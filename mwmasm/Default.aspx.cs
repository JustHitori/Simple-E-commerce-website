using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check both possible session key formats
            if (Session["CustomerId"] == null && Session["CustomerID"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadTopProducts();
            }
        }

        private void LoadUserInfo()
        {
            int customerId = 0;
            if (Session["CustomerId"] != null)
            {
                customerId = (int)Session["CustomerId"];
            }
            else if (Session["CustomerID"] != null)
            {
                customerId = (int)Session["CustomerID"];
            }

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    "SELECT fname, lname FROM dbo.tblCustomers WHERE CustomerID = @customerId";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string firstName = reader["fname"].ToString();
                            string lastName = reader["lname"].ToString();

                            Label lblUserName = FindControlRecursive(this, "lblUserName") as Label;
                            Label lblUserInitial =
                                FindControlRecursive(this, "lblUserInitial") as Label;

                            if (lblUserName != null)
                            {
                                lblUserName.Text = firstName + " " + lastName;
                            }

                            if (lblUserInitial != null)
                            {
                                lblUserInitial.Text =
                                    firstName.Length > 0 ? firstName[0].ToString().ToUpper() : "U";
                            }
                        }
                    }
                }
            }
        }

        private void LoadTopProducts()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT TOP 6
                        p.productId,
                        p.name,
                        p.price,
                        p.imageUrl,
                        ISNULL(SUM(od.quantity), 0) AS totalSales
                    FROM dbo.tblProducts p
                    LEFT JOIN dbo.tblOrderDetails od ON p.productId = od.productId
                    GROUP BY p.productId, p.name, p.price, p.imageUrl
                    ORDER BY totalSales DESC, p.productId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            ListView lvTopProducts = FindControlRecursive(this, "lvTopProducts") as ListView;
            if (lvTopProducts != null)
            {
                lvTopProducts.DataSource = dt;
                lvTopProducts.DataBind();
            }
        }

        private Control FindControlRecursive(Control root, string id)
        {
            if (root.ID == id)
                return root;

            foreach (Control c in root.Controls)
            {
                Control t = FindControlRecursive(c, id);
                if (t != null)
                    return t;
            }

            return null;
        }
    }
}

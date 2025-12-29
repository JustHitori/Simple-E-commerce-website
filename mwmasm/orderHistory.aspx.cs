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
    public partial class orderHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOngoingOrders();
                LoadHistoryOrders();
            }
        }

        private void LoadOngoingOrders()
        {
            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        od.orderdetailsId,
                        od.orderId,
                        od.productId,
                        od.quantity,
                        od.unitPrice,
                        od.subtotal,
                        p.name AS productName,
                        p.imageUrl,
                        o.orderDate
                    FROM dbo.tblOrderDetails od
                    INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                    INNER JOIN dbo.tblorders o ON od.orderId = o.orderId
                    WHERE o.customerid = @customerId
                      AND o.orderstatus NOT IN ('Completed', 'Delivered', 'Cancelled')
                    ORDER BY o.orderDate DESC, od.orderdetailsId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            lvOngoingOrders.DataSource = dt;
            lvOngoingOrders.DataBind();
        }

        private void LoadHistoryOrders()
        {
            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        od.orderdetailsId,
                        od.orderId,
                        od.productId,
                        od.quantity,
                        od.unitPrice,
                        od.subtotal,
                        p.name AS productName,
                        p.imageUrl,
                        o.orderDate
                    FROM dbo.tblOrderDetails od
                    INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                    INNER JOIN dbo.tblorders o ON od.orderId = o.orderId
                    WHERE o.customerid = @customerId
                      AND o.orderstatus IN ('Completed', 'Delivered', 'Cancelled')
                    ORDER BY o.orderDate DESC, od.orderdetailsId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            lvHistoryOrders.DataSource = dt;
            lvHistoryOrders.DataBind();
        }
    }
}

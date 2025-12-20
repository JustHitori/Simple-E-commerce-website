using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            string customerquery = "SELECT CustomerID, fname, lname, email FROM tblCustomers WHERE email = @Email AND password = @Password";
            string adminquery = "SELECT adminId, username FROM tblAdmin WHERE username= @Email AND password = @Password";

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(customerquery, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["CustomerID"] = reader["CustomerID"];
                    Session["CustomerName"] = reader["fname"];
                    Session["CustomerEmail"] = reader["email"];

                    reader.Close();
                    conn.Close();

                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    lblError.Text = "Invalid email or password.";
                }
            }

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(adminquery, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Session["AdminUsername"] = reader["username"];
                    reader.Close();
                    conn.Close();
                    Response.Redirect("~/adminDashboard.aspx");
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                }
            }
        }
    }
}
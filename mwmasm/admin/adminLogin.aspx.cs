using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm.admin
{
    public partial class adminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            string adminquery =
                "SELECT adminId, username FROM tblAdmin WHERE username = @Username AND password = @Password";

            using (SqlConnection conn = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(adminquery, conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["AdminUsername"] = reader["username"];
                    Session["AdminId"] = reader["adminId"];
                    reader.Close();
                    conn.Close();
                    Response.Redirect("~/admin/adminDashboard.aspx");
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                    reader.Close();
                    conn.Close();
                }
            }
        }
    }
}

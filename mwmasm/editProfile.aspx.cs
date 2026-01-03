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
    public partial class editProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["CustomerID"] == null && Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            int customerId = 0;
            if (Session["CustomerID"] != null)
            {
                customerId = (int)Session["CustomerID"];
            }
            else if (Session["CustomerId"] != null)
            {
                customerId = (int)Session["CustomerId"];
            }

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    "SELECT fname, lname, email, password, PhoneNumber FROM dbo.tblCustomers WHERE CustomerID = @customerId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["fname"].ToString();
                            txtLastName.Text = reader["lname"].ToString();
                            txtEmail.Text = reader["email"].ToString();
                            // Password field is intentionally left empty for security
                            txtPhoneNumber.Text =
                                reader["PhoneNumber"] != DBNull.Value
                                    ? reader["PhoneNumber"].ToString()
                                    : "";
                        }
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                int customerId = 0;
                if (Session["CustomerID"] != null)
                {
                    customerId = (int)Session["CustomerID"];
                }
                else
                {
                    Response.Redirect("~/login.aspx");
                }

                string cs = ConfigurationManager
                    .ConnectionStrings["ConnectionString"]
                    .ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    // Check if password field is empty - if so, don't update password
                    string sql;
                    if (string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        // Update without password
                        sql =
                            @"UPDATE dbo.tblCustomers 
                                SET fname = @fname, 
                                    lname = @lname, 
                                    email = @email, 
                                    PhoneNumber = @phoneNumber 
                                WHERE CustomerID = @customerId";
                    }
                    else
                    {
                        // Update with password
                        sql =
                            @"UPDATE dbo.tblCustomers 
                                SET fname = @fname, 
                                    lname = @lname, 
                                    email = @email, 
                                    password = @password, 
                                    PhoneNumber = @phoneNumber 
                                WHERE CustomerID = @customerId";
                    }

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@fname", txtFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@lname", txtLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@phoneNumber", txtPhoneNumber.Text.Trim());
                        cmd.Parameters.AddWithValue("@customerId", customerId);

                        if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                        {
                            cmd.Parameters.AddWithValue("@password", txtPassword.Text.Trim());
                        }

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update session variables
                            Session["CustomerName"] = txtFirstName.Text.Trim();
                            Session["CustomerEmail"] = txtEmail.Text.Trim();

                            lblMessage.Text = "Profile updated successfully!";
                            lblMessage.CssClass = "message-label success";

                            // Reload data to ensure consistency
                            LoadUserData();
                            // Clear password field after successful update
                            txtPassword.Text = "";
                        }
                        else
                        {
                            lblMessage.Text = "Failed to update profile. Please try again.";
                            lblMessage.CssClass = "message-label error";
                        }
                    }
                }
            }
        }
    }
}

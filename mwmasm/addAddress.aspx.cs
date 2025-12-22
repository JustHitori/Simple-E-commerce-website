using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class addAddress : System.Web.UI.Page
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
                // Set default country
                txtCountry.Text = "Malaysia";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // If this is set as default, unset other default addresses
                        if (chkIsDefault.Checked)
                        {
                            string unsetDefaultSql = @"
                                UPDATE dbo.tblUserAddresses
                                SET IsDefault = 0
                                WHERE CustomerId = @customerId";

                            using (SqlCommand cmd = new SqlCommand(unsetDefaultSql, con, tx))
                            {
                                cmd.Parameters.AddWithValue("@customerId", customerId);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // Insert new address
                        string insertSql = @"
                            INSERT INTO dbo.tblUserAddresses 
                            (CustomerId, Label, AddressLine1, AddressLine2, City, State, Postcode, Country, IsDefault)
                            VALUES 
                            (@customerId, @label, @addressLine1, @addressLine2, @city, @state, @postcode, @country, @isDefault)";

                        using (SqlCommand cmd = new SqlCommand(insertSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@customerId", customerId);
                            cmd.Parameters.AddWithValue("@label", txtLabel.Text.Trim());
                            cmd.Parameters.AddWithValue("@addressLine1", txtAddressLine1.Text.Trim());
                            
                            // AddressLine2 is optional
                            if (!string.IsNullOrWhiteSpace(txtAddressLine2.Text))
                            {
                                cmd.Parameters.AddWithValue("@addressLine2", txtAddressLine2.Text.Trim());
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("@addressLine2", DBNull.Value);
                            }
                            
                            cmd.Parameters.AddWithValue("@city", txtCity.Text.Trim());
                            cmd.Parameters.AddWithValue("@state", txtState.Text.Trim());
                            cmd.Parameters.AddWithValue("@postcode", txtPostcode.Text.Trim());
                            cmd.Parameters.AddWithValue("@country", txtCountry.Text.Trim());
                            cmd.Parameters.AddWithValue("@isDefault", chkIsDefault.Checked);

                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();

                        // Redirect back to payment page with reload flag
                        Response.Redirect("~/payment.aspx?reload=true");
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        lblError.Text = "An error occurred while adding the address. Please try again.";
                        lblError.Visible = true;
                        System.Diagnostics.Debug.WriteLine("Add address error: " + ex.Message);
                    }
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Redirect back to payment page
            Response.Redirect("~/payment.aspx");
        }
    }
}

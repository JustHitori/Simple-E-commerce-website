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
    public partial class manageAddress : System.Web.UI.Page
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
                LoadAddresses();
            }
        }

        private void LoadAddresses()
        {
            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT AddressId, CustomerId, Label, AddressLine1, AddressLine2, City, State, Postcode, Country, IsDefault
                    FROM dbo.tblUserAddresses
                    WHERE CustomerId = @customerId
                    ORDER BY IsDefault DESC, AddressId DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            // Add FullAddress column to DataTable schema
            dt.Columns.Add("FullAddress", typeof(string));

            // Add formatted address to each row
            foreach (DataRow row in dt.Rows)
            {
                string fullAddress = FormatAddressForDisplay(row);
                row["FullAddress"] = fullAddress;
            }

            rptAddresses.DataSource = dt;
            rptAddresses.DataBind();
        }

        private string FormatAddressForDisplay(DataRow row)
        {
            string addressLine1 = row["AddressLine1"].ToString();
            string addressLine2 =
                row["AddressLine2"] != DBNull.Value ? row["AddressLine2"].ToString() : "";
            string city = row["City"].ToString();
            string state = row["State"].ToString();
            string postcode = row["Postcode"].ToString();
            string country = row["Country"].ToString();

            string fullAddress = addressLine1;
            if (!string.IsNullOrEmpty(addressLine2))
                fullAddress += ", " + addressLine2;
            fullAddress += ", " + city + ", " + state + " " + postcode + ", " + country;

            return fullAddress;
        }

        protected void rptAddresses_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // No special handling needed, data binding handles it
        }

        protected void rptAddresses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Update")
            {
                UpdateAddress(e);
            }
        }

        private void UpdateAddress(RepeaterCommandEventArgs e)
        {
            int addressId = int.Parse(e.CommandArgument.ToString());
            RepeaterItem item = e.Item;

            TextBox txtLabel = (TextBox)item.FindControl("txtLabel");
            TextBox txtAddressLine1 = (TextBox)item.FindControl("txtAddressLine1");
            TextBox txtAddressLine2 = (TextBox)item.FindControl("txtAddressLine2");
            TextBox txtCity = (TextBox)item.FindControl("txtCity");
            TextBox txtState = (TextBox)item.FindControl("txtState");
            TextBox txtPostcode = (TextBox)item.FindControl("txtPostcode");
            TextBox txtCountry = (TextBox)item.FindControl("txtCountry");
            CheckBox chkIsDefault = (CheckBox)item.FindControl("chkIsDefault");

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
                            string unsetDefaultSql =
                                @"
                                UPDATE dbo.tblUserAddresses
                                SET IsDefault = 0
                                WHERE CustomerId = @customerId AND AddressId != @addressId";

                            using (SqlCommand cmd = new SqlCommand(unsetDefaultSql, con, tx))
                            {
                                cmd.Parameters.AddWithValue("@customerId", customerId);
                                cmd.Parameters.AddWithValue("@addressId", addressId);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // Update address
                        string updateSql =
                            @"
                            UPDATE dbo.tblUserAddresses 
                            SET Label = @label, 
                                AddressLine1 = @addressLine1, 
                                AddressLine2 = @addressLine2, 
                                City = @city, 
                                State = @state, 
                                Postcode = @postcode, 
                                Country = @country, 
                                IsDefault = @isDefault
                            WHERE AddressId = @addressId AND CustomerId = @customerId";

                        using (SqlCommand cmd = new SqlCommand(updateSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@addressId", addressId);
                            cmd.Parameters.AddWithValue("@customerId", customerId);
                            cmd.Parameters.AddWithValue("@label", txtLabel.Text.Trim());
                            cmd.Parameters.AddWithValue(
                                "@addressLine1",
                                txtAddressLine1.Text.Trim()
                            );

                            if (!string.IsNullOrWhiteSpace(txtAddressLine2.Text))
                            {
                                cmd.Parameters.AddWithValue(
                                    "@addressLine2",
                                    txtAddressLine2.Text.Trim()
                                );
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
                        Response.Redirect("~/payment.aspx");
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        lblError.Text =
                            "An error occurred while updating the address. Please try again.";
                        lblError.Visible = true;
                        lblSuccess.Visible = false;
                        System.Diagnostics.Debug.WriteLine("Update address error: " + ex.Message);
                    }
                }
            }

            LoadAddresses();
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            // Get the address ID from the hidden field
            if (string.IsNullOrEmpty(hidAddressIdToDelete.Value))
            {
                lblError.Text = "No address selected for deletion.";
                lblError.Visible = true;
                return;
            }

            int addressId;
            if (!int.TryParse(hidAddressIdToDelete.Value, out addressId))
            {
                lblError.Text = "Invalid address ID.";
                lblError.Visible = true;
                return;
            }

            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string deleteSql =
                    @"
                    DELETE FROM dbo.tblUserAddresses
                    WHERE AddressId = @addressId AND CustomerId = @customerId";

                using (SqlCommand cmd = new SqlCommand(deleteSql, con))
                {
                    cmd.Parameters.AddWithValue("@addressId", addressId);
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();

                    if (rowsAffected > 0)
                    {
                        lblSuccess.Text = "Address deleted successfully.";
                        lblSuccess.Visible = true;
                        lblError.Visible = false;
                    }
                    else
                    {
                        lblError.Text = "Address not found or could not be deleted.";
                        lblError.Visible = true;
                        lblSuccess.Visible = false;
                    }
                }
            }

            // Clear the hidden field
            hidAddressIdToDelete.Value = "";

            // Reload addresses
            LoadAddresses();
        }

        protected void btnShowAddForm_Click(object sender, EventArgs e)
        {
            pnlAddAddress.Visible = true;
            btnShowAddForm.Visible = false;
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            pnlAddAddress.Visible = false;
            btnShowAddForm.Visible = true;
            txtNewLabel.Text = "";
            txtNewAddressLine1.Text = "";
            txtNewAddressLine2.Text = "";
            txtNewCity.Text = "";
            txtNewState.Text = "";
            txtNewPostcode.Text = "";
            txtNewCountry.Text = "Malaysia";
            chkNewIsDefault.Checked = false;
        }

        protected void btnAddNew_Click(object sender, EventArgs e)
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
                        if (chkNewIsDefault.Checked)
                        {
                            string unsetDefaultSql =
                                @"
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
                        string insertSql =
                            @"
                            INSERT INTO dbo.tblUserAddresses 
                            (CustomerId, Label, AddressLine1, AddressLine2, City, State, Postcode, Country, IsDefault)
                            VALUES 
                            (@customerId, @label, @addressLine1, @addressLine2, @city, @state, @postcode, @country, @isDefault)";

                        using (SqlCommand cmd = new SqlCommand(insertSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@customerId", customerId);
                            cmd.Parameters.AddWithValue("@label", txtNewLabel.Text.Trim());
                            cmd.Parameters.AddWithValue(
                                "@addressLine1",
                                txtNewAddressLine1.Text.Trim()
                            );

                            if (!string.IsNullOrWhiteSpace(txtNewAddressLine2.Text))
                            {
                                cmd.Parameters.AddWithValue(
                                    "@addressLine2",
                                    txtNewAddressLine2.Text.Trim()
                                );
                            }
                            else
                            {
                                cmd.Parameters.AddWithValue("@addressLine2", DBNull.Value);
                            }

                            cmd.Parameters.AddWithValue("@city", txtNewCity.Text.Trim());
                            cmd.Parameters.AddWithValue("@state", txtNewState.Text.Trim());
                            cmd.Parameters.AddWithValue("@postcode", txtNewPostcode.Text.Trim());
                            cmd.Parameters.AddWithValue("@country", txtNewCountry.Text.Trim());
                            cmd.Parameters.AddWithValue("@isDefault", chkNewIsDefault.Checked);

                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        lblSuccess.Text = "Address added successfully.";
                        lblSuccess.Visible = true;
                        lblError.Visible = false;

                        // Hide form and show button again
                        pnlAddAddress.Visible = false;
                        btnShowAddForm.Visible = true;

                        // Clear form fields
                        txtNewLabel.Text = "";
                        txtNewAddressLine1.Text = "";
                        txtNewAddressLine2.Text = "";
                        txtNewCity.Text = "";
                        txtNewState.Text = "";
                        txtNewPostcode.Text = "";
                        txtNewCountry.Text = "Malaysia";
                        chkNewIsDefault.Checked = false;
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        lblError.Text =
                            "An error occurred while adding the address. Please try again.";
                        lblError.Visible = true;
                        lblSuccess.Visible = false;
                        System.Diagnostics.Debug.WriteLine("Add address error: " + ex.Message);
                    }
                }
            }

            LoadAddresses();
        }
    }
}

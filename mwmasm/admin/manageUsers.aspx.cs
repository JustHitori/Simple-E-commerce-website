using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm.admin
{
    public partial class manageUsers : System.Web.UI.Page
    {
        private string cs = ConfigurationManager
            .ConnectionStrings["ConnectionString"]
            .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize search fields
                ddlSearchColumn.SelectedValue = "";
                txtSearch.Text = "";
                ddlSortBy.SelectedValue = "CustomerID";
                ViewState["SortDirection"] = "DESC";
                btnSortDirection.Text = "↓ Desc";
            }
        }

        protected void btnAddAdminConfirm_Click(object sender, EventArgs e)
        {
            Page.Validate("AddAdmin");
            if (!Page.IsValid)
                return;

            string username = txtAdminUsername.Text.Trim();
            string password = txtAdminPassword.Text.Trim();

            // Check if username already exists
            using (SqlConnection conn = new SqlConnection(cs))
            {
                string checkQuery = "SELECT COUNT(*) FROM dbo.tblAdmin WHERE username = @username";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@username", username);
                    conn.Open();
                    int count = (int)checkCmd.ExecuteScalar();
                    conn.Close();

                    if (count > 0)
                    {
                        lblAdminStatus.Text =
                            "Username already exists. Please choose a different username.";
                        lblAdminStatus.CssClass = "text-danger";
                        return;
                    }
                }
            }

            // Insert new admin
            using (SqlConnection conn = new SqlConnection(cs))
            {
                string insertQuery =
                    "INSERT INTO dbo.tblAdmin (username, password) VALUES (@username, @password)";
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@password", password);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            // Clear form and refresh grid
            txtAdminUsername.Text = "";
            txtAdminPassword.Text = "";
            gvAdmins.DataBind();

            lblAdminStatus.Text = "Admin added successfully.";
            lblAdminStatus.CssClass = "text-success";
            string js =
                $"setTimeout(function(){{var el=document.getElementById('{lblAdminStatus.ClientID}');"
                + "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }"
                + "}, 3000);";
            ScriptManager.RegisterStartupScript(this, GetType(), "hideAdminStatusMsg", js, true);
        }

        protected void gvAdmins_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Cancel the default update since we're handling it manually
            e.Cancel = true;

            int adminId = (int)gvAdmins.DataKeys[e.RowIndex].Value;
            string newUsername = e.NewValues["username"]?.ToString() ?? "";

            // Get password from the edit template
            GridViewRow row = gvAdmins.Rows[e.RowIndex];
            TextBox txtPassword = row.FindControl("txtPassword") as TextBox;
            string newPassword = txtPassword?.Text ?? "";

            using (SqlConnection conn = new SqlConnection(cs))
            {
                // Check if username already exists (excluding current admin)
                string checkQuery =
                    "SELECT COUNT(*) FROM dbo.tblAdmin WHERE username = @username AND adminId != @adminId";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@username", newUsername);
                    checkCmd.Parameters.AddWithValue("@adminId", adminId);
                    conn.Open();
                    int count = (int)checkCmd.ExecuteScalar();
                    conn.Close();

                    if (count > 0)
                    {
                        lblAdminStatus.Text =
                            "Username already exists. Please choose a different username.";
                        lblAdminStatus.CssClass = "text-danger";
                        return;
                    }
                }

                // Update admin
                string updateQuery;
                if (string.IsNullOrWhiteSpace(newPassword))
                {
                    // Update only username
                    updateQuery =
                        "UPDATE dbo.tblAdmin SET username = @username WHERE adminId = @adminId";
                }
                else
                {
                    // Update both username and password
                    updateQuery =
                        "UPDATE dbo.tblAdmin SET username = @username, password = @password WHERE adminId = @adminId";
                }

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@username", newUsername);
                    cmd.Parameters.AddWithValue("@adminId", adminId);
                    if (!string.IsNullOrWhiteSpace(newPassword))
                    {
                        cmd.Parameters.AddWithValue("@password", newPassword);
                    }
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            // Exit edit mode and refresh
            gvAdmins.EditIndex = -1;
            gvAdmins.DataBind();
            lblAdminStatus.Text = "Admin updated successfully.";
            lblAdminStatus.CssClass = "text-success";
            string js =
                $"setTimeout(function(){{var el=document.getElementById('{lblAdminStatus.ClientID}');"
                + "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }"
                + "}, 3000);";
            ScriptManager.RegisterStartupScript(this, GetType(), "hideAdminStatusMsg", js, true);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(ddlSearchColumn.SelectedValue))
            {
                lblCustomerStatus.Text = "Please select a column to search by.";
                lblCustomerStatus.CssClass = "text-danger";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtSearch.Text.Trim()))
            {
                lblCustomerStatus.Text = "Please enter a search term.";
                lblCustomerStatus.CssClass = "text-danger";
                return;
            }

            gvCustomers.DataBind();
            lblCustomerStatus.Text = "Search completed.";
            lblCustomerStatus.CssClass = "text-success";
            string js =
                $"setTimeout(function(){{var el=document.getElementById('{lblCustomerStatus.ClientID}');"
                + "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }"
                + "}, 3000);";
            ScriptManager.RegisterStartupScript(this, GetType(), "hideCustomerStatusMsg", js, true);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlSearchColumn.SelectedValue = "";
            txtSearch.Text = "";
            ddlSortBy.SelectedValue = "CustomerID";
            ViewState["SortDirection"] = "DESC";
            btnSortDirection.Text = "↓ Desc";
            gvCustomers.DataBind();
            lblCustomerStatus.Text = "";
        }

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvCustomers.DataBind();
        }

        protected void btnSortDirection_Click(object sender, EventArgs e)
        {
            string currentDirection = ViewState["SortDirection"]?.ToString() ?? "DESC";
            if (currentDirection == "DESC")
            {
                ViewState["SortDirection"] = "ASC";
                btnSortDirection.Text = "↑ Asc";
            }
            else
            {
                ViewState["SortDirection"] = "DESC";
                btnSortDirection.Text = "↓ Desc";
            }
            gvCustomers.DataBind();
        }

        protected void SqlDsCustomers_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            string searchColumn = ddlSearchColumn.SelectedValue;
            string searchValue = txtSearch.Text.Trim();
            string sortBy = ddlSortBy.SelectedValue;

            // Build WHERE clause if search criteria provided
            string whereClause = "";
            if (!string.IsNullOrWhiteSpace(searchColumn) && !string.IsNullOrWhiteSpace(searchValue))
            {
                switch (searchColumn)
                {
                    case "CustomerID":
                        whereClause = "WHERE CAST(CustomerID AS VARCHAR) LIKE @searchValue";
                        break;
                    case "fname":
                        whereClause = "WHERE fname LIKE @searchValue";
                        break;
                    case "lname":
                        whereClause = "WHERE lname LIKE @searchValue";
                        break;
                    case "email":
                        whereClause = "WHERE email LIKE @searchValue";
                        break;
                    case "PhoneNumber":
                        whereClause = "WHERE PhoneNumber LIKE @searchValue";
                        break;
                }
            }

            // Get sort direction from ViewState (default to DESC)
            string sortDirection = ViewState["SortDirection"]?.ToString() ?? "DESC";

            // Build ORDER BY clause
            string orderByClause = "ORDER BY " + sortBy + " " + sortDirection;

            // Build final query
            string query =
                "SELECT CustomerID, fname, lname, email, PhoneNumber, dtRegistered FROM dbo.tblCustomers "
                + whereClause
                + " "
                + orderByClause;

            e.Command.CommandText = query;

            // Add search parameter if needed
            if (!string.IsNullOrEmpty(whereClause))
            {
                ((SqlCommand)e.Command).Parameters.AddWithValue(
                    "@searchValue",
                    "%" + searchValue + "%"
                );
            }
        }
    }
}

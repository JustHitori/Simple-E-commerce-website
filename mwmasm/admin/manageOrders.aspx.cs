using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm.admin
{
    public partial class manageOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatusCounts();
                LoadProcessingOrders();
                LoadProcessedOrders();
                LoadCancelledOrders();
            }
        }

        private void LoadStatusCounts()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        SUM(CASE WHEN orderstatus = 'Pending' THEN 1 ELSE 0 END) AS PendingCount,
                        SUM(CASE WHEN orderstatus = 'Sent out for delivery' THEN 1 ELSE 0 END) AS SentOutCount,
                        SUM(CASE WHEN orderstatus = 'Delivered' THEN 1 ELSE 0 END) AS DeliveredCount,
                        SUM(CASE WHEN orderstatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedCount,
                        SUM(CASE WHEN orderstatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledCount
                    FROM dbo.tblorders";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int pendingCount =
                                reader["PendingCount"] != DBNull.Value
                                    ? Convert.ToInt32(reader["PendingCount"])
                                    : 0;
                            int sentOutCount =
                                reader["SentOutCount"] != DBNull.Value
                                    ? Convert.ToInt32(reader["SentOutCount"])
                                    : 0;
                            int deliveredCount =
                                reader["DeliveredCount"] != DBNull.Value
                                    ? Convert.ToInt32(reader["DeliveredCount"])
                                    : 0;
                            int completedCount =
                                reader["CompletedCount"] != DBNull.Value
                                    ? Convert.ToInt32(reader["CompletedCount"])
                                    : 0;
                            int cancelledCount =
                                reader["CancelledCount"] != DBNull.Value
                                    ? Convert.ToInt32(reader["CancelledCount"])
                                    : 0;

                            lblStatusCounts.Text =
                                $"Pending {pendingCount} | Sent out for delivery {sentOutCount} | Delivered {deliveredCount} | Completed {completedCount} | Cancelled {cancelledCount}";
                        }
                    }
                }
            }
        }

        private void LoadProcessingOrders()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        o.orderId,
                        o.customerid,
                        CONCAT(c.fname, ' ', c.lname) AS customerName,
                        o.orderDate,
                        o.totalAmount,
                        o.shippingAddress,
                        o.paymentMethod,
                        o.paymentStatus,
                        o.orderStatus,
                        (SELECT TOP 1 p.name 
                         FROM dbo.tblOrderDetails od
                         INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                         WHERE od.orderId = o.orderId
                         ORDER BY od.orderdetailsId) AS productName
                    FROM dbo.tblorders o
                    INNER JOIN dbo.tblCustomers c ON o.customerid = c.CustomerID
                    WHERE o.orderstatus IN ('Pending', 'Sent out for delivery', 'Delivered')
                    ORDER BY o.orderDate DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            gvProcessingOrders.DataSource = dt;
            gvProcessingOrders.DataBind();
        }

        private void LoadProcessedOrders()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        o.orderId,
                        o.customerid,
                        CONCAT(c.fname, ' ', c.lname) AS customerName,
                        o.orderDate,
                        o.totalAmount,
                        o.shippingAddress,
                        o.paymentMethod,
                        o.paymentStatus,
                        o.orderStatus,
                        (SELECT TOP 1 p.name 
                         FROM dbo.tblOrderDetails od
                         INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                         WHERE od.orderId = o.orderId
                         ORDER BY od.orderdetailsId) AS productName
                    FROM dbo.tblorders o
                    INNER JOIN dbo.tblCustomers c ON o.customerid = c.CustomerID
                    WHERE o.orderstatus = 'Completed'
                    ORDER BY o.orderDate DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            gvProcessedOrders.DataSource = dt;
            gvProcessedOrders.DataBind();
        }

        private void LoadCancelledOrders()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    SELECT 
                        o.orderId,
                        o.customerid,
                        CONCAT(c.fname, ' ', c.lname) AS customerName,
                        o.orderDate,
                        o.totalAmount,
                        o.shippingAddress,
                        o.paymentMethod,
                        o.paymentStatus,
                        o.orderStatus,
                        (SELECT TOP 1 p.name 
                         FROM dbo.tblOrderDetails od
                         INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                         WHERE od.orderId = o.orderId
                         ORDER BY od.orderdetailsId) AS productName
                    FROM dbo.tblorders o
                    INNER JOIN dbo.tblCustomers c ON o.customerid = c.CustomerID
                    WHERE o.orderstatus = 'Cancelled'
                    ORDER BY o.orderDate DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            gvCancelledOrders.DataSource = dt;
            gvCancelledOrders.DataBind();
        }

        protected void ddlOrderStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl.NamingContainer;

            if (row != null && row.RowIndex >= 0)
            {
                GridView gv = (GridView)row.NamingContainer;
                int orderId = Convert.ToInt32(gv.DataKeys[row.RowIndex].Value);
                string newStatus = ddl.SelectedValue;

                UpdateOrderStatus(orderId, newStatus);
                LoadStatusCounts();
                LoadProcessingOrders();
                LoadProcessedOrders();
                LoadCancelledOrders();
            }
        }

        protected void btnSettle_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int orderId = Convert.ToInt32(btn.CommandArgument);

            // Settle order by setting status to "Completed"
            UpdateOrderStatus(orderId, "Completed");
            LoadStatusCounts();
            LoadProcessingOrders();
            LoadProcessedOrders();
            LoadCancelledOrders();
        }

        private void UpdateOrderStatus(int orderId, string newStatus)
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    UPDATE dbo.tblorders
                    SET orderstatus = @orderStatus
                    WHERE orderId = @orderId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    cmd.Parameters.AddWithValue("@orderStatus", newStatus);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblStatus.Text = $"Order #{orderId} status updated to {newStatus} successfully.";
            lblStatus.Visible = true;
            lblError.Visible = false;

            // Hide status and error messages after 3 seconds
            HideStatusMessages();
        }

        protected void gvProcessingOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                string orderStatus = rowView["orderStatus"].ToString();

                // Get segment controls
                System.Web.UI.HtmlControls.HtmlGenericControl segPending =
                    FindControlRecursive(e.Row, "segmentPending")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;
                System.Web.UI.HtmlControls.HtmlGenericControl segSentOut =
                    FindControlRecursive(e.Row, "segmentSentOut")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;
                System.Web.UI.HtmlControls.HtmlGenericControl segDelivered =
                    FindControlRecursive(e.Row, "segmentDelivered")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;

                // Reset all segments to inactive (light gray)
                if (segPending != null)
                    segPending.Attributes["class"] = "progress-segment-small";
                if (segSentOut != null)
                    segSentOut.Attributes["class"] = "progress-segment-small";
                if (segDelivered != null)
                    segDelivered.Attributes["class"] = "progress-segment-small";

                // Set active segment based on status
                string statusLower = orderStatus.ToLower();
                switch (statusLower)
                {
                    case "pending":
                        if (segPending != null)
                            segPending.Attributes["class"] = "progress-segment-small active";
                        break;
                    case "sent out for delivery":
                        if (segSentOut != null)
                            segSentOut.Attributes["class"] = "progress-segment-small active";
                        break;
                    case "delivered":
                        if (segDelivered != null)
                            segDelivered.Attributes["class"] = "progress-segment-small active";
                        break;
                }

                // Set active label
                System.Web.UI.HtmlControls.HtmlGenericControl labelPending =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelPending");
                System.Web.UI.HtmlControls.HtmlGenericControl labelSentOut =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelSentOut");
                System.Web.UI.HtmlControls.HtmlGenericControl labelDelivered =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelDelivered");

                if (labelPending != null)
                    labelPending.Attributes["class"] = "progress-label-small";
                if (labelSentOut != null)
                    labelSentOut.Attributes["class"] = "progress-label-small";
                if (labelDelivered != null)
                    labelDelivered.Attributes["class"] = "progress-label-small";

                // Set active label based on status
                if (statusLower == "pending" && labelPending != null)
                    labelPending.Attributes["class"] = "progress-label-small active";
                else if (statusLower == "sent out for delivery" && labelSentOut != null)
                    labelSentOut.Attributes["class"] = "progress-label-small active";
                else if (statusLower == "delivered" && labelDelivered != null)
                    labelDelivered.Attributes["class"] = "progress-label-small active";

                // Set Settle button visibility
                Button btnSettle = (Button)e.Row.FindControl("btnSettle");
                if (btnSettle != null)
                {
                    btnSettle.Visible = !IsOrderSettled(orderStatus);
                }
            }
        }

        protected void gvProcessedOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                string orderStatus = rowView["orderStatus"].ToString();

                // Get segment controls
                System.Web.UI.HtmlControls.HtmlGenericControl segPending =
                    FindControlRecursive(e.Row, "segmentPending")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;
                System.Web.UI.HtmlControls.HtmlGenericControl segSentOut =
                    FindControlRecursive(e.Row, "segmentSentOut")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;
                System.Web.UI.HtmlControls.HtmlGenericControl segDelivered =
                    FindControlRecursive(e.Row, "segmentDelivered")
                    as System.Web.UI.HtmlControls.HtmlGenericControl;

                // Reset all segments to inactive (light gray)
                if (segPending != null)
                    segPending.Attributes["class"] = "progress-segment-small";
                if (segSentOut != null)
                    segSentOut.Attributes["class"] = "progress-segment-small";
                if (segDelivered != null)
                    segDelivered.Attributes["class"] = "progress-segment-small";

                // Set active segment for completed orders
                if (orderStatus.ToLower() == "completed" && segDelivered != null)
                    segDelivered.Attributes["class"] = "progress-segment-small active";

                // Set active label
                System.Web.UI.HtmlControls.HtmlGenericControl labelPending =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelPending");
                System.Web.UI.HtmlControls.HtmlGenericControl labelSentOut =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelSentOut");
                System.Web.UI.HtmlControls.HtmlGenericControl labelDelivered =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)
                        e.Row.FindControl("labelDelivered");

                if (labelPending != null)
                    labelPending.Attributes["class"] = "progress-label-small";
                if (labelSentOut != null)
                    labelSentOut.Attributes["class"] = "progress-label-small";
                if (labelDelivered != null)
                    labelDelivered.Attributes["class"] = "progress-label-small active";
            }
        }

        protected void gvCancelledOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Cancelled orders don't need progress bars, so this method is intentionally left empty
            // but kept for consistency and potential future use
        }

        private bool IsOrderSettled(string orderStatus)
        {
            // Only Completed and Cancelled orders are settled
            // Delivered orders still need the Settle button to be pressed
            return orderStatus == "Completed" || orderStatus == "Cancelled";
        }

        private Control FindControlRecursive(Control root, string id)
        {
            if (root == null)
                return null;
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

        private void HideStatusMessages()
        {
            // Hide status and error messages after 3 seconds
            string script =
                @"
                setTimeout(function() {
                    var lblStatus = document.getElementById('"
                + lblStatus.ClientID
                + @"');
                    var lblError = document.getElementById('"
                + lblError.ClientID
                + @"');
                    if (lblStatus) lblStatus.style.display = 'none';
                    if (lblError) lblError.style.display = 'none';
                }, 3000);";
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "HideStatusMessages",
                script,
                true
            );
        }
    }
}

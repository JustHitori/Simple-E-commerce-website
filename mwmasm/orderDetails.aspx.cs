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
    public partial class orderDetails : System.Web.UI.Page
    {
        private int _currentOrderId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string orderIdParam = Request.QueryString["orderId"];
                if (string.IsNullOrEmpty(orderIdParam))
                {
                    lblError.Text = "Order ID is required.";
                    lblError.Visible = true;
                    return;
                }

                int orderId;
                if (!int.TryParse(orderIdParam, out orderId))
                {
                    lblError.Text = "Invalid order ID.";
                    lblError.Visible = true;
                    return;
                }

                int customerId = (int)Session["CustomerId"];
                _currentOrderId = orderId;
                ViewState["OrderId"] = orderId;
                LoadOrderDetails(orderId, customerId);
            }
        }

        private void LoadOrderDetails(int orderId, int customerId)
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get order information
                string orderSql =
                    @"
                    SELECT o.orderId, o.orderdate, o.totalamount, o.shippingaddress, 
                           o.orderstatus, o.paymentmethod, c.PhoneNumber
                    FROM dbo.tblorders o
                    INNER JOIN dbo.tblCustomers c ON o.customerid = c.CustomerID
                    WHERE o.orderId = @orderId AND o.customerid = @customerId";

                using (SqlCommand cmd = new SqlCommand(orderSql, con))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    cmd.Parameters.AddWithValue("@customerId", customerId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            lblError.Text =
                                "Order not found or you don't have permission to view this order.";
                            lblError.Visible = true;
                            return;
                        }

                        // Set order information
                        string orderStatus = reader["orderstatus"].ToString();
                        string shippingAddress = reader["shippingaddress"].ToString();
                        decimal totalAmount = Convert.ToDecimal(reader["totalamount"]);
                        DateTime orderDate = Convert.ToDateTime(reader["orderdate"]);
                        string phoneNumber =
                            reader["PhoneNumber"] != DBNull.Value
                                ? reader["PhoneNumber"].ToString()
                                : "N/A";

                        // Set progress bar based on order status
                        SetProgressBar(orderStatus);

                        // Set cancel button visibility based on order status
                        SetCancelButtonVisibility(orderStatus);

                        // Set address information
                        // Extract address label from shipping address (first part before comma)
                        string[] addressParts = shippingAddress.Split(',');
                        string addressLabel =
                            addressParts.Length > 0 ? addressParts[0].Trim() : shippingAddress;
                        lblAddressLabel.Text = addressLabel;
                        lblShippingAddress.Text = shippingAddress;
                        lblPhoneNumber.Text = phoneNumber;

                        reader.Close();
                    }
                }

                // Get order items
                string itemsSql =
                    @"
                    SELECT od.orderdetailsId, od.orderId, od.productId, od.quantity, 
                           od.unitPrice, od.subtotal,
                           p.name AS productName, p.imageUrl,
                           c.name AS categoryName,
                           o.orderdate
                    FROM dbo.tblOrderDetails od
                    INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                    INNER JOIN dbo.tblCategories c ON p.categoryId = c.categoryId
                    INNER JOIN dbo.tblorders o ON od.orderId = o.orderId
                    WHERE od.orderId = @orderId
                    ORDER BY od.orderdetailsId";

                DataTable dt = new DataTable();
                using (SqlCommand cmd = new SqlCommand(itemsSql, con))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    lvOrderItems.DataSource = dt;
                    lvOrderItems.DataBind();

                    // Calculate totals
                    decimal subtotal = 0m;
                    int totalQuantity = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        subtotal += Convert.ToDecimal(row["subtotal"]);
                        totalQuantity += Convert.ToInt32(row["quantity"]);
                    }

                    // Get total amount from order
                    string totalSql =
                        "SELECT totalamount FROM dbo.tblorders WHERE orderId = @orderId";
                    decimal totalAmount = 0m;
                    using (SqlCommand cmd = new SqlCommand(totalSql, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            totalAmount = Convert.ToDecimal(result);
                        }
                    }

                    decimal shippingFee = totalAmount - subtotal;

                    // Display totals
                    lblTotalQuantity.Text = totalQuantity.ToString();
                    lblSubtotal.Text = "RM " + subtotal.ToString("N2");
                    lblShippingFee.Text = "RM " + shippingFee.ToString("N2");
                    lblTotal.Text = "RM " + totalAmount.ToString("N2");
                }
                else
                {
                    lblError.Text = "No items found in this order.";
                    lblError.Visible = true;
                }

                con.Close();
            }
        }

        private void SetProgressBar(string orderStatus)
        {
            // Get segment controls - search recursively in the page
            System.Web.UI.HtmlControls.HtmlGenericControl segPending =
                FindControlRecursive(Page, "segmentPending")
                as System.Web.UI.HtmlControls.HtmlGenericControl;
            System.Web.UI.HtmlControls.HtmlGenericControl segSentOut =
                FindControlRecursive(Page, "segmentSentOut")
                as System.Web.UI.HtmlControls.HtmlGenericControl;
            System.Web.UI.HtmlControls.HtmlGenericControl segDelivered =
                FindControlRecursive(Page, "segmentDelivered")
                as System.Web.UI.HtmlControls.HtmlGenericControl;

            // Reset all segments to inactive (light gray)
            if (segPending != null)
                segPending.Attributes["class"] = "progress-segment";
            if (segSentOut != null)
                segSentOut.Attributes["class"] = "progress-segment";
            if (segDelivered != null)
                segDelivered.Attributes["class"] = "progress-segment";

            // Reset all labels to inactive (they remain visible, just gray)
            labelPending.CssClass = "progress-label";
            labelSentOut.CssClass = "progress-label";
            labelDelivered.CssClass = "progress-label";

            string statusLower = orderStatus.Trim().ToLower();

            switch (statusLower)
            {
                case "pending":
                    // Only current step (pending) is active
                    if (segPending != null)
                        segPending.Attributes["class"] = "progress-segment active";
                    labelPending.CssClass = "progress-label active";
                    break;
                case "sent out for delivery":
                    // Only current step (sent out) is active, pending becomes inactive
                    if (segSentOut != null)
                        segSentOut.Attributes["class"] = "progress-segment active";
                    labelSentOut.CssClass = "progress-label active";
                    break;
                case "delivered":
                case "completed":
                    // Only current step (delivered) is active, previous steps are inactive
                    if (segDelivered != null)
                        segDelivered.Attributes["class"] = "progress-segment active";
                    labelDelivered.CssClass = "progress-label active";
                    break;
                default:
                    if (segPending != null)
                        segPending.Attributes["class"] = "progress-segment active";
                    labelPending.CssClass = "progress-label active";
                    break;
            }
        }

        private void SetCancelButtonVisibility(string orderStatus)
        {
            string statusLower = orderStatus.Trim().ToLower();

            // Show cancel button only for Pending, Sent out for delivery, or Delivered
            // Hide for Completed or Cancelled
            if (
                statusLower == "pending"
                || statusLower == "sent out for delivery"
                || statusLower == "delivered"
            )
            {
                btnCancelOrder.Visible = true;
            }
            else
            {
                btnCancelOrder.Visible = false;
            }
        }

        protected void btnCancelOrder_Click(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            int orderId;
            if (ViewState["OrderId"] != null)
            {
                orderId = (int)ViewState["OrderId"];
            }
            else
            {
                string orderIdParam = Request.QueryString["orderId"];
                if (string.IsNullOrEmpty(orderIdParam) || !int.TryParse(orderIdParam, out orderId))
                {
                    lblError.Text = "Invalid order ID.";
                    lblError.Visible = true;
                    return;
                }
            }

            int customerId = (int)Session["CustomerId"];

            // Update order status to Cancelled
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql =
                    @"
                    UPDATE dbo.tblorders
                    SET orderstatus = @orderStatus
                    WHERE orderId = @orderId AND customerid = @customerId";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@orderId", orderId);
                    cmd.Parameters.AddWithValue("@orderStatus", "Cancelled");
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();

                    if (rowsAffected > 0)
                    {
                        // Reload the page to reflect the updated status
                        Response.Redirect("~/orderDetails.aspx?orderId=" + orderId);
                    }
                    else
                    {
                        lblError.Text =
                            "Failed to cancel order. Order not found or you don't have permission.";
                        lblError.Visible = true;
                    }
                }
            }
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
    }
}

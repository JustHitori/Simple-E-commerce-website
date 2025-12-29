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
    public partial class payment : System.Web.UI.Page
    {
        private decimal _subtotal = 0m;
        private decimal _deliveryFee = 10m;
        private decimal _total = 0m;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            // Check if there are selected cart items
            if (Session["SelectedCartItems"] == null)
            {
                Response.Redirect("~/shoppingCart.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAddresses();
                LoadOrderDetails();
                LoadOrderSummary();
            }
            else
            {
                // On postback, preserve selected address
                // Get selected address from hidden field (set by JavaScript)
                if (!string.IsNullOrEmpty(hidSelectedAddressId.Value))
                {
                    int addressId;
                    if (int.TryParse(hidSelectedAddressId.Value, out addressId))
                    {
                        ViewState["SelectedAddressId"] = addressId;
                    }
                }

                // Only reload addresses if coming from addAddress page
                if (Request.QueryString["reload"] == "true")
                {
                    LoadAddresses();
                }
                else
                {
                    // On normal postback, reload addresses but preserve selection
                    // Selection will be restored in ItemDataBound from ViewState
                    LoadAddresses();
                }
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

            if (dt.Rows.Count > 0)
            {
                pnlAddressList.Visible = true;
                pnlNoAddress.Visible = false;
                btnEditAddress.Visible = true;

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
            else
            {
                pnlAddressList.Visible = false;
                pnlNoAddress.Visible = true;
                btnEditAddress.Visible = false;
            }
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
            if (
                e.Item.ItemType == ListItemType.Item
                || e.Item.ItemType == ListItemType.AlternatingItem
            )
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                RadioButton rbAddress = (RadioButton)e.Item.FindControl("rbAddress");
                HiddenField hidAddressId = (HiddenField)e.Item.FindControl("hidAddressId");

                if (rbAddress != null && hidAddressId != null)
                {
                    int addressId = int.Parse(hidAddressId.Value);

                    // On postback, restore selected address from ViewState or hidden field
                    if (IsPostBack)
                    {
                        int selectedAddressId = 0;

                        // First try ViewState
                        if (ViewState["SelectedAddressId"] != null)
                        {
                            selectedAddressId = (int)ViewState["SelectedAddressId"];
                        }
                        // If not in ViewState, try hidden field (set by JavaScript)
                        else if (!string.IsNullOrEmpty(hidSelectedAddressId.Value))
                        {
                            if (int.TryParse(hidSelectedAddressId.Value, out selectedAddressId))
                            {
                                ViewState["SelectedAddressId"] = selectedAddressId;
                            }
                        }

                        if (selectedAddressId > 0 && addressId == selectedAddressId)
                        {
                            rbAddress.Checked = true;
                        }
                    }
                    // On initial load, select default address if available
                    else
                    {
                        if (row["IsDefault"] != DBNull.Value && (bool)row["IsDefault"])
                        {
                            rbAddress.Checked = true;
                            ViewState["SelectedAddressId"] = addressId;
                            hidSelectedAddressId.Value = addressId.ToString();
                        }
                    }
                }
            }
        }

        private void LoadOrderDetails()
        {
            List<int> selectedCartItemIds = Session["SelectedCartItems"] as List<int>;
            if (selectedCartItemIds == null || selectedCartItemIds.Count == 0)
            {
                return;
            }

            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                // Get cart ID
                string cartSql =
                    @"
                    SELECT TOP 1 shoppingCartId
                    FROM dbo.tblShoppingCart
                    WHERE customerId = @customerId
                    ORDER BY shoppingCartId DESC";

                int cartId = 0;
                using (SqlCommand cmd = new SqlCommand(cartSql, con))
                {
                    cmd.Parameters.AddWithValue("@customerId", customerId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        cartId = (int)result;
                    }
                    con.Close();
                }

                if (cartId == 0)
                {
                    return;
                }

                // Get selected cart items with product details
                // Build parameterized IN clause
                var parameters = new List<string>();
                string sql =
                    @"
                    SELECT ci.cartItemId,
                           ci.productId,
                           ci.quantity,
                           p.name,
                           p.price,
                           p.imageUrl,
                           (ci.quantity * p.price) AS subtotal
                    FROM dbo.tblCartItems ci
                    INNER JOIN dbo.tblProducts p ON ci.productId = p.productId
                    WHERE ci.shoppingCartId = @cartId
                      AND ci.cartItemId IN (";

                for (int i = 0; i < selectedCartItemIds.Count; i++)
                {
                    parameters.Add("@itemId" + i);
                    sql += "@itemId" + i;
                    if (i < selectedCartItemIds.Count - 1)
                        sql += ", ";
                }
                sql += ") ORDER BY ci.dtAdded";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@cartId", cartId);
                    for (int i = 0; i < selectedCartItemIds.Count; i++)
                    {
                        cmd.Parameters.AddWithValue("@itemId" + i, selectedCartItemIds[i]);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            lvOrderDetails.DataSource = dt;
            lvOrderDetails.DataBind();
        }

        private void LoadOrderSummary()
        {
            List<int> selectedCartItemIds = Session["SelectedCartItems"] as List<int>;
            if (selectedCartItemIds == null || selectedCartItemIds.Count == 0)
            {
                _subtotal = 0m;
                _deliveryFee = CartHelper.GetDeliveryFee();
                _total = 0m;
                lblSubtotal.Text = "RM 0.00";
                lblDeliveryFee.Text = "RM " + _deliveryFee.ToString("N2");
                lblTotal.Text = "RM 0.00";
                return;
            }

            int customerId = (int)Session["CustomerId"];

            // Use shared helper to calculate subtotal from actual cart items
            _subtotal = CartHelper.CalculateSubtotal(customerId, selectedCartItemIds);
            _deliveryFee = CartHelper.GetDeliveryFee();
            _total = _subtotal + _deliveryFee;

            lblSubtotal.Text = "RM " + _subtotal.ToString("N2");
            lblDeliveryFee.Text = "RM " + _deliveryFee.ToString("N2");
            lblTotal.Text = "RM " + _total.ToString("N2");
        }

        protected void btnAddAddress_Click(object sender, EventArgs e)
        {
            // TODO: Redirect to add address page
            Response.Redirect("~/addAddress.aspx");
        }

        protected void btnEditAddress_Click(object sender, EventArgs e)
        {
            // TODO: Redirect to manage addresses page
            Response.Redirect("~/manageAddress.aspx");
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            // Validate inputs - get selected address
            int addressId = 0;
            bool addressSelected = false;

            foreach (RepeaterItem item in rptAddresses.Items)
            {
                RadioButton rbAddress = (RadioButton)item.FindControl("rbAddress");
                if (rbAddress != null && rbAddress.Checked)
                {
                    HiddenField hidAddressId = (HiddenField)item.FindControl("hidAddressId");
                    if (hidAddressId != null)
                    {
                        addressId = int.Parse(hidAddressId.Value);
                        addressSelected = true;
                        break;
                    }
                }
            }

            if (!addressSelected || addressId == 0)
            {
                lblError.Text = "Please select a delivery address.";
                lblError.Visible = true;
                return;
            }

            // Check if payment method is selected
            string paymentMethod = "";
            if (rbOnlineBanking.Checked)
            {
                paymentMethod = "Online Banking";
            }
            else if (rbEWallet.Checked)
            {
                paymentMethod = "E Wallet";
            }
            else
            {
                lblError.Text = "Please select a payment method.";
                lblError.Visible = true;
                return;
            }

            List<int> selectedCartItemIds = Session["SelectedCartItems"] as List<int>;
            if (selectedCartItemIds == null || selectedCartItemIds.Count == 0)
            {
                lblError.Text = "No items selected for checkout.";
                lblError.Visible = true;
                return;
            }

            // Recalculate subtotal and total from actual cart items before placing order
            LoadOrderSummary();

            int customerId = (int)Session["CustomerId"];

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // Get full address details
                        string addressSql =
                            @"
                            SELECT AddressLine1, AddressLine2, City, State, Postcode, Country
                            FROM dbo.tblUserAddresses
                            WHERE AddressId = @addressId";

                        string fullAddress = "";
                        using (SqlCommand cmd = new SqlCommand(addressSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@addressId", addressId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    fullAddress = reader["AddressLine1"].ToString();
                                    if (
                                        reader["AddressLine2"] != DBNull.Value
                                        && !string.IsNullOrEmpty(reader["AddressLine2"].ToString())
                                    )
                                        fullAddress += ", " + reader["AddressLine2"].ToString();
                                    fullAddress +=
                                        ", "
                                        + reader["City"].ToString()
                                        + ", "
                                        + reader["State"].ToString()
                                        + " "
                                        + reader["Postcode"].ToString()
                                        + ", "
                                        + reader["Country"].ToString();
                                }
                            }
                        }

                        // Create order
                        int orderId = 0;
                        string orderSql =
                            @"
                            INSERT INTO dbo.tblorders (customerid, orderdate, totalamount, shippingaddress, paymentmethod, orderstatus, paymentstatus)
                            VALUES (@customerId, GETDATE(), @totalAmount, @shippingAddress, @paymentMethod, @orderStatus, @paymentStatus);
                            SELECT SCOPE_IDENTITY();";

                        using (SqlCommand cmd = new SqlCommand(orderSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@customerId", customerId);
                            cmd.Parameters.AddWithValue("@totalAmount", _total);
                            cmd.Parameters.AddWithValue("@shippingAddress", fullAddress);
                            cmd.Parameters.AddWithValue("@paymentMethod", paymentMethod);
                            cmd.Parameters.AddWithValue("@orderStatus", "Pending");
                            cmd.Parameters.AddWithValue("@paymentStatus", "Unpaid"); //Means payment operation is failed or not completed

                            object result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                orderId = Convert.ToInt32(result);
                            }
                        }

                        if (orderId == 0)
                        {
                            throw new Exception("Failed to create order.");
                        }

                        // Get cart ID
                        string cartSql =
                            @"
                            SELECT TOP 1 shoppingCartId
                            FROM dbo.tblShoppingCart
                            WHERE customerId = @customerId
                            ORDER BY shoppingCartId DESC";

                        int cartId = 0;
                        using (SqlCommand cmd = new SqlCommand(cartSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@customerId", customerId);
                            object result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                cartId = (int)result;
                            }
                        }

                        // Create order details and remove from cart
                        // Build parameterized IN clause for order details
                        var orderDetailParams = new List<string>();
                        string orderDetailsSql =
                            @"
                            INSERT INTO dbo.tblOrderDetails (orderId, productId, quantity, unitPrice)
                            SELECT @orderId, ci.productId, ci.quantity, p.price
                            FROM dbo.tblCartItems ci
                            INNER JOIN dbo.tblProducts p ON ci.productId = p.productId
                            WHERE ci.shoppingCartId = @cartId
                              AND ci.cartItemId IN (";
                        for (int i = 0; i < selectedCartItemIds.Count; i++)
                        {
                            orderDetailParams.Add("@orderItemId" + i);
                            orderDetailsSql += "@orderItemId" + i;
                            if (i < selectedCartItemIds.Count - 1)
                                orderDetailsSql += ", ";
                        }
                        orderDetailsSql += ")";

                        using (SqlCommand cmd = new SqlCommand(orderDetailsSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            cmd.Parameters.AddWithValue("@cartId", cartId);
                            for (int i = 0; i < selectedCartItemIds.Count; i++)
                            {
                                cmd.Parameters.AddWithValue(
                                    "@orderItemId" + i,
                                    selectedCartItemIds[i]
                                );
                            }
                            cmd.ExecuteNonQuery();
                        }

                        // Delete selected items from cart
                        string deleteCartItemsSql =
                            @"
                            DELETE FROM dbo.tblCartItems
                            WHERE shoppingCartId = @cartId
                              AND cartItemId IN (";
                        for (int i = 0; i < selectedCartItemIds.Count; i++)
                        {
                            deleteCartItemsSql += "@deleteItemId" + i;
                            if (i < selectedCartItemIds.Count - 1)
                                deleteCartItemsSql += ", ";
                        }
                        deleteCartItemsSql += ")";

                        using (SqlCommand cmd = new SqlCommand(deleteCartItemsSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@cartId", cartId);
                            for (int i = 0; i < selectedCartItemIds.Count; i++)
                            {
                                cmd.Parameters.AddWithValue(
                                    "@deleteItemId" + i,
                                    selectedCartItemIds[i]
                                );
                            }
                            cmd.ExecuteNonQuery();
                        }

                        // Create payment record
                        string paymentSql =
                            @"
                            INSERT INTO dbo.tblpayments (orderId, paymentDate, paymentMethod, amount)
                            VALUES (@orderId, GETDATE(), @paymentMethod, @amount)";

                        using (SqlCommand cmd = new SqlCommand(paymentSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            cmd.Parameters.AddWithValue("@paymentMethod", paymentMethod);
                            cmd.Parameters.AddWithValue("@amount", _total);
                            cmd.ExecuteNonQuery();
                        }

                        // Update payment status to Paid after payment record is successfully created
                        string updatePaymentStatusSql =
                            @"
                            UPDATE dbo.tblorders
                            SET paymentStatus = @paymentStatus
                            WHERE orderId = @orderId";

                        using (SqlCommand cmd = new SqlCommand(updatePaymentStatusSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            cmd.Parameters.AddWithValue("@paymentStatus", "Paid");
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();

                        // Clear session
                        Session.Remove("SelectedCartItems");
                        Session.Remove("OrderSubtotal");
                        Session.Remove("OrderDeliveryFee");
                        Session.Remove("OrderTotal");

                        // Redirect to order confirmation page
                        Response.Redirect("~/orderHistory.aspx?orderId=" + orderId);
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        Console.WriteLine("Error:" + ex.Message);
                        lblError.Text =
                            "An error occurred while placing your order. Please try again.";
                        lblError.Visible = true;
                    }
                }
            }
        }
    }
}

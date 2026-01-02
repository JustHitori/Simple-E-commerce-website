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
    public partial class productDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }
            int customerId = (int)Session["CustomerId"];

            if (
                !TryGetFormValues(
                    out int productId,
                    out string _name,
                    out decimal _priceIgnored,
                    out string _img,
                    out int qty,
                    out string err
                )
            )
            {
                SetStatus(err, true);
                return;
            }
            if (qty <= 0)
            {
                SetStatus("Quantity must be at least 1.", true);
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // ✅ Get or create this user's cart (tblShoppingCart)
                        int shoppingCartId = GetOrCreateOpenCartId(con, tx, customerId);

                        // ✅ Upsert line in tblCartItems (no unitPrice in your table)
                        int rows;
                        using (
                            SqlCommand cmd = new SqlCommand(
                                @"
                    UPDATE ci
                    SET quantity = ci.quantity + @q
                    FROM dbo.tblCartItems ci
                    WHERE ci.shoppingCartId = @cartId AND ci.productId = @pid;",
                                con,
                                tx
                            )
                        )
                        {
                            cmd.Parameters.AddWithValue("@q", qty);
                            cmd.Parameters.AddWithValue("@cartId", shoppingCartId);
                            cmd.Parameters.AddWithValue("@pid", productId);
                            rows = cmd.ExecuteNonQuery();
                        }

                        if (rows == 0)
                        {
                            using (
                                SqlCommand cmd = new SqlCommand(
                                    @"
                        INSERT INTO dbo.tblCartItems (shoppingCartId, productId, quantity)
                        VALUES (@cartId, @pid, @q);",
                                    con,
                                    tx
                                )
                            )
                            {
                                cmd.Parameters.AddWithValue("@cartId", shoppingCartId);
                                cmd.Parameters.AddWithValue("@pid", productId);
                                cmd.Parameters.AddWithValue("@q", qty);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // No header update needed: dtCreated has default GETDATE()

                        tx.Commit();
                        SetStatus("Item added to cart.", false);
                    }
                    catch (Exception ex)
                    {
                        try
                        {
                            tx.Rollback();
                        }
                        catch
                        { /* ignore */
                        }
                        SetStatus("Error adding to cart: " + ex.Message, true);
                    }
                }
            }
        }

        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }
            int customerId = (int)Session["CustomerId"];

            if (
                !TryGetFormValues(
                    out int productId,
                    out string _name,
                    out decimal _priceIgnored,
                    out string _img,
                    out int qty,
                    out string err
                )
            )
            {
                SetStatus(err, true);
                return;
            }
            if (qty <= 0)
            {
                SetStatus("Quantity must be at least 1.", true);
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        // Get or create this user's cart
                        int shoppingCartId = GetOrCreateOpenCartId(con, tx, customerId);

                        int cartItemId = 0;

                        // Check if item already exists in cart
                        using (
                            SqlCommand cmd = new SqlCommand(
                                @"
                            SELECT cartItemId FROM dbo.tblCartItems 
                            WHERE shoppingCartId = @cartId AND productId = @pid",
                                con,
                                tx
                            )
                        )
                        {
                            cmd.Parameters.AddWithValue("@cartId", shoppingCartId);
                            cmd.Parameters.AddWithValue("@pid", productId);
                            object result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                cartItemId = Convert.ToInt32(result);
                                // Update quantity
                                using (
                                    SqlCommand updateCmd = new SqlCommand(
                                        @"
                                    UPDATE dbo.tblCartItems 
                                    SET quantity = quantity + @q
                                    WHERE cartItemId = @cartItemId",
                                        con,
                                        tx
                                    )
                                )
                                {
                                    updateCmd.Parameters.AddWithValue("@q", qty);
                                    updateCmd.Parameters.AddWithValue("@cartItemId", cartItemId);
                                    updateCmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                // Insert new cart item and get the ID
                                using (
                                    SqlCommand insertCmd = new SqlCommand(
                                        @"
                                    INSERT INTO dbo.tblCartItems (shoppingCartId, productId, quantity)
                                    OUTPUT INSERTED.cartItemId
                                    VALUES (@cartId, @pid, @q)",
                                        con,
                                        tx
                                    )
                                )
                                {
                                    insertCmd.Parameters.AddWithValue("@cartId", shoppingCartId);
                                    insertCmd.Parameters.AddWithValue("@pid", productId);
                                    insertCmd.Parameters.AddWithValue("@q", qty);
                                    cartItemId = Convert.ToInt32(insertCmd.ExecuteScalar());
                                }
                            }
                        }

                        tx.Commit();

                        // Store selected cart item ID in session and redirect to payment
                        if (cartItemId > 0)
                        {
                            List<int> selectedCartItemIds = new List<int> { cartItemId };
                            Session["SelectedCartItems"] = selectedCartItemIds;
                            Response.Redirect("~/payment.aspx");
                        }
                        else
                        {
                            SetStatus("Error: Could not add item to cart.", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        try
                        {
                            tx.Rollback();
                        }
                        catch
                        { /* ignore */
                        }
                        SetStatus("Error: " + ex.Message, true);
                    }
                }
            }
        }

        private bool TryGetFormValues(
            out int productId,
            out string name,
            out decimal price,
            out string imageUrl,
            out int qty,
            out string error
        )
        {
            productId = 0;
            name = "";
            price = 0m;
            imageUrl = "";
            qty = 1;
            error = "";

            // 1️⃣ First try: FormView DataKey (since you set DataKeyNames="productId")
            if (fvProduct.DataKey != null && fvProduct.DataKey.Value != null)
            {
                int.TryParse(fvProduct.DataKey.Value.ToString(), out productId);
            }

            // 2️⃣ Second try: hidden field (fallback)
            if (productId <= 0)
            {
                var hidId = fvProduct.FindControl("hidProductId") as HiddenField;
                if (hidId != null)
                {
                    int.TryParse(hidId.Value, out productId);
                }
            }

            // 3️⃣ If still invalid -> stop
            if (productId <= 0)
            {
                error = "Product not found.";
                return false;
            }

            // Read other hidden fields (not critical, but ok to keep)
            var hidName = fvProduct.FindControl("hidName") as HiddenField;
            var hidPrice = fvProduct.FindControl("hidPrice") as HiddenField;
            var hidImage = fvProduct.FindControl("hidImage") as HiddenField;
            var txtQty = fvProduct.FindControl("txtQty") as TextBox;

            name = hidName?.Value ?? "";
            decimal.TryParse(hidPrice?.Value, out price);
            imageUrl = hidImage?.Value ?? "";

            // Quantity validation
            if (txtQty == null || !int.TryParse(txtQty.Text, out qty) || qty < 1 || qty > 999)
            {
                error = "Invalid quantity.";
                return false;
            }

            return true;
        }

        private void SetStatus(string message, bool isError)
        {
            // Show toast notification instead of label
            string script =
                "showToast('"
                + message.Replace("'", "\\'").Replace("\r\n", " ").Replace("\n", " ")
                + "');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowToast", script, true);
        }

        private int GetOrCreateOpenCartId(SqlConnection con, SqlTransaction tx, int customerId)
        {
            // We assume: one active cart per customer, use the latest shoppingCartId
            using (
                var cmd = new SqlCommand(
                    @"
        DECLARE @cartId INT;

        -- Take an update lock so two requests can't create two carts at same time
        SELECT TOP 1 @cartId = shoppingCartId
        FROM dbo.tblShoppingCart WITH (UPDLOCK, HOLDLOCK)
        WHERE customerId = @cid
        ORDER BY shoppingCartId DESC;

        IF (@cartId IS NULL)
        BEGIN
            INSERT INTO dbo.tblShoppingCart (customerId)
            VALUES (@cid);            -- dtCreated uses default GETDATE()
            SET @cartId = SCOPE_IDENTITY();
        END

        SELECT @cartId;",
                    con,
                    tx
                )
            )
            {
                cmd.Parameters.AddWithValue("@cid", customerId);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}

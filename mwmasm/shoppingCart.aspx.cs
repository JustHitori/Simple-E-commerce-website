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
    public partial class shoppingCart : System.Web.UI.Page
    {
        private decimal _subtotal = 0m;
        private decimal _deliveryFee = CartHelper.GetDeliveryFee();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CustomerId"] == null)
            {
                Response.Redirect("~/login.aspx");
                return;
            }

            if(!IsPostBack)
            {
                BindCart();
            }
        }

        private void BindCart()
        {
            int customerId = (int)Session["CustomerId"];
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql = @"
            DECLARE @cartId INT;

            SELECT TOP 1 @cartId = shoppingCartId
            FROM dbo.tblShoppingCart
            WHERE customerId = @cid
            ORDER BY shoppingCartId DESC;

            IF (@cartId IS NULL)
            BEGIN
                -- No cart yet -> return empty result
                SELECT TOP 0 
                       CAST(NULL AS INT) AS cartItemId,
                       CAST(NULL AS INT) AS productId,
                       CAST(NULL AS INT) AS quantity,
                       CAST(NULL AS NVARCHAR(200)) AS name,
                       CAST(NULL AS DECIMAL(10,2)) AS price,
                       CAST(NULL AS NVARCHAR(500)) AS imageUrl;
            END
            ELSE
            BEGIN
                SELECT ci.cartItemId,
                       ci.productId,
                       ci.quantity,
                       p.name,
                       p.price,
                       p.imageUrl,
                       ci.dtAdded
                FROM dbo.tblCartItems ci
                INNER JOIN dbo.tblProducts p
                    ON ci.productId = p.productId
                WHERE ci.shoppingCartId = @cartId
                ORDER BY ci.dtAdded;
            END";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@cid", customerId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            int totalLines = dt.Rows.Count; // number of different products
            lblCartItemsCount.Text = totalLines.ToString();

            lvCartItems.DataSource = dt;
            lvCartItems.DataBind();

            // At first load, nothing selected -> summary hidden
            UpdateSummaryFromSelection();
        }

        private void UpdateSummaryFromSelection()
        {
            decimal selectedSubtotal = 0m;
            int selectedItemCount = 0;

            foreach (ListViewItem item in lvCartItems.Items)
            {
                var chk = item.FindControl("chkSelect") as CheckBox;
                if (chk != null && chk.Checked)
                {
                    var hidPrice = item.FindControl("hidPrice") as HiddenField;
                    var hidQty = item.FindControl("hidQty") as HiddenField;

                    if (hidPrice != null && hidQty != null)
                    {
                        decimal price;
                        int qty;
                        if (decimal.TryParse(hidPrice.Value, out price) &&
                            int.TryParse(hidQty.Value, out qty))
                        {
                            selectedSubtotal += price * qty;
                            selectedItemCount += qty;
                        }
                    }
                }
            }

            if (selectedSubtotal > 0)
            {
                _subtotal = selectedSubtotal;
                _deliveryFee = CartHelper.GetDeliveryFee(); // Use shared helper
                decimal total = _subtotal + _deliveryFee;

                pnlOrderSummary.Visible = true;
                lblSubtotal.Text = "RM " + _subtotal.ToString("N2");
                lblDeliveryFee.Text = "RM " + _deliveryFee.ToString("N2");
                lblTotal.Text = "RM " + total.ToString("N2");
            }
            else
            {
                // No selected items -> hide summary
                pnlOrderSummary.Visible = false;
                lblSubtotal.Text = "RM 0.00";
                lblDeliveryFee.Text = "RM 0.00";
                lblTotal.Text = "RM 0.00";
            }
        }

        protected void chkSelect_CheckedChanged(object sender, EventArgs e)
        {
            // Just recalc based on current selection; no need to re-bind here
            UpdateSummaryFromSelection();
        }

        protected void lvCartItems_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (Session["CustomerId"] == null) return;

            if (e.CommandName == "Increase" || e.CommandName == "Decrease")
            {
                int cartItemId;
                if (!int.TryParse(e.CommandArgument.ToString(), out cartItemId))
                    return;

                int delta = e.CommandName == "Increase" ? 1 : -1;

                string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    using (SqlTransaction tx = con.BeginTransaction())
                    {
                        try
                        {
                            int currentQty = 0;

                            // Get current quantity
                            using (SqlCommand cmd = new SqlCommand(
                                "SELECT quantity FROM dbo.tblCartItems WHERE cartItemId = @id", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@id", cartItemId);
                                object val = cmd.ExecuteScalar();
                                //if (val == null)
                                //{
                                //    tx.Rollback();
                                //    return;
                                //}
                                currentQty = (int)val;
                            }

                            int newQty = currentQty + delta;

                            if (newQty <= 0)
                            {
                                using (SqlCommand cmd = new SqlCommand(
                                    "DELETE FROM dbo.tblCartItems WHERE cartItemId = @id", con, tx))
                                {
                                    cmd.Parameters.AddWithValue("@id", cartItemId);
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                using (SqlCommand cmd = new SqlCommand(
                                    "UPDATE dbo.tblCartItems SET quantity = @q WHERE cartItemId = @id", con, tx))
                                {
                                    cmd.Parameters.AddWithValue("@q", newQty);
                                    cmd.Parameters.AddWithValue("@id", cartItemId);
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            tx.Commit();
                        }
                        catch
                        {
                            try { tx.Rollback(); } catch { }
                        }
                    }
                }

                // Rebind to refresh UI + totals
                BindCart();
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Collect selected cart items
            List<int> selectedCartItemIds = new List<int>();
            
            foreach (ListViewItem item in lvCartItems.Items)
            {
                var chk = item.FindControl("chkSelect") as CheckBox;
                if (chk != null && chk.Checked)
                {
                    int cartItemId = (int)lvCartItems.DataKeys[item.DataItemIndex].Value;
                    selectedCartItemIds.Add(cartItemId);
                }
            }

            if (selectedCartItemIds.Count == 0)
            {
                // No items selected
                return;
            }

            // Store selected cart item IDs in session
            Session["SelectedCartItems"] = selectedCartItemIds;
            Session["OrderSubtotal"] = _subtotal;
            Session["OrderDeliveryFee"] = _deliveryFee;
            Session["OrderTotal"] = _subtotal + _deliveryFee;

            // Redirect to payment page
            Response.Redirect("~/payment.aspx");
        }
    }
}
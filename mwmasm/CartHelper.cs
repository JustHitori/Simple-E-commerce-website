using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace mwmasm
{
    public class CartHelper
    {
        /// <summary>
        /// Calculates the subtotal for selected cart items
        /// </summary>
        /// <param name="customerId">The customer ID</param>
        /// <param name="selectedCartItemIds">List of selected cart item IDs</param>
        /// <returns>Subtotal amount (quantity * price for all selected items)</returns>
        public static decimal CalculateSubtotal(int customerId, List<int> selectedCartItemIds)
        {
            if (selectedCartItemIds == null || selectedCartItemIds.Count == 0)
            {
                return 0m;
            }

            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            decimal subtotal = 0m;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // Get cart ID
                string cartSql = @"
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

                if (cartId > 0)
                {
                    // Calculate subtotal from selected cart items: SUM(quantity * price)
                    string subtotalSql = @"
                        SELECT SUM(ci.quantity * p.price) AS totalSubtotal
                        FROM dbo.tblCartItems ci
                        INNER JOIN dbo.tblProducts p ON ci.productId = p.productId
                        WHERE ci.shoppingCartId = @cartId
                          AND ci.cartItemId IN (";

                    for (int i = 0; i < selectedCartItemIds.Count; i++)
                    {
                        subtotalSql += "@itemId" + i;
                        if (i < selectedCartItemIds.Count - 1)
                            subtotalSql += ", ";
                    }
                    subtotalSql += ")";

                    using (SqlCommand cmd = new SqlCommand(subtotalSql, con))
                    {
                        cmd.Parameters.AddWithValue("@cartId", cartId);
                        for (int i = 0; i < selectedCartItemIds.Count; i++)
                        {
                            cmd.Parameters.AddWithValue("@itemId" + i, selectedCartItemIds[i]);
                        }
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            subtotal = Convert.ToDecimal(result);
                        }
                        con.Close();
                    }
                }
            }

            return subtotal;
        }

        /// <summary>
        /// Gets the delivery fee (can be made configurable later)
        /// </summary>
        /// <returns>Delivery fee amount</returns>
        public static decimal GetDeliveryFee()
        {
            return 10m; // Default delivery fee
        }
    }
}
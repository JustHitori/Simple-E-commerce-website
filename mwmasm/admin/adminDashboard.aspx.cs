using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class adminDashboard : System.Web.UI.Page
    {
        private Dictionary<string, List<decimal>> statsData =
            new Dictionary<string, List<decimal>>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
                RenderChartData();
                LoadTopProducts();
            }
        }

        private void LoadStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get Users statistics for last 3 months
                List<decimal> usersStats = GetUsersStats(con);
                statsData["users"] = usersStats;

                // Get Products statistics for last 3 months
                List<decimal> productsStats = GetProductsStats(con);
                statsData["products"] = productsStats;

                // Get Orders statistics for last 3 months
                List<decimal> ordersStats = GetOrdersStats(con);
                statsData["orders"] = ordersStats;

                // Get Sales statistics for last 3 months
                List<decimal> salesStats = GetSalesStats(con);
                statsData["sales"] = salesStats;

                con.Close();
            }
        }

        private List<decimal> GetUsersStats(SqlConnection con)
        {
            List<decimal> stats = new List<decimal>();
            string sql =
                @"
                SELECT 
                    COUNT(CASE WHEN dtRegistered >= DATEADD(MONTH, -1, GETDATE()) AND dtRegistered < GETDATE() THEN 1 END) AS Month1,
                    COUNT(CASE WHEN dtRegistered >= DATEADD(MONTH, -2, GETDATE()) AND dtRegistered < DATEADD(MONTH, -1, GETDATE()) THEN 1 END) AS Month2,
                    COUNT(CASE WHEN dtRegistered >= DATEADD(MONTH, -3, GETDATE()) AND dtRegistered < DATEADD(MONTH, -2, GETDATE()) THEN 1 END) AS Month3
                FROM dbo.tblCustomers";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        stats.Add(Convert.ToDecimal(reader["Month3"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month2"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month1"] ?? 0));
                    }
                }
            }

            return stats;
        }

        private List<decimal> GetProductsStats(SqlConnection con)
        {
            List<decimal> stats = new List<decimal>();
            string sql =
                @"
                SELECT 
                    COUNT(CASE WHEN dtAdded >= DATEADD(MONTH, -1, GETDATE()) AND dtAdded < GETDATE() THEN 1 END) AS Month1,
                    COUNT(CASE WHEN dtAdded >= DATEADD(MONTH, -2, GETDATE()) AND dtAdded < DATEADD(MONTH, -1, GETDATE()) THEN 1 END) AS Month2,
                    COUNT(CASE WHEN dtAdded >= DATEADD(MONTH, -3, GETDATE()) AND dtAdded < DATEADD(MONTH, -2, GETDATE()) THEN 1 END) AS Month3
                FROM dbo.tblProducts";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        stats.Add(Convert.ToDecimal(reader["Month3"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month2"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month1"] ?? 0));
                    }
                }
            }

            return stats;
        }

        private List<decimal> GetOrdersStats(SqlConnection con)
        {
            List<decimal> stats = new List<decimal>();
            string sql =
                @"
                SELECT 
                    COUNT(CASE WHEN orderDate >= DATEADD(MONTH, -1, GETDATE()) AND orderDate < GETDATE() THEN 1 END) AS Month1,
                    COUNT(CASE WHEN orderDate >= DATEADD(MONTH, -2, GETDATE()) AND orderDate < DATEADD(MONTH, -1, GETDATE()) THEN 1 END) AS Month2,
                    COUNT(CASE WHEN orderDate >= DATEADD(MONTH, -3, GETDATE()) AND orderDate < DATEADD(MONTH, -2, GETDATE()) THEN 1 END) AS Month3
                FROM dbo.tblorders";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        stats.Add(Convert.ToDecimal(reader["Month3"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month2"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month1"] ?? 0));
                    }
                }
            }

            return stats;
        }

        private List<decimal> GetSalesStats(SqlConnection con)
        {
            List<decimal> stats = new List<decimal>();
            string sql =
                @"
                SELECT 
                    ISNULL(SUM(CASE WHEN orderDate >= DATEADD(MONTH, -1, GETDATE()) AND orderDate < GETDATE() THEN totalAmount ELSE 0 END), 0) AS Month1,
                    ISNULL(SUM(CASE WHEN orderDate >= DATEADD(MONTH, -2, GETDATE()) AND orderDate < DATEADD(MONTH, -1, GETDATE()) THEN totalAmount ELSE 0 END), 0) AS Month2,
                    ISNULL(SUM(CASE WHEN orderDate >= DATEADD(MONTH, -3, GETDATE()) AND orderDate < DATEADD(MONTH, -2, GETDATE()) THEN totalAmount ELSE 0 END), 0) AS Month3
                FROM dbo.tblorders";

            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        stats.Add(Convert.ToDecimal(reader["Month3"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month2"] ?? 0));
                        stats.Add(Convert.ToDecimal(reader["Month1"] ?? 0));
                    }
                }
            }

            return stats;
        }

        private void RenderChartData()
        {
            // Calculate month names for the last 3 months
            DateTime now = DateTime.Now;
            string[] monthLabels = new string[3];
            monthLabels[0] = now.AddMonths(-3).ToString("MMM yyyy"); // 3 months ago
            monthLabels[1] = now.AddMonths(-2).ToString("MMM yyyy"); // 2 months ago
            monthLabels[2] = now.AddMonths(-1).ToString("MMM yyyy"); // 1 month ago

            // Prepare data object for JSON serialization
            var chartData = new
            {
                monthLabels = monthLabels,
                users = statsData.ContainsKey("users")
                    ? statsData["users"].Select(x => (double)x).ToArray()
                    : new double[] { 0, 0, 0 },
                products = statsData.ContainsKey("products")
                    ? statsData["products"].Select(x => (double)x).ToArray()
                    : new double[] { 0, 0, 0 },
                orders = statsData.ContainsKey("orders")
                    ? statsData["orders"].Select(x => (double)x).ToArray()
                    : new double[] { 0, 0, 0 },
                sales = statsData.ContainsKey("sales")
                    ? statsData["sales"].Select(x => (double)x).ToArray()
                    : new double[] { 0, 0, 0 },
            };

            // Serialize to JSON and set in hidden field
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string jsonData = serializer.Serialize(chartData);
            hfChartData.Value = jsonData;

            // Set totals
            litUsersTotal.Text = GetTotalText("users", false);
            litProductsTotal.Text = GetTotalText("products", false);
            litOrdersTotal.Text = GetTotalText("orders", false);
            litSalesTotal.Text = GetTotalText("sales", true);
        }

        private string GetTotalText(string statType, bool isSales)
        {
            if (!statsData.ContainsKey(statType) || statsData[statType].Count < 3)
            {
                return isSales ? "(Total: RM 0.00)" : "(Total: 0)";
            }

            List<decimal> values = statsData[statType];
            decimal total = values.Sum();

            if (isSales)
            {
                return string.Format("(RM {0:N2})", total);
            }
            else
            {
                return string.Format("({0})", total.ToString("0"));
            }
        }

        private void LoadTopProducts()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                string sql =
                    @"
                    SELECT TOP 3
                        p.productId,
                        p.name AS ProductName,
                        p.imageUrl AS ImageUrl,
                        SUM(od.quantity * od.unitPrice) AS TotalRevenue,
                        SUM(od.quantity) AS TotalQuantity
                    FROM dbo.tblOrderDetails od
                    INNER JOIN dbo.tblorders o ON od.orderId = o.orderId
                    INNER JOIN dbo.tblProducts p ON od.productId = p.productId
                    GROUP BY p.productId, p.name, p.imageUrl
                    ORDER BY TotalRevenue DESC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }

                con.Close();
            }

            rptTopProducts.DataSource = dt;
            rptTopProducts.DataBind();
        }
    }
}

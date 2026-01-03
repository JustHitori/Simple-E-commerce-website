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
    public partial class adminDashboard : System.Web.UI.Page
    {
        private Dictionary<string, List<decimal>> statsData =
            new Dictionary<string, List<decimal>>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
                RenderCharts();
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

        public string GetStatValue(string statType, int index)
        {
            if (statsData.ContainsKey(statType) && statsData[statType].Count > index)
            {
                decimal value = statsData[statType][index];
                if (statType == "sales")
                {
                    return value.ToString("N2");
                }
                return value.ToString("0");
            }
            return "0";
        }

        public string GetBarHeight(string statType, int index)
        {
            if (statsData.ContainsKey(statType) && statsData[statType].Count > index)
            {
                List<decimal> values = statsData[statType];
                decimal maxValue = values.Max() > 0 ? values.Max() : 1;
                decimal currentValue = values[index];
                decimal percentage = (currentValue / maxValue) * 100;
                return percentage.ToString("0");
            }
            return "0";
        }

        private void RenderCharts()
        {
            // Calculate month names for the last 3 months
            DateTime now = DateTime.Now;
            string[] monthLabels = new string[3];
            monthLabels[0] = now.AddMonths(-3).ToString("MMMM yyyy"); // 3 months ago
            monthLabels[1] = now.AddMonths(-2).ToString("MMMM yyyy"); // 2 months ago
            monthLabels[2] = now.AddMonths(-1).ToString("MMMM yyyy"); // 1 month ago

            // Set chart bars
            litUsersChart.Text = GenerateChartBars("users", monthLabels);
            litProductsChart.Text = GenerateChartBars("products", monthLabels);
            litOrdersChart.Text = GenerateChartBars("orders", monthLabels);
            litSalesChart.Text = GenerateChartBars("sales", monthLabels, true);

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

        private string GenerateChartBars(
            string statType,
            string[] monthLabels,
            bool isSales = false
        )
        {
            if (!statsData.ContainsKey(statType) || statsData[statType].Count < 3)
            {
                return GenerateBar(0, "0", monthLabels[0], isSales)
                    + GenerateBar(0, "0", monthLabels[1], isSales)
                    + GenerateBar(0, "0", monthLabels[2], isSales);
            }

            List<decimal> values = statsData[statType];
            decimal maxValue = values.Max() > 0 ? values.Max() : 1;

            string html = "";
            for (int i = 0; i < 3; i++)
            {
                decimal currentValue = values[i];
                decimal percentage = (currentValue / maxValue) * 100;
                string valueStr = isSales
                    ? "RM " + currentValue.ToString("N2")
                    : currentValue.ToString("0");
                html += GenerateBar(percentage, valueStr, monthLabels[i], isSales);
            }

            return html;
        }

        private string GenerateBar(decimal height, string value, string monthLabel, bool isSales)
        {
            return string.Format(
                @"<div class=""chart-bar"" style=""height: {0}%"">
                    <span class=""chart-value"">{1}</span>
                    <span class=""chart-bar-label"">{2}</span>
                </div>",
                height.ToString("0"),
                value,
                monthLabel
            );
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

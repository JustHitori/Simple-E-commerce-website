<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="adminDashboard.aspx.cs" Inherits="mwmasm.adminDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .border-black {
            border: 1px solid black;
        }
        .grid-container {
            display: grid;
            grid-template-columns: auto auto;
            gap: 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-chart {
            background-color: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            min-height: 250px;
            box-shadow: rgba(0, 0, 0, 0.1) 0px 4px 12px;
        }
        .stat-chart h3 {
            margin-bottom: 30px;
            font-size: 1.2rem;
            font-weight: 600;
        }
        .chart-container {
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            height: 180px;
            gap: 15px;
            margin-bottom: 0.5rem;
        }
        .chart-bar {
            flex: 1;
            background-color: #dc2626;
            border-radius: 4px 4px 0 0;
            min-width: 40px;
            position: relative;
            transition: height 0.3s ease;
        }
        .chart-bar-label {
            position: absolute;
            bottom: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.85rem;
            white-space: nowrap;
        }
        .chart-value {
            position: absolute;
            top: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.9rem;
            font-weight: 600;
            width:100%;
            text-align: center;
        }
        .top-products-section {
            margin-bottom: 40px;
        }
        .top-products-section h2 {
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        .top-products-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .top-product-item {
            background-color: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            box-shadow: rgba(0, 0, 0, 0.1) 0px 4px 12px;
        }
        .top-product-item h4 {
            font-size: 1rem;
            font-weight: 600;
            margin-bottom: 10px;
            text-align: left;
        }
        .top-product-image {
            width: 80%;
            height: 150px;
            border-radius: 4px;
            margin-bottom: 10px;
            background-color: #e5e5e5;
        }
        .top-product-sold {
            font-size: 0.9rem;
            color: #666;
        }
        .management-section {
            margin-top: 30px;
        }
        .management-section h2 {
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="mb-4">Admin Dashboard</h1>

    <!-- Summary Statistics Section -->
    <div class="stats-grid">
        <!-- Total Users Chart -->
        <div class="stat-chart">
            <h3>Total Users <asp:Literal ID="litUsersTotal" runat="server"></asp:Literal></h3>
            <div class="chart-container">
                <asp:Literal ID="litUsersChart" runat="server"></asp:Literal>
            </div>
        </div>

        <!-- Total Products Chart -->
        <div class="stat-chart">
            <h3>Total Products <asp:Literal ID="litProductsTotal" runat="server"></asp:Literal></h3>
            <div class="chart-container">
                <asp:Literal ID="litProductsChart" runat="server"></asp:Literal>
            </div>
        </div>

        <!-- Total Orders Chart -->
        <div class="stat-chart">
            <h3>Total Orders <asp:Literal ID="litOrdersTotal" runat="server"></asp:Literal></h3>
            <div class="chart-container">
                <asp:Literal ID="litOrdersChart" runat="server"></asp:Literal>
            </div>
        </div>

        <!-- Total Sales Chart -->
        <div class="stat-chart">
            <h3>Total Sales <asp:Literal ID="litSalesTotal" runat="server"></asp:Literal></h3>
            <div class="chart-container">
                <asp:Literal ID="litSalesChart" runat="server"></asp:Literal>
            </div>
        </div>
    </div>

    <!-- Top Products Section -->
    <div class="top-products-section">
        <h2>Top Products</h2>
        <div class="top-products-grid">
            <asp:Repeater ID="rptTopProducts" runat="server">
                <ItemTemplate>
                    <div class="top-product-item">
                        <h4><%# Container.ItemIndex + 1 %>. <%# Eval("ProductName") %></h4>
                        <img src="<%# Eval("ImageUrl") %>" alt="<%# Eval("ProductName") %>" class="top-product-image" 
                             onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'200\' height=\'150\'%3E%3Crect width=\'200\' height=\'150\' fill=\'%23e5e5e5\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dy=\'.3em\' fill=\'%23999\'%3ENo Image%3C/text%3E%3C/svg%3E';" />
                        <div class="top-product-sold">
                            Sold: RM <%# Eval("TotalRevenue", "{0:N2}") %>(<%# Eval("TotalQuantity") %>)
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- System Management Section -->
    <div class="management-section">
        <h2>System Management</h2>
        <div class="grid-container">  
            <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageUsers">
                <div class="card p-2 border-black align-items-center">Users</div>
            </a>

            <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageProducts">
                <div class="card p-2 border-black align-items-center">Products</div>
            </a>

            <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageCategories">
                <div class="card p-2 border-black align-items-center">Categories</div>
            </a>

            <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageOrders">
                <div class="card p-2 border-black align-items-center">Deliveries</div>
            </a>
        </div>
    </div>
</asp:Content>

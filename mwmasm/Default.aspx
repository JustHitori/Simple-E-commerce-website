<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="mwmasm._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="home-page">
        <!-- User Profile Section -->
        <div class="user-profile-card">
            <div class="user-profile-content">
                <div class="user-avatar">
                    <asp:Label ID="lblUserInitial" runat="server" CssClass="user-initial"></asp:Label>
                </div>
                <div class="user-name">
                    <asp:Label ID="lblUserName" runat="server" CssClass="username-text"></asp:Label>
                </div>
                <div class="user-settings d-flex flex-column align-items-center">
                    <asp:HyperLink ID="hlSettings" runat="server" 
                        NavigateUrl="~/editProfile.aspx" 
                        Text="⚙️" 
                        CssClass="settings-icon" />
                        <div class="settings-label fw-bold">Settings</div>
                </div>
            </div>
        </div>

        <!-- My Orders Section -->
        <div class="my-orders-card">
            <h3 class="section-title">My orders</h3>
            <div class="orders-tabs">
                <a href="~/orderHistory.aspx?tab=ongoing" class="order-tab-item" runat="server">
                    <div class="order-tab-icon">📦</div>
                    <div class="order-tab-label">Ongoing</div>
                </a>
                <a href="~/orderHistory.aspx?tab=history" class="order-tab-item" runat="server">
                    <div class="order-tab-icon">📋</div>
                    <div class="order-tab-label">History</div>
                </a>
                <a href="~/orderHistory.aspx?tab=cancelled" class="order-tab-item" runat="server">
                    <div class="order-tab-icon">❌</div>
                    <div class="order-tab-label">Cancelled</div>
                </a>
            </div>
        </div>

        <!-- Product Catalog Section -->
        <div class="products-section">
            <div class="section-header">
                <h3 class="section-title">Products</h3>
                <asp:HyperLink ID="hlShowMore" runat="server" NavigateUrl="~/productCatalog.aspx" CssClass="show-more-link">Show More></asp:HyperLink>
            </div>

            <asp:ListView ID="lvTopProducts" runat="server">
                <LayoutTemplate>
                    <div class="products-grid">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                    </div>
                </LayoutTemplate>

                <ItemTemplate>
                    <asp:HyperLink ID="productLink" runat="server" 
                        NavigateUrl='<%# "~/productDetails.aspx?productId=" + Eval("productId") %>' 
                        CssClass="product-card">
                        <div class="product-image-wrapper">
                            <asp:Image ID="productImage" runat="server"
                                ImageUrl='<%# Eval("imageUrl") %>'
                                AlternateText='<%# Eval("name") %>'
                                CssClass="product-image" />
                        </div>
                        <div class="product-info">
                            <h3 class="product-name"><%# Eval("name") %></h3>
                            <div class="product-price">
                                <%# "RM " + string.Format("{0:N2}", Eval("price")) %>
                            </div>
                        </div>
                    </asp:HyperLink>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="empty-state">
                        <p class="empty-message">No products found.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
    </div>

    <style>
        /* Mobile-first styles */
        .home-page {
            padding: 16px;
            max-width: 100%;
        }

        /* User Profile Card */
        .user-profile-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .user-profile-content {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .user-avatar {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background-color: #212529;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .user-initial {
            color: #ffffff;
            font-size: 24px;
            font-weight: 700;
            line-height: 1;
        }

        .user-name {
            flex: 1;
        }

        .username-text {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
        }

        .settings-icon {
            font-size: 24px;
            text-decoration: none;
            color: #212529;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 4px;
            transition: background-color 0.2s ease;
        }

        .settings-icon:hover {
            background-color: #f8f9fa;
            text-decoration: none;
        }
        .settings-label {
            font-size: 12px;
            color: #212529;
        }

        /* My Orders Card */
        .my-orders-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #212529;
            margin: 0 0 16px 0;
        }

        .orders-tabs {
            display: flex;
            justify-content: space-around;
            gap: 8px;
        }

        .order-tab-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 12px 8px;
            text-decoration: none;
            color: #212529;
            border-radius: 8px;
            transition: background-color 0.2s ease;
        }

        .order-tab-item:hover {
            background-color: #f8f9fa;
            text-decoration: none;
            color: #212529;
        }

        .order-tab-icon {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .order-tab-label {
            font-size: 14px;
            font-weight: 500;
        }

        /* Products Section */
        .products-section {
            margin-bottom: 24px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .show-more-link {
            font-size: 14px;
            color: #212529;
            text-decoration: none;
            font-weight: 500;
        }

        .show-more-link:hover {
            text-decoration: underline;
            color: #212529;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            width: 100%;
        }

        .product-card {
            display: flex;
            flex-direction: column;
            background-color: #fff;
            border-radius: 12px;
            overflow: hidden;
            text-decoration: none;
            color: #212529;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
            text-decoration: none;
            color: #212529;
        }

        .product-image-wrapper {
            width: 100%;
            aspect-ratio: 1;
            overflow: hidden;
            background-color: #f3f3f3;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-info {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .product-name {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 8px 0;
            color: #212529;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 44px;
        }

        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #212529;
            margin-top: auto;
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 48px 16px;
        }

        .empty-message {
            font-size: 18px;
            color: #6c757d;
            margin: 0;
        }

        /* Tablet and up */
        @media (min-width: 768px) {
            .home-page {
                padding: 24px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .user-profile-card,
            .my-orders-card {
                padding: 24px;
            }

            .user-avatar {
                width: 64px;
                height: 64px;
            }

            .user-initial {
                font-size: 28px;
            }

            .username-text {
                font-size: 20px;
            }

            .order-tab-icon {
                font-size: 40px;
            }

            .order-tab-label {
                font-size: 16px;
            }

            .products-grid {
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
            }

            .product-name {
                font-size: 18px;
            }

            .product-price {
                font-size: 20px;
            }
        }

        /* Desktop */
        @media (min-width: 992px) {
            .products-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            // Check for tab parameter in URL for order history links
            var urlParams = new URLSearchParams(window.location.search);
            var tabParam = urlParams.get('tab');
            
            // The links are server-side, so they will handle the navigation
            // This script is just for reference if needed
        });
    </script>
</asp:Content>

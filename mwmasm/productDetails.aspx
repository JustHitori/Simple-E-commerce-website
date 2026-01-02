<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="productDetails.aspx.cs" Inherits="mwmasm.productDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div class="product-details-page">
    <asp:FormView ID="fvProduct" runat="server"
            DataSourceID="SqlDsProduct" DataKeyNames="productId" DefaultMode="ReadOnly">
            <ItemTemplate>
                <!-- Hidden fields for code-behind -->
                <asp:HiddenField ID="hidProductId" runat="server" Value='<%# Eval("productId") %>' />
                <asp:HiddenField ID="hidName" runat="server" Value='<%# Eval("name") %>' />
                <asp:HiddenField ID="hidPrice" runat="server" Value='<%# Eval("price") %>' />
                <asp:HiddenField ID="hidImage" runat="server" Value='<%# Eval("imageUrl") %>' />

                <!-- Product Image Section -->
                <div class="product-image-section">
                    <asp:Image ID="imgProduct" runat="server"
                        ImageUrl='<%# Eval("imageUrl") %>'
                        AlternateText='<%# Eval("name") %>'
                        CssClass="product-main-image" />
                </div>

                <!-- Product Information Section -->
                <div class="product-info-section">
                    <!-- Product Name -->
                    <h1 class="product-name"><%# Eval("name") %></h1>
                    
                    <!-- Price -->
                    <div class="product-price">
                        <%# Eval("price", "RM {0:N2}") %>
                    </div>

                    <!-- Description -->
                    <div class="product-description">
                        <h3 class="section-title">Description</h3>
                        <p class="description-text">
                            <%# string.IsNullOrWhiteSpace(Eval("description") as string) ? "None" : Eval("description") %>
                        </p>
                    </div>

                    <!-- Product Details -->
                    <div class="product-details">
                        <h3 class="section-title">Product Details</h3>
                        <div class="details-content">
                            <div class="detail-item">
                                <span class="detail-label">Available Stock:</span>
                                <span class="detail-value"><%# Eval("stockQuantity") %></span>
                            </div>
                        </div>
                    </div>

                    <!-- Quantity Selector -->
                    <div class="quantity-section">
                        <label for="txtQty" class="quantity-label">Quantity</label>
                        <div class="quantity-controls">
                            <asp:TextBox ID="txtQty" runat="server" Text="1" CssClass="form-control quantity-input" />
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtQty" ErrorMessage="Qty required"
                                Display="Dynamic" ForeColor="Red" CssClass="validation-error" />
                            <asp:RangeValidator ID="rvQuantity" runat="server"
                                ControlToValidate="txtQty" 
                                MinimumValue="1" 
                                MaximumValue='<%# Math.Max(1, Convert.ToInt32(Eval("stockQuantity")) - 1) %>'
                                Type="Integer" ErrorMessage="Cannot purchase all items. At least 1 must remain in stock."
                                Display="Dynamic" ForeColor="Red" CssClass="validation-error"
                                Enabled='<%# Convert.ToInt32(Eval("stockQuantity")) > 1 %>' />
                        </div>
                    </div>

                    <!-- Sold Out Label -->
                    <asp:Panel ID="pnlSoldOut" runat="server" Visible='<%# Convert.ToInt32(Eval("stockQuantity")) <= 0 %>' CssClass="sold-out-panel">
                        <div class="sold-out-label">Sold Out</div>
                    </asp:Panel>

                </div>

                <!-- Action Buttons (Fixed at bottom on mobile) -->
                <div class="action-buttons">
                    <asp:Button ID="btnBuyNow" runat="server" Text="Buy Now"
                        CssClass="btn btn-buy-now"
                        OnClick="btnBuyNow_Click"
                        Enabled='<%# Convert.ToInt32(Eval("stockQuantity")) > 0 %>' />
                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart"
                        CssClass="btn btn-add-cart"
                        OnClick="btnAddToCart_Click"
                        Enabled='<%# Convert.ToInt32(Eval("stockQuantity")) > 0 %>' />
                </div>
            </ItemTemplate>

            <EmptyDataTemplate>
                <div class="text-muted">Product not found.</div>
                <asp:HyperLink runat="server" NavigateUrl="productCatalog.aspx">Back to Catalog</asp:HyperLink>
            </EmptyDataTemplate>
        </asp:FormView>
</div>

    <!-- Toast Notification -->
    <div id="toastNotification" class="toast-notification">
        <button class="toast-close" onclick="closeToast()" aria-label="Close">&times;</button>
        <div class="toast-content" id="toastContent"></div>
        <asp:HyperLink ID="hlGoToCart" runat="server" 
            NavigateUrl="~/shoppingCart.aspx" 
            Text="Go to Cart" />
    </div>

    <!-- Data source: reads ?productId=... from URL -->
    <asp:SqlDataSource ID="SqlDsProduct" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="
            SELECT TOP 1 productId, name, description, price, imageUrl, stockQuantity
            FROM dbo.tblProducts
            WHERE productId = @productId">
        <SelectParameters>
            <asp:QueryStringParameter Name="productId" QueryStringField="productId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <style>
        /* Mobile-first styles */
        .product-details-page {
            margin: 0;
            padding: 0;
            width: 100%;
        }

        /* Product Image Section */
        .product-image-section {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            margin-right: calc(-50vw + 50%);
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 0;
            box-sizing: border-box;
        }

        .product-main-image {
            width: 100%;
            height: auto;
            object-fit: cover;
            object-position: center;
            background-color: #f3f3f3;
            display: block;
        }

        /* Product Information Section */
        .product-info-section {
            padding: 0 16px 100px;
        }

        .product-name {
            font-size: 24px;
            font-weight: 700;
            margin: 0 0 12px 0;
            line-height: 1.3;
            color: #212529;
        }

        .product-price {
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 24px 0;
            color: #212529;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin: 24px 0 12px 0;
            color: #212529;
        }

        .product-description {
            margin-bottom: 24px;
        }

        .description-text {
            color: #555;
            line-height: 1.6;
            margin: 0;
        }

        .product-details {
            margin-bottom: 24px;
        }

        .details-content {
            color: #555;
        }

        .detail-item {
            margin-bottom: 8px;
        }

        .detail-label {
            font-weight: 500;
            margin-right: 8px;
        }

        .detail-value {
            color: #212529;
        }

        /* Quantity Section */
        .quantity-section {
            margin: 24px 0;
        }

        .quantity-label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #212529;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .quantity-input {
            width: 80px;
            max-width: 80px;
        }

        .validation-error {
            font-size: 12px;
        }

        /* Sold Out Label */
        .sold-out-panel {
            margin: 24px 0;
        }

        .sold-out-label {
            display: inline-block;
            padding: 12px 24px;
            background-color: #dc3545;
            color: #ffffff;
            font-size: 18px;
            font-weight: 600;
            border-radius: 8px;
            text-align: center;
            width: 100%;
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* Toast Notification */
        .toast-notification {
            position: fixed;
            bottom: 100px;
            right: 16px;
            background-color: #212529;
            color: #ffffff;
            padding: 16px 40px 16px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 1100;
            min-width: 280px;
            max-width: calc(100% - 32px);
            display: none;
            transform: translateX(calc(100% + 20px));
            transition: transform 0.3s ease-in-out, opacity 0.3s ease-in-out;
            opacity: 0;
        }

        .toast-notification.show {
            display: block;
            transform: translateX(0);
            opacity: 1;
        }

        .toast-close {
            position: absolute;
            top: 8px;
            right: 8px;
            background: transparent;
            border: none;
            color: #ffffff;
            font-size: 24px;
            line-height: 1;
            cursor: pointer;
            padding: 4px 8px;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: background-color 0.2s ease;
        }

        .toast-close:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .toast-close:active {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .toast-content {
            font-size: 14px;
            line-height: 1.5;
            word-wrap: break-word;
        }

        /* Action Buttons - Fixed at bottom on mobile */
        .action-buttons {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            display: flex;
            gap: 12px;
            padding: 16px;
            background-color: #fff;
            border-top: 1px solid #dee2e6;
            z-index: 100;
            box-shadow: 0 -2px 8px rgba(0,0,0,0.1);
        }

        .btn-buy-now,
        .btn-add-cart {
            flex: 1;
            padding: 14px 24px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-buy-now {
            background-color: #212529;
            color: #ffffff;
        }

        .btn-buy-now:hover {
            background-color: #000000;
        }

        .btn-add-cart {
            background-color: #212529;
            color: #ffffff;
        }

        .btn-add-cart:hover {
            background-color: #000000;
        }

        /* Desktop styles */
        @media (min-width: 768px) {
            .product-details-page {
                margin: 0 auto;
                padding: 24px;
                max-width: 1200px;
            }

            .product-image-section {
                width: calc(100% + 48px);
                margin-left: 24px;
                display: block;
                margin-bottom: 32px;
            }
            
            .product-main-image {
                width: 100%;
                margin-left: 24px;
                height: auto;
                max-height: 600px;
                object-fit: cover;
            }

            .product-info-section {
                max-width: 600px;
                margin: 0 auto;
                padding: 0 0 24px;
            }

            .product-name {
                font-size: 32px;
            }

            .product-price {
                font-size: 36px;
            }

            /* Desktop: Buttons not fixed */
            .action-buttons {
                position: static;
                max-width: 600px;
                margin: 32px auto 0;
                padding: 0;
                border-top: none;
                box-shadow: none;
            }

            .btn-buy-now,
            .btn-add-cart {
                flex: 1;
                max-width: 300px;
            }
        }

        @media (min-width: 992px) {
            .product-details-page {
                display: flex;
                gap: 48px;
                align-items: flex-start;
                padding: 32px;
            }

            .product-image-section {
                flex: 0 0 400px;
                max-width: 400px;
                margin: 0;
            }

            .product-info-section {
                flex: 1;
                max-width: none;
                padding: 0;
            }

            .action-buttons {
                max-width: none;
                margin: 24px 0 0;
            }

            .toast-notification {
                bottom: 24px;
                right: 24px;
                max-width: 400px;
            }
        }
    </style>

    <script type="text/javascript">
        function showToast(message) {
            var toast = document.getElementById('toastNotification');
            var content = document.getElementById('toastContent');
            if (toast && content) {
                content.textContent = message;
                toast.classList.add('show');
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    closeToast();
                }, 5000);
            }
        }

        function closeToast() {
            var toast = document.getElementById('toastNotification');
            if (toast) {
                toast.classList.remove('show');
            }
        }
    </script>
</asp:Content>

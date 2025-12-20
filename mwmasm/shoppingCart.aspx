<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="shoppingCart.aspx.cs" Inherits="mwmasm.shoppingCart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="mb-3">Your Cart
    (<asp:Label ID="lblCartItemsCount" runat="server"></asp:Label> items) 
    </h2>

    <!-- Cart items -->
    <asp:ListView ID="lvCartItems" runat="server" DataKeyNames="cartItemId"
        OnItemCommand="lvCartItems_ItemCommand">
        <LayoutTemplate>
            <div id="cartItemsContainer" runat="server" class="cart-items">
                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
            </div>
        </LayoutTemplate>

        <ItemTemplate>
            <div class="cart-item d-flex flex-row flex-md-row align-items-center mb-3 p-3 border rounded-3">
                <!-- Checkbox -->
                <div class="me-2 mb-2 mb-md-0 ">
                    <asp:CheckBox ID="chkSelect" runat="server"
                        AutoPostBack="true"
                        OnCheckedChanged="chkSelect_CheckedChanged" />
                </div>

                <!-- Product image -->
                <div class="cart-item-image me-3 mb-2 mb-md-0">
                    <asp:Image ID="imgProduct" runat="server"
                        ImageUrl='<%# Eval("imageUrl") %>'
                        AlternateText='<%# Eval("name") %>'
                        CssClass="cart-thumb img-thumbnail" />
                </div>

                <!-- Product name + price -->
                <div class="cart-item-info flex-grow-1">
                    <div class="fw-semibold cart-product-name">
                        <%# Eval("name") %>
                    </div>
                    <div class="text-muted small">
                        RM <%# Eval("price", "{0:N2}") %>
                    </div>
                </div>

                <!-- Quantity controls -->
                <div class="cart-item-qty ms-md-auto mt-2 mt-md-0">
                    <div class="qty-control d-flex align-items-center">
                        <asp:LinkButton ID="btnMinus" runat="server"
                            CommandName="Decrease"
                            CommandArgument='<%# Eval("cartItemId") %>'
                            CssClass="qty-btn">-</asp:LinkButton>

                        <span class="qty-value mx-3">
                            <%# Eval("quantity") %>
                        </span>

                        <asp:LinkButton ID="btnPlus" runat="server"
                            CommandName="Increase"
                            CommandArgument='<%# Eval("cartItemId") %>'
                            CssClass="qty-btn">+</asp:LinkButton>
                    </div>
                </div>

                <!-- Hidden numeric values for server-side calculation -->
                <asp:HiddenField ID="hidPrice" runat="server" Value='<%# Eval("price") %>' />
                <asp:HiddenField ID="hidQty" runat="server" Value='<%# Eval("quantity") %>' />
            </div>
        </ItemTemplate>


        <EmptyDataTemplate>
            <div class="alert alert-info">
                Your cart is empty.
            </div>
        </EmptyDataTemplate>
    </asp:ListView>

    <!-- Order summary -->
    <asp:Panel ID="pnlOrderSummary" runat="server"
        CssClass="order-summary card mt-4" Visible="false">
        <div class="card-body">
            <h5 class="card-title mb-3">Order Summary</h5>

            <div class="d-flex justify-content-between mb-1">
                <span>Subtotal</span>
                <asp:Label ID="lblSubtotal" runat="server" Text="RM0.00"></asp:Label>
            </div>

            <div class="d-flex justify-content-between mb-1">
                <span>Delivery Fee</span>
                <asp:Label ID="lblDeliveryFee" runat="server" Text="RM0.00"></asp:Label>
            </div>

            <hr />

            <div class="d-flex justify-content-between mb-3 fw-semibold">
                <span>Total</span>
                <asp:Label ID="lblTotal" runat="server" Text="RM0.00"></asp:Label>
            </div>

            <asp:Button ID="btnCheckout" runat="server"
                Text="Proceed To Payment"
                CssClass="btn btn-dark mw-none w-100"
                OnClick="btnCheckout_Click" />
        </div>
    </asp:Panel>


    <style>
        /* mobile-first styles (match your Figma) */
        .cart-item {
            background-color: #fff;
        }
        .cart-thumb {
            width: 64px;
            height: 64px;
            object-fit: cover;
        }
        .qty-control {
            background: #f3f3f3;
            border-radius: 999px;
            padding: 4px 8px;
        }
        .qty-btn {
            display: inline-block;
            width: 32px;
            height: 32px;
            border: none;
            text-align: center;
            line-height: 30px;
            text-decoration: none;
            color: #000;
            font-size:20px;
        }
        .qty-btn:hover {
            text-decoration: none;
        }
        .qty-value {
            min-width: 24px;
            text-align: center;
            font-weight: 600;
        }
        .mw-none {
            max-width:none;
        }

        /* Desktop layout tweaks */
        @media (min-width: 768px) {
            .order-summary {
                max-width: 320px;
                margin-left: auto;
            }
            /* Put summary to the right if you wrap them later in columns */
        }
    </style>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="payment.aspx.cs" Inherits="mwmasm.payment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="payment-page">
        <h2 class="mb-4">Order - Payment</h2>

        <!-- Delivery to Section -->
        <div class="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <h5 class="mb-0">Delivery to</h5>
                <asp:LinkButton ID="btnEditAddress" runat="server" CssClass="text-decoration-none me-1" OnClick="btnEditAddress_Click" Visible="false">
                    Edit
                </asp:LinkButton>
            </div>

            <!-- Address List -->
            <asp:Panel ID="pnlAddressList" runat="server" Visible="false">
                <asp:HiddenField ID="hidSelectedAddressId" runat="server" />
                <asp:Repeater ID="rptAddresses" runat="server" OnItemDataBound="rptAddresses_ItemDataBound">
                    <ItemTemplate>
                        <div class="address-card">
                            <asp:RadioButton ID="rbAddress" runat="server" 
                                GroupName="AddressSelection" 
                                CssClass="address-radio" />
                            <div class="address-label">
                                <div class="address-label-text"><%# Eval("Label") %></div>
                                <div class="address-full-text"><%# Eval("FullAddress") %></div>
                            </div>
                            <asp:HiddenField ID="hidAddressId" runat="server" Value='<%# Eval("AddressId") %>' />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- No Address Message -->
            <asp:Panel ID="pnlNoAddress" runat="server" Visible="false">
                <div class="alert alert-info">
                    <p class="mb-2">No delivery address found.</p>
                    <asp:Button ID="btnAddAddress" runat="server" Text="Add Address" CssClass="btn btn-primary btn-sm" OnClick="btnAddAddress_Click" />
                </div>
            </asp:Panel>
        </div>

        <!-- Payment Method Section -->
        <div class="mb-4">
            <h5 class="mb-2">Payment Method</h5>
            <div class="payment-method-container">
                <div class="payment-method-card">
                    <asp:RadioButton ID="rbOnlineBanking" runat="server" 
                        GroupName="PaymentMethod" 
                        CssClass="payment-radio" />
                    <label for="<%= rbOnlineBanking.ClientID %>" class="payment-method-label">
                        <span class="payment-icon">🏦</span>
                        <span class="payment-text">Online Banking</span>
                    </label>
                </div>
                <div class="payment-method-card">
                    <asp:RadioButton ID="rbEWallet" runat="server" 
                        GroupName="PaymentMethod" 
                        CssClass="payment-radio" />
                    <label for="<%= rbEWallet.ClientID %>" class="payment-method-label">
                        <span class="payment-icon">💳</span>
                        <span class="payment-text">E Wallet</span>
                    </label>
                </div>
            </div>
        </div>

        <!-- Details Section -->
        <div class="mb-4">
            <h5 class="mb-2">Details</h5>
            <asp:ListView ID="lvOrderDetails" runat="server">
                <LayoutTemplate>
                    <div id="orderDetailsContainer" runat="server">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <div class="order-detail-item d-flex align-items-center mb-3 p-3 border rounded-3">
                        <div class="me-3">
                            <asp:Image ID="imgProduct" runat="server"
                                ImageUrl='<%# Eval("imageUrl") %>'
                                AlternateText='<%# Eval("name") %>'
                                CssClass="product-thumb img-thumbnail" />
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">
                                <%# Eval("name") %>
                            </div>
                            <div class="text-muted small">
                                <%# Eval("quantity") %> items
                            </div>
                            <div class="fw-semibold mt-1">
                                RM <%# Eval("subtotal", "{0:N2}") %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="alert alert-warning">
                        No items selected for checkout.
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>

        <!-- Order Summary -->
        <div class="order-summary card mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal</span>
                    <asp:Label ID="lblSubtotal" runat="server" Text="RM 0.00" CssClass="fw-semibold"></asp:Label>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Delivery Fee</span>
                    <asp:Label ID="lblDeliveryFee" runat="server" Text="RM 0.00" CssClass="fw-semibold"></asp:Label>
                </div>
                <hr />
                <div class="d-flex justify-content-between mb-3">
                    <span class="fw-bold">Total</span>
                    <asp:Label ID="lblTotal" runat="server" Text="RM 0.00" CssClass="fw-bold fs-5"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Place Order Button -->
        <div class="d-flex justify-content-center">
            <asp:Button ID="btnPlaceOrder" runat="server" 
            Text="Place Order" 
            CssClass="btn btn-dark custom-width py-3 mb-4" 
            OnClick="btnPlaceOrder_Click" />
        </div>

        <!-- Error Message -->
        <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
    </div>

    <style>
        .payment-page {
            max-width: 600px;
            margin: 0 auto;
        }
        .custom-width {
            max-width: none;
            width:100%
        }

        /* Address Cards */
        .address-card {
            display: flex;
            align-items: center;
            padding: 16px;
            margin-bottom: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .address-card:hover {
            background-color: #f8f9fa;
            border-color: #212529;
        }

        .address-card:has(input[type="radio"]:checked) {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }

        .address-radio {
            margin-right: 12px;
            margin-top: 2px;
            flex-shrink: 0;
        }

        .address-label {
            flex-grow: 1;
            cursor: pointer;
            margin: 0;
        }

        .address-label-text {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 4px;
            color: #212529;
        }

        .address-full-text {
            font-size: 14px;
            color: #6c757d;
            line-height: 1.5;
        }

        /* Selected state */
        .address-card.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }

        /* Payment Method Cards */
        .payment-method-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .payment-method-card {
            position: relative;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
            padding: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .payment-method-card:hover {
            background-color: #f8f9fa;
            border-color: #0d6efd;
        }

        .payment-radio {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .payment-method-label {
            display: flex;
            align-items: center;
            cursor: pointer;
            margin: 0;
            width: 100%;
        }

        .payment-icon {
            font-size: 24px;
            margin-right: 12px;
            width: 32px;
            text-align: center;
        }

        .payment-text {
            font-size: 16px;
            color: #212529;
        }

        /* Radio button styling */
        .payment-method-card::before {
            content: '';
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            border: 2px solid #ddd;
            border-radius: 50%;
            background-color: #fff;
            transition: all 0.2s ease;
        }

        /* Selected state */
        .payment-method-card.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }

        .payment-method-card.selected::before {
            border-color: #0d6efd;
        }

        .payment-method-card.selected::after {
            content: '';
            position: absolute;
            right: 21px;
            top: 50%;
            transform: translateY(-50%);
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #0d6efd;
        }

        .product-thumb {
            width: 64px;
            height: 64px;
            object-fit: cover;
        }

        .order-detail-item {
            background-color: #fff;
        }

        .order-summary {
            background-color: #fff;
        }
    </style>
    <script type="text/javascript">
        // Handle payment method card selection
        document.addEventListener('DOMContentLoaded', function() {
            var paymentCards = document.querySelectorAll('.payment-method-card');
            var paymentRadios = document.querySelectorAll('.payment-radio');
            
            // Add click handler to cards
            paymentCards.forEach(function(card) {
                card.addEventListener('click', function(e) {
                    // Don't trigger if clicking the label directly
                    if (e.target.tagName === 'LABEL' || e.target.closest('label')) {
                        return;
                    }
                    
                    var radio = card.querySelector('input[type="radio"]');
                    if (radio) {
                        radio.checked = true;
                        updateCardStates();
                    }
                });
            });
            
            // Add change handler to radios
            paymentRadios.forEach(function(radio) {
                radio.addEventListener('change', function() {
                    updateCardStates();
                });
            });
            
            // Update card visual states
            function updateCardStates() {
                paymentCards.forEach(function(card) {
                    var radio = card.querySelector('input[type="radio"]');
                    if (radio && radio.checked) {
                        card.classList.add('selected');
                    } else {
                        card.classList.remove('selected');
                    }
                });
            }
            
            // Initialize on page load
            updateCardStates();
        });

        // Handle address card selection
        (function() {
            function initAddressCards() {
                var addressCards = document.querySelectorAll('.address-card');
                var addressRadios = document.querySelectorAll('.address-radio');
                
                // Add click handler to cards
                addressCards.forEach(function(card) {
                    card.addEventListener('click', function(e) {
                        // Don't trigger if clicking the radio directly
                        if (e.target.type === 'radio') {
                            return;
                        }
                        
                        var radio = card.querySelector('input[type="radio"]');
                        if (radio) {
                            radio.checked = true;
                            updateAddressCardStates();
                        }
                    });
                });
                
                // Add change handler to radios
                addressRadios.forEach(function(radio) {
                    radio.addEventListener('change', function() {
                        updateAddressCardStates();
                        // Store selected address ID for postback
                        var card = radio.closest('.address-card');
                        var hidAddressId = card.querySelector('input[type="hidden"]');
                        if (hidAddressId) {
                            // Store in a hidden field or use __doPostBack to preserve selection
                            document.getElementById('<%= hidSelectedAddressId.ClientID %>').value = hidAddressId.value;
                        }
                    });
                });
                
                // Update card visual states
                function updateAddressCardStates() {
                    addressCards.forEach(function(card) {
                        var radio = card.querySelector('input[type="radio"]');
                        if (radio && radio.checked) {
                            card.classList.add('selected');
                        } else {
                            card.classList.remove('selected');
                        }
                    });
                }
                
                // Initialize on page load
                updateAddressCardStates();
            }
            
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initAddressCards);
            } else {
                initAddressCards();
            }
        })();
    </script>
</asp:Content>

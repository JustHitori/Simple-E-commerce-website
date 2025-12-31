<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="orderDetails.aspx.cs" Inherits="mwmasm.orderDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="order-details-page">
        <h2 class="mb-4">Order Details</h2>

        <asp:Label ID="lblError" runat="server" CssClass="text-danger mb-3" Visible="false"></asp:Label>

        <!-- Delivery to Section -->
        <div class="mb-4">
            <h5 class="mb-3">Delivery to</h5>
            
            <!-- Progress Bar with All Status Labels -->
            <div class="progress-container mb-3">
                <div class="progress-bar-wrapper">
                    <div class="progress-segments">
                        <div class="progress-segment" id="segmentPending" runat="server"></div>
                        <div class="progress-segment" id="segmentSentOut" runat="server"></div>
                        <div class="progress-segment" id="segmentDelivered" runat="server"></div>
                    </div>
                    <div class="progress-labels">
                        <asp:Label ID="labelPending" runat="server" CssClass="progress-label" Text="Pending"></asp:Label>
                        <asp:Label ID="labelSentOut" runat="server" CssClass="progress-label" Text="Sent out for delivery"></asp:Label>
                        <asp:Label ID="labelDelivered" runat="server" CssClass="progress-label" Text="Delivered"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Address Card -->
            <div class="card border">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="address-image-placeholder me-3">
                            <div class="">
                                <img src="images/address-image.png" alt="Address" width="60px" height="60px" />
                            </div>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-bold mb-1">
                                <asp:Label ID="lblAddressLabel" runat="server"></asp:Label>
                            </div>
                            <div class="text-muted small">
                                <asp:Label ID="lblShippingAddress" runat="server"></asp:Label>
                            </div>
                            <div class="text-muted small mt-1">
                                Phone Number: <asp:Label ID="lblPhoneNumber" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Details -->
        <div class="mb-4">
            <asp:ListView ID="lvOrderItems" runat="server">
                <LayoutTemplate>
                    <div id="orderItemsContainer" runat="server">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <div class="card border mb-3">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="product-image-placeholder me-3">
                                    <asp:Image ID="imgProduct" runat="server"
                                        ImageUrl='<%# Eval("imageUrl") %>'
                                        AlternateText='<%# Eval("productName") %>'
                                        CssClass="product-image" />
                                </div>
                                <div class="flex-grow-1">
                                    <div class="fw-bold mb-1">
                                        <%# Eval("productName") %>
                                    </div>
                                    <div class="text-muted small mb-1">
                                        <asp:Label ID="lblCategory" runat="server" Text='<%# Eval("categoryName") %>'></asp:Label>
                                    </div>
                                    <div class="text-muted small">
                                        Date: <%# Eval("orderDate", "{0:dd/MM/yyyy}") %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="alert alert-warning">
                        No items found in this order.
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>

        <!-- Order Summary -->
        <div class="card border">
            <div class="card-body">
                <div class="d-flex justify-content-between mb-2">
                    <span>Subtotal (<asp:Label ID="lblTotalQuantity" runat="server"></asp:Label>)</span>
                    <asp:Label ID="lblSubtotal" runat="server" CssClass="fw-semibold"></asp:Label>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Shipping Fee</span>
                    <asp:Label ID="lblShippingFee" runat="server" CssClass="fw-semibold"></asp:Label>
                </div>
                <hr />
                <div class="d-flex justify-content-between">
                    <span class="fw-bold">Total</span>
                    <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold fs-5"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Cancel Order Button -->
        <div class="mt-4 text-center">
            <asp:Button ID="btnCancelOrder" runat="server" 
                Text="Cancel Order" 
                CssClass="btn btn-danger"
                OnClientClick="return showCancelOrderModal('confirmCancelOrderModal');" />
        </div>
    </div>

    <!-- Modal for cancel order confirmation -->
    <div class="modal" tabindex="-1" id="confirmCancelOrderModal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cancel Order</h5>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to cancel this order? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnConfirmCancelOrder" runat="server"
                        Text="Yes, Cancel Order"
                        CssClass="btn btn-danger"
                        OnClick="btnCancelOrder_Click"
                        CausesValidation="false" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        .order-details-page {
            max-width: 800px;
            margin: 0 auto;
        }

        .progress-container {
            position: relative;
        }

        .progress-bar-wrapper {
            position: relative;
            height: 40px;
            background-color: #e9ecef;
            border-radius: 8px;
            overflow: hidden;
            display: flex;
        }

        .progress-segments {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            z-index: 2;
        }

        .progress-segment {
            flex: 1;
            height: 100%;
            background-color: #e9ecef;
            transition: background-color 0.6s ease;
        }

        .progress-segment.active {
            background-color: #212529;
        }

        .progress-labels {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-around;
            z-index: 3;
            padding: 0 10px;
        }

        .progress-label {
            color: #6c757d;
            font-size: 12px;
            font-weight: 500;
            text-align: center;
            flex: 1;
            pointer-events: none;
        }

        .progress-label.active {
            color: white;
            font-weight: 600;
        }

        .address-image-placeholder {
            flex-shrink: 0;
        }

        .product-image-placeholder {
            flex-shrink: 0;
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            background-color: #f3f3f3;
            border-radius: 4px;
        }

        .card {
            background-color: #fff;
        }
    </style>

    <script>
        function showCancelOrderModal(modalId) {
            var el = document.getElementById(modalId);
            if (!el) return false;
            var modal = new bootstrap.Modal(el);
            modal.show();
            return false;
        }
    </script>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="orderHistory.aspx.cs" Inherits="mwmasm.orderHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="order-history-page">
        <h2 class="mb-4">Order</h2>

        <!-- Tabs -->
        <ul class="nav nav-tabs mb-4" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="ongoing-tab" data-bs-toggle="tab" data-bs-target="#ongoing" type="button" role="tab" aria-controls="ongoing" aria-selected="false">Ongoing</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab" aria-controls="history" aria-selected="true">History</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button" role="tab" aria-controls="cancelled" aria-selected="false">Cancelled</button>
            </li>
        </ul>

        <!-- Tab -->
        <div class="tab-content">
            <!-- Ongoing Orders -->
            <div class="tab-pane fade" id="ongoing" role="tabpanel" aria-labelledby="ongoing-tab">
                <asp:ListView ID="lvOngoingOrders" runat="server">
                    <LayoutTemplate>
                        <div id="ongoingOrdersContainer" runat="server">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="hlOrderLink" runat="server" 
                            NavigateUrl='<%# "~/orderDetails.aspx?orderId=" + Eval("orderId") %>' 
                            CssClass="text-decoration-none text-dark">
                            <div class="order-item-card mb-3 p-3 border rounded-3">
                                <div class="d-flex align-items-center">
                                    <div class="order-item-image me-3">
                                        <asp:Image ID="imgProduct" runat="server"
                                            ImageUrl='<%# Eval("imageUrl") %>'
                                            AlternateText='<%# Eval("productName") %>'
                                            CssClass="product-image" />
                                    </div>
                                    <div class="order-item-info flex-grow-1">
                                        <div class="fw-bold mb-1">
                                            <%# Eval("productName") %>
                                        </div>
                                        <div class="text-muted small mb-1">
                                            <%# Eval("quantity") %> items
                                        </div>
                                        <div class="fw-semibold">
                                            RM <%# Eval("subtotal", "{0:N2}") %>
                                        </div>
                                    </div>
                                    <div class="order-item-date text-muted small">
                                        <%# Eval("orderDate", "{0:dd/MM/yyyy}") %>
                                    </div>
                                </div>
                            </div>
                        </asp:HyperLink>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <div class="alert alert-info">
                            No ongoing orders found.
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
            </div>

            <!-- History Orders -->
            <div class="tab-pane fade show active" id="history" role="tabpanel" aria-labelledby="history-tab">
                <asp:ListView ID="lvHistoryOrders" runat="server">
                    <LayoutTemplate>
                        <div id="historyOrdersContainer" runat="server">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="hlOrderLink" runat="server" 
                            NavigateUrl='<%# "~/orderDetails.aspx?orderId=" + Eval("orderId") %>' 
                            CssClass="text-decoration-none text-dark">
                            <div class="order-item-card mb-3 p-3 border rounded-3">
                                <div class="d-flex align-items-center">
                                    <div class="order-item-image me-3">
                                        <asp:Image ID="imgProduct" runat="server"
                                            ImageUrl='<%# Eval("imageUrl") %>'
                                            AlternateText='<%# Eval("productName") %>'
                                            CssClass="product-image" />
                                    </div>
                                    <div class="order-item-info flex-grow-1">
                                        <div class="fw-bold mb-1">
                                            <%# Eval("productName") %>
                                        </div>
                                        <div class="text-muted small mb-1">
                                            <%# Eval("quantity") %> items
                                        </div>
                                        <div class="fw-semibold">
                                            RM <%# Eval("subtotal", "{0:N2}") %>
                                        </div>
                                    </div>
                                    <div class="order-item-date text-muted small">
                                        <%# Eval("orderDate", "{0:dd/MM/yyyy}") %>
                                    </div>
                                </div>
                            </div>
                        </asp:HyperLink>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <div class="alert alert-info">
                            No order history found.
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
            </div>

            <!-- Cancelled Orders -->
            <div class="tab-pane fade" id="cancelled" role="tabpanel" aria-labelledby="cancelled-tab">
                <asp:ListView ID="lvCancelledOrders" runat="server">
                    <LayoutTemplate>
                        <div id="cancelledOrdersContainer" runat="server">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="hlOrderLink" runat="server" 
                            NavigateUrl='<%# "~/orderDetails.aspx?orderId=" + Eval("orderId") %>' 
                            CssClass="text-decoration-none text-dark">
                            <div class="order-item-card mb-3 p-3 border rounded-3">
                                <div class="d-flex align-items-center">
                                    <div class="order-item-image me-3">
                                        <asp:Image ID="imgProduct" runat="server"
                                            ImageUrl='<%# Eval("imageUrl") %>'
                                            AlternateText='<%# Eval("productName") %>'
                                            CssClass="product-image" />
                                    </div>
                                    <div class="order-item-info flex-grow-1">
                                        <div class="fw-bold mb-1">
                                            <%# Eval("productName") %>
                                        </div>
                                        <div class="text-muted small mb-1">
                                            <%# Eval("quantity") %> items
                                        </div>
                                        <div class="fw-semibold">
                                            RM <%# Eval("subtotal", "{0:N2}") %>
                                        </div>
                                    </div>
                                    <div class="order-item-date text-muted small">
                                        <%# Eval("orderDate", "{0:dd/MM/yyyy}") %>
                                    </div>
                                </div>
                            </div>
                        </asp:HyperLink>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <div class="alert alert-info">
                            No cancelled orders found.
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
            </div>
        </div>
    </div>

    <style>
        .order-history-page {
            max-width: 800px;
            margin: 0 auto;
        }

        .nav-tabs {
            border-bottom: 2px solid #dee2e6;
        }

        .nav-tabs .nav-link {
            color: #6c757d;
            border: none;
            border-bottom: 2px solid transparent;
            padding: 0.75rem 1.5rem;
            background: none;
            cursor: pointer;
        }

        .nav-tabs .nav-link:hover {
            border-color: #dee2e6;
            color: #212529;
        }

        .nav-tabs .nav-link.active {
            color: #212529;
            border-bottom-color: #212529;
            font-weight: 600;
        }

        .order-item-card {
            background-color: #fff;
            transition: box-shadow 0.2s ease;
            cursor: pointer;
        }

        .order-item-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        a:hover .order-item-card {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .order-item-image {
            flex-shrink: 0;
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            background-color: #f3f3f3;
            border-radius: 4px;
        }

        .order-item-info {
            min-width: 0;
        }

        .order-item-date {
            flex-shrink: 0;
            text-align: right;
            white-space: nowrap;
            margin-left: 1rem;
        }

        @media (max-width: 576px) {
            .order-item-date {
                font-size: 0.75rem;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            // Check for tab parameter in URL
            var urlParams = new URLSearchParams(window.location.search);
            var tabParam = urlParams.get('tab');
            
            if (tabParam === 'ongoing') {
                // Activate the ongoing tab using Bootstrap Tab API
                var ongoingTab = document.getElementById('ongoing-tab');
                if (ongoingTab) {
                    var ongoingTabTrigger = new bootstrap.Tab(ongoingTab);
                    ongoingTabTrigger.show();
                }
            } else if (tabParam === 'cancelled') {
                // Activate the cancelled tab using Bootstrap Tab API
                var cancelledTab = document.getElementById('cancelled-tab');
                if (cancelledTab) {
                    var cancelledTabTrigger = new bootstrap.Tab(cancelledTab);
                    cancelledTabTrigger.show();
                }
            }
        });
    </script>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="manageOrders.aspx.cs" Inherits="mwmasm.admin.manageOrders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="mb-3">Orders</h1>

    <!-- Status Counts -->
    <div class="mb-3">
        <asp:Label ID="lblStatusCounts" runat="server"></asp:Label>
    </div>

    <asp:Label ID="lblStatus" runat="server" EnableViewState="false" CssClass="text-success mb-2 d-block"></asp:Label>
    <asp:Label ID="lblError" runat="server" EnableViewState="false" CssClass="text-danger mb-2 d-block"></asp:Label>

    <!-- Tabs -->
     <div class="rounded p-2">
        <ul class="nav nav-tabs mb-4" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="processing-tab" data-bs-toggle="tab" data-bs-target="#processing" type="button" role="tab" aria-controls="processing" aria-selected="true">Processing</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="processed-tab" data-bs-toggle="tab" data-bs-target="#processed" type="button" role="tab" aria-controls="processed" aria-selected="false">Processed</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button" role="tab" aria-controls="cancelled" aria-selected="false">Cancelled</button>
            </li>
        </ul>
    </div>
    <!-- Tab Content -->
    <div class="tab-content">
        <!-- Processing Orders Tab -->
        <div class="tab-pane fade show active" id="processing" role="tabpanel" aria-labelledby="processing-tab">
            <asp:GridView ID="gvProcessingOrders" runat="server" 
                CssClass="table table-striped table-bordered" 
                AutoGenerateColumns="False" 
                DataKeyNames="orderId"
                EmptyDataText="No processing orders found."
                OnRowDataBound="gvProcessingOrders_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="orderId" HeaderText="Order ID" />
                    <asp:BoundField DataField="customerName" HeaderText="Customer" />
                    <asp:BoundField DataField="productName" HeaderText="Product Name" />
                    <asp:BoundField DataField="orderDate" HeaderText="Order Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="totalAmount" HeaderText="Total Amount" DataFormatString="RM {0:N2}" />
                    <asp:BoundField DataField="paymentMethod" HeaderText="Payment Method" />
                    <asp:BoundField DataField="paymentStatus" HeaderText="Payment Status" />
                    <asp:TemplateField HeaderText="Order Status">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-2">
                                <asp:DropDownList ID="ddlOrderStatus" runat="server" 
                                    CssClass="form-select form-select-sm"
                                    SelectedValue='<%# Eval("orderStatus") %>'
                                    OnSelectedIndexChanged="ddlOrderStatus_SelectedIndexChanged"
                                    AutoPostBack="true">
                                    <asp:ListItem Text="Pending" Value="Pending" />
                                    <asp:ListItem Text="Sent out for delivery" Value="Sent out for delivery" />
                                    <asp:ListItem Text="Delivered" Value="Delivered" />
                                </asp:DropDownList>
                                <asp:Button ID="btnSettle" runat="server" 
                                    Text="Settle" 
                                    CssClass="btn btn-sm btn-success"
                                    CommandArgument='<%# Eval("orderId") %>'
                                    OnClick="btnSettle_Click" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Progress">
                        <ItemTemplate>
                            <div class="progress-container-small">
                                <div class="progress-bar-wrapper-small">
                                    <div class="progress-segments-small">
                                        <div class="progress-segment-small" id="segmentPending" runat="server"></div>
                                        <div class="progress-segment-small" id="segmentSentOut" runat="server"></div>
                                        <div class="progress-segment-small" id="segmentDelivered" runat="server"></div>
                                    </div>
                                    <div class="progress-labels-small">
                                        <span class="progress-label-small" id="labelPending" runat="server">Pending</span>
                                        <span class="progress-label-small" id="labelSentOut" runat="server">Sent out</span>
                                        <span class="progress-label-small" id="labelDelivered" runat="server">Delivered</span>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="shippingAddress" HeaderText="Shipping Address" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Processed Orders Tab -->
        <div class="tab-pane fade" id="processed" role="tabpanel" aria-labelledby="processed-tab">
            <asp:GridView ID="gvProcessedOrders" runat="server" 
                CssClass="table table-striped table-bordered" 
                AutoGenerateColumns="False" 
                DataKeyNames="orderId"
                EmptyDataText="No processed orders found."
                OnRowDataBound="gvProcessedOrders_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="orderId" HeaderText="Order ID" />
                    <asp:BoundField DataField="customerName" HeaderText="Customer" />
                    <asp:BoundField DataField="productName" HeaderText="Product Name" />
                    <asp:BoundField DataField="orderDate" HeaderText="Order Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="totalAmount" HeaderText="Total Amount" DataFormatString="RM {0:N2}" />
                    <asp:BoundField DataField="paymentMethod" HeaderText="Payment Method" />
                    <asp:BoundField DataField="paymentStatus" HeaderText="Payment Status" />
                    <asp:BoundField DataField="orderStatus" HeaderText="Order Status" />
                    <asp:TemplateField HeaderText="Progress">
                        <ItemTemplate>
                            <div class="progress-container-small">
                                <div class="progress-bar-wrapper-small">
                                    <div class="progress-segments-small">
                                        <div class="progress-segment-small" id="segmentPending" runat="server"></div>
                                        <div class="progress-segment-small" id="segmentSentOut" runat="server"></div>
                                        <div class="progress-segment-small" id="segmentDelivered" runat="server"></div>
                                    </div>
                                    <div class="progress-labels-small">
                                        <span class="progress-label-small" id="labelPending" runat="server">Pending</span>
                                        <span class="progress-label-small" id="labelSentOut" runat="server">Sent out</span>
                                        <span class="progress-label-small" id="labelDelivered" runat="server">Delivered</span>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="shippingAddress" HeaderText="Shipping Address" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Cancelled Orders Tab -->
        <div class="tab-pane fade" id="cancelled" role="tabpanel" aria-labelledby="cancelled-tab">
            <asp:GridView ID="gvCancelledOrders" runat="server" 
                CssClass="table table-striped table-bordered" 
                AutoGenerateColumns="False" 
                DataKeyNames="orderId"
                EmptyDataText="No cancelled orders found."
                OnRowDataBound="gvCancelledOrders_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="orderId" HeaderText="Order ID" />
                    <asp:BoundField DataField="customerName" HeaderText="Customer" />
                    <asp:BoundField DataField="productName" HeaderText="Product Name" />
                    <asp:BoundField DataField="orderDate" HeaderText="Order Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="totalAmount" HeaderText="Total Amount" DataFormatString="RM {0:N2}" />
                    <asp:BoundField DataField="paymentMethod" HeaderText="Payment Method" />
                    <asp:BoundField DataField="paymentStatus" HeaderText="Payment Status" />
                    <asp:BoundField DataField="orderStatus" HeaderText="Order Status" />
                    <asp:BoundField DataField="shippingAddress" HeaderText="Shipping Address" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <style>
        .nav-tabs {
            border-bottom: none;
        }

        .nav-tabs .nav-link {
            color: #212529;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.75rem 1.5rem;
            background-color: #ffffff;
            cursor: pointer;
            margin-right: 0.5rem;
        }

        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
            color: #212529;
        }

        .nav-tabs .nav-link.active {
            color: #ffffff;
            background-color: #212529;
            border-color: #212529;
            font-weight: 600;
        }

        .progress-container-small {
            position: relative;
            width: 200px;
        }

        .progress-bar-wrapper-small {
            position: relative;
            height: 30px;
            background-color: #e9ecef;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
        }

        .progress-segments-small {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            z-index: 2;
        }

        .progress-segment-small {
            flex: 1;
            height: 100%;
            background-color: #e9ecef;
            transition: background-color 0.6s ease;
        }

        .progress-segment-small.active {
            background-color: #212529;
        }

        .progress-labels-small {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: space-around;
            z-index: 3;
            padding: 0 5px;
        }

        .progress-label-small {
            color: #6c757d;
            font-size: 9px;
            font-weight: 500;
            text-align: center;
            flex: 1;
            pointer-events: none;
        }

        .progress-label-small.active {
            color: white;
            font-weight: 600;
        }
    </style>
</asp:Content>

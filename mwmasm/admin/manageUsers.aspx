<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="manageUsers.aspx.cs" Inherits="mwmasm.admin.manageUsers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="mb-3">Manage Users</h1>
    
    <!-- Admin Management Section -->
    <div class="mb-5">
        <h2 class="mb-3">Admin Management</h2>
        <asp:Button ID="btnAddAdmin" runat="server" Text="Add Admin" CssClass="btn btn-primary mb-3"
            OnClientClick="return showModal('addAdminModal');" />
        
        <asp:Label ID="lblAdminStatus" runat="server" EnableViewState="false" CssClass="d-block mb-2"></asp:Label>
        
        <asp:GridView ID="gvAdmins" runat="server" CssClass="table table-striped" 
            DataSourceID="SqlDsAdmins" AutoGenerateColumns="False" DataKeyNames="adminId"
            OnRowUpdating="gvAdmins_RowUpdating" EmptyDataText="No admins found.">
            <Columns>
                <asp:BoundField DataField="adminId" HeaderText="ID" ReadOnly="True" />
                <asp:BoundField DataField="username" HeaderText="Username" />
                <asp:TemplateField HeaderText="Password">
                    <ItemTemplate>
                        <asp:Label ID="lblPassword" runat="server" Text="******" />
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                        <small class="text-muted">Leave blank to keep current password</small>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:CommandField ShowEditButton="True" />
            </Columns>
        </asp:GridView>
    </div>

    <!-- Customer Search Section -->
    <div class="mb-5">
        <h2 class="mb-3">Customer Search</h2>
        <div class="row mb-3">
            <div class="col-md-2">
                <asp:Label ID="lblSearchColumn" runat="server" Text="Search By:" AssociatedControlID="ddlSearchColumn" />
                <asp:DropDownList ID="ddlSearchColumn" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Select Column --" Value="" Selected="True" />
                    <asp:ListItem Text="Customer ID" Value="CustomerID" />
                    <asp:ListItem Text="First Name" Value="fname" />
                    <asp:ListItem Text="Last Name" Value="lname" />
                    <asp:ListItem Text="Email" Value="email" />
                    <asp:ListItem Text="Phone Number" Value="PhoneNumber" />
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblSearchText" runat="server" Text="Search:" AssociatedControlID="txtSearch" />
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Enter search term..." />
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary me-2"
                    OnClick="btnSearch_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary"
                    OnClick="btnClear_Click" />
            </div>
            <div class="col-md-3">
                <asp:Label ID="lblSortBy" runat="server" Text="Sort By:" AssociatedControlID="ddlSortBy" />
                <div class="d-flex gap-2">
                    <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-select" AutoPostBack="true"
                        OnSelectedIndexChanged="ddlSortBy_SelectedIndexChanged">
                        <asp:ListItem Text="Customer ID" Value="CustomerID" Selected="True" />
                        <asp:ListItem Text="First Name" Value="fname" />
                        <asp:ListItem Text="Last Name" Value="lname" />
                        <asp:ListItem Text="Email" Value="email" />
                        <asp:ListItem Text="Phone Number" Value="PhoneNumber" />
                        <asp:ListItem Text="Date Registered" Value="dtRegistered" />
                    </asp:DropDownList>
                    <asp:Button ID="btnSortDirection" runat="server" Text="↓ Desc" CssClass="btn btn-outline-secondary"
                        OnClick="btnSortDirection_Click" />
                </div>
            </div>
        </div>
        
        <asp:Label ID="lblCustomerStatus" runat="server" EnableViewState="false" CssClass="d-block mb-2"></asp:Label>
        
        <asp:GridView ID="gvCustomers" runat="server" CssClass="table table-striped" 
            DataSourceID="SqlDsCustomers" AutoGenerateColumns="False" DataKeyNames="CustomerID"
            EmptyDataText="No customers found.">
            <Columns>
                <asp:BoundField DataField="CustomerID" HeaderText="ID" ReadOnly="True" />
                <asp:BoundField DataField="fname" HeaderText="First Name" />
                <asp:BoundField DataField="lname" HeaderText="Last Name" />
                <asp:BoundField DataField="email" HeaderText="Email" />
                <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" />
                <asp:BoundField DataField="dtRegistered" HeaderText="Date Registered" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
            </Columns>
        </asp:GridView>
    </div>

    <!-- Modal for Add Admin -->
    <div class="modal" tabindex="-1" id="addAdminModal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1>Add Admin</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:ValidationSummary ID="vsAddAdmin" runat="server" ValidationGroup="AddAdmin" CssClass="text-danger" />

                    <div class="col-12 mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtAdminUsername" Text="Username" />
                        <asp:TextBox ID="txtAdminUsername" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAdminUsername"
                            ErrorMessage="Username is required." CssClass="text-danger" ValidationGroup="AddAdmin" />
                    </div>

                    <div class="col-12 mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtAdminPassword" Text="Password" />
                        <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAdminPassword"
                            ErrorMessage="Password is required." CssClass="text-danger" ValidationGroup="AddAdmin" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnAddAdminConfirm" runat="server"
                        Text="Add Admin"
                        CssClass="btn btn-primary"
                        OnClick="btnAddAdminConfirm_Click"
                        ValidationGroup="AddAdmin"
                        UseSubmitBehavior="true"
                        CausesValidation="true" />
                </div>
            </div>
        </div>
    </div>

    <!-- SqlDataSource for Admins -->
    <asp:SqlDataSource ID="SqlDsAdmins" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT adminId, username FROM dbo.tblAdmin ORDER BY adminId">
    </asp:SqlDataSource>

    <!-- SqlDataSource for Customers -->
    <asp:SqlDataSource ID="SqlDsCustomers" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT CustomerID, fname, lname, email, PhoneNumber, dtRegistered FROM dbo.tblCustomers ORDER BY CustomerID DESC"
        OnSelecting="SqlDsCustomers_Selecting">
    </asp:SqlDataSource>

    <script>
        function showModal(modalId) {
            var el = document.getElementById(modalId);
            if (!el) return false;
            var modal = new bootstrap.Modal(el);
            modal.show();
            return false;
        }
    </script>
</asp:Content>

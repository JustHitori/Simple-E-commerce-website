<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="manageAddress.aspx.cs" Inherits="mwmasm.manageAddress" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="manage-addresses-page">
        <h2 class="mb-4">Manage Addresses</h2>

        <asp:Label ID="lblError" runat="server" CssClass="text-danger mb-3" Visible="false"></asp:Label>
        <asp:Label ID="lblSuccess" runat="server" CssClass="text-success mb-3" Visible="false"></asp:Label>
        <br /> 

        <asp:HyperLink NavigateUrl="~/payment.aspx" runat="server">Back to Payment</asp:HyperLink>

        <!-- Hidden field to store address ID for deletion -->
        <asp:HiddenField ID="hidAddressIdToDelete" runat="server" />

        <!-- Existing Addresses List -->
        <asp:Repeater ID="rptAddresses" runat="server" OnItemCommand="rptAddresses_ItemCommand" OnItemDataBound="rptAddresses_ItemDataBound">
            <ItemTemplate>
                <div class="address-card-collapsible mb-3">
                    <!-- Collapsed Header (Clickable) -->
                    <div class="address-card-header" 
                         data-bs-toggle="collapse" 
                         data-bs-target='#collapseAddress<%# Eval("AddressId") %>' 
                         aria-expanded="false" 
                         aria-controls='collapseAddress<%# Eval("AddressId") %>'>
                        <div class="address-label">
                            <div class="address-label-text"><%# Eval("Label") %></div>
                            <div class="address-full-text"><%# Eval("FullAddress") %></div>
                        </div>
                        <div class="address-chevron">
                            <span class="chevron-icon">▼</span>
                        </div>
                    </div>

                    <!-- Collapsible Form Content -->
                    <div class="collapse" id='collapseAddress<%# Eval("AddressId") %>'>
                        <div class="address-form-card card">
                            <div class="card-body">
                                <div class="mb-3">
                                    <asp:Label ID="lblLabel" runat="server" Text="Address Label" CssClass="form-label" AssociatedControlID="txtLabel" />
                                    <asp:TextBox ID="txtLabel" runat="server" CssClass="form-control" Text='<%# Eval("Label") %>' MaxLength="50" />
                                    <asp:RequiredFieldValidator ID="rfvLabel" runat="server" 
                                        ControlToValidate="txtLabel" 
                                        ErrorMessage="Address label is required" 
                                        CssClass="text-danger small" 
                                        Display="Dynamic" />
                                </div>

                                <div class="mb-3">
                                    <asp:Label ID="lblAddressLine1" runat="server" Text="Address Line 1" CssClass="form-label" AssociatedControlID="txtAddressLine1" />
                                    <asp:TextBox ID="txtAddressLine1" runat="server" CssClass="form-control" Text='<%# Eval("AddressLine1") %>' MaxLength="200" />
                                    <asp:RequiredFieldValidator ID="rfvAddressLine1" runat="server" 
                                        ControlToValidate="txtAddressLine1" 
                                        ErrorMessage="Address line 1 is required" 
                                        CssClass="text-danger small" 
                                        Display="Dynamic" />
                                </div>

                                <div class="mb-3">
                                    <asp:Label ID="lblAddressLine2" runat="server" Text="Address Line 2 (Optional)" CssClass="form-label" AssociatedControlID="txtAddressLine2" />
                                    <asp:TextBox ID="txtAddressLine2" runat="server" CssClass="form-control" Text='<%# Eval("AddressLine2") != DBNull.Value ? Eval("AddressLine2").ToString() : "" %>' MaxLength="200" />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <asp:Label ID="lblCity" runat="server" Text="City" CssClass="form-label" AssociatedControlID="txtCity" />
                                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" Text='<%# Eval("City") %>' MaxLength="100" />
                                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" 
                                            ControlToValidate="txtCity" 
                                            ErrorMessage="City is required" 
                                            CssClass="text-danger small" 
                                            Display="Dynamic" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <asp:Label ID="lblState" runat="server" Text="State" CssClass="form-label" AssociatedControlID="txtState" />
                                        <asp:TextBox ID="txtState" runat="server" CssClass="form-control" Text='<%# Eval("State") %>' MaxLength="100" />
                                        <asp:RequiredFieldValidator ID="rfvState" runat="server" 
                                            ControlToValidate="txtState" 
                                            ErrorMessage="State is required" 
                                            CssClass="text-danger small" 
                                            Display="Dynamic" />
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <asp:Label ID="lblPostcode" runat="server" Text="Postcode" CssClass="form-label" AssociatedControlID="txtPostcode" />
                                        <asp:TextBox ID="txtPostcode" runat="server" CssClass="form-control" Text='<%# Eval("Postcode") %>' MaxLength="20" />
                                        <asp:RequiredFieldValidator ID="rfvPostcode" runat="server" 
                                            ControlToValidate="txtPostcode" 
                                            ErrorMessage="Postcode is required" 
                                            CssClass="text-danger small" 
                                            Display="Dynamic" />
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <asp:Label ID="lblCountry" runat="server" Text="Country" CssClass="form-label" AssociatedControlID="txtCountry" />
                                        <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" Text='<%# Eval("Country") %>' MaxLength="100" />
                                        <asp:RequiredFieldValidator ID="rfvCountry" runat="server" 
                                            ControlToValidate="txtCountry" 
                                            ErrorMessage="Country is required" 
                                            CssClass="text-danger small" 
                                            Display="Dynamic" />
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <div class="form-check ps-0">
                                        <asp:CheckBox ID="chkIsDefault" runat="server" Checked='<%# Eval("IsDefault") != DBNull.Value && (bool)Eval("IsDefault") %>' />
                                        <asp:Label ID="lblIsDefault" runat="server" Text="Set as default address" CssClass="form-check-label" AssociatedControlID="chkIsDefault" />
                                    </div>
                                </div>

                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-dark" 
                                        CommandName="Update" CommandArgument='<%# Eval("AddressId") %>' />
                                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-secondary btn-delete-address" 
                                        CommandName="Delete" 
                                        data-address-id='<%# Eval("AddressId") %>'
                                        OnClientClick="return setDeleteAddressIdFromButton(this, 'confirmDeleteModal');" />
                                </div>

                                <asp:HiddenField ID="hidAddressId" runat="server" Value='<%# Eval("AddressId") %>' />
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Add New Address Button -->
        <div class="mb-3">
            <asp:Button ID="btnShowAddForm" runat="server" Text="Add Address" CssClass="btn btn-dark w-100 custom-width py-4" OnClick="btnShowAddForm_Click" />
        </div>

        <!-- Add New Address Form (Hidden by default) -->
        <asp:Panel ID="pnlAddAddress" runat="server" Visible="false">
            <div class="address-form-card card mb-3">
                <div class="card-header">
                    <h5 class="mb-0">Add New Address</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <asp:Label ID="lblNewLabel" runat="server" Text="Address Label" CssClass="form-label" AssociatedControlID="txtNewLabel" />
                        <asp:TextBox ID="txtNewLabel" runat="server" CssClass="form-control" placeholder="e.g., Home, Office, etc." MaxLength="50" />
                        <asp:RequiredFieldValidator ID="rfvNewLabel" runat="server" 
                            ControlToValidate="txtNewLabel" 
                            ErrorMessage="Address label is required" 
                            CssClass="text-danger small" 
                            Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblNewAddressLine1" runat="server" Text="Address Line 1" CssClass="form-label" AssociatedControlID="txtNewAddressLine1" />
                        <asp:TextBox ID="txtNewAddressLine1" runat="server" CssClass="form-control" placeholder="Street address" MaxLength="200" />
                        <asp:RequiredFieldValidator ID="rfvNewAddressLine1" runat="server" 
                            ControlToValidate="txtNewAddressLine1" 
                            ErrorMessage="Address line 1 is required" 
                            CssClass="text-danger small" 
                            Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblNewAddressLine2" runat="server" Text="Address Line 2 (Optional)" CssClass="form-label" AssociatedControlID="txtNewAddressLine2" />
                        <asp:TextBox ID="txtNewAddressLine2" runat="server" CssClass="form-control" placeholder="Apartment, suite, etc." MaxLength="200" />
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label ID="lblNewCity" runat="server" Text="City" CssClass="form-label" AssociatedControlID="txtNewCity" />
                            <asp:TextBox ID="txtNewCity" runat="server" CssClass="form-control" placeholder="City" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvNewCity" runat="server" 
                                ControlToValidate="txtNewCity" 
                                ErrorMessage="City is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label ID="lblNewState" runat="server" Text="State" CssClass="form-label" AssociatedControlID="txtNewState" />
                            <asp:TextBox ID="txtNewState" runat="server" CssClass="form-control" placeholder="State" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvNewState" runat="server" 
                                ControlToValidate="txtNewState" 
                                ErrorMessage="State is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <asp:Label ID="lblNewPostcode" runat="server" Text="Postcode" CssClass="form-label" AssociatedControlID="txtNewPostcode" />
                            <asp:TextBox ID="txtNewPostcode" runat="server" CssClass="form-control" placeholder="Postcode" MaxLength="20" />
                            <asp:RequiredFieldValidator ID="rfvNewPostcode" runat="server" 
                                ControlToValidate="txtNewPostcode" 
                                ErrorMessage="Postcode is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <asp:Label ID="lblNewCountry" runat="server" Text="Country" CssClass="form-label" AssociatedControlID="txtNewCountry" />
                            <asp:TextBox ID="txtNewCountry" runat="server" CssClass="form-control" Text="Malaysia" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvNewCountry" runat="server" 
                                ControlToValidate="txtNewCountry" 
                                ErrorMessage="Country is required" 
                                CssClass="text-danger small" 
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-check">
                            <asp:CheckBox ID="chkNewIsDefault" runat="server" />
                            <asp:Label ID="lblNewIsDefault" runat="server" Text="Set as default address" CssClass="form-check-label" AssociatedControlID="chkNewIsDefault" />
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <asp:Button ID="btnAddNew" runat="server" Text="Add Address" CssClass="btn btn-dark flex-grow-1" OnClick="btnAddNew_Click" />
                        <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancelAdd_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

         <!-- Modal for delete confirmation -->
     <div class="modal" tabindex="-1" id="confirmDeleteModal" aria-hidden="true">
       <div class="modal-dialog">
         <div class="modal-content">
           <div class="modal-header">
               <h5 class="modal-title">Delete Address</h5>
           </div>
           <div class="modal-body">
             <p>Are you sure you want to delete this address?</p>
           </div>
           <div class="modal-footer">
            <asp:Button ID="btnConfirmDelete" runat="server"
             Text="Yes"
             CssClass="btn btn-primary"
             OnClick="btnConfirmDelete_Click"
             CausesValidation="false" />
             <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
           </div>
         </div>
       </div>
     </div>

    <style>
        .manage-addresses-page {
            max-width: 800px;
            margin: 0 auto;
        }
        
        /* Collapsible Address Card Header */
        .address-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .address-card-header:hover {
            background-color: #f8f9fa;
            border-color: #212529;
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

        .address-chevron {
            margin-left: 12px;
            color: #6c757d;
            transition: transform 0.3s ease;
            font-size: 12px;
        }

        .address-card-header[aria-expanded="true"] .address-chevron {
            transform: rotate(180deg);
        }

        .address-form-card {
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #ddd;
            padding: 1rem;
            border-radius: 8px 8px 0 0;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .gap-2 {
            gap: 0.5rem;
        }
        
        .custom-width {
            max-width: none;
            margin: 0 auto;
        }
    </style>

    <script>
        function setDeleteAddressIdFromButton(button, modalId) {
            // Get the address ID from the button's data attribute
            var addressId = button.getAttribute('data-address-id');
            if (!addressId) {
                return false;
            }
            
            // Store the address ID in the hidden field
            var hidField = document.getElementById('<%= hidAddressIdToDelete.ClientID %>');
            if (hidField) {
                hidField.value = addressId;
            }
            
            // Show the modal
            var el = document.getElementById(modalId);
            if (!el) return false;
            var modal = new bootstrap.Modal(el);
            modal.show();
            return false;
        }
    </script>
</asp:Content>

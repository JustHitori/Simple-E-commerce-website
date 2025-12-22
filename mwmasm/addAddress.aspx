<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="addAddress.aspx.cs" Inherits="mwmasm.addAddress" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="add-address-page">
        <div class="card">
            <div class="card-header">
                <h4 class="mb-0">Add New Address</h4>
            </div>
            <div class="card-body">
                <asp:Label ID="lblError" runat="server" CssClass="text-danger mb-3" Visible="false"></asp:Label>
                
                <div class="mb-3">
                    <asp:Label ID="lblLabel" runat="server" Text="Address Label" CssClass="form-label" AssociatedControlID="txtLabel" />
                    <asp:TextBox ID="txtLabel" runat="server" CssClass="form-control" placeholder="e.g., Home, Office, etc." MaxLength="50" />
                    <asp:RequiredFieldValidator ID="rfvLabel" runat="server" 
                        ControlToValidate="txtLabel" 
                        ErrorMessage="Address label is required" 
                        CssClass="text-danger small" 
                        Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <asp:Label ID="lblAddressLine1" runat="server" Text="Address Line 1" CssClass="form-label" AssociatedControlID="txtAddressLine1" />
                    <asp:TextBox ID="txtAddressLine1" runat="server" CssClass="form-control" placeholder="Street address" MaxLength="200" />
                    <asp:RequiredFieldValidator ID="rfvAddressLine1" runat="server" 
                        ControlToValidate="txtAddressLine1" 
                        ErrorMessage="Address line 1 is required" 
                        CssClass="text-danger small" 
                        Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <asp:Label ID="lblAddressLine2" runat="server" Text="Address Line 2 (Optional)" CssClass="form-label" AssociatedControlID="txtAddressLine2" />
                    <asp:TextBox ID="txtAddressLine2" runat="server" CssClass="form-control" placeholder="Apartment, suite, etc." MaxLength="200" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblCity" runat="server" Text="City" CssClass="form-label" AssociatedControlID="txtCity" />
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="City" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvCity" runat="server" 
                            ControlToValidate="txtCity" 
                            ErrorMessage="City is required" 
                            CssClass="text-danger small" 
                            Display="Dynamic" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblState" runat="server" Text="State" CssClass="form-label" AssociatedControlID="txtState" />
                        <asp:TextBox ID="txtState" runat="server" CssClass="form-control" placeholder="State" MaxLength="100" />
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
                        <asp:TextBox ID="txtPostcode" runat="server" CssClass="form-control" placeholder="Postcode" MaxLength="20" />
                        <asp:RequiredFieldValidator ID="rfvPostcode" runat="server" 
                            ControlToValidate="txtPostcode" 
                            ErrorMessage="Postcode is required" 
                            CssClass="text-danger small" 
                            Display="Dynamic" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblCountry" runat="server" Text="Country" CssClass="form-label" AssociatedControlID="txtCountry" />
                        <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" Text="Malaysia" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvCountry" runat="server" 
                            ControlToValidate="txtCountry" 
                            ErrorMessage="Country is required" 
                            CssClass="text-danger small" 
                            Display="Dynamic" />
                    </div>
                </div>

                <div class="mb-3">
                    <div class="">
                        <asp:CheckBox ID="chkIsDefault" runat="server" />
                        <asp:Label ID="lblIsDefault" runat="server" Text="Set as default address" CssClass="form-check-label" AssociatedControlID="chkIsDefault" />
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <asp:Button ID="btnAdd" runat="server" Text="Add Address" CssClass="btn btn-dark flex-grow-1" OnClick="btnAdd_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .add-address-page {
            max-width: 600px;
            margin: 0 auto;
        }
        .card {
            border: 1px solid #ddd;
            border-radius: 8px;
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
    </style>
</asp:Content>

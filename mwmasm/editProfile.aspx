<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="editProfile.aspx.cs" Inherits="mwmasm.editProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="edit-profile-page">
        <!-- Back Button -->
        <div class="back-button-container">
            <asp:HyperLink ID="hlBack" runat="server" 
                NavigateUrl="~/Default.aspx" 
                CssClass="back-button">
                ← Back
            </asp:HyperLink>
        </div>
        
        <!-- First Card - Personal Information -->
        <div class="profile-card">
            <div class="profile-field">
                <asp:Label ID="lblFirstName" runat="server" Text="First Name" CssClass="field-label"></asp:Label>
                <div class="field-content">
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="field-input" placeholder="First Name"></asp:TextBox>
                    <span class="field-arrow">›</span>
                </div>
            </div>
            <div class="field-divider"></div>
            <div class="profile-field">
                <asp:Label ID="lblLastName" runat="server" Text="Last Name" CssClass="field-label"></asp:Label>
                <div class="field-content">
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="field-input" placeholder="Last Name"></asp:TextBox>
                    <span class="field-arrow">›</span>
                </div>
            </div>
        </div>

        <!-- Second Card - Contact Information -->
        <div class="profile-card">
            <div class="profile-field">
                <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="field-label"></asp:Label>
                <div class="field-content">
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="field-input" placeholder="Email"></asp:TextBox>
                    <span class="field-arrow">›</span>
                </div>
            </div>
            <div class="field-divider"></div>
            <div class="profile-field">
                <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="field-label"></asp:Label>
                <div class="field-content">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="field-input" placeholder="Leave blank to keep current password"></asp:TextBox>
                    <span class="field-arrow">›</span>
                </div>
            </div>
            <div class="field-divider"></div>
            <div class="profile-field">
                <asp:Label ID="lblPhoneNumber" runat="server" Text="Phone Number" CssClass="field-label"></asp:Label>
                <div class="field-content">
                    <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="field-input" placeholder="Phone Number"></asp:TextBox>
                    <span class="field-arrow">›</span>
                </div>
            </div>
        </div>

        <!-- Error/Success Messages -->
        <asp:Label ID="lblMessage" runat="server" CssClass="message-label" EnableViewState="false"></asp:Label>

        <!-- Validation Messages -->
        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
            ControlToValidate="txtFirstName"
            ErrorMessage="First name is required."
            Display="Dynamic"
            CssClass="text-danger" />
        <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
            ControlToValidate="txtLastName"
            ErrorMessage="Last name is required."
            Display="Dynamic"
            CssClass="text-danger" />
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
            ControlToValidate="txtEmail"
            ErrorMessage="Email is required."
            Display="Dynamic"
            CssClass="text-danger" />
        <asp:RegularExpressionValidator ID="revEmail" runat="server"
            ControlToValidate="txtEmail"
            ErrorMessage="Please enter a valid email."
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
            Display="Dynamic"
            CssClass="text-danger" />
        <asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server"
            ControlToValidate="txtPhoneNumber"
            ErrorMessage="Phone number is required."
            Display="Dynamic"
            CssClass="text-danger" />

        <!-- Save Button -->
        <div class="button-container d-flex justify-content-center">
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" OnClick="btnSave_Click" CssClass="btn-save" />
        </div>
    </div>

    <style>
        .edit-profile-page {
            padding: 16px;
            background-color: #f5f5f5;
            min-height: calc(100vh - 100px);
        }

        .back-button-container {
            margin-bottom: 16px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            color: #212529;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            padding: 8px 0;
            transition: color 0.2s ease;
        }

        .back-button:hover {
            color: #000000;
            text-decoration: none;
        }

        .profile-card {
            background-color: #ffffff;
            border-radius: 12px;
            margin-bottom: 16px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        }

        .profile-field {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px;
            min-height: 56px;
        }

        .field-label {
            font-size: 16px;
            font-weight: 400;
            color: #212529;
            flex-shrink: 0;
            min-width: 120px;
        }

        .field-content {
            display: flex;
            align-items: center;
            flex: 1;
            justify-content: flex-end;
            gap: 8px;
        }

        .field-input {
            border: none;
            outline: none;
            background: transparent;
            font-size: 16px;
            color: #212529;
            text-align: right;
            flex: 1;
            max-width: 200px;
        }

        .field-input::placeholder {
            color: #6c757d;
        }

        .field-arrow {
            font-size: 20px;
            color: #212529;
            font-weight: 300;
            flex-shrink: 0;
        }

        .field-divider {
            height: 1px;
            background-color: #e9ecef;
            margin: 0 16px;
        }

        .message-label {
            display: block;
            text-align: center;
            padding: 12px;
            margin: 16px 0;
            border-radius: 8px;
            font-size: 14px;
        }

        .message-label.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-label.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .text-danger {
            color: #dc3545;
            font-size: 14px;
            display: block;
            padding: 8px 16px;
            text-align: center;
        }

        .button-container {
            padding: 16px;
        }

        .btn-save {
            width: 100%;
            padding: 14px;
            background-color: #212529;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-save:hover {
            background-color: #000000;
        }

        .btn-save:active {
            transform: scale(0.98);
        }

        @media (min-width: 768px) {
            .edit-profile-page {
                max-width: 600px;
                margin: 0 auto;
                padding: 24px;
            }

            .field-label {
                min-width: 150px;
            }

            .field-input {
                max-width: 300px;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            var messageLabel = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageLabel && messageLabel.textContent.trim() !== '') {
                setTimeout(function() {
                    messageLabel.style.display = 'none';
                }, 3000);
            }
        });
    </script>
</asp:Content>
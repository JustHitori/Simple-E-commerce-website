<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="mwmasm.register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="register-page">
        <div class="register-card">
            <h1 class="register-title">Register</h1>
            
            <div class="register-form">
                <!-- First Name Field -->
                <div class="form-group">
                    <asp:Label ID="lblFirstName" runat="server" Text="First Name" AssociatedControlID="txtFirstName" CssClass="form-label">
                        First Name <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control-input" placeholder="First Name" />
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                        ControlToValidate="txtFirstName" 
                        ErrorMessage="First name is required." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                </div>

                <!-- Last Name Field -->
                <div class="form-group">
                    <asp:Label ID="lblLastName" runat="server" Text="Last Name" AssociatedControlID="txtLastName" CssClass="form-label">
                        Last Name <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control-input" placeholder="Last Name" />
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                        ControlToValidate="txtLastName" 
                        ErrorMessage="Last name is required." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                </div>

                <!-- Email Field -->
                <div class="form-group">
                    <asp:Label ID="lblEmail" runat="server" Text="Email" AssociatedControlID="txtEmail" CssClass="form-label">
                        Email <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" 
                        TextMode="Email" 
                        CssClass="form-control-input" 
                        placeholder="Email" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail" 
                        ErrorMessage="Email is required." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Please enter a valid email."
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                </div>

                <!-- Password Field -->
                <div class="form-group">
                    <asp:Label ID="lblPassword" runat="server" Text="Password" AssociatedControlID="txtPassword" CssClass="form-label">
                        Password <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtPassword" runat="server" 
                        TextMode="Password" 
                        CssClass="form-control-input" 
                        placeholder="Password" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword" 
                        ErrorMessage="Password is required." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                </div>

                <!-- Confirm Password Field -->
                <div class="form-group">
                    <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password" AssociatedControlID="txtConfirmPassword" CssClass="form-label">
                        Confirm Password <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" 
                        TextMode="Password" 
                        CssClass="form-control-input" 
                        placeholder="Confirm Password" />
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                        ControlToValidate="txtConfirmPassword" 
                        ErrorMessage="Please confirm your password." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                    <asp:CompareValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        Operator="Equal"
                        ErrorMessage="Passwords do not match."
                        Display="Dynamic"
                        CssClass="text-danger small" />
                </div>

                <!-- Phone Number Field -->
                <div class="form-group">
                    <asp:Label ID="lblPhone" runat="server" Text="Phone Number" AssociatedControlID="txtPhone" CssClass="form-label">
                        Phone Number <span class="required">*</span>
                    </asp:Label>
                    <asp:TextBox ID="txtPhone" runat="server" 
                        CssClass="form-control-input" 
                        placeholder="Phone Number" />
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                        ControlToValidate="txtPhone" 
                        ErrorMessage="Phone number is required." 
                        Display="Dynamic" 
                        CssClass="text-danger small" />
                </div>

                <!-- Error Message -->
                <asp:Label ID="lblResult" runat="server" 
                    CssClass="error-message" 
                    EnableViewState="false" />

                <!-- Register Button -->
                <asp:Button ID="btnRegister" runat="server" 
                    Text="Register" 
                    OnClick="btnRegister_Click" 
                    CssClass="btn-register" />

                <!-- Login Link -->
                <div class="login-link">
                    <span>Already have an account? </span>
                    <asp:HyperLink ID="hlLogin" runat="server" 
                        NavigateUrl="~/login.aspx" 
                        Text="Login" 
                        CssClass="login-link-text" />
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 25%, #2d2d2d 50%, #1a1a1a 75%, #000000 100%);
            background-size: 400% 400%;
            background-attachment: fixed;
            animation: gradientShift 15s ease infinite;
            margin: 0;
            padding: 0;
        }

        .body-content {
            background: transparent !important;
        }

        .container.body-content {
            background: transparent !important;
            padding: 0 !important;
            margin: 0 !important;
            max-width: 100% !important;
            width: 100% !important;
        }

        .register-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            background: linear-gradient(135deg, #000000 0%, #1a1a1a 25%, #2d2d2d 50%, #1a1a1a 75%, #000000 100%);
            background-size: 400% 400%;
            background-attachment: fixed;
            animation: gradientShift 15s ease infinite;
            margin: 0;
            box-sizing: border-box;
            width: 100%;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .register-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
        }

        .register-title {
            font-size: 2rem;
            font-weight: 700;
            color: #212529;
            text-align: center;
            margin-bottom: 2rem;
            letter-spacing: 1px;
        }

        .register-form {
            display: flex;
            flex-direction: column;
            gap: 1.25rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-label {
            font-size: 0.9rem;
            font-weight: 500;
            color: #212529;
            margin: 0;
        }

        .required {
            color: #dc3545;
            font-weight: 600;
        }

        .form-control-input {
            width: 100%;
            padding: 0.75rem 1rem;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            font-size: 1rem;
            color: #212529;
            box-sizing: border-box;
            transition: border-color 0.3s ease;
        }

        .form-control-input:focus {
            outline: none;
            border-color: #212529;
            background-color: #ffffff;
        }

        .form-control-input::placeholder {
            color: #adb5bd;
        }

        .btn-register {
            width: 100%;
            padding: 0.875rem;
            background: linear-gradient(135deg, #212529 0%, #000000 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 0.5rem;
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #000000 0%, #212529 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            text-align: center;
            margin-top: 0.5rem;
        }

        .login-link {
            text-align: center;
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 1rem;
        }

        .login-link-text {
            color: #212529;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link-text:hover {
            text-decoration: underline;
            color: #000000;
        }

        .text-danger {
            color: #dc3545;
            font-size: 0.875rem;
            display: block;
            margin-top: 0.25rem;
        }

        hr {
            display: none;
        }

        footer {
            display: none;
        }

        @media (max-width: 576px) {
            .register-page {
                align-items: flex-start;
                padding-top: 3rem;
                min-height: 100vh;
            }

            .register-card {
                padding: 2rem 1.5rem;
                margin-top: 2rem;
            }

            .register-title {
                font-size: 1.75rem;
            }
        }
    </style>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" 
        SelectCommand="SELECT * FROM [tblCustomers]" 
        InsertCommand="INSERT INTO [dbo].[tblCustomers] ([fname], [lname], [email], [password], [PhoneNumber])
                       VALUES (@fname, @lname, @email, @password, @PhoneNumber)"
        UpdateCommand="UPDATE [dbo].[tblCustomers]
                       SET [fname] = @fname,
                           [lname] = @lname,
                           [email] = @email,
                           [password] = @password,
                           [PhoneNumber] = @PhoneNumber
                       WHERE [CustomerID] = @CustomerID"
        DeleteCommand="DELETE FROM [dbo].[tblCustomers]
                       WHERE [CustomerID] = @CustomerID">
        <DeleteParameters>
            <asp:Parameter Name="CustomerID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:ControlParameter ControlID="txtFirstName" Name="fname" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtLastName" Name="lname" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtEmail" Name="email" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtPassword" Name="password" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtPhone" Name="PhoneNumber" PropertyName="Text" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="fname" Type="String" />
            <asp:Parameter Name="lname" Type="String" />
            <asp:Parameter Name="email" Type="String" />
            <asp:Parameter Name="password" Type="String" />
            <asp:Parameter Name="PhoneNumber" Type="String" />
            <asp:Parameter Name="CustomerID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
</asp:Content>

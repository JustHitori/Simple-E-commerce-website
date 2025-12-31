<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="mwmasm.login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-page">
        <div class="login-card">
            <h1 class="login-title">LOGIN</h1>
            
            <div class="login-form">
                <!-- Email Field -->
                <div class="input-group-custom">
                    <span class="input-icon">✉</span>
                    <asp:TextBox ID="txtEmail" runat="server" 
                        TextMode="Email" 
                        CssClass="form-control-custom" 
                        placeholder="Email" />
                </div>
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

                <!-- Password Field -->
                <div class="input-group-custom">
                    <span class="input-icon">🔒</span>
                    <asp:TextBox ID="txtPassword" runat="server" 
                        TextMode="Password" 
                        CssClass="form-control-custom" 
                        placeholder="Password" />
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="txtPassword" 
                    ErrorMessage="Password is required." 
                    Display="Dynamic" 
                    CssClass="text-danger small" />

                <!-- Login Button -->
                <asp:Button ID="btnLogin" runat="server" 
                    Text="LOGIN" 
                    OnClick="btnLogin_Click" 
                    CssClass="btn-login" />

                <!-- Error Message -->
                <asp:Label ID="lblError" runat="server" 
                    CssClass="error-message" 
                    EnableViewState="false" />

                <!-- Sign Up Link -->
                <div class="signup-link">
                    <span>Not a member? </span>
                    <asp:HyperLink ID="hlRegister" runat="server" 
                        NavigateUrl="~/register.aspx" 
                        Text="Sign up now" 
                        CssClass="signup-link-text" />
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
        }

        .login-page {
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

        .navbar {
            background-color: #212529 !important;
        }

        hr {
            display: none;
        }

        footer {
            display: none;
        }

        .login-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
        }

        .login-title {
            font-size: 2rem;
            font-weight: 700;
            color: #212529;
            text-align: center;
            margin-bottom: 2rem;
            letter-spacing: 1px;
        }

        .login-form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .input-group-custom {
            position: relative;
            display: flex;
            align-items: center;
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            border: 1px solid #e9ecef;
        }

        .input-icon {
            font-size: 1.2rem;
            margin-right: 0.75rem;
            color: #6c757d;
            display: flex;
            align-items: center;
        }

        .form-control-custom {
            border: none;
            background: transparent;
            outline: none;
            flex: 1;
            font-size: 1rem;
            color: #212529;
            padding: 0;
        }

        .form-control-custom::placeholder {
            color: #adb5bd;
        }

        .form-control-custom:focus {
            outline: none;
        }

        .btn-login {
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

        .btn-login:hover {
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

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
        }


        .signup-link {
            text-align: center;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .signup-link-text {
            color: #212529;
            text-decoration: none;
            font-weight: 500;
        }

        .signup-link-text:hover {
            text-decoration: underline;
            color: #000000;
        }

        .text-danger {
            color: #dc3545;
            font-size: 0.875rem;
            display: block;
            margin-top: 0.25rem;
        }

        @media (max-width: 576px) {
            .login-page {
                align-items: flex-start;
                padding-top: 3rem;
                min-height: 100vh;
            }

            .login-card {
                padding: 2rem 1.5rem;
                margin-top: 2rem;
            }

            .login-title {
                font-size: 1.75rem;
            }
        }
    </style>
</asp:Content>

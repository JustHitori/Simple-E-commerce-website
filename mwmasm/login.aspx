<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="mwmasm.login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Login</h1>

    <div>
        <!--Email -->
        <asp:Label ID="lblEmail" runat="server" Text="Email" AssociatedControlID="txtEmail" />
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
            ControlToValidate="txtEmail" ErrorMessage="Email is required." Display="Dynamic" ForeColor="Red" />
        <asp:RegularExpressionValidator ID="revEmail" runat="server"
            ControlToValidate="txtEmail"
            ErrorMessage="Please enter a valid email."
            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" Display="Dynamic" ForeColor="Red" />
        <br />

        <!--Password -->
        <asp:Label ID="lblPassword" runat="server" Text="Password" AssociatedControlID="txtPassword" />
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
            ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic" ForeColor="Red" />
        <br />

        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn btn-primary d-block mb-3" />
        <div>
            <label>Dont have an account yet?</label>
            <asp:HyperLink ID="hlRegister" runat="server" NavigateUrl="~/register.aspx" Text="Register" CssClass="btn btn-link p-0" /> 
        </div>
        <asp:Label ID="lblError" runat="server" ForeColor="Red" EnableViewState="false" />
    </div>

</asp:Content>

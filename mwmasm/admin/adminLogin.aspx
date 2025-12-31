<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="adminLogin.aspx.cs" Inherits="mwmasm.admin.adminLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Admin Login</h1>

    <div>
        <!--Username -->
        <asp:Label ID="lblUsername" runat="server" Text="Username" AssociatedControlID="txtUsername" />
        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
            ControlToValidate="txtUsername" ErrorMessage="Username is required." Display="Dynamic" ForeColor="Red" />
        <br />

        <!--Password -->
        <asp:Label ID="lblPassword" runat="server" Text="Password" AssociatedControlID="txtPassword" />
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
            ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic" ForeColor="Red" />
        <br />

        <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn btn-primary d-block mb-3" />
        
        <asp:Label ID="lblError" runat="server" ForeColor="Red" EnableViewState="false" />
    </div>

</asp:Content>

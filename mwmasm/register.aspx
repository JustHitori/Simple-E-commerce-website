<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="mwmasm.register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h2>Registration</h2>

        <asp:Label ID="lblFirstName" runat="server" Text="First Name:" AssociatedControlID="txtFirstName" /><br />
        <asp:TextBox ID="txtFirstName" runat="server" /><br /><br />
 
        <asp:Label ID="lblLastName" runat="server" Text="Last Name:" AssociatedControlID="txtLastName" /><br />
        <asp:TextBox ID="txtLastName" runat="server" /><br /><br />
 
        <asp:Label ID="lblEmail" runat="server" Text="Email Address:" AssociatedControlID="txtEmail" /><br />
        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" /><br /><br />
 
        <asp:Label ID="lblPassword" runat="server" Text="Password:" AssociatedControlID="txtPassword" /><br />
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" /><br /><br />
 
        <asp:Label ID="lblPhone" runat="server" Text="Phone Number:" AssociatedControlID="txtPhone" /><br />
        <asp:TextBox ID="txtPhone" runat="server" /><br /><br />
 
        <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" /><br /><br />

        <asp:Label ID="lblResult" runat="server" ForeColor="Red" /><br /><br />

        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" 
        SelectCommand="SELECT * FROM [tblCustomers]" InsertCommand="INSERT INTO [dbo].[tblCustomers] ([fname], [lname], [email], [password], [PhoneNumber])

                       VALUES (@fname, @lname, @email, @password, @PhoneNumber)"
        UpdateCommand="UPDATE [dbo].[tblCustomers]
                       SET [fname] = @fname,
                           [lname] = @lname,
                           [email] = @email,
                           [password] = @password,
                           [PhoneNumber] = @PhoneNumber
                       WHERE [CustomerID] = @CustomerID"

        DeleteCommand="DELETE FROM [dbo].[tblCustomers]
                       WHERE [CustomerID] = @CustomerID" >

        <DeleteParameters>
            <asp:Parameter Name="CustomerID" Type="Int32" />
        </DeleteParameters>

        <InsertParameters>
            <asp:ControlParameter ControlID="txtFirstName" Name="fname" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtLastName"  Name="lname" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtEmail"     Name="email" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtPassword"  Name="password" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtPhone"     Name="PhoneNumber" PropertyName="Text" Type="String" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="fname"       Type="String" />
            <asp:Parameter Name="lname"       Type="String" />
            <asp:Parameter Name="email"       Type="String" />
            <asp:Parameter Name="password"    Type="String" />
            <asp:Parameter Name="PhoneNumber" Type="String" />
            <asp:Parameter Name="CustomerID"  Type="Int32" />
        </UpdateParameters>

        </asp:SqlDataSource>
        </div>
</asp:Content>

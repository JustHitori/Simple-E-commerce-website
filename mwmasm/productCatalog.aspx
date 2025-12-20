<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="productCatalog.aspx.cs" Inherits="mwmasm.productCatalog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Product Catalog</h1>

    <!--dropdownlist for category selection -->
    <asp:DropDownList ID="ddlCategories" runat="server"
        DataSourceID="SqlDsCategories"
        DataTextField="name"
        DataValueField="categoryId"
        CssClass="form-select mb-3 mt-4"
        AutoPostBack="true"
        AppendDataBoundItems="true">
        <asp:ListItem Text="-- All Categories --" Value="0" />
    </asp:DropDownList>


    <asp:ListView ID="productListView" runat="server" DataKeyNames="productId" DataSourceID="SqlDsProducts">
        <LayoutTemplate>
            <div class="catalog-grid">
                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
            </div>
        </LayoutTemplate>

        <ItemTemplate>
            <asp:HyperLink ID="productLink" runat="server" NavigateUrl='<%# "productDetails.aspx?productId=" + Eval("productId") %>' CssClass="text-decoration-none text-black">
                    <div style="width:180px">
                        <asp:Image ID="productImage" runat="server"
                            ImageUrl='<%# Eval("imageUrl") %>'
                            AlternateText='<%# Eval("name") %>'
                            Width="180" Height="180" />
                        <div style="margin-top:8px;font-weight:bold;font-size:32px;">
                            <%# Eval("name") %>
                        </div>
                    <div>
                        <%# "RM " + string.Format("{0:N2}", Eval("price")) %>
                    </div>
                </div>
            </asp:HyperLink>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="text-muted">No products found.</div>
        </EmptyDataTemplate>
    </asp:ListView>


     <asp:SqlDataSource ID="SqlDsCategories" runat="server"
     ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
     SelectCommand="SELECT categoryId, name FROM dbo.tblCategories ORDER BY name" />

    <asp:SqlDataSource ID="SqlDsProducts" runat="server"
     ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
     SelectCommand="SELECT productId, categoryId, name, description, price, imageUrl, stockQuantity, dtAdded 
                    FROM dbo.tblProducts WHERE (categoryId = @categoryId OR @categoryId=0 OR @categoryId IS NULL) ORDER BY dtAdded DESC"
     CancelSelectOnNullParameter="false">
        <SelectParameters>
            <asp:ControlParameter Name="categoryId" ControlID="ddlCategories" PropertyName="SelectedValue" Type="Int32" DefaultValue="0"/>
        </SelectParameters>
    </asp:SqlDataSource>

    <style>
        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 16px;
        }
    </style>
</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="productDetails.aspx.cs" Inherits="mwmasm.productDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<asp:FormView ID="fvProduct" runat="server"
        DataSourceID="SqlDsProduct" DataKeyNames="productId" DefaultMode="ReadOnly">
        <ItemTemplate>
            <!-- Hidden fields for code-behind -->
            <asp:HiddenField ID="hidProductId" runat="server" Value='<%# Eval("productId") %>' />
            <asp:HiddenField ID="hidName" runat="server" Value='<%# Eval("name") %>' />
            <asp:HiddenField ID="hidPrice" runat="server" Value='<%# Eval("price") %>' />
            <asp:HiddenField ID="hidImage" runat="server" Value='<%# Eval("imageUrl") %>' />

            <div style="display:flex; gap:32px; align-items:flex-start;">
                <!-- Left: gallery (simple single image for now) -->
                <div>
                    <asp:Image ID="imgProduct" runat="server"
                        ImageUrl='<%# Eval("imageUrl") %>'
                        AlternateText='<%# Eval("name") %>'
                        Width="380" Height="380" />
                </div>

                <!-- Right: info + actions -->
                <div style="flex:1;">
                    <h2 style="margin-top:0;"><%# Eval("name") %></h2>
                    <div style="font-size:1.6rem; font-weight:700; margin:8px 0 16px;">
                        <%# Eval("price", "RM {0:N2}") %>
                    </div>

                    <div style="margin:12px 0 20px; color:#555;">
                        <%# Eval("description") %>
                    </div>

                    <!-- Quantity -->
                    <div style="display:flex; align-items:center; gap:12px; margin:12px 0;">
                        <label for="txtQty" style="min-width:80px;">Quantity</label>
                        <asp:TextBox ID="txtQty" runat="server" Text="1" CssClass="form-control" Width="80" />
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtQty" ErrorMessage="Qty required"
                            Display="Dynamic" ForeColor="Red" />
                        <asp:RangeValidator runat="server"
                            ControlToValidate="txtQty" MinimumValue="1" MaximumValue='<%#Eval("stockQuantity") %>'
                            Type="Integer" ErrorMessage="Exceed stock quantity"
                            Display="Dynamic" ForeColor="Red" />
                        <span style="color:#666;">Available: <%# Eval("stockQuantity") %></span>
                    </div>

                    <!-- Actions -->
                    <div style="display:flex; gap:12px; margin-top:8px;">
                        <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart"
                            CssClass="btn btn-outline-primary"
                            OnClick="btnAddToCart_Click" />
                        <asp:Button ID="btnBuyNow" runat="server" Text="Buy Now"
                            CssClass="btn btn-primary"
                            OnClick="btnBuyNow_Click" />
                    </div>

                    <asp:Label ID="lblStatus" runat="server" EnableViewState="false"
                               Style="display:block;margin-top:10px;"></asp:Label>
                </div>
            </div>
        </ItemTemplate>

        <EmptyDataTemplate>
            <div class="text-muted">Product not found.</div>
            <asp:HyperLink runat="server" NavigateUrl="productCatalog.aspx">Back to Catalog</asp:HyperLink>
        </EmptyDataTemplate>
    </asp:FormView>

    <!-- Data source: reads ?productId=... from URL -->
    <asp:SqlDataSource ID="SqlDsProduct" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="
            SELECT TOP 1 productId, name, description, price, imageUrl, stockQuantity
            FROM dbo.tblProducts
            WHERE productId = @productId">
        <SelectParameters>
            <asp:QueryStringParameter Name="productId" QueryStringField="productId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>

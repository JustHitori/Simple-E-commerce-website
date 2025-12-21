<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="manageProducts.aspx.cs" Inherits="mwmasm.manageProducts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="mb-3">Manage Products</h1>
    <!-- Add product button (enter to form) -->
        <asp:Button runat="server" Text="Add" CssClass="btn btn-primary"
            OnClientClick="return showModal('addProductModal');" />
    <!-- button trigger delete modal--> 
        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-secondary d-none" 
            CausesValidation="false" UseSubmitBehaviour="false" OnClientClick="return showModal('confirmDeleteModal');"/>
    <br /> 

    <asp:DropDownList ID="ddlCategories" runat="server"
        DataSourceID="SqlDsCategories"
        DataTextField="name"
        DataValueField="categoryId"
        CssClass="form-select mb-1 mt-4"
        AutoPostBack="true"
        AppendDataBoundItems="true">
        <asp:ListItem Text="-- Select a category --" Value="" />
    </asp:DropDownList>

    <br />

   <asp:Label ID="lblStatus" runat="server" EnableViewState="false" Style="margin-left:10px;"></asp:Label>

        <br />
    <!-- data grid / grid view for products -->
    <asp:GridView ID="gvProducts" runat="server" CssClass="table table-striped" DataSourceID="SqlDsProducts"
        AutoGenerateColumns="False" DataKeyNames="productId" OnRowUpdating="gvProducts_RowUpdating" EmptyDataText="No products found.">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:CheckBox ID="chkSelect" runat="server" CssClass="row-check" onclick="toggleDeleteButton();" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" Width="40px" />
                <HeaderStyle HorizontalAlign="Center" Width="40px" />
            </asp:TemplateField>
            <asp:BoundField DataField="productId" HeaderText="ID" />
            <asp:TemplateField HeaderText="Category ID" Visible="true" HeaderStyle-CssClass="d-none" ItemStyle-CssClass="d-none">
                <ItemTemplate>
                    <asp:Label ID="lblCatId" runat="server" Text='<%# Bind("categoryId") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="name" HeaderText="Name" />
            <asp:BoundField DataField="description" HeaderText="Description" />
            <asp:BoundField DataField="price" HeaderText="Price" DataFormatString="{0:C}" />
            <asp:BoundField DataField="stockQuantity" HeaderText="Quantity" />
            <asp:TemplateField HeaderText="Image">
              <ItemTemplate>
                <%-- show current image --%>
                <img src='<%# Eval("imageUrl") %>' alt="img" style="width:80px;height:80px;object-fit:cover" />
              </ItemTemplate>
              <EditItemTemplate>
                <%-- keep current url in a hidden field --%>
                <asp:HiddenField ID="hidCurrentImage" runat="server" Value='<%# Bind("imageUrl") %>' />
                <asp:FileUpload ID="fuEditImage" runat="server" CssClass="form-control mb-2" />
                <small class="text-muted d-block">.jpg/.jpeg/.png</small>
              </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="dtAdded" HeaderText="Added On" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:CommandField ShowEditButton="True" />
        </Columns>
    </asp:GridView>

    <!--Modal for Add products -->
    <div class="modal" tabindex="-1" id ="addProductModal" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1>Add Products</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:ValidationSummary ID="vsInsert" runat="server" ValidationGroup="InsertProd" CssClass="text-danger" />

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="txtModalName" Text="Name" />
                        <asp:TextBox ID="txtModalName" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtModalName"
                            ErrorMessage="Name is required." CssClass="text-danger" ValidationGroup="InsertProd" />
                      </div>

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="ddlModalCategory" Text="Category" />
                        <asp:DropDownList ID="ddlModalCategory" runat="server" CssClass="form-select"
                            DataSourceID="SqlDsCategories" DataTextField="name" DataValueField="categoryId"
                            AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select a category --" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlModalCategory"
                            InitialValue="" ErrorMessage="Please choose a category." CssClass="text-danger"
                            ValidationGroup="InsertProd" />
                      </div>

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="txtModalDesc" Text="Description (optional)" />
                        <asp:TextBox ID="txtModalDesc" runat="server" CssClass="form-control"
                            MaxLength="500" TextMode="MultiLine" Rows="3" />
                      </div>

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="txtModalPrice" Text="Price (RM)" />
                        <asp:TextBox ID="txtModalPrice" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtModalPrice"
                            ErrorMessage="Price is required." CssClass="text-danger" ValidationGroup="InsertProd" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtModalPrice"
                            ValidationExpression="^\d+(\.\d{1,2})?$" ErrorMessage="Invalid price (e.g. 99.99)."
                            CssClass="text-danger" ValidationGroup="InsertProd" />
                      </div>

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="txtModalStock" Text="Stock Qty" />
                        <asp:TextBox ID="txtModalStock" runat="server" CssClass="form-control" Text="0" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtModalStock"
                            ErrorMessage="Stock is required." CssClass="text-danger" ValidationGroup="InsertProd" />
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtModalStock"
                            ValidationExpression="^\d+$" ErrorMessage="Stock must be a whole number."
                            CssClass="text-danger" ValidationGroup="InsertProd" />
                      </div>

                      <div class="col-12">
                        <asp:Label runat="server" AssociatedControlID="fuImage" Text="Product Image (.jpg/.jpeg/.png)" />
                        <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
                        <asp:Label ID="lblImageError" runat="server" CssClass="text-danger"></asp:Label>
                      </div>
                    </div>

                 <div class="modal-footer">
                     <asp:Button ID="btnAddProduct" runat="server"
                         Text="Add Product"
                         CssClass="btn btn-primary"
                         OnClick="btnAddProduct_Click"
                         ValidationGroup="InsertProd"
                         UseSubmitBehavior="true"
                         CausesValidation="true" />
                 </div>
            </div>
        </div>
    </div>

    <!-- Modal for delete confirmation -->
    <div class="modal" tabindex="-1" id="confirmDeleteModal" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
              <h5 class="modal-title">Delete selected categories</h5>
          </div>
          <div class="modal-body">
            <p>Are you sure to delete this category?</p>
          </div>
          <div class="modal-footer">
           <asp:Button ID="btnConfirmDelete" runat="server"
            Text="Yes"
            CssClass="btn btn-primary"
            OnClick="btnDelete_Click"
            UseSubmitBehavior="false"
            CausesValidation="false" />
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          </div>
        </div>
      </div>
    </div>

    <asp:SqlDataSource ID="SqlDsCategories" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT categoryId, name FROM dbo.tblCategories ORDER BY name" />

    <asp:SqlDataSource ID="SqlDsProducts" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        SelectCommand="SELECT productId, categoryId, name, description, price, imageUrl, stockQuantity, dtAdded 
                       FROM dbo.tblProducts WHERE categoryId = @categoryId ORDER BY dtAdded DESC"
        InsertCommand="INSERT INTO dbo.tblProducts (categoryId, name, description, price, imageUrl, stockQuantity)
                       VALUES (@categoryId, @name, @description, @price, @imageUrl, @stockQuantity)"
        DeleteCommand="DELETE FROM dbo.tblProducts WHERE productId=@productId"
        UpdateCommand = "UPDATE dbo.tblProducts
                       SET categoryId=@categoryId,
                           name=@name,
                           description=@description,
                           price=@price,
                           imageUrl=@imageUrl,
                           stockQuantity=@stockQuantity
                       WHERE productId=@productId"
        CancelSelectOnNullParameter="true">

        <SelectParameters>
            <asp:ControlParameter Name="categoryId" ControlID="ddlCategories" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>

        <DeleteParameters>
            <asp:Parameter Name="productId" Type="Int32" />
        </DeleteParameters>

        <UpdateParameters>
            <asp:Parameter Name="productId" Type="Int32" />
            <asp:Parameter Name="categoryId" Type="Int32" />
            <asp:Parameter Name="name" Type="String" />
            <asp:Parameter Name="description" Type="String" />
            <asp:Parameter Name="price" Type="Decimal" />
            <asp:Parameter Name="imageUrl" Type="String" />
            <asp:Parameter Name="stockQuantity" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>



    <script>
        function toggleDeleteButton() {
            var grid = document.getElementById('<%= gvProducts.ClientID %>');
            var btn = document.getElementById('<%= btnDelete.ClientID %>');
            if (!grid || !btn) return;

            var anyChecked = grid.querySelectorAll('.row-check input[type=checkbox]:checked').length > 0;

            btn.classList.toggle('d-none', !anyChecked);
            btn.style.display = anyChecked ? 'inline-block' : 'none';
        }

        if (window.Sys && Sys.Application) {
            Sys.Application.add_load(function () { toggleDeleteButton(); });
        } else {
            document.addEventListener('DOMContentLoaded', toggleDeleteButton);
        }

        function showModal(modalId) {
            var el = document.getElementById(modalId);
            if (!el) return false;
            var modal = new bootstrap.Modal(el);
            modal.show();
            return false;
        }
    </script>

</asp:Content>

<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="manageCategories.aspx.cs" Inherits="mwmasm.manageCategories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1>Manage Category Page</h1>

    <div style="max-width:600px;margin-bottom:16px;">
        <div style="margin-bottom:8px;">
            <asp:Label ID="lblCatName" runat="server" Text="Category name:" AssociatedControlID="txtCatName" />
            <asp:TextBox ID="txtCatName" runat="server" MaxLength="50" CssClass="form-control" />
            <asp:RequiredFieldValidator ID="rfvCatName" runat="server"
                ControlToValidate="txtCatName" Display="Dynamic"
                ErrorMessage="Category name is required." CssClass="text-danger" ValidationGroup="InsertCat" />
        </div>

        <div style="margin-bottom:8px;">
            <asp:Label ID="lblCatDesc" runat="server" Text="Description (optional):" AssociatedControlID="txtCatDesc" />
            <asp:TextBox ID="txtCatDesc" runat="server" MaxLength="50" CssClass="form-control" />
        </div>
        <asp:Button ID="btnInsert" runat="server" Text="Add" CssClass="btn btn-primary"
            OnClick="btnInsert_Click" ValidationGroup="InsertCat" />
        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-secondary d-none" 
            CausesValidation="false" UseSubmitBehaviour="false" OnClientClick="return showDeleteModal();"/>
        <asp:Label ID="lblStatus" runat="server" EnableViewState="false" Style="margin-left:10px;"></asp:Label>
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

    <!-- data grid / data table for categories-->
    <asp:GridView ID="gvCategories" runat="server"
        DataSourceID="SqlDsCategories"
        AutoGenerateColumns="False"
        AllowPaging="true" PageSize="10"
        DataKeyNames="categoryId"
        CssClass="table table-striped table-bordered">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:CheckBox ID="chkSelect" runat="server" CssClass="row-check" onclick="toggleDeleteButton();" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" Width="40px" />
                <HeaderStyle HorizontalAlign="Center" Width="40px" />
            </asp:TemplateField>
            <asp:BoundField DataField="categoryId" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="name" HeaderText="Name" />
            <asp:BoundField DataField="description" HeaderText="Description" />
            <asp:BoundField DataField="dtAdded" HeaderText="Added" DataFormatString="{0:yyyy-MM-dd HH:mm}" ReadOnly="True" />
            <asp:CommandField ShowEditButton="True" />
        </Columns>
    </asp:GridView>

    <!-- Sql Data Source Properties-->
    <asp:SqlDataSource ID="SqlDsCategories" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"

        SelectCommand="SELECT [categoryId], [name], [description], [dtAdded]
                       FROM [dbo].[tblCategories]
                       ORDER BY [categoryId] DESC"

        InsertCommand="INSERT INTO [dbo].[tblCategories] ([name], [description])
                       VALUES (@name, @description)"

        UpdateCommand="UPDATE [dbo].[tblCategories]
                       SET [name] = @name,
                           [description] = @description
                       WHERE [categoryId] = @categoryId"

        DeleteCommand="DELETE FROM [dbo].[tblCategories]
                       WHERE [categoryId] = @categoryId">

        <DeleteParameters>
            <asp:Parameter Name="categoryId" Type="Int32" />
        </DeleteParameters>

        <InsertParameters>
            <asp:ControlParameter ControlID="txtCatName" Name="name" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="txtCatDesc" Name="description" PropertyName="Text" Type="String" ConvertEmptyStringToNull="true" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="name" Type="String" />
            <asp:Parameter Name="description" Type="String" />
            <asp:Parameter Name="categoryId" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <script type="text/javascript">
        function toggleDeleteButton() {
            var grid = document.getElementById('<%= gvCategories.ClientID %>');
            var btn  = document.getElementById('<%= btnDelete.ClientID %>');
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

        function showDeleteModal() {
            var el = document.getElementById('confirmDeleteModal');
            if (!el) return false;
            var modal = new bootstrap.Modal(el);
            modal.show();
            return false;
        }
    </script>
</asp:Content>


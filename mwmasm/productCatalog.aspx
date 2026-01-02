<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="productCatalog.aspx.cs" Inherits="mwmasm.productCatalog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="catalog-page">
        <h1 class="catalog-title">Product Catalog</h1>

        <!--dropdownlist for category selection -->
        <div class="category-filter">
            <asp:DropDownList ID="ddlCategories" runat="server"
                DataSourceID="SqlDsCategories"
                DataTextField="name"
                DataValueField="categoryId"
                CssClass="category-dropdown"
                AutoPostBack="true"
                AppendDataBoundItems="true">
                <asp:ListItem Text="All Categories" Value="0" />
            </asp:DropDownList>
        </div>

        <asp:ListView ID="productListView" runat="server" DataKeyNames="productId" DataSourceID="SqlDsProducts">
            <LayoutTemplate>
                <div class="catalog-grid">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                </div>
            </LayoutTemplate>

            <ItemTemplate>
                <asp:HyperLink ID="productLink" runat="server" 
                    NavigateUrl='<%# "productDetails.aspx?productId=" + Eval("productId") %>' 
                    CssClass="product-card">
                    <div class="product-image-wrapper">
                        <asp:Image ID="productImage" runat="server"
                            ImageUrl='<%# Eval("imageUrl") %>'
                            AlternateText='<%# Eval("name") %>'
                            CssClass="product-image" />
                    </div>
                    <div class="product-info">
                        <h3 class="product-name"><%# Eval("name") %></h3>
                        <div class="product-price">
                            <%# "RM " + string.Format("{0:N2}", Eval("price")) %>
                        </div>
                    </div>
                </asp:HyperLink>
            </ItemTemplate>
            <EmptyDataTemplate>
                <div class="empty-state">
                    <p class="empty-message">No products found.</p>
                </div>
            </EmptyDataTemplate>
        </asp:ListView>
    </div>


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
        /* Mobile-first styles */
        .catalog-page {
            padding: 16px;
            max-width: 100%;
        }

        .catalog-title {
            font-size: 28px;
            font-weight: 700;
            margin: 0 0 20px 0;
            color: #212529;
        }

        .category-filter {
            margin-bottom: 24px;
        }

        .category-dropdown {
            width: 100%;
            max-width: 100%;
            padding: 12px 16px;
            font-size: 16px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background-color: #fff;
            color: #212529;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23212529' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 40px;
            cursor: pointer;
            transition: border-color 0.2s ease;
        }

        .category-dropdown:focus {
            outline: none;
            border-color: #212529;
            box-shadow: 0 0 0 3px rgba(33, 37, 41, 0.1);
        }

        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            width: 100%;
        }

        .product-card {
            display: flex;
            flex-direction: column;
            background-color: #fff;
            border-radius: 12px;
            overflow: hidden;
            text-decoration: none;
            color: #212529;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
            text-decoration: none;
            color: #212529;
        }

        .product-image-wrapper {
            width: 100%;
            aspect-ratio: 1;
            overflow: hidden;
            background-color: #f3f3f3;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-info {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .product-name {
            font-size: 16px;
            font-weight: 600;
            margin: 0 0 8px 0;
            color: #212529;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 44px;
        }

        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #212529;
            margin-top: auto;
        }

        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 48px 16px;
        }

        .empty-message {
            font-size: 18px;
            color: #6c757d;
            margin: 0;
        }

        /* Tablet and up */
        @media (min-width: 768px) {
            .catalog-page {
                padding: 24px;
                max-width: 1200px;
                margin: 0 auto;
            }

            .catalog-title {
                font-size: 36px;
                margin-bottom: 24px;
            }

            .category-filter {
                margin-bottom: 32px;
            }

            .category-dropdown {
                max-width: 300px;
            }

            .catalog-grid {
                grid-template-columns: repeat(3, 1fr);
                gap: 24px;
            }

            .product-name {
                font-size: 18px;
            }

            .product-price {
                font-size: 20px;
            }
        }

        /* Desktop */
        @media (min-width: 992px) {
            .catalog-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        /* Large desktop */
        @media (min-width: 1200px) {
            .catalog-grid {
                grid-template-columns: repeat(4, 1fr);
                gap: 32px;
            }
        }
    </style>
</asp:Content>

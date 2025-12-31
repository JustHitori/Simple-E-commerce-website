<%@ Page Title="" Language="C#" MasterPageFile="~/adminSite.Master" AutoEventWireup="true" CodeBehind="adminDashboard.aspx.cs" Inherits="mwmasm.adminDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .border-black {
            border: 1px solid black;
        }
        .grid-container {
            display: grid;
            grid-template-columns: auto auto;
            gap: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 class="mb-4">Admin Dashboard</h1>

    <div class="grid-container">  
        <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageUsers">
            <div class="card p-2 border-black align-items-center">Manage Users</div>
        </a>

        <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageCategories">
            <div class="card p-2 border-black align-items-center">Manage Categories</div>
        </a>

        <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageProducts">
            <div class="card p-2 border-black align-items-center">Manage Products</div>
        </a>

        <a runat="server" class="nav-link fs-3 fw-semibold" href="~/admin/manageOrders">
            <div class="card p-2 border-black align-items-center">Manage Orders</div>
        </a>
    </div>
</asp:Content>

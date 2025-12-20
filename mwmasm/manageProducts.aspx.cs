using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class manageProducts : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            Page.Validate("InsertProd");
            if (!Page.IsValid) return;

            int categoryId;
            if (!int.TryParse(ddlModalCategory.SelectedValue, out categoryId))
            {
                // show message if you have a label; otherwise return
                return;
            }

            string name = txtModalName.Text.Trim();
            string description = txtModalDesc.Text.Trim();

            if (!decimal.TryParse(txtModalPrice.Text, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal price))
            {
                return;
            }

            if (!int.TryParse(txtModalStock.Text, out int stock))
            {
                return;
            }

            string imageUrl = null;
            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName)?.ToLowerInvariant();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    lblImageError.Text = "Only .jpg, .jpeg, .png are allowed.";
                    return;
                }

                string folder = Server.MapPath("~/productImages/");
                Directory.CreateDirectory(folder);

                string serverFileName = Path.GetFileName(fuImage.FileName); // keep original name
                string savePath = Path.Combine(folder, serverFileName);

                if (!File.Exists(savePath))
                {
                    // only save if not already there
                    fuImage.SaveAs(savePath);
                }
                // always reuse same path
                imageUrl = ResolveUrl("~/productImages/" + serverFileName);
            }


            SqlDsProducts.InsertParameters.Clear();
            SqlDsProducts.InsertParameters.Add("categoryId", categoryId.ToString());
            SqlDsProducts.InsertParameters.Add("name", name);
            if (txtModalDesc.Text.Trim().Length == 0)
            {
                SqlDsProducts.InsertParameters.Add("description", DBNull.Value.ToString());
            }
            else
            {
                SqlDsProducts.InsertParameters.Add("description", description);
            }
            SqlDsProducts.InsertParameters.Add("price", price.ToString(CultureInfo.InvariantCulture));
            SqlDsProducts.InsertParameters.Add("imageUrl", imageUrl);
            SqlDsProducts.InsertParameters.Add("stockQuantity", stock.ToString());

            SqlDsProducts.Insert();

            txtModalName.Text = "";
            txtModalDesc.Text = "";
            txtModalPrice.Text = "";
            txtModalStock.Text = "0";

            gvProducts.DataBind();

            lblStatus.Text = "Product Added";
            string js = $"setTimeout(function(){{var el=document.getElementById('{lblStatus.ClientID}');" +
                                "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }" +
                                "}, 3000);";
            ScriptManager.RegisterStartupScript(this, GetType(), "hideStatusMsg", js, true);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int deleteCount = 0;

            try
            {
                foreach (GridViewRow row in gvProducts.Rows)
                {
                    var checkbox = row.FindControl("chkSelect") as CheckBox;
                    if (checkbox != null && checkbox.Checked)
                    {
                        var keyObj = gvProducts.DataKeys[row.RowIndex].Value;

                        SqlDsProducts.DeleteParameters["productId"].DefaultValue = keyObj.ToString();
                        SqlDsProducts.Delete();
                        deleteCount++;
                    }
                    gvProducts.DataBind();

                    btnDelete.CssClass = (btnDelete.CssClass ?? "") + " d-none";

                    lblStatus.CssClass = "text-success";
                    lblStatus.Text = "Product deleted";
                    string js = $"setTimeout(function(){{var el=document.getElementById('{lblStatus.ClientID}');" +
                                        "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }" +
                                        "}, 3000);";
                    ScriptManager.RegisterStartupScript(this, GetType(), "hideStatusMsg", js, true);
                }
            }
            catch (Exception ex)
            {
                lblStatus.CssClass = "text-danger";
                lblStatus.Text = "Error: " + ex.Message;
            }
        }

        protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            var row = gvProducts.Rows[e.RowIndex];

            var fu = row.FindControl("fuEditImage") as FileUpload;
            var hid = row.FindControl("hidCurrentImage") as HiddenField;

            string imageUrl = hid?.Value;

            if (fu != null && fu.HasFile)
            {
                string ext = Path.GetExtension(fu.FileName)?.ToLowerInvariant();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
                {
                    e.Cancel = true;
                    lblStatus.CssClass = "text-danger";
                    lblStatus.Text = "Only .jpg, .jpeg, .png are allowed.";
                    return;
                }

                string folder = Server.MapPath("~/productImages/");
                Directory.CreateDirectory(folder);

                string serverFileName = Path.GetFileName(fu.FileName);
                string savePath = Path.Combine(folder, serverFileName);

                if (!File.Exists(savePath))
                {
                    fu.SaveAs(savePath);
                }
                imageUrl = ResolveUrl("~/productImages/" + serverFileName);
            }
            e.NewValues["imageUrl"] = string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl;

        }

    }
}
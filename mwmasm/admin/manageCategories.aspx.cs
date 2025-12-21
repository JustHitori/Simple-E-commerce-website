using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class manageCategories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            try
            {
                SqlDsCategories.Insert();
                txtCatName.Text = string.Empty;
                txtCatDesc.Text = string.Empty;
                lblStatus.CssClass = "text-success";
                lblStatus.Text = "Categories Added";
                string js = $"setTimeout(function(){{var el=document.getElementById('{lblStatus.ClientID}');" +
                                    "if(el){ el.textContent=''; el.classList.remove('text-success','text-danger'); }" +
                                    "}, 3000);";
                ScriptManager.RegisterStartupScript(this, GetType(), "hideStatusMsg", js, true);
            }
            catch (Exception ex)
            {
                lblStatus.CssClass = "text-danger";
                lblStatus.Text = "Error: " + ex.Message;
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int deleteCount = 0;

            try
            {
                foreach (GridViewRow row in gvCategories.Rows)
                {
                    var checkbox = row.FindControl("chkSelect") as CheckBox;
                    if (checkbox != null && checkbox.Checked)
                    {
                        var keyObj = gvCategories.DataKeys[row.RowIndex].Value;

                        SqlDsCategories.DeleteParameters["categoryId"].DefaultValue = keyObj.ToString();
                        SqlDsCategories.Delete();
                        deleteCount++;
                    }
                    gvCategories.DataBind();

                    btnDelete.CssClass = (btnDelete.CssClass ?? "") + " d-none";

                    lblStatus.CssClass = "text-success";
                    lblStatus.Text = "Categories deleted";
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
    }
}
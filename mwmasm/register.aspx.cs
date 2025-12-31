using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace mwmasm
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            SqlDataSource1.Insert();
            lblResult.Text = "Registration successful!";
            Response.Redirect("login.aspx");
        }
    }
}

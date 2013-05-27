using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace AdvancedLogParser
{
    class LoadingForm:Form
    {
        public Label status = new Label();
        public LoadingForm()
        {
            status.Text = "Loading Local Resources...";
            status.Size = status.PreferredSize;

            this.Height = 100;
            this.Width = 200;

            status.Location = new Point((this.Width - status.Width) / 2, (this.Height - status.Height) / 2);

            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;

            this.Controls.Add(status);
        }
    }
}

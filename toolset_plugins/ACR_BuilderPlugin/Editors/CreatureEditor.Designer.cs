namespace ACR_BuilderPlugin
{
    partial class CreatureEditor
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.setHitPointsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.penAndPaperToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.maximumToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.viewToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.alwaysOnTopToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.tabControl = new System.Windows.Forms.TabControl();
            this.tabProperties = new System.Windows.Forms.TabPage();
            this.propMain = new System.Windows.Forms.PropertyGrid();
            this.tabACRProps = new System.Windows.Forms.TabPage();
            this.propACR = new System.Windows.Forms.PropertyGrid();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.lbStatus = new System.Windows.Forms.ToolStripStatusLabel();
            this.menuStrip1.SuspendLayout();
            this.tabControl.SuspendLayout();
            this.tabProperties.SuspendLayout();
            this.tabACRProps.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem,
            this.viewToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(622, 24);
            this.menuStrip1.TabIndex = 1;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.setHitPointsToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(47, 20);
            this.fileToolStripMenuItem.Text = "Tools";
            // 
            // setHitPointsToolStripMenuItem
            // 
            this.setHitPointsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.penAndPaperToolStripMenuItem,
            this.maximumToolStripMenuItem});
            this.setHitPointsToolStripMenuItem.Name = "setHitPointsToolStripMenuItem";
            this.setHitPointsToolStripMenuItem.Size = new System.Drawing.Size(142, 22);
            this.setHitPointsToolStripMenuItem.Text = "Set HitPoints";
            // 
            // penAndPaperToolStripMenuItem
            // 
            this.penAndPaperToolStripMenuItem.Name = "penAndPaperToolStripMenuItem";
            this.penAndPaperToolStripMenuItem.Size = new System.Drawing.Size(150, 22);
            this.penAndPaperToolStripMenuItem.Text = "Pen and Paper";
            this.penAndPaperToolStripMenuItem.Click += new System.EventHandler(this.penAndPaperToolStripMenuItem_Click);
            // 
            // maximumToolStripMenuItem
            // 
            this.maximumToolStripMenuItem.Name = "maximumToolStripMenuItem";
            this.maximumToolStripMenuItem.Size = new System.Drawing.Size(150, 22);
            this.maximumToolStripMenuItem.Text = "Maximum";
            this.maximumToolStripMenuItem.Click += new System.EventHandler(this.maximumToolStripMenuItem_Click);
            // 
            // viewToolStripMenuItem
            // 
            this.viewToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.alwaysOnTopToolStripMenuItem});
            this.viewToolStripMenuItem.Name = "viewToolStripMenuItem";
            this.viewToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.viewToolStripMenuItem.Text = "View";
            // 
            // alwaysOnTopToolStripMenuItem
            // 
            this.alwaysOnTopToolStripMenuItem.Name = "alwaysOnTopToolStripMenuItem";
            this.alwaysOnTopToolStripMenuItem.Size = new System.Drawing.Size(151, 22);
            this.alwaysOnTopToolStripMenuItem.Text = "Always on Top";
            this.alwaysOnTopToolStripMenuItem.Click += new System.EventHandler(this.alwaysOnTopToolStripMenuItem_Click);
            // 
            // tabControl
            // 
            this.tabControl.Controls.Add(this.tabProperties);
            this.tabControl.Controls.Add(this.tabACRProps);
            this.tabControl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl.Location = new System.Drawing.Point(0, 24);
            this.tabControl.Name = "tabControl";
            this.tabControl.SelectedIndex = 0;
            this.tabControl.Size = new System.Drawing.Size(622, 457);
            this.tabControl.TabIndex = 2;
            // 
            // tabProperties
            // 
            this.tabProperties.Controls.Add(this.propMain);
            this.tabProperties.Location = new System.Drawing.Point(4, 22);
            this.tabProperties.Name = "tabProperties";
            this.tabProperties.Padding = new System.Windows.Forms.Padding(3);
            this.tabProperties.Size = new System.Drawing.Size(614, 431);
            this.tabProperties.TabIndex = 0;
            this.tabProperties.Text = "Properties";
            this.tabProperties.UseVisualStyleBackColor = true;
            // 
            // propMain
            // 
            this.propMain.CategoryForeColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.propMain.Dock = System.Windows.Forms.DockStyle.Fill;
            this.propMain.Location = new System.Drawing.Point(3, 3);
            this.propMain.Name = "propMain";
            this.propMain.Size = new System.Drawing.Size(608, 425);
            this.propMain.TabIndex = 0;
            this.propMain.ToolbarVisible = false;
            // 
            // tabACRProps
            // 
            this.tabACRProps.Controls.Add(this.propACR);
            this.tabACRProps.Location = new System.Drawing.Point(4, 22);
            this.tabACRProps.Name = "tabACRProps";
            this.tabACRProps.Padding = new System.Windows.Forms.Padding(3);
            this.tabACRProps.Size = new System.Drawing.Size(614, 431);
            this.tabACRProps.TabIndex = 2;
            this.tabACRProps.Text = "ACR Config";
            this.tabACRProps.UseVisualStyleBackColor = true;
            // 
            // propACR
            // 
            this.propACR.CategoryForeColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.propACR.Dock = System.Windows.Forms.DockStyle.Fill;
            this.propACR.Location = new System.Drawing.Point(3, 3);
            this.propACR.Name = "propACR";
            this.propACR.Size = new System.Drawing.Size(608, 425);
            this.propACR.TabIndex = 0;
            this.propACR.ToolbarVisible = false;
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.lbStatus});
            this.statusStrip1.Location = new System.Drawing.Point(0, 481);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(622, 22);
            this.statusStrip1.TabIndex = 3;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // lbStatus
            // 
            this.lbStatus.Name = "lbStatus";
            this.lbStatus.Size = new System.Drawing.Size(108, 17);
            this.lbStatus.Text = "No object selected.";
            // 
            // CreatureEditor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(622, 503);
            this.Controls.Add(this.tabControl);
            this.Controls.Add(this.menuStrip1);
            this.Controls.Add(this.statusStrip1);
            this.Name = "CreatureEditor";
            this.ShowIcon = false;
            this.Text = "ACR Creature Editor";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.tabControl.ResumeLayout(false);
            this.tabProperties.ResumeLayout(false);
            this.tabACRProps.ResumeLayout(false);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.TabPage tabProperties;
        private System.Windows.Forms.ToolStripMenuItem setHitPointsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem penAndPaperToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem maximumToolStripMenuItem;
        private System.Windows.Forms.PropertyGrid propMain;
        private System.Windows.Forms.TabPage tabACRProps;
        private System.Windows.Forms.PropertyGrid propACR;
        private System.Windows.Forms.ToolStripMenuItem viewToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem alwaysOnTopToolStripMenuItem;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel lbStatus;

    }
}
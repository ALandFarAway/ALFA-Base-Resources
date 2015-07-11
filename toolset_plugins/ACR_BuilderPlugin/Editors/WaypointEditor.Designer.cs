namespace ACR_BuilderPlugin
{
    partial class WaypointEditor
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
            this.propBasic = new System.Windows.Forms.PropertyGrid();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aCRSpawnDocumentationToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabProperties = new System.Windows.Forms.TabPage();
            this.tabSpawn = new System.Windows.Forms.TabPage();
            this.propSpawn = new System.Windows.Forms.PropertyGrid();
            this.viewToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.alwaysOnTopToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabProperties.SuspendLayout();
            this.tabSpawn.SuspendLayout();
            this.SuspendLayout();
            // 
            // propBasic
            // 
            this.propBasic.CategoryForeColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.propBasic.Dock = System.Windows.Forms.DockStyle.Fill;
            this.propBasic.Location = new System.Drawing.Point(3, 3);
            this.propBasic.Name = "propBasic";
            this.propBasic.Size = new System.Drawing.Size(483, 371);
            this.propBasic.TabIndex = 0;
            this.propBasic.ToolbarVisible = false;
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.viewToolStripMenuItem,
            this.helpToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(497, 24);
            this.menuStrip1.TabIndex = 1;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // helpToolStripMenuItem
            // 
            this.helpToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aCRSpawnDocumentationToolStripMenuItem});
            this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
            this.helpToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.helpToolStripMenuItem.Text = "Help";
            // 
            // aCRSpawnDocumentationToolStripMenuItem
            // 
            this.aCRSpawnDocumentationToolStripMenuItem.Name = "aCRSpawnDocumentationToolStripMenuItem";
            this.aCRSpawnDocumentationToolStripMenuItem.Size = new System.Drawing.Size(221, 22);
            this.aCRSpawnDocumentationToolStripMenuItem.Text = "ACR Spawn Documentation";
            this.aCRSpawnDocumentationToolStripMenuItem.Click += new System.EventHandler(this.aCRSpawnDocumentationToolStripMenuItem_Click);
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabProperties);
            this.tabControl1.Controls.Add(this.tabSpawn);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(0, 24);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(497, 403);
            this.tabControl1.TabIndex = 2;
            // 
            // tabProperties
            // 
            this.tabProperties.Controls.Add(this.propBasic);
            this.tabProperties.Location = new System.Drawing.Point(4, 22);
            this.tabProperties.Name = "tabProperties";
            this.tabProperties.Padding = new System.Windows.Forms.Padding(3);
            this.tabProperties.Size = new System.Drawing.Size(489, 377);
            this.tabProperties.TabIndex = 0;
            this.tabProperties.Text = "Waypoint";
            this.tabProperties.UseVisualStyleBackColor = true;
            // 
            // tabSpawn
            // 
            this.tabSpawn.Controls.Add(this.propSpawn);
            this.tabSpawn.Location = new System.Drawing.Point(4, 22);
            this.tabSpawn.Name = "tabSpawn";
            this.tabSpawn.Padding = new System.Windows.Forms.Padding(3);
            this.tabSpawn.Size = new System.Drawing.Size(489, 377);
            this.tabSpawn.TabIndex = 1;
            this.tabSpawn.Text = "Spawn";
            this.tabSpawn.UseVisualStyleBackColor = true;
            // 
            // propSpawn
            // 
            this.propSpawn.CategoryForeColor = System.Drawing.SystemColors.InactiveCaptionText;
            this.propSpawn.Dock = System.Windows.Forms.DockStyle.Fill;
            this.propSpawn.Location = new System.Drawing.Point(3, 3);
            this.propSpawn.Name = "propSpawn";
            this.propSpawn.Size = new System.Drawing.Size(483, 371);
            this.propSpawn.TabIndex = 0;
            this.propSpawn.ToolbarVisible = false;
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
            this.alwaysOnTopToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.alwaysOnTopToolStripMenuItem.Text = "Always on Top";
            this.alwaysOnTopToolStripMenuItem.Click += new System.EventHandler(this.alwaysOnTopToolStripMenuItem_Click);
            // 
            // WaypointEditor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(497, 427);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "WaypointEditor";
            this.Text = "ACR Waypoint Editor";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabProperties.ResumeLayout(false);
            this.tabSpawn.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PropertyGrid propBasic;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aCRSpawnDocumentationToolStripMenuItem;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabProperties;
        private System.Windows.Forms.TabPage tabSpawn;
        private System.Windows.Forms.PropertyGrid propSpawn;
        private System.Windows.Forms.ToolStripMenuItem viewToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem alwaysOnTopToolStripMenuItem;
    }
}
namespace ACR_BuilderPlugin
{
    partial class ValidateWindow
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
            this.lbCurrentTask = new System.Windows.Forms.Label();
            this.pbOverall = new System.Windows.Forms.ProgressBar();
            this.pbCurrent = new System.Windows.Forms.ProgressBar();
            this.lbCurrentDetail = new System.Windows.Forms.Label();
            this.bwMain = new System.ComponentModel.BackgroundWorker();
            this.SuspendLayout();
            // 
            // lbCurrentTask
            // 
            this.lbCurrentTask.AutoSize = true;
            this.lbCurrentTask.Location = new System.Drawing.Point(12, 9);
            this.lbCurrentTask.Name = "lbCurrentTask";
            this.lbCurrentTask.Size = new System.Drawing.Size(16, 13);
            this.lbCurrentTask.TabIndex = 0;
            this.lbCurrentTask.Text = "...";
            this.lbCurrentTask.UseWaitCursor = true;
            // 
            // pbOverall
            // 
            this.pbOverall.Location = new System.Drawing.Point(12, 25);
            this.pbOverall.Name = "pbOverall";
            this.pbOverall.Size = new System.Drawing.Size(375, 23);
            this.pbOverall.TabIndex = 1;
            this.pbOverall.UseWaitCursor = true;
            // 
            // pbCurrent
            // 
            this.pbCurrent.Location = new System.Drawing.Point(12, 81);
            this.pbCurrent.Name = "pbCurrent";
            this.pbCurrent.Size = new System.Drawing.Size(375, 23);
            this.pbCurrent.TabIndex = 2;
            this.pbCurrent.UseWaitCursor = true;
            // 
            // lbCurrentDetail
            // 
            this.lbCurrentDetail.AutoSize = true;
            this.lbCurrentDetail.Location = new System.Drawing.Point(12, 65);
            this.lbCurrentDetail.Name = "lbCurrentDetail";
            this.lbCurrentDetail.Size = new System.Drawing.Size(16, 13);
            this.lbCurrentDetail.TabIndex = 3;
            this.lbCurrentDetail.Text = "...";
            this.lbCurrentDetail.UseWaitCursor = true;
            // 
            // bwMain
            // 
            this.bwMain.WorkerReportsProgress = true;
            this.bwMain.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwMain_DoWork);
            this.bwMain.ProgressChanged += new System.ComponentModel.ProgressChangedEventHandler(this.bwMain_ProgressChanged);
            this.bwMain.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.bwMain_RunWorkerCompleted);
            // 
            // ValidateWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(399, 118);
            this.ControlBox = false;
            this.Controls.Add(this.lbCurrentDetail);
            this.Controls.Add(this.pbCurrent);
            this.Controls.Add(this.pbOverall);
            this.Controls.Add(this.lbCurrentTask);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "ValidateWindow";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Validating Module";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lbCurrentTask;
        private System.Windows.Forms.ProgressBar pbOverall;
        private System.Windows.Forms.ProgressBar pbCurrent;
        private System.Windows.Forms.Label lbCurrentDetail;
        private System.ComponentModel.BackgroundWorker bwMain;
    }
}
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Instances;
using NWN2Toolset.NWN2.Data.Templates;

using ACR_BuilderPlugin.Editors.Wrappers;

namespace ACR_BuilderPlugin
{
    public partial class TriggerEditor : Form
    {
        ACRQuestObject ACRQuestTGR = new ACRQuestObject();

        public TriggerEditor()
        {
            InitializeComponent();

            propQuest.SelectedObject = ACRQuestTGR;
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            Hide();
            e.Cancel = true;
            base.OnClosing(e);
        }

        public void setFocus(NWN2TriggerTemplate tgr)
        {
            if (tgr == null)
            {
                Text = "ACR Trigger Editor";
                propBasic.SelectedObject = null;
                ACRQuestTGR.SetSelection(null);
                propBasic.Refresh();
                propQuest.Refresh();
            }

            // Update main property sheet.
            if (tgr.GetType() == typeof(NWN2TriggerBlueprint))
            {
                Text = "ACR Trigger Editor: " + ((NWN2TriggerBlueprint)tgr).ResourceName.Value;
                propBasic.SelectedObject = (NWN2TriggerBlueprint)tgr;
            }
            else if (tgr.GetType() == typeof(NWN2WaypointInstance))
            {
                Text = "ACR Trigger Editor: " + ((NWN2TriggerInstance)tgr).Template.ResRef.Value + " (instance)";
                propBasic.SelectedObject = (NWN2TriggerInstance)tgr;
            }
            else
            {
                propBasic.SelectedObject = tgr;
            }

            // Update ACR property sheet.
            ACRQuestTGR.SetSelection(tgr);

            propBasic.Refresh();
            propQuest.Refresh();
        }

        private void aCRSpawnDocumentationToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://www.alandfaraway.info/wiki/ACR_Spawn");
        }

        private void alwaysOnTopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            TopMost = !TopMost;
            ((ToolStripMenuItem)sender).Checked = TopMost;
        }
    }
}

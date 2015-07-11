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

namespace ACR_BuilderPlugin
{
    public partial class WaypointEditor : Form
    {
        ACRSpawnWaypoint ACRSpawnWP = new ACRSpawnWaypoint();

        public WaypointEditor()
        {
            InitializeComponent();

            propSpawn.SelectedObject = ACRSpawnWP;
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            Hide();
            e.Cancel = true;
            base.OnClosing(e);
        }

        public void setFocus(NWN2WaypointTemplate wp)
        {
            if (wp == null)
            {
                Text = "ACR Creature Editor";
                propBasic.SelectedObject = null;
                ACRSpawnWP.SetSelection(null);
                propBasic.Refresh();
                propSpawn.Refresh();
            }

            // Update main property sheet.
            if (wp.GetType() == typeof(NWN2WaypointBlueprint))
            {
                Text = "ACR Waypoint Editor: " + ((NWN2WaypointBlueprint)wp).ResourceName.Value;
                propBasic.SelectedObject = (NWN2WaypointBlueprint)wp;
            }
            else if (wp.GetType() == typeof(NWN2WaypointInstance))
            {
                Text = "ACR Creature Editor: " + ((NWN2WaypointInstance)wp).Template.ResRef.Value + " (instance)";
                propBasic.SelectedObject = (NWN2WaypointInstance)wp;
            }
            else
            {
                propBasic.SelectedObject = wp;
            }

            // Update ACR property sheet.
            ACRSpawnWP.SetSelection(wp);

            propBasic.Refresh();
            propSpawn.Refresh();
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

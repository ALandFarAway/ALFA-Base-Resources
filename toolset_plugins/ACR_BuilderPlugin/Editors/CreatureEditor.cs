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
    public partial class CreatureEditor : Form
    {
        ACRCreature selection = new ACRCreature();

        public CreatureEditor()
        {
            InitializeComponent();

            propACR.SelectedObject = selection;
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            Hide();
            e.Cancel = true;
            base.OnClosing(e);
        }

        public void setFocus(NWN2CreatureTemplate creature)
        {
            if (creature == null)
            {
                Text = "ACR Creature Editor";
                propMain.SelectedObject = null;
                selection.SetSelection(null);
                propMain.Refresh();
                propACR.Refresh();
            }

            // Update main property sheet.
            if (creature.GetType() == typeof(NWN2CreatureBlueprint))
            {
                Text = "ACR Creature Editor: " + ((NWN2CreatureBlueprint)creature).ResourceName.Value;
                propMain.SelectedObject = (NWN2CreatureBlueprint)creature;
            }
            else if (creature.GetType() == typeof(NWN2CreatureInstance))
            {
                Text = "ACR Creature Editor: " + ((NWN2CreatureInstance)creature).Template.ResRef.Value + " (instance)";
                propMain.SelectedObject = (NWN2CreatureInstance)creature;
            }
            else
            {
                propMain.SelectedObject = creature;
            }

            // Update ACR property sheet.
            selection.SetSelection(creature);

            propMain.Refresh();
            propACR.Refresh();
        }

        private void alwaysOnTopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            TopMost = !TopMost;
            ((ToolStripMenuItem)sender).Checked = TopMost;
        }

        private void penAndPaperToolStripMenuItem_Click(object sender, EventArgs e)
        {
            CreatureHelper.SetCreatureHitPoints(selection.GetTemplate(), CreatureHelper.HPType.PenAndPaper);
        }

        private void maximumToolStripMenuItem_Click(object sender, EventArgs e)
        {
            CreatureHelper.SetCreatureHitPoints(selection.GetTemplate(), CreatureHelper.HPType.Maximum);
        }
    }
}

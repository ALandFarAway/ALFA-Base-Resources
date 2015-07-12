using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Windows.Forms;
using TD.SandBar;

using NWN2Toolset;
using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Instances;
using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Data.TypedCollections;
using NWN2Toolset.NWN2.Views;
using NWN2Toolset.Plugins;

namespace ACR_BuilderPlugin
{
    public class PluginMain : INWN2Plugin
    {
        private MenuButtonItem m_cMenuItem;

        private TD.SandBar.ToolBar toolBar;

        // Editors.
        CreatureEditor creatureEditor = new CreatureEditor();
        TriggerEditor triggerEditor = new TriggerEditor();
        WaypointEditor waypointEditor = new WaypointEditor();

        /// <summary>
        /// Checks the module for common errors, and logs them to a file. Handled by
        /// the ValidateWindow class.
        /// </summary>
        private void ValidateModule(object sender, EventArgs e)
        {
            if (MessageBox.Show("This tool will check for common errors in using ACR tools. Validating a module may take several minutes. Continue?", "Validate Module", MessageBoxButtons.OKCancel) == DialogResult.Cancel) return;
            try
            {
                ModuleValidator validator = new ModuleValidator();
                validator.Run();
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.ToString());
            }
        }

        private void SetCreatureHPPnP(object sender, EventArgs e)
        {
            if (MessageBox.Show("This tool will set creature hit points across the module. To blacklist a creature from this feature, add a local variable of type int with a name of ABP_SETHP_OVERRIDE and a value of -1. For further uses of ABP_SETHP_OVERRIDE, see the wiki.", "Set Creature Hit Points", MessageBoxButtons.OKCancel) == DialogResult.Cancel) return;
            SetCreatureHP(CreatureHelper.HPType.PenAndPaper);
        }

        private void SetCreatureHPMax(object sender, EventArgs e)
        {
            if (MessageBox.Show("This tool will set creature hit points across the module. To blacklist a creature from this feature, add a local variable of type int with a name of ABP_SETHP_OVERRIDE and a value of -1. For further uses of ABP_SETHP_OVERRIDE, see the wiki.", "Set Creature Hit Points", MessageBoxButtons.OKCancel) == DialogResult.Cancel) return;
            SetCreatureHP(CreatureHelper.HPType.Maximum);
        }

        private void OpenCreatureEditor(object sender, EventArgs e)
        {
            creatureEditor.Show();
        }

        private void OpenTriggerEditor(object sender, EventArgs e)
        {
            triggerEditor.Show();
        }

        private void OpenWaypointEditor(object sender, EventArgs e)
        {
            waypointEditor.Show();
        }

        /// <summary>
        /// Sets all creatures in the module to a certain HP.
        /// </summary>
        private void SetCreatureHP(CreatureHelper.HPType hpType)
        {
            try
            {
                foreach (NWN2CreatureBlueprint creature in NWN2ToolsetMainForm.App.Module.Creatures)
                    CreatureHelper.SetCreatureHitPoints(creature, hpType);

                foreach (NWN2GameArea area in NWN2ToolsetMainForm.App.Module.Areas.Values)
                {
                    area.Demand();

                    foreach (NWN2CreatureInstance creature in area.Creatures)
                        CreatureHelper.SetCreatureHitPoints(creature, hpType);

                    area.LoadAllHookPoints();
                    area.OEISerialize();
                    area.Release();
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.ToString());
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public void Load(INWN2PluginHost cHost)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        public void Shutdown(INWN2PluginHost cHost)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        public void Startup(INWN2PluginHost cHost)
        {
            m_cMenuItem = cHost.GetMenuForPlugin(this);
            m_cMenuItem.Items.Add("Validate Module", ValidateModule);

            // Get common views, forms, and controls.
            NWN2BlueprintView blueprintView = (NWN2BlueprintView)ToolsetHelper.GetControlOfFieldType(typeof(NWN2BlueprintView));

            // Create our toolbar.
            toolBar = ToolsetHelper.GenerateToolBar("acrToolBar");
            ToolsetHelper.GetControl(typeof(ToolBarContainer), "topSandBarDock").Controls.Add(toolBar);

            // Populate it with some buttons.
            toolBar.Items.Add(ToolsetHelper.GenerateButtonItem("Creature", OpenCreatureEditor));
            toolBar.Items.Add(ToolsetHelper.GenerateButtonItem("Trigger", OpenTriggerEditor));
            toolBar.Items.Add(ToolsetHelper.GenerateButtonItem("Waypoint", OpenWaypointEditor));

            // Handle blueprint view selection changes.
            blueprintView.SelectionChanged += delegate(object sender, BlueprintSelectionChangedEventArgs e)
            {
                if (e.Selection.Length > 0 && e.Selection != e.OldSelection)
                {
                    INWN2Blueprint blueprint = (INWN2Blueprint)e.Selection[0];
                    switch ( blueprint.ObjectType )
                    {
                        case NWN2ObjectType.Creature:
                            creatureEditor.setFocus((NWN2CreatureBlueprint)blueprint);
                            break;
                        case NWN2ObjectType.Waypoint:
                            waypointEditor.setFocus((NWN2WaypointBlueprint)blueprint);
                            break;
                        case NWN2ObjectType.Trigger:
                            triggerEditor.setFocus((NWN2TriggerBlueprint)blueprint);
                            break;
                    }
                }
            };

        }

        /// <summary>
        /// 
        /// </summary>
        public void Unload(INWN2PluginHost cHost)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        public MenuButtonItem PluginMenuItem
        {
            get
            {
                return m_cMenuItem;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string DisplayName
        {
            get
            {
                return "ALFA Core Rules";
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string MenuName
        {
            get
            {
                return "ALFA Core Rules";
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string Name
        {
            get
            {
                return "ALFA Core Rules";
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public object Preferences
        {
            get
            {
                return null;
            }
            set
            {

            }
        }
    }
}

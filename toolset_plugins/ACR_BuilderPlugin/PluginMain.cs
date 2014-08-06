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
using NWN2Toolset.Plugins;

namespace ACR_BuilderPlugin
{
    public class PluginMain : INWN2Plugin
    {
        private MenuButtonItem m_cMenuItem;

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
            SetCreatureHP(CreatureHelper.HPType.PenAndPaper);
        }

        private void SetCreatureHPMax(object sender, EventArgs e)
        {
            SetCreatureHP(CreatureHelper.HPType.Maximum);
        }

        /// <summary>
        /// Sets all creatures in the module to a certain HP.
        /// </summary>
        private void SetCreatureHP(CreatureHelper.HPType hpType)
        {
            if (MessageBox.Show("This tool will set creature hit points across the module. To blacklist a creature from this feature, add a local variable of type int with a name of ABP_SETHP_OVERRIDE and a value of -1. For further uses of ABP_SETHP_OVERRIDE, see the wiki.", "Set Creature Hit Points", MessageBoxButtons.OKCancel) == DialogResult.Cancel) return;
            try
            {
                // First build our creature list.
                List<NWN2CreatureTemplate> creatureList = new List<NWN2CreatureTemplate>();
                foreach (NWN2CreatureBlueprint creature in NWN2ToolsetMainForm.App.Module.Creatures)
                    creatureList.Add((NWN2CreatureTemplate)creature);
                foreach (NWN2GameArea area in NWN2ToolsetMainForm.App.Module.Areas.Values)
                    foreach (NWN2CreatureInstance creature in area.Creatures) 
                        creatureList.Add((NWN2CreatureTemplate)creature);

                // Go through them and fix HP.
                foreach (NWN2CreatureTemplate creature in creatureList)
                {
                    // Check for blacklisting.
                    if (creature.Variables.GetVariable("ABP_SETHP_OVERRIDE").ValueInt > 0) hpType = (CreatureHelper.HPType)creature.Variables.GetVariable("ABP_SETHP_OVERRIDE").ValueInt;
                    if (hpType == CreatureHelper.HPType.Ignore) continue;

                    // Find the new HP.
                    short newHP = 0;
                    switch (hpType)
                    {
                        case CreatureHelper.HPType.PenAndPaper: newHP = CreatureHelper.GetHitPointsPNP(creature); break;
                        case CreatureHelper.HPType.Maximum: newHP = CreatureHelper.GetHitPointsMax(creature); break;
                        default: continue;
                    }

                    // And set it.
                    creature.BaseHitPoints = newHP;
                    creature.CurrentHitPoints = newHP;
                    creature.CharsheetHitPoints = newHP;
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
        private void HandlePluginLaunch(object sender, EventArgs e)
        {

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
            int nCreaturesMenu = m_cMenuItem.Items.Add("Creatures");
            {
                int nSetHPMenu = m_cMenuItem.Items[nCreaturesMenu].Items.Add("Set Hit Points");
                {
                    m_cMenuItem.Items[nCreaturesMenu].Items[nSetHPMenu].Items.Add("Pen and Paper", SetCreatureHPPnP);
                    m_cMenuItem.Items[nCreaturesMenu].Items[nSetHPMenu].Items.Add("Maximum", SetCreatureHPMax);
                }
            }
            m_cMenuItem.Items.Add("Validate Module", ValidateModule);
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

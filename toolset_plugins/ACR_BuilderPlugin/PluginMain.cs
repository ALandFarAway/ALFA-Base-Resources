using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Windows.Forms;
using NWN2Toolset;
using NWN2Toolset.Plugins;
using TD.SandBar;

using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Templates;
using NWN2Toolset.NWN2.Data.TypedCollections;

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

            // Create and run the validator.
            ValidateWindow progress = new ValidateWindow();
            try
            {
                progress.Run();
                progress.ShowDialog();
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
                progress.Close();
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

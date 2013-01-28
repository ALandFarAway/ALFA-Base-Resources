using System;
using System.Collections.Generic;
using System.Text;
using NWN2Toolset;
using NWN2Toolset.Plugins;
using TD.SandBar;

namespace ACR_EmptyPlugin
{
    public class PluginMain : INWN2Plugin
    {
        private MenuButtonItem m_cMenuItem;

        private void HandlePluginLaunch(object sender, EventArgs e)
        {

        }

        public void Load(INWN2PluginHost cHost)
        {

        }

        public void Shutdown(INWN2PluginHost cHost)
        {

        }

        public void Startup(INWN2PluginHost cHost)
        {
            m_cMenuItem = cHost.GetMenuForPlugin(this);
            m_cMenuItem.Activate += new EventHandler(this.HandlePluginLaunch);
        }

        public void Unload(INWN2PluginHost cHost)
        {

        }

        public MenuButtonItem PluginMenuItem
        {
            get
            {
                return m_cMenuItem;
            }
        }

        public string DisplayName
        {
            get
            {
                return "Plugin Name";
            }
        }

        public string MenuName
        {
            get
            {
                return "Plugin Name";
            }
        }

        public string Name
        {
            get
            {
                return "Plugin Name";
            }
        }


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

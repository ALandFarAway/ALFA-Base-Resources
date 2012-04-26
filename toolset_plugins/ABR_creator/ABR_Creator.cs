using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Drawing;
/*
 * NWN2Toolset.dll exposes all the functions we need to manupulate the toolkit.
 */
using NWN2Toolset.Plugins;
/*
 * Sandbar is the library thats used for the toolbar.
 * 
 * Windows also has a Toolbar object in System.Windows.Forms so make sure
 * you create the correct object when adding a toolbar to the toolkit.
 */
using TD.SandBar;

namespace ABM_creator
{
    public class ABM_creator : INWN2Plugin
    {

        private MenuButtonItem m_cMenuItem;

        private void HandlePluginLaunch(object sender, EventArgs e)
        {
            //NWN2Toolset.NWN2.Data.Blueprints.NWN2GlobalBlueprintManager bpManager = new NWN2Toolset.NWN2.Data.Blueprints.NWN2GlobalBlueprintManager();
            //bpManager.Initialize();
            NWN2Toolset.NWN2.Data.TypedCollections.NWN2BlueprintCollection items = NWN2Toolset.NWN2.Data.Blueprints.NWN2GlobalBlueprintManager.GetBlueprintsOfType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Item);
            ALFAItemBlueprint scroll;
            
            System.Windows.Forms.Form form = new System.Windows.Forms.Form();
            /*System.Windows.Forms.TextBox text = new System.Windows.Forms.TextBox();
            text.Size = new System.Drawing.Size(400, 300);
            text.Multiline = true;
            text.WordWrap = false;
            text.AcceptsReturn = true;
            text.AcceptsTab = true;
            text.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            text.Text = scroll.ToString();*/
            System.Windows.Forms.ListBox listBox = new System.Windows.Forms.ListBox();
            listBox.Sorted = true;
            listBox.HorizontalScrollbar = true;
            listBox.Size = new System.Drawing.Size(400, 300);

            form.Controls.Add(listBox);
            form.Size = new System.Drawing.Size(430, 330);
            form.Show();    

            //items.Add(scroll.ItemBlueprint);
            //scroll.TemplateResRef = "TEST RESREF";
            //scroll.AddItemProperty(ALFAItemProperty.CastSpell1ChargeItemProperty(0));
            //scroll.AddItemProperty(ALFAItemProperty.WizardOnlyItemProperty());            
            //items.Add(scroll.ItemBlueprint);

            ConsumableCreator cc = new ConsumableCreator();
            cc.Run();
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

        // Properties
        public string DisplayName
        {
            get
            {
                return "ABM Content Creator";
            }
        }

        public string MenuName
        {
            get
            {
                return "ABM Content Creator";
            }
        }

        public string Name
        {
            get
            {
                return "ABM Content Creator";
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

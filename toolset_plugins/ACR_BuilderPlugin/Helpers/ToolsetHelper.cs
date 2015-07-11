using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.Windows.Forms;

using NWN2Toolset;
using NWN2Toolset.Plugins;
using TD.SandBar;

namespace ACR_BuilderPlugin
{
    static class ToolsetHelper
    {
        public static Control GetControl(Type type, string name)
        {
            foreach (Control control in NWN2Toolset.NWN2ToolsetMainForm.App.Controls)
            {
                if (control.GetType() == type && control.Name == name)
                    return control;
            }
            throw new Exception(String.Format("Could not find Control of type {0} and name {1}.", type.ToString(), name));
        }

        public static UserControl GetControlOfFieldType(Type type)
        {
            FieldInfo[] fields = NWN2Toolset.NWN2ToolsetMainForm.App.GetType().GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static);
            foreach (FieldInfo field in fields)
            {
                if (field.FieldType == type)
                    return (UserControl)field.GetValue(NWN2Toolset.NWN2ToolsetMainForm.App);
            }
            throw new Exception(String.Format("Could not find UserControl of type {0}.", type.ToString()));
        }

        public static TD.SandBar.ToolBar GenerateToolBar(string name)
        {
            TD.SandBar.ToolBar toolBar = new TD.SandBar.ToolBar();
            toolBar.Name = name;
            toolBar.Overflow = ToolBarOverflow.Hide;
            toolBar.AllowHorizontalDock = true;
            toolBar.AllowRightToLeft = true;
            toolBar.AllowVerticalDock = true;
            toolBar.Closable = false;
            toolBar.Movable = true;
            toolBar.Tearable = true;
            toolBar.DockOffset = 2;
            toolBar.DockLine = 2;

            return toolBar;
        }

        public static ButtonItem GenerateButtonItem(string text, EventHandler e = null)
        {
            ButtonItem button = new ButtonItem();
            button.Text = text;
            if (e != null) button.Activate += e;
            return button;
        }

        public static MenuButtonItem GenerateMenuButtonItem(string text)
        {
            MenuButtonItem button = new MenuButtonItem();
            button.Text = text;
            return button;
        }

    }
}

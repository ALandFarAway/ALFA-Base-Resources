using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ALFA.Shared;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

namespace ACR_ChooserCreator
{
    public static class Waiter
    {
        public static void WaitForNavigator(CLRScriptBase script, Navigator nav)
        {
            if (nav.WaitForResourcesLoaded(false) == true)
            {
                DrawNavigatorCategory(script, nav.bottomCategory);
                return;
            }
            else
            {
                script.SendMessageToPC(script.OBJECT_SELF, "loading...");
                script.DelayCommand(0.5f, delegate() { WaitForNavigator(script, nav); });
                return;
            }
        }

        public static void WaitForResources(CLRScriptBase script, IBackgroundLoadedResource resource)
        {
            if (resource.WaitForResourcesLoaded(false) == true)
            {
                DrawListBox(script, (resource as IDrawableList).ListBox);
                return;
            }
            else
            {
                // TODO: Display the 'thinking' animation.
                script.DelayCommand(0.5f, delegate() { WaitForResources(script, resource); });
                return;
            }
        }

        public static void DrawNavigatorCategory(CLRScriptBase script, NavigatorCategory nav)
        {
            if (nav != null)
            {
                script.ClearListBox(script.OBJECT_SELF, "SCREEN_DMC_CREATOR", "LISTBOX_ACR_CREATOR");
                if (nav.ParentCategory != null)
                {
                    string textFields = "LISTBOX_ITEM_TEXT=  ..";
                    string variables = "5=Category:..";
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_DMC_CREATOR", "LISTBOX_ACR_CREATOR", "Category:..", textFields, "LISTBOX_ITEM_ICON=folder.tga", variables, "unhide");
                }
                foreach (NavigatorCategory navCat in nav.ContainedCategories)
                {
                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0}", navCat.DisplayName);
                    string variables = String.Format("5={0}", "Category:" + navCat.Name);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_DMC_CREATOR", "LISTBOX_ACR_CREATOR", "Category:" + navCat.Name, textFields, "LISTBOX_ITEM_ICON=folder.tga", variables, "unhide");
                }
                foreach (IListBoxItem navItem in nav.ContainedItems)
                {
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_DMC_CREATOR", "LISTBOX_ACR_CREATOR", navItem.RowName, navItem.TextFields, navItem.Icon, navItem.Variables, "unhide");
                }
            }
            else
            {
                script.SendMessageToPC(script.OBJECT_SELF, "Error: Navigator category is null. Cannot draw a list.");
            }
        }

        public static void DrawListBox(CLRScriptBase script, List<IListBoxItem> resource)
        {
            // TODO: Remove the last frame of the 'thinking' animation.
            if(resource != null)
            {
                foreach (IListBoxItem item in resource)
                {
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_DMC_CREATOR", "LISTBOX_ACR_CREATOR", item.RowName, item.TextFields, item.Icon, item.Variables, "unhide");
                }
            }
        }
    }
}

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
                DrawListBox(script, resource as IDrawableList);
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
                script.ClearListBox(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR");
                if (nav.ParentCategory != null)
                {
                    string textFields = "LISTBOX_ITEM_TEXT=  ..";
                    string variables = "5=Category:..";
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", "Category:..", textFields, "LISTBOX_ITEM_ICON=folder.tga", variables, "unhide");
                }
                foreach (NavigatorCategory navCat in nav.ContainedCategories)
                {
                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0}", navCat.DisplayName);
                    string variables = String.Format("5={0}", "Category:" + navCat.Name);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", "Category:" + navCat.Name, textFields, "LISTBOX_ITEM_ICON=folder.tga", variables, "unhide");
                }
                foreach (NavigatorItem navItem in nav.ContainedItems)
                {
                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {2}", navItem.DisplayName, navItem.Info1, navItem.Info2);
                    string variables = String.Format("5={0}", navItem.ResRef);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", navItem.Name, textFields, "LISTBOX_ITEM_ICON="+navItem.Icon, variables, "unhide");
                }
            }
            else
            {
                script.SendMessageToPC(script.OBJECT_SELF, "Error: Navigator category is null. Cannot draw a list.");
            }
        }

        public static void DrawListBox(CLRScriptBase script, IDrawableList resource)
        {
            // TODO: Remove the last frame of the 'thinking' animation.
            CreatureList resourceAsCreatureList = resource as CreatureList;
            if(resourceAsCreatureList != null)
            {
                script.ClearListBox(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR");
                foreach(ALFA.Shared.CreatureResource creature in resourceAsCreatureList.drawableList)
                {
                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {3:N1}", String.Format("{0} {1}", creature.FirstName, creature.LastName), ALFA.Shared.Modules.InfoStore.ModuleFactions[creature.FactionID].Name, creature.ChallengeRating);
                    string variables = String.Format("5={0}", creature.TemplateResRef);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", creature.TemplateResRef, textFields, "LISTBOX_ITEM_ICON=creature.tga", variables, "unhide");
                }
            }

            ItemList resourceAsItemList = resource as ItemList;
            if (resourceAsItemList != null)
            {
                script.ClearListBox(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR");
                foreach (ALFA.Shared.ItemResource item in resourceAsItemList.drawableList)
                {
                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {3:N1}", item.LocalizedName, item.Cost, item.AppropriateLevel);
                    string variables = String.Format("5={0}", item.TemplateResRef);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", item.TemplateResRef, textFields, "LISTBOX_ITEM_ICON=item.tga", variables, "unhide");
                }
            }

            PlaceableList resourceAsPlaceableList = resource as PlaceableList;
            if (resourceAsPlaceableList != null)
            {
                script.ClearListBox(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR");
                foreach (ALFA.Shared.PlaceableResource placeable in resourceAsPlaceableList.drawableList)
                {
                    string inventory = "";
                    if(placeable.HasInventory) inventory = "Inv";
                    string lockTrap = "";
                    if(placeable.Locked && placeable.Trapped) lockTrap = String.Format("L{0}/T{1}", placeable.LockDC, placeable.TrapDisarmDC);
                    else if(placeable.Locked) lockTrap = String.Format("L{0}", placeable.LockDC);
                    else if(placeable.Trapped) lockTrap = String.Format("T{0}", placeable.TrapDisarmDC);

                    string textFields = String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1};LISTBOX_ITEM_TEXT3= {3:N1}", placeable.Name, lockTrap, inventory);
                    string variables = String.Format("5={0}", placeable.TemplateResRef);
                    script.AddListBoxRow(script.OBJECT_SELF, "SCREEN_ACR_CREATOR", "LISTBOX_ACR_CREATOR", placeable.TemplateResRef, textFields, "LISTBOX_ITEM_ICON=item.tga", variables, "unhide");
                }
            }
        }
    }
}

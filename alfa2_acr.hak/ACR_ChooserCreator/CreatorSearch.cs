using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.IO;

using OEIShared.IO;
using OEIShared.IO.GFF;

using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

namespace ACR_ChooserCreator
{
    public class CreatorSearch : BackgroundWorker
    {
        NavigatorCategory responseObject;
        public NavigatorCategory baseCat;
        public User currentUser;

        public void SearchCreator(object Sender, EventArgs e)
        {
            responseObject = new NavigatorCategory();
            responseObject.ParentCategory = baseCat;
            SearchCat(baseCat);
            if (this.CancellationPending)
            {
                return;
            }
            currentUser.CreatorSearchResponse = responseObject;
        }

        public void SearchCat(NavigatorCategory currentCat)
        {
            foreach (ALFA.Shared.IListBoxItem item in currentCat.ContainedItems)
            {
                string[] rowDataEntries = item.TextFields.ToLower().Split(';');
                foreach(string rowData in rowDataEntries)
                {
                    string[] rowBit = rowData.Split('=');
                    if(rowBit.Length > 1)
                    {
                        if(rowBit[1].Contains(currentUser.LastSearchString.ToLower()) &&
                            !responseObject.ContainedItems.Contains(item))
                        {
                            responseObject.ContainedItems.Add(item);
                        }
                    }
                }
                if (this.CancellationPending)
                {
                    return;
                }
            }
            foreach (NavigatorCategory childCat in currentCat.ContainedCategories)
            {
                SearchCat(childCat);
            }
        }

        public static void WaitForSearch(CLRScriptBase script, User currentUser, ACR_ChooserCreator.ACR_CreatorCommand currentTab, CreatorSearch awaitedSearch)
        {
            if (awaitedSearch == null)
            {
                // Search has been removed. Abort.
                return;
            }
            if (awaitedSearch.CancellationPending)
            {
                // Search has been canceled. Abort.
                return;
            }
            if (currentUser.openCommand != currentTab)
            {
                // User has switched tabs. Kill the search.
                return;
            }
            if (currentUser.CreatorSearchResponse != null)
            {
                // Looks like we've finished. Draw a list!
                CreatorSearch oldSearch = currentUser.CurrentSearch;
                currentUser.CurrentSearch = null;
                oldSearch.Dispose();

                Waiter.DrawNavigatorCategory(script, currentUser.CreatorSearchResponse);
                switch (currentUser.openCommand)
                {
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_CREATURE_TAB:
                        currentUser.CurrentCreatureCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_ITEM_TAB:
                        currentUser.CurrentItemCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_LIGHTS_TAB:
                        currentUser.CurrentLightCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_PLACEABLE_TAB:
                        currentUser.CurrentPlaceableCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_TRAP_TAB:
                        currentUser.CurrentTrapCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_VFX_TAB:
                        currentUser.CurrentVisualEffectCategory = currentUser.CreatorSearchResponse;
                        break;
                    case ACR_ChooserCreator.ACR_CreatorCommand.ACR_CHOOSERCREATOR_FOCUS_WAYPOINT_TAB:
                        currentUser.CurrentWaypointCategory = currentUser.CreatorSearchResponse;
                        break;
                }
                return;
            }
            script.DelayCommand(1.0f, delegate { WaitForSearch(script, currentUser, currentTab, awaitedSearch); });
        }
    }
}

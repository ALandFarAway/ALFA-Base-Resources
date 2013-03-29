using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.ComponentModel;

namespace ACR_ChooserCreator
{
    class BackgroundLoader : BackgroundWorker
    {
        public static volatile string loaderError = "";

        public static void LoadNavigator(List<ALFA.Shared.IListBoxItem> list, Navigator bottomNavigator)
        {
            try
            {
                foreach (ALFA.Shared.IListBoxItem boxItem in list)
                {
                    try
                    {
                        NavigatorCategory cat = null;
                        // first, find out if there even is a classification for this.
                        if (String.IsNullOrWhiteSpace(boxItem.Classification))
                        {
                            cat = bottomNavigator.bottomCategory;
                        }
                        // next, we want to find out if we're in one classification or in many.
                        else if (boxItem.Classification.Contains('|'))
                        {
                            string[] cats = boxItem.Classification.Split('|');
                            NavigatorCategory tempCat = bottomNavigator.bottomCategory;

                            foreach (string category in cats)
                            {
                                tempCat = GetCategoryByName(tempCat, category);
                            }
                            cat = tempCat;
                        }
                        // Looks like it's only one classification deep. Don't need to do anything fancy.
                        else
                        {
                            cat = GetCategoryByName(bottomNavigator.bottomCategory, boxItem.Classification);
                        }

                        cat.ContainedItems.Add(boxItem);
                    }
                    catch (Exception ex)
                    {
                        loaderError += "\n Placeable Loading Error: " + ex.Message;
                    }
                }
            }
            finally
            {
                bottomNavigator.SetResourcesLoaded();
            }
        }

        public static void LoadNavigators(object Sender, EventArgs e)
        {
            ALFA.Shared.Modules.InfoStore.WaitForResourcesLoaded(true);

            try
            {
                List<ALFA.Shared.IListBoxItem> suppliedList = new List<ALFA.Shared.IListBoxItem>();
                foreach(ALFA.Shared.ItemResource item in ALFA.Shared.Modules.InfoStore.ModuleItems.Values)
                {
                    suppliedList.Add(item);
                }
                LoadNavigator(suppliedList, Navigators.ItemNavigator);
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadItems :" + ex.Message;
            }

            try
            {
                List<ALFA.Shared.IListBoxItem> suppliedList = new List<ALFA.Shared.IListBoxItem>();
                foreach (ALFA.Shared.CreatureResource item in ALFA.Shared.Modules.InfoStore.ModuleCreatures.Values)
                {
                    suppliedList.Add(item);
                }
                LoadNavigator(suppliedList, Navigators.CreatureNavigator);
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadCreatures :" + ex.Message;
            }

            try
            {
                List<ALFA.Shared.IListBoxItem> suppliedList = new List<ALFA.Shared.IListBoxItem>();
                foreach (ALFA.Shared.PlaceableResource item in ALFA.Shared.Modules.InfoStore.ModulePlaceables.Values)
                {
                    suppliedList.Add(item);
                }
                LoadNavigator(suppliedList, Navigators.PlaceableNavigator);
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadPlaceables :" + ex.Message;
            }

            try
            {
                List<ALFA.Shared.IListBoxItem> suppliedList = new List<ALFA.Shared.IListBoxItem>();
                foreach (ALFA.Shared.WaypointResource item in ALFA.Shared.Modules.InfoStore.ModuleWaypoints.Values)
                {
                    suppliedList.Add(item);
                }
                LoadNavigator(suppliedList, Navigators.WaypointNavigator);
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadWaypoints :" + ex.Message;
            }

            try
            {
                DefaultSortNavigators(Navigators.CreatureNavigator.bottomCategory);
                DefaultSortNavigators(Navigators.ItemNavigator.bottomCategory);
                DefaultSortNavigators(Navigators.PlaceableNavigator.bottomCategory);
                DefaultSortNavigators(Navigators.WaypointNavigator.bottomCategory);
            }
            catch (Exception ex)
            {
                loaderError += "\n SortingErrors :" + ex.Message;
            }
        }

        public static NavigatorCategory GetCategoryByName(NavigatorCategory ContainingCat, string SeekingName)
        {
            foreach (NavigatorCategory containedCat in ContainingCat.ContainedCategories)
            {
                if (containedCat.Name == SeekingName)
                    return containedCat;
            }
            NavigatorCategory newCat = new NavigatorCategory();
            newCat.Name = SeekingName;
            newCat.ParentCategory = ContainingCat;
            newCat.DisplayName = ALFA.Shared.DisplayString.ShortenStringToWidth(newCat.Name, 150);
            ContainingCat.ContainedCategories.Add(newCat);
            return newCat;
        }

        public static void DefaultSortNavigators(NavigatorCategory cat)
        {
            try
            {
                foreach (NavigatorCategory containedCat in cat.ContainedCategories)
                {
                    DefaultSortNavigators(containedCat);
                }
                cat.ContainedCategories.Sort();
                cat.ContainedItems.Sort();
            }
            catch(Exception ex)
            {
                loaderError += "\nSorting Error: " + ex.Message;
            }
        }
    }
}
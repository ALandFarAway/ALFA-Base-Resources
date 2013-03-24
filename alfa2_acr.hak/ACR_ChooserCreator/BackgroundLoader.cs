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

        private static void LoadCreatures()
        {
            try
            {
                foreach (ALFA.Shared.CreatureResource creature in ALFA.Shared.Modules.InfoStore.ModuleCreatures.Values)
                {
                    NavigatorCategory cat = null;
                    try
                    {
                        // first, find out if there even is a classification for this.
                        if (String.IsNullOrWhiteSpace(creature.Classification))
                        {
                            cat = Navigators.CreatureNavigator.bottomCategory;
                        }
                        // First, we want to find out if we're in one classification or in many.
                        else if (creature.Classification.Contains('|'))
                        {
                            string[] cats = creature.Classification.Split('|');
                            NavigatorCategory tempCat = Navigators.CreatureNavigator.bottomCategory;

                            foreach (string category in cats)
                            {
                                tempCat = GetCategoryByName(tempCat, category);
                            }
                            cat = tempCat;
                        }
                        else
                        {
                            // Looks like it's only one classification deep. Don't need to do anything fancy.
                            cat = GetCategoryByName(Navigators.CreatureNavigator.bottomCategory, creature.Classification);
                        }

                        cat.ContainedItems.Add(creature);
                    }
                    catch (Exception ex)
                    {
                        loaderError += "\n Creature Loading Error: " + ex.Message;
                    }
                }
            }
            finally
            {
                Navigators.CreatureNavigator.SetResourcesLoaded();
            }
        }

        private static void LoadItems()
        {
            try
            {
                foreach (ALFA.Shared.ItemResource item in ALFA.Shared.Modules.InfoStore.ModuleItems.Values)
                {
                    try
                    {
                        NavigatorCategory cat = null;
                        // first, find out if there even is a classification for this.
                        if (String.IsNullOrWhiteSpace(item.Classification))
                        {
                            cat = Navigators.ItemNavigator.bottomCategory;
                        }
                        // next, we want to find out if we're in one classification or in many.
                        else if (item.Classification.Contains('|'))
                        {
                            string[] cats = item.Classification.Split('|');
                            NavigatorCategory tempCat = Navigators.ItemNavigator.bottomCategory;

                            foreach (string category in cats)
                            {
                                tempCat = GetCategoryByName(tempCat, category);
                            }
                            cat = tempCat;
                        }
                        // Looks like it's only one classification deep. Don't need to do anything fancy.
                        else
                        {
                            cat = GetCategoryByName(Navigators.ItemNavigator.bottomCategory, item.Classification);
                        }

                        cat.ContainedItems.Add(item);
                    }
                    catch (Exception ex)
                    {
                        loaderError += "\n Item Loading Error: " + ex.Message;
                    }
                }
            }
            finally
            {
                Navigators.ItemNavigator.SetResourcesLoaded();
            }
        }

        private static void LoadPlaceables()
        {
            try
            {
                foreach (ALFA.Shared.PlaceableResource placeable in ALFA.Shared.Modules.InfoStore.ModulePlaceables.Values)
                {
                    try
                    {
                        NavigatorCategory cat = null;
                        // first, find out if there even is a classification for this.
                        if (String.IsNullOrWhiteSpace(placeable.Classification))
                        {
                            cat = Navigators.PlaceableNavigator.bottomCategory;
                        }
                        // next, we want to find out if we're in one classification or in many.
                        else if (placeable.Classification.Contains('|'))
                        {
                            string[] cats = placeable.Classification.Split('|');
                            NavigatorCategory tempCat = Navigators.PlaceableNavigator.bottomCategory;

                            foreach (string category in cats)
                            {
                                tempCat = GetCategoryByName(tempCat, category);
                            }
                            cat = tempCat;
                        }
                        // Looks like it's only one classification deep. Don't need to do anything fancy.
                        else
                        {
                            cat = GetCategoryByName(Navigators.PlaceableNavigator.bottomCategory, placeable.Classification);
                        }

                        cat.ContainedItems.Add(placeable);
                    }
                    catch (Exception ex)
                    {
                        loaderError += "\n Placeable Loading Error: " + ex.Message;
                    }
                }
            }
            finally
            {
                Navigators.PlaceableNavigator.SetResourcesLoaded();
            }
        }

        public static void LoadNavigators(object Sender, EventArgs e)
        {
            ALFA.Shared.Modules.InfoStore.WaitForResourcesLoaded(true);

            try
            {
                LoadItems();
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadItems :" + ex.Message;
            }

            try
            {
                LoadCreatures();
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadCreatures :" + ex.Message;
            }

            try
            {
                LoadPlaceables();
            }
            catch (Exception ex)
            {
                loaderError += "\n LoadPlaceables :" + ex.Message;
            }

            try
            {
                DefaultSortNavigators(Navigators.CreatureNavigator.bottomCategory);
                DefaultSortNavigators(Navigators.ItemNavigator.bottomCategory);
                DefaultSortNavigators(Navigators.PlaceableNavigator.bottomCategory);
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
            if (newCat.Name.Length > 18) newCat.DisplayName = newCat.Name.Substring(0, 14) + "...";
            else newCat.DisplayName = newCat.Name;
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
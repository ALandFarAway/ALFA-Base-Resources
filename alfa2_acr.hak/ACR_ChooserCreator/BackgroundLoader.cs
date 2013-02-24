using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.ComponentModel;

namespace ACR_ChooserCreator
{
    class BackgroundLoader : BackgroundWorker
    {
        public static void LoadNavigators(object Sender, EventArgs e)
        {
            Navigators.CreatureNavigator = new Navigator();
            Navigators.ItemNavigator = new Navigator();
            Navigators.PlaceableNavigator = new Navigator();

            ALFA.Shared.Modules.InfoStore.WaitForResourcesLoaded(true);

            foreach(ALFA.Shared.CreatureResource creature in ALFA.Shared.Modules.InfoStore.ModuleCreatures.Values)
            {
                NavigatorCategory cat;
                // First, we want to find out if we're in one classification or in many.
                if (creature.Classification.Contains('|'))
                {
                    string[] cats = creature.Classification.Split('|');
                    NavigatorCategory tempCat = Navigators.CreatureNavigator.bottomCategory;

                    foreach (string category in cats)
                    {
                        tempCat = GetCategoryByName(tempCat, category);
                    }
                    cat = tempCat;
                }
                // Looks like it's only one classification deep. Don't need to do anything fancy.
                else
                {
                    cat = GetCategoryByName(Navigators.CreatureNavigator.bottomCategory, creature.Classification);
                }

                cat.ContainedItems.Add(new NavigatorItem()
                {
                    Icon = "creature.tga",
                    Name = creature.FirstName + " " + creature.LastName,
                    ResRef = creature.TemplateResRef,
                    Info1 = ALFA.Shared.Modules.InfoStore.ModuleFactions[creature.FactionID].Name,
                    Info2 = String.Format("{0:N1}", creature.ChallengeRating)
                });
            }
            Navigators.CreatureNavigator.SetResourcesLoaded();

            foreach (ALFA.Shared.ItemResource item in ALFA.Shared.Modules.InfoStore.ModuleItems.Values)
            {
                NavigatorCategory cat;
                // First, we want to find out if we're in one classification or in many.
                if (item.Classification.Contains('|'))
                {
                    string[] cats = item.Classification.Split('|');
                    NavigatorCategory tempCat = Navigators.CreatureNavigator.bottomCategory;

                    foreach (string category in cats)
                    {
                        tempCat = GetCategoryByName(tempCat, category);
                    }
                    cat = tempCat;
                }
                // Looks like it's only one classification deep. Don't need to do anything fancy.
                else
                {
                    cat = GetCategoryByName(Navigators.CreatureNavigator.bottomCategory, item.Classification);
                }

                cat.ContainedItems.Add(new NavigatorItem()
                {
                    Icon = "item.tga",
                    Name = item.LocalizedName,
                    ResRef = item.TemplateResRef,
                    Info1 = item.Cost.ToString(),
                    Info2 = item.AppropriateLevel.ToString()
                });
            }
            Navigators.ItemNavigator.SetResourcesLoaded();

            foreach (ALFA.Shared.PlaceableResource placeable in ALFA.Shared.Modules.InfoStore.ModulePlaceables.Values)
            {
                NavigatorCategory cat;
                // First, we want to find out if we're in one classification or in many.
                if (placeable.Classification.Contains('|'))
                {
                    string[] cats = placeable.Classification.Split('|');
                    NavigatorCategory tempCat = Navigators.CreatureNavigator.bottomCategory;

                    foreach (string category in cats)
                    {
                        tempCat = GetCategoryByName(tempCat, category);
                    }
                    cat = tempCat;
                }
                // Looks like it's only one classification deep. Don't need to do anything fancy.
                else
                {
                    cat = GetCategoryByName(Navigators.CreatureNavigator.bottomCategory, placeable.Classification);
                }

                string inventory = "";
                if(placeable.HasInventory) inventory = "Inv";
                string lockTrap = "";
                if(placeable.Locked && placeable.Trapped) lockTrap = String.Format("L{0}/T{1}", placeable.LockDC, placeable.TrapDisarmDC);
                else if(placeable.Locked) lockTrap = String.Format("L{0}", placeable.LockDC);
                else if(placeable.Trapped) lockTrap = String.Format("T{0}", placeable.TrapDisarmDC);

                cat.ContainedItems.Add(new NavigatorItem()
                {
                    Icon = "placeable.tga",
                    Name = placeable.Name,
                    ResRef = placeable.TemplateResRef,
                    Info1 = lockTrap,
                    Info2 = inventory
                });
            }
            Navigators.PlaceableNavigator.SetResourcesLoaded();
        }

        public static NavigatorCategory GetCategoryByName(NavigatorCategory ContainingCat, string SeekingName)
        {
            foreach (NavigatorCategory containedCat in ContainingCat.ContainedCategories)
            {
                if (containedCat.Name == SeekingName)
                    return containedCat;
            }

            return new NavigatorCategory() { Name = SeekingName, ParentCategory = ContainingCat };
        }
    }
}
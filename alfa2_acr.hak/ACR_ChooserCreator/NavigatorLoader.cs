using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Threading;

namespace ACR_ChooserCreator
{
    public class NavigatorLoader : BackgroundWorker
    {
        public static void BuildNavigators()
        {
            while (ALFA.Shared.Modules.InfoStore.ResourcesLoaded == false)
            {
                Thread.Sleep(1000);
            }

            if (Navigators.CreatureNavigator.ResourcesLoaded == false)
            {
                foreach(ALFA.Shared.CreatureResource creature in ALFA.Shared.Modules.InfoStore.ModuleCreatures.Values)
                {
                    // Firstly, we don't necessarily know that any given creature has a classification, so it might
                    // not belong in any folder. Catch those first, and plop them as items in the base category.
                    if (creature.Classification == null || creature.Classification.Trim() == "")
                    {
                        NavigatorItem addedNavItem = new NavigatorItem()
                        {
                            Name = creature.FirstName + " " + creature.LastName,
                            Info1 = ALFA.Shared.Modules.InfoStore.ModuleFactions[creature.FactionID].Name,
                            Info2 = String.Format("{0:N1}", creature.ChallengeRating),
                            Icon = "creature.tga",
                            ResRef = creature.TemplateResRef
                        };

                        Navigators.CreatureNavigator.bottomCategory.ContainedItems.Add(addedNavItem);
                    }
                }
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NWN2Toolset.NWN2.Data.Blueprints;
using NWN2Toolset.NWN2.Data.Templates;

namespace ABM_creator
{
    class CraftingStore : NWN2StoreBlueprint
    {
        ushort storeResourceType = OEIShared.Utils.BWResourceTypes.GetResourceType("UTM");

        public CraftingStore(string _name, string _tag)
        {
            Resource = Globals.repository.CreateResource(new OEIShared.Utils.OEIResRef(_tag), storeResourceType);

            BuyFromPlayerPricePercent = 0;
            SellToPlayerPricePercent = 50;

            TemplateResRef = new OEIShared.Utils.OEIResRef(_tag);
            Tag = _tag;
            ResourceName = new OEIShared.Utils.OEIResRef(_tag);

            LocalizedName = new OEIShared.Utils.OEIExoLocString();
            LocalizedName[OEIShared.Utils.BWLanguages.BWLanguage.English] = _name;

            Globals.AddBlueprint(this);
        }

        public void addToPotionItems(NWN2ItemBlueprint bp)
        {
            NWN2BlueprintStoreItemInfo storeItem = new NWN2BlueprintStoreItemInfo();
            storeItem.Item = bp.Resource;
            storeItem.Infinite = true;
            storeItem.Droppable = false;
            storeItem.Pickpocketable = false;
            PotionItems.Add(storeItem);
        }
    }
}

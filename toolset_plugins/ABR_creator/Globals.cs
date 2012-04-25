using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OEIShared.IO;
using OEIShared.IO.TwoDA;
using OEIShared.IO.TalkTable;
using NWN2Toolset.NWN2.Rules;
using NWN2Toolset.NWN2.Data;
using NWN2Toolset.NWN2.Data.TypedCollections;
using NWN2Toolset.NWN2.Data.Blueprints;

namespace ABM_creator
{
    static class Globals
    {

        static public TalkTable customTlk;
        static public TwoDAManager tdaManager;
        static public TwoDAFile spellschools2da, iprp_spells2da, nwn2_icons2da;
        static public CNWSpellArray spells;

        static public NWN2BlueprintCollection items;
        static public NWN2GameModule mod;
        static public NWN2BlueprintCollection globalItemCollection;
        static public Dictionary<string, int> iconHash;
        static public IResourceRepository repository;

        static Globals()
        {
            mod = NWN2Toolset.NWN2ToolsetMainForm.App.Module;
            repository = mod.Repository;
            items = mod.GetBlueprintCollectionForType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Item);

            customTlk = new OEIShared.IO.TalkTable.TalkTable();
            customTlk.OpenCustom(OEIShared.Utils.BWLanguages.BWLanguage.English, "alfa_acr02.tlk");

            tdaManager = TwoDAManager.Instance;

            spellschools2da = tdaManager.Get("spellschools");
            nwn2_icons2da = tdaManager.Get("nwn2_icons");
            iprp_spells2da = tdaManager.Get("iprp_spells");

            spells = new NWN2Toolset.NWN2.Rules.CNWSpellArray();
            spells.Load();

            globalItemCollection = NWN2Toolset.NWN2.Data.Blueprints.NWN2GlobalBlueprintManager.GetBlueprintsOfType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Item);

            iconHash = new Dictionary<string, int>();
            int rowCount = Globals.nwn2_icons2da.RowCount;
            for (int i = 0; i < rowCount; i++)
            {
                string twodaString = Globals.nwn2_icons2da["ICON"][i];
                if (!iconHash.ContainsKey(twodaString))
                {
                    iconHash.Add(twodaString, i);
                }
            }
        }

        static public void AddBlueprint(NWN2ItemBlueprint ibp)
        {
            ibp.BlueprintLocation = mod.BlueprintLocation;
            ibp.Resource = mod.Repository.CreateResource(new OEIShared.Utils.OEIResRef(ibp.TemplateResRef.Value), ibp.ResourceType);
            mod.GetBlueprintCollectionForType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Item).Add(ibp);
        }

        static public void AddBlueprint(NWN2StoreBlueprint bp)
        {
            bp.BlueprintLocation = mod.BlueprintLocation;
            bp.Resource = mod.Repository.CreateResource(new OEIShared.Utils.OEIResRef(bp.TemplateResRef.Value), bp.ResourceType);
            mod.GetBlueprintCollectionForType(NWN2Toolset.NWN2.Data.Templates.NWN2ObjectType.Store).Add(bp);
        }

        static public int getIconId(string iconName)
        {
            try
            {
                return Globals.iconHash[iconName];
            }
            catch
            {
                DebugWindow.PrintDebugMessage("Cannot find '" + iconName + "' in nwn2_icons.2da.");
                return 0;
            }
        }
    }
}

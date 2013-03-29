using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.IO;

using OEIShared.IO;
using OEIShared.IO.GFF;

using ALFA;

namespace ACR_Candlekeep
{
    public class Archivist : BackgroundWorker
    {
        public static ALFA.ResourceManager manager;
        static public OEIShared.IO.TalkTable.TalkTable customTlk;
        static public OEIShared.IO.TalkTable.TalkTable dialog;

        public void InitializeArchives(object Sender, EventArgs e)
        {
            // TODO: Allow this to be configured.
            try
            {
                manager = new ALFA.ResourceManager(null);
                LoadModuleProperties();

                dialog = new OEIShared.IO.TalkTable.TalkTable();
                dialog.Open(OEIShared.Utils.BWLanguages.BWLanguage.English);
                
                if (!String.IsNullOrEmpty(customTlkFileName))
                {
                    customTlk = new OEIShared.IO.TalkTable.TalkTable();
                    customTlk.OpenCustom(OEIShared.Utils.BWLanguages.BWLanguage.English, customTlkFileName);
                }

                ALFA.Shared.Modules.InfoStore.ModuleItems = new Dictionary<string, ALFA.Shared.ItemResource>();
                ALFA.Shared.Modules.InfoStore.ModuleCreatures = new Dictionary<string, ALFA.Shared.CreatureResource>();
                ALFA.Shared.Modules.InfoStore.ModulePlaceables = new Dictionary<string, ALFA.Shared.PlaceableResource>();
                ALFA.Shared.Modules.InfoStore.ModuleWaypoints = new Dictionary<string, ALFA.Shared.WaypointResource>();
                ALFA.Shared.Modules.InfoStore.ModuleFactions = new Dictionary<int, ALFA.Shared.Faction>();

                List<int> factionIndex = new List<int>();

                #region Caching Information about All Items
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTI))
                {
                    try
                    {
                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                        string currentResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        if (ALFA.Shared.Modules.InfoStore.ModuleItems.Keys.Contains(currentResRef))
                        {
                            // If we have competing resources, we expect that GetResourcesByType will give us the
                            // resource of greatest priority first. Therefore, redundant entries of a given resref
                            // are trash.
                            continue;
                        }

                        ALFA.Shared.ItemResource addingItem = new ALFA.Shared.ItemResource();
                        try
                        {
                            addingItem.LocalizedName = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingItem.LocalizedName = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString();
                        }
                        if (addingItem.LocalizedName == "")
                        {
                            addingItem.LocalizedName = GetTlkEntry(currentGFF.TopLevelStruct["LocalizedName"].ValueCExoLocString.StringRef);
                        }

                        // Might be a talk table reference. Let's see...
                        if (addingItem.LocalizedName.Contains('{') && addingItem.LocalizedName.Contains('}'))
                        {
                            string attemptingName = GffStoreToTlk(addingItem.LocalizedName);
                            if (attemptingName != "") addingItem.LocalizedName = attemptingName;
                        }

                        addingItem.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());

                        addingItem.TemplateResRef = currentResRef;
                        addingItem.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                        int Cost, CostModify, BaseItem;
                        bool Cursed = false, Plot = false, Stolen = false;
                        Int32.TryParse(currentGFF.TopLevelStruct["Cost"].Value.ToString(), out Cost);
                        Int32.TryParse(currentGFF.TopLevelStruct["ModifyCost"].Value.ToString(), out CostModify);
                        Int32.TryParse(currentGFF.TopLevelStruct["BaseItem"].Value.ToString(), out BaseItem);
                        if (currentGFF.TopLevelStruct["Cursed"].Value.ToString() == "1") Cursed = true;
                        if (currentGFF.TopLevelStruct["Plot"].Value.ToString() == "1") Plot = true;
                        if (currentGFF.TopLevelStruct["Stolen"].Value.ToString() == "1") Stolen = true;

                        addingItem.Cost = Cost + CostModify;
                        addingItem.BaseItem = BaseItem;
                        addingItem.Cursed = Cursed;
                        addingItem.Plot = Plot;
                        addingItem.Stolen = Stolen;

                        addingItem.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModuleItems.Add(currentResRef, addingItem);
                    }
                    catch { }
                }
                #endregion

                #region Caching Information about All Creatures
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTC))
                {
                    try
                    {
                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                        string currentResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(currentResRef))
                        {
                            continue;
                        }

                        ALFA.Shared.CreatureResource addingCreature = new ALFA.Shared.CreatureResource();

                        try
                        {
                            addingCreature.FirstName = currentGFF.TopLevelStruct["FirstName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingCreature.FirstName = currentGFF.TopLevelStruct["FirstName"].Value.ToString();
                        }
                        if (addingCreature.FirstName == "")
                        {
                            addingCreature.FirstName = GetTlkEntry(currentGFF.TopLevelStruct["FirstName"].ValueCExoLocString.StringRef);
                        }

                        try
                        {
                            addingCreature.LastName = currentGFF.TopLevelStruct["LastName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingCreature.LastName = currentGFF.TopLevelStruct["LastName"].Value.ToString();
                        }
                        if (addingCreature.LastName == "")
                        {
                            addingCreature.LastName = GetTlkEntry(currentGFF.TopLevelStruct["LastName"].ValueCExoLocString.StringRef);
                        }

                        addingCreature.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());

                        addingCreature.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        addingCreature.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                        if (currentGFF.TopLevelStruct["IsImmortal"].Value.ToString() == "0")
                            addingCreature.IsImmortal = false;
                        else
                            addingCreature.IsImmortal = true;

                        float calculatedCR = 0.0f;
                        if (float.TryParse(currentGFF.TopLevelStruct["ChallengeRating"].Value.ToString(), out calculatedCR))
                        {
                            addingCreature.ChallengeRating = calculatedCR;
                        }

                        int faction;
                        if (Int32.TryParse(currentGFF.TopLevelStruct["FactionID"].Value.ToString(), out faction))
                        {
                            addingCreature.FactionID = faction;
                            if (!factionIndex.Contains(faction)) factionIndex.Add(faction);
                        }

                        int LawChaos;
                        if (Int32.TryParse(currentGFF.TopLevelStruct["LawfulChaotic"].Value.ToString(), out LawChaos))
                        {
                            addingCreature.LawfulChaotic = LawChaos;
                        }

                        int GoodEvil;
                        if (Int32.TryParse(currentGFF.TopLevelStruct["GoodEvil"].Value.ToString(), out GoodEvil))
                        {
                            addingCreature.GoodEvil = GoodEvil;
                        }

                        string AlignSummary;
                        if (GoodEvil < 31) AlignSummary = "E";
                        else if (GoodEvil < 70) AlignSummary = "N";
                        else AlignSummary = "G";

                        if (LawChaos < 31) AlignSummary = "C" + AlignSummary;
                        else if (LawChaos < 70 && AlignSummary == "N") AlignSummary = "TN";
                        else if (LawChaos < 70) AlignSummary = "N" + AlignSummary;
                        else AlignSummary = "L" + AlignSummary;

                        addingCreature.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModuleCreatures.Add(addingCreature.TemplateResRef, addingCreature);
                    }
                    catch { }
                }
                #endregion

                #region Caching Information about All Placeables
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTP))
                {
                    try
                    {
                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                        string currentResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(currentResRef))
                        {
                            continue;
                        }

                        ALFA.Shared.PlaceableResource addingPlaceable = new ALFA.Shared.PlaceableResource();

                        try
                        {
                            addingPlaceable.Name = currentGFF.TopLevelStruct["LocName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingPlaceable.Name = currentGFF.TopLevelStruct["LocName"].Value.ToString();
                        }
                        if (addingPlaceable.Name == "")
                        {
                            addingPlaceable.Name = GetTlkEntry(currentGFF.TopLevelStruct["LocalizedName"].ValueCExoLocString.StringRef);
                        }

                        addingPlaceable.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());


                        addingPlaceable.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        addingPlaceable.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();
                        addingPlaceable.Useable = currentGFF.TopLevelStruct["Useable"].Value.ToString() != "0";
                        addingPlaceable.HasInventory = currentGFF.TopLevelStruct["HasInventory"].Value.ToString() != "0";
                        addingPlaceable.Trapped = currentGFF.TopLevelStruct["Useable"].Value.ToString() != "0";
                        addingPlaceable.Locked = currentGFF.TopLevelStruct["Locked"].Value.ToString() != "0";

                        int trapDisarmDC = 0, trapDetectDC = 0, unlockDC = 0;
                        if (Int32.TryParse(currentGFF.TopLevelStruct["TrapDetectDC"].Value.ToString(), out trapDetectDC))
                        {
                            addingPlaceable.TrapDetectDC = trapDetectDC;
                        }
                        if (Int32.TryParse(currentGFF.TopLevelStruct["DisarmDC"].Value.ToString(), out trapDetectDC))
                        {
                            addingPlaceable.TrapDisarmDC = trapDisarmDC;
                        }
                        if (Int32.TryParse(currentGFF.TopLevelStruct["OpenLockDC"].Value.ToString(), out trapDetectDC))
                        {
                            addingPlaceable.LockDC = unlockDC;
                        }

                        addingPlaceable.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModulePlaceables.Add(addingPlaceable.TemplateResRef, addingPlaceable);
                    }
                    catch { }
                }
                #endregion

                #region Caching Information about Factions
                factionIndex.Sort();
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResFAC))
                {
                    try
                    {
                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                        int count = 0;
                        foreach (GFFStruct field in currentGFF.TopLevelStruct["FactionList"].ValueList.StructList)
                        {
                            ALFA.Shared.Faction addingFaction = new ALFA.Shared.Faction();
                            addingFaction.Name = field.GetFieldSafe("FactionName").Value.ToString();
                            ALFA.Shared.Modules.InfoStore.ModuleFactions.Add(factionIndex[count], addingFaction);
                            count++;
                        }

                        // If there are multiple .FAC resources, we only care about the one that gets priority.
                        if (ALFA.Shared.Modules.InfoStore.ModuleFactions.Count > 0) break;
                    }
                    catch { }
                }
                #endregion

                #region Caching Information about Waypoints
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTW))
                {
                    try
                    {
                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);

                        string currentResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(currentResRef))
                        {
                            continue;
                        }

                        ALFA.Shared.WaypointResource addingWaypoint = new ALFA.Shared.WaypointResource();

                        addingWaypoint.TemplateResRef = currentResRef;

                        try
                        {
                            addingWaypoint.Name = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingWaypoint.Name = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString();
                        }
                        if (addingWaypoint.Name == "")
                        {
                            addingWaypoint.Name = GetTlkEntry(currentGFF.TopLevelStruct["LocalizedName"].ValueCExoLocString.StringRef);
                        }
                        
                        addingWaypoint.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());
                        addingWaypoint.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                        addingWaypoint.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModuleWaypoints.Add(addingWaypoint.TemplateResRef, addingWaypoint);
                    }
                    catch { }
                }
                #endregion


                #region Commented-Out Resource Types
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.Res2DA))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResARE))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBBX))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBIC))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBMP))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResBMU))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResCAM))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDDS))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDFT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDLG))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResDWK))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResFAC))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResFXA))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGFF))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGIC))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGIT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGR2))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResGUI))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResIFO))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResINI))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResINVALID))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResITP))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResJPG))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResJRL))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResLTR))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResMDB))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResMDL))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNCS))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNDB))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResNSS))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPFB))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPFX))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPLT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPTM))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPTT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPWC))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResPWK))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSEF))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSET))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSPT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResSSF))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTGA))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRn))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRN))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRx))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTRX))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTXI))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResTXT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUEN))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResULT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUPE))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUSC))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTD))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTE))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTM))
                //{ }

                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTR))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTS))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTT))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWAV))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWLK))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResWOK))
                //{ }
                //foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResXML))
                //{ }
                #endregion
            }
            catch { }

            ACR_Candlekeep.ArchivesInstance.SetResourcesLoaded();
        }

        private static string ParseClassification(string classification)
        {
            string[] attemptingClasses = classification.Split('|');
            if (attemptingClasses.Length > 1)
            {
                string builtClass = "";
                foreach (string attClass in attemptingClasses)
                {
                    if (attClass.Contains('{') && attClass.Contains('}'))
                    {
                        string madeClass = GffStoreToTlk(attClass);
                        if (madeClass != "")
                        {
                            if (builtClass != "") builtClass += "|" + madeClass;
                            else builtClass = madeClass;
                        }
                    }
                    else
                    {
                        if (builtClass != "") builtClass += "|" + attClass;
                        else builtClass = attClass;
                    }
                }
                builtClass.TrimStart('|');
                return builtClass;
            }
            else
            {
                if (classification.Contains('{') && classification.Contains('}'))
                {
                    string madeClass = GffStoreToTlk(classification);
                    if (madeClass != "")
                    {
                        return madeClass;
                    }
                    return classification;
                }
            }
            return classification;
        }

        static public string GetTlkEntry(uint num)
        {
            if (((num & OEIShared.IO.TalkTable.TalkTable.nCustomMask) != 0) && (customTlk != null))
                return customTlk[num].String;
            else return dialog[num].String;
        }

        static public string GffStoreToTlk(string num)
        {
            num = num.Trim();
            num = num.TrimStart('{');
            num = num.TrimEnd('}');
            int attemptingTlk;
            if (Int32.TryParse(num, out attemptingTlk))
            {
                return GetTlkEntry((uint)attemptingTlk);
            }
            return "";
        }

        /// <summary>
        /// Load various data from the module.ifo file.
        /// </summary>
        static private void LoadModuleProperties()
        {
            GFFFile moduleIfo = manager.OpenModuleIfo();

            customTlkFileName = moduleIfo.TopLevelStruct.GetExoStringSafe("Mod_CustomTlk").Value;

            if (!String.IsNullOrEmpty(customTlkFileName))
            {
                int offset = customTlkFileName.IndexOf('.');

                if (offset != -1)
                    customTlkFileName = customTlkFileName.Substring(0, offset);

                customTlkFileName += ".tlk";
            }
        }

        /// <summary>
        /// The custom talk table file name, if any.
        /// </summary>
        static private string customTlkFileName = null;
    }
}
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
namespace ACR_Candlekeep
{
    public class Archivist : BackgroundWorker
    {
        public static volatile string debug = "";
        public static ALFA.ResourceManager manager;
        static public OEIShared.IO.TalkTable.TalkTable customTlk;
        static public OEIShared.IO.TalkTable.TalkTable dialog;

        public void InitializeArchives(object Sender, EventArgs e)
        {
            // TODO: Allow this to be configured.
            try
            {
                Archivist.debug += "\nAttempting to make a new ResourceManager";
                manager = new ALFA.ResourceManager(null);
                LoadModuleProperties();

                Archivist.debug += "\nAttempting to open the default talk table";
                dialog = new OEIShared.IO.TalkTable.TalkTable();
                dialog.Open(OEIShared.Utils.BWLanguages.BWLanguage.English);

                Archivist.debug += "\nAttempting to open the custom talk table";
                if (!String.IsNullOrEmpty(customTlkFileName))
                {
                    customTlk = new OEIShared.IO.TalkTable.TalkTable();
                    customTlk.OpenCustom(OEIShared.Utils.BWLanguages.BWLanguage.English, customTlkFileName);
                }

                Archivist.debug += "\nInitializing ALFA.Shared collections";
                ALFA.Shared.Modules.InfoStore.ModuleItems = new Dictionary<string, ALFA.Shared.ItemResource>();
                ALFA.Shared.Modules.InfoStore.ModuleCreatures = new Dictionary<string, ALFA.Shared.CreatureResource>();
                ALFA.Shared.Modules.InfoStore.ModulePlaceables = new Dictionary<string, ALFA.Shared.PlaceableResource>();
                ALFA.Shared.Modules.InfoStore.ModuleWaypoints = new Dictionary<string, ALFA.Shared.WaypointResource>();
                ALFA.Shared.Modules.InfoStore.ModuleFactions = new Dictionary<int, ALFA.Shared.Faction>();
                ALFA.Shared.Modules.InfoStore.ModuleVisualEffects = new Dictionary<string, ALFA.Shared.VisualEffectResource>();
                ALFA.Shared.Modules.InfoStore.ModuleLights = new Dictionary<string, ALFA.Shared.LightResource>();
                ALFA.Shared.Modules.InfoStore.ModuleTraps = new Dictionary<string, ALFA.Shared.TrapResource>();

                ALFA.Shared.Modules.InfoStore.SpawnedTrapTriggers = new Dictionary<string, ALFA.Shared.ActiveTrap>();
                ALFA.Shared.Modules.InfoStore.SpawnedTrapDetect = new Dictionary<string, ALFA.Shared.ActiveTrap>();

                ALFA.Shared.Modules.InfoStore.ModifiedGff = new Dictionary<string, GFFFile>();

                ALFA.Shared.Modules.InfoStore.CoreSpells = new Dictionary<int, ALFA.Shared.Spell>();

                Archivist.debug += "\nInitializing standard factions";
                List<int> factionIndex = new List<int>();
                factionIndex.Add(0); // Player
                factionIndex.Add(1); // Hostile
                factionIndex.Add(2); // Commoner
                factionIndex.Add(3); // Merchant
                factionIndex.Add(4); // Defender

                // The damage-doing traps from the original campaign, converted to
                // our purposes.
                Archivist.debug += "\nAdding standard traps";
                AddStandardTraps();

                #region Caching Information about All Items
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTI))
                {
                    try
                    {
                        if (ALFA.Shared.Modules.InfoStore.ModuleItems.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            // If we have competing resources, we expect that GetResourcesByType will give us the
                            // resource of greatest priority first. Therefore, redundant entries of a given resref
                            // are trash.
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        ALFA.Shared.ItemResource addingItem = new ALFA.Shared.ItemResource();
                        addingItem.ResourceName = resource.FullName.Split('.')[0].ToLower();
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

                        addingItem.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
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

                        ALFA.Shared.Modules.InfoStore.ModuleItems.Add(addingItem.ResourceName, addingItem);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
                }
                #endregion

                #region Caching Information about All Creatures
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTC))
                {
                    try
                    {
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        ALFA.Shared.CreatureResource addingCreature = new ALFA.Shared.CreatureResource();

                        addingCreature.ResourceName = resource.FullName.Split('.')[0].ToLower();
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

                        ALFA.Shared.Modules.InfoStore.ModuleCreatures.Add(addingCreature.ResourceName, addingCreature);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
                }
                #endregion

                #region Caching Information about All Placeables
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUTP))
                {
                    try
                    {
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        ALFA.Shared.PlaceableResource addingPlaceable = new ALFA.Shared.PlaceableResource();
                        addingPlaceable.ResourceName = resource.FullName.Split('.')[0].ToLower();
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
                            addingPlaceable.Name = GetTlkEntry(currentGFF.TopLevelStruct["LocName"].ValueCExoLocString.StringRef);
                        }

                        addingPlaceable.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());

                        addingPlaceable.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        addingPlaceable.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();
                        addingPlaceable.Useable = currentGFF.TopLevelStruct["Useable"].Value.ToString() != "0";
                        addingPlaceable.HasInventory = currentGFF.TopLevelStruct["HasInventory"].ValueByte != 0;
                        addingPlaceable.Trapped = currentGFF.TopLevelStruct["TrapFlag"].ValueByte != 0;
                        addingPlaceable.Locked = currentGFF.TopLevelStruct["Locked"].ValueByte != 0;

                        addingPlaceable.TrapDetectDC = currentGFF.TopLevelStruct["TrapDetectDC"].ValueInt;
                        addingPlaceable.TrapDisarmDC = currentGFF.TopLevelStruct["DisarmDC"].ValueInt;                        
                        addingPlaceable.LockDC = currentGFF.TopLevelStruct["OpenLockDC"].ValueInt;

                        addingPlaceable.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModulePlaceables.Add(addingPlaceable.ResourceName, addingPlaceable);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
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
                        if (ALFA.Shared.Modules.InfoStore.ModuleWaypoints.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        GFFStructCollection variables = currentGFF.TopLevelStruct["VarTable"].ValueList.StructList;
                        if (variables.Count > 0)
                        {
                            bool nonWaypoint = false;
                            // Waypoints can be a lot of things. Let's see if we can figure anything out about this one.
                            foreach (GFFStruct var in variables)
                            {
                                if (var["Name"].Value.ToString() == "ACR_TRAP_TRIGGER_AREA")
                                {
                                    // This is a trap. We should process as one.
                                    ParseTrapWaypoint(currentGFF, currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString());
                                    nonWaypoint = true;
                                    break;
                                }
                            }
                            if (nonWaypoint)
                            {
                                continue;
                            }
                        }

                        ALFA.Shared.WaypointResource addingWaypoint = new ALFA.Shared.WaypointResource();
                        addingWaypoint.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        addingWaypoint.ResourceName = resource.FullName.Split('.')[0].ToLower();

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

                        ALFA.Shared.Modules.InfoStore.ModuleWaypoints.Add(addingWaypoint.ResourceName, addingWaypoint);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
                }
                #endregion

                #region Caching Information about Visual Effects
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResUPE))
                {
                    try
                    {
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        ALFA.Shared.VisualEffectResource addingVisual = new ALFA.Shared.VisualEffectResource();

                        addingVisual.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();
                        addingVisual.ResourceName = resource.FullName.Split('.')[0].ToLower();
                        try
                        {
                            addingVisual.Name = currentGFF.TopLevelStruct["LocName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingVisual.Name = currentGFF.TopLevelStruct["LocName"].Value.ToString();
                        }
                        if (addingVisual.Name == "")
                        {
                            addingVisual.Name = GetTlkEntry(currentGFF.TopLevelStruct["LocName"].ValueCExoLocString.StringRef);
                        }

                        addingVisual.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());
                        addingVisual.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                        addingVisual.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModuleVisualEffects.Add(addingVisual.ResourceName, addingVisual);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
                }
                #endregion

                #region Caching Information about Lights
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.ResULT))
                {
                    try
                    {
                        if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.Keys.Contains(resource.FullName.Split('.')[0].ToLower()))
                        {
                            continue;
                        }

                        GFFFile currentGFF = manager.OpenGffResource(resource.ResRef.Value, resource.ResourceType);
                        ALFA.Shared.LightResource addingLight = new ALFA.Shared.LightResource();
                        addingLight.ResourceName = resource.FullName.Split('.')[0].ToLower();
                        addingLight.TemplateResRef = currentGFF.TopLevelStruct["TemplateResRef"].Value.ToString();

                        try
                        {
                            addingLight.Name = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString().Split('"')[1];
                        }
                        catch
                        {
                            addingLight.Name = currentGFF.TopLevelStruct["LocalizedName"].Value.ToString();
                        }
                        if (addingLight.Name == "")
                        {
                            addingLight.Name = GetTlkEntry(currentGFF.TopLevelStruct["LocalizedName"].ValueCExoLocString.StringRef);
                        }

                        addingLight.Classification = ParseClassification(currentGFF.TopLevelStruct["Classification"].Value.ToString());
                        addingLight.Tag = currentGFF.TopLevelStruct["Tag"].Value.ToString();

                        addingLight.LightRange = currentGFF.TopLevelStruct["Range"].ValueFloat;
                        addingLight.LightIntensity = currentGFF.TopLevelStruct["Light"].ValueStruct["Intensity"].ValueFloat;
                        addingLight.ShadowIntensity = currentGFF.TopLevelStruct["ShadowIntensity"].ValueFloat * 100;

                        addingLight.ConfigureDisplayName();

                        ALFA.Shared.Modules.InfoStore.ModuleLights.Add(addingLight.ResourceName, addingLight);
                    }
                    catch 
                    {
                        Archivist.debug += String.Format("\n {0}", resource.FullName);
                    }
                }
                #endregion

                #region Gathering Information from 2da Files
                bool spellsLoaded = false;
                foreach (ResourceEntry resource in manager.GetResourcesByType(ALFA.ResourceManager.Res2DA))
                {
                    try
                    {
                        if (resource.FullName.ToLower() == "spells.2da" && !spellsLoaded)
                        {
                            OEIShared.IO.TwoDA.TwoDAFile twoda = manager.OpenTwoDAResource(resource.ResRef.Value, ALFA.ResourceManager.Res2DA);
                            spellsLoaded = true;
                            for (int row = 0; row < twoda.RowCount; row++)
                            {
                                ALFA.Shared.Spell spell = new ALFA.Shared.Spell();
                                int parseholder = 0;
                                uint parseuint = 0;
                                if(uint.TryParse(twoda["Name"].LiteralValue(row), out parseuint))
                                    spell.Name = GetTlkEntry(parseuint);
                                else spell.Name = twoda["Label"][row];

                                if (spell.Name == "" ||
                                    spell.Name == "padding" ||
                                    spell.Name == "PADDING_PERSONAL_VFX")
                                {
                                    // This line is padding.
                                    continue;
                                }

                                spell.Icon = twoda["IconResRef"][row];
                                spell.School = twoda["School"][row];
                                spell.Range = twoda["Range"][row];
                                spell.Components = twoda["VS"][row];
                                spell.ImpactScript = twoda["ImpactScript"][row];

                                if (int.TryParse(twoda["MetaMagic"][row], System.Globalization.NumberStyles.AllowHexSpecifier, System.Globalization.CultureInfo.InvariantCulture, out parseholder))
                                    spell.MetaMagic = parseholder;
                                else spell.MetaMagic = -1;
                                if (int.TryParse(twoda["TargetType"][row], System.Globalization.NumberStyles.AllowHexSpecifier, System.Globalization.CultureInfo.InvariantCulture, out parseholder))
                                    spell.TargetType = parseholder;
                                else spell.TargetType = -1;

                                spell.ImmunityType = twoda["ImmunityType"][row];
                                if (int.TryParse(twoda["ItemImmunity"][row], out parseholder))
                                    spell.ItemImmunity = (parseholder != 0);
                                else spell.ItemImmunity = false;

                                if(int.TryParse(twoda["Bard"][row], out parseholder))
                                    spell.BardLevel = parseholder;
                                else spell.BardLevel = -1;
                                if (int.TryParse(twoda["Cleric"][row], out parseholder))
                                    spell.ClericLevel = parseholder;
                                else spell.ClericLevel = -1;
                                if (int.TryParse(twoda["Druid"][row], out parseholder))
                                    spell.DruidLevel = parseholder;
                                else spell.DruidLevel = -1;
                                if (int.TryParse(twoda["Paladin"][row], out parseholder))
                                    spell.PaladinLevel = parseholder;
                                else spell.PaladinLevel = -1;
                                if (int.TryParse(twoda["Ranger"][row], out parseholder))
                                    spell.RangerLevel = parseholder;
                                else spell.RangerLevel = -1;
                                if (int.TryParse(twoda["Wiz_Sorc"][row], out parseholder))
                                    spell.WizardLevel = parseholder;
                                else spell.WizardLevel = -1;
                                if (int.TryParse(twoda["Warlock"][row], out parseholder))
                                    spell.WarlockLevel = parseholder;
                                else spell.WarlockLevel = -1;
                                if (int.TryParse(twoda["Innate"][row], out parseholder))
                                    spell.InnateLevel = parseholder;
                                else spell.InnateLevel = -1;

                                spell.SubSpells = new List<int>();
                                if (int.TryParse(twoda["SubRadSpell1"][row], out parseholder))
                                    spell.SubSpells.Add(parseholder);
                                if (int.TryParse(twoda["SubRadSpell2"][row], out parseholder))
                                    spell.SubSpells.Add(parseholder);
                                if (int.TryParse(twoda["SubRadSpell3"][row], out parseholder))
                                    spell.SubSpells.Add(parseholder);
                                if (int.TryParse(twoda["SubRadSpell4"][row], out parseholder))
                                    spell.SubSpells.Add(parseholder);
                                if (int.TryParse(twoda["SubRadSpell5"][row], out parseholder))
                                    spell.SubSpells.Add(parseholder);
                                if (int.TryParse(twoda["Master"][row], out parseholder))
                                    spell.MasterSpell = parseholder;
                                else spell.MasterSpell = -1;

                                spell.CounterSpells = new List<int>();
                                if (int.TryParse(twoda["Counter1"][row], out parseholder))
                                    spell.CounterSpells.Add(parseholder);
                                if (int.TryParse(twoda["Counter2"][row], out parseholder))
                                    spell.CounterSpells.Add(parseholder);

                                if (int.TryParse(twoda["REMOVED"][row], out parseholder))
                                    spell.Removed = (parseholder != 0);
                                else spell.Removed = false;

                                ALFA.Shared.Modules.InfoStore.CoreSpells.Add(row, spell);
                            }
                        }
                        
                    }
                    catch (Exception ex)
                    {
                        Archivist.debug += "\n" + ex.Message;
                    }
                }
                #endregion

                #region Commented-Out Resource Types
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
            catch (Exception ex)
            {
                debug += ex;
            }

            ACR_Candlekeep.ArchivesInstance.Resources = manager;
            ACR_Candlekeep.ArchivesInstance.SetResourcesLoaded();
        }

        private static void AddStandardTraps()
        {
            #region Acid Blob
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_acid",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 15,
                    DiceNumber = 3,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Acid Blob, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_acid",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_acid",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_acid",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 20,
                    DiceNumber = 5,
                    DiceType = 6,
                    DisarmDC = 20,
                    DisplayName = "  Acid Blob, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_acid",
                    SaveDC = 20,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_acid",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_acid",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 25,
                    DiceNumber = 12,
                    DiceType = 6,
                    DisarmDC = 25,
                    DisplayName = "  Acid Blob, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_acid",
                    SaveDC = 25,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_acid",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_acid",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 25,
                    DiceNumber = 18,
                    DiceType = 6,
                    DisarmDC = 25,
                    DisplayName = "  Acid Blob, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_acid",
                    SaveDC = 25,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_acid",
                    TriggerArea = 2,
                });
            #endregion

            #region Acid Splash
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_acidspl",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 12,
                    DiceNumber = 2,
                    DiceType = 8,
                    DisarmDC = 12,
                    DisplayName = "  Acid Splash, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_acidspl",
                    SaveDC = 12,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_acidspl",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_acidspl",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 14,
                    DiceNumber = 3,
                    DiceType = 8,
                    DisarmDC = 14,
                    DisplayName = "  Acid Splash, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_acidspl",
                    SaveDC = 14,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_acidspl",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_acidspl",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 17,
                    DiceNumber = 5,
                    DiceType = 8,
                    DisarmDC = 17,
                    DisplayName = "  Acid Splash, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_acidspl",
                    SaveDC = 17,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_acidspl",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_acidspl",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ACID,
                    Description = "This trap seems to be meant to spray some awful substance on its victim, though likely just one, based on the nozzle you've found.",
                    DetectDC = 20,
                    DiceNumber = 8,
                    DiceType = 8,
                    DisarmDC = 20,
                    DisplayName = "  Acid Splash, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_acidspl",
                    SaveDC = 20,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_acidspl",
                    TriggerArea = 2,
                });
            #endregion

            #region Electrical
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_elec",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ELECTRICAL,
                    Description = "This trap seems to be fitted with a cathode and annode, almost certainly designed to electrocute its victims. Probably many victims at once.",
                    DetectDC = 19,
                    DiceNumber = 8,
                    DiceType = 6,
                    DisarmDC = 19,
                    DisplayName = "  Electrical, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 5.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_elec",
                    SaveDC = 19,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_elec",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_elec",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ELECTRICAL,
                    Description = "This trap seems to be fitted with a cathode and annode, almost certainly designed to electrocute its victims. Probably many victims at once.",
                    DetectDC = 22,
                    DiceNumber = 15,
                    DiceType = 6,
                    DisarmDC = 22,
                    DisplayName = "  Electrical, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 5.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_elec",
                    SaveDC = 22,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_elec",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_elec",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ELECTRICAL,
                    Description = "This trap seems to be fitted with a cathode and annode, almost certainly designed to electrocute its victims. Probably many victims at once.",
                    DetectDC = 26,
                    DiceNumber = 20,
                    DiceType = 6,
                    DisarmDC = 26,
                    DisplayName = "  Electrical, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 5.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_elec",
                    SaveDC = 26,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_elec",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_elec",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_ELECTRICAL,
                    Description = "This trap seems to be fitted with a cathode and annode, almost certainly designed to electrocute its victims. Probably many victims at once.",
                    DetectDC = 28,
                    DiceNumber = 30,
                    DiceType = 6,
                    DisarmDC = 28,
                    DisplayName = "  Electrical, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 5.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_elec",
                    SaveDC = 28,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_elec",
                    TriggerArea = 2,
                });
            #endregion

            #region Fire
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_fire",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_FIRE,
                    Description = "This trap seems to be meant to spray some awful substance on its victims, which may be many based on the nozzles you can find.",
                    DetectDC = 18,
                    DiceNumber = 5,
                    DiceType = 6,
                    DisarmDC = 18,
                    DisplayName = "  Fire, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 2.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_fire",
                    SaveDC = 18,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_fire",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_fire",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_FIRE,
                    Description = "This trap seems to be meant to spray some awful substance on its victims, which may be many based on the nozzles you can find.",
                    DetectDC = 20,
                    DiceNumber = 8,
                    DiceType = 6,
                    DisarmDC = 20,
                    DisplayName = "  Fire, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 2.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_fire",
                    SaveDC = 20,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_fire",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_fire",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_FIRE,
                    Description = "This trap seems to be meant to spray some awful substance on its victims, which may be many based on the nozzles you can find.",
                    DetectDC = 23,
                    DiceNumber = 15,
                    DiceType = 6,
                    DisarmDC = 23,
                    DisplayName = "  Fire, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 4.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_fire",
                    SaveDC = 23,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_fire",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_fire",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_FIRE,
                    Description = "This trap seems to be meant to spray some awful substance on its victims, which may be many based on the nozzles you can find.",
                    DetectDC = 26,
                    DiceNumber = 25,
                    DiceType = 6,
                    DisarmDC = 26,
                    DisplayName = "  Fire, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 4.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_fire",
                    SaveDC = 26,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_fire",
                    TriggerArea = 2,
                });
            #endregion

            #region Frost
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_frost",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_COLD,
                    Description = "This trap seems to be meant to dramatically drop the temperature of its target.",
                    DetectDC = 12,
                    DiceNumber = 2,
                    DiceType = 4,
                    DisarmDC = 12,
                    DisplayName = "  Frost, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_frost",
                    SaveDC = 12,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_frost",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_frost",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_COLD,
                    Description = "This trap seems to be meant to dramatically drop the temperature of its target.",
                    DetectDC = 13,
                    DiceNumber = 3,
                    DiceType = 4,
                    DisarmDC = 13,
                    DisplayName = "  Frost, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_frost",
                    SaveDC = 13,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_frost",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_frost",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_COLD,
                    Description = "This trap seems to be meant to dramatically drop the temperature of its target.",
                    DetectDC = 14,
                    DiceNumber = 5,
                    DiceType = 4,
                    DisarmDC = 14,
                    DisplayName = "  Frost, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_frost",
                    SaveDC = 14,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_frost",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_frost",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_COLD,
                    Description = "This trap seems to be meant to dramatically drop the temperature of its target.",
                    DetectDC = 15,
                    DiceNumber = 8,
                    DiceType = 4,
                    DisarmDC = 15,
                    DisplayName = "  Frost, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_frost",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_frost",
                    TriggerArea = 2,
                });
            #endregion

            #region Negative
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_neg",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_NEGATIVE,
                    Description = "This trap seems to directly channel some kind of harmful magical energy, without casting spells",
                    DetectDC = 12,
                    DiceNumber = 2,
                    DiceType = 6,
                    DisarmDC = 12,
                    DisplayName = "  Negative, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_neg",
                    SaveDC = 12,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_neg",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_neg",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_NEGATIVE,
                    Description = "This trap seems to directly channel some kind of harmful magical energy, without casting spells",
                    DetectDC = 15,
                    DiceNumber = 3,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Negative, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_neg",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_neg",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_neg",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_NEGATIVE,
                    Description = "This trap seems to directly channel some kind of harmful magical energy, without casting spells",
                    DetectDC = 18,
                    DiceNumber = 5,
                    DiceType = 6,
                    DisarmDC = 18,
                    DisplayName = "  Negative, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_neg",
                    SaveDC = 18,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_neg",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_neg",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_NEGATIVE,
                    Description = "This trap seems to directly channel some kind of harmful magical energy, without casting spells",
                    DetectDC = 21,
                    DiceNumber = 8,
                    DiceType = 6,
                    DisarmDC = 21,
                    DisplayName = "  Negative, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_neg",
                    SaveDC = 21,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_neg",
                    TriggerArea = 2,
                });
            #endregion

            #region Sonic
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_sonic",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_SONIC,
                    Description = "This trap seems to be centered on the use of thunderstones. It is likely to be powerfully-noisy, and perhaps even damaging because of it.",
                    DetectDC = 12,
                    DiceNumber = 2,
                    DiceType = 4,
                    DisarmDC = 12,
                    DisplayName = "  Sonic, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 3.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_sonic",
                    SaveDC = 12,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_sonic",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_sonic",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_SONIC,
                    Description = "This trap seems to be centered on the use of thunderstones. It is likely to be powerfully-noisy, and perhaps even damaging because of it.",
                    DetectDC = 14,
                    DiceNumber = 3,
                    DiceType = 4,
                    DisarmDC = 14,
                    DisplayName = "  Sonic, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 3.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_sonic",
                    SaveDC = 14,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_sonic",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_sonic",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_SONIC,
                    Description = "This trap seems to be centered on the use of thunderstones. It is likely to be powerfully-noisy, and perhaps even damaging because of it.",
                    DetectDC = 17,
                    DiceNumber = 5,
                    DiceType = 4,
                    DisarmDC = 17,
                    DisplayName = "  Sonic, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 3.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_sonic",
                    SaveDC = 17,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_sonic",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_sonic",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_SONIC,
                    Description = "This trap seems to be centered on the use of thunderstones. It is likely to be powerfully-noisy, and perhaps even damaging because of it.",
                    DetectDC = 20,
                    DiceNumber = 8,
                    DiceType = 4,
                    DisarmDC = 20,
                    DisplayName = "  Sonic, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 3.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_sonic",
                    SaveDC = 20,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_sonic",
                    TriggerArea = 2,
                });
            #endregion

            #region Spike
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_minor_spike",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_PIERCING,
                    Description = "This trap seems to be designed to fire something solid at its targets, though you can't see the exact payload.",
                    DetectDC = 15,
                    DiceNumber = 2,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Spike, Minor",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_minor_spike",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_minor_spike",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_average_spike",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_PIERCING,
                    Description = "This trap seems to be designed to fire something solid at its targets, though you can't see the exact payload.",
                    DetectDC = 15,
                    DiceNumber = 3,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Spike, Average",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_average_spike",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_average_spike",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_strong_spike",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_PIERCING,
                    Description = "This trap seems to be designed to fire something solid at its targets, though you can't see the exact payload.",
                    DetectDC = 15,
                    DiceNumber = 5,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Spike, Strong",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_strong_spike",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_strong_spike",
                    TriggerArea = 2,
                });
            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add("std_deadly_spike",
                new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    Classification = "Standard",
                    DamageType = CLRScriptBase.DAMAGE_TYPE_PIERCING,
                    Description = "This trap seems to be designed to fire something solid at its targets, though you can't see the exact payload.",
                    DetectDC = 15,
                    DiceNumber = 25,
                    DiceType = 6,
                    DisarmDC = 15,
                    DisplayName = "  Spike, Deadly",
                    EffectArea = CLRScriptBase.SHAPE_SPHERE,
                    EffectSize = 1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = "std_deadly_spike",
                    SaveDC = 15,
                    SpellId = -1,
                    SpellTrap = false,
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    Tag = "std_deadly_spike",
                    TriggerArea = 2,
                });
            #endregion

            foreach (ALFA.Shared.TrapResource trap in ALFA.Shared.Modules.InfoStore.ModuleTraps.Values)
            {
                trap.CalculateCR();
            }
        }

        private static void ParseTrapWaypoint(GFFFile trapGff, string resRef)
        {
            if (ALFA.Shared.Modules.InfoStore.ModuleTraps.Keys.Contains(resRef))
            {
                // We've already got one of those. We'll crash if we try to
                // add another.
                return;
            }
            ALFA.Shared.TrapResource addingTrap = new ALFA.Shared.TrapResource()
                {
                    AttackBonus = -1,
                    ChallengeRating = -1.0f,
                    Classification = "",
                    DamageType = -1,
                    DetectDC = -1,
                    DiceNumber = -1,
                    DiceType = -1,
                    DisarmDC = -1,
                    DisplayName = "",
                    EffectArea = -1,
                    EffectSize = -1.0f,
                    MinimumToTrigger = 1,
                    NumberOfShots = 1,
                    ResRef = resRef,
                    SaveDC = -1,
                    SpellId = -1,
                    SpellTrap = false,
                    Tag = "",
                    TargetAlignment = CLRScriptBase.ALIGNMENT_ALL,
                    TargetRace = CLRScriptBase.RACIAL_TYPE_ALL,
                    TrapOrigin = CLRScriptBase.OBJECT_INVALID,
                };


            try
            {
                addingTrap.DisplayName = trapGff.TopLevelStruct["LocalizedName"].Value.ToString().Split('"')[1];
            }
            catch
            {
                addingTrap.DisplayName = trapGff.TopLevelStruct["LocalizedName"].Value.ToString();
            }
            if (addingTrap.DisplayName == "")
            {
                addingTrap.DisplayName = GetTlkEntry(trapGff.TopLevelStruct["LocalizedName"].ValueCExoLocString.StringRef);
            }

            addingTrap.Classification = ParseClassification(trapGff.TopLevelStruct["Classification"].Value.ToString());
            addingTrap.Tag = trapGff.TopLevelStruct["Tag"].Value.ToString();

            GFFStructCollection variables = trapGff.TopLevelStruct["VarTable"].ValueList.StructList;
            // Waypoints can be a lot of things. Let's see if we can figure anything out about this one.
            foreach (GFFStruct var in variables)
            {
                string varName = var["Name"].Value.ToString();
                if (varName == "ACR_TRAP_TRIGGER_AREA")
                {
                    addingTrap.TriggerArea = var["Value"].ValueInt;
                    continue;
                }
                if (varName == "ACR_TRAP_ATTACK_BONUS")
                {
                    addingTrap.AttackBonus = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DAMAGE_TYPE")
                {
                    addingTrap.DamageType = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DETECT_DC")
                {
                    addingTrap.DetectDC = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DICE_NUMBER")
                {
                    addingTrap.DiceNumber = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DICE_TYPE")
                {
                    addingTrap.DiceType = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DISARM_DC")
                {
                    addingTrap.DisarmDC = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_EFFECT_AREA")
                {
                    addingTrap.EffectArea = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_EFFECT_SIZE")
                {
                    addingTrap.EffectSize = var["Value"].ValueFloat;
                    continue;
                }
                else if (varName == "ACR_TRAP_MINIMUM_TO_TRIGGER")
                {
                    addingTrap.MinimumToTrigger = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_NUMBER_OF_SHOTS")
                {
                    addingTrap.NumberOfShots = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_SAVE_DC")
                {
                    addingTrap.SaveDC = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_SPELL_ID")
                {
                    addingTrap.SpellId = var["Value"].ValueInt;
                    if (addingTrap.SpellId >= 0)
                    {
                        addingTrap.SpellTrap = true;
                    }
                    else
                    {
                        addingTrap.SpellTrap = false;
                    }
                    continue;
                }
                else if (varName == "ACR_TRAP_TARGET_ALIGNMENT")
                {
                    addingTrap.TargetAlignment = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_TARGET_RACE")
                {
                    addingTrap.TargetRace = var["Value"].ValueInt;
                    continue;
                }
                else if (varName == "ACR_TRAP_DESCRIPTION")
                {
                    addingTrap.Description = (string)var["Value"].Value;
                    continue;
                }
            }

            addingTrap.CalculateCR();

            ALFA.Shared.Modules.InfoStore.ModuleTraps.Add(addingTrap.ResRef, addingTrap);
        }

        private static string ParseClassification(string classification)
        {
            classification = classification.Replace(':','-');
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
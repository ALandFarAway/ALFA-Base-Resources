using ALFA;
using ALFA.Shared;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using CLRScriptFramework;

namespace ACR_Quest
{
    [DataContract(Name = "Infestation")]
    public class Infestation
    {
        #region Persistent Storage
        [DataMember]
        public string InfestationName;

        [DataMember]
        public string BossTemplate;

        [DataMember]
        public List<string> MiniBoss = new List<string>();

        [DataMember]
        public int MaxTier;

        [DataMember]
        public int MaxArea;

        [DataMember]
        public Dictionary<string, int> InfestedAreaLevels = new Dictionary<string, int>();

        [DataMember]
        public Dictionary<int, List<string>> Spawns = new Dictionary<int, List<string>>();

        [DataMember]
        public int Fecundity;
        #endregion

        #region Temporary Storage
        [IgnoreDataMember]
        private int CachedGrowth;

        [IgnoreDataMember]
        public List<ActiveArea> InfestedAreas = new List<ActiveArea>();

        [IgnoreDataMember]
        public bool RecentBossSpawn = false;

        [IgnoreDataMember]
        public bool RecentMiniBossSpawn = false;
        #endregion

        #region Constructors
        public Infestation() { }

        public Infestation(string Name, string Template, int State, CLRScriptBase script) 
        {
            InfestationName = Name;
            Spawns.Add(1, new List<string>());
            Spawns[1].Add(Template);
            MaxTier = 1;
            uint startAreaObject = script.GetArea(script.OBJECT_SELF);
            string startArea = script.GetTag(startAreaObject);
            InfestArea(startArea, ALFA.Shared.Modules.InfoStore.ActiveAreas[startAreaObject], 1, script);
            QuestStore.LoadedInfestations.Add(this);
            Save();
        }
        #endregion

        #region (De)serialization
        public void Save()
        {
            if(!Directory.Exists(QuestStore.InfestationStoreDirectory))
            {
                Directory.CreateDirectory(QuestStore.InfestationStoreDirectory);
            }
            using (FileStream stream = new FileStream(QuestStore.InfestationStoreDirectory + InfestationName + ".xml", FileMode.Create))
            {
                DataContractSerializer ser = new DataContractSerializer(typeof(Infestation));
                ser.WriteObject(stream, this);
            }
        }

        public void Delete()
        {
            if (!Directory.Exists(QuestStore.InfestationStoreDirectory))
                return;
            if(File.Exists(QuestStore.InfestationStoreDirectory + InfestationName + ".xml"))
            {
                File.Delete(QuestStore.InfestationStoreDirectory + InfestationName + ".xml");
            }
        }

        public static void InitializeInfestations(CLRScriptBase s)
        {
            // If we haven't even started caching areas, no point in starting here.
            if(ALFA.Shared.Modules.InfoStore.ActiveAreas == null)
            {
                s.DelayCommand(30.0f, delegate { InitializeInfestations(s); });
                return;
            }

            // If we have areas, but haven't added any to ActiveAreas, we can't check on the areas.
            if(ALFA.Shared.Modules.InfoStore.ActiveAreas.Count == 0)
            {
                s.DelayCommand(30.0f, delegate { InitializeInfestations(s); });
                return;
            }

            // If the first area we loop over hasn't mapped its area transitions, we can't be sure
            // that we have a complete list of areas.
            if(ALFA.Shared.Modules.InfoStore.ActiveAreas.First().Value.ExitTransitions == null)
            {
                s.DelayCommand(30.0f, delegate { InitializeInfestations(s); });
                return;
            }

            // Once we know we at least have a complete list of areas, we can deserialize our infestations
            // and start infesting areas.
            foreach (string file in Directory.EnumerateFiles(QuestStore.InfestationStoreDirectory))
            {
                using (FileStream stream = new FileStream(file, FileMode.Open))
                {
                    DataContractSerializer ser = new DataContractSerializer(typeof(Infestation));
                    Infestation ret = ser.ReadObject(stream) as Infestation;
                    QuestStore.LoadedInfestations.Add(ret);
                    ret.InfestedAreas = new List<ActiveArea>();
                    Dictionary<string, ActiveArea> areasToAdjust = new Dictionary<string, ActiveArea>();
                    foreach (string inf in ret.InfestedAreaLevels.Keys)
                    {
                        ActiveArea ar = GetAreaByTag(inf);
                        if (ar != null) // Areas might be removed during a reset.
                        {
                            ret.InfestedAreas.Add(ar);
                            areasToAdjust.Add(inf, ar);
                        }
                    }
                    foreach(KeyValuePair<string, ActiveArea> area in areasToAdjust)
                    {
                        ret.InfestArea(area.Key, area.Value, ret.InfestedAreaLevels[area.Key], s);
                    }
                }
            }
        }

        public override string ToString()
        {
            string ret = String.Format("{0} lead by {1}", InfestationName, BossTemplate);
            foreach (KeyValuePair<string, int> ar in InfestedAreaLevels)
            {
                ret += String.Format("\n -- {0}, {1}", ar.Key, ar.Value);
            }
            foreach(KeyValuePair<int, List<string>> sp in Spawns)
            {
                ret += String.Format("\nTier {0}:", sp.Key);
                foreach(string creat in sp.Value)
                {
                    ret += String.Format("\n -- {0}", creat);
                }
            }
            return ret;
        }
        #endregion

        #region Spawn Management
        public void AddSpawn(int Tier, string Spawn)
        {
            if(!Spawns.ContainsKey(Tier))
            {
                Spawns.Add(Tier, new List<string>());
            }
            Spawns[Tier].Add(Spawn);
            MaxTier = Spawns.Count();
            Save();
        }

        public bool RemoveSpawn(int Tier, string Spawn)
        {
            if(!Spawns.ContainsKey(Tier))
            {
                return false;
            }
            if(!Spawns[Tier].Contains(Spawn))
            {
                return false;
            }
            if(Spawns.ContainsKey(Tier + 1) &&
               Spawns[Tier + 1].Count > 0 &&
               Spawns[Tier].Count <= 1)
            {
                return false;
            }
            Spawns[Tier].Remove(Spawn);
            if (Spawns[Tier].Count() == 0) Spawns.Remove(Tier);
            MaxTier = Spawns.Count();
            Save();
            return true;
        }

        public void AddBoss(string Spawn)
        {
            if(String.IsNullOrEmpty(BossTemplate))
            {
                BossTemplate = Spawn;
                Fecundity = 1;
                Save();
                return;
            }
            float newBossCR = ALFA.Shared.Modules.InfoStore.ModuleCreatures[Spawn].ChallengeRating;
            float oldBossCR = ALFA.Shared.Modules.InfoStore.ModuleCreatures[BossTemplate].ChallengeRating;
            if(newBossCR > oldBossCR)
            {
                MiniBoss.Add(BossTemplate);
                BossTemplate = Spawn;
            }
            else
            {
                MiniBoss.Add(Spawn);
            }
            Fecundity = MiniBoss.Count + 1;
            Save();
        }

        public void RemoveBoss(string Spawn)
        {
            if(Spawn == BossTemplate)
            {
                if(MiniBoss.Count == 0)
                {
                    Fecundity = 0;
                    BossTemplate = String.Empty;
                }
                else
                {
                    if (Fecundity < 0) Fecundity = 0;
                    BossTemplate = MiniBoss[0];
                    MiniBoss.Remove(MiniBoss[0]);
                    Fecundity = MiniBoss.Count + 1;
                }
            }
            else
            {
                if(MiniBoss.Contains(Spawn))
                {
                    MiniBoss.Remove(Spawn);
                    Fecundity = MiniBoss.Count + 1;
                }
            }
            Save();
        }

        public void SpawnOneAtTier(CLRScriptBase s)
        {
            string Area = s.GetTag(s.GetArea(s.OBJECT_SELF));
            int Tier = InfestedAreaLevels[Area];
            if(Tier == MaxArea)
            {
                if(!RecentBossSpawn)
                {
                    if (s.d20(1) == 1)
                    {
                        RecentBossSpawn = true;
                        s.DelayCommand(s.HoursToSeconds(12), delegate { RecentBossSpawn = false; });
                        if (BossTemplate != String.Empty)
                        {
                            uint spawn = Spawn.SpawnCreature(BossTemplate, s);
                            s.SetLocalString(spawn, InfestNameVar, this.InfestationName);
                            s.SetLocalInt(spawn, InfestBossVar, 1);
                        }
                    }
                }
                else if(!RecentMiniBossSpawn)
                {
                    if (s.d10(1) == 1)
                    {
                        RecentMiniBossSpawn = true;
                        s.DelayCommand(s.HoursToSeconds(4), delegate { RecentMiniBossSpawn = false; });
                        if (MiniBoss.Count > 0)
                        {
                            int spawnNumber = new Random().Next(0, MiniBoss.Count);
                            uint spawn = Spawn.SpawnCreature(MiniBoss[spawnNumber], s);
                            s.SetLocalString(spawn, InfestNameVar, this.InfestationName);
                            s.SetLocalInt(spawn, InfestBossVar, 1);
                        }
                    }
                }
            }
            int spawnNum = 1;
            int spawnTier = Tier;
            if(Tier == 2)
            {
                if(s.d2(1) == 1)
                {
                    spawnNum = s.d3(1);
                    spawnTier = 1;
                }
            }
            else if(Tier > 2)
            {
                switch(s.d3(1))
                {
                    case 1:
                        spawnNum = s.d3(1);
                        spawnTier--;
                        break;
                    case 2:
                        spawnNum = s.d4(1) + 1;
                        spawnTier -= 2;
                        break;
                }
            }
            while (spawnNum > 0)
            {
                string rand = GetRandomSpawnAtTier(spawnTier);
                if (rand != "")
                {
                    uint spawn = Spawn.SpawnCreature(rand, s);
                    s.SetLocalString(spawn, InfestNameVar, this.InfestationName);
                }
                spawnNum -= 1;
            }
        }

        private string GetRandomSpawnAtTier(int Tier)
        {
            if (Spawns.ContainsKey(Tier))
            {
                int spawnNumber = new Random().Next(0, Spawns[Tier].Count);
                return Spawns[Tier][spawnNumber];
            }
            return "";
        }
        #endregion

        #region Methods to run at Infestation Growth
        public void GrowInfestation(CLRScriptBase script)
        {
            CachedGrowth += Fecundity;
            CleanUpZeroes();
            while (SmoothEdges(script)) { }
            while (CachedGrowth < 0 && RecoverFromTops(script)) { }
            while (CachedGrowth > 0 && (GrowCurrent(script) || ExpandRemaining(script))) { }
            MaxArea = 0;
            foreach(int val in InfestedAreaLevels.Values)
            {
                if (val > MaxArea) MaxArea = val;
            }
            Save();
        }

        private bool SmoothEdges(CLRScriptBase s)
        {
            bool changeMade = false;
            foreach(ActiveArea area in InfestedAreas)
            {
                int areaLevel = InfestedAreaLevels[area.Tag];
                foreach(ActiveArea adj in area.ExitTransitions.Values)
                {
                    if(InfestedAreas.Contains(adj))
                    {
                        int diff = areaLevel - InfestedAreaLevels[adj.Tag];
                        if(diff > 1)
                        {
                            ChangeAreaLevel(adj.Tag, adj, InfestedAreaLevels[adj.Tag] + diff - 1, s);
                            CachedGrowth -= (diff - 1);
                            changeMade = true;
                        }
                        else if(diff < -1)
                        {
                            ChangeAreaLevel(adj.Tag, adj, InfestedAreaLevels[adj.Tag] - diff + 1, s);
                            CachedGrowth += (diff + 1);
                            changeMade = true;
                        }
                    }
                    else if (areaLevel > 1 && adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] >= 0)
                    {
                        if(areaLevel - 1 > adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] &&
                            adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] != 0)
                        {
                            areaLevel = adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] + 1;
                        }
                        InfestArea(adj.Tag, adj, areaLevel - 1, s);
                        CachedGrowth -= (areaLevel - 1);
                        changeMade = true;
                    }
                }
            }
            return changeMade;
        }

        private bool RecoverFromTops(CLRScriptBase s)
        {
            bool changeMade = false;
            int highestDensity = 1;
            foreach(int dens in InfestedAreaLevels.Values)
            {
                if (dens > highestDensity)
                    highestDensity = dens;
            }
            Dictionary<string, int> toChange = new Dictionary<string, int>();
            foreach(KeyValuePair<string, int> inf in InfestedAreaLevels)
            {
                if(inf.Value == highestDensity)
                {
                    toChange.Add(inf.Key, inf.Value - 1);
                    CachedGrowth += 1;
                    changeMade = true;
                }
            }
            foreach(KeyValuePair<string, int> inf in toChange)
            {
                ChangeAreaLevel(inf.Key, null, inf.Value - 1, s);
            }
            return changeMade;
        }

        private bool GrowCurrent(CLRScriptBase s)
        {
            bool changeMade = false;
            foreach(ActiveArea area in InfestedAreas)
            {
                bool growthBlocked = false;
                int currentLevel = InfestedAreaLevels[area.Tag];
                if (area.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] != 0 &&
                    area.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] <= currentLevel)
                {
                    // We need no handling for -1, as it will always be less than an infested area tag; therefore,
                    // if an area becomes uninfestable after being infested for whatever reason, it will always 
                    // refuse to grow.
                    growthBlocked = true;
                }
                else if(currentLevel >= MaxTier)
                {
                    InfestedAreaLevels[area.Tag] = MaxTier;
                    growthBlocked = true;
                }
                else
                {
                    foreach (ActiveArea adj in area.ExitTransitions.Values)
                    {
                        if (!InfestedAreas.Contains(adj))
                        {
                            growthBlocked = true;
                            break;
                        }
                        if (InfestedAreaLevels[adj.Tag] < currentLevel)
                        {
                            growthBlocked = true;
                            break;
                        }
                    }
                }
                if(!growthBlocked)
                {
                    InfestedAreaLevels[area.Tag] += 1;
                    CachedGrowth -= 1;
                    changeMade = true;
                }
                if(CachedGrowth <= 0)
                {
                    break;
                }
            }
            return changeMade;
        }

        private bool ExpandRemaining(CLRScriptBase s)
        {
            bool changeMade = false;
            List<ActiveArea> areaToInfest = new List<ActiveArea>();
            foreach (ActiveArea area in InfestedAreas)
            {
                int currentLevel = InfestedAreaLevels[area.Tag];
                foreach (ActiveArea adj in area.ExitTransitions.Values)
                {
                    if (!InfestedAreas.Contains(adj))
                    {
                        if (adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] >= 0)
                        {
                            areaToInfest.Add(adj);
                            CachedGrowth -= 1;
                            changeMade = true;
                        }
                    }
                    if (CachedGrowth <= 0)
                        break;
                }
                if (CachedGrowth <= 0)
                    break;
            }
            foreach (ActiveArea adj in areaToInfest)
            {
                InfestArea(adj.Tag, adj, 1, s);
            }
            return changeMade;
        }

        private void CleanUpZeroes()
        {
            List<string> areasToRemove = new List<string>();
            foreach(KeyValuePair<string, int> inf in InfestedAreaLevels)
            {
                if (inf.Value <= 0)
                    areasToRemove.Add(inf.Key);
            }
            foreach(string rem in areasToRemove)
            {
                InfestedAreaLevels.Remove(rem);
                InfestedAreas.Remove(GetAreaByTag(rem));
            }
        }


        public const string WayPointArrayName = "ACR_SPA_WA_";
        public const string GroupVarName = "ACR_SPAWN_GROUP_";
        public const string SingleVarName = "ACR_SPAWN_RESNAME_";
        public const string RandomVarName = "ACR_SPAWN_RANDOM_RESNAME_";
        public const string SpawnTypeVarName = "ACR_SPAWN_TYPE";
        public const string InfestPrefix = "INF_";
        public const string InfestGroupScript = "infest";
        public const string InfestNameVar = "AREA_INFESTATION_NAME";
        public const string InfestBossVar = "INFESTATION_BOSS";
        private void InfestArea(string areaTag, ActiveArea area, int initialLevel, CLRScriptBase s)
        {
            if(area == null)
            {
                area = GetAreaByTag(areaTag);
            }
            if(!InfestedAreas.Contains(area))
            {
                InfestedAreas.Add(area);
            }
            if(!InfestedAreaLevels.ContainsKey(areaTag))
            {
                InfestedAreaLevels.Add(areaTag, initialLevel);
            }
            else
            {
                InfestedAreaLevels[areaTag] = initialLevel;
            }
            s.SetLocalString(area.Id, InfestNameVar, this.InfestationName);
            int count = 0;
            uint wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            while(s.GetIsObjectValid(wp) != CLRScriptBase.FALSE)
            {
                int groupNum = 1;
                string oldGroup = s.GetLocalString(wp, GroupVarName + groupNum.ToString());
                while(oldGroup != "")
                {
                    s.SetLocalString(wp, InfestPrefix + GroupVarName + groupNum.ToString(), oldGroup);
                    s.SetLocalString(wp, GroupVarName + groupNum.ToString(), InfestGroupScript);
                    groupNum++;
                    oldGroup = s.GetLocalString(wp, GroupVarName + groupNum.ToString());
                }
                if (s.GetLocalInt(wp, "ACR_SPAWN_TYPE") != CLRScriptBase.OBJECT_TYPE_CREATURE)
                {
                    count++;
                    wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
                    continue;
                }
                int var = 1;
                string oldVar = s.GetLocalString(wp, SingleVarName + var.ToString());
                while(oldVar != "")
                {
                    s.SetLocalString(wp, InfestPrefix + SingleVarName + var.ToString(), oldVar);
                    s.SetLocalString(wp, SingleVarName + var.ToString(), GetRandomSpawnAtTier(initialLevel));
                    var++;
                    oldVar = s.GetLocalString(wp, SingleVarName + var.ToString());
                }
                var = 1;
                oldVar = s.GetLocalString(wp, RandomVarName + var.ToString());
                while(oldVar != "")
                {
                    s.SetLocalString(wp, InfestPrefix + RandomVarName + var.ToString(), oldVar);
                    s.SetLocalString(wp, RandomVarName + var.ToString(), GetRandomSpawnAtTier(initialLevel));
                    var++;
                    oldVar = s.GetLocalString(wp, RandomVarName + var.ToString());
                }
                count++;
                wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            }
        }

        public void ChangeAreaLevel(string areaTag, ActiveArea area, int infestLevel, CLRScriptBase s)
        {
            if (area == null)
            {
                area = GetAreaByTag(areaTag);
            }
            if(!InfestedAreas.Contains(area))
            {
                InfestArea(areaTag, area, infestLevel, s);
                return;
            }
            InfestedAreaLevels[areaTag] -= 1;
            s.DeleteLocalString(area.Id, InfestNameVar);
            int count = 0;
            uint wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            while (s.GetIsObjectValid(wp) != CLRScriptBase.FALSE)
            {
                if (s.GetLocalInt(wp, "ACR_SPAWN_TYPE") != 0)
                {
                    count++;
                    wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
                    continue;
                }
                int var = 1;
                string oldVar = s.GetLocalString(wp, SingleVarName + var.ToString());
                while (oldVar != "")
                {
                    s.SetLocalString(wp, SingleVarName + var.ToString(), GetRandomSpawnAtTier(infestLevel));
                    var++;
                    oldVar = s.GetLocalString(wp, SingleVarName + var.ToString());
                }
                var = 1;
                oldVar = s.GetLocalString(wp, RandomVarName + var.ToString());
                while (oldVar != "")
                {
                    s.SetLocalString(wp, RandomVarName + var.ToString(), GetRandomSpawnAtTier(infestLevel));
                    var++;
                    oldVar = s.GetLocalString(wp, RandomVarName + var.ToString());
                }
                count++;
                wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            }
        }

        public void ClearArea(string areaTag, ActiveArea area, CLRScriptBase s)
        {
            if (area == null)
            {
                area = GetAreaByTag(areaTag);
            }
            if (InfestedAreas.Contains(area))
            {
                InfestedAreas.Remove(area);
            }
            if (InfestedAreaLevels.ContainsKey(areaTag))
            {
                InfestedAreaLevels.Remove(areaTag);
            }
            if(InfestedAreas.Count < 1)
            {
                QuestStore.LoadedInfestations.Remove(this);
                this.Delete();
            }
            int count = 0;
            uint wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            while (s.GetIsObjectValid(wp) != CLRScriptBase.FALSE)
            {
                int groupNum = 1;
                string oldGroup = s.GetLocalString(wp, InfestPrefix + GroupVarName + groupNum.ToString());
                while (oldGroup != "")
                {
                    s.SetLocalString(wp, GroupVarName + groupNum.ToString(), oldGroup);
                    groupNum++;
                    oldGroup = s.GetLocalString(wp, InfestPrefix + GroupVarName + groupNum.ToString());
                }
                if (s.GetLocalInt(wp, "ACR_SPAWN_TYPE") != 0)
                {
                    count++;
                    wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
                    continue;
                }
                int var = 1;
                string oldVar = s.GetLocalString(wp, InfestPrefix + SingleVarName + var.ToString());
                while (oldVar != "")
                {
                    s.SetLocalString(wp, SingleVarName + var.ToString(), oldVar);
                    var++;
                    oldVar = s.GetLocalString(wp, InfestPrefix + SingleVarName + var.ToString());
                }
                var = 1;
                oldVar = s.GetLocalString(wp, InfestPrefix + RandomVarName + var.ToString());
                while (oldVar != "")
                {
                    s.SetLocalString(wp, RandomVarName + var.ToString(), oldVar);
                    var++;
                    oldVar = s.GetLocalString(wp, InfestPrefix + RandomVarName + var.ToString());
                }
                count++;
                wp = s.GetLocalObject(area.Id, WayPointArrayName + count.ToString());
            }
        }
        #endregion

        #region GUI Methods
        public void PopulateGUI(uint player, CLRScriptBase s)
        {
            s.ClearListBox(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_BOSSES");
            s.SetGUIObjectText(player, "SCREEN_INFESTATION", "DISP_INFEST", -1, String.Format("Infestation: {0} areas, {1} spread, {2} peak.", InfestedAreaLevels.Count(), Fecundity, MaxTier));
            if(!String.IsNullOrEmpty(BossTemplate))
            {
                if(ALFA.Shared.Modules.InfoStore.ModuleCreatures.ContainsKey(BossTemplate))
                {
                    s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_BOSSES", BossTemplate, String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1:0.0};LISTBOX_ITEM_TEXT3= {2}", ALFA.Shared.Modules.InfoStore.ModuleCreatures[BossTemplate].DisplayName, ALFA.Shared.Modules.InfoStore.ModuleCreatures[BossTemplate].ChallengeRating.ToString(), "Boss"), "", "5=" + BossTemplate, "");
                }
                else
                {
                    s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_BOSSES", BossTemplate, String.Format("LISTBOX_ITEM_TEXT=  Error: {0} is invalid", BossTemplate), "", "5=" + BossTemplate, "");
                }
            }
            if (MiniBoss != null)
            {
                foreach (string mini in MiniBoss)
                {
                    if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.ContainsKey(mini))
                    {
                        s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_BOSSES", mini, String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1:0.0};LISTBOX_ITEM_TEXT3= {2}", ALFA.Shared.Modules.InfoStore.ModuleCreatures[mini].DisplayName, ALFA.Shared.Modules.InfoStore.ModuleCreatures[mini].ChallengeRating.ToString(), "Mini"), "", "5=" + mini, "");
                    }
                    else
                    {
                        s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_BOSSES", mini, String.Format("LISTBOX_ITEM_TEXT=  Error: {0} is invalid", mini), "", "5=" + mini, "");
                    }
                }
            }
            s.ClearListBox(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_TIERS");
            foreach(KeyValuePair<int, List<string>> tier in Spawns)
            {
                foreach(string creat in tier.Value)
                {
                    if (ALFA.Shared.Modules.InfoStore.ModuleCreatures.ContainsKey(creat))
                    {
                        s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_TIERS", creat, String.Format("LISTBOX_ITEM_TEXT=  {0};LISTBOX_ITEM_TEXT2= {1:0.0};LISTBOX_ITEM_TEXT3= {2}", ALFA.Shared.Modules.InfoStore.ModuleCreatures[creat].DisplayName, ALFA.Shared.Modules.InfoStore.ModuleCreatures[creat].ChallengeRating.ToString(), tier.Key.ToString()), "", String.Format("5={0};6={1}", creat, tier.Key.ToString()), "");
                    }
                    else
                    {
                        s.AddListBoxRow(player, "SCREEN_INFESTATION", "LISTBOX_ACR_INF_TIERS", creat, String.Format("LISTBOX_ITEM_TEXT=  Error: {0} is invalid", creat), "", "5=" + creat, "");
                    }
                }
            }
        }
        #endregion

        #region Utility Methods
        public static ActiveArea GetAreaByTag(string Tag)
        {
            foreach(ActiveArea ar in Modules.InfoStore.ActiveAreas.Values)
            {
                if (ar.Tag == Tag)
                    return ar;
            }
            return null;
        }
        #endregion
    }

    public static class QuestStore
    {
        public static Infestation GetInfestation(string Name)
        {
            foreach(Infestation inf in LoadedInfestations)
            {
                if (inf.InfestationName == Name)
                    return inf;
            }
            return null;
        }

        public static void GrowAllInfestations(CLRScriptBase s)
        {
            InfestationGrowthCounterStarted = true;
            float delay = 0.0f;
            foreach(Infestation inf in LoadedInfestations)
            {
                s.DelayCommand(delay, delegate { inf.GrowInfestation(s); });
                delay += 6.0f;
            }
            s.DelayCommand(s.HoursToSeconds(24), delegate { GrowAllInfestations(s); });
        }

        public static bool InfestationGrowthCounterStarted = false;
        public static List<Infestation> LoadedInfestations = new List<Infestation>();

        public static string InfestationStoreDirectory = String.Format("{0}{1}QuestResources{1}", SystemInfo.GetHomeDirectory(), Path.DirectorySeparatorChar);
    }
}

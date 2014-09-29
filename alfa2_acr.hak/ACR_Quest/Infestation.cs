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
        public int MaxTier;

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
            InfestedAreaLevels.Add(startArea, 1);
            InfestedAreas.Add(Modules.InfoStore.ActiveAreas[startAreaObject]);
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

        public static void InitializeInfestations()
        {
            foreach (string file in Directory.EnumerateFiles(QuestStore.InfestationStoreDirectory))
            {
                using (FileStream stream = new FileStream(file, FileMode.Open))
                {
                    DataContractSerializer ser = new DataContractSerializer(typeof(Infestation));
                    Infestation ret = ser.ReadObject(stream) as Infestation;
                    QuestStore.LoadedInfestations.Add(ret);
                    ret.InfestedAreas = new List<ActiveArea>();
                    foreach (string inf in ret.InfestedAreaLevels.Keys)
                    {
                        ActiveArea ar = GetAreaByTag(inf);
                        if (ar != null) // Areas might be removed during a reset.
                            ret.InfestedAreas.Add(ar);
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
            if(Spawns.ContainsKey(MaxTier + 1))
            {
                MaxTier = MaxTier + 1;
            }
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
            Spawns[Tier].Remove(Spawn);
            Save();
            return true;
        }

        public void SpawnOneAtTier(CLRScriptBase s)
        {
            string Area = s.GetTag(s.GetArea(s.OBJECT_SELF));
            int Tier = InfestedAreaLevels[Area];
            string rand = GetRandomSpawnAtTier(Tier);
            if(rand != "")
            {
                Spawn.SpawnCreature(rand, s);
            }
        }

        private string GetRandomSpawnAtTier(int Tier)
        {
            if (Spawns.ContainsKey(Tier))
            {
                int spawnNumber = new Random().Next() * Spawns[Tier].Count;
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
            foreach(KeyValuePair<string, int> inf in InfestedAreaLevels)
            {
                if(inf.Value == highestDensity)
                {
                    ChangeAreaLevel(inf.Key, null, inf.Value - 1, s);
                    CachedGrowth += 1;
                    changeMade = true;
                }
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
                else if(currentLevel <= MaxTier)
                {
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
            foreach (ActiveArea area in InfestedAreas)
            {
                int currentLevel = InfestedAreaLevels[area.Tag];
                foreach (ActiveArea adj in area.ExitTransitions.Values)
                {
                    if (!InfestedAreas.Contains(adj))
                    {
                        if (adj.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] >= 0)
                        {
                            InfestArea(adj.Tag, adj, 1, s);
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


        const string WayPointArrayName = "ACR_SPA_WA_";
        const string GroupVarName = "ACR_SPAWN_GROUP_";
        const string SingleVarName = "ACR_SPAWN_RESNAME_";
        const string RandomVarName = "ACR_SPAWN_RANDOM_RESNAME_";
        const string SpawnTypeVarName = "ACR_SPAWN_TYPE";
        const string InfestPrefix = "INF_";
        const string InfestGroupScript = "infest";
        const string InfestNameVar = "AREA_INFESTATION_NAME";
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
                if (s.GetLocalInt(wp, "ACR_SPAWN_TYPE") != 0)
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

        private void ChangeAreaLevel(string areaTag, ActiveArea area, int infestLevel, CLRScriptBase s)
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

        private void ClearArea(string areaTag, ActiveArea area, CLRScriptBase s)
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
        public static List<Infestation> LoadedInfestations = new List<Infestation>();

        public static string InfestationStoreDirectory = String.Format("{0}{1}QuestResources{1}", SystemInfo.GetHomeDirectory(), Path.DirectorySeparatorChar);
    }
}

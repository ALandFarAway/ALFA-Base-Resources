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
            BossTemplate = Template;
            MaxTier = State;
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

        public void SpawnOneAtTier(int Tier, CLRScriptBase s)
        {
            if(Spawns.ContainsKey(Tier))
            {
                int spawnNumber = new Random().Next() * Spawns[Tier].Count;
                Spawn.SpawnCreature(Spawns[Tier][spawnNumber], s);
            }
        }
        #endregion

        #region Methods to run at Infestation Growth
        public void GrowInfestation(CLRScriptBase script)
        {
            CachedGrowth += Fecundity;
            CleanUpZeroes();
            while (SmoothEdges()) { }
            while (CachedGrowth < 0 && RecoverFromTops()) { }
            while (CachedGrowth > 0 && (GrowCurrent() || ExpandRemaining())) { }
            Save();
        }

        private bool SmoothEdges()
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
                            InfestedAreaLevels[adj.Tag] += (diff - 1);
                            CachedGrowth -= (diff - 1);
                            changeMade = true;
                        }
                        else if(diff < -1)
                        {
                            InfestedAreaLevels[area.Tag] -= (diff + 1);
                            CachedGrowth += (diff + 1);
                            changeMade = true;
                        }
                    }
                    else if (areaLevel > 1)
                    {
                        InfestedAreas.Add(adj);
                        InfestedAreaLevels.Add(adj.Tag, areaLevel - 1);
                        CachedGrowth -= (areaLevel - 1);
                        changeMade = true;
                    }
                }
            }
            return changeMade;
        }

        private bool RecoverFromTops()
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
                    InfestedAreaLevels[inf.Key] -= 1;
                    CachedGrowth += 1;
                    changeMade = true;
                }
            }
            return changeMade;
        }

        private bool GrowCurrent()
        {
            bool changeMade = false;
            foreach(ActiveArea area in InfestedAreas)
            {
                bool growthBlocked = false;
                int currentLevel = InfestedAreaLevels[area.Tag];
                if (area.GlobalQuests[ACR_Quest.GLOBAL_QUEST_INFESTATION_KEY] <= InfestedAreaLevels[area.Tag])
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

        private bool ExpandRemaining()
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
                            InfestedAreas.Add(adj);
                            InfestedAreaLevels.Add(adj.Tag, 1);
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

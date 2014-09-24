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
        [DataMember]
        public string InfestationName;

        [DataMember]
        public string BossTemplate;

        [DataMember]
        public int MaxTier;

        [DataMember]
        public Dictionary<string, int> InfestedAreaLevels = new Dictionary<string, int>();

        [DataMember]
        public int Fecundity;

        [IgnoreDataMember]
        private int CachedGrowth;

        [IgnoreDataMember]
        public List<ActiveArea> InfestedAreas = new List<ActiveArea>();
        
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

        public void GrowInfestation(CLRScriptBase script)
        {
            CachedGrowth += Fecundity;
            CleanUpZeroes();
            while (SmoothEdges()) { }
            while (CachedGrowth < 0)
            {
                RecoverFromTops();
            }
            while(CachedGrowth > 0)
            {
                GrowCurrent();
                ExpandRemaining();
            }
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

        private void RecoverFromTops()
        {
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
                }
            }
        }

        private void GrowCurrent()
        {
            foreach(ActiveArea area in InfestedAreas)
            {
                bool growthBlocked = false;
                int currentLevel = InfestedAreaLevels[area.Tag];
                foreach(ActiveArea adj in area.ExitTransitions.Values)
                {
                    if (!InfestedAreas.Contains(adj))
                    {
                        growthBlocked = true;
                        break;
                    }
                    if(InfestedAreaLevels[adj.Tag] < currentLevel)
                    {
                        growthBlocked = true;
                        break;
                    }
                }
                if(!growthBlocked)
                {
                    InfestedAreaLevels[area.Tag] += 1;
                    CachedGrowth -= 1;
                }
                if(CachedGrowth <= 0)
                {
                    break;
                }
            }
        }

        private void ExpandRemaining()
        {
            foreach (ActiveArea area in InfestedAreas)
            {
                int currentLevel = InfestedAreaLevels[area.Tag];
                foreach (ActiveArea adj in area.ExitTransitions.Values)
                {
                    if (!InfestedAreas.Contains(adj))
                    {
                        InfestedAreas.Add(adj);
                        InfestedAreaLevels.Add(adj.Tag, 1);
                        CachedGrowth -= 1;
                    }
                    if (CachedGrowth <= 0)
                        break;
                }
                if (CachedGrowth <= 0)
                    break;
            }
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

        public override string ToString()
        {
            string ret = String.Format("{0} lead by {1}", InfestationName, BossTemplate);
            foreach(KeyValuePair<string, int> ar in InfestedAreaLevels)
            {
                ret += String.Format("\n -- {0}, {1}", ar.Key, ar.Value);
            }
            return ret;
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

        public static ActiveArea GetAreaByTag(string Tag)
        {
            foreach(ActiveArea ar in Modules.InfoStore.ActiveAreas.Values)
            {
                if (ar.Tag == Tag)
                    return ar;
            }
            return null;
        }
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

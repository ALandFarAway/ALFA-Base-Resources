using ALFA;
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
        public List<InfestedArea> InfestedAreas = new List<InfestedArea>();
        
        public Infestation() { }

        public Infestation(string Name, string Template, int State, CLRScriptBase script) 
        {
            InfestationName = Name;
            BossTemplate = Template;
            MaxTier = State;
            string startArea = script.GetTag(script.GetArea(script.OBJECT_SELF));
            InfestedAreas.Add(new InfestedArea(startArea, 1));
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

        public override string ToString()
        {
            return String.Format("{0} lead by {1} in {2}", InfestationName, BossTemplate, InfestedAreas[0].Area);
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
                }
            }
        }
    }

    [DataContract(Name = "InfestatedArea")]
    public class InfestedArea
    {
        [DataMember]
        public string Area;

        [DataMember]
        public int InfestationTier;

        public InfestedArea(string area, int infestationTier)
        {
            Area = area;
            infestationTier = InfestationTier;
        }
    }
    public static class QuestStore
    {
        public static List<Infestation> LoadedInfestations = new List<Infestation>();

        public static string InfestationStoreDirectory = String.Format("{0}{1}QuestResources{1}", SystemInfo.GetHomeDirectory(), Path.DirectorySeparatorChar);
    }
}

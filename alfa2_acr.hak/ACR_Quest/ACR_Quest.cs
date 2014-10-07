using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Threading;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Quest
{
    public partial class ACR_Quest : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Quest([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Quest([In] ACR_Quest Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int), typeof(string), typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int command = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)
            string name = (string)ScriptParameters[1];
            int state = (int)ScriptParameters[2];
            string template = (string)ScriptParameters[3];
            Infestation infest = null;

            switch((Command)command)
            {
                case Command.InitializeInfestations:
                    if (!QuestStore.InfestationGrowthCounterStarted)
                    {
                        Infestation.InitializeInfestations(this);
                        DelayCommand(HoursToSeconds(24), delegate { QuestStore.GrowAllInfestations(this); });
                    }
                    break;
                case Command.CreateInfestation:
                    new Infestation(name, template, state, this);
                    break;
                case Command.GrowInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if(infest != null)
                    {
                        infest.GrowInfestation(this);
                    }
                    else { SendMessageToAllDMs(NoInfest); }
                    break;
                case Command.AddSpawnToInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if(infest != null)
                    {
                        infest.AddSpawn(state, template);
                    }
                    else { SendMessageToAllDMs(NoInfest); }
                    break;
                case Command.RemoveSpawnFromInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if(infest != null)
                    {
                        if(!infest.RemoveSpawn(state, template))
                        {
                            SendMessageToAllDMs(NoSpawn);
                        }
                    }
                    else { SendMessageToAllDMs(NoInfest); }
                    break;
                case Command.SetInfestationFecundity:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        infest.Fecundity = state;
                        infest.Save();
                    }
                    else { SendMessageToAllDMs(NoInfest); }
                    break;
                case Command.SpawnCreatureFromInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if(infest != null)
                    {
                        infest.SpawnOneAtTier(this);
                    }
                    break;
                case Command.DegradeAreaInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        uint degradedInfestationArea = GetArea(OBJECT_SELF);
                        string degradedInfestationTag = GetTag(degradedInfestationArea);

                        if (infest.InfestedAreaLevels.ContainsKey(degradedInfestationTag))
                        {
                            if (infest.InfestedAreaLevels[degradedInfestationTag] <= 1)
                            {
                                infest.ClearArea(degradedInfestationTag, ALFA.Shared.Modules.InfoStore.ActiveAreas[degradedInfestationArea], this);
                            }
                            else
                            {
                                infest.ChangeAreaLevel(degradedInfestationTag, ALFA.Shared.Modules.InfoStore.ActiveAreas[degradedInfestationArea], infest.InfestedAreaLevels[degradedInfestationTag] - 1, this);
                                infest.Save();
                            }
                        }
                    }
                    break;
                case Command.PrintInfestations:
                    foreach(Infestation inf in QuestStore.LoadedInfestations)
                    {
                        SendMessageToAllDMs(inf.ToString());
                    }
                    break;
            }
            SendMessageToAllDMs(String.Format("Command: {0}, Name: {1}, State: {2}, Template: {3}.", command, name, state, template));
            return 0;
        }

        enum Command 
        {
            InitializeInfestations = 0,
            CreateInfestation = 1,
            GrowInfestation = 2,
            AddSpawnToInfestation = 3,
            SetInfestationFecundity = 4,
            RemoveSpawnFromInfestation = 5,
            SpawnCreatureFromInfestation = 6,
            DegradeAreaInfestation = 7,

            PrintInfestations = 999,
        }

        public const string NoSpawn = "Error: That spawn does not seem to be at that tier.";
        public const string NoInfest = "Error: There does not seem to be an infestation by that name.";

        public const string AREA_MAX_INFESTATION = "ACR_QST_MAX_INFESTATION";
        public const string GLOBAL_QUEST_INFESTATION_KEY = "Infestation";
    }
}

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
                                infest.Save();
                            }
                            else
                            {
                                infest.ChangeAreaLevel(degradedInfestationTag, ALFA.Shared.Modules.InfoStore.ActiveAreas[degradedInfestationArea], infest.InfestedAreaLevels[degradedInfestationTag] - 1, this);
                                infest.Save();
                            }
                        }
                    }
                    break;
                case Command.AddBossMonsterToInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        infest.AddBoss(template);
                    }
                    break;
                case Command.RemoveBossMonsterFromInfestation:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        infest.RemoveBoss(template);
                    }
                    break;
                case Command.PopulateInfestationGUIScreen:
                    string infestName = GetLocalString(GetArea(OBJECT_SELF), Infestation.InfestNameVar);
                    infest = QuestStore.GetInfestation(infestName);
                    if(infest != null)
                    {
                        infest.PopulateGUI(OBJECT_SELF, this);
                    }
                    break;
                case Command.UpgradeInfestationCreatureTier:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        if(!infest.Spawns.ContainsKey(state))
                        {
                            SendMessageToAllDMs("No spawns found at that tier.");
                        }
                        else if(infest.Spawns[state].Count <= 1)
                        {
                            SendMessageToAllDMs("Cannot upgrade tier for " + template + " as there are too few creatures at that tier.");
                        }
                        else if(!infest.Spawns[state].Contains(template))
                        {
                            SendMessageToAllDMs(template + " does not exist at that tier.");
                        }
                        else
                        {
                            infest.AddSpawn(state + 1, template);
                            infest.RemoveSpawn(state, template);
                        }
                    }
                    break;
                case Command.DowngradeInfestationCreatureTier:
                    infest = QuestStore.GetInfestation(name);
                    if (infest != null)
                    {
                        if(state <= 1)
                        {
                            SendMessageToAllDMs("Creature is already at the minimum tier.");
                        }
                        else if(!infest.Spawns.ContainsKey(state))
                        {
                            SendMessageToAllDMs("No spawns found at that tier.");
                        }
                        else if(infest.Spawns[state].Count <= 1 &&
                                infest.Spawns.ContainsKey(state + 1) &&
                                infest.Spawns[state + 1].Count > 0)
                        {
                            SendMessageToAllDMs("Cannot downgrade tier for " + template + " as there are creatures at the next tier.");
                        }
                        else if(!infest.Spawns[state].Contains(template))
                        {
                            SendMessageToAllDMs(template + " does not exist at that tier.");
                        }
                        else
                        {
                            infest.AddSpawn(state - 1, template);
                            infest.RemoveSpawn(state, template);
                        }
                    }
                    break;
                case Command.PrintInfestations:
                    foreach(Infestation inf in QuestStore.LoadedInfestations)
                    {
                        SendMessageToAllDMs(inf.ToString());
                    }
                    break;
                case Command.InstanceDungeon:
                    if (DungeonStore.Dungeons.ContainsKey(name)) return 0;
                    DungeonStore.FindAvailableAreas(template);
                    RandomDungeon dung = new RandomDungeon(template, state, state, this);
                    dung.retLoc = GetLocation(OBJECT_SELF);
                    DungeonStore.Dungeons.Add(name, dung);
                    break;
                case Command.EnterDungeon:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        SendMessageToAllDMs("Jumping to area");
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea enter = dungeon.GetEntranceArea();
                        enter.LoadArea(this);
                        enter.TransitionToArea(this, enter.DungeonExit);
                    }
                    break;
                case Command.DungeonTransitionNorth:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if (current.DungeonExit == ExitDirection.North)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.North, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.South);
                    }
                    break;
                case Command.DungeonTransitionEast:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if (current.DungeonExit == ExitDirection.East)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.East, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.West);
                    }
                    break;
                case Command.DungeonTransitionSouth:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if (current.DungeonExit == ExitDirection.South)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.South, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.North);
                    }
                    break;
                case Command.DungeonTransitionWest:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if (current.DungeonExit == ExitDirection.West)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.West, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.East);
                    }
                    break;
                case Command.DungeonTransitionUp:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if (current.DungeonExit == ExitDirection.Up)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.Up, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.Down);
                    }
                    break;
                case Command.DungeonTransitionDown:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        RandomDungeon dungeon = DungeonStore.Dungeons[name];
                        RandomDungeonArea current = dungeon.GetCurrentArea(this);
                        if (current == null) return 0;
                        if(current.DungeonExit == ExitDirection.Down)
                        {
                            JumpToLocation(dungeon.retLoc);
                            return 0;
                        }
                        RandomDungeonArea target = dungeon.GetAdjacentArea(this, ExitDirection.Down, current);
                        target.LoadArea(this);
                        target.TransitionToArea(this, ExitDirection.Up);
                    }
                    break;
                case Command.AddDungeonSpawn:
                    if(!DungeonStore.DungeonSpawns.ContainsKey(name))
                    {
                        DungeonStore.DungeonSpawns.Add(name, new Dictionary<int, List<string>>());
                    }
                    if(!DungeonStore.DungeonSpawns[name].ContainsKey(state))
                    {
                        DungeonStore.DungeonSpawns[name].Add(state, new List<string>());
                    }
                    DungeonStore.DungeonSpawns[name][state].Add(template);
                    break;
                case Command.RemoveDungeonSpawn:
                    if(DungeonStore.DungeonSpawns.ContainsKey(name) &&
                       DungeonStore.DungeonSpawns[name].ContainsKey(state) &&
                       DungeonStore.DungeonSpawns[name][state].Contains(template))
                    {
                        DungeonStore.DungeonSpawns[name][state].Remove(template);
                    }
                    break;
                case Command.SetDungeonSpawnType:
                    if (DungeonStore.Dungeons.ContainsKey(name))
                    {
                        foreach(RandomDungeonArea area in DungeonStore.Dungeons[name].AreasOfDungeon)
                        {
                            area.SpawnType = template;
                        }
                    }
                    break;
                case Command.PrintDungeons:
                    foreach(KeyValuePair<string, RandomDungeon> dungeon in DungeonStore.Dungeons)
                    {
                        SendMessageToAllDMs(dungeon.Key);
                        foreach(RandomDungeonArea area in dungeon.Value.AreasOfDungeon)
                        {
                            SendMessageToAllDMs(GetName(area.TemplateAreaId) + " : " + GetName(area.AreaId));
                        }
                    }
                    break;
            }
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
            AddBossMonsterToInfestation = 8,
            RemoveBossMonsterFromInfestation = 9,
            PopulateInfestationGUIScreen = 10,
            UpgradeInfestationCreatureTier = 11,
            DowngradeInfestationCreatureTier = 12,

            InstanceDungeon = 100,
            EnterDungeon = 101,
            DungeonTransitionNorth = 102,
            DungeonTransitionEast = 103,
            DungeonTransitionSouth = 104,
            DungeonTransitionWest = 105,
            DungeonTransitionUp = 106,
            DungeonTransitionDown = 107,
            AddDungeonSpawn = 108,
            RemoveDungeonSpawn = 109,
            SetDungeonSpawnType = 110,

            PrintDungeons = 998,
            PrintInfestations = 999,
        }

        public const string NoSpawn =  "Error: Cannot remove that spawn.";
        public const string NoInfest = "Error: Cannot find that infestation.";

        public const string AREA_MAX_INFESTATION = "ACR_QST_MAX_INFESTATION";
        public const string GLOBAL_QUEST_INFESTATION_KEY = "Infestation";
    }
}

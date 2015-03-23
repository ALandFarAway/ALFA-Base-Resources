using CLRScriptFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
    public class RandomDungeonArea
    {
        public int X;
        public int Y;
        public int Z;

        public ExitDirection DungeonExit = ExitDirection.None;
        public List<ExitDirection> AreaExits = new List<ExitDirection>();
        public Dictionary<ExitDirection, RandomDungeonArea> AdjacentAreas;

        public string DungeonName = "";
        public string SpawnType = "";
        public string TrapType = "";
        public string Quest = "";
        public int CR = 0;

        public uint AreaId = 0;
        public uint TemplateAreaId = 0;

        private Random rand = new Random();
        private bool questSpawned = false;

        public RandomDungeonArea() { }

        public bool LoadArea(CLRScriptBase script)
        {
            if(TemplateAreaId == 0)
            {
                // No template? Can't instance anything. Report failure.
                return false;
            }
            if(AreaId != 0)
            {
                // Got an Id? Great! Job's already done.
                return true;
            }

            // Guess we need an area. Check the cache first.
            if(DungeonStore.CachedAreas.ContainsKey(TemplateAreaId))
            {
                if(DungeonStore.CachedAreas[TemplateAreaId].Count > 0)
                {
                    AreaId = DungeonStore.CachedAreas[TemplateAreaId][0];
                    DungeonStore.CachedAreas[TemplateAreaId].Remove(DungeonStore.CachedAreas[TemplateAreaId][0]);
                    script.SetLocalString(AreaId, "DUNGEON_NAME", DungeonName);
                    PopulateArea(script);
                    return true;
                }
            }

            // No dice? OK, time to make an instance
            AreaId = script.CreateInstancedAreaFromSource(TemplateAreaId);
            if(script.GetIsObjectValid(AreaId) == CLRScriptBase.TRUE)
            {
                script.SetLocalString(AreaId, "DUNGEON_NAME", DungeonName);
                PopulateArea(script);
                return true;
            }

            return false;
        }

        private void PopulateArea(CLRScriptBase script)
        {
            List<Vector3> trapsToSpawn = new List<Vector3>();
            if (!DungeonStore.DungeonSpawns.ContainsKey(SpawnType)) return;
            foreach(uint wp in script.GetObjectsInArea(AreaId))
            {
                if(script.GetTag(wp) == "MONSTER_LOW")
                {
                    if (DungeonStore.DungeonSpawns[SpawnType].ContainsKey(CR / 3))
                    {
                        script.CreateObject(CLRScriptBase.OBJECT_TYPE_CREATURE, DungeonStore.DungeonSpawns[SpawnType][CR/3][rand.Next(DungeonStore.DungeonSpawns[SpawnType][CR/3].Count)], script.GetLocation(wp), CLRScriptBase.TRUE, "");
                    }
                }
                else if(script.GetTag(wp) == "MONSTER_MED")
                {
                    if (DungeonStore.DungeonSpawns[SpawnType].ContainsKey(CR / 2))
                    {
                        script.CreateObject(CLRScriptBase.OBJECT_TYPE_CREATURE, DungeonStore.DungeonSpawns[SpawnType][CR/2][rand.Next(DungeonStore.DungeonSpawns[SpawnType][CR/2].Count)], script.GetLocation(wp), CLRScriptBase.TRUE, "");
                    }
                }
                else if(script.GetTag(wp) == "MONSTER_HIGH")
                {
                    
                    if (DungeonStore.DungeonSpawns[SpawnType].ContainsKey(CR))
                    {
                        script.CreateObject(CLRScriptBase.OBJECT_TYPE_CREATURE, DungeonStore.DungeonSpawns[SpawnType][CR][rand.Next(DungeonStore.DungeonSpawns[SpawnType][CR].Count)], script.GetLocation(wp), CLRScriptBase.TRUE, "");
                    }
                    if (!questSpawned)
                    {
                        questSpawned = true;
                        NWEffect AoE = script.EffectAreaOfEffect(86, "acf_trg_onenter", "acf_trg_onheartbeat", "acf_trg_onexit", "AOE"+Quest);
                        script.ApplyEffectAtLocation(CLRScriptBase.DURATION_TYPE_PERMANENT, script.SupernaturalEffect(AoE), script.GetLocation(wp), 0.0f);
                        uint spawnedAoE = script.GetObjectByTag("AOE" + Quest, 0);
                        script.SetLocalString(spawnedAoE, "ACR_QST_NAME", Quest);
                        script.SetLocalInt(spawnedAoE, "ACR_QST_LOWER_STATE", 1);
                        script.SetLocalInt(spawnedAoE, "ACR_QST_UPPER_STATE", 2);
                        script.SetLocalString(spawnedAoE, "ACR_QST_MESSAGE", "This appears to be the end of the dungeon, and your path here is scouted.");
                    }
                }
                else if (script.GetTag(wp) == "TRAP")
                { 
                    if(DungeonStore.DungeonTraps[TrapType].ContainsKey(CR))
                    {
                        trapsToSpawn.Add(script.GetPosition(wp));
                    }
                }
            }
            foreach (Vector3 trap in trapsToSpawn)
            {
                script.ClearScriptParams();
                script.AddScriptParameterInt(1);
                script.AddScriptParameterFloat(trap.x);
                script.AddScriptParameterFloat(trap.y);
                script.AddScriptParameterFloat(trap.z);
                script.AddScriptParameterObject(AreaId);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterFloat(-1.0f);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterObject(CLRScriptBase.OBJECT_INVALID);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterInt(-1);
                script.AddScriptParameterString(DungeonStore.DungeonTraps[TrapType][CR][rand.Next(DungeonStore.DungeonTraps[TrapType][CR].Count)]);
                script.ExecuteScriptEnhanced("ACR_Traps", script.GetModule(), CLRScriptBase.FALSE);
            }
        }

        public void TransitionToArea(CLRScriptBase script, ExitDirection exit)
        {
            string doorTag = "DOOR_NORTH";
            switch(exit)
            {
                case ExitDirection.North:
                    doorTag = "DOOR_NORTH";
                    break;
                case ExitDirection.East:
                    doorTag = "DOOR_EAST";
                    break;
                case ExitDirection.South:
                    doorTag = "DOOR_SOUTH";
                    break;
                case ExitDirection.West:
                    doorTag = "DOOR_WEST";
                    break;
                case ExitDirection.Up:
                    doorTag = "DOOR_UP";
                    break;
                case ExitDirection.Down:
                    doorTag = "DOOR_DOWN";
                    break;
            }
            if(script.GetIsObjectValid(script.GetLocalObject(AreaId, doorTag)) == CLRScriptBase.TRUE)
            {
                uint door = script.GetLocalObject(AreaId, doorTag);
                script.JumpToObject(door, CLRScriptBase.TRUE);
                return;
            }

            foreach(uint obj in script.GetObjectsInArea(AreaId))
            {
                if(script.GetTag(obj) == doorTag)
                {
                    script.SetLocalObject(AreaId, doorTag, obj);
                    script.JumpToObject(obj, CLRScriptBase.TRUE);
                    return;
                }
            }
        }

        public void ClearArea(CLRScriptBase script)
        {
            foreach(uint obj in script.GetObjectsInArea(AreaId))
            {
                if(script.GetObjectType(obj) == CLRScriptBase.OBJECT_TYPE_CREATURE ||
                   script.GetObjectType(obj) == CLRScriptBase.OBJECT_TYPE_AREA_OF_EFFECT)
                {
                    script.DestroyObject(obj, 0.0f, CLRScriptBase.FALSE);
                }
            }
        }
    }

    public enum ExitDirection
    {
        North,
        East,
        South,
        West,
        Up,
        Down,
        None,
    }
}

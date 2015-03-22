using CLRScriptFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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
        public int CR = 0;

        public uint AreaId = 0;
        public uint TemplateAreaId = 0;

        private Random rand = new Random();

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
                }
                else if (script.GetTag(wp) == "TRAP")
                { 
                    if(DungeonStore.DungeonTraps[TrapType].ContainsKey(CR))
                    {
                        script.ClearScriptParams();
                        script.AddScriptParameterInt(1);
                        script.AddScriptParameterFloat(-1.0f);
                        script.AddScriptParameterFloat(-1.0f);
                        script.AddScriptParameterFloat(-1.0f);
                        script.AddScriptParameterObject(CLRScriptBase.OBJECT_INVALID);
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
                        script.ExecuteScriptEnhanced("ACR_Traps", AreaId, CLRScriptBase.TRUE);
                    }
                }
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

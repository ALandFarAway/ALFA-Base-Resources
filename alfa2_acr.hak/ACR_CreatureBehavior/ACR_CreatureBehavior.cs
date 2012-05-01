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

namespace ACR_CreatureBehavior
{
    public partial class ACR_CreatureBehavior : CLRScriptBase, IGeneratedScriptProgram
    {
        private ACR_CreatureBehavior([In] ACR_CreatureBehavior Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode = 0;
            int CreatureEventType = (int)ScriptParameters[0];
            SendMessageToPC(GetLocalObject(OBJECT_SELF, "TEST_OBJECT"), "Hello world!");
            switch ((EVENT_TYPE)CreatureEventType)
            {
                case EVENT_TYPE.CREATURE_ON_SPAWN:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_SPELL_CAST_AT:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_PHYSICALLY_ATTACKED:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DAMAGED:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DEATH:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_BLOCKED:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_END_COMBAT_ROUND:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_CONVERSATION:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_INVENTORY_DISTURBED:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_HEARTBEAT:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_RESTED:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_PERCEPTION:
                    {
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_USER_DEFINED:
                    {
                    }
                    break;

                case EVENT_TYPE.MODULE_ON_START:
                    {
                        AreaManager.IndexAreas(this);
                    }
                    break;

                foreach(AreaManager.AreaObject Area in
                        AreaManager.ServerContents.Areas)
                    {
                        SendMessageToPC(GetLocalObject(OBJECT_SELF, "TEST_OBJECT"), IntToString(ObjectToInt(Area.AreaObjectId)));
                    }
            }

            return ReturnCode;
        }

        private enum EVENT_TYPE
        {
            CREATURE_ON_SPAWN,
            CREATURE_ON_SPELL_CAST_AT,
            CREATURE_ON_PHYSICALLY_ATTACKED,
            CREATURE_ON_DAMAGED,
            CREATURE_ON_DEATH,
            CREATURE_ON_BLOCKED,
            CREATURE_END_COMBAT_ROUND,
            CREATURE_ON_CONVERSATION,
            CREATURE_ON_INVENTORY_DISTURBED,
            CREATURE_ON_HEARTBEAT,
            CREATURE_ON_RESTED,
            CREATURE_ON_PERCEPTION,
            CREATURE_ON_USER_DEFINED,
            
            MODULE_ON_START
        }

        private ALFA.Database Database = null;
    }

    public static class AreaManager
    {
        public static void IndexAreas(ACR_CreatureBehavior Script)
        {
            foreach (uint AreaObjectId in
                    Script.GetAreas())
            {
                AreaObject Area = new AreaObject();
                Area.AreaObjectId = AreaObjectId;
                Area.AreaInterior = Script.GetIsAreaInterior(AreaObjectId);
                Area.AreaNatural = Script.GetIsAreaNatural(AreaObjectId);
                Area.AreaUnderground = Script.GetIsAreaAboveGround(AreaObjectId);
                ServerContents.Areas.Add(Area);
            }
        }

        public class AreaObject
        {
            public uint AreaObjectId;
            public int  AreaInterior;
            public int  AreaNatural;
            public int  AreaUnderground;
        }

        public static class ServerContents
        {
            public static List<AreaObject> Areas = null;
        }
    }

    public enum AIType
    {
        BEHAVIOR_TYPE_TANK,
        BEHAVIOR_TYPE_FLANK,
        BEHAVIOR_TYPE_SHOCK,
        BEHAVIOR_TYPE_BUFFS,
        BEHAVIOR_TYPE_MEDIC,
        BEHAVIOR_TYPE_SKIRMISH,
        BEHAVIOR_TYPE_ARCHER,
        BEHAVIOR_TYPE_CONTROL,
        BEHAVIOR_TYPE_NUKE
    }
}
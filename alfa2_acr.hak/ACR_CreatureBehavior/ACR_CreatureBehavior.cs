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
        public ACR_CreatureBehavior([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
            Database = new ALFA.Database(this);
        }

        private ACR_CreatureBehavior([In] ACR_CreatureBehavior Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode = 0;
            int CreatureEventType = (int)ScriptParameters[0];
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
                        foreach (uint AreaObjectId in
                                 GetAreas())
                        {
                            AreaManager.AreaObject Area = new AreaManager.AreaObject();
                            Area.AreaObjectId = AreaObjectId;
                            Area.AreaInterior = GetIsAreaInterior(AreaObjectId);
                            Area.AreaNatural = GetIsAreaNatural(AreaObjectId);
                            Area.AreaUnderground = GetIsAreaAboveGround(AreaObjectId);
                            foreach (uint ObjectId in
                                     GetObjectsInArea(AreaObjectId))
                            {
                                if (GetIsObjectValid(GetTransitionTarget(ObjectId)) != 0)
                                {
                                    if(!Area.AreaTransitionObjects.Contains(ObjectId))
                                        Area.AreaTransitionObjects.Add(ObjectId);

                                    if(!Area.AreaTransitionTargets.Contains(ObjectId))
                                        Area.AreaTransitionTargets.Add(GetArea(GetTransitionTarget(ObjectId)));
                                }

                            }
                            ServerContents.Areas.Add(Area);
                        }
                    }
                    break;
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

// AreaManager is a class used to define classes used by other portions of code-- it is meant to provide instances
// to the ServerContents static class via nesting.
// ServerContents
//  - AreaObject
//  --- AreaTransitions
//  --- NPC Parties
//  ----- Individual NPCs
//  - AreaObject
    public class AreaManager
    {
        public class AreaObject
        {
            public uint AreaObjectId = OBJECT_INVALID;
            public int  AreaInterior = -1;
            public int  AreaNatural = -1;
            public int  AreaUnderground = -1;
            public List<uint> AreaTransitionObjects = new List<uint> { };
            public List<uint> AreaTransitionTargets = new List<uint> { };
            public List<NPCParty> ContainedParties = new List<NPCParty> { };
        }

        public class NPCParty
        {
            public float PartyCR = 0.0f;

            public NPC PartyLeader = new NPC { };
            public List<NPC> PartyMembers = new List<NPC> { };
            public List<NPC> DeadMember = new List<NPC> { };

            // Melee types.
            public List<NPC> PartyTanks = new List<NPC> { };
            public List<NPC> PartyCrushbots = new List<NPC> { };
            
            // Skilled types.
            public List<NPC> PartyFlanks = new List<NPC> { };
            public List<NPC> PartyArcher = new List<NPC> { };
            public List<NPC> PartySkirmish = new List<NPC> { };
            
            // Magic types.
            public List<NPC> PartyBuffbot = new List<NPC> { };
            public List<NPC> PartyHealbot = new List<NPC> { };
            public List<NPC> PartyBlaster = new List<NPC> { };

            // Other types.
            public List<NPC> PartyCowards = new List<NPC> { };
            public List<NPC> PartyAnimals = new List<NPC> { };
            public List<NPC> PartyMindless = new List<NPC> { };

        }

        public class NPC
        {
            public float NPCCR = 0.0f;
            public uint NPCObjectId = OBJECT_INVALID;
        }

        private const uint OBJECT_INVALID = 2130706432;
    }


// ServerContents is the static shell to make the seeking of object instances defined in AreaManager perpetually
// findable.
    public static class ServerContents
    {
        public static List<AreaManager.AreaObject> Areas = new List<AreaManager.AreaObject> { };
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
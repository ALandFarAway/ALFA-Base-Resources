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
                        CreatureObject Creature = new CreatureObject(OBJECT_SELF);
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_SPELL_CAST_AT:
                    {
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnSpellCastAt(GetLastSpellCaster(), GetLastSpell());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_PHYSICALLY_ATTACKED:
                    {
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnAttacked(GetLastAttacker(OBJECT_SELF));
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DAMAGED:
                    {
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnDamaged(GetLastDamager(OBJECT_SELF), GetTotalDamageDealt());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DEATH:
                    {
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnDeath(GetLastKiller());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_BLOCKED:
                    {
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnBlocked(GetBlockingDoor());
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
                        CreatureObject Creature = GameObject.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                        {
                            Creature.OnPerception(GetLastPerceived(),
                                GetLastPerceptionHeard() != CLRScriptBase.FALSE ? true : false,
                                GetLastPerceptionInaudible() != CLRScriptBase.FALSE ? true : false,
                                GetLastPerceptionSeen() != CLRScriptBase.FALSE ? true : false,
                                GetLastPerceptionVanished() != CLRScriptBase.FALSE ? true : false);
                        }
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_USER_DEFINED:
                    {
                    }
                    break;

                case EVENT_TYPE.MODULE_ON_START:
                    {
                        //
                        // Initialize the game object subsystem.
                        //

                        GameObject.Initialize();



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
                                    if (!Area.AreaTransitionObjects.Contains(ObjectId))
                                        Area.AreaTransitionObjects.Add(ObjectId);

                                    if (!Area.AreaTransitionTargets.Contains(ObjectId))
                                        Area.AreaTransitionTargets.Add(GetArea(GetTransitionTarget(ObjectId)));
                                }

                            }
                            ServerContents.Areas.Add(Area);
                        }
                    }
                    break;

                case EVENT_TYPE.AREA_ON_INSTANCE_CREATE:
                    {
                        ModuleObject Module = GameObject.Module;

                        Module.AddInstancedArea(OBJECT_SELF);
                    }
                    break;
            }

            GameObject.ProcessPendingDeletions();

            return ReturnCode;
        }

        private enum EVENT_TYPE
        {
            CREATURE_ON_SPAWN = 0,
            CREATURE_ON_SPELL_CAST_AT = 1,
            CREATURE_ON_PHYSICALLY_ATTACKED = 2,
            CREATURE_ON_DAMAGED = 3,
            CREATURE_ON_DEATH = 4,
            CREATURE_ON_BLOCKED = 5,
            CREATURE_END_COMBAT_ROUND = 6,
            CREATURE_ON_CONVERSATION = 7,
            CREATURE_ON_INVENTORY_DISTURBED = 8,
            CREATURE_ON_HEARTBEAT = 9,
            CREATURE_ON_RESTED = 10,
            CREATURE_ON_PERCEPTION = 11,
            CREATURE_ON_USER_DEFINED = 12,
            
            MODULE_ON_START = 100,

            AREA_ON_INSTANCE_CREATE = 200
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

        private const uint OBJECT_INVALID = CLRScriptBase.OBJECT_INVALID;
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
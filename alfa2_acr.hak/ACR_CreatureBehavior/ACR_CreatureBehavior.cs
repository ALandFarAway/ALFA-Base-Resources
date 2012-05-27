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
                        CreatureObject Creature = new CreatureObject(OBJECT_SELF, Server.ObjectManager);

                        Creature.OnSpawn();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_SPELL_CAST_AT:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnSpellCastAt(GetLastSpellCaster(), GetLastSpell());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_PHYSICALLY_ATTACKED:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnAttacked(GetLastAttacker(OBJECT_SELF));
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DAMAGED:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnDamaged(GetLastDamager(OBJECT_SELF), GetTotalDamageDealt());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_DEATH:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnDeath(GetLastKiller());
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_BLOCKED:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnBlocked(GetBlockingDoor());
                    }
                    break;

                case EVENT_TYPE.CREATURE_END_COMBAT_ROUND:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnEndCombatRound();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_CONVERSATION:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnConversation();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_INVENTORY_DISTURBED:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnInventoryDisturbed();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_HEARTBEAT:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnHeartbeat();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_RESTED:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnRested();
                    }
                    break;

                case EVENT_TYPE.CREATURE_ON_PERCEPTION:
                    {
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

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
                        CreatureObject Creature = Server.ObjectManager.GetCreatureObject(OBJECT_SELF);

                        if (Creature != null)
                            Creature.OnUserDefined(GetUserDefinedEventNumber());
                    }
                    break;

                case EVENT_TYPE.MODULE_ON_STARTED:
                    {
                        //
                        // Initialize the server subsystem.
                        //

                        Server.Initialize();

                        foreach (AreaObject Area in Server.ObjectManager.GetAreas())
                        {
                            foreach (uint ObjectInAreaId in Area.GetObjectIdsInArea())
                            {
                                if (GetObjectType(ObjectInAreaId) == CLRScriptBase.OBJECT_TYPE_TRIGGER)
                                {
                                    if (GetTransitionTarget(ObjectInAreaId) != OBJECT_INVALID)
                                    {
                                        AreaObject.AreaTransition Transition = new AreaObject.AreaTransition();
                                        Transition.ObjectId = ObjectInAreaId;
                                        Transition.TargetArea = Server.ObjectManager.GetAreaObject(GetArea(GetTransitionTarget(ObjectInAreaId)));
                                        Area.AreaTransitions.Add(Transition);
                                    }
                                }
                            }
                        }
                    }
                    break;

                case EVENT_TYPE.AREA_ON_INSTANCE_CREATE:
                    {
                        if (Server.ObjectManager == null)
                            break;

                        ModuleObject Module = Server.ObjectManager.Module;

                        if (Module == null)
                            break;

                        Module.AddInstancedArea(OBJECT_SELF);
                    }
                    break;
            }

            Server.ObjectManager.ProcessPendingDeletions();

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
            
            MODULE_ON_STARTED = 100,

            AREA_ON_INSTANCE_CREATE = 200
        }

        private ALFA.Database Database = null;
    }
}
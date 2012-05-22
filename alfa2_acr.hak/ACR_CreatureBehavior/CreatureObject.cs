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
    /// <summary>
    /// This class represents a creature within the game.
    /// </summary>
    public class CreatureObject : GameObject
    {

        /// <summary>
        /// Construct a creature object and insert it into the object table.
        /// </summary>
        /// <param name="ObjectId">Supplies the creature object id.</param>
        /// <param name="ObjectManager">Supplies the object manager.</param>
        public CreatureObject(uint ObjectId, GameObjectManager ObjectManager) : base(ObjectId, GameObjectType.Creature, ObjectManager)
        {
            //
            // Cache state that doesn't change over the lifetime of the object
            // so as to avoid a need to call down into the engine for these
            // fields.
            //

            CreatureIsPC = Script.GetIsPC(ObjectId) != CLRScriptBase.FALSE ? true : false;
            CreatureIsDM = Script.GetIsDM(ObjectId) != CLRScriptBase.FALSE ? true : false;
            PerceivedObjects = new List<PerceptionNode>();
        }

        /// <summary>
        ///  Called when the creature is spawned, immediately after the class' constructors are run.
        ///  Responsible for establishing party membership.
        /// </summary>
        public void OnSpawn()
        {
            bool PartyAssigned = false;
            uint NearbyCreatureId = Script.GetFirstObjectInShape(CLRScriptBase.SHAPE_SPHERE, 25.0f, Script.GetLocation(this.ObjectId), CLRScriptBase.TRUE, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f,0.0f,0.0f));
            if(NearbyCreatureId != OBJECT_INVALID && PartyAssigned == false)
            {
                if (Script.GetFactionEqual(this.ObjectId, NearbyCreatureId) == CLRScriptBase.TRUE)
                {
                    CreatureObject NearbyCreature = Server.ObjectManager.GetCreatureObject(NearbyCreatureId);
                    if (NearbyCreature != null)
                    {
                        AIParty Party = NearbyCreature.Party;
                        if(Party == null)
                            throw new ApplicationException(String.Format("Creature {0} has spawned without being added to a party.", NearbyCreature));
                        else
                        {
                            Party.AddPartyMember(this);
                        }
                    }
                    else
                    {
                        // This is an error-- an existing creature slipped by us?
                        throw new ApplicationException(String.Format("Creature with ID {0} has spawned, but has not been indexed by ACR_CreatureBehavior.", NearbyCreatureId));
                    }
                }
                Script.GetFirstObjectInShape(CLRScriptBase.SHAPE_SPHERE, 25.0f, Script.GetLocation(this.ObjectId), CLRScriptBase.TRUE, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f,0.0f,0.0f));
            }
        }

        /// <summary>
        /// Called when the C# object state is being run down because the game
        /// engine half of the object has been deleted.  This might occur after
        /// the fact.
        /// </summary>
        public override void OnRundown()
        {
            if (Party != null)
                Party.RemovePartyMember(this);
        }

        /// <summary>
        /// Called when a spell is cast on the creature.
        /// </summary>
        /// <param name="CasterObjectId">Supplies the spell caster object id.
        /// </param>
        /// <param name="SpellId">Supplies the spell id.</param>
        public void OnSpellCastAt(uint CasterObjectId, int SpellId)
        {
            if (!IsAIControlled)
                return;

            int nSpell = Script.GetLastSpell();
            int nHostile = Script.StringToInt(Script.Get2DAString("spells","HostileSetting", nSpell));

//===================================================================================================================================
//=======================  Handling for harmful spells ==============================================================================
//===================================================================================================================================
            if (nHostile == 1)
            {
                // As this is a harmful spell, the target is probably going to be unhappy about it.
                bool bAngry = true;
                uint CasterId =  Script.GetLastSpellCaster();
                int nReputation = Script.GetReputation(this.ObjectId, CasterId);

                // If the creature is -already- hostile, we don't need to make it any -more- angry.
                if (nReputation <= 10)
                    bAngry = false;

                // If this is the caster hitting him or herself, no doubt that's angering, but we don't need to change behavior because of it.
                if (CasterId == this.ObjectId)
                    bAngry = false;

                // Maybe mind-controlling magic is in play?
                if (bAngry)
                {
                    if (_IsMindMagiced(this.ObjectId)) bAngry = false;
                    if (_IsMindMagiced(CasterId)) bAngry = false;
                }

                // If mind magics didn't motivate the spell, we check to see if it's plausibly friendly fire.
                if (bAngry)
                {
                    int nTargetArea = Script.StringToInt(Script.Get2DAString("spells", "TargetingUI", nSpell));
                    if (_IsFriendlyFire(nTargetArea)) bAngry = false;
                }

                // Is the target a friend to the caster?
                if (bAngry)
                {
                    CreatureObject Caster = Server.ObjectManager.GetCreatureObject(CasterId, true);
                    AIParty Party = this.Party;

                    // This is the fault of a bug in the AI; best not to compound it.
                    if (Party.PartyMembers.Contains(Caster))
                    {
                        bAngry = false;
                    }

                    // These two creatures are friends.
                    else if (nReputation > 89)
                    {
                        Script.SetLocalInt(this.ObjectId, "FRIENDLY_FIRED", Script.GetLocalInt(this.ObjectId, "FRIENDLY_FIRED") + 1);
                    }

                    // Neutral creatures take direct attacks personally. Your friends try to trust you, but will snap if abused too much.
                    else if (nReputation > 10 || Script.GetLocalInt(this.ObjectId, "FRIENDLY_FIRED") > Script.d4(2))
                    {
                        // And all of them are going to get angry.
                        foreach (CreatureObject CurrentPartyMember in this.Party.PartyMembers)
                        {
                            _SetMutualEnemies(CurrentPartyMember.ObjectId, CasterId);
                            if (!CurrentPartyMember.HasCombatRoundProcess)
                                 CurrentPartyMember.SelectCombatRoundAction();
                        }
                        this.Party.AddPartyEnemy(Caster);
                        this.Party.EnemySpellcasters.Add(Caster);
                    }
                }
            }

//===================================================================================================================================
//=======================  Handling for non-harmful spells ==========================================================================
//===================================================================================================================================
            else
            {
            }
        }

        /// <summary>
        /// Called when the creature is damaged.
        /// </summary>
        /// <param name="DamagerObjectId">Supplies the damager object id.
        /// </param>
        /// <param name="TotalDamageDealt">Supplies the total damage dealt.
        /// </param>
        public void OnDamaged(uint DamagerObjectId, int TotalDamageDealt)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature dies.
        /// </summary>
        /// <param name="KillerObjectId">Supplies the killer object id.</param>
        public void OnDeath(uint KillerObjectId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the creature's movement is blocked.
        /// </summary>
        /// <param name="BlockerObjectId">Supplies the blocker object
        /// id.</param>
        public void OnBlocked(uint BlockerObjectId)
        {
            if (!IsAIControlled)
                return;
        }

        /// <summary>
        /// Called when the perception state of the creature changes.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="Heard">True if the object is now heard.</param>
        /// <param name="Inaudible">True if the object is now not
        /// heard.</param>
        /// <param name="Seen">True if the object is now seen.</param>
        /// <param name="Vanished">True if the object is now not seen.</param>
        public void OnPerception(uint PerceivedObjectId, bool Heard, bool Inaudible, bool Seen, bool Vanished)
        {
            //
            // No need to manage perception tracking for PC or DM avatars as
            // these will never be AI controlled.
            //

            if (IsPC || IsDM)
                return;

            //
            // Update the perception list.  This is done even if we are not yet
            // AI controlled (as control could be temporarily suspended e.g. by
            // DM command).
            //

            PerceptionNode Node = (from PN in PerceivedObjects
                                   where PN.PerceivedObjectId == PerceivedObjectId
                                   select PN).FirstOrDefault();
            bool NewNode = false;
            bool RemoveNode = false;

            if (Node == null)
            {
                if (Heard || Seen)
                {
                    Node = new PerceptionNode(PerceivedObjectId);
                    NewNode = true;
                    PerceivedObjects.Add(Node);
                }
                else
                {
                    return;
                }
            }

            if (Heard)
            {
                Node.Heard = true;
                OnPerceptionSeenObject(PerceivedObjectId, NewNode);
            }

            if (Seen)
            {
                Node.Seen = true;
                OnPerceptionHeardObject(PerceivedObjectId, NewNode);
            }

            if (Vanished)
            {
                Node.Seen = false;

                if (!Node.Heard)
                {
                    RemoveNode = true;
                    PerceivedObjects.Remove(Node);
                }

                OnPerceptionLostSightObject(PerceivedObjectId, RemoveNode);
            }

            if (Inaudible)
            {
                Node.Heard = false;

                if (!Node.Seen)
                {
                    RemoveNode = true;
                    PerceivedObjects.Remove(Node);
                }

                OnPerceptionLostHearingObject(PerceivedObjectId, RemoveNode);
            }
        }

        /// <summary>
        /// Called when an object first sees an object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="InitialDetection">True if this is the first detection
        /// event for the perceived object since it last became undetected.
        /// </param>
        private void OnPerceptionSeenObject(uint PerceivedObjectId,
            bool InitialDetection)
        {
        
        }

        /// <summary>
        /// Called when an object first hears an object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="InitialDetection">True if this is the first detection
        /// event for the perceived object since it last became undetected.
        /// </param>
        private void OnPerceptionHeardObject(uint PerceivedObjectId,
            bool InitialDetection)
        {
        
        }

        /// <summary>
        /// Called when an object loses sight of another object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="LastDetection">True if this is the last detection
        /// method for the perceived object.
        /// </param>
        private void OnPerceptionLostSightObject(uint PerceivedObjectId,
            bool LastDetection)
        {
        
        }

        /// <summary>
        /// Called when an object loses hearing of another object.
        /// </summary>
        /// <param name="PerceivedObjectId">Supplies the perceived object id.
        /// </param>
        /// <param name="LastDetection">True if this is the last detection
        /// method for the perceived object.
        /// </param>
        private void OnPerceptionLostHearingObject(uint PerceivedObjectId,
            bool LastDetection)
        {
        
        }

        /// <summary>
        /// Called at the end of a combat round, when direction for the next round of combat 
        /// is necessary. This managed the bulk of action in combat.
        /// </summary>
        public void OnEndCombatRound()
        {
            
        }

        /// <summary>
        /// Called when someone attempts to open a static conversation with the creature.
        /// </summary>
        public void OnConversation()
        {

        }

        /// <summary>
        /// Called when a creature picks up or loses an item.
        /// </summary>
        public void OnInventoryDisturbed()
        {

        }

        /// <summary>
        /// Called approximately every six seconds on an NPC, regardless of whether or not the NPC is in combat.
        /// </summary>
        public void OnHeartbeat()
        {

        }

        /// <summary>
        /// Called after a creature rests.
        /// </summary>
        public void OnRested()
        {

        }

        /// <summary>
        /// Called whenever a builder invokes an event by script.
        /// </summary>
        /// <param name="UserDefinedEventNumber">Supplies the user-defined
        /// event number associated with the event request.</param>
        public void OnUserDefined(int UserDefinedEventNumber)
        {

        }

        /// <summary>
        /// This function is the primary means by which actions are selected for a given combat round.
        /// </summary>
        public void SelectCombatRoundAction()
        {

        }

        /// <summary>
        /// This function causes Creature1 and Creature2 to be flagged as temporary enemies of one another, with no specified decay
        /// time. They, thus, will fight until killed or separated, but will not break the rest of their factions.
        /// </summary>
        /// <param name="Creature1"></param>
        /// <param name="Creature2"></param>
        private void _SetMutualEnemies(uint Creature1, uint Creature2)
        {
            Script.SetIsTemporaryEnemy(Creature1, Creature2, CLRScriptBase.FALSE, 0.0f);
            Script.SetIsTemporaryEnemy(Creature2, Creature1, CLRScriptBase.FALSE, 0.0f);
        }

        /// <summary>
        /// This function attempts to determine if the spell just cast on this creature was plausibly friendly fire, based on the
        /// locations of nearby enemies.
        /// </summary>
        /// <param name="nTargetArea">Spell Target AOE as defined in spells.2da in the targeting UI</param>
        /// <returns></returns>
        private bool _IsFriendlyFire(int nTargetArea)
        {
            // Check for friendly fire.
            switch ((SpellTargetAOE)nTargetArea)
            {
                case SpellTargetAOE.SPELL_TARGET_COLOSSAL_AOE:
                    // With a colossal AOE, no sense in checking. That as probably friendly fire.
                    return true;
                case SpellTargetAOE.SPELL_TARGET_HUGE_AOE:
                case SpellTargetAOE.SPELL_TARGET_HUGE_AOE_A:
                case SpellTargetAOE.SPELL_TARGET_HUGE_AOE_B:
                    {
                        foreach (uint TargetId in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_HUGE * 2.0f, Script.GetLocation(this.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                        {
                            // We found an enemy in sight; this is probably friendly fire.
                            if (Script.GetReputation(this.ObjectId, TargetId) < 11)
                                return true;
                        }
                    }
                    break;
                case SpellTargetAOE.SPELL_TARGET_LARGE_AOE:
                case SpellTargetAOE.SPELL_TARGET_PURPLE_LARGE:
                case SpellTargetAOE.SPELL_TARGET_LINE:
                    {
                        foreach (uint TargetId in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_LARGE * 2.0f, Script.GetLocation(this.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                        {
                            // We found an enemy nearby; this is probably friendly fire.
                            if (Script.GetReputation(this.ObjectId, TargetId) < 11)
                                return true;
                        }
                    }
                    break;
                case SpellTargetAOE.SPELL_TARGET_PURPLE_MEDIUM:
                case SpellTargetAOE.SPELL_TARGET_RECTANGLE_A:
                case SpellTargetAOE.SPELL_TARGET_RECTANGLE_B:
                    {
                        foreach (uint TargetId in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM * 2.0f, Script.GetLocation(this.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                        {
                            // We found an enemy nearby; this is probably friendly fire.
                            if (Script.GetReputation(this.ObjectId, TargetId) < 11)
                                return true;
                        }
                    }
                    break;
                case SpellTargetAOE.SPELL_TARGET_PURPLE_SMALL:
                case SpellTargetAOE.SPELL_TARGET_SHORT_CONE_A:
                case SpellTargetAOE.SPELL_TARGET_SHORT_CONE_B:
                case SpellTargetAOE.SPELL_TARGET_SHORT_CONE_C:
                case SpellTargetAOE.SPELL_TARGET_SHORT_CONE_D:
                    {
                        foreach (uint TargetId in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_SMALL * 2.0f, Script.GetLocation(this.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                        {
                            // We found an enemy nearby; this is probably friendly fire.
                            if (Script.GetReputation(this.ObjectId, TargetId) < 11)
                                return true;
                        }
                    }
                    break;
            }
            return false;
        }

        /// <summary>
        /// Determines if Creature has effects which would typically cause targeting problems, and might
        ///  result in attacking a friendly person.
        /// </summary>
        /// <param name="CreatureId"></param>
        /// <returns></returns>
        private bool _IsMindMagiced(uint CreatureId)
        {
            foreach (NWEffect eEffect in Script.GetObjectEffects(CreatureId))
            {
                if (Script.GetEffectType(eEffect) == CLRScriptBase.EFFECT_TYPE_BLINDNESS ||
                    Script.GetEffectType(eEffect) == CLRScriptBase.EFFECT_TYPE_CHARMED ||
                    Script.GetEffectType(eEffect) == CLRScriptBase.EFFECT_TYPE_CONFUSED ||
                    Script.GetEffectType(eEffect) == CLRScriptBase.EFFECT_TYPE_DOMINATED ||
                    Script.GetEffectType(eEffect) == CLRScriptBase.EFFECT_TYPE_INSANE)
                {
                    // These are all obvious sources of misbehavior.
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Called when the creature is attacked.
        /// </summary>
        /// <param name="AttackerObjectId">Supplies the attacker object id.
        /// </param>
        public void OnAttacked(uint AttackerObjectId)
        {
            if (!IsAIControlled)
                return;

            uint Attacker = Script.GetLastAttacker(this.ObjectId);

            // Attacker is under the influence of mind-affecting stuff; we don't need to get angry.
            if (_IsMindMagiced(Attacker))
                return;

            // This creature is under the influence of mind-affecting stuff. It isn't cognizant enough to be angry.
            if (_IsMindMagiced(this.ObjectId))
                return;
        }

        /// <summary>
        /// This contains whether or not this creature has an active cycle of combat round processing.
        /// </summary>
        public bool HasCombatRoundProcess = false;

        /// <summary>
        /// Get whether the creature is a player avatar (includes DMs).
        /// </summary>
        public bool IsPC { get { return CreatureIsPC; } }

        /// <summary>
        /// Get whether the creature is a DM avatar.
        /// </summary>
        public bool IsDM { get { return CreatureIsDM; } }

        /// <summary>
        /// Get whether a player or DM is controlling the creature.
        /// </summary>
        public bool IsPlayerControlled { get { return Script.GetControlledCharacter(ObjectId) != OBJECT_INVALID; } }

        /// <summary>
        /// Get or set whether the object is managed by the AI subsystem.  This
        /// should be only set at startup time for the object, generally.
        /// </summary>
        public bool IsAIControlled { get { return AIControlled && !IsPlayerControlled; } set { AIControlled = value; } }

        /// <summary>
        /// The list of perceived objects.
        /// </summary>
        public List<PerceptionNode> PerceivedObjects { get; set; }

        /// <summary>
        /// The associated AI party, if any.
        /// </summary>
        public AIParty Party { get; set; }

        /// <summary>
        /// The leader of the party, if any.
        /// </summary>
        public CreatureObject PartyLeader
        {
            get
            {
                if (Party == null)
                    return null;
                else
                    return Party.PartyLeader;
            }
        }



        /// <summary>
        /// The creature is PC flag (DMs are also PCs).
        /// </summary>
        private bool CreatureIsPC;

        /// <summary>
        /// The creature is DM flag.
        /// </summary>
        private bool CreatureIsDM;

        /// <summary>
        /// True if the object is controlled by the AI subsystem.
        /// </summary>
        private bool AIControlled;


        /// <summary>
        /// This class records what objects are perceived by this object.
        /// </summary>
        public class PerceptionNode
        {
            /// <summary>
            /// Create a new, blank perception node relating to perception of a
            /// given object.
            /// </summary>
            /// <param name="ObjectId">Supplies the object whose perception
            /// state is being tracked.</param>
            public PerceptionNode(uint ObjectId)
            {
                PerceivedObjectId = ObjectId;
            }

            /// <summary>
            /// The object id that is being perceived.
            /// </summary>
            public uint PerceivedObjectId;

            /// <summary>
            /// True if the object is seen.
            /// </summary>
            public bool Seen;

            /// <summary>
            /// True if the object is heard.
            /// </summary>
            public bool Heard;
        }

        public int TacticsType = (int)AIParty.AIType.BEHAVIOR_TYPE_UNDEFINED;

        public enum SpellTargetAOE
        {
            SPELL_TARGET_SINGLE = 0,
            SPELL_TARGET_RECTANGLE_A = 1,
            SPELL_TARGET_HUGE_AOE_A = 2,
            SPELL_TARGET_SHORT_CONE_A = 3,
            SPELL_TARGET_SHORT_CONE_B = 4,
            SPELL_TARGET_SHORT_CONE_C = 5,
            SPELL_TARGET_POINT = 6,
            SPELL_TARGET_HUGE_AOE_B = 7,
            SPELL_TARGET_LARGE_AOE = 8,
            SPELL_TARGET_HUGE_AOE = 9,
            SPELL_TARGET_COLOSSAL_AOE = 10,
            SPELL_TARGET_RECTANGLE_B = 11,
            SPELL_TARGET_LINE = 12,
            SPELL_TARGET_PURPLE_SMALL = 13,
            SPELL_TARGET_PURPLE_MEDIUM = 14,
            SPELL_TARGET_PURPLE_LARGE = 15,
            SPELL_TARGET_SHORT_CONE_D = 16,
        }
        
        const string ON_SPAWN_EVENT = "ACR_VFX_ON_SPAWN";
        const string EFFECT_VISUAL = "_EFFECT_VISUAL";
        const string EFFECT_PHYSICAL = "_EFFECT_PHYSICAL";
        const string EFFECT_DAMAGE = "_EFFECT_DAMAGE";
    }
}

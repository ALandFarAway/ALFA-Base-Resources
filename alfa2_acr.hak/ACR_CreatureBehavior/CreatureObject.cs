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

        #region === Incoming Events ===
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
            IsAIControlled = true;
            foreach(uint NearbyCreatureId in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, 25.0f, Script.GetLocation(this.ObjectId), true, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f,0.0f,0.0f)))
            {
                if (Script.GetFactionEqual(this.ObjectId, NearbyCreatureId) == CLRScriptBase.TRUE)
                {
                    CreatureObject NearbyCreature = Server.ObjectManager.GetCreatureObject(NearbyCreatureId, true);
                    if (NearbyCreature != null && NearbyCreature.Party != null)
                    NearbyCreature.Party.AddPartyMember(this);
                    break;
                }
            }
            if (this.Party == null)
            {
                new AIParty(Server.PartyManager).AddPartyMember(this);
            }

            // Set effects inherent to subtype.
            if (Script.GetLocalInt(this.ObjectId, "X2_L_IS_INCORPOREAL") != 0) SetIncorporealEffects();

            // Set effects inherent to type.
            if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_ABERRATION) SetAbberationEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_ANIMAL) SetAnimalEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_CONSTRUCT) SetConstructEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_DRAGON) SetDragonEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_ELEMENTAL) SetElementalEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_FEY) SetFeyEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_GIANT) SetGiantEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_HUMANOID_MONSTROUS) SetMonstrousHumanoidEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_MAGICAL_BEAST) SetMagicalBeastEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_OOZE) SetOozeEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_UNDEAD) SetUndeadEffects();
            else if (Script.GetRacialType(this.ObjectId) == CLRScriptBase.RACIAL_TYPE_VERMIN) SetVerminEffects();

            int extraAttacks = Script.GetLocalInt(ObjectId, "ACR_CREATURE_EXTRA_ATTACKS");
            if(extraAttacks != 0)
                SetExtraAttacks(extraAttacks);
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
                    else if (nReputation > 10 || Script.GetLocalInt(this.ObjectId, "FRIENDLY_FIRED") > Script.d4(3))
                    {
                        // And all of them are going to get angry.
                        foreach (CreatureObject CurrentPartyMember in this.Party.PartyMembers)
                        {
                            _SetMutualEnemies(CurrentPartyMember.ObjectId, CasterId);
                            if (!CurrentPartyMember.HasCombatRoundProcess)
                                 CurrentPartyMember.SelectCombatRoundAction(false);
                        }
                        this.Party.AddPartyEnemy(Caster);
                        this.Party.EnemySpellcasters.Add(Caster);
                        HasCombatRoundProcess = true;
                        if (!UsingEndCombatRound)
                        {
                            SelectCombatRoundAction(false);
                        }
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
            if (Script.GetIsDM(DamagerObjectId) == CLRScriptBase.TRUE)
                return;
            if (Script.GetObjectType(DamagerObjectId) != CLRScriptBase.OBJECT_TYPE_CREATURE)
                return;

            CreatureObject Damager = Server.ObjectManager.GetCreatureObject(DamagerObjectId, true);
            AIParty Party = this.Party;

            if (Damager != null)
            {
                int nReputation = Script.GetReputation(this.ObjectId, DamagerObjectId);

                // The friendly fire functionality lives in the spell cast method
                if (Script.GetLastSpellCaster() == DamagerObjectId)
                    return;


                // This is the fault of a bug in the AI; best not to compound it.
                if (Party.PartyMembers.Contains(Damager))
                    return;

                // These two creatures are friends.
                else if (nReputation > 89)
                {
                    Script.SetLocalInt(this.ObjectId, "FRIENDLY_FIRED", Script.GetLocalInt(this.ObjectId, "FRIENDLY_FIRED") + 1);
                }

                // Neutral creatures take direct attacks personally. Your friends try to trust you, but will snap if abused too much.
                else if (nReputation > 10 || Script.GetLocalInt(this.ObjectId, "FRIENDLY_FIRED") > Script.d4(3))
                {
                    // And all of them are going to get angry.
                    foreach (CreatureObject CurrentPartyMember in this.Party.PartyMembers)
                    {
                        _SetMutualEnemies(CurrentPartyMember.ObjectId, DamagerObjectId);
                        if (!CurrentPartyMember.HasCombatRoundProcess)
                            CurrentPartyMember.SelectCombatRoundAction(false);
                    }
                    this.Party.AddPartyEnemy(Damager);
                    HasCombatRoundProcess = true;
                    if (!UsingEndCombatRound)
                    {
                        SelectCombatRoundAction(false);
                    }
                }
                else
                {
                    this.Party.AddPartyEnemy(Damager);
                    HasCombatRoundProcess = true;
                    if (!UsingEndCombatRound)
                    {
                        SelectCombatRoundAction(false);
                    }
                }
            }
            else
            {
                HasCombatRoundProcess = true;
                if(!UsingEndCombatRound)
                {
                    SelectCombatRoundAction(false);
                }
            }
        }

        /// <summary>
        /// Called when the creature dies.
        /// </summary>
        /// <param name="KillerObjectId">Supplies the killer object id.</param>
        public void OnDeath(uint KillerObjectId)
        {
            if (!IsAIControlled)
                return;

            this.Party.RemovePartyMember(this);
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
            if (Script.GetObjectType(BlockerObjectId) == CLRScriptBase.OBJECT_TYPE_CREATURE)
            {
                if (Script.GetReputation(this.ObjectId, BlockerObjectId) < 11)
                {
                    CreatureObject Blocker = Server.ObjectManager.GetCreatureObject(BlockerObjectId, true);
                    _AttackWrapper(Blocker);
                }
                else
                {
                    if (!TryToAttackRanged())
                        Script.ActionMoveToObject(BlockerObjectId, CLRScriptBase.TRUE, 1.0f);
                }
            }
            else if (Script.GetObjectType(BlockerObjectId) == CLRScriptBase.OBJECT_TYPE_DOOR)
            {
                if (Script.GetUseableFlag(BlockerObjectId) == CLRScriptBase.TRUE)
                {
                    if (Script.GetPlotFlag(BlockerObjectId) == CLRScriptBase.TRUE)
                    {
                        if (Script.GetLocked(BlockerObjectId) == CLRScriptBase.TRUE)
                        {
                            // Well, it's a closed locked plot door. I think we're screwed.
                            return;
                        }
                        else
                            Script.ActionOpenDoor(BlockerObjectId);
                    }
                    else
                    {
                        if (Script.GetLocked(BlockerObjectId) == CLRScriptBase.TRUE)
                            _BashObject(BlockerObjectId);
                        else
                            Script.ActionOpenDoor(BlockerObjectId);
                    }
                }
            }
            else if (Script.GetObjectType(BlockerObjectId) == CLRScriptBase.OBJECT_TYPE_PLACEABLE)
            {
                if (Script.GetPlotFlag(BlockerObjectId) == CLRScriptBase.TRUE)
                {
                    // Well, thatps a plot placeable. We're probably not getting through.
                    return;
                }
                else
                    _BashObject(BlockerObjectId);
            }
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
                if (Party == null) OnSpawn();
                OnPerceptionSeenObject(PerceivedObjectId, NewNode);
            }

            if (Seen)
            {
                Node.Seen = true;
                if (Party == null) OnSpawn();
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
            CreatureObject SeenObject = Server.ObjectManager.GetCreatureObject(PerceivedObjectId, true);

//===== If we just started seeing this person again, we need to process memberships. ====//
            if (InitialDetection)
            {
                int nReputation = Script.GetReputation(this.ObjectId, PerceivedObjectId);
                if (nReputation < 11 && nReputation > -1)
                {
                    if (Party.EnemiesLost.Contains(SeenObject))
                        Party.EnemiesLost.Remove(SeenObject);
                    Party.AddPartyEnemy(SeenObject);
                    HasCombatRoundProcess = true;
                    if (!HasCombatRoundProcess)
                    {
                        HasCombatRoundProcess = true;
                        Script.DelayCommand(3.0f, delegate() { SelectCombatRoundAction(false); });
                    }
                }
                else if (Script.GetFactionEqual(this.ObjectId, PerceivedObjectId) == CLRScriptBase.TRUE)
                {
                    // Might as well try to recover if we've messed up party memberships.
                    if (SeenObject.Party == null && Script.GetIsPC(SeenObject.ObjectId) == CLRScriptBase.FALSE)
                        SeenObject.Party.AddPartyMember(SeenObject);
                }
            }
            else
            {
                if (!HasCombatRoundProcess)
                {
                    HasCombatRoundProcess = true;
                    Script.DelayCommand(3.0f, delegate() { SelectCombatRoundAction(false); });
                }
            }
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
            CreatureObject SeenObject = Server.ObjectManager.GetCreatureObject(PerceivedObjectId, true);

//===== If we just started hearing this person again, we need to process memberships. ====//
            if (InitialDetection)
            {
                int nReputation = Script.GetReputation(this.ObjectId, PerceivedObjectId);

                if (nReputation < 11 && nReputation > -1)
                {
                    if (Party.EnemiesLost.Contains(SeenObject))
                    {
                        Party.EnemiesLost.Remove(SeenObject);
                        Party.AddPartyEnemy(SeenObject);
                        HasCombatRoundProcess = true;
                        if (!UsingEndCombatRound)
                        {
                            Script.DelayCommand(3.0f, delegate() { SelectCombatRoundAction(false); });
                        }
                    }
                }
                else if (Script.GetFactionEqual(this.ObjectId, PerceivedObjectId) == CLRScriptBase.TRUE)
                {
                    // Might as well try to recover if we've messed up party memberships.
                    if (SeenObject.Party == null && Script.GetIsPC(SeenObject.ObjectId) == CLRScriptBase.FALSE)
                        SeenObject.Party.AddPartyMember(SeenObject);
                }
            }
            else
            {
                if (!HasCombatRoundProcess)
                {
                    HasCombatRoundProcess = true;
                    Script.DelayCommand(3.0f, delegate() { SelectCombatRoundAction(false); });
                }
            }
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
            if (Party == null) return; // Creature hasn't initialized as spawned yet; thus, there's nothing
                                       // tracked as already existing.
            CreatureObject SeenObject = Server.ObjectManager.GetCreatureObject(PerceivedObjectId, true);

//===== If we've actually lost this creature, we need to populate missing lists. ====//
            if (LastDetection)
            {
                int nReputation = Script.GetReputation(this.ObjectId, PerceivedObjectId);

                if (nReputation < 11)
                {
                    if (!Party.EnemiesLost.Contains(SeenObject))
                    {
                        if (!Party.CanPartyHear(SeenObject) && !Party.CanPartySee(SeenObject))
                        {
                            Party.RemovePartyEnemy(SeenObject);
                            Party.EnemiesLost.Add(SeenObject);
                        }
                    }
                }
            }          
        }

        /// <summary>
        /// This method speaks a string of the creature calling out to its friends that it
        /// has spotted trouble.
        /// </summary>
        private void CallToFriends()
        {
            string sShout = Script.GetLocalString(ObjectId, "ACR_CREATURE_SURPRISE_SHOUT");
            if (sShout == "")
            {
                if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_MINDLESS)
                {
                    switch (new Random().Next(4))
                    {
                        case 1:
                            sShout = "Nnnnnraaaaaagh!";
                            break;
                        case 2:
                            sShout = "*groans*";
                            break;
                        case 3:
                            sShout = "Mmmmmmrrrrrrn.";
                            break;
                        case 4:
                            sShout = "Chseeeeeeeeeeeeh.";
                            break;
                    }
                }
                else if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_ANIMAL)
                {
                    sShout = "*howls!*";
                }
                else
                {
                    switch (new Random().Next(8))
                    {
                        case 1:
                            sShout = "Bwuh?";
                            break;
                        case 2:
                            sShout = "Bane's black balls!";
                            break;
                        case 3:
                            sShout = "Ack!";
                            break;
                        case 4:
                            sShout = "Galad!";
                            break;
                        case 5:
                            sShout = "Hrast!";
                            break;
                        case 6:
                            sShout = "Naeth!";
                            break;
                        case 7:
                            sShout = "Stlarning hells!";
                            break;
                        case 8:
                            sShout = "*says something that's <i>certainly</i> profanity.*";
                            break;
                    }
                }
            }

            Script.ActionSpeakString(sShout, CLRScriptBase.TALKVOLUME_TALK);
            foreach (CreatureObject ally in Party.PartyMembers)
            {
                if (Script.GetArea(ally.ObjectId) == Script.GetArea(ObjectId))
                {
                    Vector3 allyPosition = Script.GetPosition(ally.ObjectId);
                    Vector3 personalPosition = Script.GetPosition(ObjectId);
                    int X = (int)Math.Pow(allyPosition.x - personalPosition.x, 2);
                    int Y = (int)Math.Pow(allyPosition.y - personalPosition.y, 2);
                    if (X + Y < 40 * 40 && // Within earshot.
                        !ally.HasCombatRoundProcess)
                    {
                        ally.HasCombatRoundProcess = true;
                        Script.DelayCommand(0.5f, delegate() { ally.CallToFriends(); });
                        Script.DelayCommand(3.0f, delegate() { ally.SelectCombatRoundAction(false); });
                    }
                }
            }
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
            CreatureObject SeenObject = Server.ObjectManager.GetCreatureObject(PerceivedObjectId, true);

            //===== If we've actually lost this creature, we need to populate missing lists. ====//
            if (LastDetection)
            {
                int nReputation = Script.GetReputation(this.ObjectId, PerceivedObjectId);

                if (nReputation < 11)
                {
                    if (!Party.EnemiesLost.Contains(SeenObject))
                    {
                        if (!Party.CanPartyHear(SeenObject) && !Party.CanPartySee(SeenObject))
                        {
                            Party.RemovePartyEnemy(SeenObject);
                            Party.EnemiesLost.Add(SeenObject);
                        }
                    }
                }
            }        
        }

        /// <summary>
        /// Called at the end of a combat round, when direction for the next round of combat 
        /// is necessary. This managed the bulk of action in combat.
        /// </summary>
        public void OnEndCombatRound()
        {
            // If this event has fired, we assume that the creature is in combat.
            HasCombatRoundProcess = true;
            UsingEndCombatRound = true;
            SelectCombatRoundAction(false);
        }

        /// <summary>
        /// Called when someone attempts to open a static conversation with the creature.
        /// </summary>
        public void OnConversation()
        {
            Script.BeginConversation("", CLRScriptBase.OBJECT_INVALID, CLRScriptBase.FALSE);
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
            if (HasCombatRoundProcess == true &&
                UsingEndCombatRound == true)
            {
                // We're in a fight, but End Combat Round is firing, so we don't want to do anything here. Overloading
                // with commands is what causes the stutter walk.
                return;
            }
            if (HasCombatRoundProcess == true &&
               UsingEndCombatRound == false)
            {
                // In this state, we've decided that the creature would like to start a fight, but combat rounds
                // haven't started yet. We'll start the fight, and update once the creature gets there.
                SelectCombatRoundAction(false);
                return;
            }
            if (HasCombatRoundProcess == false &&
                UsingEndCombatRound == false)
            {
                // We're not in a fight, but maybe our pals need healing.
                if (CleanUpNeeded)
                {
                    if (!TryToHealAll())
                        CleanUpNeeded = false;
                }

                // We're not in a fight, but maybe our leader is.
                if (this.Party.PartyLeader != null)
                {
                    if (this.Party.PartyLeader.HasCombatRoundProcess)
                    {
                        // And nearby-- we should go find him.
                        if (this.Area == Party.PartyLeader.Area)
                            Script.ActionMoveToObject(Party.PartyLeader.ObjectId, CLRScriptBase.TRUE, 1.0f);

                        // Seems Glorious Leader isn't nearby. Bordering area, maybe?
                        else
                        {
                            if (Area.AreaTransitions.Count > 0)
                            {
                                foreach (AreaObject.AreaTransition Transition in Area.AreaTransitions)
                                {
                                    if (Transition.TargetArea == PartyLeader.Area)
                                    {
                                        Script.ActionInteractObject(Transition.ObjectId);
                                    }
                                }
                            }
                        }
                    }
                }

                // Guess no one we know is in trouble. Carry on.
                else _AmbientBehavior();
            }
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

            CreatureObject attackerObject = ObjectManager.GetCreatureObject(Attacker, true);

            if(!HasCombatRoundProcess)
            {
                Party.AddPartyEnemy(attackerObject);
                SelectCombatRoundAction(false);
            }
        }
        #endregion

        #region === Generic Action Triage ===
        /// <summary>
        /// This function is the primary means by which actions are selected for a given combat round.
        /// </summary>
        public void SelectCombatRoundAction(bool fromAllyCall)
        {
            HasCombatRoundProcess = true;
            if (Script.GetIsObjectValid(ObjectId) == CLRScriptBase.FALSE) return;

            #region Clean Up Before Attempting Action
            List<CreatureObject> deadEnemies = new List<CreatureObject>();
            foreach(CreatureObject enemy in Party.Enemies)
            {
                if(Script.GetCurrentHitPoints(enemy.ObjectId) < 1)
                {
                    if (Script.GetIsPC(enemy.ObjectId) != CLRScriptBase.FALSE)
                    {
                        if (!Party.CleanUpEnemies.Contains(enemy))
                            Party.CleanUpEnemies.Add(enemy);
                    }
                    deadEnemies.Add(enemy);
                }
            }
            foreach(CreatureObject enemy in deadEnemies)
            {
                Party.RemovePartyEnemy(enemy);
            }
            List<CreatureObject> revivedEnemies = new List<CreatureObject>();
            foreach(CreatureObject enemy in Party.CleanUpEnemies)
            {
                if(Script.GetCurrentHitPoints(enemy.ObjectId) > 0)
                {
                    Party.AddPartyEnemy(enemy);
                    revivedEnemies.Add(enemy);
                }
            }
            foreach(CreatureObject enemy in revivedEnemies)
            {
                Party.CleanUpEnemies.Remove(enemy);
            }
            #endregion

            #region Rally Any Party Mates
            if (!fromAllyCall)
            {
                foreach (CreatureObject ally in Party.PartyMembers)
                {
                    if (Script.GetCurrentAction(ally.ObjectId) == CLRScriptBase.ACTION_INVALID)
                    {
                        if (!ally.HasCombatRoundProcess)
                        {
                            ally.HasCombatRoundProcess = true;
                            ally.SelectCombatRoundAction(true);
                        }
                    }
                }
            }
            #endregion

            #region Gather Data on Status
            RefreshNegativeStatuses();
            #endregion

            #region Early return for not being able to act.
            // Can't do anything. Might as well give up early and pray there's help on the way.
            if (!CanAct())
            {
                return;
            }
            #endregion

            #region Specify panic behavior due to injury
            int nWellBeing = HealthPercentage;
            int nMissingHitPoints = MaxHitPoints - CurrentHitPoints;

            // Do we even have anyone to fight?
            if (Party.Enemies.Count == 0 &&
                Party.EnemiesLost.Count == 0)
            {
                HasCombatRoundProcess = false;
                UsingEndCombatRound = false;
                CreatureObject Healer = Party.GetNearest(this, Party.PartyMedics);
                // Everyone gather around the healer; he or she might be using mass heals.
                if (Healer != null)
                    Script.ActionMoveToObject(Healer.ObjectId, CLRScriptBase.TRUE, 1.0f);
                if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_MEDIC &&
                    CurrentAction == CLRScriptBase.ACTION_INVALID)
                {
                    if (TryToHealAll())
                        CleanUpNeeded = true;
                    else
                        CleanUpNeeded = false;
                    return;
                }
                else
                    TryToHeal(this, nMissingHitPoints);
            }

            // Are we in critical condition?
            if (nWellBeing < 10)
            {
                CreatureObject Healer = Party.GetNearest(this, Party.PartyMedics);
                if (Healer == null)
                    Healer = Party.GetNearest(this, Party.PartyBuffs);
                if (Healer != null && Healer != this)
                {
                    if(Script.GetDistanceBetween(Healer.ObjectId, this.ObjectId) > 5.0f)
                        Script.ActionMoveToObject(Healer.ObjectId, CLRScriptBase.TRUE, 1.0f);
                    if(TryToHeal(this, nMissingHitPoints))
                        return;
                }
                else if (Party.PartyLeader != null && Party.PartyLeader != this)
                {
                    Healer = Party.PartyLeader;
                    if (Script.GetDistanceBetween(Healer.ObjectId, this.ObjectId) > 5.0f)
                        Script.ActionMoveToObject(Healer.ObjectId, CLRScriptBase.TRUE, 1.0f);
                    if(TryToHeal(this, nMissingHitPoints))
                        return;
                }
                else
                {
                    if (TryToHeal(this, nMissingHitPoints))
                        return;
                }

                if (TryToHeal(this, nMissingHitPoints)) return;
            }

            #region Early Returns: Mindless
            // We're mindless, and thus too stupid to do anything special. Hit the nearest bad guy.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_MINDLESS)
            {
                CreatureObject AttackTarget = Party.GetNearest(this, Party.Enemies);
                if (AttackTarget == null)
                {
                    uint newEnemy = Script.GetNearestCreature(CLRScriptBase.CREATURE_TYPE_REPUTATION, CLRScriptBase.REPUTATION_TYPE_ENEMY, this.ObjectId, 1, -1, -1, -1, -1);
                    if(Script.GetIsObjectValid(newEnemy) != CLRScriptBase.FALSE &&
                       Script.GetObjectSeen(newEnemy, this.ObjectId) != CLRScriptBase.FALSE &&
                       Script.GetObjectHeard(newEnemy, this.ObjectId) != CLRScriptBase.FALSE)
                    {
                        AttackTarget = Server.ObjectManager.GetCreatureObject(newEnemy, true);
                        Party.AddPartyEnemy(AttackTarget);
                    }
                }
                if (AttackTarget == null) return;
                _AttackWrapper(AttackTarget);
                return;
            }
            #endregion

            // Bad enough to self heal?
            else if (nWellBeing < 50)
            {
                if (TryToHeal(this, nMissingHitPoints))
                    return;
            }
            #endregion

            #region AIType-Specific Behaviors
            #region Animals
            // Time to break off into the particular types
            // Animals are simple creatures; they want to protect themselves and their masters.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_ANIMAL)
            {
                // Animals are too dumb to do anything other than use their direct attacks on foes.
                CreatureObject AttackTarget = Party.GetNearest(this, Party.Enemies);
                if (AttackTarget == null)
                {
                    uint newEnemy = Script.GetNearestCreature(CLRScriptBase.CREATURE_TYPE_REPUTATION, CLRScriptBase.REPUTATION_TYPE_ENEMY, this.ObjectId, 1, -1, -1, -1, -1);
                    if (Script.GetIsObjectValid(newEnemy) != CLRScriptBase.FALSE &&
                       Script.GetObjectSeen(newEnemy, this.ObjectId) != CLRScriptBase.FALSE &&
                       Script.GetObjectHeard(newEnemy, this.ObjectId) != CLRScriptBase.FALSE)
                    {
                        AttackTarget = Server.ObjectManager.GetCreatureObject(newEnemy, true);
                        Party.AddPartyEnemy(AttackTarget);
                    }
                }
                if (AttackTarget == null) return;
                _AttackWrapper(AttackTarget);
                return;
            }
            #endregion

            #region Archers
            // Archers have the advantage of reach and accuracy with acceptable damage. They strike weak and soft targets.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_ARCHER)
            {
                if (TryToAttackRanged())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToAttackMelee(true, false))
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Buffs
            // Buffs try to boost the capabilities of their allies
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_BUFFS)
            {
                if (TryToBuffAll())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToAttackMelee())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }                
                if (Party.PartyControls.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyControls).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyNukes.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyNukes).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Controls
            // Controls try to debuff enemies and impede movement on the field.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_CONTROL)
            {
                if (TryToDebuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToAttackMelee())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyNukes.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyNukes).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Cowards
            // Cowards avoid fights and look for help.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_COWARD)
            {
                CreatureObject medic = Party.GetNearest(this, Party.PartyMedics);
                if(medic == null)
                {
                    medic = Party.GetNearest(this, Party.PartyMembers);
                }
                if(medic != null)
                {
                    Script.AssignCommand(ObjectId, delegate { Script.ActionMoveToObject(medic.ObjectId, CLRScriptBase.TRUE, 1.0f); });
                }
                else if(Party.Enemies.Count > 0)
                {
                    Script.AssignCommand(ObjectId, delegate { Script.ActionMoveAwayFromObject(Party.Enemies[0].ObjectId, CLRScriptBase.TRUE, 50.0f); });
                }
                return;
            }
            #endregion

            #region Flanks
            // Flanks try to backstab people, and counter attack people who come after squishies.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_FLANK)
            {
                if (TryToAttackMelee(true, false))
                    return; 
                if (TryToAttackRanged())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Medics
            // Medics try to heal their friends.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_MEDIC)
            {
                if (TryToHealAll())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToAttackMelee())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if(Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if(Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if(Party.PartyControls.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyControls).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyNukes.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyNukes).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMedics.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if(Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Nukes
            // Nukes try to explode hardened targets.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_NUKE)
            {
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToCallForHelp())
                    return;                
                if (TryToHealAll())
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToAttackMelee())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyControls.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyControls).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Shocks
            // Shocks try to break through the lines and take down squishies.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_SHOCK)
            {
                if (TryToAttackMelee(true, false))
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion

            #region Skirmishers
            // Skirmishers try to resist shocks, flanks, and other skirmishers.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_SKIRMISH)
            {
                if (TryToAttackRanged())
                    return;                
                if (TryToAttackMelee(true, false))
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return; 
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return; 
                }
                if (Party.PartyMembers.Count > 1)
                { 
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f); 
                    return; 
                }
                return;
            }
            #endregion

            #region Tanks
            // Tanks try to hold ground and contain dangerous foes.
            if (TacticsType == AIParty.AIType.BEHAVIOR_TYPE_TANK)
            {
                if (TryToAttackMelee(false, true))
                    return;
                if (TryToAttackRanged())
                    return;
                if (TryToDebuffAll())
                    return;
                if (TryToDebuffCareful())
                    return;
                if (TryToBuffAll())
                    return;
                if (TryToCallForHelp())
                    return;
                if (TryToHealAll())
                    return;
                if (TryToCleanUp())
                    return;

                // We don't have anything productive to do. Figure out who we'd like to snuggle up against.
                if (Party.PartyMedics.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMedics).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return; 
                }
                if (Party.PartyBuffs.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyBuffs).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return; 
                }
                if (Party.PartyArchers.Count > 0)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyArchers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                if (Party.PartyMembers.Count > 1)
                {
                    Script.ActionMoveToObject(Party.GetNearest(this, Party.PartyMembers).ObjectId, CLRScriptBase.TRUE, 3.0f);
                    return;
                }
                return;
            }
            #endregion
            #endregion
            // Making it this far is some kind of error case. Try to salvage something.

            return;
        }

        /// <summary>
        /// This orders this creature to perform whatever it's supposed to perform when not engaged in something
        /// else.
        /// </summary>
        private void _AmbientBehavior()
        {

        }
        #endregion

        #region === Crowd Control Methods ===
        bool TryToCallForHelp()
        {
            // Summons are generally short-duration spells which are better used like traps, sprung
            // on hapless opponents.
            if (GetAlliesInMelee() > 0)
            {
                NWTalent Summon = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, 20, ObjectId, 0);
                if (Script.GetIsTalentValid(Summon) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentAtLocation(Summon, Script.GetLocation(ObjectId));
                    return true;
                }
            }
            return false;
        }
        #endregion

        #region === Healing Methods ===
        /// <summary>
        /// This will look for an action that will improve the condition of the party.
        /// </summary>
        /// <returns>True if an appropriate action is found.</returns>
        public bool TryToHealAll()
        {
            // First we look for friends who are on death's door.
            foreach (CreatureObject Target in Party.PartyMembers)
            {
                if (Target.HealthPercentage < 10)
                {
                    TryToHeal(Target, Target.MaxHitPoints - Target.CurrentHitPoints);
                    return true;
                }
            }

            // Then we look for friends who are very-badly hurt, or have a crippling status affliction, and treat with equal priority.
            foreach (CreatureObject Target in Party.PartyMembers)
            {
                if (Target.HealthPercentage < 30)
                {
                    TryToHeal(Target, Target.MaxHitPoints - Target.CurrentHitPoints);
                    return true;
                }
                else if (TryRemoveUrgentStatusAfflictions(Target))
                    return true;
            }
            
            // Then we look for people who have status afflictions generally-- or are just hurt pretty bad.
            foreach (CreatureObject Target in Party.PartyMembers)
            {
                if (Target.HealthPercentage < 60)
                {
                    TryToHeal(Target, Target.MaxHitPoints - Target.CurrentHitPoints);
                    return true;
                }
                else if (TryRemoveUrgentStatusAfflictions(Target))
                    return true;
            }

            // Then we look for people who are a little hurt.
            foreach (CreatureObject Target in Party.PartyMembers)
            {
                if (Target.HealthPercentage < 90)
                {
                    TryToHeal(Target, Target.MaxHitPoints - Target.CurrentHitPoints);
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// This will look for the most-urgent disabling status afflictions on HealTarget and attempt to cure them.
        /// </summary>
        /// <param name="HealTarget">The target to be healed</param>
        /// <returns>true if an appropriate action is assigned.</returns>
        public bool TryRemoveUrgentStatusAfflictions(CreatureObject HealTarget)
        {
            if (HealTarget.Confused || HealTarget.Insane || HealTarget.Frightened || HealTarget.Paralyzed || HealTarget.Blinded)
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_HEAL, ObjectId) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_HEAL), HealTarget.ObjectId);
                    return true;
                }
                if (HealTarget.Blinded || HealTarget.Deaf)
                {
                    if (Script.GetHasSpell(CLRScriptBase.SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, ObjectId) == CLRScriptBase.TRUE)
                    {
                        Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_REMOVE_BLINDNESS_AND_DEAFNESS), HealTarget.ObjectId);
                        return true;
                    }
                }
            }
            if (HealTarget.Petrified)
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_STONE_TO_FLESH, ObjectId) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_STONE_TO_FLESH), HealTarget.ObjectId);
                    return true;
                }
            }
            if (HealTarget.Wounded)
            {
                int nMissingHitPoints = HealTarget.MaxHitPoints - HealTarget.CurrentHitPoints;
                if (nMissingHitPoints == 0) nMissingHitPoints = 1;
                if (TryToHeal(HealTarget, nMissingHitPoints))
                    return true;
            }
            return false;
        }
        
        /// <summary>
        /// This will look for status afflictions that need healing.
        /// </summary>
        /// <param name="HealTarget">The target to be healed</param>
        /// <returns>True if an appropriate action is found and assigned</returns>
        public bool TryRemoveStatusAfflictions(CreatureObject HealTarget)
        {
            if (HealTarget.Confused || HealTarget.Insane || HealTarget.Frightened || HealTarget.Paralyzed || HealTarget.AbilityDamaged || HealTarget.Diseased ||
                HealTarget.Blinded || HealTarget.Deaf || HealTarget.Poisoned)
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_HEAL, ObjectId) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_HEAL), HealTarget.ObjectId);
                    return true;
                }
                else
                {
                    if (HealTarget.AbilityDamaged)
                    {
                        if (Script.GetHasSpell(CLRScriptBase.SPELL_LESSER_RESTORATION, ObjectId) == CLRScriptBase.TRUE &&
                            Script.GetHasSpell(CLRScriptBase.SPELL_RESTORATION, ObjectId) == CLRScriptBase.FALSE &&
                            Script.GetHasSpell(CLRScriptBase.SPELL_GREATER_RESTORATION, ObjectId) == CLRScriptBase.FALSE)
                        {
                            Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_LESSER_RESTORATION), HealTarget.ObjectId);
                            return true;
                        }
                    }
                    if (HealTarget.Diseased)
                    {
                        if (Script.GetHasSpell(CLRScriptBase.SPELL_LESSER_RESTORATION, ObjectId) == CLRScriptBase.TRUE)
                        {
                            Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_REMOVE_DISEASE), HealTarget.ObjectId);
                            return true;
                        }
                    }
                    if (HealTarget.Blinded || HealTarget.Deaf)
                    {
                        if (Script.GetHasSpell(CLRScriptBase.SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, ObjectId) == CLRScriptBase.TRUE)
                        {
                            Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_REMOVE_BLINDNESS_AND_DEAFNESS), HealTarget.ObjectId);
                            return true;
                        }
                    }
                    if (HealTarget.Poisoned)
                    {
                        if (Script.GetHasSpell(CLRScriptBase.SPELL_NEUTRALIZE_POISON, ObjectId) == CLRScriptBase.TRUE)
                        {
                            Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_NEUTRALIZE_POISON), HealTarget.ObjectId);
                            return true;
                        }
                    }
                }
            }
            if (HealTarget.Petrified)
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_STONE_TO_FLESH, ObjectId) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_STONE_TO_FLESH), HealTarget.ObjectId);
                    return true;
                }
            }
            if ((HealTarget.AbilityDrained || HealTarget.LevelDrain) ||
                (HealTarget.AbilityDamaged && Script.GetHasSpell(CLRScriptBase.SPELL_LESSER_RESTORATION, ObjectId) == CLRScriptBase.FALSE))
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_RESTORATION, ObjectId) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_RESTORATION), HealTarget.ObjectId);
                    return true;
                }
                else if (Script.GetHasSpell(CLRScriptBase.SPELL_GREATER_RESTORATION, ObjectId) == CLRScriptBase.FALSE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_GREATER_RESTORATION), HealTarget.ObjectId);
                    return true;
                }
            }
            if (HealTarget.Cursed)
            {
                if (Script.GetHasSpell(CLRScriptBase.SPELL_REMOVE_CURSE, ObjectId) == CLRScriptBase.FALSE)
                {
                    Script.ActionUseTalentOnObject(Script.TalentSpell(CLRScriptBase.SPELL_REMOVE_CURSE), HealTarget.ObjectId);
                    return true;
                }
            }
            if (HealTarget.Wounded)
            {
                int nMissingHitPoints = HealTarget.MaxHitPoints - HealTarget.CurrentHitPoints;
                if (nMissingHitPoints == 0) nMissingHitPoints = 1;
                if (TryToHeal(HealTarget, nMissingHitPoints))
                    return true;
            }
            return false;
        }

        /// <summary>
        /// This will search for an ability that will directly restore about HitPoints of hit points and use it on HealTarget
        /// </summary>
        /// <param name="HealTarget">The one to receive healing.</param>
        /// <param name="HitPoints">The amount to heal.</param>
        /// <returns>True if an ability is found.</returns>
        public bool TryToHeal(CreatureObject HealTarget, int HitPoints)
        {
            int SpellId = -1;
            NWTalent Healing = null;
            if (HitPoints > 50 && Script.GetHasSpell(CLRScriptBase.SPELL_HEAL, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_HEAL;
            else if(HitPoints > 50 && Script.GetHasSpell(CLRScriptBase.SPELL_MASS_HEAL, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_MASS_HEAL;
            else if (HitPoints > 21 && Script.GetHasSpell(CLRScriptBase.SPELL_CURE_CRITICAL_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_CRITICAL_WOUNDS;
            else if (HitPoints > 21 && Script.GetHasSpell(CLRScriptBase.SPELL_MASS_CURE_CRITICAL_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_MASS_CURE_CRITICAL_WOUNDS;
            else if (HitPoints > 16 && Script.GetHasSpell(CLRScriptBase.SPELL_CURE_SERIOUS_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_SERIOUS_WOUNDS;
            else if (HitPoints > 16 && Script.GetHasSpell(CLRScriptBase.SPELL_MASS_CURE_SERIOUS_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_MASS_CURE_SERIOUS_WOUNDS;
            else if (HitPoints > 10 && Script.GetHasSpell(CLRScriptBase.SPELL_CURE_MODERATE_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_MODERATE_WOUNDS;
            else if (HitPoints > 10 && Script.GetHasSpell(CLRScriptBase.SPELL_MASS_CURE_MODERATE_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_MASS_CURE_MODERATE_WOUNDS;
            else if (Script.GetHasSpell(CLRScriptBase.SPELL_CURE_LIGHT_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_LIGHT_WOUNDS;
            else if (Script.GetHasSpell(CLRScriptBase.SPELL_MASS_CURE_LIGHT_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_MASS_CURE_LIGHT_WOUNDS;
            else if (Script.GetHasSpell(CLRScriptBase.SPELL_CURE_MODERATE_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_MODERATE_WOUNDS;
            else if (Script.GetHasSpell(CLRScriptBase.SPELL_CURE_SERIOUS_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_SERIOUS_WOUNDS;
            else if (Script.GetHasSpell(CLRScriptBase.SPELL_CURE_CRITICAL_WOUNDS, ObjectId) == CLRScriptBase.TRUE) SpellId = CLRScriptBase.SPELL_CURE_CRITICAL_WOUNDS;

            if (SpellId != -1)
            {
                Healing = Script.TalentSpell(SpellId);
                Script.ActionUseTalentOnObject(Healing, HealTarget.ObjectId);
                return true;
            }
            else
            {
                if (HealTarget == this)
                {
                    Healing = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 20, ObjectId, 0);
                    if (Script.GetIsTalentValid(Healing) == CLRScriptBase.TRUE)
                    {
                        Script.ActionUseTalentOnObject(Healing, HealTarget.ObjectId);
                        return true;
                    }
                }
            }
            return false;
        }
        #endregion

        #region === Buffing Methods ===
        /// <summary>
        /// This will search for an ability to buff an ally, or oneself, which is not already applied to its target.
        /// </summary>
        /// <returns>true if an ability is found.</returns>
        public bool TryToBuffAll()
        {
            NWTalent Buff;
            // We look for party buffs first if we have a party worth noting.
            if (this.Party.PartyMembers.Count() > 2)
            {
                Buff = _GetKnownPartyBuff();
                if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                    Buff = _GetKnownSingleBuff();
            }
            // Otherwise we look for single-target buffs.
            else
            {
                Buff = _GetKnownSingleBuff();
                if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                    Buff = _GetKnownPartyBuff();
            }
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.TRUE)
            {
                uint TargetId = _FindTargetForBuff(Buff);
                if (TargetId != OBJECT_INVALID)
                {
                    Script.ActionUseTalentOnObject(Buff, TargetId);
                    return true;
                }
            }

            // And if we haven't found anything, try buffing ourselves.
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                Buff = _GetKnownSelfBuff();
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.TRUE)
            {
                int SpellId = Script.GetIdFromTalent(Buff);
                if (Script.GetHasSpellEffect(SpellId, ObjectId) == CLRScriptBase.FALSE)
                {
                    Script.ActionUseTalentOnObject(Buff, ObjectId);
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// This seeks a known talent which can provide benefit to the party.
        /// </summary>
        /// <returns>The talent</returns>
        private NWTalent _GetKnownPartyBuff()
        {
            NWTalent Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT, 20, ObjectId, 0);
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT, 20, ObjectId, 0);
            return Buff;
        }

        /// <summary>
        /// This seeks a known talent which can provide benefit to one ally.
        /// </summary>
        /// <returns>The talent</returns>
        private NWTalent _GetKnownSingleBuff()
        {
            NWTalent Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE, 20, ObjectId, 0);
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE, 20, ObjectId, 0);
            return Buff;
        }

        /// <summary>
        /// This seeks a known talent which can provide benefit to oneself.
        /// </summary>
        /// <returns>The talent</returns>
        private NWTalent _GetKnownSelfBuff()
        {
            NWTalent Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF, 20, ObjectId, 0);
            if (Script.GetIsTalentValid(Buff) == CLRScriptBase.FALSE)
                Buff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF, 20, ObjectId, 0);
            return Buff;
        }

        /// <summary>
        /// This seeks a target for a buff talent, prioritizing on high-risk allies, but only selecting one who doesn't already have the effect.
        /// </summary>
        /// <param name="Buff">The talent to check</param>
        /// <returns>the object ID of a valid target, or OBJECT_INVALID on error</returns>
        private uint _FindTargetForBuff(NWTalent Buff)
        {
            int SpellId = Script.GetIdFromTalent(Buff);
            foreach (CreatureObject PartyMember in Party.PartyTanks)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            foreach (CreatureObject PartyMember in Party.PartyShocks)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            foreach (CreatureObject PartyMember in Party.PartySkrimishers)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            foreach (CreatureObject PartyMember in Party.PartyFlanks)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            foreach (CreatureObject PartyMember in Party.PartyAnimals)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            foreach (CreatureObject PartyMember in Party.PartyMindless)
            {
                if (Script.GetHasSpellEffect(SpellId, PartyMember.ObjectId) == CLRScriptBase.FALSE)
                    return PartyMember.ObjectId;
            }
            if (Script.GetHasSpellEffect(SpellId, ObjectId) == CLRScriptBase.FALSE)
                return ObjectId;            
            return OBJECT_INVALID;
        }
        #endregion

        #region === Debuffing Methods ===
        /// <summary>
        /// This attempts to find a valid place to put down large field-altering effects, and destructive (but dangerous
        /// and indiscriminate) spells. It will attempt to avoid friendly fire, but might hit allies who just happen to
        /// be within the area of effect anyway.
        /// </summary>
        /// <returns>true if successful</returns>
        public bool TryToDebuffAll()
        {
            NWTalent Debuff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_DISPEL, 20, this.ObjectId, 0);
            uint Target = OBJECT_INVALID;
            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                Target = _FindTargetForDispel();
                if (Target != OBJECT_INVALID)
                {
                    Script.ActionUseTalentOnObject(Debuff, Target);
                    return true;
                }
            }
            Debuff = _GetKnownFieldAlteringEffect();
            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                Target = _FindTargetForDebuff(Debuff);
                if (Target != OBJECT_INVALID)
                {
                    Script.ActionUseTalentOnObject(Debuff, Target);
                    return true;
                }
            }
            Debuff = _GetKnownUnfriendlyDebuff();
            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                Target = _FindTargetForDebuff(Debuff);
                if (Target != OBJECT_INVALID)
                {
                    Script.ActionUseTalentOnObject(Debuff, Target);
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// This attempts to find a place to send an attack which either only harms enemies or which only harms single targets.
        /// </summary>
        /// <returns>true if such an ability is found</returns>
        public bool TryToDebuffCareful()
        {
            NWTalent Debuff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, 20, ObjectId, 0);
            CreatureObject Target = Party.GetNearest(this, Party.Enemies);
            
            // If there is no nearest enemy, might as well abort.
            if (Target == null)
                return false;

            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                Script.ActionUseTalentOnObject(Debuff, Target.ObjectId);
                return true;
            }

            Debuff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_HARMFUL_RANGED, 20, ObjectId, 0);
            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                uint newTarget = _FindTargetForDispel();
                if (Script.GetIsObjectValid(newTarget) == CLRScriptBase.TRUE)
                {
                    Script.ActionUseTalentOnObject(Debuff, newTarget);
                    return true;
                }
                else
                {
                    Script.ActionUseTalentOnObject(Debuff, Target.ObjectId);
                    return true;
                }
            }

            Debuff = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_HARMFUL_TOUCH, 20, ObjectId, 0);
            if (Script.GetIsTalentValid(Debuff) == CLRScriptBase.TRUE)
            {
                Script.ActionUseTalentOnObject(Debuff, Target.ObjectId);
                return true;
            }
            return false;
        }

        private NWTalent _GetKnownFieldAlteringEffect()
        {
            NWTalent Talent = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, 20, ObjectId, 0);
            return Talent;
        }

        private NWTalent _GetKnownUnfriendlyDebuff()
        {
            NWTalent Talent = Script.GetCreatureTalentBest(CLRScriptBase.TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, 20, ObjectId, 0);
            return Talent;
        }

        /// <summary>
        /// This seeks a target for for large terrain-altering or wide effect spells meant to sway battles. It prioritizes distant and high-danger targets.
        /// </summary>
        /// <param name="Debuff">Provides the NWTalent for the buff to check against.</param>
        /// <returns>the object ID of the target, or OBJECT_INVALID on error.</returns>
        private uint _FindTargetForDebuff(NWTalent Debuff)
        {
            int SpellId = Script.GetIdFromTalent(Debuff);
            CreatureObject Target = Party.GetFarthest(this, Party.Enemies);
            if (Target != null && Script.GetHasSpellEffect(SpellId, Target.ObjectId) == CLRScriptBase.FALSE)
            {
                foreach (uint Collateral in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM, Script.GetLocation(Target.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                {
                    if (Script.GetIsReactionTypeHostile(Target.ObjectId, ObjectId) != CLRScriptBase.TRUE)
                        Target = null;
                }
                if(Target != null)
                    return Target.ObjectId;
            }
            Target = Party.GetFarthest(this, Party.EnemySpellcasters);
            if (Target != null && Script.GetHasSpellEffect(SpellId, Target.ObjectId) == CLRScriptBase.FALSE)
            {
                foreach (uint Collateral in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM, Script.GetLocation(Target.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                {
                    if (Script.GetIsReactionTypeHostile(Target.ObjectId, ObjectId) != CLRScriptBase.TRUE)
                        Target = null;
                }
                if (Target != null)
                    return Target.ObjectId;
            }
            Target = Party.GetFarthest(this, Party.EnemyHealers);
            if (Target != null && Script.GetHasSpellEffect(SpellId, Target.ObjectId) == CLRScriptBase.FALSE)
            {
                foreach (uint Collateral in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM, Script.GetLocation(Target.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                {
                    if (Script.GetIsReactionTypeHostile(Target.ObjectId, ObjectId) != CLRScriptBase.TRUE)
                        Target = null;
                }
                if (Target != null)
                    return Target.ObjectId;
            }
            Target = Party.GetFarthest(this, Party.EnemySoftTargets);
            if (Target != null && Script.GetHasSpellEffect(SpellId, Target.ObjectId) == CLRScriptBase.FALSE)
            {
                foreach (uint Collateral in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM, Script.GetLocation(Target.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                {
                    if (Script.GetIsReactionTypeHostile(Target.ObjectId, ObjectId) != CLRScriptBase.TRUE)
                        Target = null;
                }
                if (Target != null)
                    return Target.ObjectId;
            }
            foreach(CreatureObject SpellTarget in Party.EnemyHardTargets)
            {
                if (Script.GetHasSpellEffect(SpellId, SpellTarget.ObjectId) == CLRScriptBase.FALSE)
                {
                    foreach (uint Collateral in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, CLRScriptBase.RADIUS_SIZE_MEDIUM, Script.GetLocation(Target.ObjectId), false, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                    {
                        if (Script.GetIsReactionTypeHostile(Target.ObjectId, ObjectId) != CLRScriptBase.TRUE)
                            Target = null;
                    }
                    if (Target != null)
                        return Target.ObjectId;
                }
            }
            return OBJECT_INVALID;
        }

        /// <summary>
        /// This seeks an enemy target with the most visual effects present, which would imply an in-character motivation to dispel.
        /// </summary>
        /// <returns>the object ID of the target.</returns>
        private uint _FindTargetForDispel()
        {
            uint RetTarget = OBJECT_INVALID;
            uint CurrentMaxVFX = 0;
            foreach (CreatureObject Target in Party.Enemies)
            {
                uint TargetEffectCount = 0;                
                foreach (NWEffect Effect in Script.GetEffects(Target.ObjectId))
                {
                    if (Script.GetEffectType(Effect) == CLRScriptBase.EFFECT_TYPE_VISUALEFFECT)
                        TargetEffectCount++;
                }
                if (TargetEffectCount > CurrentMaxVFX)
                {
                    TargetEffectCount = CurrentMaxVFX;
                    RetTarget = Target.ObjectId;
                }
            }
            return RetTarget;
        }
        #endregion

        #region === Physical Attack Methods ===
        /// <summary>
        /// This serves as a wrapper about calls to ActionAttack, to apply things like the uncanny
        /// dodge modifiers
        /// </summary>
        /// <returns>true if the attack is successfully staged</returns>
        public bool _AttackWrapper(CreatureObject AttackTarget)
        {
            if (Script.GetIsObjectValid(AttackTarget.ObjectId) == CLRScriptBase.TRUE)
            {
                if (Script.GetHasFeat(2179, ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) // Shadow touch attack
                {
                    Script.ActionUseTalentOnObject(Script.TalentFeat(2179), AttackTarget.ObjectId);
                    return true;
                }
                else
                {
                    if (Script.GetCurrentAction(ObjectId) == CLRScriptBase.ACTION_ATTACKOBJECT &&
                       Script.GetAttackTarget(ObjectId) == AttackTarget.ObjectId)
                    {
                        return true;
                    }
                    else
                    {
                        Script.ClearAllActions(CLRScriptBase.FALSE);
                        Script.ActionAttack(AttackTarget.ObjectId, CLRScriptBase.FALSE);
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// This orders Creature to bash Target until it is destroyed.
        /// </summary>
        /// <param name="Target">The target to be bashed</param>
        private void _BashObject(uint Target)
        {
            OverrideTarget = Target;
            Script.ActionAttack(Target, CLRScriptBase.FALSE);
        }

        /// <summary>
        /// This function causes Creature to switch to change to ranged weapons temporarily. It should be used when
        /// ranged combat is only a good idea for a moment, because of battlefield conditions.
        /// </summary>
        /// <param name="Reason">The object we should wait to move or go away before changing back</param>
        /// <param name="WaitForDeath">If set to false, the creature will wait until Reason is destroyed before switching back to melee</param>
        private void _TemporaryRangedCombat(uint Reason, bool WaitForDeath = false)
        {
            TryToAttackRanged();
        }

        /// <summary>
        /// This function causes Creature to switch to ranged weapons, if the weapon wielded isn't already ranged, and attack
        /// from a distance.
        /// </summary>
        /// <returns>true if a target and a ranged weapon are found, and an attack is ordered.</returns>
        public bool TryToAttackRanged()
        {
            CreatureObject killObject = null;
            Vector3 myLoc = Script.GetPosition(this.ObjectId);
            foreach (CreatureObject enemy in Party.EnemySoftTargets)
            {
                if (Script.LineOfSightObject(this.ObjectId, enemy.ObjectId) == CLRScriptBase.TRUE)
                    killObject = enemy;
                Vector3 loc = Script.GetPosition(enemy.ObjectId);
                float diff = ((loc.x - myLoc.x) * (loc.x - myLoc.x)) + ((loc.y - myLoc.y) * (loc.y - myLoc.y));
                if(diff < 25.0f)
                {
                    // We're too close to this enemy to rely on ranged combat.
                    return false;
                }
            }
            if (killObject == null)
            {
                foreach (CreatureObject enemy in Party.Enemies)
                {
                    if (Script.LineOfSightObject(this.ObjectId, enemy.ObjectId) == CLRScriptBase.TRUE)
                        killObject = enemy;
                    Vector3 loc = Script.GetPosition(enemy.ObjectId);
                    float diff = ((loc.x - myLoc.x) * (loc.x - myLoc.x)) + ((loc.y - myLoc.y) * (loc.y - myLoc.y));
                    if (diff < 25.0f)
                    {
                        // We're too close to this enemy to rely on ranged combat.
                        return false;
                    }
                }
            }
            
            // We don't have any enemies who we can shoot without moving.
            if (killObject == null)
                return false;
            else
            {
                _EquipWeapon(false);
                
                // Looks like we found something to kill and something to kill it with.
                _AttackWrapper(killObject);
                return true;
            }
        }

        public bool TryToAttackMelee(bool PrioritizeSoftTargets = false, bool DistributeAttacks = false)
        {
            CreatureObject finalTarget = null;
            if (PrioritizeSoftTargets)
            {
                foreach (CreatureObject enemy in Party.EnemySoftTargets)
                {
                    if(Script.GetAttackTarget(enemy.ObjectId) != this.ObjectId && Script.GetDistanceBetween(enemy.ObjectId, this.ObjectId) < 5.0f)
                    {
                        finalTarget = enemy;
                        break;
                    }
                }
                if (finalTarget == null)
                {
                    foreach(CreatureObject enemy in Party.Enemies)
                    {
                        if (Script.GetAttackTarget(enemy.ObjectId) != this.ObjectId && Script.GetDistanceBetween(enemy.ObjectId, this.ObjectId) < 5.0f)
                        {
                            finalTarget = enemy;
                            break;
                        }
                    }
                }
            }
            if (DistributeAttacks && finalTarget == null)
            {
                int maxAttacking = 999;
                foreach (CreatureObject enemy in Party.EnemySoftTargets)
                {
                    int numberAttacking = 0;
                    foreach (CreatureObject ally in Party.PartyMembers)
                    {
                        if (Script.GetAttackTarget(ally.ObjectId) == enemy.ObjectId)
                        {
                            numberAttacking++;
                        }
                    }
                    if (numberAttacking == 0)
                    {
                        finalTarget = enemy;
                        break;
                    }
                    else if (numberAttacking < maxAttacking)
                    {
                        maxAttacking = numberAttacking;
                        finalTarget = enemy;
                    }
                }
            }
            if (finalTarget == null &&
                Script.GetIsObjectValid(Script.GetAttackTarget(this.ObjectId)) == CLRScriptBase.TRUE)
                    finalTarget = Server.ObjectManager.GetCreatureObject(Script.GetAttackTarget(this.ObjectId), true);
            if(finalTarget == null)
                finalTarget = Party.GetNearest(this, Party.Enemies);
            if(finalTarget == null)
                return false;

            _EquipWeapon();
            _AttackWrapper(finalTarget);
            return true;
        }

        private bool TryToCleanUp()
        {
            foreach(CreatureObject enemy in Party.CleanUpEnemies)
            {
                _EquipWeapon(true);
                _AttackWrapper(enemy);
                return true;
            }
            return false;
        }

        private void _EquipWeapon(bool meleeWeapon = true)
        {
            uint item = Script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_RIGHTHAND, ObjectId);
            if ((Script.GetWeaponRanged(item) == CLRScriptBase.FALSE && !meleeWeapon) ||
                (Script.GetWeaponRanged(item) == CLRScriptBase.TRUE && meleeWeapon))
            {
                uint weapon = Script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_RIGHTHAND, this.ObjectId);
                int weaponValue = 0;
                if(Script.GetIsObjectValid(weapon) == CLRScriptBase.TRUE) weaponValue = Script.GetGoldPieceValue(weapon);

                uint shield = Script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_LEFTHAND, this.ObjectId);
                int shieldValue = 0;
                if(Script.GetIsObjectValid(shield) == CLRScriptBase.TRUE) shieldValue = Script.GetGoldPieceValue(shield);

                foreach (uint bagItem in Script.GetItemsInInventory(ObjectId))
                {
                    if(meleeWeapon && _GetIsMeleeWeapon(Script.GetBaseItemType(bagItem)))
                    {
                        if(_GetIsProficient(Script, bagItem) &&
                            weaponValue < Script.GetGoldPieceValue(bagItem))
                        {
                            weapon = bagItem;
                            weaponValue = Script.GetGoldPieceValue(bagItem);
                        }
                        if(Script.GetBaseItemType(bagItem) == CLRScriptBase.BASE_ITEM_SMALLSHIELD ||
                            Script.GetBaseItemType(bagItem) == CLRScriptBase.BASE_ITEM_LARGESHIELD ||
                            Script.GetBaseItemType(bagItem) == CLRScriptBase.BASE_ITEM_TOWERSHIELD)
                        {
                            if(shieldValue < Script.GetGoldPieceValue(bagItem))
                            {
                                shield = bagItem;
                                shieldValue = Script.GetGoldPieceValue(bagItem);
                            }
                        }
                    }
                    if (!meleeWeapon && Script.GetWeaponRanged(bagItem) == CLRScriptBase.TRUE)
                    {
                        if (_GetIsProficient(Script, bagItem) &&
                            weaponValue < Script.GetGoldPieceValue(bagItem))
                        {
                            weapon = bagItem;
                            weaponValue = Script.GetGoldPieceValue(bagItem);
                        }
                    }
                }
                if (Script.GetIsObjectValid(weapon) == CLRScriptBase.TRUE)
                {
                    Script.ActionEquipItem(weapon, CLRScriptBase.INVENTORY_SLOT_RIGHTHAND);
                    
                    if(_GetIsMeleeWeapon(Script.GetBaseItemType(weapon)))
                    {
                        int weaponSize = ALFA.Shared.Modules.InfoStore.BaseItems[Script.GetBaseItemType(weapon)].WeaponSize;
                        int creatureSize = Script.GetCreatureSize(this.ObjectId);
                        if(creatureSize > weaponSize)
                        {
                            if(Script.GetHasFeat(CLRScriptBase.FEAT_SHIELD_PROFICIENCY, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE)
                            {
                                Script.ActionEquipItem(shield, CLRScriptBase.INVENTORY_SLOT_LEFTHAND);
                            }
                        }
                    }
                }
            }
        }

        private bool _GetIsProficient(CLRScriptBase script, uint item)
        {
            int baseItem = script.GetBaseItemType(item);
            if (baseItem == CLRScriptBase.BASE_ITEM_INVALID) return false; // this doesn't even look like a real item.
            ALFA.Shared.BaseItem itemType = ALFA.Shared.Modules.InfoStore.BaseItems[baseItem];
            if (itemType.ReqFeat0 != 0 && script.GetHasFeat(itemType.ReqFeat0, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            if (itemType.ReqFeat1 != 0 && script.GetHasFeat(itemType.ReqFeat1, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            if (itemType.ReqFeat2 != 0 && script.GetHasFeat(itemType.ReqFeat2, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            if (itemType.ReqFeat3 != 0 && script.GetHasFeat(itemType.ReqFeat3, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            if (itemType.ReqFeat4 != 0 && script.GetHasFeat(itemType.ReqFeat4, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            if (itemType.ReqFeat5 != 0 && script.GetHasFeat(itemType.ReqFeat5, this.ObjectId, CLRScriptBase.TRUE) == CLRScriptBase.TRUE) return true;
            return false;
        }

        private static bool _GetIsMeleeWeapon(int baseItemType)
        {
            // If this isn't even a real base item, it's not a melee weapon.
            if (baseItemType == CLRScriptBase.BASE_ITEM_INVALID)
                return false;

            // All weapons have a weapon focus feat. If this is 0, then it's not even a weapon.
            if (ALFA.Shared.Modules.InfoStore.BaseItems[baseItemType].FEATWpnFocus == 0)
                return false;

            // All melee weapons lack an ammunition type. If this is 0, it's a melee weapon.
            if (ALFA.Shared.Modules.InfoStore.BaseItems[baseItemType].AmmunitionType == 0)
                return true;

            // If it's not a melee weapon, it must be a ranged weapon.
            return false;
        }
        #endregion

        #region === Discovery Methods ===
        /// <summary>
        /// This returns the number of allies who are near hostile opponents.
        /// </summary>
        /// <returns></returns>
        public int GetAlliesInMelee()
        {
            int returnVal = 0;
            foreach (CreatureObject partymember in Party.PartyMembers)
            {
                foreach(uint target in Script.GetObjectsInShape(CLRScriptBase.SHAPE_SPHERE, 5.0f, Script.GetLocation(partymember.ObjectId), true, CLRScriptBase.OBJECT_TYPE_CREATURE, Script.Vector(0.0f, 0.0f, 0.0f)))
                {
                    int add = 0;
                    if(Script.GetReputation(partymember.ObjectId, target) < 10)
                    {
                        add = 1;
                    }
                    returnVal += add;
                }
            }
            return returnVal;
        }

        /// <summary>
        /// This refreshes the public variables which track status afflictions on the creature.
        /// </summary>
        public void RefreshNegativeStatuses()
        {
            AbilityDamaged = false;
            AbilityDrained = false;
            Blinded = false;
            Charmed = false;
            Confused = false;
            Cursed = false;
            Darkness = false;
            Dazed = false;
            Deaf = false;
            Diseased = false;
            Dominated = false;
            Entangled = false;
            Frightened = false;
            Insane = false;
            MoveDown = false;
            LevelDrain = false;
            Paralyzed = false;
            Petrified = false;
            Poisoned = false;
            Silenced = false;
            Sleeping = false;
            Slowed = false;
            Stunned = false;
            Turned = false;
            Wounded = false;

            foreach (NWEffect Effect in Script.GetObjectEffects(this.ObjectId))
            {
                int nEffectType = Script.GetEffectType(Effect);
                int nEffectSubType = Script.GetEffectSubType(Effect);
                if (nEffectType == CLRScriptBase.EFFECT_TYPE_ABILITY_DECREASE)
                {
                    if (nEffectSubType == CLRScriptBase.SUBTYPE_MAGICAL || nEffectSubType == CLRScriptBase.SUBTYPE_EXTRAORDINARY)
                        AbilityDamaged = true;
                    else
                        AbilityDrained = true;
                }

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_BLINDNESS)
                    Blinded = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_CHARMED)
                    Charmed = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_CONFUSED)
                    Confused = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_CURSE)
                    Cursed = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_DARKNESS)
                    Darkness = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_DAZED)
                    Dazed = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_DEAF)
                    Deaf = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_DISEASE)
                    Diseased = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_DOMINATED)
                    Dominated = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_ENTANGLE)
                    Entangled = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_FRIGHTENED)
                    Frightened = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_INSANE)
                    Insane = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
                    MoveDown = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_NEGATIVELEVEL)
                    LevelDrain = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_PARALYZE)
                    Paralyzed = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_PETRIFY)
                    Petrified = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_POISON)
                    Poisoned = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_SILENCE)
                    Silenced = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_SLEEP)
                    Sleeping = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_SLOW)
                    Slowed = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_STUNNED)
                    Stunned = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_TURNED)
                    Turned = true;

                else if (nEffectType == CLRScriptBase.EFFECT_TYPE_WOUNDING)
                    Wounded = true;

            }
        }

        /// <summary>
        /// This determines if the creature has any negative status effects which prevent actions in combat.
        /// </summary>
        /// <returns>false if the creature is incapable of acting</returns>
        public bool CanAct()
        {
            if (Charmed) return false;
            if (Confused) return false;
            if (Dominated) return false;
            if (Frightened) return false;
            if (Insane) return false;
            if (Paralyzed) return false;
            if (Petrified) return false;
            if (Sleeping) return false;
            if (Stunned) return false;
            if (Turned) return false;
            return true;
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
        #endregion

        #region === Attitude Methods ===
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
        #endregion

        #region === Status Information ===
        /// <summary>
        /// This contains whether a target is charmed, and thus is unwilling to fight enemies
        /// </summary>
        public bool Charmed = false;

        /// <summary>
        /// This contains whether a target is confused, and thus acting randomly.
        /// </summary>
        public bool Confused = false;

        /// <summary>
        /// This contains whether a target is cursed, and in need of a remove curse spell.
        /// </summary>
        public bool Cursed = false;

        /// <summary>
        /// This contains whether a target is afflicted by a Darkness spell, and thus needs
        /// true seeing or to move.
        /// </summary>
        public bool Darkness = false;

        /// <summary>
        /// This contains whether a target is dazed, and thus incapable of fighting.
        /// </summary>
        public bool Dazed = false;

        /// <summary>
        /// This contains whether a target is deaf, and in need of healing.
        /// </summary>
        public bool Deaf = false;

        /// <summary>
        /// This contains whether a target is diseased.
        /// </summary>
        public bool Diseased = false;

        /// <summary>
        /// This contains whether a target is following the orders of an enemy spellcaster.
        /// </summary>
        public bool Dominated = false;

        /// <summary>
        /// This contains whether a target has been trapped by webs, ropes, or the like.
        /// </summary>
        public bool Entangled = false;

        /// <summary>
        /// This contains whether a target is "frightened" by the NWN2 engine, which is mechanically
        /// "panicked"
        /// </summary>
        public bool Frightened = false;

        /// <summary>
        /// This contains whether a target is permanently confused, and thus in desparate need of healing.
        /// </summary>
        public bool Insane = false;

        /// <summary>
        /// This contains whether some effect is reducing the creature's movement speed.
        /// </summary>
        public bool MoveDown = false;

        /// <summary>
        /// This contains whether a target has negative levels.
        /// </summary>
        public bool LevelDrain = false;

        /// <summary>
        /// This contains whether a target is paralyzed.
        /// </summary>
        public bool Paralyzed = false;

        /// <summary>
        /// This contains whether a target has been turned to stone.
        /// </summary>
        public bool Petrified = false;

        /// <summary>
        /// This contains whether a target has been poisoned.
        /// </summary>
        public bool Poisoned = false;

        /// <summary>
        /// This contains whether a target has been silenced.
        /// </summary>
        public bool Silenced = false;

        /// <summary>
        /// This contains whether a target is sleeping.
        /// </summary>
        public bool Sleeping = false;

        /// <summary>
        /// This contains whether a target is slowed.
        /// </summary>
        public bool Slowed = false;

        /// <summary>
        /// This contains whether a target is stunned.
        /// </summary>
        public bool Stunned = false;

        /// <summary>
        /// This contains whether a target has been turned.
        /// </summary>
        public bool Turned = false;

        /// <summary>
        /// This contains whether a target is bleeding, and in need of a cure spell.
        /// </summary>
        public bool Wounded = false;

        /// <summary>
        /// This contains whether or not this creature is blinded, and thus needs a remove blindness
        /// spell.
        /// </summary>
        public bool Blinded = false;

        /// <summary>
        /// This contains whether or not this creature has ability drain, and thus needs help from a
        /// restoration or greater restoration.
        /// </summary>
        public bool AbilityDrained = false;

        /// <summary>
        /// This contains whether or not this creature has ability damage, and thus needs help from a 
        /// lesser restoration, restoration, or greater restoration.
        /// </summary>
        public bool AbilityDamaged = false;
        #endregion

        #region === Creature Type Handling ===
        private void SetExtraAttacks(int Attacks)
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectModifyAttacks(Attacks)), ObjectId, 0.0f);
        }

        private void SetAbberationEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
        }

        private void SetAnimalEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectLowLightVision()), ObjectId, 0.0f);
        }

        private void SetConstructEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_MIND_SPELLS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_POISON)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_STUN)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_DISEASE)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_DEATH)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_CRITICAL_HIT)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SNEAK_ATTACK)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_ABILITY_DECREASE)), ObjectId, 0.0f);            
        }

        private void SetDragonEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
        }

        private void SetElementalEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_POISON)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_STUN)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_CRITICAL_HIT)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SNEAK_ATTACK)), ObjectId, 0.0f);
        }

        private void SetFeyEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectLowLightVision()), ObjectId, 0.0f);
        }

        private void SetGiantEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectLowLightVision()), ObjectId, 0.0f);
        }

        private void SetMagicalBeastEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
        }

        private void SetMonstrousHumanoidEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
        }

        private void SetOozeEffects()
        {
            // TODO: Oozes should be blind and have blindsight.
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_MIND_SPELLS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_POISON)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_STUN)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_CRITICAL_HIT)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SNEAK_ATTACK)), ObjectId, 0.0f);
        }

        private void SetPlantEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_MIND_SPELLS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_POISON)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_STUN)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_CRITICAL_HIT)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SNEAK_ATTACK)), ObjectId, 0.0f);
        }

        private void SetUndeadEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_MIND_SPELLS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_POISON)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SLEEP)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_PARALYSIS)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_STUN)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_DISEASE)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_DEATH)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_CRITICAL_HIT)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_SNEAK_ATTACK)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_ABILITY_DECREASE)), ObjectId, 0.0f);
        }

        private void SetVerminEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_MIND_SPELLS)), ObjectId, 0.0f);
        }
        #endregion

        #region === Creature Subtype Handling ===
        private void SetAngelEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityIncrease(CLRScriptBase.DAMAGE_TYPE_ACID, 100)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityIncrease(CLRScriptBase.DAMAGE_TYPE_COLD, 100)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageResistance(CLRScriptBase.DAMAGE_TYPE_ELECTRICAL, 10, 0)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageResistance(CLRScriptBase.DAMAGE_TYPE_FIRE, 10, 0)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectSavingThrowIncrease(CLRScriptBase.SAVING_THROW_ALL, 4, CLRScriptBase.SAVING_THROW_TYPE_POISON, CLRScriptBase.FALSE)), ObjectId, 0.0f);
            // TODO: Angels have a protective aura that gives all friends +4 deflection/saves vs. evil, and immunity to spells of 3rd level or less.
        }

        private void SetArchonEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDarkVision()), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityIncrease(CLRScriptBase.DAMAGE_TYPE_ELECTRICAL, 100)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectSavingThrowIncrease(CLRScriptBase.SAVING_THROW_ALL, 4, CLRScriptBase.SAVING_THROW_TYPE_POISON, CLRScriptBase.FALSE)), ObjectId, 0.0f);
            // TODO: Archons have a permenant magic circle vs. evil
            // TODO: Archons have an aura of fear, which makes enemies who fail a will save shaken.
        }

        private void SetColdEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityIncrease(CLRScriptBase.DAMAGE_TYPE_COLD, 100)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityDecrease(CLRScriptBase.DAMAGE_TYPE_FIRE, 50)), ObjectId, 0.0f);
        }

        private void SetFireEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityIncrease(CLRScriptBase.DAMAGE_TYPE_FIRE, 100)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectDamageImmunityDecrease(CLRScriptBase.DAMAGE_TYPE_COLD, 50)), ObjectId, 0.0f);
        }

        private void SetIncorporealEffects()
        {
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectConcealment(50, CLRScriptBase.MISS_CHANCE_TYPE_NORMAL)), ObjectId, 0.0f);
            int nACBonus = Script.GetAbilityModifier(CLRScriptBase.ABILITY_CHARISMA, ObjectId);
            if (nACBonus < 1) nACBonus = 1;
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectACIncrease(nACBonus, CLRScriptBase.AC_DEFLECTION_BONUS, CLRScriptBase.DAMAGE_TYPE_ALL, CLRScriptBase.FALSE)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_ENTANGLE)), ObjectId, 0.0f);
            Script.ApplyEffectToObject(CLRScriptBase.DURATION_TYPE_PERMANENT, Script.SupernaturalEffect(Script.EffectImmunity(CLRScriptBase.IMMUNITY_TYPE_KNOCKDOWN)), ObjectId, 0.0f);
            Script.SetCollision(ObjectId, CLRScriptBase.FALSE);
        }
        #endregion

        #region === Event Management Information ===
        /// <summary>
        /// This determines if a healer believes that a party still needs healing after a fight is over.
        /// </summary>
        public bool CleanUpNeeded = false;

        /// <summary>
        /// This contains whether or not this creature has an active cycle of combat round processing.
        /// </summary>
        public bool HasCombatRoundProcess = false;

        /// <summary>
        /// This contains whether or not EndCombatRound has begun firing for the NPC.
        /// </summary>
        public bool UsingEndCombatRound = false;

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
        /// Get the current action (CLRScriptBase.ACTION_*) that the object is
        /// executing.
        /// </summary>
        public int CurrentAction { get { return Script.GetCurrentAction(ObjectId); } }

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

        public uint OverrideTarget = CLRScriptBase.OBJECT_INVALID;

        public AIParty.AIType TacticsType = AIParty.AIType.BEHAVIOR_TYPE_UNDEFINED;

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
        #endregion

        bool debug = true;
    }
}

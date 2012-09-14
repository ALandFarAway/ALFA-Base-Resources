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
    /// This class describe a party of AI controlled characters that work
    /// together.  An AI controlled character can be a member of zero or one
    /// parties.
    /// </summary>
    public class AIParty
    {
        /// <summary>
        /// Create a new, empty AI party.
        /// </summary>
        /// <param name="PartyManager">Supplies the party manager that the
        /// party will be attached to.</param>
        public AIParty(AIPartyManager PartyManager)
        {
            this.PartyManager = PartyManager;

            PartyManager.AddParty(this);
        }

        /// <summary>
        /// Add a party member.
        /// </summary>
        /// <param name="Creature">Supplies the creature to add.</param>
        public void AddPartyMember(CreatureObject Creature)
        {
            if (Creature.Party != null)
            {
                throw new ApplicationException(String.Format(
                    "Adding creature {0} to party, but it is already joined to a party."));
            }

            PartyMembers.Add(Creature);
            Creature.Party = this;

            // No party leader defined. Guess it's this guy!
            if (PartyLeader == null)
            {
                PartyLeader = Creature;
            }

            // Existing party leader. Is this guy better at it?
            else
            {
                // If I'm the more charismatic leader, I take over.
                if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_CHARISMA, CLRScriptBase.TRUE) > PartyLeader.Script.GetAbilityScore(PartyLeader.ObjectId, CLRScriptBase.ABILITY_CHARISMA, CLRScriptBase.TRUE))
                        PartyLeader = Creature;

                // We're equally charismatic, but I'm more experienced. I take over.
                else if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_CHARISMA, CLRScriptBase.TRUE) == PartyLeader.Script.GetAbilityScore(PartyLeader.ObjectId, CLRScriptBase.ABILITY_CHARISMA, CLRScriptBase.TRUE) &&
                    Creature.Script.GetHitDice(Creature.ObjectId) > PartyLeader.Script.GetHitDice(PartyLeader.ObjectId))
                        PartyLeader = Creature;
            }

            // Now that leadership is established, what sort of guy is this?
            AIParty.AIType TacticsType = (AIParty.AIType)Creature.Script.GetLocalInt(Creature.ObjectId, "ACR_CREATURE_BEHAVIOR");
            if (TacticsType == AIType.BEHAVIOR_TYPE_UNDEFINED)
            {
                string Tactics = Creature.Script.GetLocalString(Creature.ObjectId, "ACR_CREATURE_BEHAVIOR");
                if (!Enum.TryParse<AIParty.AIType>(Tactics.ToUpper(), out TacticsType))
                    TacticsType = AIType.BEHAVIOR_TYPE_UNDEFINED;
            }
            if(TacticsType != AIType.BEHAVIOR_TYPE_UNDEFINED)
            {
                if(TacticsType == AIType.BEHAVIOR_TYPE_ANIMAL)
                {
                    this.PartyAnimals.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_ARCHER)
                {
                    this.PartyArchers.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_BUFFS)
                {
                    this.PartyBuffs.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_CONTROL)
                {
                    this.PartyControls.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_COWARD)
                {
                    this.PartyCowards.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_FLANK)
                {
                    this.PartyFlanks.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_MEDIC)
                {
                    this.PartyMedics.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_MINDLESS)
                {
                    this.PartyMindless.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_NUKE)
                {
                    this.PartyNukes.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_SHOCK)
                {
                    this.PartyShocks.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_SKIRMISH)
                {
                    this.PartySkrimishers.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else if(TacticsType == AIType.BEHAVIOR_TYPE_TANK)
                {
                    this.PartyTanks.Add(Creature);
                    Creature.TacticsType = TacticsType;
                }
                else
                {
                    TacticsType = AIType.BEHAVIOR_TYPE_UNDEFINED;
                    Creature.Script.SendMessageToAllDMs(String.Format("** ERROR ** : {0} has an AI type {1} defined, but that type is not understood by ACR_CreatureBehavior. This creature DOES NOT KNOW HOW TO FIGHT, and needs to be despawned.", Creature, TacticsType));
                    throw new ApplicationException(String.Format("Creature {0} has an AI type {1} defined, but that type is not understood by ACR_CreatureBehavior.", Creature, TacticsType));
                }
            }
            else if (TacticsType == AIType.BEHAVIOR_TYPE_UNDEFINED)
            {
//==================================================================================================================================================
//                                         Maybe this is an easy question. Is the creature stupid?
//==================================================================================================================================================
                // The creature is mindless; that's a simple thing.
                if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_INTELLIGENCE, CLRScriptBase.TRUE) == 0)
                {
                    Creature.TacticsType = AIType.BEHAVIOR_TYPE_MINDLESS;
                    this.PartyMindless.Add(Creature);
                }
                
                // The creature is too dumb to take more than simple orders.
                else if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_INTELLIGENCE, CLRScriptBase.TRUE) < 6)
                {
                    Creature.TacticsType = AIType.BEHAVIOR_TYPE_ANIMAL;
                    this.PartyAnimals.Add(Creature);
                }

//==================================================================================================================================================
//                        No such luck. We have to figure out how to make this creature act. Count and categorize classes.
//==================================================================================================================================================
                else
                {
                    int Heal = 0;
                    int Buff = 0;
                    int Blast = 0;
                    int Tank = 0;
                    int Crush = 0;
                    int Flank = 0;
                    int Skirm = 0;
                    int Arch = 0;
                    int Cont = 0;
                    for (int nClassPosition = 0; nClassPosition < 4; nClassPosition++)
                    {
                        int nClass = Creature.Script.GetClassByPosition(nClassPosition, Creature.ObjectId);
                        int nClassLevel = Creature.Script.GetLevelByClass(nClass, Creature.ObjectId);

                        // Members of these classes commonly have and prepare healing spells.
                        if (nClass == CLRScriptBase.CLASS_TYPE_CLERIC ||
                            nClass == CLRScriptBase.CLASS_TYPE_DRUID ||
                            nClass == CLRScriptBase.CLASS_TYPE_FAVORED_SOUL ||
                            nClass == CLRScriptBase.CLASS_TYPE_SPIRIT_SHAMAN)
                        {
                            Heal += nClassLevel;
                        }

                        // Members of these classes commonly have good support magic.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_BARD)
                        {
                            Buff += nClassLevel;
                        }

                        // Members of these classes are usually well-set to focus on aggressive magic.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_SORCERER ||
                                nClass == CLRScriptBase.CLASS_TYPE_WARLOCK)
                        {
                            Blast += nClassLevel;
                        }

                        // Members of these classes tend to have some combination of high AC, good saves, and/or damage reduction.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_FIGHTER ||
                                nClass == CLRScriptBase.CLASS_TYPE_PALADIN ||
                                nClass == 35 ||
                                nClass == CLRScriptBase.CLASS_TYPE_UNDEAD ||
                                nClass == CLRScriptBase.CLASS_TYPE_CONSTRUCT) // CLASS_TYPE_PLANT is undefined.
                        {
                            Tank += nClassLevel;
                        }

                        // Members of these classes tend to do a lot of damage in direct melee combat.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_BARBARIAN ||
                                nClass == CLRScriptBase.CLASS_TYPE_OOZE ||
                                nClass == CLRScriptBase.CLASS_TYPE_VERMIN ||
                                nClass == CLRScriptBase.CLASS_TYPE_OUTSIDER ||
                                nClass == CLRScriptBase.CLASS_TYPE_GIANT ||
                                nClass == CLRScriptBase.CLASS_TYPE_BEAST ||
                                nClass == CLRScriptBase.CLASS_TYPE_ELEMENTAL ||
                                nClass == CLRScriptBase.CLASS_TYPE_MONSTROUS ||
                                nClass == CLRScriptBase.CLASS_TYPE_HUMANOID)
                        {
                            Crush += nClassLevel;
                        }
                        
                        // Members of these classes are typically the most-threatening if they can stab an opponent in the back.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_ROGUE ||
                                nClass == CLRScriptBase.CLASS_TYPE_SWASHBUCKLER)
                        {
                            Flank += nClassLevel;
                        }

                        // Members of these classes are typically highly-mobile.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_MONK ||
                                nClass == CLRScriptBase.CLASS_TYPE_RANGER ||
                                nClass == CLRScriptBase.CLASS_TYPE_SHAPECHANGER ||
                                nClass == CLRScriptBase.CLASS_TYPE_MAGICAL_BEAST ||
                                nClass == CLRScriptBase.CLASS_TYPE_ANIMAL)
                        {
                            Skirm += nClassLevel;
                        }

                        // Members of these classes are typically best at attacking from a distance.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_RANGER)
                        {
                            Arch += nClassLevel;
                        }

                        // Members of these classes typically have or prepare spells which control the battlefield.
                        else if (nClass == CLRScriptBase.CLASS_TYPE_WIZARD ||
                                nClass == CLRScriptBase.CLASS_TYPE_FEY ||
                                nClass == CLRScriptBase.CLASS_TYPE_ABERRATION)
                        {
                            Cont += nClassLevel;
                        }
                    }

//==================================================================================================================================================
//                                    Now that we know classes by their generic type, we compare the varieties.
//==================================================================================================================================================
                    // Spellcasting conters are higher than the others; this person is mostly a spellcaster.
                    if (Heal + Buff + Blast + Cont > Tank + Crush &&
                        Heal + Buff + Blast + Cont > Flank + Skirm + Arch)
                    {
                        // Spellcaster is better at controlling the field than others.
                        if (Cont > Buff &&
                            Cont > Blast &&
                            Cont > Heal)
                        {
                            this.PartyControls.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_CONTROL;
                        }

                        // Spellcaster is better at support magic than others.
                        else if (Buff > Blast &&
                                Buff > Heal)
                        {
                            this.PartyBuffs.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_BUFFS;
                        }

                        // Spellcaster is better at destroying things than not.
                        else if (Blast > Heal)
                        {
                            this.PartyNukes.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_NUKE;
                        }

                        // Spellcaster is either a healer or we don't know. We'll set them to taking care of pals.
                        else
                        {
                            this.PartyMedics.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_MEDIC;
                        }
                    }

                    // Looks like a melee fighter.
                    else if (Tank + Crush > Flank + Skirm + Arch)
                    {
                        if (Tank > Crush)
                        {
                            this.PartyTanks.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_TANK;
                        }
                        else
                        {
                            this.PartyShocks.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_SHOCK;
                        }
                    }

                    // Looks like a skilled character.
                    else if (Flank + Skirm + Arch > 0)
                    {
                        if (Flank > Skirm &&
                            Flank > Arch)
                        {
                            this.PartyFlanks.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_FLANK;
                        }
                        else if (Arch > Skirm)
                        {
                            this.PartyArchers.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_ARCHER;
                        }
                        else
                        {
                            this.PartySkrimishers.Add(Creature);
                            Creature.TacticsType = AIType.BEHAVIOR_TYPE_SKIRMISH;
                        }
                    }

                    // None of them have any value. This guy is probably useless, except that he can run for help.
                    else
                    {
                        this.PartyCowards.Add(Creature);
                        Creature.TacticsType = AIType.BEHAVIOR_TYPE_COWARD;
                    }
                }
            }
        }

        /// <summary>
        /// Remove a party member.  If the party member was the last in the
        /// party, then the party is dissolved.
        /// </summary>
        /// <param name="Creature">Supplies the creature to remove.</param>
        public void RemovePartyMember(CreatureObject Creature)
        {
            if (Creature.Party != this)
            {
                throw new ApplicationException(String.Format(
                    "Removing creature {0} from party, but it is not in this party."));
            }

            PartyMembers.Remove(Creature);
            Creature.Party = null;

            if (PartyLeader == Creature)
                PartyLeader = null;

            if (PartyMembers.Count == 0)
                PartyManager.RemoveParty(this);

            switch ((AIType)Creature.TacticsType)
            {
                case AIType.BEHAVIOR_TYPE_ANIMAL:
                    PartyAnimals.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_ARCHER:
                    PartyArchers.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_BUFFS:
                    PartyBuffs.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_CONTROL:
                    PartyControls.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_COWARD:
                    PartyCowards.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_FLANK:
                    PartyFlanks.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_MEDIC:
                    PartyMedics.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_MINDLESS:
                    PartyMindless.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_NUKE:
                    PartyNukes.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_SHOCK:
                    PartyShocks.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_SKIRMISH:
                    PartySkrimishers.Remove(Creature);
                    break;
                case AIType.BEHAVIOR_TYPE_TANK:
                    PartyTanks.Remove(Creature);
                    break;
                default:
                    break;
            }

            if (PartyMembers.Count > 0 && PartyLeader == null)
            {
                int nCha = 0;
                foreach (CreatureObject Member in PartyMembers)
                {
                    if (Member.Script.GetAbilityModifier(CLRScriptBase.ABILITY_CHARISMA, Member.ObjectId) > nCha)
                    {
                        nCha = Member.Script.GetAbilityModifier(CLRScriptBase.ABILITY_CHARISMA, Member.ObjectId);
                        PartyLeader = Member;
                    }
                }
            }
        }

        /// <summary>
        /// Promote a creature in the party to party leader.
        /// </summary>
        /// <param name="PartyLeader">Supplies the new party leader.</param>
        public void PromotePartyLeader(CreatureObject PartyLeader)
        {
            if (PartyLeader != null)
            {
                if (PartyLeader.Party != this)
                {
                    throw new ApplicationException(String.Format(
                        "Trying to promote creature {0} to party leader, but it is not in this party.",
                        PartyLeader));
                }
            }

            this.PartyLeader = PartyLeader;
        }

        public void AddPartyEnemy(CreatureObject PartyEnemy)
        {
            if (PartyEnemy == null)
            {
                throw new ApplicationException("Trying to add party enemy, but that creature does not exist.");
            }
            Enemies.Add(PartyEnemy);

            if (CanPartySee(PartyEnemy))
            {
                int EnemyArmorRank = PartyEnemy.Script.GetArmorRank(PartyEnemy.Script.GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CARMOUR, PartyEnemy.ObjectId));
                if (EnemyArmorRank == CLRScriptBase.ARMOR_RANK_HEAVY ||
                    EnemyArmorRank == CLRScriptBase.ARMOR_RANK_MEDIUM)
                    EnemyHardTargets.Add(PartyEnemy);
                if (EnemyArmorRank == CLRScriptBase.ARMOR_RANK_LIGHT ||
                    EnemyArmorRank == CLRScriptBase.ARMOR_RANK_NONE)
                    EnemySoftTargets.Add(PartyEnemy);
                if (_LooksLikeSpellcaster(PartyEnemy))
                    EnemySpellcasters.Add(PartyEnemy);
            }
            else
            {
                EnemiesLost.Add(PartyEnemy);
            }
        }

        public void RemovePartyEnemy(CreatureObject PartyEnemy)
        {
            Enemies.Remove(PartyEnemy);
            EnemyHardTargets.Remove(PartyEnemy);
            EnemySoftTargets.Remove(PartyEnemy);
            EnemySpellcasters.Remove(PartyEnemy);
            EnemyHealers.Remove(PartyEnemy);
        }

        public CreatureObject GetNearest(CreatureObject Source, List<CreatureObject> Creatures)
        {
            AreaObject SourceArea = Source.Area;
            Vector3 SourcePos = Source.Position;
            CreatureObject RetValue = null;
            if (Creatures.Count == 0) return RetValue;

            float ShortestDistance = -1.0f;
            foreach (CreatureObject Target in Creatures)
            {
                // Only interested in objects in the same area.
                if (SourceArea != Target.Area)
                    continue;

                Vector3 TargetPos = Target.Position;
                float Distance = MathOps.DistanceSq(SourcePos, TargetPos);

                if ((ShortestDistance < 0) || (Distance < ShortestDistance))
                {
                    ShortestDistance = Distance;
                    RetValue = Target;
                }
            }
            return RetValue;
        }

        public CreatureObject GetFarthest(CreatureObject Source, List<CreatureObject> Creatures)
        {
            AreaObject SourceArea = Source.Area;
            Vector3 SourcePos = Source.Position;
            CreatureObject RetValue = null;
            if (Creatures.Count == 0) return RetValue;

            float LongestDistance = -1.0f;
            foreach (CreatureObject Target in Creatures)
            {
                // Only interested in objects in the same area.
                if (SourceArea != Target.Area)
                    continue;

                Vector3 TargetPos = Target.Position;
                float Distance = MathOps.DistanceSq(SourcePos, TargetPos);

                if ((LongestDistance < 0) || ((Distance > LongestDistance) && (Distance < 100.0f * 100.0f))) // 100 meters is about as far as we'd expect combat to reach.
                {
                    LongestDistance = Distance;
                    RetValue = Target;
                }
            }
            return RetValue;
        }

        public enum AIType
        {
            BEHAVIOR_TYPE_UNDEFINED = 0,
            BEHAVIOR_TYPE_TANK = 1,
            BEHAVIOR_TYPE_FLANK = 2,
            BEHAVIOR_TYPE_SHOCK = 3,
            BEHAVIOR_TYPE_BUFFS = 4,
            BEHAVIOR_TYPE_MEDIC = 5,
            BEHAVIOR_TYPE_SKIRMISH = 6,
            BEHAVIOR_TYPE_ARCHER = 7,
            BEHAVIOR_TYPE_CONTROL = 8,
            BEHAVIOR_TYPE_NUKE = 9,

            BEHAVIOR_TYPE_MINDLESS = 20,
            BEHAVIOR_TYPE_ANIMAL = 30,
            BEHAVIOR_TYPE_COWARD = 40
        }

// ====== Block of private functions with assess what the party knows. =======================//
        /// <summary>
        /// This function assesses whether or not a creature is visible to any member of the party.
        /// </summary>
        /// <param name="Creature">The creature that the party is looking for</param>
        /// <returns>true if the creature is seen by any member of the party</returns>
        public bool CanPartySee(CreatureObject Creature)
        {
            foreach (CreatureObject PartyMember in PartyMembers)
            {
                if (PartyMember.Script.GetObjectSeen(PartyMember.ObjectId, Creature.ObjectId) == CLRScriptBase.TRUE)
                    return true;
            }
            return false;
        }

        public bool CanPartyHear(CreatureObject Creature)
        {
            foreach (CreatureObject PartyMember in PartyMembers)
            {
                if (PartyMember.Script.GetObjectHeard(PartyMember.ObjectId, Creature.ObjectId) == CLRScriptBase.TRUE)
                    return true;
            }
            return false;
        }

        /// <summary>
        /// This function seeks signs of a spellcaster, looking for visible paraphenalia. Visibility is assumed, and should be checked separately.
        /// </summary>
        /// <param name="Creature">The creature to be assessed</param>
        /// <returns>True if there is some visible paraphenalia that suggests spellcasting.</returns>
        private bool _LooksLikeSpellcaster(CreatureObject Creature)
        {
            int VisibleSpellbooks = 0;
            foreach (uint Item in Creature.Script.GetItemsInInventory(Creature.ObjectId))
            {
                if (Creature.Script.GetTag(Item) == "ACR_MOD_SPELLBOOK" ||
                    Creature.Script.GetTag(Item) == "ACR_MOD_HOLYSYMBOL")
                    VisibleSpellbooks++;
                if (Creature.Script.GetHasInventory(Item) == CLRScriptBase.TRUE)
                {
                    foreach (uint ContainerContents in Creature.Script.GetItemsInInventory(Item))
                    {
                        if (Creature.Script.GetTag(ContainerContents) == "ACR_MOD_SPELLBOOK" ||
                            Creature.Script.GetTag(ContainerContents) == "ACR_MOD_HOLYSYMBOL")
                            VisibleSpellbooks--;
                    }
                }
            }
            if (VisibleSpellbooks > 0)
                return true;
            return false;
        }

// ====== Block of general management lists =================================================//
        /// <summary>
        /// The list of objects in the party.
        /// </summary>
        public List<CreatureObject> PartyMembers = new List<CreatureObject>();

        /// <summary>
        /// An arbitrary measure of how badly the party is being beaten.
        /// </summary>
        public int PartyLosses = 0;

        /// <summary>
        /// The designated party leader (if one is still alive).
        /// </summary>
        public CreatureObject PartyLeader = null;

        /// <summary>
        /// The associated party manager.
        /// </summary>
        public AIPartyManager PartyManager = null;

// ===== Block of lists for party enemies ===================================================//
        /// <summary>
        /// The list of known enemies of the party
        /// </summary>
        public List<CreatureObject> Enemies = new List<CreatureObject>();

        /// <summary>
        /// Ths list of enemies who appear to be easy to hit.
        /// </summary>
        public List<CreatureObject> EnemySoftTargets = new List<CreatureObject>();

        /// <summary>
        /// The list of enemies who appear to be difficult to hit.
        /// </summary>
        public List<CreatureObject> EnemyHardTargets = new List<CreatureObject>();

        /// <summary>
        /// The list of enemies who have been observed casting spells.
        /// </summary>
        public List<CreatureObject> EnemySpellcasters = new List<CreatureObject>();

        /// <summary>
        /// The list of enemies who have been observed casting healing magic.
        /// </summary>
        public List<CreatureObject> EnemyHealers = new List<CreatureObject>();

        /// <summary>
        /// The list of enemies who we know exist, but can't see.
        /// </summary>
        public List<CreatureObject> EnemiesLost = new List<CreatureObject>();

// ===== Block of lists for spellcasting NPCs ===============================================//
        /// <summary>
        /// The list of party members focused primarily on healing magic.
        /// </summary>
        public List<CreatureObject> PartyMedics = new List<CreatureObject>();

        /// <summary>
        /// The list of party members focused primarily on support magic.
        /// </summary>
        public List<CreatureObject> PartyBuffs = new List<CreatureObject>();

        /// <summary>
        /// The list of party members focused primarily on crowd control and battlefield manipulation.
        /// </summary>
        public List<CreatureObject> PartyControls = new List<CreatureObject>();

        /// <summary>
        /// The list of party members focused primarily on attack magic.
        /// </summary>
        public List<CreatureObject> PartyNukes = new List<CreatureObject>();

// ====== Block of lists for heavy NPCs ====================================================//
        /// <summary>
        /// The list of party members focused primarily on tactical defense and holding ground.
        /// </summary>
        public List<CreatureObject> PartyTanks = new List<CreatureObject>();

        /// <summary>
        /// The list of party members focused primarily on
        /// </summary>
        public List<CreatureObject> PartyShocks = new List<CreatureObject>();

// ====== Block of lists for skilled NPCs ==================================================//
        /// <summary>
        /// The list of party members who flank in melee combat to inflict damage.
        /// </summary>
        public List<CreatureObject> PartyFlanks = new List<CreatureObject>();

        /// <summary>
        /// The list of party members who prefer ranged combat.
        /// </summary>
        public List<CreatureObject> PartyArchers = new List<CreatureObject>();

        /// <summary>
        /// The list of party members who specialise in short highly-mobile melee strikes.
        /// </summary>
        public List<CreatureObject> PartySkrimishers = new List<CreatureObject>();

// ====== Block of lists for other NPCs ==================================================//
        /// <summary>
        /// The list of party members who don't want to fight, and will run for help.
        /// </summary>
        public List<CreatureObject> PartyCowards = new List<CreatureObject>();

        /// <summary>
        /// The list of party members who aren't smart enough to behave tactically, but are smart
        /// enough to have some sense of self preservation.
        /// </summary>
        public List<CreatureObject> PartyAnimals = new List<CreatureObject>();

        /// <summary>
        /// The list of party members who are incapable of thought, and will thrash out mindlessly.
        /// </summary>
        public List<CreatureObject> PartyMindless = new List<CreatureObject>();
    }
}

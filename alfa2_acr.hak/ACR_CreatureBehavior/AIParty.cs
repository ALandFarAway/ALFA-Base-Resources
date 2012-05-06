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
            int TacticsType = Creature.Script.GetLocalInt(Creature.ObjectId, "ACR_CREATURE_BEHAVIOR");

            if (TacticsType == 0)
            {
                // Well, no one set a variable, but the creature is mindless; that's a simple thing.
                if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_INTELLIGENCE, CLRScriptBase.TRUE) == 0)
                {
                    Creature.TacticsType = (int)AIType.BEHAVIOR_TYPE_MINDLESS;
                }
                
                // Missing the variable, but the creature is too dumb to take more than simple orders.
                else if (Creature.Script.GetAbilityScore(Creature.ObjectId, CLRScriptBase.ABILITY_INTELLIGENCE, CLRScriptBase.TRUE) < 6)
                {
                    Creature.TacticsType = (int)AIType.BEHAVIOR_TYPE_ANIMAL;
                }
                
                int Heal = 0;
                int Buff = 0;
                int Blast = 0;
                int Tank = 0;
                int Crush = 0;
                int Flank = 0;
                int Skirm = 0;
                int Arch = 0;
                int Cont = 0;
                for (int nClass = 0; nClass < 104; nClass++)
                {
                    int nClassLevel = Creature.Script.GetLevelByClass(nClass, Creature.ObjectId);
                    if (nClass == CLRScriptBase.CLASS_TYPE_CLERIC ||
                        nClass == CLRScriptBase.CLASS_TYPE_DRUID ||
                        nClass == CLRScriptBase.CLASS_TYPE_FAVORED_SOUL ||
                        nClass == CLRScriptBase.CLASS_TYPE_SPIRIT_SHAMAN)
                    {
                        Heal += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_BARD)
                    {
                        Buff += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_SORCERER ||
                            nClass == CLRScriptBase.CLASS_TYPE_WARLOCK)
                    {
                        Blast += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_FIGHTER ||
                            nClass == CLRScriptBase.CLASS_TYPE_PALADIN ||
                            nClass == 35 ||
                            nClass == CLRScriptBase.CLASS_TYPE_UNDEAD ||
                            nClass == CLRScriptBase.CLASS_TYPE_CONSTRUCT) // CLASS_TYPE_PLANT is undefined.
                    {
                        Tank += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_BARBARIAN ||
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
                    else if(nClass == CLRScriptBase.CLASS_TYPE_ROGUE ||
                            nClass == CLRScriptBase.CLASS_TYPE_SWASHBUCKLER)
                    {
                        Flank += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_MONK ||
                            nClass == CLRScriptBase.CLASS_TYPE_RANGER ||
                            nClass == CLRScriptBase.CLASS_TYPE_SHAPECHANGER ||
                            nClass == CLRScriptBase.CLASS_TYPE_MAGICAL_BEAST ||
                            nClass == CLRScriptBase.CLASS_TYPE_ANIMAL)
                    {
                        Skirm += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_RANGER ||
                            nClass == CLRScriptBase.CLASS_TYPE_COMMONER)
                    {
                        Arch += nClassLevel;
                    }
                    else if(nClass == CLRScriptBase.CLASS_TYPE_WIZARD ||
                            nClass == CLRScriptBase.CLASS_TYPE_FEY ||
                            nClass == CLRScriptBase.CLASS_TYPE_ABERRATION)
                    {
                        Cont += nClassLevel;
                    }
                }
            }
            Creature.TacticsType = TacticsType;
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
        public List<CreatureObject> PartyNukess = new List<CreatureObject>();

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

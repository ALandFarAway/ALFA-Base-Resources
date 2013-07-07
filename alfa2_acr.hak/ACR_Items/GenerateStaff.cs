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

using OEIShared.IO.GFF;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Items
{
    class GenerateStaff: CLRScriptBase
    {
        public static int NewStaff(CLRScriptBase script, int maxValue)
        {
            Dictionary<int, int> currentAvailableSpells = new Dictionary<int,int>();
            List<string> possibleNames = new List<string>();
            #region Get Starting Collections
            switch (Generation.rand.Next(22))
            {
                case 0:
                    copyDictionary(FireSpells, currentAvailableSpells);
                    copyList(FireNames, possibleNames);
                    break;
                case 1:
                    copyDictionary(ColdSpells, currentAvailableSpells);
                    copyList(ColdNames, possibleNames);
                    break;
                case 2:
                    copyDictionary(AcidSpells, currentAvailableSpells);
                    copyList(AcidNames, possibleNames);
                    break;
                case 3:
                    copyDictionary(ElectricSpells, currentAvailableSpells);
                    copyList(ElectricNames, possibleNames);
                    break;
                case 4:
                    copyDictionary(SoundSpells, currentAvailableSpells);
                    copyList(SoundNames, possibleNames);
                    break;
                case 5:
                    copyDictionary(PhysicalAttackSpells, currentAvailableSpells);
                    copyList(PhysicalAttackNames, possibleNames);
                    break;
                case 6:
                    copyDictionary(ForceSpells, currentAvailableSpells);
                    copyList(ForceNames, possibleNames);
                    break;
                case 7: 
                    copyDictionary(MoraleSpells, currentAvailableSpells);
                    copyList(MoraleNames, possibleNames);
                    break;
                case 8:
                    copyDictionary(AntimoraleSpells, currentAvailableSpells);
                    copyList(AntimoraleNames, possibleNames);
                    break;
                case 9:
                    copyDictionary(MindControlSpells, currentAvailableSpells);
                    copyList(MindControlNames, possibleNames);
                    break;
                case 10:
                    copyDictionary(PerceptionSpells, currentAvailableSpells);
                    copyList(PerceptionNames, possibleNames);
                    break;
                case 11:
                    copyDictionary(PhysicalSpells, currentAvailableSpells);
                    copyList(PhysicalNames, possibleNames);
                    break;
                case 12:
                    copyDictionary(MentalSpells, currentAvailableSpells);
                    copyList(MentalNames, possibleNames);
                    break;
                case 13:
                    copyDictionary(Transmutations, currentAvailableSpells);
                    copyList(TransmutNames, possibleNames);
                    break;
                case 14:
                    copyDictionary(AntiMagicSpells, currentAvailableSpells);
                    copyList(AntiMagicNames, possibleNames);
                    break;
                case 15:
                    copyDictionary(IllusionSpells, currentAvailableSpells);
                    copyList(IllusionNames, possibleNames);
                    break;
                case 16:
                    copyDictionary(DeathSpells, currentAvailableSpells);
                    copyList(DeathNames, possibleNames);
                    break;
                case 17:
                    copyDictionary(EvilSpells, currentAvailableSpells);
                    copyList(EvilNames, possibleNames);
                    break;
                case 18:
                    copyDictionary(GoodSpells, currentAvailableSpells);
                    copyList(GoodNames, possibleNames);
                    break;
                case 19:
                    copyDictionary(ProtectionSpells, currentAvailableSpells);
                    copyList(ProtectionNames, possibleNames);
                    break;
                case 20:
                    copyDictionary(HealingSpells, currentAvailableSpells);
                    copyList(HealingNames, possibleNames);
                    break;
                case 21:
                    copyDictionary(SummonSpells, currentAvailableSpells);
                    copyList(SummonNames, possibleNames);
                    break;
            }
            if (currentAvailableSpells.Count == 0 || possibleNames.Count == 0)
            {
                return 0;
            }
            #endregion

            #region Select Spells from Collections Based on Price
            Dictionary<int, int> SelectedSpells = new Dictionary<int, int>();
            List<int> SelectedPrices = new List<int>();
            int currentCharges = 5;
            int maxSpellValue = maxValue;
            while (true)
            {
                List<int> spellsToRemove = new List<int>();
                foreach (int spell in currentAvailableSpells.Keys)
                {
                    if (((currentAvailableSpells[spell] * 50) / currentCharges) > maxValue ||
                        currentAvailableSpells[spell] > maxSpellValue)
                    {
                        spellsToRemove.Add(spell);
                    }
                }
                foreach (int spell in spellsToRemove)
                {
                    currentAvailableSpells.Remove(spell);
                }
                if (currentAvailableSpells.Count == 0)
                {
                    if(SelectedSpells.Count == 0)
                    {
                        return 0;
                    }
                    else
                    {
                        break;
                    }
                }
                List<int> spellOptions = new List<int>();
                foreach (int key in currentAvailableSpells.Keys)
                {
                    spellOptions.Add(key);
                }
                int spellSelection = spellOptions[Generation.rand.Next(spellOptions.Count)];
                switch (currentCharges)
                {
                    case 1:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 50);
                        currentCharges--;
                        break;
                    case 2:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 25);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 25;
                        currentCharges--;
                        break;
                    case 3:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 16);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 16;
                        currentCharges--;
                        break;
                    case 4:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 12);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 12;
                        currentCharges--;
                        break;
                    case 5:
                        SelectedSpells.Add(spellSelection, IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE);
                        SelectedPrices.Add(currentAvailableSpells[spellSelection] * 10);
                        maxSpellValue = currentAvailableSpells[spellSelection] - 1;
                        maxValue -= currentAvailableSpells[spellSelection] * 10;
                        currentCharges--;
                        break;
                }
                if (currentCharges == 0)
                {
                    break;
                }
            }
            #endregion

            #region Sum Predicted Values of Properties
            SelectedPrices.Sort();
            int value = SelectedPrices[0];
            if (SelectedPrices.Count > 1)
            {
                value += (SelectedPrices[1] * 3 / 4);
            }
            if (SelectedPrices.Count > 2)
            {
                value += (SelectedPrices[2] / 2);
            }
            if (SelectedPrices.Count > 3)
            {
                value += (SelectedPrices[3] / 2);
            }
            if (SelectedPrices.Count > 4)
            {
                value += (SelectedPrices[4] / 2);
            }
            #endregion

            #region Build the Actual Staff
            uint staff = script.CreateItemOnObject(GenerateWeapon.WeaponResrefs[BASE_ITEM_QUARTERSTAFF], script.OBJECT_SELF, 1, "", FALSE);
            script.SetItemCharges(staff, 50);
            foreach (KeyValuePair<int, int> Spell in SelectedSpells)
            {
                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyCastSpell(Spell.Key, Spell.Value), staff, 0.0f);
            }
            script.SetFirstName(staff, String.Format(possibleNames[Generation.rand.Next(possibleNames.Count)], "Staff"));
            Pricing.CalculatePrice(script, staff);
            #endregion
            return value;
        }

        #region Fire Spells
        public static List<string> FireNames = new List<string>
        {
            "{0} of Fire",
        };

        public static Dictionary<int, int> FireSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BURNING_HANDS_2, 30},
            {IP_CONST_CASTSPELL_BURNING_HANDS_5, 75},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13, 1365},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15, 1575},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20, 2100},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12, 720},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7, 420},
            {IP_CONST_CASTSPELL_FIRE_STORM_13, 1365},
            {IP_CONST_CASTSPELL_FIRE_STORM_18, 1890},
            {IP_CONST_CASTSPELL_FIREBALL_10, 450},
            {IP_CONST_CASTSPELL_FIREBALL_5, 225},
            {IP_CONST_CASTSPELL_FIREBRAND_15, 1125},
            {IP_CONST_CASTSPELL_FLAME_ARROW_12, 540},
            {IP_CONST_CASTSPELL_FLAME_ARROW_18, 810},
            {IP_CONST_CASTSPELL_FLAME_ARROW_5, 225},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_12, 720},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_18, 1080},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_7, 420},
            {IP_CONST_CASTSPELL_FLARE_1, 8},
            {IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15, 1800},
            {IP_CONST_CASTSPELL_INFERNO_15, 1125},
            {IP_CONST_CASTSPELL_WALL_OF_FIRE_9, 540},
        };
        #endregion

        #region Cold Spells
        public static List<string> ColdNames = new List<string>
        {
            "{0} of Cold",
        };

        public static Dictionary<int, int> ColdSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CONE_OF_COLD_15, 1125},
            {IP_CONST_CASTSPELL_CONE_OF_COLD_9, 675},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12, 720},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7, 420},
            {IP_CONST_CASTSPELL_ICE_STORM_9, 540},
            {IP_CONST_CASTSPELL_RAY_OF_FROST_1, 8},
        };
        #endregion

        #region Acid Spells
        public static List<string> AcidNames = new List<string>
        {
            "{0} of Acid",
        };

        public static Dictionary<int, int> AcidSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_ACID_FOG_11, 990},
            {IP_CONST_CASTSPELL_ACID_SPLASH_1, 8},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3, 90},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6, 180},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9, 270},
        };
        #endregion

        #region Electric Spells
        public static List<string> ElectricNames = new List<string>
        {
            "{0} of Lightning",
        };

        public static Dictionary<int, int> ElectricSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CALL_LIGHTNING_10, 450},
            {IP_CONST_CASTSPELL_CALL_LIGHTNING_5, 225},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11, 990},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15, 1350},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20, 1800},
            {IP_CONST_CASTSPELL_ELECTRIC_JOLT_1, 8},
            {IP_CONST_CASTSPELL_LIGHTNING_BOLT_10, 450},
            {IP_CONST_CASTSPELL_LIGHTNING_BOLT_5, 225},
            {IP_CONST_CASTSPELL_SCINTILLATING_SPHERE_5, 225},
        };
        #endregion

        #region Sound Spells
        public static List<string> SoundNames = new List<string>
        {
            "{0} of Sound",
        };

        public static Dictionary<int, int> SoundSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7, 210},
            {IP_CONST_CASTSPELL_SOUND_BURST_3, 90},
        };
        #endregion

        #region Physical Attacks
        public static List<string> PhysicalAttackNames = new List<string>
        {
            "{0} of Creation",
        };
        public static Dictionary<int, int> PhysicalAttackSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BLADE_BARRIER_11, 990},
            {IP_CONST_CASTSPELL_BLADE_BARRIER_15, 1350},
            {IP_CONST_CASTSPELL_BOMBARDMENT_20, 2400},
            {IP_CONST_CASTSPELL_EARTHQUAKE_20, 2700},
            {IP_CONST_CASTSPELL_ENTANGLE_2, 30},
            {IP_CONST_CASTSPELL_ENTANGLE_5, 75},
            {IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15, 900},
            {IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7, 420},
            {IP_CONST_CASTSPELL_GREASE_2, 30},
            {IP_CONST_CASTSPELL_GUST_OF_WIND_10, 300},
            {IP_CONST_CASTSPELL_IMPLOSION_17, 2295},
            {IP_CONST_CASTSPELL_METEOR_SWARM_17, 2295},
            {IP_CONST_CASTSPELL_WEB_3, 90},
        };
        #endregion

        #region Force Spells
        public static List<string> ForceNames = new List<string>
        {
            "{0} of Force",
        };

        public static Dictionary<int, int> ForceSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20, 2400},
            {IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20, 2700},
            {IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15, 1350},
            {IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17, 2380},
            {IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15, 1125},
            {IP_CONST_CASTSPELL_IMPROVED_MAGE_ARMOR_10, 450},
            {IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15, 1170},
            {IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13, 780},
            {IP_CONST_CASTSPELL_KNOCK_3, 90},
            {IP_CONST_CASTSPELL_MAGE_ARMOR_2, 30},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_3, 45},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_5, 75},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_9, 135},
            {IP_CONST_CASTSPELL_SHIELD_5, 75},
        };
        #endregion

        #region Morale Spells
        public static List<string> MoraleNames = new List<string>
        {
            "{0} of Morale",
            "Flagbearer's {0}",
            "{0} of Hope",
        };

        public static Dictionary<int, int> MoraleSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_AID_3, 90},
            {IP_CONST_CASTSPELL_AURAOFGLORY_7, 210},
            {IP_CONST_CASTSPELL_BLESS_2, 30},
            {IP_CONST_CASTSPELL_PRAYER_5, 225},
            {IP_CONST_CASTSPELL_VIRTUE_1, 8},
        };
        #endregion

        #region Demoralizing Spells
        public static List<string> AntimoraleNames = new List<string>
        {
            "Demoralizing {0}",
        };

        public static Dictionary<int, int> AntimoraleSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BANE_5, 75},
            {IP_CONST_CASTSPELL_BESTOW_CURSE_5, 225},
            {IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3, 180},
            {IP_CONST_CASTSPELL_DOOM_2, 30},
            {IP_CONST_CASTSPELL_DOOM_5, 75},
            {IP_CONST_CASTSPELL_FEAR_5, 225},
            {IP_CONST_CASTSPELL_SCARE_2, 30},
        };
        #endregion

        #region Mind Control Spells
        public static List<string> MindControlNames = new List<string>
        {
            "{0} of Persuasion",
            "Mindbending {0}",
        };

        public static Dictionary<int, int> MindControlSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CHARM_MONSTER_10, 450},
            {IP_CONST_CASTSPELL_CHARM_MONSTER_5, 225},
            {IP_CONST_CASTSPELL_CHARM_PERSON_10, 150},
            {IP_CONST_CASTSPELL_CHARM_PERSON_2, 30},
            {IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10, 150},
            {IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3, 30},
            {IP_CONST_CASTSPELL_CONFUSION_10, 450},
            {IP_CONST_CASTSPELL_CONFUSION_5, 225},
            {IP_CONST_CASTSPELL_DAZE_1, 8},
            {IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5, 225},
            {IP_CONST_CASTSPELL_DOMINATE_MONSTER_17, 2295},
            {IP_CONST_CASTSPELL_DOMINATE_PERSON_7, 675},
            {IP_CONST_CASTSPELL_FEEBLEMIND_9, 675},
            {IP_CONST_CASTSPELL_HOLD_ANIMAL_3, 90},
            {IP_CONST_CASTSPELL_HOLD_MONSTER_7, 420},
            {IP_CONST_CASTSPELL_HOLD_PERSON_3, 90},
            {IP_CONST_CASTSPELL_MASS_CHARM_15, 1800},
            {IP_CONST_CASTSPELL_MIND_FOG_9, 675},
            {IP_CONST_CASTSPELL_POWER_WORD_STUN_13, 1800},
            {IP_CONST_CASTSPELL_SLEEP_2, 30},
            {IP_CONST_CASTSPELL_SLEEP_5, 75},
            {IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7, 210},
        };
        #endregion

        #region Perception Spells
        public static List<string> PerceptionNames = new List<string>
        {
            "{0} of Vision",
            "{0} of Knowing",
        };

        public static Dictionary<int, int> PerceptionSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_AMPLIFY_5, 75},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10, 450},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15, 675},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5, 225},
            {IP_CONST_CASTSPELL_DARKVISION_3, 90},
            {IP_CONST_CASTSPELL_DARKVISION_6, 180},
            {IP_CONST_CASTSPELL_FIND_TRAPS_3, 90},
            {IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5, 225},
            {IP_CONST_CASTSPELL_LEGEND_LORE_5, 420},
            {IP_CONST_CASTSPELL_SEE_INVISIBILITY_3, 90},
            {IP_CONST_CASTSPELL_TRUE_SEEING_9, 675},
            {IP_CONST_CASTSPELL_TRUE_STRIKE_5, 75},
        };
        #endregion

        #region Physical Improvement Spells
        public static List<string> PhysicalNames = new List<string>
        {
            "{0} of Vitality",
        };

        public static Dictionary<int, int> PhysicalSpells = new Dictionary<int,int>
        {
            {IP_CONST_CASTSPELL_AURA_OF_VITALITY_13, 1365},
            {IP_CONST_CASTSPELL_BARKSKIN_12, 360},
            {IP_CONST_CASTSPELL_BARKSKIN_3, 90},
            {IP_CONST_CASTSPELL_BARKSKIN_6, 180},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_10, 300},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_15, 450},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_3, 90},
            {IP_CONST_CASTSPELL_CAMOFLAGE_5, 75},
            {IP_CONST_CASTSPELL_CATS_GRACE_10, 300},
            {IP_CONST_CASTSPELL_CATS_GRACE_15, 450},
            {IP_CONST_CASTSPELL_CATS_GRACE_3, 90},
            {IP_CONST_CASTSPELL_ENDURANCE_10, 300},
            {IP_CONST_CASTSPELL_ENDURANCE_15, 450},
            {IP_CONST_CASTSPELL_ENDURANCE_3, 90},
            {IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5, 75},
            {IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9, 405},
            {IP_CONST_CASTSPELL_GREATER_STONESKIN_11, 990},
            {IP_CONST_CASTSPELL_HASTE_10, 450},
            {IP_CONST_CASTSPELL_HASTE_5, 225},
            {IP_CONST_CASTSPELL_IRON_BODY_15, 2295},
            {IP_CONST_CASTSPELL_IRON_BODY_20, 2700},
            {IP_CONST_CASTSPELL_MAGIC_FANG_5, 75},
            {IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13, 780},
            {IP_CONST_CASTSPELL_STONESKIN_7, 420},
        };
        #endregion

        #region Mental Spells
        public static List<string> MentalNames = new List<string>
        {
            "{0} of Thought",
        };

        public static Dictionary<int, int> MentalSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CLARITY_3, 90},    
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10, 300},
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15, 450},
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3, 90},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_10, 300},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_15, 450},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_3, 90},
            {IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9, 675},
            {IP_CONST_CASTSPELL_MIND_BLANK_15, 1800},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_10, 300},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_15, 450},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_3, 90},
        };
        #endregion

        #region Shapechanging Spells
        public static List<string> TransmutNames = new List<string>
        {
            "{0} of Changing",
        };

        public static Dictionary<int, int> Transmutations = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_FLESH_TO_STONE_5, 990},
            {IP_CONST_CASTSPELL_POLYMORPH_SELF_7, 420},
            {IP_CONST_CASTSPELL_SHAPECHANGE_17, 2295},
            {IP_CONST_CASTSPELL_STONE_TO_FLESH_5, 990},
            {IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11, 990},
        };
        #endregion

        #region Antimagic Spells
        public static List<string> AntiMagicNames = new List<string>
        {
            "{0} of Dispelling",
            "{0} of Counterspells",
        };

        public static Dictionary<int, int> AntiMagicSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7, 420},
            {IP_CONST_CASTSPELL_BANISHMENT_15, 1350},
            {IP_CONST_CASTSPELL_DISMISSAL_12, 720},
            {IP_CONST_CASTSPELL_DISMISSAL_18, 1080},
            {IP_CONST_CASTSPELL_DISMISSAL_7, 420},
            {IP_CONST_CASTSPELL_DISPEL_MAGIC_10, 450},
            {IP_CONST_CASTSPELL_DISPEL_MAGIC_5, 225},
            {IP_CONST_CASTSPELL_GREATER_DISPELLING_15, 1350},
            {IP_CONST_CASTSPELL_GREATER_DISPELLING_7, 990},
            {IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11, 990},
            {IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17, 2295},
            {IP_CONST_CASTSPELL_LESSER_DISPEL_3, 90},
            {IP_CONST_CASTSPELL_LESSER_DISPEL_5, 150},
            {IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11, 990},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_15, 900},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_7, 420},
            {IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7, 420},
            {IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9, 675},
            {IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17, 2295},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13, 1560},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20, 2400},
            {IP_CONST_CASTSPELL_SPELL_MANTLE_13, 1365},
            {IP_CONST_CASTSPELL_SPELL_RESISTANCE_15, 1125},
            {IP_CONST_CASTSPELL_SPELL_RESISTANCE_9, 675},
        };
        #endregion

        #region Illusion Spells
        public static List<string> IllusionNames = new List<string>
        {
            "{0} of Illusion",
        };

        public static Dictionary<int, int> IllusionSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_COLOR_SPRAY_2, 30},
            {IP_CONST_CASTSPELL_DISPLACEMENT_9, 405},
            {IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5, 75},
            {IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15, 1350},
            {IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9, 990},
            {IP_CONST_CASTSPELL_ETHEREALNESS_18, 2430},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15, 450},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3, 90},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9, 270},
            {IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9, 1365},
            {IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7, 420},
            {IP_CONST_CASTSPELL_INVISIBILITY_3, 90},
            {IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5, 225},
            {IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13, 1560},
            {IP_CONST_CASTSPELL_SHADOW_CONJURATION_7, 420},
            {IP_CONST_CASTSPELL_WEIRD_17, 2295},
        };
        #endregion

        #region Death Spells
        public static List<string> DeathNames = new List<string>
        {
            "{0} of Death",
        };

        public static Dictionary<int, int> DeathSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11, 990},
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15, 1350},
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20, 1800},
            {IP_CONST_CASTSPELL_CLOUDKILL_9, 675},
            {IP_CONST_CASTSPELL_CONTAGION_5, 225},
            {IP_CONST_CASTSPELL_DESTRUCTION_13, 1365},
            {IP_CONST_CASTSPELL_FINGER_OF_DEATH_13, 1365},
            {IP_CONST_CASTSPELL_ENERGY_DRAIN_17, 2295},
            {IP_CONST_CASTSPELL_ENERVATION_7, 420},
            {IP_CONST_CASTSPELL_GHOUL_TOUCH_3, 90},
            {IP_CONST_CASTSPELL_HARM_11, 990},
            {IP_CONST_CASTSPELL_HORRID_WILTING_15, 1800},
            {IP_CONST_CASTSPELL_HORRID_WILTING_20, 2400},
            {IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12, 720},
            {IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5, 75},
            {IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1, 15},
            {IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7, 210},
            {IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9, 405},
            {IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7, 420},
            {IP_CONST_CASTSPELL_POISON_5, 225},
            {IP_CONST_CASTSPELL_POWER_WORD_KILL_17, 2295},
            {IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2, 30},
            {IP_CONST_CASTSPELL_SLAY_LIVING_9, 675},
            {IP_CONST_CASTSPELL_STINKING_CLOUD_5, 225},
            {IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5, 225},
            {IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17, 2295},
        };
        #endregion

        #region Dark, Evil and Negative Energy Spells
        public static List<string> EvilNames = new List<string>
        {
            "Profane {0}",
            "{0} of Darkness",
            "{0} of Evil",
        };

        public static Dictionary<int, int> EvilSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_10, 450},
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_15, 675},
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_5, 225},
            {IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15, 1800},
            {IP_CONST_CASTSPELL_CONTROL_UNDEAD_13, 1365},
            {IP_CONST_CASTSPELL_CONTROL_UNDEAD_20, 2100},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15, 1800},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16, 1920},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18, 2160},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_11, 990},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_14, 1260},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_16, 1920},
            {IP_CONST_CASTSPELL_DARKNESS_3, 90},
            {IP_CONST_CASTSPELL_GHOUL_TOUCH_3, 90},
            {IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5, 225},
        };
        #endregion

        #region Light and Good Spells
        public static List<string> GoodNames = new List<string>
        {
            "Holy {0}",
            "{0} of Light",
            "{0} of Good",
        };

        public static Dictionary<int, int> GoodSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15, 1800},
            {IP_CONST_CASTSPELL_DIVINE_FAVOR_5, 75},
            {IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12, 720},
            {IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7, 420},
            {IP_CONST_CASTSPELL_LIGHT_1, 8},
            {IP_CONST_CASTSPELL_LIGHT_5, 38},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 15},
            {IP_CONST_CASTSPELL_SUNBEAM_13, 1365},
            {IP_CONST_CASTSPELL_SUNBURST_20, 2400},
            {IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20, 2700},
            {IP_CONST_CASTSPELL_WORD_OF_FAITH_13, 1365},
        };
        #endregion

        #region Protection Spells
        public static List<string> ProtectionNames = new List<string>
        {
            "{0} of Protection",
            "Abjurative {0}",
            "Shielding {0}",
            "Protective {0}",
        };

        public static Dictionary<int, int> ProtectionSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_DEATH_WARD_7, 420},    
            {IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2, 30},
            {IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7, 420},
            {IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11, 990},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_15, 900},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_7, 420},
            {IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5, 225},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2, 30},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5, 75},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10, 450},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3, 225},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 15},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13, 1365},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20, 2100},
            {IP_CONST_CASTSPELL_RESIST_ELEMENTS_10, 300},
            {IP_CONST_CASTSPELL_RESIST_ELEMENTS_3, 90},
            {IP_CONST_CASTSPELL_RESISTANCE_2, 15},
            {IP_CONST_CASTSPELL_RESISTANCE_5, 38},
            {IP_CONST_CASTSPELL_SANCTUARY_2, 30},
            {IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5, 75},
        };
        #endregion

        #region Healing Spells
        public static List<string> HealingNames = new List<string>
        {
            "{0} of Healing",
        };

        public static Dictionary<int, int> HealingSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12, 720},
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15, 900},
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7, 420},
            {IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2, 30},
            {IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5, 75},
            {IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1, 8},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10, 300},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3, 90},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6, 180},
            {IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10, 450},
            {IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5, 225},
            {IP_CONST_CASTSPELL_GREATER_RESTORATION_13, 1365},
            {IP_CONST_CASTSPELL_HEAL_11, 990},
            {IP_CONST_CASTSPELL_HEALING_CIRCLE_16, 1200},
            {IP_CONST_CASTSPELL_HEALING_CIRCLE_9, 675},
            {IP_CONST_CASTSPELL_LESSER_RESTORATION_3, 90},
            {IP_CONST_CASTSPELL_MASS_HEAL_15, 1800},
            {IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5, 225},
            {IP_CONST_CASTSPELL_REGENERATE_13, 1365},
            {IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5, 225},
            {IP_CONST_CASTSPELL_REMOVE_CURSE_5, 225},
            {IP_CONST_CASTSPELL_REMOVE_DISEASE_5, 225},
            {IP_CONST_CASTSPELL_REMOVE_FEAR_2, 30},
            {IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3, 90},
            {IP_CONST_CASTSPELL_RESTORATION_7, 420},
        };
        #endregion

        #region Summoning Spells
        public static List<string> SummonNames = new List<string>
        {
            "{0} of Summoning",
        };

        public static Dictionary<int, int> SummonSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15, 1800},
            {IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9, 675},
            {IP_CONST_CASTSPELL_PLANAR_ALLY_15, 1800},
            {IP_CONST_CASTSPELL_PLANAR_BINDING_11, 990},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2, 30},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5, 75},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3, 90},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5, 225},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7, 420},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17, 2295},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9, 675},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11, 990},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13, 1365},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15, 1800},
        };
        #endregion

        #region Copying Methods
        public static void copyDictionary(Dictionary<int, int> from, Dictionary<int, int> to)
        {
            foreach(KeyValuePair<int, int> item in from)
            {
                to.Add(item.Key, item.Value);
            }
        }

        public static void copyList(List<string> from, List<string> to)
        {
            foreach (string item in from)
            {
                to.Add(item);
            }
        }
        #endregion
    }
}

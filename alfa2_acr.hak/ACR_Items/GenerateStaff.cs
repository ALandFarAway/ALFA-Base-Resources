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
            #region Check if collections need to be loaded. Load them if so
            if (FireSpells.Count == 0)
            {
                convertToStaffPrice(FireSpells);
                convertToStaffPrice(ColdSpells);
                convertToStaffPrice(AcidSpells);
                convertToStaffPrice(ElectricSpells);
                convertToStaffPrice(SoundSpells);
                convertToStaffPrice(PhysicalAttackSpells);
                convertToStaffPrice(ForceSpells);
                convertToStaffPrice(MoraleSpells);
                convertToStaffPrice(AntimoraleSpells);
                convertToStaffPrice(MindControlSpells);
                convertToStaffPrice(PerceptionSpells);
                convertToStaffPrice(PhysicalSpells);
                convertToStaffPrice(MentalSpells);
                convertToStaffPrice(Transmutations);
                convertToStaffPrice(AntiMagicSpells);
                convertToStaffPrice(IllusionSpells);
                convertToStaffPrice(DeathSpells);
                convertToStaffPrice(EvilSpells);
                convertToStaffPrice(GoodSpells);
                convertToStaffPrice(ProtectionSpells);
                convertToStaffPrice(HealingSpells);
                convertToStaffPrice(SummonSpells);
            }
            #endregion

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
            List<int> classRestrictions = new List<int>();
            foreach (KeyValuePair<int, int> Spell in SelectedSpells)
            {
                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyCastSpell(Spell.Key, Spell.Value), staff, 0.0f);
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.BardLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_BARD))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_BARD);
                }
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.ClericLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_CLERIC))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC), staff, 0.0f);
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_FAVORED_SOUL), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_CLERIC);
                }
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.DruidLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_DRUID))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID), staff, 0.0f);
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_SPIRIT_SHAMAN), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_DRUID);
                }
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.WizardLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_WIZARD))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD), staff, 0.0f);
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_SORCERER), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_WIZARD);
                }
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.PaladinLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_PALADIN))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_PALADIN);
                }
                if (ALFA.Shared.Modules.InfoStore.IPCastSpells[Spell.Key].Spell.RangerLevel >= 0 &&
                    !classRestrictions.Contains(IP_CONST_CLASS_RANGER))
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER), staff, 0.0f);
                    classRestrictions.Add(IP_CONST_CLASS_RANGER);
                }
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
            {IP_CONST_CASTSPELL_BURNING_HANDS_2, 0},
            {IP_CONST_CASTSPELL_BURNING_HANDS_5, 0},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_13, 0},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_15, 0},
            {IP_CONST_CASTSPELL_DELAYED_BLAST_FIREBALL_20, 0},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12, 0},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7, 0},
            {IP_CONST_CASTSPELL_FIRE_STORM_13, 0},
            {IP_CONST_CASTSPELL_FIRE_STORM_18, 0},
            {IP_CONST_CASTSPELL_FIREBALL_10, 0},
            {IP_CONST_CASTSPELL_FIREBALL_5, 0},
            {IP_CONST_CASTSPELL_FIREBRAND_15, 0},
            {IP_CONST_CASTSPELL_FLAME_ARROW_12, 0},
            {IP_CONST_CASTSPELL_FLAME_ARROW_18, 0},
            {IP_CONST_CASTSPELL_FLAME_ARROW_5, 0},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_12, 0},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_18, 0},
            {IP_CONST_CASTSPELL_FLAME_STRIKE_7, 0},
            {IP_CONST_CASTSPELL_FLARE_1, 0},
            {IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15, 0},
            {IP_CONST_CASTSPELL_INFERNO_15, 0},
            {IP_CONST_CASTSPELL_WALL_OF_FIRE_9, 0},
        };
        #endregion

        #region Cold Spells
        public static List<string> ColdNames = new List<string>
        {
            "{0} of Cold",
        };

        public static Dictionary<int, int> ColdSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CONE_OF_COLD_15, 0},
            {IP_CONST_CASTSPELL_CONE_OF_COLD_9, 0},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_12, 0},
            {IP_CONST_CASTSPELL_ELEMENTAL_SHIELD_7, 0},
            {IP_CONST_CASTSPELL_ICE_STORM_9, 0},
            {IP_CONST_CASTSPELL_RAY_OF_FROST_1, 0},
        };
        #endregion

        #region Acid Spells
        public static List<string> AcidNames = new List<string>
        {
            "{0} of Acid",
        };

        public static Dictionary<int, int> AcidSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_ACID_FOG_11, 0},
            {IP_CONST_CASTSPELL_ACID_SPLASH_1, 0},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_3, 0},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_6, 0},
            {IP_CONST_CASTSPELL_MELFS_ACID_ARROW_9, 0},
        };
        #endregion

        #region Electric Spells
        public static List<string> ElectricNames = new List<string>
        {
            "{0} of Lightning",
        };

        public static Dictionary<int, int> ElectricSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CALL_LIGHTNING_10, 0},
            {IP_CONST_CASTSPELL_CALL_LIGHTNING_5, 0},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_11, 0},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_15, 0},
            {IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20, 0},
            {IP_CONST_CASTSPELL_ELECTRIC_JOLT_1, 0},
            {IP_CONST_CASTSPELL_LIGHTNING_BOLT_10, 0},
            {IP_CONST_CASTSPELL_LIGHTNING_BOLT_5, 0},
            {IP_CONST_CASTSPELL_SCINTILLATING_SPHERE_5, 0},
        };
        #endregion

        #region Sound Spells
        public static List<string> SoundNames = new List<string>
        {
            "{0} of Sound",
        };

        public static Dictionary<int, int> SoundSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BALAGARNSIRONHORN_7, 0},
            {IP_CONST_CASTSPELL_SOUND_BURST_3, 0},
        };
        #endregion

        #region Physical Attacks
        public static List<string> PhysicalAttackNames = new List<string>
        {
            "{0} of Creation",
        };
        public static Dictionary<int, int> PhysicalAttackSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BLADE_BARRIER_11, 0},
            {IP_CONST_CASTSPELL_BLADE_BARRIER_15, 0},
            {IP_CONST_CASTSPELL_BOMBARDMENT_20, 0},
            {IP_CONST_CASTSPELL_EARTHQUAKE_20, 0},
            {IP_CONST_CASTSPELL_ENTANGLE_2, 0},
            {IP_CONST_CASTSPELL_ENTANGLE_5, 0},
            {IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_15, 0},
            {IP_CONST_CASTSPELL_EVARDS_BLACK_TENTACLES_7, 0},
            {IP_CONST_CASTSPELL_GREASE_2, 0},
            {IP_CONST_CASTSPELL_GUST_OF_WIND_10, 0},
            {IP_CONST_CASTSPELL_IMPLOSION_17, 0},
            {IP_CONST_CASTSPELL_METEOR_SWARM_17, 0},
            {IP_CONST_CASTSPELL_WEB_3, 0},
        };
        #endregion

        #region Force Spells
        public static List<string> ForceNames = new List<string>
        {
            "{0} of Force",
        };

        public static Dictionary<int, int> ForceSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BIGBYS_CLENCHED_FIST_20, 0},
            {IP_CONST_CASTSPELL_BIGBYS_CRUSHING_HAND_20, 0},
            {IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15, 0},
            {IP_CONST_CASTSPELL_BIGBYS_GRASPING_HAND_17, 0},
            {IP_CONST_CASTSPELL_BIGBYS_INTERPOSING_HAND_15, 0},
            {IP_CONST_CASTSPELL_IMPROVED_MAGE_ARMOR_10, 0},
            {IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15, 0},
            {IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13, 0},
            {IP_CONST_CASTSPELL_KNOCK_3, 0},
            {IP_CONST_CASTSPELL_MAGE_ARMOR_2, 0},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_3, 0},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_5, 0},
            {IP_CONST_CASTSPELL_MAGIC_MISSILE_9, 0},
            {IP_CONST_CASTSPELL_SHIELD_5, 0},
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
            {IP_CONST_CASTSPELL_AID_3, 0},
            {IP_CONST_CASTSPELL_AURAOFGLORY_7, 0},
            {IP_CONST_CASTSPELL_BLESS_2, 0},
            {IP_CONST_CASTSPELL_PRAYER_5, 0},
            {IP_CONST_CASTSPELL_VIRTUE_1, 0},
        };
        #endregion

        #region Demoralizing Spells
        public static List<string> AntimoraleNames = new List<string>
        {
            "Demoralizing {0}",
        };

        public static Dictionary<int, int> AntimoraleSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_BANE_5, 0},
            {IP_CONST_CASTSPELL_BESTOW_CURSE_5, 0},
            {IP_CONST_CASTSPELL_BLINDNESS_DEAFNESS_3, 0},
            {IP_CONST_CASTSPELL_DOOM_2, 0},
            {IP_CONST_CASTSPELL_DOOM_5, 0},
            {IP_CONST_CASTSPELL_FEAR_5, 0},
            {IP_CONST_CASTSPELL_SCARE_2, 0},
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
            {IP_CONST_CASTSPELL_CHARM_MONSTER_10, 0},
            {IP_CONST_CASTSPELL_CHARM_MONSTER_5, 0},
            {IP_CONST_CASTSPELL_CHARM_PERSON_10, 0},
            {IP_CONST_CASTSPELL_CHARM_PERSON_2, 0},
            {IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_10, 0},
            {IP_CONST_CASTSPELL_CHARM_PERSON_OR_ANIMAL_3, 0},
            {IP_CONST_CASTSPELL_CONFUSION_10, 0},
            {IP_CONST_CASTSPELL_CONFUSION_5, 0},
            {IP_CONST_CASTSPELL_DAZE_1, 0},
            {IP_CONST_CASTSPELL_DOMINATE_ANIMAL_5, 0},
            {IP_CONST_CASTSPELL_DOMINATE_MONSTER_17, 0},
            {IP_CONST_CASTSPELL_DOMINATE_PERSON_7, 0},
            {IP_CONST_CASTSPELL_FEEBLEMIND_9, 0},
            {IP_CONST_CASTSPELL_HOLD_ANIMAL_3, 0},
            {IP_CONST_CASTSPELL_HOLD_MONSTER_7, 0},
            {IP_CONST_CASTSPELL_HOLD_PERSON_3, 0},
            {IP_CONST_CASTSPELL_MASS_CHARM_15, 0},
            {IP_CONST_CASTSPELL_MIND_FOG_9, 0},
            {IP_CONST_CASTSPELL_POWER_WORD_STUN_13, 0},
            {IP_CONST_CASTSPELL_SLEEP_2, 0},
            {IP_CONST_CASTSPELL_SLEEP_5, 0},
            {IP_CONST_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER_7, 0},
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
            {IP_CONST_CASTSPELL_AMPLIFY_5, 0},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_10, 0},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_15, 0},
            {IP_CONST_CASTSPELL_CLAIRAUDIENCE_CLAIRVOYANCE_5, 0},
            {IP_CONST_CASTSPELL_DARKVISION_3, 0},
            {IP_CONST_CASTSPELL_DARKVISION_6, 0},
            {IP_CONST_CASTSPELL_FIND_TRAPS_3, 0},
            {IP_CONST_CASTSPELL_INVISIBILITY_PURGE_5, 0},
            {IP_CONST_CASTSPELL_LEGEND_LORE_5, 0},
            {IP_CONST_CASTSPELL_SEE_INVISIBILITY_3, 0},
            {IP_CONST_CASTSPELL_TRUE_SEEING_9, 0},
            {IP_CONST_CASTSPELL_TRUE_STRIKE_5, 0},
        };
        #endregion

        #region Physical Improvement Spells
        public static List<string> PhysicalNames = new List<string>
        {
            "{0} of Vitality",
        };

        public static Dictionary<int, int> PhysicalSpells = new Dictionary<int,int>
        {
            {IP_CONST_CASTSPELL_AURA_OF_VITALITY_13, 0},
            {IP_CONST_CASTSPELL_BARKSKIN_12, 0},
            {IP_CONST_CASTSPELL_BARKSKIN_3, 0},
            {IP_CONST_CASTSPELL_BARKSKIN_6, 0},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_10, 0},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_15, 0},
            {IP_CONST_CASTSPELL_BULLS_STRENGTH_3, 0},
            {IP_CONST_CASTSPELL_CAMOFLAGE_5, 0},
            {IP_CONST_CASTSPELL_CATS_GRACE_10, 0},
            {IP_CONST_CASTSPELL_CATS_GRACE_15, 0},
            {IP_CONST_CASTSPELL_CATS_GRACE_3, 0},
            {IP_CONST_CASTSPELL_ENDURANCE_10, 0},
            {IP_CONST_CASTSPELL_ENDURANCE_15, 0},
            {IP_CONST_CASTSPELL_ENDURANCE_3, 0},
            {IP_CONST_CASTSPELL_EXPEDITIOUS_RETREAT_5, 0},
            {IP_CONST_CASTSPELL_GREATER_MAGIC_FANG_9, 0},
            {IP_CONST_CASTSPELL_GREATER_STONESKIN_11, 0},
            {IP_CONST_CASTSPELL_HASTE_10, 0},
            {IP_CONST_CASTSPELL_HASTE_5, 0},
            {IP_CONST_CASTSPELL_IRON_BODY_15, 0},
            {IP_CONST_CASTSPELL_IRON_BODY_20, 0},
            {IP_CONST_CASTSPELL_MAGIC_FANG_5, 0},
            {IP_CONST_CASTSPELL_MASS_CAMOFLAGE_13, 0},
            {IP_CONST_CASTSPELL_STONESKIN_7, 0},
        };
        #endregion

        #region Mental Spells
        public static List<string> MentalNames = new List<string>
        {
            "{0} of Thought",
        };

        public static Dictionary<int, int> MentalSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CLARITY_3, 0},    
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_10, 0},
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_15, 0},
            {IP_CONST_CASTSPELL_EAGLE_SPLEDOR_3, 0},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_10, 0},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_15, 0},
            {IP_CONST_CASTSPELL_FOXS_CUNNING_3, 0},
            {IP_CONST_CASTSPELL_LESSER_MIND_BLANK_9, 0},
            {IP_CONST_CASTSPELL_MIND_BLANK_15, 0},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_10, 0},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_15, 0},
            {IP_CONST_CASTSPELL_OWLS_WISDOM_3, 0},
        };
        #endregion

        #region Shapechanging Spells
        public static List<string> TransmutNames = new List<string>
        {
            "{0} of Changing",
        };

        public static Dictionary<int, int> Transmutations = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_FLESH_TO_STONE_5, 0},
            {IP_CONST_CASTSPELL_POLYMORPH_SELF_7, 0},
            {IP_CONST_CASTSPELL_SHAPECHANGE_17, 0},
            {IP_CONST_CASTSPELL_STONE_TO_FLESH_5, 0},
            {IP_CONST_CASTSPELL_TENSERS_TRANSFORMATION_11, 0},
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
            {IP_CONST_CASTSPELL_ASSAY_RESISTANCE_7, 0},
            {IP_CONST_CASTSPELL_BANISHMENT_15, 0},
            {IP_CONST_CASTSPELL_DISMISSAL_12, 0},
            {IP_CONST_CASTSPELL_DISMISSAL_18, 0},
            {IP_CONST_CASTSPELL_DISMISSAL_7, 0},
            {IP_CONST_CASTSPELL_DISPEL_MAGIC_10, 0},
            {IP_CONST_CASTSPELL_DISPEL_MAGIC_5, 0},
            {IP_CONST_CASTSPELL_GREATER_DISPELLING_15, 0},
            {IP_CONST_CASTSPELL_GREATER_DISPELLING_7, 0},
            {IP_CONST_CASTSPELL_GREATER_SPELL_BREACH_11, 0},
            {IP_CONST_CASTSPELL_GREATER_SPELL_MANTLE_17, 0},
            {IP_CONST_CASTSPELL_LESSER_DISPEL_3, 0},
            {IP_CONST_CASTSPELL_LESSER_DISPEL_5, 0},
            {IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11, 0},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_15, 0},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_7, 0},
            {IP_CONST_CASTSPELL_LESSER_SPELL_BREACH_7, 0},
            {IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9, 0},
            {IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20, 0},
            {IP_CONST_CASTSPELL_SPELL_MANTLE_13, 0},
            {IP_CONST_CASTSPELL_SPELL_RESISTANCE_15, 0},
            {IP_CONST_CASTSPELL_SPELL_RESISTANCE_9, 0},
        };
        #endregion

        #region Illusion Spells
        public static List<string> IllusionNames = new List<string>
        {
            "{0} of Illusion",
        };

        public static Dictionary<int, int> IllusionSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_COLOR_SPRAY_2, 0},
            {IP_CONST_CASTSPELL_DISPLACEMENT_9, 0},
            {IP_CONST_CASTSPELL_ENTROPIC_SHIELD_5, 0},
            {IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15, 0},
            {IP_CONST_CASTSPELL_ETHEREAL_VISAGE_9, 0},
            {IP_CONST_CASTSPELL_ETHEREALNESS_18, 0},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_15, 0},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3, 0},
            {IP_CONST_CASTSPELL_GHOSTLY_VISAGE_9, 0},
            {IP_CONST_CASTSPELL_GREATER_SHADOW_CONJURATION_9, 0},
            {IP_CONST_CASTSPELL_IMPROVED_INVISIBILITY_7, 0},
            {IP_CONST_CASTSPELL_INVISIBILITY_3, 0},
            {IP_CONST_CASTSPELL_INVISIBILITY_SPHERE_5, 0},
            {IP_CONST_CASTSPELL_PRISMATIC_SPRAY_13, 0},
            {IP_CONST_CASTSPELL_SHADOW_CONJURATION_7, 0},
            {IP_CONST_CASTSPELL_WEIRD_17, 0},
        };
        #endregion

        #region Death Spells
        public static List<string> DeathNames = new List<string>
        {
            "{0} of Death",
        };

        public static Dictionary<int, int> DeathSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_11, 0},
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_15, 0},
            {IP_CONST_CASTSPELL_CIRCLE_OF_DEATH_20, 0},
            {IP_CONST_CASTSPELL_CLOUDKILL_9, 0},
            {IP_CONST_CASTSPELL_CONTAGION_5, 0},
            {IP_CONST_CASTSPELL_DESTRUCTION_13, 0},
            {IP_CONST_CASTSPELL_FINGER_OF_DEATH_13, 0},
            {IP_CONST_CASTSPELL_ENERGY_DRAIN_17, 0},
            {IP_CONST_CASTSPELL_ENERVATION_7, 0},
            {IP_CONST_CASTSPELL_GHOUL_TOUCH_3, 0},
            {IP_CONST_CASTSPELL_HARM_11, 0},
            {IP_CONST_CASTSPELL_HORRID_WILTING_15, 0},
            {IP_CONST_CASTSPELL_HORRID_WILTING_20, 0},
            {IP_CONST_CASTSPELL_INFLICT_CRITICAL_WOUNDS_12, 0},
            {IP_CONST_CASTSPELL_INFLICT_LIGHT_WOUNDS_5, 0},
            {IP_CONST_CASTSPELL_INFLICT_MINOR_WOUNDS_1, 0},
            {IP_CONST_CASTSPELL_INFLICT_MODERATE_WOUNDS_7, 0},
            {IP_CONST_CASTSPELL_INFLICT_SERIOUS_WOUNDS_9, 0},
            {IP_CONST_CASTSPELL_PHANTASMAL_KILLER_7, 0},
            {IP_CONST_CASTSPELL_POISON_5, 0},
            {IP_CONST_CASTSPELL_POWER_WORD_KILL_17, 0},
            {IP_CONST_CASTSPELL_RAY_OF_ENFEEBLEMENT_2, 0},
            {IP_CONST_CASTSPELL_SLAY_LIVING_9, 0},
            {IP_CONST_CASTSPELL_STINKING_CLOUD_5, 0},
            {IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5, 0},
            {IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17, 0},
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
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_10, 0},
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_15, 0},
            {IP_CONST_CASTSPELL_ANIMATE_DEAD_5, 0},
            {IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15, 0},
            {IP_CONST_CASTSPELL_CONTROL_UNDEAD_13, 0},
            {IP_CONST_CASTSPELL_CONTROL_UNDEAD_20, 0},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_15, 0},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_16, 0},
            {IP_CONST_CASTSPELL_CREATE_GREATER_UNDEAD_18, 0},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_11, 0},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_14, 0},
            {IP_CONST_CASTSPELL_CREATE_UNDEAD_16, 0},
            {IP_CONST_CASTSPELL_DARKNESS_3, 0},
            {IP_CONST_CASTSPELL_GHOUL_TOUCH_3, 0},
            {IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5, 0},
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
            {IP_CONST_CASTSPELL_AURA_VERSUS_ALIGNMENT_15, 0},
            {IP_CONST_CASTSPELL_DIVINE_FAVOR_5, 0},
            {IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12, 0},
            {IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_7, 0},
            {IP_CONST_CASTSPELL_LIGHT_1, 0},
            {IP_CONST_CASTSPELL_LIGHT_5, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 0},
            {IP_CONST_CASTSPELL_SUNBEAM_13, 0},
            {IP_CONST_CASTSPELL_SUNBURST_20, 0},
            {IP_CONST_CASTSPELL_UNDEATHS_ETERNAL_FOE_20, 0},
            {IP_CONST_CASTSPELL_WORD_OF_FAITH_13, 0},
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
            {IP_CONST_CASTSPELL_DEATH_WARD_7, 0},    
            {IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2, 0},
            {IP_CONST_CASTSPELL_FREEDOM_OF_MOVEMENT_7, 0},
            {IP_CONST_CASTSPELL_GLOBE_OF_INVULNERABILITY_11, 0},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_15, 0},
            {IP_CONST_CASTSPELL_LESSER_GLOBE_OF_INVULNERABILITY_7, 0},
            {IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_2, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_10, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_ELEMENTS_3, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_EVIL_1, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_13, 0},
            {IP_CONST_CASTSPELL_PROTECTION_FROM_SPELLS_20, 0},
            {IP_CONST_CASTSPELL_RESIST_ELEMENTS_10, 0},
            {IP_CONST_CASTSPELL_RESIST_ELEMENTS_3, 0},
            {IP_CONST_CASTSPELL_RESISTANCE_2, 0},
            {IP_CONST_CASTSPELL_RESISTANCE_5, 0},
            {IP_CONST_CASTSPELL_SANCTUARY_2, 0},
            {IP_CONST_CASTSPELL_SHIELD_OF_FAITH_5, 0},
        };
        #endregion

        #region Healing Spells
        public static List<string> HealingNames = new List<string>
        {
            "{0} of Healing",
        };

        public static Dictionary<int, int> HealingSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12, 0},
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_15, 0},
            {IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_7, 0},
            {IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_2, 0},
            {IP_CONST_CASTSPELL_CURE_LIGHT_WOUNDS_5, 0},
            {IP_CONST_CASTSPELL_CURE_MINOR_WOUNDS_1, 0},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_10, 0},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_3, 0},
            {IP_CONST_CASTSPELL_CURE_MODERATE_WOUNDS_6, 0},
            {IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_10, 0},
            {IP_CONST_CASTSPELL_CURE_SERIOUS_WOUNDS_5, 0},
            {IP_CONST_CASTSPELL_GREATER_RESTORATION_13, 0},
            {IP_CONST_CASTSPELL_HEAL_11, 0},
            {IP_CONST_CASTSPELL_HEALING_CIRCLE_16, 0},
            {IP_CONST_CASTSPELL_HEALING_CIRCLE_9, 0},
            {IP_CONST_CASTSPELL_LESSER_RESTORATION_3, 0},
            {IP_CONST_CASTSPELL_MASS_HEAL_15, 0},
            {IP_CONST_CASTSPELL_NEUTRALIZE_POISON_5, 0},
            {IP_CONST_CASTSPELL_REGENERATE_13, 0},
            {IP_CONST_CASTSPELL_REMOVE_BLINDNESS_DEAFNESS_5, 0},
            {IP_CONST_CASTSPELL_REMOVE_CURSE_5, 0},
            {IP_CONST_CASTSPELL_REMOVE_DISEASE_5, 0},
            {IP_CONST_CASTSPELL_REMOVE_FEAR_2, 0},
            {IP_CONST_CASTSPELL_REMOVE_PARALYSIS_3, 0},
            {IP_CONST_CASTSPELL_RESTORATION_7, 0},
        };
        #endregion

        #region Summoning Spells
        public static List<string> SummonNames = new List<string>
        {
            "{0} of Summoning",
        };

        public static Dictionary<int, int> SummonSpells = new Dictionary<int, int>
        {
            {IP_CONST_CASTSPELL_GREATER_PLANAR_BINDING_15, 0},
            {IP_CONST_CASTSPELL_LESSER_PLANAR_BINDING_9, 0},
            {IP_CONST_CASTSPELL_PLANAR_ALLY_15, 0},
            {IP_CONST_CASTSPELL_PLANAR_BINDING_11, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_I_2, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_IV_7, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_IX_17, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_V_9, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VI_11, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VII_13, 0},
            {IP_CONST_CASTSPELL_SUMMON_CREATURE_VIII_15, 0},
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

        private static void convertToStaffPrice(Dictionary<int, int> dict)
        {
            Dictionary<int, int> newDict = new Dictionary<int, int>();
            foreach (int ip in dict.Keys)
            {
                newDict.Add(ip, 15 * ALFA.Shared.Modules.InfoStore.IPCastSpells[ip].CasterLevel * ALFA.Shared.Modules.InfoStore.IPCastSpells[ip].InnateLevel);
            }
            dict = newDict;
        }
        #endregion
    }
}

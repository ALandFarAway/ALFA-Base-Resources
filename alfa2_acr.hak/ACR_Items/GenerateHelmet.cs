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
    public class GenerateHelmet : CLRScriptBase
    {
        public static int NewHelmet(CLRScriptBase script, int maxValue)
        {
            List<int> potentialAbilities = new List<int>();
            foreach (KeyValuePair<int, int> ability in AvailableAbilities)
            {
                if (ability.Value <= maxValue)
                {
                    potentialAbilities.Add(ability.Key);
                }
            }
            if (potentialAbilities.Count == 0)
            {
                return 0;
            }
            int selectedAbility = potentialAbilities[Generation.rand.Next(potentialAbilities.Count)];
            uint helmet = script.CreateItemOnObject("zitem_helm2", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Helmets of Ability Scores
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = AvailableAbilityScores[Generation.rand.Next(AvailableAbilityScores.Count)];
                        string name = AbilityScoreNames[abilityScore];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +6");
                            Pricing.CalculatePrice(script, helmet);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +5");
                            Pricing.CalculatePrice(script, helmet);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +4");
                            Pricing.CalculatePrice(script, helmet);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +3");
                            Pricing.CalculatePrice(script, helmet);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +2");
                            Pricing.CalculatePrice(script, helmet);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " +1");
                            Pricing.CalculatePrice(script, helmet);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Helmets with Bonus Feats
                case ITEM_PROPERTY_BONUS_FEAT:
                    {
                        List<int> possibleFeats = new List<int>();
                        foreach (KeyValuePair<int, int> feat in AvailableFeats)
                        {
                            if (feat.Value <= maxValue)
                            {
                                possibleFeats.Add(feat.Key);
                            }
                        }
                        if (possibleFeats.Count == 0)
                        {
                            return 0;
                        }
                        int selectedFeat = possibleFeats[Generation.rand.Next(possibleFeats.Count)];
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(selectedFeat), helmet, 0.0f);
                        script.SetFirstName(helmet, FeatNames[selectedFeat]);
                        Pricing.CalculatePrice(script, helmet);
                        return AvailableFeats[selectedFeat];
                    }
                #endregion
                #region Bonus Spell Slots
                case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
                    {
                        int bonusType = AvailableBonusSpells[Generation.rand.Next(AvailableBonusSpells.Count)];
                        string name = BonusSpellNames[bonusType];
                        if (maxValue >= 81000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_9), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " IX");
                            Pricing.CalculatePrice(script, helmet);
                            return 81000;
                        }
                        else if (maxValue >= 64000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_8), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " VIII");
                            Pricing.CalculatePrice(script, helmet);
                            return 64000;
                        }
                        else if (maxValue >= 49000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_7), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " VII");
                            Pricing.CalculatePrice(script, helmet);
                            return 49000;
                        }
                        else if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_6), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " VI");
                            Pricing.CalculatePrice(script, helmet);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_5), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " V");
                            Pricing.CalculatePrice(script, helmet);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_4), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " IV");
                            Pricing.CalculatePrice(script, helmet);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_3), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " III");
                            Pricing.CalculatePrice(script, helmet);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_2), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " II");
                            Pricing.CalculatePrice(script, helmet);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_1), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " I");
                            Pricing.CalculatePrice(script, helmet);
                            return 1000;
                        }
                        else if (maxValue >= 500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_0), helmet, 0.0f);
                            script.SetFirstName(helmet, name + " 0");
                            Pricing.CalculatePrice(script, helmet);
                            return 500;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Immunities
                case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
                    {
                        List<int> possibleImmunities = new List<int>();
                        foreach (KeyValuePair<int, int> immunity in AvailableImmunities)
                        {
                            if (immunity.Value <= maxValue)
                            {
                                possibleImmunities.Add(immunity.Key);
                            }
                        }
                        if (possibleImmunities.Count == 0)
                        {
                            return 0;
                        }
                        int selectedImmunity = possibleImmunities[Generation.rand.Next(possibleImmunities.Count)];
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), helmet, 0.0f);
                        script.SetFirstName(helmet, ImmunityNames[selectedImmunity]);
                        Pricing.CalculatePrice(script, helmet);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Saving Throws vs. Specific
                case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                    {
                        int saveType = AvailableSaveTypes[Generation.rand.Next(AvailableSaveTypes.Count)];
                        script.SetFirstName(helmet, SaveTypeNames[saveType]);
                        if (maxValue >= 6250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 5), helmet, 0.0f);
                            script.SetFirstName(helmet, String.Format("{0} +5", script.GetName(helmet)));
                            Pricing.CalculatePrice(script, helmet);
                            return 6250;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 4), helmet, 0.0f);
                            script.SetFirstName(helmet, String.Format("{0} +4", script.GetName(helmet)));
                            Pricing.CalculatePrice(script, helmet);
                            return 4000;
                        }
                        else if (maxValue >= 2250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 3), helmet, 0.0f);
                            script.SetFirstName(helmet, String.Format("{0} +3", script.GetName(helmet)));
                            Pricing.CalculatePrice(script, helmet);
                            return 2250;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 2), helmet, 0.0f);
                            script.SetFirstName(helmet, String.Format("{0} +2", script.GetName(helmet)));
                            Pricing.CalculatePrice(script, helmet);
                            return 1000;
                        }
                        else if (maxValue >= 250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 1), helmet, 0.0f);
                            script.SetFirstName(helmet, String.Format("{0} +1", script.GetName(helmet)));
                            Pricing.CalculatePrice(script, helmet);
                            return 250;
                        }
                        break;
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(helmet, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +10");
                            Pricing.CalculatePrice(script, helmet);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +9");
                            Pricing.CalculatePrice(script, helmet);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +8");
                            Pricing.CalculatePrice(script, helmet);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +7");
                            Pricing.CalculatePrice(script, helmet);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +6");
                            Pricing.CalculatePrice(script, helmet);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +5");
                            Pricing.CalculatePrice(script, helmet);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +4");
                            Pricing.CalculatePrice(script, helmet);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +3");
                            Pricing.CalculatePrice(script, helmet);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +2");
                            Pricing.CalculatePrice(script, helmet);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), helmet, 0.0f);
                            script.SetFirstName(helmet, script.GetName(helmet) + " +1");
                            Pricing.CalculatePrice(script, helmet);
                            return 100;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            script.DestroyObject(helmet, 0.0f, FALSE);
            return 0;
        }

        #region Ability Categories
        public static Dictionary<int, int> AvailableAbilities = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_BONUS_FEAT, 5000},
            {ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, 500},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 10000},
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, 250},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
        };

        public static Dictionary<int, string> AbilityNames = new Dictionary<int, string>
        {
            {ITEM_PROPERTY_ABILITY_BONUS, "" },
            {ITEM_PROPERTY_BONUS_FEAT, "" },
            {ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, "" },
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, "" },
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, "" },
            {ITEM_PROPERTY_SKILL_BONUS, "" },
        };
        #endregion

        #region Ability Scores
        static List<int> AvailableAbilityScores = new List<int>
        {
            IP_CONST_ABILITY_CHA,
            IP_CONST_ABILITY_INT,
            IP_CONST_ABILITY_WIS,
        };

        static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_CHA, "Helmet of Charm" },
            {IP_CONST_ABILITY_INT, "Helmet of Wit" },
            {IP_CONST_ABILITY_WIS, "Helmet of Insight" },
        };
        #endregion

        #region Immunities
        public static Dictionary<int, int> AvailableImmunities = new Dictionary<int, int>
        {
            {IP_CONST_IMMUNITYMISC_FEAR, 10000},
        };

        public static Dictionary<int, string> ImmunityNames = new Dictionary<int, string>
        {
            {IP_CONST_IMMUNITYMISC_FEAR, "Helmet of Fearlessness" },
        };
        #endregion

        #region Bonus Feats
        public static Dictionary<int, int> AvailableFeats = new Dictionary<int, int>
        {
            {IP_CONST_FEAT_COMBAT_CASTING, 5000},
        };

        public static Dictionary<int, string> FeatNames = new Dictionary<int, string>
        {
            {IP_CONST_FEAT_COMBAT_CASTING, "Helmet of the Battlemage" },
        };
        #endregion

        #region Bonus Spell Classes
        public static List<int> AvailableBonusSpells = new List<int>
        {
            IP_CONST_CLASS_BARD,
            IP_CONST_CLASS_CLERIC,
            IP_CONST_CLASS_DRUID,
            IP_CONST_CLASS_FAVORED_SOUL,
            IP_CONST_CLASS_PALADIN,
            IP_CONST_CLASS_RANGER,
            IP_CONST_CLASS_SORCERER,
            IP_CONST_CLASS_SPIRIT_SHAMAN,
            IP_CONST_CLASS_WIZARD,
        };

        public static Dictionary<int, string> BonusSpellNames = new Dictionary<int, string>
        {
            {IP_CONST_CLASS_BARD, "Helmet of Poetry" },
            {IP_CONST_CLASS_CLERIC, "Helmet of Ministry" },
            {IP_CONST_CLASS_DRUID, "Helmet of Nature" },
            {IP_CONST_CLASS_FAVORED_SOUL, "Helmet of Favor" },
            {IP_CONST_CLASS_PALADIN, "Helmet of Holiness" },
            {IP_CONST_CLASS_RANGER, "Helmet of Hunting" },
            {IP_CONST_CLASS_SORCERER, "Helmet of Sorcery" },
            {IP_CONST_CLASS_SPIRIT_SHAMAN, "Helmet of Shamanism" },
            {IP_CONST_CLASS_WIZARD, "Helmet of Wizardry" },
        };
        #endregion

        #region Skills
        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_APPRAISE,
            SKILL_BLUFF,
            SKILL_CONCENTRATION,
            SKILL_DECIPHER_SCRIPT,
            SKILL_DIPLOMACY,
            SKILL_DISGUISE,
            SKILL_FORGERY,
            SKILL_GATHER_INFO,
            SKILL_HANDLE_ANIMAL,
            SKILL_INTIMIDATE,
            SKILL_KNOW_ARCANA,
            SKILL_KNOW_DUNGEON,
            SKILL_KNOW_ENGINEERING,
            SKILL_KNOW_GEOPGRAPHY,
            SKILL_KNOW_HISTORY,
            SKILL_KNOW_LOCAL,
            SKILL_KNOW_NATURE,
            SKILL_KNOW_NOBILITY,
            SKILL_KNOW_PLANES,
            SKILL_KNOW_RELIGION,
            SKILL_PERFORM_ACT,
            SKILL_PERFORM_COMEDY,
            SKILL_PERFORM_DANCE,
            SKILL_PERFORM_KEYBOARDS,
            SKILL_PERFORM_ORATORY,
            SKILL_PERFORM_PERCUSSION,
            SKILL_PERFORM_SING,
            SKILL_PERFORM_STRING,
            SKILL_PERFORM_WIND,
            SKILL_SEARCH,
            SKILL_SENSE_MOTIVE,
            SKILL_SPOT,
            SKILL_SPELLCRAFT,
            SKILL_USE_MAGIC_DEVICE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_APPRAISE, "Helmet of Appraisal" },
            {SKILL_BLUFF, "Helmet of Glibness" },
            {SKILL_CONCENTRATION, "Helmet of Concentration" },
            {SKILL_DECIPHER_SCRIPT, "Helmet of the Linguist" },
            {SKILL_DIPLOMACY, "Helmet of Diplomacy" },
            {SKILL_DISGUISE, "Helmet of Disguise" },
            {SKILL_FORGERY, "Helmet of Forgery" },
            {SKILL_GATHER_INFO, "Helmet of Information" },
            {SKILL_HANDLE_ANIMAL, "Helmet of the Trainer" },
            {SKILL_INTIMIDATE, "Helmet of Intimidation" },
            {SKILL_KNOW_ARCANA, "Helmet of Arcana" },
            {SKILL_KNOW_DUNGEON, "Helmet of Dungeoneering" },
            {SKILL_KNOW_ENGINEERING, "Helmet of Engineering" },
            {SKILL_KNOW_GEOPGRAPHY, "Helmet of Geography" },
            {SKILL_KNOW_HISTORY, "Helmet of History" },
            {SKILL_KNOW_LOCAL, "Helmet of Rumor" },
            {SKILL_KNOW_NATURE, "Helmet of Nature" },
            {SKILL_KNOW_NOBILITY, "Helmet of Heraldry" },
            {SKILL_KNOW_PLANES, "Helmet of the Planes" },
            {SKILL_KNOW_RELIGION, "Helmet of Theology" },
            {SKILL_PERFORM_ACT, "Helmet of Acting" },
            {SKILL_PERFORM_COMEDY, "Helmet of Comedy" },
            {SKILL_PERFORM_DANCE, "Helmet of Dancing" },
            {SKILL_PERFORM_KEYBOARDS, "Helmet of the Pianist" },
            {SKILL_PERFORM_ORATORY, "Helmet of Speech" },
            {SKILL_PERFORM_PERCUSSION, "Helmet of the Drummer" },
            {SKILL_PERFORM_SING, "Helmet of Singing" },
            {SKILL_PERFORM_STRING, "Helmet of the Violinist" },
            {SKILL_PERFORM_WIND, "Helmet of the Piper" },
            {SKILL_SEARCH, "Helmet of Minute Seeing" },
            {SKILL_SENSE_MOTIVE, "Helmet of Scrutiny" },
            {SKILL_SPOT, "Helmet of Sharp Eyes" },
            {SKILL_SPELLCRAFT, "Helmet of Wizardly Study" },
            {SKILL_USE_MAGIC_DEVICE, "Helmet of Spellguessing" },
        };
        #endregion

        #region Specific Saving Throws
        public static List<int> AvailableSaveTypes = new List<int>
        {
            IP_CONST_SAVEVS_FEAR,
        };

        public static Dictionary<int, string> SaveTypeNames = new Dictionary<int, string>
        {
            {IP_CONST_SAVEVS_FEAR, "Fearless Helmet"},
        };
        #endregion
    }
}

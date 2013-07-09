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
    public class GenerateCloak : CLRScriptBase
    {
        public static int NewCloak(CLRScriptBase script, int maxValue)
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
            uint cloak = script.CreateItemOnObject("zitem_cloak", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Cloaks of Deflection
                case ITEM_PROPERTY_AC_BONUS:
                    {
                        string name = AbilityNames[selectedAbility];
                        if (maxValue >= 50000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(5), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +5");
                            Pricing.CalculatePrice(script, cloak);
                            return 50000;
                        }
                        else if (maxValue >= 32000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(4), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +4");
                            Pricing.CalculatePrice(script, cloak);
                            return 32000;
                        }
                        else if (maxValue >= 18000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(3), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +3");
                            Pricing.CalculatePrice(script, cloak);
                            return 18000;
                        }
                        else if (maxValue >= 8000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(2), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +2");
                            Pricing.CalculatePrice(script, cloak);
                            return 8000;
                        }
                        else if (maxValue >= 2000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(1), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +1");
                            Pricing.CalculatePrice(script, cloak);
                            return 2000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Cloaks of Ability Scores
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = AvailableAbilityScores[Generation.rand.Next(AvailableAbilityScores.Count)];
                        string name = AbilityScoreNames[abilityScore];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +6");
                            Pricing.CalculatePrice(script, cloak);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +5");
                            Pricing.CalculatePrice(script, cloak);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +4");
                            Pricing.CalculatePrice(script, cloak);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +3");
                            Pricing.CalculatePrice(script, cloak);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +2");
                            Pricing.CalculatePrice(script, cloak);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), cloak, 0.0f);
                            script.SetFirstName(cloak, name + " +1");
                            Pricing.CalculatePrice(script, cloak);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Damage Resistance
                case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                    {
                        int damageResistType = DamageResistances[Generation.rand.Next(DamageResistances.Count)];
                        if (damageResistType == IP_CONST_DAMAGETYPE_NEGATIVE &&
                            maxValue < 6000)
                        {
                            int attempts = 0;
                            while (damageResistType == IP_CONST_DAMAGETYPE_NEGATIVE)
                            {
                                damageResistType = DamageResistances[Generation.rand.Next(DamageResistances.Count)];
                                attempts++;
                                if (attempts == 10)
                                {
                                    // something is wrong. Break out and just go with fire or something.
                                    damageResistType = IP_CONST_DAMAGETYPE_FIRE;
                                    break;
                                }
                            }
                        }
                        if (damageResistType == IP_CONST_DAMAGETYPE_NEGATIVE)
                        {
                            if (maxValue >= 66000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, cloak);
                                return 66000;
                            }
                            else if (maxValue >= 54000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, cloak);
                                return 54000;
                            }
                            else if (maxValue >= 42000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, cloak);
                                return 42000;
                            }
                            else if (maxValue >= 30000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, cloak);
                                return 30000;
                            }
                            else if (maxValue >= 18000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, cloak);
                                return 18000;
                            }
                            else if (maxValue >= 6000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, cloak);
                                return 6000;
                            }
                        }
                        else
                        {
                            if (maxValue >= 44000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, cloak);
                                return 44000;
                            }
                            else if (maxValue >= 36000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, cloak);
                                return 36000;
                            }
                            else if (maxValue >= 28000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, cloak);
                                return 28000;
                            }
                            else if (maxValue >= 20000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, cloak);
                                return 20000;
                            }
                            else if (maxValue >= 12000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, cloak);
                                return 12000;
                            }
                            else if (maxValue >= 4000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), cloak, 0.0f);
                                script.SetFirstName(cloak, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, cloak);
                                return 4000;
                            }
                        }
                        break;
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), cloak, 0.0f);
                        script.SetFirstName(cloak, ImmunityNames[selectedImmunity]);
                        Pricing.CalculatePrice(script, cloak);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Saving Throws
                case ITEM_PROPERTY_SAVING_THROW_BONUS:
                    {
                        if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Resistance +5");
                            Pricing.CalculatePrice(script, cloak);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Resistance +4");
                            Pricing.CalculatePrice(script, cloak);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Resistance +3");
                            Pricing.CalculatePrice(script, cloak);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Resistance +2");
                            Pricing.CalculatePrice(script, cloak);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Resistance +1");
                            Pricing.CalculatePrice(script, cloak);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Saving Throws vs. Specific
                case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                    {
                        int saveType = AvailableSaveTypes[Generation.rand.Next(AvailableSaveTypes.Count)];
                        script.SetFirstName(cloak, SaveTypeNames[saveType]);
                        if (maxValue >= 6250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 5), cloak, 0.0f);
                            script.SetFirstName(cloak, String.Format("{0} +5", script.GetName(cloak)));
                            Pricing.CalculatePrice(script, cloak);
                            return 6250;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 4), cloak, 0.0f);
                            script.SetFirstName(cloak, String.Format("{0} +4", script.GetName(cloak)));
                            Pricing.CalculatePrice(script, cloak);
                            return 4000;
                        }
                        else if (maxValue >= 2250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 3), cloak, 0.0f);
                            script.SetFirstName(cloak, String.Format("{0} +3", script.GetName(cloak)));
                            Pricing.CalculatePrice(script, cloak);
                            return 2250;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 2), cloak, 0.0f);
                            script.SetFirstName(cloak, String.Format("{0} +2", script.GetName(cloak)));
                            Pricing.CalculatePrice(script, cloak);
                            return 1000;
                        }
                        else if (maxValue >= 250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 1), cloak, 0.0f);
                            script.SetFirstName(cloak, String.Format("{0} +1", script.GetName(cloak)));
                            Pricing.CalculatePrice(script, cloak);
                            return 250;
                        }
                        break;
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(cloak, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +10");
                            Pricing.CalculatePrice(script, cloak);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +9");
                            Pricing.CalculatePrice(script, cloak);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +8");
                            Pricing.CalculatePrice(script, cloak);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +7");
                            Pricing.CalculatePrice(script, cloak);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +6");
                            Pricing.CalculatePrice(script, cloak);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +5");
                            Pricing.CalculatePrice(script, cloak);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +4");
                            Pricing.CalculatePrice(script, cloak);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +3");
                            Pricing.CalculatePrice(script, cloak);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +2");
                            Pricing.CalculatePrice(script, cloak);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), cloak, 0.0f);
                            script.SetFirstName(cloak, script.GetName(cloak) + " +1");
                            Pricing.CalculatePrice(script, cloak);
                            return 100;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Spell Resistance
                case ITEM_PROPERTY_SPELL_RESISTANCE:
                    {
                        if (maxValue >= 140000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 26");
                            Pricing.CalculatePrice(script, cloak);
                            return 140000;
                        }
                        else if (maxValue >= 120000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 24");
                            Pricing.CalculatePrice(script, cloak);
                            return 120000;
                        }
                        else if (maxValue >= 100000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 22");
                            Pricing.CalculatePrice(script, cloak);
                            return 100000;
                        }
                        else if (maxValue >= 80000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 20");
                            Pricing.CalculatePrice(script, cloak);
                            return 80000;
                        }
                        else if (maxValue >= 60000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 18");
                            Pricing.CalculatePrice(script, cloak);
                            return 60000;
                        }
                        else if (maxValue >= 40000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 16");
                            Pricing.CalculatePrice(script, cloak);
                            return 40000;
                        }
                        else if (maxValue >= 20000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 14");
                            Pricing.CalculatePrice(script, cloak);
                            return 20000;
                        }
                        else if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 12");
                            Pricing.CalculatePrice(script, cloak);
                            return 10000;
                        }
                        else if (maxValue >= 6000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10), cloak, 0.0f);
                            script.SetFirstName(cloak, "Cloak of Spell Resistance, 10");
                            Pricing.CalculatePrice(script, cloak);
                            return 6000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            script.DestroyObject(cloak, 0.0f, FALSE);
            return 0;
        }

        #region Ability Categories
        public static Dictionary<int, int> AvailableAbilities = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_AC_BONUS, 2000},
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, 500},
            {ITEM_PROPERTY_DAMAGE_RESISTANCE, 4000},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 7500},
            {ITEM_PROPERTY_SAVING_THROW_BONUS, 1000},
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, 250},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
            {ITEM_PROPERTY_SPELL_RESISTANCE, 6000},
        };

        public static Dictionary<int, string> AbilityNames = new Dictionary<int, string>
        {
            {ITEM_PROPERTY_AC_BONUS, "Cloak of Protection"},
            {ITEM_PROPERTY_ABILITY_BONUS, "" },
            {ITEM_PROPERTY_DAMAGE_RESISTANCE, "" },
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, "Cloak of Freedom" },
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, "" },
            {ITEM_PROPERTY_LIGHT, "Cloak of Light" },
            {ITEM_PROPERTY_SAVING_THROW_BONUS, "Cloak of Resistance" },
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, "" },
            {ITEM_PROPERTY_SKILL_BONUS, "" },
            {ITEM_PROPERTY_SPELL_RESISTANCE, "Cloak of Spell Resistance" },
        };
        #endregion

        #region Ability Scores
        static List<int> AvailableAbilityScores = new List<int>
        {
            IP_CONST_ABILITY_CHA,
        };

        static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_CHA, "Cloak of Charisma" },
        };
        #endregion

        #region Immunities
        public static Dictionary<int, int> AvailableImmunities = new Dictionary<int, int>
        {
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, 80000},
            {IP_CONST_IMMUNITYMISC_DISEASE, 7500},
            {IP_CONST_IMMUNITYMISC_FEAR, 10000},
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, 22500},
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, 40000},
            {IP_CONST_IMMUNITYMISC_PARALYSIS, 15000},
            {IP_CONST_IMMUNITYMISC_POISON, 25000},
        };

        public static Dictionary<int, string> ImmunityNames = new Dictionary<int, string>
        {
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, "Cloak of Deathward" },
            {IP_CONST_IMMUNITYMISC_DISEASE, "Cloak of Good Health" },
            {IP_CONST_IMMUNITYMISC_FEAR, "Cloak of Fearlessness" },
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, "Cloak of Stability" },
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, "Cloak of Undeath's Ward" },
            {IP_CONST_IMMUNITYMISC_PARALYSIS, "Cloak of Enduring Mobility" },
            {IP_CONST_IMMUNITYMISC_POISON, "Cloak of Antivenom" },
        };
        #endregion

        #region Damage Resistance
        public static List<int> DamageResistances = new List<int>
        {
            IP_CONST_DAMAGETYPE_ACID,
            IP_CONST_DAMAGETYPE_COLD,
            IP_CONST_DAMAGETYPE_FIRE,
            IP_CONST_DAMAGETYPE_ELECTRICAL,
            IP_CONST_DAMAGETYPE_SONIC,
            IP_CONST_DAMAGETYPE_NEGATIVE,
        };

        public static Dictionary<int, string> DamageResistanceNames = new Dictionary<int, string>
        {
            {IP_CONST_DAMAGETYPE_ACID, "Acidproof Cloak" },
            {IP_CONST_DAMAGETYPE_COLD, "Frostproof Cloak" },
            {IP_CONST_DAMAGETYPE_FIRE, "Fireproof Cloak" },
            {IP_CONST_DAMAGETYPE_ELECTRICAL, "Shockproof Cloak" },
            {IP_CONST_DAMAGETYPE_SONIC, "Soundproof Cloak" },
            {IP_CONST_DAMAGETYPE_NEGATIVE, "Necromancyproof Cloak" },
        };
        #endregion

        #region Skills
        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_HIDE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_HIDE, "Cloak of Stealth" },
        };
        #endregion

        #region Specific Saving Throws
        public static List<int> AvailableSaveTypes = new List<int>
        {
            IP_CONST_SAVEVS_ACID,
            IP_CONST_SAVEVS_COLD,
            IP_CONST_SAVEVS_DEATH,
            IP_CONST_SAVEVS_DISEASE,
            IP_CONST_SAVEVS_ELECTRICAL,
            IP_CONST_SAVEVS_FEAR,
            IP_CONST_SAVEVS_FIRE,
            IP_CONST_SAVEVS_NEGATIVE,
            IP_CONST_SAVEVS_POISON,
            IP_CONST_SAVEVS_SONIC
        };

        public static Dictionary<int, string> SaveTypeNames = new Dictionary<int, string>
        {
            {IP_CONST_SAVEVS_ACID, "Alkaline Cloak"},
            {IP_CONST_SAVEVS_COLD, "Warming Cloak"},
            {IP_CONST_SAVEVS_DEATH, "Antinecromantic Cloak"},
            {IP_CONST_SAVEVS_DISEASE, "Irongut Cloak"},
            {IP_CONST_SAVEVS_ELECTRICAL, "Insulating Cloak"},
            {IP_CONST_SAVEVS_FEAR, "Fearless Cloak"},
            {IP_CONST_SAVEVS_FIRE, "Cooling Cloak"},
            {IP_CONST_SAVEVS_NEGATIVE, "Antinecromantic Cloak"},
            {IP_CONST_SAVEVS_POISON, "Antivenom Cloak"},
            {IP_CONST_SAVEVS_SONIC, "Dampening Cloak"},
        };
        #endregion
    }
}

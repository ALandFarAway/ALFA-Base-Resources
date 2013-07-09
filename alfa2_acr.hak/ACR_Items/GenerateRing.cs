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
    public class GenerateRing: CLRScriptBase
    {
        public static int NewRing(CLRScriptBase script, int maxValue)
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
            uint ring = script.CreateItemOnObject("nw_it_mring021", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Rings of Deflection
                case ITEM_PROPERTY_AC_BONUS:
                    {
                        string name = AbilityNames[selectedAbility];
                        if (maxValue >= 50000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(5), ring, 0.0f);
                            script.SetFirstName(ring, name + " +5");
                            Pricing.CalculatePrice(script, ring);
                            return 50000;
                        }
                        else if (maxValue >= 32000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(4), ring, 0.0f);
                            script.SetFirstName(ring, name + " +4");
                            Pricing.CalculatePrice(script, ring);
                            return 32000;
                        }
                        else if (maxValue >= 18000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(3), ring, 0.0f);
                            script.SetFirstName(ring, name + " +3");
                            Pricing.CalculatePrice(script, ring);
                            return 18000;
                        }
                        else if (maxValue >= 8000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(2), ring, 0.0f);
                            script.SetFirstName(ring, name + " +2");
                            Pricing.CalculatePrice(script, ring);
                            return 8000;
                        }
                        else if (maxValue >= 2000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(1), ring, 0.0f);
                            script.SetFirstName(ring, name + " +1");
                            Pricing.CalculatePrice(script, ring);
                            return 2000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Rings of Ability Scores
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = AvailableAbilityScores[Generation.rand.Next(AvailableAbilityScores.Count)];
                        string name = AbilityScoreNames[abilityScore];
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), ring, 0.0f);
                            script.SetFirstName(ring, name + " +6");
                            Pricing.CalculatePrice(script, ring);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), ring, 0.0f);
                            script.SetFirstName(ring, name + " +5");
                            Pricing.CalculatePrice(script, ring);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), ring, 0.0f);
                            script.SetFirstName(ring, name + " +4");
                            Pricing.CalculatePrice(script, ring);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), ring, 0.0f);
                            script.SetFirstName(ring, name + " +3");
                            Pricing.CalculatePrice(script, ring);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), ring, 0.0f);
                            script.SetFirstName(ring, name + " +2");
                            Pricing.CalculatePrice(script, ring);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), ring, 0.0f);
                            script.SetFirstName(ring, name + " +1");
                            Pricing.CalculatePrice(script, ring);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Rings with Bonus Feats
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(selectedFeat), ring, 0.0f);
                        script.SetFirstName(ring, FeatNames[selectedFeat]);
                        Pricing.CalculatePrice(script, ring);
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
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_9), ring, 0.0f);
                            script.SetFirstName(ring, name + " IX");
                            Pricing.CalculatePrice(script, ring);
                            return 81000;
                        }
                        else if (maxValue >= 64000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_8), ring, 0.0f);
                            script.SetFirstName(ring, name + " VIII");
                            Pricing.CalculatePrice(script, ring);
                            return 64000;
                        }
                        else if (maxValue >= 49000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_7), ring, 0.0f);
                            script.SetFirstName(ring, name + " VII");
                            Pricing.CalculatePrice(script, ring);
                            return 49000;
                        }
                        else if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_6), ring, 0.0f);
                            script.SetFirstName(ring, name + " VI");
                            Pricing.CalculatePrice(script, ring);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_5), ring, 0.0f);
                            script.SetFirstName(ring, name + " V");
                            Pricing.CalculatePrice(script, ring);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_4), ring, 0.0f);
                            script.SetFirstName(ring, name + " IV");
                            Pricing.CalculatePrice(script, ring);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_3), ring, 0.0f);
                            script.SetFirstName(ring, name + " III");
                            Pricing.CalculatePrice(script, ring);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_2), ring, 0.0f);
                            script.SetFirstName(ring, name + " II");
                            Pricing.CalculatePrice(script, ring);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_1), ring, 0.0f);
                            script.SetFirstName(ring, name + " I");
                            Pricing.CalculatePrice(script, ring);
                            return 1000;
                        }
                        else if (maxValue >= 500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusLevelSpell(bonusType, IP_CONST_SPELLLEVEL_0), ring, 0.0f);
                            script.SetFirstName(ring, name + " 0");
                            Pricing.CalculatePrice(script, ring);
                            return 500;
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
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, ring);
                                return 66000;
                            }
                            else if (maxValue >= 54000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, ring);
                                return 54000;
                            }
                            else if (maxValue >= 42000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, ring);
                                return 42000;
                            }
                            else if (maxValue >= 30000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, ring);
                                return 30000;
                            }
                            else if (maxValue >= 18000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, ring);
                                return 18000;
                            }
                            else if (maxValue >= 6000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, ring);
                                return 6000;
                            }
                        }
                        else
                        {
                            if (maxValue >= 44000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, ring);
                                return 44000;
                            }
                            else if (maxValue >= 36000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, ring);
                                return 36000;
                            }
                            else if (maxValue >= 28000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, ring);
                                return 28000;
                            }
                            else if (maxValue >= 20000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, ring);
                                return 20000;
                            }
                            else if (maxValue >= 12000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, ring);
                                return 12000;
                            }
                            else if (maxValue >= 4000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), ring, 0.0f);
                                script.SetFirstName(ring, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, ring);
                                return 4000;
                            }
                        }
                        break;
                    }
                #endregion
                #region Freedom of Movement
                case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyFreeAction(), ring, 0.0f);
                        script.SetFirstName(ring, "Ring of Freedom");
                        Pricing.CalculatePrice(script, ring);
                        return 40000;
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), ring, 0.0f);
                        script.SetFirstName(ring, ImmunityNames[selectedImmunity]);
                        Pricing.CalculatePrice(script, ring);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Light
                case ITEM_PROPERTY_LIGHT:
                    {
                        int lightColor = LightColors[Generation.rand.Next(LightColors.Count)]; ;
                        script.SetFirstName(ring, AbilityNames[selectedAbility]);
                        if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, lightColor), ring, 0.0f);
                            Pricing.CalculatePrice(script, ring);
                            return 400;
                        }
                        else if (maxValue >= 300)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, lightColor), ring, 0.0f);
                            Pricing.CalculatePrice(script, ring);
                            return 300;
                        }
                        else if (maxValue >= 200)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_LOW, lightColor), ring, 0.0f);
                            Pricing.CalculatePrice(script, ring);
                            return 200;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_DIM, lightColor), ring, 0.0f);
                            Pricing.CalculatePrice(script, ring);
                            return 100;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Saving Throws
                case ITEM_PROPERTY_SAVING_THROW_BONUS:
                    {
                        if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Resistance +5");
                            Pricing.CalculatePrice(script, ring);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Resistance +4");
                            Pricing.CalculatePrice(script, ring);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Resistance +3");
                            Pricing.CalculatePrice(script, ring);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Resistance +2");
                            Pricing.CalculatePrice(script, ring);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Resistance +1");
                            Pricing.CalculatePrice(script, ring);
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
                        script.SetFirstName(ring, SaveTypeNames[saveType]);
                        if (maxValue >= 6250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 5), ring, 0.0f);
                            script.SetFirstName(ring, String.Format("{0} +5", script.GetName(ring)));
                            Pricing.CalculatePrice(script, ring);
                            return 6250;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 4), ring, 0.0f);
                            script.SetFirstName(ring, String.Format("{0} +4", script.GetName(ring)));
                            Pricing.CalculatePrice(script, ring);
                            return 4000;
                        }
                        else if (maxValue >= 2250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 3), ring, 0.0f);
                            script.SetFirstName(ring, String.Format("{0} +3", script.GetName(ring)));
                            Pricing.CalculatePrice(script, ring);
                            return 2250;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 2), ring, 0.0f);
                            script.SetFirstName(ring, String.Format("{0} +2", script.GetName(ring)));
                            Pricing.CalculatePrice(script, ring);
                            return 1000;
                        }
                        else if (maxValue >= 250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 1), ring, 0.0f);
                            script.SetFirstName(ring, String.Format("{0} +1", script.GetName(ring)));
                            Pricing.CalculatePrice(script, ring);
                            return 250;
                        }
                        break;
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(ring, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +10");
                            Pricing.CalculatePrice(script, ring);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +9");
                            Pricing.CalculatePrice(script, ring);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +8");
                            Pricing.CalculatePrice(script, ring);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +7");
                            Pricing.CalculatePrice(script, ring);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +6");
                            Pricing.CalculatePrice(script, ring);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +5");
                            Pricing.CalculatePrice(script, ring);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +4");
                            Pricing.CalculatePrice(script, ring);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +3");
                            Pricing.CalculatePrice(script, ring);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +2");
                            Pricing.CalculatePrice(script, ring);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), ring, 0.0f);
                            script.SetFirstName(ring, script.GetName(ring) + " +1");
                            Pricing.CalculatePrice(script, ring);
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
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 26");
                            Pricing.CalculatePrice(script, ring);
                            return 140000;
                        }
                        else if (maxValue >= 120000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 24");
                            Pricing.CalculatePrice(script, ring);
                            return 120000;
                        }
                        else if (maxValue >= 100000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 22");
                            Pricing.CalculatePrice(script, ring);
                            return 100000;
                        }
                        else if (maxValue >= 80000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 20");
                            Pricing.CalculatePrice(script, ring);
                            return 80000;
                        }
                        else if (maxValue >= 60000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 18");
                            Pricing.CalculatePrice(script, ring);
                            return 60000;
                        }
                        else if (maxValue >= 40000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 16");
                            Pricing.CalculatePrice(script, ring);
                            return 40000;
                        }
                        else if (maxValue >= 20000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 14");
                            Pricing.CalculatePrice(script, ring);
                            return 20000;
                        }
                        else if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 12");
                            Pricing.CalculatePrice(script, ring);
                            return 10000;
                        }
                        else if (maxValue >= 6000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10), ring, 0.0f);
                            script.SetFirstName(ring, "Ring of Spell Resistance, 10");
                            Pricing.CalculatePrice(script, ring);
                            return 6000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            script.DestroyObject(ring, 0.0f, FALSE);
            return 0;
        }

        #region Ability Categories
        public static Dictionary<int, int> AvailableAbilities = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_AC_BONUS, 2000},
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_BONUS_FEAT, 2500},
            {ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, 500},
            {ITEM_PROPERTY_DAMAGE_RESISTANCE, 4000},
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, 40000},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 7500},
            {ITEM_PROPERTY_LIGHT, 100},
            {ITEM_PROPERTY_SAVING_THROW_BONUS, 1000},
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, 250},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
            {ITEM_PROPERTY_SPELL_RESISTANCE, 6000},
        };

        public static Dictionary<int, string> AbilityNames = new Dictionary<int, string>
        {
            {ITEM_PROPERTY_AC_BONUS, "Ring of Protection"},
            {ITEM_PROPERTY_ABILITY_BONUS, "" },
            {ITEM_PROPERTY_BONUS_FEAT, "" },
            {ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N, "" },
            {ITEM_PROPERTY_DAMAGE_RESISTANCE, "" },
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, "Ring of Freedom" },
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, "" },
            {ITEM_PROPERTY_LIGHT, "Ring of Light" },
            {ITEM_PROPERTY_SAVING_THROW_BONUS, "Ring of Resistance" },
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, "" },
            {ITEM_PROPERTY_SKILL_BONUS, "" },
            {ITEM_PROPERTY_SPELL_RESISTANCE, "Ring of Spell Resistance" },
        };
        #endregion

        #region Ability Scores
        static List<int> AvailableAbilityScores = new List<int>
        {
            IP_CONST_ABILITY_CHA,
            IP_CONST_ABILITY_CON,
            IP_CONST_ABILITY_DEX,
            IP_CONST_ABILITY_INT,
            IP_CONST_ABILITY_STR,
            IP_CONST_ABILITY_WIS,
        };

        static Dictionary<int, string> AbilityScoreNames = new Dictionary<int, string>
        {
            {IP_CONST_ABILITY_CHA, "Ring of Charm" },
            {IP_CONST_ABILITY_CON, "Ring of Health" },
            {IP_CONST_ABILITY_DEX, "Ring of Agility" },
            {IP_CONST_ABILITY_INT, "Ring of Wit" },
            {IP_CONST_ABILITY_STR, "Ring of Might" },
            {IP_CONST_ABILITY_WIS, "Ring of Insight" },
        };
        #endregion

        #region Light Colors
        public static List<int> LightColors = new List<int>
        {
            IP_CONST_LIGHTCOLOR_BLUE,
            IP_CONST_LIGHTCOLOR_GREEN,
            IP_CONST_LIGHTCOLOR_ORANGE,
            IP_CONST_LIGHTCOLOR_PURPLE,
            IP_CONST_LIGHTCOLOR_RED,
            IP_CONST_LIGHTCOLOR_WHITE,
            IP_CONST_LIGHTCOLOR_YELLOW
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
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, "Ring of Deathward" },
            {IP_CONST_IMMUNITYMISC_DISEASE, "Ring of Good Health" },
            {IP_CONST_IMMUNITYMISC_FEAR, "Ring of Fearlessness" },
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, "Ring of Stability" },
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, "Ring of Undeath's Ward" },
            {IP_CONST_IMMUNITYMISC_PARALYSIS, "Ring of Enduring Mobility" },
            {IP_CONST_IMMUNITYMISC_POISON, "Ring of Antivenom" },
        };
        #endregion

        #region Bonus Feats
        public static Dictionary<int, int> AvailableFeats = new Dictionary<int, int>
        {
            {IP_CONST_FEAT_DARKVISION, 2500},
            {IP_CONST_FEAT_COMBAT_CASTING, 5000},
            {IP_CONST_FEAT_EXTRA_TURNING, 7500},
        };

        public static Dictionary<int, string> FeatNames = new Dictionary<int, string>
        {
            {IP_CONST_FEAT_DARKVISION, "Ring of Nightvision" },
            {IP_CONST_FEAT_COMBAT_CASTING, "Ring of the Battlemage" },
            {IP_CONST_FEAT_EXTRA_TURNING, "Ring of Turning" },
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
            {IP_CONST_CLASS_BARD, "Ring of Poetry" },
            {IP_CONST_CLASS_CLERIC, "Ring of Ministry" },
            {IP_CONST_CLASS_DRUID, "Ring of Nature" },
            {IP_CONST_CLASS_FAVORED_SOUL, "Ring of Favor" },
            {IP_CONST_CLASS_PALADIN, "Ring of Holiness" },
            {IP_CONST_CLASS_RANGER, "Ring of Hunting" },
            {IP_CONST_CLASS_SORCERER, "Ring of Sorcery" },
            {IP_CONST_CLASS_SPIRIT_SHAMAN, "Ring of Shamanism" },
            {IP_CONST_CLASS_WIZARD, "Ring of Wizardry" },
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
            {IP_CONST_DAMAGETYPE_ACID, "Acidproof Ring" },
            {IP_CONST_DAMAGETYPE_COLD, "Frostproof Ring" },
            {IP_CONST_DAMAGETYPE_FIRE, "Fireproof Ring" },
            {IP_CONST_DAMAGETYPE_ELECTRICAL, "Shockproof Ring" },
            {IP_CONST_DAMAGETYPE_SONIC, "Soundproof Ring" },
            {IP_CONST_DAMAGETYPE_NEGATIVE, "Necromancyproof Ring" },
        };
        #endregion

        #region Skills
        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_APPRAISE,
            SKILL_BALANCE,
            SKILL_BLUFF,
            SKILL_CLIMB,
            SKILL_CONCENTRATION,
            SKILL_CRAFT_ALCHEMY,
            SKILL_CRAFT_ARMORER,
            SKILL_CRAFT_BOWMAKING,
            SKILL_CRAFT_WEAPONSMITHING,
            SKILL_DECIPHER_SCRIPT,
            SKILL_DIPLOMACY,
            SKILL_DISABLE_TRAP,
            SKILL_DISGUISE,
            SKILL_ESCAPE_ARTIST,
            SKILL_FORGERY,
            SKILL_GATHER_INFO,
            SKILL_HANDLE_ANIMAL,
            SKILL_HEAL,
            SKILL_HIDE,
            SKILL_INTIMIDATE,
            SKILL_JUMP,
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
            SKILL_LISTEN,
            SKILL_MOVE_SILENTLY,
            SKILL_OPEN_LOCK,
            SKILL_PERFORM_ACT,
            SKILL_PERFORM_COMEDY,
            SKILL_PERFORM_DANCE,
            SKILL_PERFORM_KEYBOARDS,
            SKILL_PERFORM_ORATORY,
            SKILL_PERFORM_PERCUSSION,
            SKILL_PERFORM_SING,
            SKILL_PERFORM_STRING,
            SKILL_PERFORM_WIND,
            SKILL_RIDE,
            SKILL_SEARCH,
            SKILL_SENSE_MOTIVE,
            SKILL_SLEIGHT_OF_HAND,
            SKILL_SURVIVAL,
            SKILL_SPOT,
            SKILL_SPELLCRAFT,
            SKILL_SWIM,
            SKILL_TUMBLE,
            SKILL_USE_MAGIC_DEVICE,
            SKILL_USE_ROPE,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_APPRAISE, "Ring of Appraisal" },
            {SKILL_BALANCE, "Ring of Balance" },
            {SKILL_BLUFF, "Ring of Glibness" },
            {SKILL_CLIMB, "Ring of Climbing" },
            {SKILL_CONCENTRATION, "Ring of Concentration" },
            {SKILL_CRAFT_ALCHEMY, "Ring of the Alchemist" },
            {SKILL_CRAFT_ARMORER, "Ring of the Armorer" },
            {SKILL_CRAFT_BOWMAKING, "Ring of the Bowyer" },
            {SKILL_CRAFT_WEAPONSMITHING, "Ring of the Weaponsmith" },
            {SKILL_DECIPHER_SCRIPT, "Ring of the Linguist" },
            {SKILL_DIPLOMACY, "Ring of Diplomacy" },
            {SKILL_DISABLE_TRAP, "Ring of Trapspringing" },
            {SKILL_DISGUISE, "Ring of Disguise" },
            {SKILL_ESCAPE_ARTIST, "Ring of Escape" },
            {SKILL_FORGERY, "Ring of Forgery" },
            {SKILL_GATHER_INFO, "Ring of Information" },
            {SKILL_HANDLE_ANIMAL, "Ring of the Trainer" },
            {SKILL_HEAL, "Ring of Medicine" },
            {SKILL_HIDE, "Ring of Stealth" },
            {SKILL_INTIMIDATE, "Ring of Intimidation" },
            {SKILL_JUMP, "Ring of Jumping" },
            {SKILL_KNOW_ARCANA, "Ring of Arcana" },
            {SKILL_KNOW_DUNGEON, "Ring of Dungeoneering" },
            {SKILL_KNOW_ENGINEERING, "Ring of Engineering" },
            {SKILL_KNOW_GEOPGRAPHY, "Ring of Geography" },
            {SKILL_KNOW_HISTORY, "Ring of History" },
            {SKILL_KNOW_LOCAL, "Ring of Rumor" },
            {SKILL_KNOW_NATURE, "Ring of Nature" },
            {SKILL_KNOW_NOBILITY, "Ring of Heraldry" },
            {SKILL_KNOW_PLANES, "Ring of the Planes" },
            {SKILL_KNOW_RELIGION, "Ring of Theology" },
            {SKILL_LISTEN, "Ring of Sharp Ears" },
            {SKILL_MOVE_SILENTLY, "Ring of Prowling" },
            {SKILL_OPEN_LOCK, "Ring of Lockpicking" },
            {SKILL_PERFORM_ACT, "Ring of Acting" },
            {SKILL_PERFORM_COMEDY, "Ring of Comedy" },
            {SKILL_PERFORM_DANCE, "Ring of Dancing" },
            {SKILL_PERFORM_KEYBOARDS, "Ring of the Pianist" },
            {SKILL_PERFORM_ORATORY, "Ring of Speech" },
            {SKILL_PERFORM_PERCUSSION, "Ring of the Drummer" },
            {SKILL_PERFORM_SING, "Ring of Singing" },
            {SKILL_PERFORM_STRING, "Ring of the Violinist" },
            {SKILL_PERFORM_WIND, "Ring of the Piper" },
            {SKILL_RIDE, "Ring of Horsemanship" },
            {SKILL_SEARCH, "Ring of Minute Seeing" },
            {SKILL_SENSE_MOTIVE, "Ring of Scrutiny" },
            {SKILL_SLEIGHT_OF_HAND, "Ring of Palming" },
            {SKILL_SURVIVAL, "Ring of Survival" },
            {SKILL_SPOT, "Ring of Sharp Eyes" },
            {SKILL_SPELLCRAFT, "Ring of Wizardly Study" },
            {SKILL_SWIM, "Ring of Swimming" },
            {SKILL_TUMBLE, "Ring of Tumbling" },
            {SKILL_USE_MAGIC_DEVICE, "Ring of Spellguessing" },
            {SKILL_USE_ROPE, "Ring of Knots" },
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
            {IP_CONST_SAVEVS_ACID, "Alkaline Ring"},
            {IP_CONST_SAVEVS_COLD, "Warming Ring"},
            {IP_CONST_SAVEVS_DEATH, "Antinecromantic Ring"},
            {IP_CONST_SAVEVS_DISEASE, "Irongut Ring"},
            {IP_CONST_SAVEVS_ELECTRICAL, "Insulating Ring"},
            {IP_CONST_SAVEVS_FEAR, "Fearless Ring"},
            {IP_CONST_SAVEVS_FIRE, "Cooling Ring"},
            {IP_CONST_SAVEVS_NEGATIVE, "Antinecromantic Ring"},
            {IP_CONST_SAVEVS_POISON, "Antivenom Ring"},
            {IP_CONST_SAVEVS_SONIC, "Dampening Ring"},
        };
        #endregion
    }
}

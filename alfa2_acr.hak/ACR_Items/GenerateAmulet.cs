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
    public class GenerateAmulet: CLRScriptBase
    {
        public static int NewAmulet(CLRScriptBase script, int maxValue)
        {
            List<int> potentialAbilities = new List<int>();
            foreach (KeyValuePair<int, int> ability in PrimaryAmuletAbility)
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
            uint amulet = script.CreateItemOnObject("nw_it_mneck020", script.OBJECT_SELF, 1, "", FALSE);
            switch (selectedAbility)
            {
                #region Amulets of Natural Armor
                case ITEM_PROPERTY_AC_BONUS:
                    {
                        if (maxValue >= 50000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(5), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Natural Armor +5");
                            Pricing.CalculatePrice(script, amulet);
                            return 50000;
                        }
                        else if (maxValue >= 32000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(4), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Natural Armor +4");
                            Pricing.CalculatePrice(script, amulet);
                            return 32000;
                        }
                        else if (maxValue >= 18000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(3), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Natural Armor +3");
                            Pricing.CalculatePrice(script, amulet);
                            return 18000;
                        }
                        else if (maxValue >= 8000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(2), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Natural Armor +2");
                            Pricing.CalculatePrice(script, amulet);
                            return 8000;
                        }
                        else if (maxValue >= 2000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(1), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Natural Armor +1");
                            Pricing.CalculatePrice(script, amulet);
                            return 2000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Amulets of Health and Wisdom
                case ITEM_PROPERTY_ABILITY_BONUS:
                    {
                        int abilityScore = IP_CONST_ABILITY_CON;
                        string name = "Amulet of Health";
                        if (script.d2(1) == 1)
                        {
                            abilityScore = IP_CONST_ABILITY_WIS;
                            name = "Amulet of Wisdom";
                        }
                        if (maxValue >= 36000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 6), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +6");
                            Pricing.CalculatePrice(script, amulet);
                            return 36000;
                        }
                        else if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 5), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +5");
                            Pricing.CalculatePrice(script, amulet);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 4), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +4");
                            Pricing.CalculatePrice(script, amulet);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 3), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +3");
                            Pricing.CalculatePrice(script, amulet);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 2), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +2");
                            Pricing.CalculatePrice(script, amulet);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAbilityBonus(abilityScore, 1), amulet, 0.0f);
                            script.SetFirstName(amulet, name + " +1");
                            Pricing.CalculatePrice(script, amulet);
                            return 1000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
                #region Amulets with Bonus Feats
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(selectedFeat), amulet, 0.0f);
                        switch (selectedFeat)
                        {
                            case IP_CONST_FEAT_COMBAT_CASTING:
                                script.SetFirstName(amulet, "Amulet of the Battlemage");
                                break;
                            case IP_CONST_FEAT_EXTRA_TURNING:
                                script.SetFirstName(amulet, "Amulet of Turning");
                                break;
                            case IP_CONST_FEAT_DARKVISION:
                                script.SetFirstName(amulet, "Amulet of Darkvision");
                                break;
                        }
                        Pricing.CalculatePrice(script, amulet);
                        return AvailableFeats[selectedFeat];
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
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, amulet);
                                return 66000;
                            }
                            else if (maxValue >= 54000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, amulet);
                                return 54000;
                            }
                            else if (maxValue >= 42000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, amulet);
                                return 42000;
                            }
                            else if (maxValue >= 30000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, amulet);
                                return 30000;
                            }
                            else if (maxValue >= 18000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, amulet);
                                return 18000;
                            }
                            else if (maxValue >= 6000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, amulet);
                                return 6000;
                            }
                        }
                        else
                        {
                            if (maxValue >= 44000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_30), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 30");
                                Pricing.CalculatePrice(script, amulet);
                                return 44000;
                            }
                            else if (maxValue >= 36000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_25), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 25");
                                Pricing.CalculatePrice(script, amulet);
                                return 36000;
                            }
                            else if (maxValue >= 28000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_20), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 20");
                                Pricing.CalculatePrice(script, amulet);
                                return 28000;
                            }
                            else if (maxValue >= 20000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_15), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 15");
                                Pricing.CalculatePrice(script, amulet);
                                return 20000;
                            }
                            else if (maxValue >= 12000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_10), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 10");
                                Pricing.CalculatePrice(script, amulet);
                                return 12000;
                            }
                            else if (maxValue >= 4000)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageResistance(damageResistType, IP_CONST_DAMAGERESIST_5), amulet, 0.0f);
                                script.SetFirstName(amulet, DamageResistanceNames[damageResistType] + ", 5");
                                Pricing.CalculatePrice(script, amulet);
                                return 4000;
                            }
                        }
                        break;
                    }
                #endregion
                #region Freedom of Movement
                case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyFreeAction(), amulet, 0.0f);
                        script.SetFirstName(amulet, "Amulet of Freedom");
                        Pricing.CalculatePrice(script, amulet);
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
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyImmunityMisc(selectedImmunity), amulet, 0.0f);
                        switch (selectedImmunity)
                        {
                            case IP_CONST_IMMUNITYMISC_DEATH_MAGIC:
                                script.SetFirstName(amulet, "Amulet of Lifeshielding");
                                break;
                            case IP_CONST_IMMUNITYMISC_DISEASE:
                                script.SetFirstName(amulet, "Amulet of Good Health");
                                break;
                            case IP_CONST_IMMUNITYMISC_FEAR:
                                script.SetFirstName(amulet, "Amulet of Fearlessness");
                                break;
                            case IP_CONST_IMMUNITYMISC_KNOCKDOWN:
                                script.SetFirstName(amulet, "Amulet of Stability");
                                break;
                            case IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN:
                                script.SetFirstName(amulet, "Amulet of Undeath's Deflection");
                                break;
                            case IP_CONST_IMMUNITYMISC_PARALYSIS:
                                script.SetFirstName(amulet, "Amulet of Mobility");
                                break;
                            case IP_CONST_IMMUNITYMISC_POISON:
                                script.SetFirstName(amulet, "Amulet of Antivenom");
                                break;
                        }
                        Pricing.CalculatePrice(script, amulet);
                        return AvailableImmunities[selectedImmunity];
                    }
                #endregion
                #region Saving Throws
                case ITEM_PROPERTY_SAVING_THROW_BONUS:
                    {
                        if (maxValue >= 25000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 5), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Resistance +5");
                            Pricing.CalculatePrice(script, amulet);
                            return 25000;
                        }
                        else if (maxValue >= 16000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 4), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Resistance +4");
                            Pricing.CalculatePrice(script, amulet);
                            return 16000;
                        }
                        else if (maxValue >= 9000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 3), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Resistance +3");
                            Pricing.CalculatePrice(script, amulet);
                            return 9000;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 2), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Resistance +2");
                            Pricing.CalculatePrice(script, amulet);
                            return 4000;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(IP_CONST_SAVEVS_UNIVERSAL, 1), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Resistance +1");
                            Pricing.CalculatePrice(script, amulet);
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
                        script.SetFirstName(amulet, SaveTypeNames[saveType]);
                        if (maxValue >= 6250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 5), amulet, 0.0f);
                            script.SetFirstName(amulet, String.Format("{0} +5", script.GetName(amulet)));
                            Pricing.CalculatePrice(script, amulet);
                            return 6250;
                        }
                        else if (maxValue >= 4000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 4), amulet, 0.0f);
                            script.SetFirstName(amulet, String.Format("{0} +4", script.GetName(amulet)));
                            Pricing.CalculatePrice(script, amulet);
                            return 4000;
                        }
                        else if (maxValue >= 2250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 3), amulet, 0.0f);
                            script.SetFirstName(amulet, String.Format("{0} +3", script.GetName(amulet)));
                            Pricing.CalculatePrice(script, amulet);
                            return 2250;
                        }
                        else if (maxValue >= 1000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 2), amulet, 0.0f);
                            script.SetFirstName(amulet, String.Format("{0} +2", script.GetName(amulet)));
                            Pricing.CalculatePrice(script, amulet);
                            return 1000;
                        }
                        else if (maxValue >= 250)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSavingThrowVsX(saveType, 1), amulet, 0.0f);
                            script.SetFirstName(amulet, String.Format("{0} +1", script.GetName(amulet)));
                            Pricing.CalculatePrice(script, amulet);
                            return 250;
                        }
                        break;
                    }
                #endregion
                #region Skill Bonus
                case ITEM_PROPERTY_SKILL_BONUS:
                    {
                        int skillBonus = AvailableSkills[Generation.rand.Next(AvailableSkills.Count)];
                        script.SetFirstName(amulet, SkillNames[skillBonus]);
                        if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 10), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +10");
                            Pricing.CalculatePrice(script, amulet);
                            return 10000;
                        }
                        else if (maxValue >= 8100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 9), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +9");
                            Pricing.CalculatePrice(script, amulet);
                            return 8100;
                        }
                        else if (maxValue >= 6400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 8), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +8");
                            Pricing.CalculatePrice(script, amulet);
                            return 6400;
                        }
                        else if (maxValue >= 4900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 7), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +7");
                            Pricing.CalculatePrice(script, amulet);
                            return 4900;
                        }
                        else if (maxValue >= 3600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 6), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +6");
                            Pricing.CalculatePrice(script, amulet);
                            return 3600;
                        }
                        else if (maxValue >= 2500)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 5), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +5");
                            Pricing.CalculatePrice(script, amulet);
                            return 2500;
                        }
                        else if (maxValue >= 1600)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 4), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +4");
                            Pricing.CalculatePrice(script, amulet);
                            return 1600;
                        }
                        else if (maxValue >= 900)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 3), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +3");
                            Pricing.CalculatePrice(script, amulet);
                            return 900;
                        }
                        else if (maxValue >= 400)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 2), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +2");
                            Pricing.CalculatePrice(script, amulet);
                            return 400;
                        }
                        else if (maxValue >= 100)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertySkillBonus(skillBonus, 1), amulet, 0.0f);
                            script.SetFirstName(amulet, script.GetName(amulet) + " +1");
                            Pricing.CalculatePrice(script, amulet);
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
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_26), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 26");
                            Pricing.CalculatePrice(script, amulet);
                            return 140000;
                        }
                        else if (maxValue >= 120000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 24");
                            Pricing.CalculatePrice(script, amulet);
                            return 120000;
                        }
                        else if (maxValue >= 100000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_22), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 22");
                            Pricing.CalculatePrice(script, amulet);
                            return 100000;
                        }
                        else if (maxValue >= 80000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_20), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 20");
                            Pricing.CalculatePrice(script, amulet);
                            return 80000;
                        }
                        else if (maxValue >= 60000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 18");
                            Pricing.CalculatePrice(script, amulet);
                            return 60000;
                        }
                        else if (maxValue >= 40000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 16");
                            Pricing.CalculatePrice(script, amulet);
                            return 40000;
                        }
                        else if (maxValue >= 20000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 14");
                            Pricing.CalculatePrice(script, amulet);
                            return 20000;
                        }
                        else if (maxValue >= 10000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 12");
                            Pricing.CalculatePrice(script, amulet);
                            return 10000;
                        }
                        else if (maxValue >= 6000)
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_10), amulet, 0.0f);
                            script.SetFirstName(amulet, "Amulet of Spell Resistance, 10");
                            Pricing.CalculatePrice(script, amulet);
                            return 6000;
                        }
                        else
                        {
                            return 0;
                        }
                    }
                #endregion
            }
            // Something has gone wrong. Nuke that amulet before it spreads the plague.
            script.DestroyObject(amulet, 0.0f, FALSE);
            return 0;
        }

        public static Dictionary<int, int> PrimaryAmuletAbility = new Dictionary<int, int>
        {
            {ITEM_PROPERTY_AC_BONUS, 2000},
            {ITEM_PROPERTY_ABILITY_BONUS, 1000},
            {ITEM_PROPERTY_BONUS_FEAT, 2500},
            {ITEM_PROPERTY_DAMAGE_RESISTANCE, 4000},
            {ITEM_PROPERTY_FREEDOM_OF_MOVEMENT, 40000},
            {ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, 7500},
            {ITEM_PROPERTY_SAVING_THROW_BONUS, 1000},
            {ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, 250},
            {ITEM_PROPERTY_SKILL_BONUS, 100},
            {ITEM_PROPERTY_SPELL_RESISTANCE, 6000},
        };

        public static Dictionary<int, int> AvailableImmunities = new Dictionary<int, int>
        {
            {IP_CONST_IMMUNITYMISC_DEATH_MAGIC, 80000},
            {IP_CONST_IMMUNITYMISC_DISEASE, 7500},
            {IP_CONST_IMMUNITYMISC_FEAR, 10000},
            {IP_CONST_IMMUNITYMISC_KNOCKDOWN, 22500},
            {IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN, 40000},
            {IP_CONST_IMMUNITYMISC_PARALYSIS, 15000},
            {IP_CONST_IMMUNITYMISC_POISON, 25000}
        };

        public static Dictionary<int, int> AvailableFeats = new Dictionary<int, int>
        {
            {IP_CONST_FEAT_DARKVISION, 2500},
            {IP_CONST_FEAT_COMBAT_CASTING, 5000},
            {IP_CONST_FEAT_EXTRA_TURNING, 7500}
        };

        public static List<int> AvailableSaveTypes = new List<int>
        {
            IP_CONST_SAVEVS_ACID,
            IP_CONST_SAVEVS_COLD,
            IP_CONST_SAVEVS_DEATH,
            IP_CONST_SAVEVS_DISEASE,
            IP_CONST_SAVEVS_DIVINE,
            IP_CONST_SAVEVS_ELECTRICAL,
            IP_CONST_SAVEVS_FEAR,
            IP_CONST_SAVEVS_FIRE,
            IP_CONST_SAVEVS_NEGATIVE,
            IP_CONST_SAVEVS_POISON,
            IP_CONST_SAVEVS_SONIC
        };

        public static Dictionary<int, string> SaveTypeNames = new Dictionary<int, string>
        {
            {IP_CONST_SAVEVS_ACID, "Alkaline Amulet"},
            {IP_CONST_SAVEVS_COLD, "Warming Amulet"},
            {IP_CONST_SAVEVS_DEATH, "Antinecromantic Amulet"},
            {IP_CONST_SAVEVS_DISEASE, "Irongut Amulet"},
            {IP_CONST_SAVEVS_ELECTRICAL, "Insulating Amulet"},
            {IP_CONST_SAVEVS_FEAR, "Fearless Amulet"},
            {IP_CONST_SAVEVS_FIRE, "Cooling Amulet"},
            {IP_CONST_SAVEVS_NEGATIVE, "Antinecromantic Amulet"},
            {IP_CONST_SAVEVS_POISON, "Antivenom Amulet"},
            {IP_CONST_SAVEVS_SONIC, "Dampening Amulet"},
        };

        public static List<int> AvailableSkills = new List<int>
        {
            SKILL_APPRAISE,
            SKILL_FORGERY,
            SKILL_INTIMIDATE,
            SKILL_LISTEN,
            SKILL_SEARCH,
            SKILL_SENSE_MOTIVE,
            SKILL_SPOT,
            SKILL_SPELLCRAFT,
        };

        public static Dictionary<int, string> SkillNames = new Dictionary<int, string>
        {
            {SKILL_APPRAISE, "Amulet of Appraisal"},
            {SKILL_INTIMIDATE, "Amulet of Intimidation"},
            {SKILL_LISTEN, "Amulet of Sharp Ear"},
            {SKILL_SEARCH, "Amulet of the Discerning Eye"},
            {SKILL_SENSE_MOTIVE, "Amulet of Scrutiny"},
            {SKILL_SPOT, "Amulet of the Eagle Eye"},
            {SKILL_SPELLCRAFT, "Amulet of Wizardly Study"},
        };

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
            {IP_CONST_DAMAGETYPE_ACID, "Acidproof Amulet" },
            {IP_CONST_DAMAGETYPE_COLD, "Frostproof Amulet" },
            {IP_CONST_DAMAGETYPE_FIRE, "Fireproof Amulet" },
            {IP_CONST_DAMAGETYPE_ELECTRICAL, "Shockproof Amulet" },
            {IP_CONST_DAMAGETYPE_SONIC, "Soundproof Amulet" },
            {IP_CONST_DAMAGETYPE_NEGATIVE, "Necromancyproof Amulet" },
        };
    }
}

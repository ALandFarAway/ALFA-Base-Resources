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
    public class GenerateArmor: CLRScriptBase
    {
        public static int NewArmor(CLRScriptBase script, int maxValue)
        {
            #region Calculate Armor Type
            List<int> possibleBaseItems = new List<int>();
            foreach (int armorType in ArmorResRefs.Keys)
            {
                if (Pricing.ArmorRulesTypeValues[armorType] <= maxValue)
                {
                    possibleBaseItems.Add(armorType);
                }
            }
            if (possibleBaseItems.Count == 0)
            {
                // Can't afford any armor. What are we doing here?
                return 0;
            }
            int selectedArmorType = possibleBaseItems[Generation.rand.Next(possibleBaseItems.Count)];
            int armorValue = Pricing.ArmorRulesTypeValues[selectedArmorType];
            maxValue -= armorValue;
            uint armor = script.CreateItemOnObject(ArmorResRefs[selectedArmorType], script.OBJECT_SELF, 1, "", FALSE);
            #endregion

            #region Armor Appearance
            Generation.Theme armorTheme = Generation.GetEnchantmentTheme();
            if (script.GetBaseItemType(armor) == BASE_ITEM_ARMOR)
            {
                script.StoreCampaignObject(ACR_Items.ItemChangeDBName, ACR_Items.ModelChangeVarName, armor, script.OBJECT_SELF);
                ArmorSet set = null;
                switch (selectedArmorType)
                {
                    case ARMOR_RULES_TYPE_BANDED:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Banded][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Banded].Count)];
                        break;
                    case ARMOR_RULES_TYPE_BREASTPLATE:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Breastplate][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Breastplate].Count)];
                        break;
                    case ARMOR_RULES_TYPE_CHAIN_SHIRT:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.ChainShirt][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.ChainShirt].Count)];
                        break;
                    case ARMOR_RULES_TYPE_CHAINMAIL:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Chainmail][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Chainmail].Count)];
                        break;
                    case ARMOR_RULES_TYPE_CLOTH:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Cloth][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Cloth].Count)];
                        break;
                    case ARMOR_RULES_TYPE_FULL_PLATE:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.FullPlate][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.FullPlate].Count)];
                        break;
                    case ARMOR_RULES_TYPE_HALF_PLATE:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.HalfPlate][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.HalfPlate].Count)];
                        break;
                    case ARMOR_RULES_TYPE_HIDE:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Hide][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Hide].Count)];
                        break;
                    case ARMOR_RULES_TYPE_LEATHER:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Leather][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Leather].Count)];
                        break;
                    case ARMOR_RULES_TYPE_PADDED:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Padded][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Padded].Count)];
                        break;
                    case ARMOR_RULES_TYPE_SCALE:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Scale][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.Scale].Count)];
                        break;
                    case ARMOR_RULES_TYPE_STUDDED_LEATHER:
                        set = ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.StuddedLeather][Generation.rand.Next(ACR_Items.ArmorSetLibrary[ACR_Items.ArmorSetTypes.StuddedLeather].Count)];
                        break;
                }
                if (set != null)
                {
                    ItemModels.TakeArmorStyle(ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName], set);
                }
                ColorPair color = GeneratedColors.ColorPairs[armorTheme][Generation.rand.Next(GeneratedColors.ColorPairs[armorTheme].Count)];
                ItemColors.SetColorThemes(ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName], color.Primary, color.Accent);
                script.DestroyObject(armor, 0.0f, TRUE);
                armor = script.RetrieveCampaignObject(ACR_Items.ItemChangeDBName, ACR_Items.ModelChangeVarName, script.GetLocation(script.OBJECT_SELF), script.OBJECT_SELF, script.OBJECT_SELF);
            }
            #endregion

            #region See if We Want This to be Masterwork
            if (maxValue >= 150)
            {
                switch (selectedArmorType)
                {
                    case ARMOR_RULES_TYPE_BANDED:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_BANDED_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_BREASTPLATE:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_BREASTPLATE_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_CHAIN_SHIRT:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_CHAIN_SHIRT_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_CHAINMAIL:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_CHAINMAIL_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_FULL_PLATE:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_FULL_PLATE_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_HALF_PLATE:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_HALF_PLATE_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_HIDE:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_HIDE_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_LEATHER:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_LEATHER_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_PADDED:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_PADDED_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_SCALE:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_SCALE_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_SHIELD_HEAVY:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_SHIELD_HEAVY_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_SHIELD_LIGHT:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_SHIELD_LIGHT_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_SHIELD_TOWER:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_SHIELD_TOWER_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_SPLINT:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_SPLINT_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                    case ARMOR_RULES_TYPE_STUDDED_LEATHER:
                        script.SetArmorRulesType(armor, ARMOR_RULES_TYPE_STUDDED_LEATHER_MASTERWORK);
                        armorValue += 150;
                        maxValue -= 150;
                        break;
                }
            }
            else
            {
                // We can't even afford masterwork. Carry on.
                return armorValue;
            }
            #endregion

            #region Calculate Effective Plus
            double effectivePlusRemaining = Math.Sqrt((double)(maxValue / 1000)); // we cast after the division because we're going to turn this into an int later.
            double currentEffectivePlus = 0.0;
            #endregion

            #region Set Base Properties
            int enhancementBonus = 0;
            if (effectivePlusRemaining >= 1.0)
            {
                enhancementBonus = 1;
                effectivePlusRemaining -= 1;
                currentEffectivePlus = 1;
                bool quirkAdded = false;
                while (effectivePlusRemaining >= 1)
                {
                    if (Generation.rand.Next(100) > 95)
                    {
                        // The remainder of the enchantment will
                        // be personality heavy.
                        break;
                    }
                    if (!quirkAdded && Generation.rand.Next(100) < 75)
                    {
                        enhancementBonus += 1;
                        effectivePlusRemaining -= 1;
                        currentEffectivePlus += 1;
                    }
                    else
                    {
                        List<EnhancementTypes> quirks = BuildBaseEnchantmentPossibilities(script.GetBaseItemType(armor), effectivePlusRemaining);
                        if (quirks.Count > 0)
                        {
                            EnhancementTypes quirk = quirks[Generation.rand.Next(quirks.Count)];
                            if (selectedArmorType == ARMOR_RULES_TYPE_CLOTH &&
                                quirk == EnhancementTypes.Twilight)
                            {
                                quirk = EnhancementTypes.SpellFocus;
                            }
                            switch (quirk)
                            {
                                case EnhancementTypes.CombatCasting:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(IP_CONST_FEAT_COMBAT_CASTING), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Battlemage's {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1;
                                    currentEffectivePlus += 1;
                                    break;
                                case EnhancementTypes.DeflectArrows:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(IP_CONST_FEAT_DEFLECT_ARROWS), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Arrowcatching {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 2;
                                    currentEffectivePlus += 2;
                                    break;
                                case EnhancementTypes.Dodge:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Nimble {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1;
                                    currentEffectivePlus += 1;
                                    break;
                                case EnhancementTypes.ExtraTurning:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_TURNING), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Turning {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1;
                                    currentEffectivePlus += 1;
                                    break;
                                case EnhancementTypes.SpellFocus:
                                    int primarySchool = Generation.SpellSchoolFocus[Generation.rand.Next(Generation.SpellSchoolFocus.Count)];
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(primarySchool), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Mage's {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1;
                                    currentEffectivePlus += 1;
                                    if (effectivePlusRemaining >= 0.5)
                                    {
                                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(Generation.SpellFocusLeft[primarySchool]), armor, 0.0f);
                                        effectivePlusRemaining -= 0.5;
                                        currentEffectivePlus += 0.5;
                                    }
                                    if (effectivePlusRemaining >= 0.5)
                                    {
                                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(Generation.SpellFocusRight[primarySchool]), armor, 0.0f);
                                        effectivePlusRemaining -= 0.5;
                                        currentEffectivePlus += 0.5;
                                    }
                                    break;
                                case EnhancementTypes.SpellPenetration:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLPENETRATION), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Mage's {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1.5;
                                    currentEffectivePlus += 1.5;
                                    break;
                                case EnhancementTypes.SR12:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_12), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Spellsoaking {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 2;
                                    currentEffectivePlus += 2;
                                    break;
                                case EnhancementTypes.SR14:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_14), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Spellsoaking {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 3;
                                    currentEffectivePlus += 3;
                                    break;
                                case EnhancementTypes.SR16:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Spellsoaking {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 4;
                                    currentEffectivePlus += 4;
                                    break;
                                case EnhancementTypes.SR18:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_18), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Spellsoaking {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 5;
                                    currentEffectivePlus += 5;
                                    break;
                                case EnhancementTypes.Twilight:
                                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT), armor, 0.0f);
                                    script.SetFirstName(armor, String.Format("Twilight {0}", script.GetName(armor)));
                                    effectivePlusRemaining -= 1;
                                    currentEffectivePlus += 1;
                                    break;
                            }
                        }
                        quirkAdded = true;
                    }
                }
                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonus(enhancementBonus), armor, 0.0f);
                script.SetFirstName(armor, String.Format("{0} +{1}", script.GetName(armor), enhancementBonus));
            }
            #endregion

            #region Armor Personality
            SetPersonalityProperties(script, armor, armorTheme, enhancementBonus, ref effectivePlusRemaining, ref currentEffectivePlus);
            armorValue += (int)(currentEffectivePlus * currentEffectivePlus * 1000);
            Pricing.CalculatePrice(script, armor);
            return armorValue;
            #endregion
        }

        private static void SetPersonalityProperties(CLRScriptBase script, uint armor, Generation.Theme theme, int baseEnhancement, ref double effectivePlusRemaining, ref double currentEffectivePlus)
        {
            switch (theme)
            {
                case Generation.Theme.Acid:
                case Generation.Theme.Cold:
                case Generation.Theme.Fire:
                case Generation.Theme.Electricity:
                case Generation.Theme.Sound:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsElementalAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsElementalAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsElementalAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsElementalAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsElementalAC = baseEnhancement + 1;
                            }
                            if (vsElementalAC > 5) vsElementalAC = 5;
                            if (vsElementalAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_ELEMENTAL, vsElementalAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Elementalwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsElementalAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsElementalAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.ConstructSlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsConstructAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsConstructAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsConstructAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsConstructAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsConstructAC = baseEnhancement + 1;
                            }
                            if (vsConstructAC > 5) vsConstructAC = 5;
                            if (vsConstructAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_CONSTRUCT, vsConstructAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Golemwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsConstructAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsConstructAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.DemonSlaying:
                case Generation.Theme.DevilSlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsOutsiderAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsOutsiderAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsOutsiderAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsOutsiderAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsOutsiderAC = baseEnhancement + 1;
                            }
                            if (vsOutsiderAC > 5) vsOutsiderAC = 5;
                            if (vsOutsiderAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, vsOutsiderAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Fiendwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsOutsiderAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsOutsiderAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.DragonSlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsDragonAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsDragonAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsDragonAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsDragonAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsDragonAC = baseEnhancement + 1;
                            }
                            if (vsDragonAC > 5) vsDragonAC = 5;
                            if (vsDragonAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_DRAGON, vsDragonAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Dragonwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsDragonAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsDragonAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.FeySlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsFeyAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsFeyAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsFeyAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsFeyAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsFeyAC = baseEnhancement + 1;
                            }
                            if (vsFeyAC > 5) vsFeyAC = 5;
                            if (vsFeyAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_FEY, vsFeyAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Feywarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsFeyAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsFeyAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.GiantSlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsGiantAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsGiantAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsGiantAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsGiantAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsGiantAC = baseEnhancement + 1;
                            }
                            if (vsGiantAC > 5) vsGiantAC = 5;
                            if (vsGiantAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_GIANT, vsGiantAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Giantwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsGiantAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsGiantAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.Holy:
                    {
                        if (effectivePlusRemaining >= 0.5)
                        {
                            int vsEvilAC = 0;
                            if (effectivePlusRemaining >= 2.0)
                            {
                                vsEvilAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.5)
                            {
                                vsEvilAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsEvilAC = baseEnhancement + 2;
                            }
                            else if (effectivePlusRemaining >= 0.5)
                            {
                                vsEvilAC = baseEnhancement + 1;
                            }
                            if (vsEvilAC > 5) vsEvilAC = 5;
                            if (vsEvilAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, vsEvilAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("Holy {0}", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsEvilAC - baseEnhancement)) / 2.0;
                                currentEffectivePlus += ((double)(vsEvilAC - baseEnhancement)) / 2.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.Themeless:
                    {
                        // Not much we can do with no theme. Return a less-than-max-value item
                        return;
                    }
                case Generation.Theme.UndeadSlaying:
                    {
                        if (effectivePlusRemaining >= (1.0 / 3.0))
                        {
                            int vsUndeadAC = 0;
                            if (effectivePlusRemaining >= (4.0 / 3.0))
                            {
                                vsUndeadAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.0)
                            {
                                vsUndeadAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= (2.0 / 3.0))
                            {
                                vsUndeadAC = baseEnhancement + 2;
                            }
                            else
                            {
                                vsUndeadAC = baseEnhancement + 1;
                            }
                            if (vsUndeadAC > 5) vsUndeadAC = 5;
                            if (vsUndeadAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, vsUndeadAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("{0} of Undeadwarding", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsUndeadAC - baseEnhancement)) / 3.0;
                                currentEffectivePlus += ((double)(vsUndeadAC - baseEnhancement)) / 3.0;
                                return;
                            }
                        }
                        return;
                    }
                case Generation.Theme.Unholy:
                    {
                        if (effectivePlusRemaining >= 0.5)
                        {
                            int vsGoodAC = 0;
                            if (effectivePlusRemaining >= 1.6)
                            {
                                vsGoodAC = baseEnhancement + 4;
                            }
                            else if (effectivePlusRemaining >= 1.2)
                            {
                                vsGoodAC = baseEnhancement + 3;
                            }
                            else if (effectivePlusRemaining >= 0.8)
                            {
                                vsGoodAC = baseEnhancement + 2;
                            }
                            else if (effectivePlusRemaining >= 0.4)
                            {
                                vsGoodAC = baseEnhancement + 1;
                            }
                            if (vsGoodAC > 5) vsGoodAC = 5;
                            if (vsGoodAC > baseEnhancement)
                            {
                                script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyACBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, vsGoodAC), armor, 0.0f);
                                script.SetFirstName(armor, String.Format("Unholy {0}", script.GetName(armor)));
                                effectivePlusRemaining -= ((double)(vsGoodAC - baseEnhancement)) * 2.0 / 5.0;
                                currentEffectivePlus += ((double)(vsGoodAC - baseEnhancement)) * 2.0 / 5.0;
                                return;
                            }
                        }
                        return;
                    }
            }
        }

        public static List<EnhancementTypes> BuildBaseEnchantmentPossibilities(int itemType, double effectivePlus)
        {
            List<EnhancementTypes> retVal = new List<EnhancementTypes>();
            bool isShield = false;
            if (itemType != BASE_ITEM_ARMOR)
            {
                isShield = true;
            }
            if (effectivePlus >= 1.0)
            {
                retVal.Add(EnhancementTypes.CombatCasting);
                retVal.Add(EnhancementTypes.Twilight);
                if (!isShield)
                {
                    retVal.Add(EnhancementTypes.Dodge);
                    retVal.Add(EnhancementTypes.SpellFocus);
                }
                else
                {
                    retVal.Add(EnhancementTypes.ExtraTurning);
                }
            }
            if (effectivePlus >= 1.5 && !isShield)
            {
                retVal.Add(EnhancementTypes.SpellPenetration);
            }
            if (effectivePlus >= 2.0)
            {
                retVal.Add(EnhancementTypes.DeflectArrows);
                retVal.Add(EnhancementTypes.SR12);
            }
            if (effectivePlus >= 3.0)
            {
                retVal.Add(EnhancementTypes.SR14);
            }
            if (effectivePlus >= 4.0f)
            {
                retVal.Add(EnhancementTypes.SR16);
            }
            if (effectivePlus >= 5.0)
            {
                retVal.Add(EnhancementTypes.SR18);
            }
            return retVal;
        }

        public static Dictionary<int, string> ArmorResRefs = new Dictionary<int, string>
        {
            {ARMOR_RULES_TYPE_BANDED, "nw_aarcl011"},
            {ARMOR_RULES_TYPE_BREASTPLATE, "nw_aarcl010"},
            {ARMOR_RULES_TYPE_CHAIN_SHIRT, "nw_aarcl012"},
            {ARMOR_RULES_TYPE_CHAINMAIL, "nw_aarcl004"},
            {ARMOR_RULES_TYPE_CLOTH, "nw_cloth005"},
            {ARMOR_RULES_TYPE_FULL_PLATE, "nw_aarcl007"},
            {ARMOR_RULES_TYPE_HALF_PLATE, "nw_aarcl006"},
            {ARMOR_RULES_TYPE_HIDE, "nw_aarcl008"},
            {ARMOR_RULES_TYPE_LEATHER, "nw_aarcl001"},
            {ARMOR_RULES_TYPE_PADDED, "nw_aarcl009"},
            {ARMOR_RULES_TYPE_SCALE, "nw_aarcl003"},
            {ARMOR_RULES_TYPE_SHIELD_HEAVY, "nw_ashlw001"},
            {ARMOR_RULES_TYPE_SHIELD_LIGHT, "nw_ashsw001"},
            {ARMOR_RULES_TYPE_SHIELD_TOWER, "nw_ashto001"},
            {ARMOR_RULES_TYPE_STUDDED_LEATHER, "nw_aarcl002"},
        };

        public enum EnhancementTypes
        {
            DeflectArrows,
            CombatCasting,
            Dodge,
            ExtraTurning,
            SpellFocus,
            SpellPenetration,
            Twilight,
            SR12,
            SR14,
            SR16,
            SR18,
        }
    }
}

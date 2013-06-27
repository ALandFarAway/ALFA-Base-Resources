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

namespace ACR_Items
{
    public class Pricing : CLRScriptBase
    {
        const string ItemChangeDBName = "VDB_ItMod";
        const string PriceChangeVarName = "PriceChange";

        const int MasterworkWeaponValue = 300;
        const int MasterworkArmorValue = 150;
        
        public static void AdjustPrice(CLRScriptBase script, uint target, int adjustBy)
        {
            if (script.GetObjectType(target) != OBJECT_TYPE_ITEM)
                return;

            script.StoreCampaignObject(ItemChangeDBName, PriceChangeVarName, target, script.OBJECT_SELF);
            if (ALFA.Shared.Modules.InfoStore.ModifiedGff.Keys.Contains(PriceChangeVarName))
            {
                script.SendMessageToAllDMs("index found");
                int currentModifyCost = 0;
                if (int.TryParse(ALFA.Shared.Modules.InfoStore.ModifiedGff[PriceChangeVarName].TopLevelStruct["ModifyCost"].Value.ToString(), out currentModifyCost))
                {
                    script.SendMessageToAllDMs("value adjustment");
                    currentModifyCost += adjustBy;
                    ALFA.Shared.Modules.InfoStore.ModifiedGff[PriceChangeVarName].TopLevelStruct["ModifyCost"].Value = currentModifyCost;
                }
            }
            script.RetrieveCampaignObject(ItemChangeDBName, PriceChangeVarName, script.GetLocation(script.OBJECT_SELF), script.OBJECT_SELF, script.OBJECT_SELF);
        }

        public static void CalculatePrice(CLRScriptBase script, uint target)
        {
            if (script.GetObjectType(target) != OBJECT_TYPE_ITEM)
            {
                return;
            }

            int itemType = script.GetBaseItemType(target);
            if (GetIsOOCItem(itemType))
            {
                return;
            }
            if (GetIsWeapon(itemType))
            {
                script.SendMessageToAllDMs(GetWeaponPrice(script, target).ToString());
            }
            if (GetIsArmor(itemType))
            {
                script.SendMessageToAllDMs(GetArmorPrice(script, target).ToString());
            }
        }

        private static int GetWeaponPrice(CLRScriptBase script, uint target)
        {
            #region Initialize commonly-used variables
            int value = BaseItemValues[script.GetBaseItemType(target)];
            int itemType = script.GetBaseItemType(target);
            int enchantmentPenalty = 0;
            bool masterworkCounted = false;
            int specialMat = script.GetItemBaseMaterialType(target);
            #endregion

            #region Load item properties into the price calculation collection
            List<PricedItemProperty> itProps = new List<PricedItemProperty>();
            foreach(NWItemProperty prop in script.GetItemPropertiesOnItem(target))
            {
                itProps.Add(new PricedItemProperty() { Property = prop, Price = 0 });
            }
            #endregion

            #region Check for Mundane Items
            if (itProps.Count == 0 &&
                (specialMat == GMATERIAL_METAL_IRON || specialMat == GMATERIAL_NONSPECIFIC))
            {
                // No item properties. This is just worth the base item.
                return value;
            }
            #endregion

            #region Clear out Properties that Come from Special Materials; Set Base Price By Special Materials
            if (specialMat != GMATERIAL_METAL_IRON &&
                specialMat != GMATERIAL_NONSPECIFIC)
            {
                #region Adamantine
                if (specialMat == GMATERIAL_METAL_ADAMANTINE)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 800;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 2000;
                    }
                    else
                    {
                        value += 1400;
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Silver and Alchemical Silver
                else if (specialMat == GMATERIAL_METAL_ALCHEMICAL_SILVER)
                {
                    if (GetIsAlchemicalSilver(script, itProps))
                    {
                        if (GetIsAmmunition(itemType))
                        {
                            value += 200;
                        }
                        else if (GetIsLightWeapon(itemType))
                        {
                            value += 20;
                        }
                        else if (GetIsHeavyWeapon(itemType))
                        {
                            value += 180;
                        }
                        else
                        {
                            value += 90;
                        }
                    }
                    else
                    {
                        if (GetIsAmmunition(itemType))
                        {
                            value += 1500;
                        }
                        else if (GetIsLightWeapon(itemType))
                        {
                            value += 1500;
                        }
                        else if (GetIsHeavyWeapon(itemType))
                        {
                            value += 3500;
                        }
                        else
                        {
                            value += 2500;
                        }
                    }
                }
                #endregion

                #region Arandur
                else if (specialMat == GMATERIAL_ARANDUR)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 2000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 4000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d3))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d3), target, 0.0f);
                        }
                    }
                    else
                    {
                        value += 3000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d2))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d2), target, 0.0f);
                        }
                    }
                }
                #endregion

                #region Bluewood
                else if (specialMat == GMATERIAL_BLUEWOOD)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 400;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 400;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 900;
                    }
                    else
                    {
                        value += 600;
                    }
                    if(!GetIsHalfWeight(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Cold Iron
                else if (specialMat == GMATERIAL_METAL_COLD_IRON)
                {
                    value += BaseItemValues[script.GetBaseItemType(target)];
                    enchantmentPenalty = 2000;
                }
                #endregion

                #region Copper
                // Copper weapons have no special properties or pricing.
                #endregion

                #region Darksteel
                else if (specialMat == GMATERIAL_METAL_DARKSTEEL)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 2000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 4000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d3))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d3), target, 0.0f);
                        }
                    }
                    else
                    {
                        value += 3000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d2))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d2), target, 0.0f);
                        }
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Dlarun
                else if (specialMat == GMATERIAL_DLARUN)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 2000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 4000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d3))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d3), target, 0.0f);
                        }
                    }
                    else
                    {
                        value += 3000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d2))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d2), target, 0.0f);
                        }
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Black, Green, or Copper Dragon
                else if (specialMat == GMATERIAL_CREATURE_BLACK_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_GREEN_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_COPPER_DRAGON)
                {
                    value += 2000;
                    if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Blue or Brass Dragon
                else if (specialMat == GMATERIAL_CREATURE_BLUE_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_BRONZE_DRAGON)
                {
                    value += 2000;
                    if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Red, Brass, or Gold Dragon
                else if (specialMat == GMATERIAL_CREATURE_RED_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_BRASS_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_GOLD_DRAGON)
                {
                    value += 2000;
                    if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }                
                #endregion

                #region White or Silver Dragon
                else if (specialMat == GMATERIAL_CREATURE_WHITE_DRAGON ||
                        specialMat == GMATERIAL_CREATURE_SILVER_DRAGON)
                {
                    value += 2000;
                    if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Duskwood
                else if (specialMat == GMATERIAL_WOOD_DUSKWOOD)
                {
                    value += 1000;
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Fever Iron
                else if (specialMat == GMATERIAL_FEVER_IRON)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 2000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 4000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d3))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d3), target, 0.0f);
                        }
                    }
                    else
                    {
                        value += 3000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d2))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d2), target, 0.0f);
                        }
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Fiend Bone
                else if (specialMat == GMATERIAL_FIENDBONE)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 3500;
                    }
                    else
                    {
                        value += 2500;
                    }
                    if(!GetHasVersusAlignmentBonus(script, itProps, IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Frystalline
                else if (specialMat == GMATERIAL_FRYSTALLINE)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 3500;
                    }
                    else
                    {
                        value += 2500;
                    }
                    if (!GetHasVersusAlignmentBonus(script, itProps, IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGEBONUS_1))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Gold
                else if (specialMat == GMATERIAL_GOLD)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 1500;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 2500;
                    }
                    else
                    {
                        value += 3500;
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Hizagkuur
                else if (specialMat == GMATERIAL_FEVER_IRON)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 2000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1), target, 0.0f);
                        }
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 4000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d3))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d3), target, 0.0f);
                        }
                    }
                    else
                    {
                        value += 3000;
                        if (!GetHasElementalWeaponBonus(script, itProps, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d2))
                        {
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d2), target, 0.0f);
                        }
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Living Metal
                else if (specialMat == GMATERIAL_LIVING_METAL)
                {
                    value += 1000;
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Mithral
                else if (specialMat == GMATERIAL_METAL_MITHRAL)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 1000;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 1000;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 12000;
                    }
                    else
                    {
                        value += 6000;
                    }
                    if (!GetIsHalfWeight(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion

                #region Platinum
                // Platinum has no special properties as a weapon.
                #endregion

                #region Sondarr
                else if (specialMat == GMATERIAL_LIVING_METAL)
                {
                    value += 1000;
                }
                #endregion

                #region Zalantar
                else if (specialMat == GMATERIAL_WOOD_DARKWOOD)
                {
                    if (GetIsAmmunition(itemType))
                    {
                        value += 300;
                    }
                    else if (GetIsLightWeapon(itemType))
                    {
                        value += 300;
                    }
                    else if (GetIsHeavyWeapon(itemType))
                    {
                        value += 300;
                    }
                    else
                    {
                        value += 300;
                    }
                    int addedVal = 0;
                    if (int.TryParse(script.Get2DAString("baseitems", "TenthLBS", itemType), out addedVal))
                    {
                        value += addedVal;
                    }
                    if (!GetIsHalfWeight(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT), target, 0.0f);
                    }
                    if (!GetIsMasterwork(script, itProps))
                    {
                        script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), target, 0.0f);
                    }
                    masterworkCounted = true;
                }
                #endregion
            }
            #endregion

            #region Check for masterwork and mighty bonuses
            if (!masterworkCounted)
            {
                if (GetIsMasterwork(script, itProps))
                {
                    value += 300;
                }
            }
            foreach (PricedItemProperty prop in itProps)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_MIGHTY)
                {
                    if (itemType == BASE_ITEM_LONGBOW ||
                       itemType == BASE_ITEM_HEAVYCROSSBOW)
                    {
                        value += (100 * script.GetItemPropertyCostTableValue(prop.Property));
                    }
                    else
                    {
                        value += (75 * script.GetItemPropertyCostTableValue(prop.Property));
                    }
                }
            }
            #endregion

            #region Check for early return, if the item is only masterwork or special material
            if (itProps.Count == 0)
            {
                return value;
            }
            #endregion

            #region Calculate Magical Bonuses
            float effectivePlus = 0.0f;
            int ACvsEveryone = 0;
            int attackVsEveryone = 0;
            int enhancementVsEveryone = 0;
            #region Properties that are Indiscriminate
            foreach (PricedItemProperty prop in itProps)
            {
                int propType = script.GetItemPropertyType(prop.Property);
                switch (propType)
                {
                    #region Ability Score Bonus
                    case ITEM_PROPERTY_ABILITY_BONUS:
                        {
                            prop.Price = (script.GetItemPropertyCostTableValue(prop.Property) * script.GetItemPropertyCostTableValue(prop.Property) * 1000);
                            break;
                        }
                    #endregion
                    #region Bonus Armor Class
                    case ITEM_PROPERTY_AC_BONUS:
                        {
                            if (script.GetItemPropertyCostTableValue(prop.Property) > ACvsEveryone)
                            {
                                ACvsEveryone = ACvsEveryone = script.GetItemPropertyCostTableValue(prop.Property);
                            }
                            prop.Price = (ACvsEveryone * ACvsEveryone * 2000);
                            break;
                        }
                    #endregion
                    #region Magical Attack Bonus
                    case ITEM_PROPERTY_ATTACK_BONUS:
                        {
                            attackVsEveryone = script.GetItemPropertyCostTableValue(prop.Property);
                            effectivePlus += attackVsEveryone;
                            break;
                        }
                    #endregion
                    #region Base Item Weight Reduction
                    case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
                        {
                            // Question: do we call this item illegal?
                            break;
                        }
                    #endregion
                    #region Bonus Feat (disarm only)
                    case ITEM_PROPERTY_BONUS_FEAT:
                        {
                            if (script.GetItemPropertySubType(prop.Property) == IP_CONST_FEAT_DISARM)
                            {
                                effectivePlus += 0.5f;
                            }
                            else
                            {
                                return -1;
                            }
                            break;
                        }
                    #endregion
                    #region Bonus Spell Slot
                    case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
                        {
                            prop.Price = ((script.GetItemPropertyCostTableValue(prop.Property) * script.GetItemPropertyCostTableValue(prop.Property)) + 1) * 1000;
                            break;
                        }
                    #endregion
                    #region Cast Spell
                    case ITEM_PROPERTY_CAST_SPELL:
                        {
                            int spell = script.GetItemPropertySubType(prop.Property);
                            float spellLevel = 0.0f;
                            float casterLevel = 0.0f;
                            float.TryParse(script.Get2DAString("iprp_spells", "InnateLvl", spell), out spellLevel);
                            float.TryParse(script.Get2DAString("iprp_spells", "CasterLvl", spell), out casterLevel);
                            if (spellLevel < 0.5f)
                            {
                                spellLevel = 0.5f;
                            }
                            if (casterLevel < 1.0f)
                            {
                                spellLevel = 1.0f;
                            }
                            float multiplier = spellLevel * casterLevel;
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_CASTSPELL_NUMUSES_0_CHARGES_PER_USE:
                                    {
                                        return -1;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE:
                                    {
                                        prop.ChargedPrice = (int)(multiplier * 50);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY:
                                    {
                                        prop.Price = (int)(multiplier * 360);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE:
                                    {
                                        prop.ChargedPrice = (int)(multiplier * 25);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY:
                                    {
                                        prop.Price = (int)(multiplier * 720);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE:
                                    {
                                        prop.ChargedPrice = (int)(multiplier * 17);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY:
                                    {
                                        prop.Price = (int)(multiplier * 1080);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE:
                                    {
                                        prop.ChargedPrice = (int)(multiplier * 13);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY:
                                    {
                                        prop.Price = (int)(multiplier * 1440);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE:
                                    {
                                        prop.ChargedPrice = (int)(multiplier * 10);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY:
                                    {
                                        prop.Price = (int)(multiplier * 1800);
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE:
                                    {
                                        if (script.GetItemCharges(target) > 0)
                                        {
                                            prop.ChargedPrice = (int)((multiplier * 50) / script.GetItemCharges(target));
                                        }
                                        else
                                        {
                                            prop.Price = (int)(multiplier * 50);
                                        }
                                        break;
                                    }
                                case IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Damage Bonus
                    case ITEM_PROPERTY_DAMAGE_BONUS:
                        {
                            switch (script.GetItemPropertySubType(prop.Property))
                            {
                                case IP_CONST_DAMAGETYPE_ACID:
                                case IP_CONST_DAMAGETYPE_BLUDGEONING:
                                case IP_CONST_DAMAGETYPE_COLD:
                                case IP_CONST_DAMAGETYPE_ELECTRICAL:
                                case IP_CONST_DAMAGETYPE_FIRE:
                                case IP_CONST_DAMAGETYPE_PHYSICAL:
                                case IP_CONST_DAMAGETYPE_PIERCING:
                                case IP_CONST_DAMAGETYPE_SLASHING:
                                case IP_CONST_DAMAGETYPE_SONIC:
                                case IP_CONST_DAMAGETYPE_SUBDUAL:
                                    {
                                        switch (script.GetItemPropertyCostTableValue(prop.Property))
                                        {
                                            case IP_CONST_DAMAGEBONUS_1d4:
                                                {
                                                    effectivePlus += 1.0f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d6:
                                                {
                                                    effectivePlus += 1.5f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d8:
                                                {
                                                    effectivePlus += 2.2f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1:
                                                {
                                                    effectivePlus += 0.4f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_2:
                                                {
                                                    effectivePlus += 0.8f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_3:
                                                {
                                                    effectivePlus += 1.2f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_4:
                                                {
                                                    effectivePlus += 1.6f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_5:
                                                {
                                                    effectivePlus += 2.0f;
                                                    break;
                                                }
                                            default:
                                                {
                                                    return -1;
                                                }
                                        }
                                        break;
                                    }
                                case IP_CONST_DAMAGETYPE_NEGATIVE:
                                    {
                                        switch (script.GetItemPropertyCostTableValue(prop.Property))
                                        {
                                            case IP_CONST_DAMAGEBONUS_1d4:
                                                {
                                                    effectivePlus += 1.1f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d6:
                                                {
                                                    effectivePlus += 1.7f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d8:
                                                {
                                                    effectivePlus += 2.4f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1:
                                                {
                                                    effectivePlus += 0.5f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_2:
                                                {
                                                    effectivePlus += 0.9f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_3:
                                                {
                                                    effectivePlus += 1.3f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_4:
                                                {
                                                    effectivePlus += 1.8f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_5:
                                                {
                                                    effectivePlus += 2.2f;
                                                    break;
                                                }
                                            default:
                                                {
                                                    return -1;
                                                }
                                        }                                        
                                        break;
                                    }
                                case IP_CONST_DAMAGETYPE_DIVINE:
                                case IP_CONST_DAMAGETYPE_MAGICAL:
                                case IP_CONST_DAMAGETYPE_POSITIVE:
                                    {
                                        switch (script.GetItemPropertyCostTableValue(prop.Property))
                                        {
                                            case IP_CONST_DAMAGEBONUS_1d4:
                                                {
                                                    effectivePlus += 1.3f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d6:
                                                {
                                                    effectivePlus += 2.0f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1d8:
                                                {
                                                    effectivePlus += 2.7f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_1:
                                                {
                                                    effectivePlus += 0.7f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_2:
                                                {
                                                    effectivePlus += 1.1f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_3:
                                                {
                                                    effectivePlus += 1.5f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_4:
                                                {
                                                    effectivePlus += 2.1f;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGEBONUS_5:
                                                {
                                                    effectivePlus += 2.5f;
                                                    break;
                                                }
                                            default:
                                                {
                                                    return -1;
                                                }
                                        } 
                                        break;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Damage Resistance
                    case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                        {
                            switch (script.GetItemPropertySubType(prop.Property))
                            {
                                case IP_CONST_DAMAGETYPE_ACID:
                                case IP_CONST_DAMAGETYPE_COLD:
                                case IP_CONST_DAMAGETYPE_ELECTRICAL:
                                case IP_CONST_DAMAGETYPE_FIRE:
                                case IP_CONST_DAMAGETYPE_SONIC:
                                    {
                                        switch (script.GetItemPropertyCostTableValue(prop.Property))
                                        {
                                            case IP_CONST_DAMAGERESIST_5:
                                                {
                                                    prop.Price = 4000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_10:
                                                {
                                                    prop.Price = 12000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_15:
                                                {
                                                    prop.Price = 20000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_20:
                                                {
                                                    prop.Price = 28000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_25:
                                                {
                                                    prop.Price = 36000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_30:
                                                {
                                                    prop.Price = 44000;
                                                    break;
                                                }
                                        }
                                        break;
                                    }
                                case IP_CONST_DAMAGETYPE_NEGATIVE:
                                    {
                                        switch (script.GetItemPropertyCostTableValue(prop.Property))
                                        {
                                            case IP_CONST_DAMAGERESIST_5:
                                                {
                                                    prop.Price = 6000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_10:
                                                {
                                                    prop.Price = 18000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_15:
                                                {
                                                    prop.Price = 30000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_20:
                                                {
                                                    prop.Price = 42000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_25:
                                                {
                                                    prop.Price = 54000;
                                                    break;
                                                }
                                            case IP_CONST_DAMAGERESIST_30:
                                                {
                                                    prop.Price = 66000;
                                                    break;
                                                }
                                        }
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Freedom of Movement
                    case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
                        {
                            prop.Price = 40000;
                            break;
                        }
                    #endregion
                    #region Enhancement Bonus
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                        {
                            enhancementVsEveryone = script.GetItemPropertyCostTableValue(prop.Property);
                            effectivePlus += enhancementVsEveryone;
                            break;
                        }
                    #endregion
                    #region Immunities
                    case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
                        {
                            switch (script.GetItemPropertySubType(prop.Property))
                            {
                                case IP_CONST_IMMUNITYMISC_DEATH_MAGIC:
                                    {
                                        prop.Price = 80000;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_DISEASE:
                                    {
                                        prop.Price = 7500;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_FEAR:
                                    {
                                        prop.Price = 10000;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_KNOCKDOWN:
                                    {
                                        prop.Price = 22500;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN:
                                    {
                                        prop.Price = 40000;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_PARALYSIS:
                                    {
                                        prop.Price = 15000;
                                        break;
                                    }
                                case IP_CONST_IMMUNITYMISC_POISON:
                                    {
                                        prop.Price = 25000;
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Immunity to Specific Spell
                    case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
                        {
                            float spellLevel = 0.0f;
                            float.TryParse(script.Get2DAString("spells", "Innate", script.GetItemPropertyCostTableValue(prop.Property)), out spellLevel);
                            if (spellLevel < 0.5f)
                            {
                                spellLevel = 0.5f;
                            }
                            prop.Price = (int)(((spellLevel * spellLevel) + 1) * 1000);
                            break;
                        }
                    #endregion
                    #region Keen
                    case ITEM_PROPERTY_KEEN:
                        {
                            effectivePlus += 2.0f;
                            break;
                        }
                    #endregion
                    #region Light
                    case ITEM_PROPERTY_LIGHT:
                        {
                            prop.Price = script.GetItemPropertyCostTableValue(prop.Property) * 100;
                            break;
                        }
                    #endregion
                    #region Massive Criticals
                    case ITEM_PROPERTY_MASSIVE_CRITICALS:
                        {
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_DAMAGEBONUS_1d4:
                                    {
                                        effectivePlus += 0.3f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d6:
                                    {
                                        effectivePlus += 0.4f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d8:
                                    {
                                        effectivePlus += 0.6f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d10:
                                    {
                                        effectivePlus += 0.8f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d12:
                                    {
                                        effectivePlus += 1.0f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2d4:
                                    {
                                        effectivePlus += 0.7f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2d6:
                                    {
                                        effectivePlus += 1.1f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1:
                                    {
                                        effectivePlus += 0.1f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2:
                                    {
                                        effectivePlus += 0.2f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_3:
                                    {
                                        effectivePlus += 0.3f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_4:
                                    {
                                        effectivePlus += 0.4f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_5:
                                    {
                                        effectivePlus += 0.6f;
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_6:
                                    {
                                        effectivePlus += 0.8f;
                                        break;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Regeneration: Vampiric
                    case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
                        {
                            int val = script.GetItemPropertyCostTableValue(prop.Property);
                            if (val > 2)
                            {
                                return -1;
                            }
                            effectivePlus = val * 0.5f;
                            break;
                        }
                    #endregion
                    #region Bonus to Saving Throw Subtypes
                    case ITEM_PROPERTY_SAVING_THROW_BONUS:
                        {
                            int val = script.GetItemPropertyCostTableValue(prop.Property);
                            if (val > 5)
                            {
                                return -1;
                            }
                            if (script.GetItemPropertySubType(prop.Property) == IP_CONST_SAVEVS_UNIVERSAL)
                            {
                                prop.Price = (val * val) * 1000;
                            }
                            else
                            {
                                prop.Price = (val * val) * 250;
                            }
                            break;
                        }
                    #endregion
                    #region Bonus to Saving Throw Types
                    case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                        {
                            int val = script.GetItemPropertyCostTableValue(prop.Property);
                            if (val > 5)
                            {
                                return -1;
                            }
                            prop.Price = (val * val) * 250;                            
                            break;
                        }
                    #endregion
                    #region Skill Bonus
                    case ITEM_PROPERTY_SKILL_BONUS:
                        {
                            int val = script.GetItemPropertyCostTableValue(prop.Property);
                            prop.Price = (val * val) * 100;
                            break;
                        }
                    #endregion
                    #region Spell Resistance
                    case ITEM_PROPERTY_SPELL_RESISTANCE:
                        {
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_SPELLRESISTANCEBONUS_10:
                                    {
                                        prop.Price = 6000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_12:
                                    {
                                        prop.Price = 10000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_14:
                                    {
                                        prop.Price = 20000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_16:
                                    {
                                        prop.Price = 40000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_18:
                                    {
                                        prop.Price = 60000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_20:
                                    {
                                        prop.Price = 80000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_22:
                                    {
                                        prop.Price = 100000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_24:
                                    {
                                        prop.Price = 120000;
                                        break;
                                    }
                                case IP_CONST_SPELLRESISTANCEBONUS_26:
                                    {
                                        prop.Price = 140000;
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Unlimited Ammunition
                    case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
                        {
                            effectivePlus += 0.5f;
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                // Basic unlimited ammo just has the 0.5 above.
                                case IP_CONST_UNLIMITEDAMMO_BASIC:
                                    {
                                        break;
                                    }
                                // These are bonus elemental damage. Price as such.
                                case IP_CONST_UNLIMITEDAMMO_1D6COLD:
                                case IP_CONST_UNLIMITEDAMMO_1D6FIRE:
                                case IP_CONST_UNLIMITEDAMMO_1D6LIGHT:
                                    {
                                        effectivePlus += 1.5f;
                                        break;
                                    }
                                // These are actually only bonus physical damage. Price as such.
                                case IP_CONST_UNLIMITEDAMMO_PLUS1:
                                    {
                                        effectivePlus += +0.4f;
                                        break;
                                    }
                                case IP_CONST_UNLIMITEDAMMO_PLUS2:
                                    {
                                        effectivePlus += 0.8f;
                                        break;
                                    }
                                case IP_CONST_UNLIMITEDAMMO_PLUS3:
                                    {
                                        effectivePlus += 1.2f;
                                        break;
                                    }
                                case IP_CONST_UNLIMITEDAMMO_PLUS4:
                                    {
                                        effectivePlus += 1.6f;
                                        break;
                                    }
                                case IP_CONST_UNLIMITEDAMMO_PLUS5:
                                    {
                                        effectivePlus += 2.0f;
                                        break;
                                    }
                                default:
                                    {
                                        // These are the quirky OC special ammo.
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Banned Properties
                    case ITEM_PROPERTY_BONUS_HITPOINTS:
                    case ITEM_PROPERTY_DAMAGE_REDUCTION:
                    case ITEM_PROPERTY_DARKVISION:
                    case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
                    case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
                    case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
                    case ITEM_PROPERTY_HASTE:
                    case ITEM_PROPERTY_HEALERS_KIT:
                    case ITEM_PROPERTY_HOLY_AVENGER:
                    case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                    case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
                    case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
                    case ITEM_PROPERTY_IMPROVED_EVASION:
                    case ITEM_PROPERTY_MIND_BLANK:
                    case ITEM_PROPERTY_MONSTER_DAMAGE:
                    case ITEM_PROPERTY_ON_HIT_PROPERTIES:
                    case ITEM_PROPERTY_ON_MONSTER_HIT:
                    case ITEM_PROPERTY_ONHITCASTSPELL:
                    case ITEM_PROPERTY_POISON:
                    case ITEM_PROPERTY_REGENERATION:
                    case ITEM_PROPERTY_SPECIAL_WALK:
                    case ITEM_PROPERTY_THIEVES_TOOLS:
                    case ITEM_PROPERTY_TRAP:
                    case ITEM_PROPERTY_TRUE_SEEING:
                    case ITEM_PROPERTY_TURN_RESISTANCE:
                        {
                            // these props are banned. return -1.
                            return -1;
                        }
                    #endregion
                    #region Penalties and Non-Price-Affecting Properties
                    case ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED:
                    case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
                    case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
                    case ITEM_PROPERTY_DECREASED_AC:
                    case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
                    case ITEM_PROPERTY_DECREASED_DAMAGE:
                    case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
                    case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
                    case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
                    case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
                    case ITEM_PROPERTY_NO_DAMAGE:
                    case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
                    case ITEM_PROPERTY_USE_LIMITATION_CLASS:
                    case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
                    case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
                    case ITEM_PROPERTY_VISUALEFFECT:
                    case ITEM_PROPERTY_WEIGHT_INCREASE:
                        {
                            // these props don't affect the price. break.
                            break;
                        }
                    #endregion
                }
            }
            #endregion

            #region Properties that are vs. Specifics
            foreach (PricedItemProperty prop in itProps)
            {
                if (prop.Price > 0) { continue; }
                int propType = script.GetItemPropertyType(prop.Property);
                switch (propType)
                {
                    #region AC Bonus vs. Alignement Group
                    case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
                        {
                            int ACvsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (ACvsGroup > ACvsEveryone)
                            {
                                float multiplier = 0.20f;
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_NEUTRAL)
                                {
                                    multiplier = 2.0f / 3.0f;
                                }
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_EVIL)
                                {
                                    multiplier = 0.50f;
                                }
                                float effectiveBonus = ((ACvsGroup - ACvsEveryone) * multiplier) + ACvsEveryone;
                                prop.Price = (int)((effectiveBonus * effectiveBonus * 2000) - (ACvsEveryone * ACvsEveryone * 2000));
                            }
                            break;
                        }
                    #endregion
                    #region AC Bonus vs. Damage Type
                    case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
                        {
                            int ACvsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (ACvsGroup > ACvsEveryone)
                            {
                                float multiplier = 1.0f / 3.0f;
                                float effectiveBonus = ((ACvsGroup - ACvsEveryone) * multiplier) + ACvsEveryone;
                                prop.Price = (int)((effectiveBonus * effectiveBonus * 2000) - (ACvsEveryone * ACvsEveryone * 2000));
                            }
                            break;
                        }
                    #endregion
                    #region AC Bonus vs. Racial Type
                    case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
                        {
                            int ACvsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (ACvsGroup > ACvsEveryone)
                            {
                                float multiplier = 1.0f / 3.0f;
                                float effectiveBonus = ((ACvsGroup - ACvsEveryone) * multiplier) + ACvsEveryone;
                                prop.Price = (int)((effectiveBonus * effectiveBonus * 2000) - (ACvsEveryone * ACvsEveryone * 2000));
                            }
                            break;
                        }
                    #endregion
                    #region AC Bonus vs. Specific Alignment
                    case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
                        {
                            int ACvsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (ACvsGroup > ACvsEveryone)
                            {
                                float multiplier = 1.0f / 6.0f;
                                float effectiveBonus = ((ACvsGroup - ACvsEveryone) * multiplier) + ACvsEveryone;
                                prop.Price = (int)((effectiveBonus * effectiveBonus * 2000) - (ACvsEveryone * ACvsEveryone * 2000));
                            }
                            break;
                        }
                    #endregion
                    #region Attack Bonus vs. Alignment Group
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                        {
                            int attackVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (attackVsGroup > attackVsEveryone)
                            {
                                float multiplier = 0.20f;
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_NEUTRAL)
                                {
                                    multiplier = 2.0f / 3.0f;
                                }
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_EVIL)
                                {
                                    multiplier = 0.50f;
                                }
                                effectivePlus += ((attackVsGroup - attackVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                    #region Attack Bonus vs. Racial Group
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                        {
                            int attackVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (attackVsGroup > attackVsEveryone)
                            {
                                float multiplier = 1.0f / 3.0f;
                                effectivePlus += ((attackVsGroup - attackVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                    #region Attack Bonus vs. Specific Alignment
                    case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                        {
                            int attackVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (attackVsGroup > attackVsEveryone)
                            {
                                float multiplier = 1.0f/6.0f;
                                effectivePlus += ((attackVsGroup - attackVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                    #region Damage Bonus vs. Alignment Group
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                        {
                            float multiplier = 0.20f;
                            if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_NEUTRAL)
                            {
                                multiplier = 2.0f / 3.0f;
                            }
                            if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_EVIL)
                            {
                                multiplier = 0.50f;
                            }
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_DAMAGEBONUS_1d4:
                                    {
                                        effectivePlus += (1.3f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d6:
                                    {
                                        effectivePlus += (2.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d8:
                                    {
                                        effectivePlus += (2.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2d4:
                                    {
                                        effectivePlus += (3.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1:
                                    {
                                        effectivePlus += (0.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2:
                                    {
                                        effectivePlus += (1.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_3:
                                    {
                                        effectivePlus += (1.5f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_4:
                                    {
                                        effectivePlus += (2.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_5:
                                    {
                                        effectivePlus += (2.5f * multiplier);
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Damage Bonus vs. Racial Group
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                        {
                            float multiplier = 1.0f / 3.0f;
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_DAMAGEBONUS_1d4:
                                    {
                                        effectivePlus += (1.3f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d6:
                                    {
                                        effectivePlus += (2.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d8:
                                    {
                                        effectivePlus += (2.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2d4:
                                    {
                                        effectivePlus += (3.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1:
                                    {
                                        effectivePlus += (0.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2:
                                    {
                                        effectivePlus += (1.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_3:
                                    {
                                        effectivePlus += (1.5f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_4:
                                    {
                                        effectivePlus += (2.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_5:
                                    {
                                        effectivePlus += (2.5f * multiplier);
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Damage Bonus vs. Specific Alignment
                    case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                        {
                            float multiplier = 1.0f / 6.0f;
                            switch (script.GetItemPropertyCostTableValue(prop.Property))
                            {
                                case IP_CONST_DAMAGEBONUS_1d4:
                                    {
                                        effectivePlus += (1.3f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d6:
                                    {
                                        effectivePlus += (2.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1d8:
                                    {
                                        effectivePlus += (2.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2d4:
                                    {
                                        effectivePlus += (3.0f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_1:
                                    {
                                        effectivePlus += (0.7f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_2:
                                    {
                                        effectivePlus += (1.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_3:
                                    {
                                        effectivePlus += (1.5f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_4:
                                    {
                                        effectivePlus += (2.1f * multiplier);
                                        break;
                                    }
                                case IP_CONST_DAMAGEBONUS_5:
                                    {
                                        effectivePlus += (2.5f * multiplier);
                                        break;
                                    }
                                default:
                                    {
                                        return -1;
                                    }
                            }
                            break;
                        }
                    #endregion
                    #region Enhancement Bonus vs. Alignment Group
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
                        {
                            int enhancementVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (enhancementVsGroup > enhancementVsEveryone)
                            {
                                float multiplier = 0.20f;
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_NEUTRAL)
                                {
                                    multiplier = 2.0f / 3.0f;
                                }
                                if (script.GetItemPropertySubType(prop.Property) == IP_CONST_ALIGNMENTGROUP_EVIL)
                                {
                                    multiplier = 0.50f;
                                }
                                effectivePlus += ((enhancementVsGroup - enhancementVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                    #region Enhancement Bonus vs. Racial Group
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
                        {
                            int enhancementVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (enhancementVsGroup > enhancementVsEveryone)
                            {
                                float multiplier = 1.0f / 3.0f;
                                effectivePlus += ((enhancementVsGroup - enhancementVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                    #region Enhancement Bonus vs. Specific Alignment
                    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
                        {
                            int enhancementVsGroup = script.GetItemPropertyCostTableValue(prop.Property);
                            if (enhancementVsGroup > enhancementVsEveryone)
                            {
                                float multiplier = 1.0f / 6.0f;
                                effectivePlus += ((enhancementVsGroup - enhancementVsEveryone) * multiplier);
                            }
                            break;
                        }
                    #endregion
                }
            }
            #endregion
            #endregion

            #region Sum Calculated Values
            value += enchantmentPenalty;
            bool allSecondary = false;
            if (effectivePlus >= 0.05f)
            {
                allSecondary = true;
                if (effectivePlus >= 1.0f)
                {
                    if (enhancementVsEveryone < 0.99)
                    {
                        return -1;
                    }
                    value += (int)((effectivePlus * effectivePlus) * 2000);
                }
                else
                {
                    value += (int)(effectivePlus * 2000);
                }
            }
            int costliestProp = 0;
            int propsPrice = 0;
            PricedItemProperty costliestCharge = null;
            PricedItemProperty secondCostliestCharge = null;
            foreach (PricedItemProperty prop in itProps)
            {
                value += prop.Price;
                propsPrice += prop.Price;
                if (costliestProp < prop.Price)
                {
                    costliestProp = prop.Price;
                }
                if (prop.ChargedPrice > 0)
                {
                    if (costliestCharge == null)
                    {
                        costliestCharge = prop;
                    }
                    else if (prop.ChargedPrice > costliestCharge.ChargedPrice)
                    {
                        secondCostliestCharge = costliestCharge;
                        costliestCharge = prop;
                    }
                    else if (prop.ChargedPrice > secondCostliestCharge.ChargedPrice)
                    {
                        secondCostliestCharge = prop;
                    }
                }
            }
            if (allSecondary)
            {
                value += (propsPrice / 2);
            }
            else
            {
                // If the costliest prop is the only prop, 0/2 = 0.
                // otherwise, all secondary props cost 50% more.
                value += ((propsPrice - costliestProp) / 2);
            }

            if (costliestCharge != null)
            {
                if (secondCostliestCharge == null)
                {
                    value += costliestCharge.ChargedPrice * script.GetItemCharges(target);
                }
                else
                {
                    foreach (PricedItemProperty prop in itProps)
                    {
                        if (costliestCharge == prop)
                        {
                            value += costliestCharge.ChargedPrice * script.GetItemCharges(target);
                        }
                        else if (secondCostliestCharge == prop)
                        {
                            value += (costliestCharge.ChargedPrice * script.GetItemCharges(target) * 3) / 4;
                        }
                        else
                        {
                            value += (costliestCharge.ChargedPrice * script.GetItemCharges(target)) / 2;
                        }
                    }
                }
            }
            #endregion
            return value;
        }

        private static int GetArmorPrice(CLRScriptBase script, uint target)
        {
            #region Initialize commonly-used variables
            int value = ArmorRulesTypeValues[script.GetArmorRulesType(target)];
            int itemType = script.GetBaseItemType(target);
            int enchantmentPenalty = 0;
            bool masterworkCounted = false;
            int specialMat = script.GetItemBaseMaterialType(target);
            #endregion

            #region Load item properties into the price calculation collection
            List<PricedItemProperty> itProps = new List<PricedItemProperty>();
            foreach (NWItemProperty prop in script.GetItemPropertiesOnItem(target))
            {
                itProps.Add(new PricedItemProperty() { Property = prop, Price = 0 });
            }
            #endregion

            #region Check for Mundane Items
            if (itProps.Count == 0 &&
                (specialMat == GMATERIAL_METAL_IRON || specialMat == GMATERIAL_NONSPECIFIC))
            {
                // No item properties. This is just worth the base item.
                return value;
            }
            #endregion

            return value;
        }

        private static bool GetIsHalfWeight(CLRScriptBase script, List<PricedItemProperty> itProp)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DAMAGE_BONUS &&
                    script.GetItemPropertyCostTableValue(prop.Property) == IP_CONST_REDUCEDWEIGHT_50_PERCENT)
                {
                    removedProp = prop;
                    break;
                }
            }
            if (removedProp != null)
            {
                itProp.Remove(removedProp);
                return true;
            }
            return false;
        }

        private static bool GetHasVersusAlignmentBonus(CLRScriptBase script, List<PricedItemProperty> itProp, int alignmentTarget, int damageBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP &&
                    script.GetItemPropertySubType(prop.Property) == alignmentTarget &&
                    script.GetItemPropertyCostTableValue(prop.Property) == damageBonus)
                {
                    removedProp = prop;
                    break;
                }
            }
            if (removedProp != null)
            {
                itProp.Remove(removedProp);
                return true;
            }
            return false;
        }

        private static bool GetHasElementalWeaponBonus(CLRScriptBase script, List<PricedItemProperty> itProp, int elementalConstant, int damageBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DAMAGE_BONUS &&
                    script.GetItemPropertySubType(prop.Property) == elementalConstant &&
                    script.GetItemPropertyCostTableValue(prop.Property) == damageBonus)
                {
                    removedProp = prop;
                    break;
                }
            }
            if (removedProp != null)
            {
                itProp.Remove(removedProp);
                return true;
            }
            return false;
        }
        
        private static bool GetIsAlchemicalSilver(CLRScriptBase script, List<PricedItemProperty> itProp)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DECREASED_DAMAGE &&
                    script.GetItemPropertyCostTableValue(prop.Property) == 1)
                {
                    removedProp = prop;
                    break;
                }
            }
            if (removedProp != null)
            {
                itProp.Remove(removedProp);
                return true;
            }
            return false;
        }
        
        private static bool GetIsMasterwork(CLRScriptBase script, List<PricedItemProperty> itProp)
        {
            PricedItemProperty removedProp = null;
            bool complexEnchantment = false;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
                {
                    // This needs its own pricing. Leave it in place and return.
                    return true;
                }
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_ATTACK_BONUS &&
                    script.GetItemPropertyCostTableValue(prop.Property) == 1)
                {
                    removedProp = prop;
                }
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP ||
                   script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP ||
                   script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
                {
                    complexEnchantment = true;
                }
            }
            if (removedProp != null && !complexEnchantment)
            {
                itProp.Remove(removedProp);
                return true;
            }
            return false;
        }

        private static bool GetIsOOCItem(int itemType)
        {
            if (OOC.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        private static bool GetIsWeapon(int itemType)
        {
            if(Weapons.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        private static bool GetIsLightWeapon(int itemType)
        {
            if (LightWeapons.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        private static bool GetIsHeavyWeapon(int itemType)
        {
            if (HeavyWeapons.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        private static bool GetIsAmmunition(int itemType)
        {
            if (Ammunition.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        private static bool GetIsArmor(int itemType)
        {
            if (Armor.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        #region Value and Category Indicies
        #region Base Item Classifications
        static List<int> OOC = new List<int>
        {
            BASE_ITEM_CBLUDGWEAPON,
            BASE_ITEM_CPIERCWEAPON,
            BASE_ITEM_CREATUREITEM,
            BASE_ITEM_CSLASHWEAPON,
            BASE_ITEM_CSLSHPRCWEAP,
            BASE_ITEM_INVALID,
        };

        static List<int> Armor = new List<int>
        {
            BASE_ITEM_ARMOR,
            BASE_ITEM_SMALLSHIELD,
            BASE_ITEM_LARGESHIELD,
            BASE_ITEM_TOWERSHIELD,
        };
        static List<int> Ammunition = new List<int>
        {
            BASE_ITEM_ARROW,
            BASE_ITEM_BOLT,
            BASE_ITEM_BULLET,
            BASE_ITEM_DART,
            BASE_ITEM_SHURIKEN,
            BASE_ITEM_THROWINGAXE,
        };

        static List<int> LightWeapons = new List<int>
        {
            BASE_ITEM_SHORTSWORD,
            BASE_ITEM_MACE,
            BASE_ITEM_DAGGER,
            BASE_ITEM_LIGHTHAMMER,
            BASE_ITEM_HANDAXE,
            BASE_ITEM_KUKRI,
            BASE_ITEM_SICKLE,
            BASE_ITEM_WHIP,
            BASE_ITEM_LIGHTFLAIL,
            BASE_ITEM_RAPIER,
        };

        static List<int> HeavyWeapons = new List<int>
        {
            BASE_ITEM_HALBERD,
            BASE_ITEM_GREATSWORD,
            BASE_ITEM_GREATAXE,
            BASE_ITEM_QUARTERSTAFF,
            BASE_ITEM_SCYTHE,
            BASE_ITEM_FALCHION,
            BASE_ITEM_SPEAR,
            BASE_ITEM_GREATCLUB,
            BASE_ITEM_WARMACE,
        };

        static List<int> Weapons = new List<int>
        {
                BASE_ITEM_ALLUSE_SWORD,
                BASE_ITEM_BASTARDSWORD,
                BASE_ITEM_BATTLEAXE,
                BASE_ITEM_CLUB,
                BASE_ITEM_DAGGER,
                BASE_ITEM_DIREMACE,
                BASE_ITEM_DOUBLEAXE,
                BASE_ITEM_DWARVENWARAXE,
                BASE_ITEM_FALCHION,
                BASE_ITEM_FLAIL,
                BASE_ITEM_GREATAXE,
                BASE_ITEM_GREATCLUB,
                BASE_ITEM_GREATSWORD,
                BASE_ITEM_HALBERD,
                BASE_ITEM_HANDAXE,
                BASE_ITEM_HEAVYCROSSBOW,
                BASE_ITEM_HEAVYFLAIL,
                BASE_ITEM_KAMA,
                BASE_ITEM_KATANA,
                BASE_ITEM_KUKRI,
                BASE_ITEM_LIGHTCROSSBOW,
                BASE_ITEM_LIGHTFLAIL,
                BASE_ITEM_LIGHTHAMMER,
                BASE_ITEM_LIGHTMACE,
                BASE_ITEM_LONGBOW,
                BASE_ITEM_LONGSWORD,
                BASE_ITEM_MACE,
                BASE_ITEM_MAGICSTAFF,
                BASE_ITEM_MORNINGSTAR,
                BASE_ITEM_QUARTERSTAFF,
                BASE_ITEM_RAPIER,
                BASE_ITEM_SCIMITAR,
                BASE_ITEM_SCYTHE,
                BASE_ITEM_SHORTBOW,
                BASE_ITEM_SHORTSPEAR,
                BASE_ITEM_SHORTSWORD,
                BASE_ITEM_SICKLE,
                BASE_ITEM_SLING,
                BASE_ITEM_SPEAR,
                BASE_ITEM_TRAINING_CLUB,
                BASE_ITEM_TWOBLADEDSWORD,
                BASE_ITEM_WARHAMMER,
                BASE_ITEM_WARMACE,
                BASE_ITEM_WHIP,
        };
        #endregion
        #region Base Item Values
        static Dictionary<int, int> BaseItemValues = new Dictionary<int, int>
        {
            {BASE_ITEM_ALLUSE_SWORD, 30},
            {BASE_ITEM_AMULET, 0},
            {BASE_ITEM_ARMOR, 0},
            {BASE_ITEM_ARROW, 1},
            {BASE_ITEM_BASTARDSWORD, 70},
            {BASE_ITEM_BATTLEAXE, 20},
            {BASE_ITEM_BELT, 0},
            {BASE_ITEM_BLANK_POTION, 0},
            {BASE_ITEM_BLANK_SCROLL, 0},
            {BASE_ITEM_BLANK_WAND, 0},
            {BASE_ITEM_BOLT, 1},
            {BASE_ITEM_BOOK, 0},
            {BASE_ITEM_BOOTS, 0},
            {BASE_ITEM_BRACER, 0},
            {BASE_ITEM_BULLET, 1},
            {BASE_ITEM_CBLUDGWEAPON, 0},
            {BASE_ITEM_CGIANT_AXE, 0},
            {BASE_ITEM_CGIANT_SWORD, 0},
            {BASE_ITEM_CLOAK, 0},
            {BASE_ITEM_CLUB, 2},
            {BASE_ITEM_CPIERCWEAPON, 0},
            {BASE_ITEM_CRAFTMATERIALMED, 0},
            {BASE_ITEM_CRAFTMATERIALSML, 0},
            {BASE_ITEM_CREATUREITEM, 0},
            {BASE_ITEM_CSLASHWEAPON, 0},
            {BASE_ITEM_CSLSHPRCWEAP, 0},
            {BASE_ITEM_DAGGER, 4},
            {BASE_ITEM_DART, 1},
            {BASE_ITEM_DIREMACE, 100},
            {BASE_ITEM_DOUBLEAXE, 100},
            {BASE_ITEM_DWARVENWARAXE, 60},
            {BASE_ITEM_ENCHANTED_POTION, 0},
            {BASE_ITEM_ENCHANTED_SCROLL, 0},
            {BASE_ITEM_ENCHANTED_WAND, 0},
            {BASE_ITEM_FALCHION, 150},
            {BASE_ITEM_FLAIL, 16},
            {BASE_ITEM_FLUTE, 5},
            {BASE_ITEM_GEM, 0},
            {BASE_ITEM_GLOVES, 0},
            {BASE_ITEM_GOLD, 0},
            {BASE_ITEM_GREATAXE, 40},
            {BASE_ITEM_GREATCLUB, 20},
            {BASE_ITEM_GREATSWORD, 100},
            {BASE_ITEM_GRENADE, 0},
            {BASE_ITEM_HALBERD, 20},
            {BASE_ITEM_HANDAXE, 12},
            {BASE_ITEM_HEALERSKIT, 0},
            {BASE_ITEM_HEAVYCROSSBOW, 100},
            {BASE_ITEM_HEAVYFLAIL, 30},
            {BASE_ITEM_HELMET, 0},
            {BASE_ITEM_INVALID, 0},
            {BASE_ITEM_KAMA, 4},
            {BASE_ITEM_KATANA, 80},
            {BASE_ITEM_KEY, 0},
            {BASE_ITEM_KUKRI, 16},
            {BASE_ITEM_LARGEBOX, 0},
            {BASE_ITEM_LARGESHIELD, 50},
            {BASE_ITEM_LIGHTCROSSBOW, 70},
            {BASE_ITEM_LIGHTFLAIL, 16},
            {BASE_ITEM_LIGHTHAMMER, 2},
            {BASE_ITEM_LIGHTMACE, 10},
            {BASE_ITEM_LONGBOW, 150},
            {BASE_ITEM_LONGSWORD, 30},
            {BASE_ITEM_MACE, 10},
            {BASE_ITEM_MAGICROD, 0},
            {BASE_ITEM_MAGICSTAFF, 2},
            {BASE_ITEM_MAGICWAND, 0},
            {BASE_ITEM_MANDOLIN, 5},
            {BASE_ITEM_MISCLARGE, 0},
            {BASE_ITEM_MISCMEDIUM, 0},
            {BASE_ITEM_MISCSMALL, 0},
            {BASE_ITEM_MISCTALL, 0},
            {BASE_ITEM_MISCTHIN, 0},
            {BASE_ITEM_MISCWIDE, 0},
            {BASE_ITEM_MORNINGSTAR, 16},
            {BASE_ITEM_POTIONS, 0},
            {BASE_ITEM_QUARTERSTAFF, 2},
            {BASE_ITEM_RAPIER, 40},
            {BASE_ITEM_RING, 0},
            {BASE_ITEM_SCIMITAR, 30},
            {BASE_ITEM_SCROLL, 0},
            {BASE_ITEM_SCYTHE, 36},
            {BASE_ITEM_SHORTBOW, 70},
            {BASE_ITEM_SHORTSPEAR, 20},
            {BASE_ITEM_SHORTSWORD, 20},
            {BASE_ITEM_SHURIKEN, 1},
            {BASE_ITEM_SICKLE, 12},
            {BASE_ITEM_SLING, 2},
            {BASE_ITEM_SMALLSHIELD, 10},
            {BASE_ITEM_SPEAR, 4},
            {BASE_ITEM_SPELLSCROLL, 0},
            {BASE_ITEM_THIEVESTOOLS, 0},
            {BASE_ITEM_THROWINGAXE, 1},
            {BASE_ITEM_TORCH, 0},
            {BASE_ITEM_TOWERSHIELD, 100},
            {BASE_ITEM_TRAINING_CLUB, 2},
            {BASE_ITEM_TRAPKIT, 0},
            {BASE_ITEM_TWOBLADEDSWORD, 100},
            {BASE_ITEM_WARHAMMER, 24},
            {BASE_ITEM_WARMACE, 100},
            {BASE_ITEM_WHIP, 10}
        };

        static Dictionary<int, int> ArmorRulesTypeValues = new Dictionary<int, int>
        {
            {ARMOR_RULES_TYPE_BANDED, 250},
            {ARMOR_RULES_TYPE_BANDED_MASTERWORK, 400},
            {ARMOR_RULES_TYPE_BANDED_MITHRAL, 9250},
            {ARMOR_RULES_TYPE_BREASTPLATE, 200},
            {ARMOR_RULES_TYPE_BREASTPLATE_MASTERWORK, 350},
            {ARMOR_RULES_TYPE_BREASTPLATE_MITHRAL, 4200},
            {ARMOR_RULES_TYPE_CHAIN_SHIRT, 100},
            {ARMOR_RULES_TYPE_CHAIN_SHIRT_MASTERWORK, 250},
            {ARMOR_RULES_TYPE_CHAIN_SHIRT_MITHRAL, 1100},
            {ARMOR_RULES_TYPE_CHAINMAIL, 150},
            {ARMOR_RULES_TYPE_CHAINMAIL_MASTERWORK, 300},
            {ARMOR_RULES_TYPE_CHAINMAIL_MITHRAL, 4150},
            {ARMOR_RULES_TYPE_CLOTH, 0},
            {ARMOR_RULES_TYPE_FULL_PLATE, 1500},
            {ARMOR_RULES_TYPE_FULL_PLATE_MASTERWORK, 1650},
            {ARMOR_RULES_TYPE_FULL_PLATE_MITHRAL, 10500},
            {ARMOR_RULES_TYPE_HALF_PLATE, 600},
            {ARMOR_RULES_TYPE_HALF_PLATE_MASTERWORK, 750},
            {ARMOR_RULES_TYPE_HALF_PLATE_MITHRAL, 9600},
            {ARMOR_RULES_TYPE_HIDE, 15},
            {ARMOR_RULES_TYPE_HIDE_MASTERWORK, 165},
            {ARMOR_RULES_TYPE_LEATHER, 10},
            {ARMOR_RULES_TYPE_LEATHER_MASTERWORK, 160},
            {ARMOR_RULES_TYPE_PADDED, 5},
            {ARMOR_RULES_TYPE_PADDED_MASTERWORK, 155},
            {ARMOR_RULES_TYPE_SCALE, 50},
            {ARMOR_RULES_TYPE_SCALE_MASTERWORK, 200},
            {ARMOR_RULES_TYPE_SCALE_MITHRAL, 4050},
            {ARMOR_RULES_TYPE_SHIELD_HEAVY, 50},
            {ARMOR_RULES_TYPE_SHIELD_HEAVY_DARKWOOD, 230},
            {ARMOR_RULES_TYPE_SHIELD_HEAVY_MASTERWORK, 200},
            {ARMOR_RULES_TYPE_SHIELD_HEAVY_MITHRAL, 1050},
            {ARMOR_RULES_TYPE_SHIELD_LIGHT, 10},
            {ARMOR_RULES_TYPE_SHIELD_LIGHT_DARKWOOD, 300},
            {ARMOR_RULES_TYPE_SHIELD_LIGHT_MASTERWORK, 160},
            {ARMOR_RULES_TYPE_SHIELD_LIGHT_MITHRAL, 1010},
            {ARMOR_RULES_TYPE_SHIELD_TOWER, 100},
            {ARMOR_RULES_TYPE_SHIELD_TOWER_DARKWOOD, 700},
            {ARMOR_RULES_TYPE_SHIELD_TOWER_MASTERWORK, 250},
            {ARMOR_RULES_TYPE_SHIELD_TOWER_MITHRAL, 1100},
            {ARMOR_RULES_TYPE_SPLINT, 250},
            {ARMOR_RULES_TYPE_SPLINT_MASTERWORK, 400},
            {ARMOR_RULES_TYPE_SPLINT_MITHREAL, 9250},
            {ARMOR_RULES_TYPE_STUDDED_LEATHER, 15},
            {ARMOR_RULES_TYPE_STUDDED_LEATHER_MASTERWORK, 165},
        };
        #endregion
        #endregion
    }
}

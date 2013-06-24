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
            // TODO: Calculate magical bonuses
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
        #endregion
        #endregion
    }
}

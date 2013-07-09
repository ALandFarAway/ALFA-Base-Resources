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
    public partial class Pricing : CLRScriptBase
    {
        private static bool GetIsUseRestrictedByClass(CLRScriptBase script, List<PricedItemProperty> itProp)
        {
            List<PricedItemProperty> removedProps = new List<PricedItemProperty>();
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
                {
                    removedProps.Add(prop);
                }
            }
            foreach (PricedItemProperty removedProp in removedProps)
            {
                itProp.Remove(removedProp);
            }
            if (removedProps.Count > 0)
            {
                return true;
            }
            return false;
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

        private static bool GetHasSpecificSavingThrowPenalty(CLRScriptBase script, List<PricedItemProperty> itProp, int saveType, int saveBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC &&
                    script.GetItemPropertySubType(prop.Property) == saveType &&
                    script.GetItemPropertyCostTableValue(prop.Property) == saveBonus)
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

        private static bool GetHasSpecificSavingThrowBonus(CLRScriptBase script, List<PricedItemProperty> itProp, int saveType, int saveBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_SAVING_THROW_BONUS &&
                    script.GetItemPropertySubType(prop.Property) == saveType &&
                    script.GetItemPropertyCostTableValue(prop.Property) == saveBonus)
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

        private static bool GetHasSavingThrowBonus(CLRScriptBase script, List<PricedItemProperty> itProp, int saveBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_SAVING_THROW_BONUS &&
                    script.GetItemPropertySubType(prop.Property) == IP_CONST_SAVEVS_UNIVERSAL &&
                    script.GetItemPropertyCostTableValue(prop.Property) == saveBonus)
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

        private static bool GetHasElementalArmorBonus(CLRScriptBase script, List<PricedItemProperty> itProp, int elementalConstant, int resistanceBonus)
        {
            PricedItemProperty removedProp = null;
            foreach (PricedItemProperty prop in itProp)
            {
                if (script.GetItemPropertyType(prop.Property) == ITEM_PROPERTY_DAMAGE_RESISTANCE &&
                    script.GetItemPropertySubType(prop.Property) == elementalConstant &&
                    script.GetItemPropertyCostTableValue(prop.Property) == resistanceBonus)
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
            if (Weapons.Contains(itemType))
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

        public static bool GetIsAmmunition(int itemType)
        {
            if (Ammunition.Contains(itemType))
            {
                return true;
            }
            return false;
        }

        public static bool GetIsArmor(int itemType)
        {
            if (Armor.Contains(itemType))
            {
                return true;
            }
            return false;
        }
    }
}

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
            int value = BaseItemValues[script.GetBaseItemType(target)];
            List<PricedItemProperty> itProps = new List<PricedItemProperty>();
            foreach(NWItemProperty prop in script.GetItemPropertiesOnItem(target))
            {
                itProps.Add(new PricedItemProperty() { Property = prop, Price = 0 });
            }

            #region Check for Mundane Items
            if (itProps.Count == 0)
            {
                // No item properties. This is just worth the base item.
                return value;
            }
            #endregion


            #region Clear out Properties that Come from Special Materials
            int specialMat = script.GetItemBaseMaterialType(target);
            if (specialMat != GMATERIAL_METAL_IRON &&
                specialMat != GMATERIAL_NONSPECIFIC)
            {
                foreach (PricedItemProperty prop in itProps)
                {
                }
            }
            #endregion

            #region Check for Simple Masterwork Items
            //if (itProps.Count == 1)
            //{
            //    // Only one item property. This might be a masterwork weapon.
            //    if (script.GetItemPropertyType(itProps[0].Property) == ITEM_PROPERTY_ATTACK_BONUS &&
            //        script.GetItemPropertyCostTableValue(itProps[0].Property) == 1)
            //    {
            //        // This is a masterwork item.
            //        value += MasterworkWeaponValue;
            //        return value;
            //    }
            //}
            //if (itProps.Count == 2)
            //{
            //    // This might be mighty and masterwork. Let's figure that out.
            //    if (script.GetItemPropertyType(itProps[0].Property) == ITEM_PROPERTY_ATTACK_BONUS &&
            //        script.GetItemPropertyCostTableValue(itProps[0].Property) == 1)
            //    {
            //        if (script.GetItemPropertyType(itProps[1].Property) == ITEM_PROPERTY_MIGHTY)
            //        {
            //            int mightyBonus = script.GetItemPropertyCostTableValue(itProps[1].Property);
            //            int itemType = script.GetBaseItemType(target);
            //            if (itemType == BASE_ITEM_LONGBOW ||
            //                itemType == BASE_ITEM_HEAVYCROSSBOW)
            //            {
            //                value += mightyBonus * 100;
            //            }
            //            else
            //            {
            //                value += mightyBonus * 75;
            //            }
            //            return value;
            //        }
            //    }
            //    if (script.GetItemPropertyType(itProps[1].Property) == ITEM_PROPERTY_ATTACK_BONUS &&
            //        script.GetItemPropertyCostTableValue(itProps[1].Property) == 1)
            //    {
            //        if (script.GetItemPropertyType(itProps[0].Property) == ITEM_PROPERTY_MIGHTY)
            //        {
            //            int mightyBonus = script.GetItemPropertyCostTableValue(itProps[0].Property);
            //            int itemType = script.GetBaseItemType(target);
            //            if (itemType == BASE_ITEM_LONGBOW ||
            //                itemType == BASE_ITEM_HEAVYCROSSBOW)
            //            {
            //                value += mightyBonus * 100;
            //            }
            //            else
            //            {
            //                value += mightyBonus * 75;
            //            }
            //            return value;
            //        }
            //    }
            //}
            #endregion
            return value;
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
        const List<int> OOC = new List<int>
        {
                BASE_ITEM_CBLUDGWEAPON,
                BASE_ITEM_CPIERCWEAPON,
                BASE_ITEM_CREATUREITEM,
                BASE_ITEM_CSLASHWEAPON,
                BASE_ITEM_CSLSHPRCWEAP,
                BASE_ITEM_INVALID,
        };
        const List<int> Ammunition = new List<int>
        {
                BASE_ITEM_ARROW,
                BASE_ITEM_BOLT,
                BASE_ITEM_BULLET,
                BASE_ITEM_DART,
                BASE_ITEM_SHURIKEN,
                BASE_ITEM_THROWINGAXE,
        };
        const List<int> Weapons = new List<int>
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
        const Dictionary<int, int> BaseItemValues = new Dictionary<int, int>
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

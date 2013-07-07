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
    public class GenerateWeapon: CLRScriptBase
    {
        public static int generateId = 0;
        public static int NewWeapon(CLRScriptBase script, int maxValue)
        {
            int itemType = SelectWeaponType(ref maxValue);
            int weaponValue = Pricing.BaseItemValues[itemType];
            maxValue -= weaponValue;
            generateId++;
            uint weapon = script.CreateItemOnObject(WeaponResrefs[itemType], script.OBJECT_SELF, 1, WeaponResrefs[itemType]+generateId.ToString(), FALSE);

            #region About +1.4 weapons
            if (maxValue > 4220)
            {
                if (Generation.rand.Next(10) > 0)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyEnhancementBonus(1), weapon, 0.0f);
                    switch (Generation.rand.Next(7))
                    {
                        case 0:
                            script.SetFirstName(weapon, "Flametouched " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, 1), weapon, 0.0f);
                            weaponValue += 4220;
                            break;
                        case 1:
                            script.SetFirstName(weapon, "Frosttouched " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, 1), weapon, 0.0f);
                            weaponValue += 4220;
                            break;
                        case 3:
                            script.SetFirstName(weapon, "Acidtouched " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, 1), weapon, 0.0f);
                            weaponValue += 4220;
                            break;
                        case 4:
                            script.SetFirstName(weapon, "Sparktouched " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, 1), weapon, 0.0f);
                            weaponValue += 4220;
                            break;
                        case 5:
                            script.SetFirstName(weapon, "Humming " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, 1), weapon, 0.0f);
                            weaponValue += 4220;
                            break;
                        case 6:
                            script.SetFirstName(weapon, "Blessed " + script.GetName(weapon) + " +1");
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, 1), weapon, 0.0f);
                            weaponValue += 3945;
                            break;
                    }
                }
                else
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyEnhancementBonus(1), weapon, 0.0f);
                    script.SetFirstName(weapon, script.GetName(weapon) + " +1");
                    weaponValue += 2300;
                }
            }
            #endregion

            #region Simple Enchantment, +1
            else if (maxValue > 2300)
            {
                if (Generation.rand.Next(10) > 0)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyEnhancementBonus(1), weapon, 0.0f);
                    script.SetFirstName(weapon, script.GetName(weapon) + " +1");
                    weaponValue += 2300;
                }
                else
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), weapon, 0.0f);
                    script.SetFirstName(weapon, "Masterwork " + script.GetName(weapon));
                    weaponValue += 300;
                }
            }
            #endregion

            #region Simple Bonus Damage, < +1 equiv
            else if (maxValue > 1100)
            {
                if (Generation.rand.Next(10) > 0)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), weapon, 0.0f);
                    switch (Generation.rand.Next(7))
                    {
                        case 0:
                            script.SetFirstName(weapon, "Flametouched " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, 1), weapon, 0.0f);
                            weaponValue += 1100;
                            break;
                        case 1:
                            script.SetFirstName(weapon, "Frosttouched " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, 1), weapon, 0.0f);
                            weaponValue += 1100;
                            break;
                        case 3:
                            script.SetFirstName(weapon, "Acidtouched " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ACID, 1), weapon, 0.0f);
                            weaponValue += 1100;
                            break;
                        case 4:
                            script.SetFirstName(weapon, "Sparktouched " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, 1), weapon, 0.0f);
                            weaponValue += 1100;
                            break;
                        case 5:
                            script.SetFirstName(weapon, "Humming " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, 1), weapon, 0.0f);
                            weaponValue += 1100;
                            break;
                        case 6:
                            script.SetFirstName(weapon, "Blessed " + script.GetName(weapon));
                            script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_MAGICAL, 1), weapon, 0.0f);
                            weaponValue += 1000;
                            break;
                    }
                }
                else
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), weapon, 0.0f);
                    script.SetFirstName(weapon, "Masterwork " + script.GetName(weapon));
                    weaponValue += 300;
                }

            }
            #endregion

            #region Masterwork Only
            else if (maxValue > 300)
            {
                if (Generation.rand.Next(10) > 0)
                {
                    script.AddItemProperty(DURATION_TYPE_PERMANENT, script.ItemPropertyAttackBonus(1), weapon, 0.0f);
                    script.SetFirstName(weapon, "Masterwork " + script.GetName(weapon));
                    weaponValue += 300;
                }
            }
            #endregion

            Pricing.CalculatePrice(script, weapon);

            return weaponValue;
        }

        public static int SelectWeaponType(ref int maxValue)
        {
            if (maxValue < 1)
            {
                return BASE_ITEM_INVALID;
            }
            int maxGen = maxValue;
            if (maxGen > 150)
            {
                maxGen = 150;
            }
            List<int> possibleWeapons = new List<int>();
            foreach (int weap in DroppableWeapons)
            {
                if (Pricing.BaseItemValues[weap] <= maxValue)
                {
                    possibleWeapons.Add(weap);
                }
            }
            int selection = possibleWeapons[Generation.rand.Next(possibleWeapons.Count)];
            maxValue -= Pricing.BaseItemValues[selection];
            return selection;
        }

        #region List of Weapons to Drop, instances control probability
        public static List<int> DroppableWeapons = new List<int>()
        {
            BASE_ITEM_ARROW,
            BASE_ITEM_BASTARDSWORD,
            BASE_ITEM_BASTARDSWORD,
            BASE_ITEM_BATTLEAXE,
            BASE_ITEM_BOLT,
            BASE_ITEM_BULLET,
            BASE_ITEM_CLUB,
            BASE_ITEM_DAGGER,
            BASE_ITEM_DAGGER,
            BASE_ITEM_DART,
            BASE_ITEM_DWARVENWARAXE,
            BASE_ITEM_DWARVENWARAXE,
            BASE_ITEM_DWARVENWARAXE,
            BASE_ITEM_FALCHION,
            BASE_ITEM_FLAIL,
            BASE_ITEM_GLOVES,
            BASE_ITEM_GREATAXE,
            BASE_ITEM_GREATAXE,
            BASE_ITEM_GREATAXE,
            BASE_ITEM_GREATCLUB,
            BASE_ITEM_GREATSWORD,
            BASE_ITEM_HALBERD,
            BASE_ITEM_HANDAXE,
            BASE_ITEM_HEAVYCROSSBOW,
            BASE_ITEM_HEAVYCROSSBOW,
            BASE_ITEM_HEAVYCROSSBOW,
            BASE_ITEM_KAMA,
            BASE_ITEM_KATANA,
            BASE_ITEM_KUKRI,
            BASE_ITEM_LIGHTCROSSBOW,
            BASE_ITEM_LIGHTCROSSBOW,
            BASE_ITEM_LIGHTCROSSBOW,
            BASE_ITEM_LIGHTFLAIL,
            BASE_ITEM_LIGHTHAMMER,
            BASE_ITEM_LIGHTMACE,
            BASE_ITEM_LIGHTMACE,
            BASE_ITEM_LONGBOW,
            BASE_ITEM_LONGBOW,
            BASE_ITEM_LONGBOW,
            BASE_ITEM_LONGBOW,
            BASE_ITEM_LONGSWORD,
            BASE_ITEM_LONGSWORD,
            BASE_ITEM_LONGSWORD,
            BASE_ITEM_LONGSWORD,
            BASE_ITEM_MORNINGSTAR,
            BASE_ITEM_MORNINGSTAR,
            BASE_ITEM_QUARTERSTAFF,
            BASE_ITEM_QUARTERSTAFF,
            BASE_ITEM_RAPIER,
            BASE_ITEM_RAPIER,
            BASE_ITEM_SCIMITAR,
            BASE_ITEM_SCIMITAR,
            BASE_ITEM_SCYTHE,
            BASE_ITEM_SHORTBOW,
            BASE_ITEM_SHORTBOW,
            BASE_ITEM_SHORTBOW,
            BASE_ITEM_SHORTBOW,
            BASE_ITEM_SHORTSPEAR,
            BASE_ITEM_SHORTSTAFF,
            BASE_ITEM_SHORTSWORD,
            BASE_ITEM_SHORTSWORD,
            BASE_ITEM_SHURIKEN,
            BASE_ITEM_SICKLE,
            BASE_ITEM_SLING,
            BASE_ITEM_SPEAR,
            BASE_ITEM_THROWINGAXE,
            BASE_ITEM_WARHAMMER,
            BASE_ITEM_WARMACE,
        };
        #endregion

        #region Weapon Resrefs
        public static Dictionary<int, string> WeaponResrefs = new Dictionary<int, string>()
        {
            {BASE_ITEM_ARROW,"nw_wamar001"},
            {BASE_ITEM_BASTARDSWORD,"nw_wswbs001"},
            {BASE_ITEM_BATTLEAXE,"nw_waxbt001"},
            {BASE_ITEM_BOLT,"nw_wambo001"},
            {BASE_ITEM_BULLET,"nw_wambu001"},
            {BASE_ITEM_CLUB,"nw_wblcl001"},
            {BASE_ITEM_DAGGER,"nw_wswdg001"},
            {BASE_ITEM_DART,"nw_wthdt001"},
            {BASE_ITEM_DWARVENWARAXE,"nw_wdwraxe001"},
            {BASE_ITEM_FALCHION,"n2_wswfl001"},
            {BASE_ITEM_FLAIL,"nw_wblfl001"},
            {BASE_ITEM_GLOVES,"zitem_glove8"},
            {BASE_ITEM_GREATAXE,"nw_waxgr001"},
            {BASE_ITEM_GREATCLUB,"zitem_wpn_greatclub"},
            {BASE_ITEM_GREATSWORD,"nw_swgs001"},
            {BASE_ITEM_HALBERD,"nw_wplhb001"},
            {BASE_ITEM_HANDAXE,"nw_waxhn001"},
            {BASE_ITEM_HEAVYCROSSBOW,"nw_wbwxh001"},
            {BASE_ITEM_KAMA,"nw_wspka001"},
            {BASE_ITEM_KATANA,"nw_wswka001"},
            {BASE_ITEM_KUKRI,"nw_wspku001"},
            {BASE_ITEM_LIGHTCROSSBOW,"nw_wbwxl001"},
            {BASE_ITEM_LIGHTFLAIL,"nw_wblfl001"},
            {BASE_ITEM_LIGHTHAMMER,"nw_wblhl001"},
            {BASE_ITEM_LIGHTMACE,"nw_wblml001"},
            {BASE_ITEM_LONGBOW,"nw_wbwln001"},
            {BASE_ITEM_LONGSWORD,"nw_wswls001"},
            {BASE_ITEM_MORNINGSTAR,"nw_wblms001"},
            {BASE_ITEM_QUARTERSTAFF,"nw_wdbqs001"},
            {BASE_ITEM_RAPIER,"nw_wswrp001"},
            {BASE_ITEM_SCIMITAR,"nwwswsc001"},
            {BASE_ITEM_SCYTHE,"nw_wplsc001"},
            {BASE_ITEM_SHORTBOW,"nw_wbwsh001"},
            {BASE_ITEM_SHORTSPEAR,"zitem_wpn_sspear"},
            {BASE_ITEM_SHORTSTAFF,"zitem_wpn_sstaff"},
            {BASE_ITEM_SHORTSWORD,"nw_wswss001"},
            {BASE_ITEM_SHURIKEN,"nw_wthsh001"},
            {BASE_ITEM_SICKLE,"nw_wspsc001"},
            {BASE_ITEM_SLING,"nw_wbwsl001"},
            {BASE_ITEM_SPEAR,"nw_wplss001"},
            {BASE_ITEM_THROWINGAXE,"nw_wthax001"},
            {BASE_ITEM_WARHAMMER,"nw_wblhw001"},
            {BASE_ITEM_WARMACE,"zitem_wpn_warmace"},
        };
        #endregion
    }
}

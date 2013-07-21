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
    class Generation: CLRScriptBase
    {
        public static Random rand = new Random();

        public static void GenerateLoot(CLRScriptBase script, int lootValue, int maxItemValue)
        {
            if (lootValue < 1)
            {
                return;
            }

            if (maxItemValue < 1)
            {
                maxItemValue = lootValue;
            }

            while (lootValue > 0)
            {
                if (maxItemValue > lootValue)
                {
                    maxItemValue = lootValue;
                }
                switch (script.d10(1))
                {
                    case 1:
                        {
                            lootValue -= GenerateArt(script, maxItemValue);
                            break;
                        }
                    default:
                        {
                            int roll = script.d100(1);
                            int decrease = 0;
                            if (roll > 82)
                            {
                                decrease = GenerateScroll.NewScroll(script, maxItemValue); // 81-100
                                lootValue -= decrease;
                            }
                            else if (roll > 65)
                            {
                                decrease = GeneratePotion.NewPotion(script, maxItemValue); // 66-80
                                lootValue -= decrease;
                            }
                            else if (roll > 55)
                            {
                                decrease = GenerateWand.NewWand(script, maxItemValue); // 56-65
                                lootValue -= decrease;
                            }
                            else if (roll > 52)
                            {
                                decrease = GenerateStaff.NewStaff(script, maxItemValue); // 53-55
                                lootValue -= decrease;
                            }
                            else if (roll > 50)
                            {
                                decrease = GenerateRod.NewRod(script, maxItemValue); // 51-52
                                lootValue -= decrease;
                            }
                            else if (roll > 42)
                            {
                                decrease = GenerateArmor.NewArmor(script, maxItemValue); // 43-50
                                lootValue -= decrease;
                            }
                            else if (roll > 35)
                            {
                                decrease = GenerateWeapon.NewWeapon(script, maxItemValue); // 36-42
                                lootValue -= decrease;
                            }
                            else if (roll > 30)
                            {
                                decrease = GenerateAmulet.NewAmulet(script, maxItemValue); // 31-35
                                lootValue -= decrease;
                            }
                            else if (roll > 25)
                            {
                                decrease = GenerateBelt.NewBelt(script, maxItemValue); // 26-30
                                lootValue -= decrease;
                            }
                            else if (roll > 20)
                            {
                                decrease = GenerateBoots.NewBoots(script, maxItemValue); // 21-25
                                lootValue -= decrease; 
                            }
                            else if (roll > 15)
                            {
                                decrease = GenerateCloak.NewCloak(script, maxItemValue); // 16-20
                                lootValue -= decrease;
                            }
                            else if (roll > 10)
                            {
                                decrease = GenerateHelmet.NewHelmet(script, maxItemValue); // 11-15
                                lootValue -= decrease;
                            }
                            else if (roll > 5)
                            {
                                decrease = GenerateRing.NewRing(script, maxItemValue); // 6-10
                                lootValue -= decrease;
                            }
                            else
                            {
                                decrease = GenerateGloves.NewGloves(script, maxItemValue); // 1-5
                                lootValue -= decrease;
                            }
                            break;
                        }
                }
                if (lootValue < 10)
                {
                    script.CreateItemOnObject("nw_it_gold001", script.OBJECT_SELF, lootValue, "", FALSE);
                    return;
                }
                if (script.d100(1) > 95)
                {
                    script.CreateItemOnObject("nw_it_gold001", script.OBJECT_SELF, maxItemValue / 10, "", FALSE);
                    lootValue -= maxItemValue / 10;
                }
            }
        }

        public static int GenerateArt(CLRScriptBase script, int itemValue)
        {
            int maxGem = itemValue / 5;
            List<string> gems = new List<string>();
            foreach (KeyValuePair<string, int> gem in DroppableGems)
            {
                if (gem.Value <= maxGem)
                {
                    gems.Add(gem.Key);
                }
            }
            if (gems.Count == 0)
            {
                return 0;
            }
            string selectedGem = gems[rand.Next(gems.Count)];
            script.CreateItemOnObject(selectedGem, script.OBJECT_SELF, rand.Next(4) + 1, "", FALSE);
            return DroppableGems[selectedGem];
        }

        public static Theme GetEnchantmentTheme()
        {
            int roll = rand.Next(100);
            if (roll > 90) return Theme.Holy;
            else if (roll > 85) return Theme.Unholy;
            else if (roll > 80) return Theme.UndeadSlaying;
            else if (roll > 75) return Theme.DemonSlaying;
            else if (roll > 70) return Theme.DevilSlaying;
            else if (roll > 65) return Theme.FeySlaying;
            else if (roll > 60) return Theme.ConstructSlaying;
            else if (roll > 55) return Theme.DragonSlaying;
            else if (roll > 50) return Theme.Acid;
            else if (roll > 45) return Theme.Electricity;
            else if (roll > 40) return Theme.Fire;
            else if (roll > 35) return Theme.Cold;
            else if (roll > 30) return Theme.Sound;
            return Theme.Themeless;
        }

        public enum Theme
        {
            Themeless,
            Holy,
            Unholy,
            UndeadSlaying,
            DemonSlaying,
            DevilSlaying,
            FeySlaying,
            ConstructSlaying,
            DragonSlaying,
            GiantSlaying,
            Acid,
            Electricity,
            Fire,
            Cold,
            Sound,
        }

        #region Gem Collections
        public static Dictionary<string, int> DroppableGems = new Dictionary<string, int>
        {
            {"nw_it_gem007", 10},
            {"nw_it_gem015", 20},
            {"nw_it_gem002", 50},
            {"nw_it_gem003", 100},
            {"nw_it_gem014", 125},
            {"nw_it_gem004", 150},
            {"nw_it_gem001", 200},
            {"nw_it_gem011", 300},
            {"nw_it_gem013", 500},
            {"nw_it_gem010", 600},
            {"nw_it_gem006", 675},
            {"nw_it_gem009", 750},
            {"nw_it_gem012", 850},
            {"nw_it_gem008", 900},
            {"nw_it_gem005", 1000},
        };
        #endregion

        #region Spell Focus Collections
        public static List<int> SpellSchoolFocus = new List<int>
        {
            IP_CONST_FEAT_SPELLFOCUSABJ,
            IP_CONST_FEAT_SPELLFOCUSCON,
            IP_CONST_FEAT_SPELLFOCUSDIV,
            IP_CONST_FEAT_SPELLFOCUSENC,
            IP_CONST_FEAT_SPELLFOCUSEVO,
            IP_CONST_FEAT_SPELLFOCUSILL,
            IP_CONST_FEAT_SPELLFOCUSNEC,
        };

        // This gets the school adjacent to the current one to the right on
        // the circle grid of spell schools.
        public static Dictionary<int, int> SpellFocusLeft = new Dictionary<int, int>
        {
            {IP_CONST_FEAT_SPELLFOCUSABJ, IP_CONST_FEAT_SPELLFOCUSCON},
            {IP_CONST_FEAT_SPELLFOCUSCON, IP_CONST_FEAT_SPELLFOCUSENC},
            {IP_CONST_FEAT_SPELLFOCUSDIV, IP_CONST_FEAT_SPELLFOCUSEVO},
            {IP_CONST_FEAT_SPELLFOCUSENC, IP_CONST_FEAT_SPELLFOCUSILL},
            {IP_CONST_FEAT_SPELLFOCUSEVO, IP_CONST_FEAT_SPELLFOCUSNEC},
            {IP_CONST_FEAT_SPELLFOCUSILL, IP_CONST_FEAT_SPELLFOCUSDIV},
            {IP_CONST_FEAT_SPELLFOCUSNEC, IP_CONST_FEAT_SPELLFOCUSABJ},
        };

        // this gets the school adjacent to the current one to the left on
        // the circle grid of spell schools
        public static Dictionary<int, int> SpellFocusRight = new Dictionary<int, int>
        {
            {IP_CONST_FEAT_SPELLFOCUSABJ, IP_CONST_FEAT_SPELLFOCUSNEC},
            {IP_CONST_FEAT_SPELLFOCUSCON, IP_CONST_FEAT_SPELLFOCUSABJ},
            {IP_CONST_FEAT_SPELLFOCUSDIV, IP_CONST_FEAT_SPELLFOCUSILL},
            {IP_CONST_FEAT_SPELLFOCUSENC, IP_CONST_FEAT_SPELLFOCUSCON},
            {IP_CONST_FEAT_SPELLFOCUSEVO, IP_CONST_FEAT_SPELLFOCUSDIV},
            {IP_CONST_FEAT_SPELLFOCUSILL, IP_CONST_FEAT_SPELLFOCUSENC},
            {IP_CONST_FEAT_SPELLFOCUSNEC, IP_CONST_FEAT_SPELLFOCUSEVO},
        };
        #endregion
    }
}

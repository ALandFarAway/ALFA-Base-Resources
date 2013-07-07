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
    public class GeneratePotion: CLRScriptBase
    {
        public static int NewPotion(CLRScriptBase script, int maxValue)
        {
            if (maxValue < 50)
            {
                return 0;
            }
            if (maxValue >= 750)
            {
                switch (Generation.rand.Next(3))
                {
                    case 0:
                        script.CreateItemOnObject(Level1Potions[Generation.rand.Next(Level1Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
                        return 50;
                    case 1:
                        script.CreateItemOnObject(Level2Potions[Generation.rand.Next(Level2Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
                        return 300;
                    case 2:
                        script.CreateItemOnObject(Level3Potions[Generation.rand.Next(Level3Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
                        return 750;
                }
            }
            else if (maxValue >= 300)
            {
                switch (Generation.rand.Next(2))
                {
                    case 0:
                        script.CreateItemOnObject(Level1Potions[Generation.rand.Next(Level1Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
                        return 50;
                    case 1:
                        script.CreateItemOnObject(Level2Potions[Generation.rand.Next(Level2Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
                        return 300;
                }
            }
            script.CreateItemOnObject(Level1Potions[Generation.rand.Next(Level1Potions.Count)], script.OBJECT_SELF, 1, "", FALSE);
            return 50;
        }

        public static List<string> Level1Potions = new List<string>
        {
            "abr_it_mpotion_bless",
            "abr_it_mpotion_marm",
            "abr_it_mpotion_mfang",
            "abr_it_mpotion_sanc",
            "abr_it_mpotion_sof",
            "abr_it_mpotion01",
            "abr_it_mpotion01",
            "abr_it_mpotion01",
            "abr_it_mpotion01",
            "abr_it_mpotion01",
        };

        public static List<string> Level2Potions = new List<string>
        {
            "abr_it_mpotion_aid",
            "abr_it_mpotion_barkskin",
            "abr_it_mpotion_blur",
            "abr_it_mpotion_cha",
            "abr_it_mpotion_con",
            "abr_it_mpotion_darkness",
            "abr_it_mpotion_dex",
            "abr_it_mpotion_int",
            "abr_it_mpotion_invis",
            "abr_it_mpotion_lessrest",
            "abr_it_mpotion_str",
            "abr_it_mpotion_wis",
            "abr_it_mpotion02",
            "abr_it_mpotion02",
            "abr_it_mpotion02",
            "abr_it_mpotion02",
        };

        public static List<string> Level3Potions = new List<string>
        {
            "abr_it_mpotion_antidote",
            "abr_it_mpotion_speed",
            "abr_it_mpotion03",
            "abr_it_mpotion03",
        };
    }

}

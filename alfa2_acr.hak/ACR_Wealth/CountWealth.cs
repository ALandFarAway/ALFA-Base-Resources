using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_Wealth
{
    public class CountWealth
    {
        public const int CutoffMultiplier = 0;
        public const int VeryRichMultiplier = 2;
        public const int RichMultiplier = 5;
        public const int NormalMultiplier = 10;
        public const int PoorMultiplier = 20;
        public const int VeryPoorMultiplier = 40;

        public static float GetWealthMultiplierFloat(CLRScriptBase script, uint Character)
        {
            return ((float)GetWealthMultiplierInt(script, Character)) / 10.0f;
        }

        public static int GetWealthMultiplierInt(CLRScriptBase script, uint Character)
        {
            int lootValue = GetTotalValueOfKit(script, Character);
            int level = GetEffectiveLevel(script, Character);

            if (lootValue < lowMarker[level]) return VeryPoorMultiplier;
            if (lootValue < (targetMarker[level] * 9 / 10)) return PoorMultiplier;
            if (lootValue < (targetMarker[level] * 11 / 10)) return NormalMultiplier;
            if (lootValue < highMarker[level]) return RichMultiplier;
            if (lootValue < cutoffMarker[level]) return VeryRichMultiplier;
            return CutoffMultiplier;
        }

        public static int GetTotalValueOfKit(CLRScriptBase script, uint Character)
        {
            int lootValue = 0;
            foreach (uint item in script.GetItemsInInventory(Character))
            {
                lootValue += script.GetGoldPieceValue(item);
            }
            return lootValue;
        }

        public static int GetEffectiveLevel(CLRScriptBase script, uint Character)
        {
            int xp = script.GetXP(Character);
            int level = 1;
            while(level < 20)
            {
                if(xp < xpToLevel[level + 1])
                {
                    return level;
                }
            }
            return 20;
        }

        static Dictionary<int, int> lowMarker = new Dictionary<int, int>()
        {
            { 1,  300 },
            { 2,  650 },
            { 3,  1925 },
            { 4,  3850 },
            { 5,  6425 },
            { 6,  9300 },
            { 7,  13575 },
            { 8,  19300 },
            { 9,  25750 },
            { 10, 35025 },
            { 11, 47200 },
            { 12, 62925 },
            { 13, 78650 },
            { 14, 107250 },
            { 15, 143000 },
            { 16, 185900 },
            { 17, 243100 },
            { 18, 314600 },
            { 19, 414700 },
            { 20, 500000 },
        };

        static Dictionary<int, int> targetMarker = new Dictionary<int, int>()
        {
            { 1,  600 },
            { 2,  1175 },
            { 3,  3500 },
            { 4,  7025 },
            { 5,  11700 },
            { 6,  16900 },
            { 7,  24700 },
            { 8,  35100 },
            { 9,  46800 },
            { 10, 63700 },
            { 11, 85800 },
            { 12, 114400 },
            { 13, 143000 },
            { 14, 195000 },
            { 15, 260000 },
            { 16, 338000 },
            { 17, 442000 },
            { 18, 572000 },
            { 19, 754000 },
            { 20, 1000000 },
        };

        static Dictionary<int, int> highMarker = new Dictionary<int, int>()
        {
            { 1,  2000 },
            { 2,  3500 },
            { 3,  5100 },
            { 4,  10175 },
            { 5,  16975 },
            { 6,  24500 },
            { 7,  35825 },
            { 8,  50900 },
            { 9,  67850 },
            { 10, 92375 },
            { 11, 124425 },
            { 12, 165875 },
            { 13, 207350 },
            { 14, 282750 },
            { 15, 377000 },
            { 16, 490100 },
            { 17, 640900 },
            { 18, 829400 },
            { 19, 1093300 },
            { 20, 1500000 },
        };

        static Dictionary<int, int> cutoffMarker = new Dictionary<int, int>()
        {
            { 1,  13350 },
            { 2,  13350 },
            { 3,  13350 },
            { 4,  13350 },
            { 5,  22225 },
            { 6,  32100 },
            { 7,  46925 },
            { 8,  66700 },
            { 9,  88925 },
            { 10, 121025 },
            { 11, 163025 },
            { 12, 217350 },
            { 13, 271700 },
            { 14, 370500 },
            { 15, 494000 },
            { 16, 642200 },
            { 17, 839800 },
            { 18, 1086800 },
            { 19, 1432600 },
            { 20, 2000000 },
        };

        static Dictionary<int, int> targetItemValue = new Dictionary<int, int>()
        {
            { 1,  40 },
            { 2,  70 },
            { 3,  210 },
            { 4,  425 },
            { 5,  710 },
            { 6,  1025 },
            { 7,  1500 },
            { 8,  2125 },
            { 9,  2850 },
            { 10, 3860 },
            { 11, 5200 },
            { 12, 6950 },
            { 13, 8666 },
            { 14, 11800 },
            { 15, 15750 },
            { 16, 20500 },
            { 17, 26750 },
            { 18, 34500 },
            { 19, 45500 },
            { 20, 60500 },
        };

        static Dictionary<int, int> xpToLevel = new Dictionary<int, int>()
        {
            { 1,  0 },
            { 2,  1000 },
            { 3,  3000 },
            { 4,  6000 },
            { 5,  10000 },
            { 6,  15000 },
            { 7,  21000 },
            { 8,  28000 },
            { 9,  36000 },
            { 10, 45000 },
            { 11, 55000 },
            { 12, 66000 },
            { 13, 78000 },
            { 14, 91000 },
            { 15, 105000 },
            { 16, 120000 },
            { 17, 136000 },
            { 18, 153000 },
            { 19, 171000 },
            { 20, 190000 },
        };
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ACR_Items
{
    public class ColorPair
    {
        public int Primary;
        public int Accent;
    }

    public static class GeneratedColors
    {
        #region Colors from the Toolset
        public static int White = 0xFFFFFF;
        public static int TenGray = 0xE6E6E6;
        public static int FifteenGray = 0xDADADA;
        public static int TwentyGray = 0xCDCDCD;
        public static int TwentyFiveGray = 0xC1C1C1;
        public static int ThirtyGray = 0xB4B4B4;
        public static int ThirtyFiveGray = 0xA7A7A7;
        public static int FortyGray = 0x9A9A9A;
        public static int FortyFiveGray = 0x8E8E8E;
        public static int FiftyGray = 0x818181;
        public static int FiftyFiveGray = 0x737373;
        public static int SixtyGray = 0x666666;
        public static int SixtyFiveGray = 0x595959;
        public static int SeventyGray = 0x4B4B4B;
        public static int SeventyFiveGray = 0x3D3D3D;
        public static int EightyGray = 0x303030;
        public static int EightyFiveGray = 0x212121;
        public static int NinetyGray = 0x131313;
        public static int NinetyFiveGray = 0x050505;
        public static int Black = 0x000000;
        public static int RGBRed = 0xFF0000;
        public static int PastelRed = 0xF69679;
        public static int LightRed = 0xF26C4F;
        public static int PureRed = 0xED1C24;
        public static int DarkRed = 0x9E0B0E;
        public static int DarkerRed = 0x790000;
        public static int DarkerRedOrange = 0x7B2E00;
        public static int DarkRedOrange = 0xA0410D;
        public static int PureRedOrange = 0xF26522;
        public static int LightRedOrange = 0xF68E56;
        public static int PastelRedOrange = 0xF9AD81;
        public static int DarkerYellowOrange = 0x7D4900;
        public static int DarkYellowOrange = 0xA36209;
        public static int PureYellowOrange = 0xF7941D;
        public static int LightYellowOrange = 0xFBAF5D;
        public static int PastelYellowOrange = 0xFDC689;
        public static int PastelYellow = 0xFFF799;
        public static int LightYellow = 0xFFF568;
        public static int PureYellow = 0xFFF200;
        public static int RGBYellow = 0xFFFF00;
        public static int DarkYellow = 0xABA000;
        public static int DarkerYellow = 0x827B00;
        public static int DarkerPeaGreen = 0x406618;
        public static int DarkPeaGreen = 0x598527;
        public static int PurePeaGreen = 0x8DC63F;
        public static int LightPeaGreen = 0xACD373;
        public static int PastelPeaGreen = 0xC4DF9B;
        public static int DarkerYellowGreen = 0x005E20;
        public static int DarkYellowGreen = 0x197B30;
        public static int PureYellowGreen = 0x39B54A;
        public static int LightYellowGreen = 0x7CC576;
        public static int PastelYellowGreen = 0xA3D39C;
        public static int DarkerGreen = 0x005826;
        public static int DarkGreen = 0x007236;
        public static int PureGreen = 0x00A651;
        public static int LightGreen = 0x3CB878;
        public static int PastelGreen = 0x82CA9C;
        public static int PastelGreenCyan = 0x7ACCC8;
        public static int LightGreenCyan = 0x1CBBB4;
        public static int PureGreenCyan = 0x00A99D;
        public static int DarkGreenCyan = 0x00746B;
        public static int DarkerGreenCyan = 0x005952;
        public static int DarkerCyan = 0x005B7F;
        public static int DarkCyan = 0x0076A3;
        public static int PureCyan = 0x0076A3;
        public static int LightCyan = 0x00BFF3;
        public static int PastelCyan = 0x6DCFF6;
        public static int RGBCyan = 0x00FFFF;
        public static int PastelCyanBlue = 0x7DA7D9;
        public static int LightCyanBlue = 0x448CCB;
        public static int PureCyanBlue = 0x0072BC;
        public static int DarkCyanBlue = 0x004A80;
        public static int DarkerCyanBlue = 0x003663;
        public static int DarkerBlue = 0x002157;
        public static int DarkBlue = 0x003471;
        public static int PureBlue = 0x0054A6;
        public static int LightBlue = 0x5674B9;
        public static int PastelBlue = 0x8781BD;
        public static int RBGBlue = 0x0000FF;
        public static int PastelBlueViolet = 0xA186BE;
        public static int LightBlueViolet = 0x605CA8;
        public static int PureBlueViolet = 0x2E3192;
        public static int DarkBlueViolet = 0x1B1464;
        public static int DarkerBlueViolet = 0x0D004C;
        public static int DarkerViolet = 0x32004B;
        public static int DarkViolet = 0x440E62;
        public static int PureViolet = 0x662D91;
        public static int LightViolet = 0x8560A8;
        public static int PastelViolet = 0xA186BE;
        public static int PastelVioletMagenta = 0xBD8CBF;
        public static int LightVioletMagenta = 0xA864A8;
        public static int PureVioletMagenta = 0x92278F;
        public static int DarkVioletMagenta = 0x630460;
        public static int DarkerVioletMagenta = 0x4B0049;
        public static int DarkerMagenta = 0x7B0046;
        public static int DarkMagenta = 0x9E005D;
        public static int PureMagenta = 0xEC008C;
        public static int LightMagenta = 0xF06EAA;
        public static int PastelMagenta = 0xF49AC1;
        public static int RGBMagenta = 0xFF00FF;
        public static int PastelMagentaRed = 0xF5989D;
        public static int LightMagentaRed = 0xF26D7D;
        public static int PureMagentaRed = 0xED145B;
        public static int DarkMagentaRed = 0x9E0039;
        public static int DarkerMagentaRed = 0x7A0026;
        public static int PaleCoolBrown = 0xC7B299;
        public static int LightCoolBrown = 0x998675;
        public static int MediumCoolBrown = 0x736357;
        public static int DarkCoolBrown = 0x534741;
        public static int DarkerCoolBrown = 0x362F2D;
        public static int PaleWarmBrown = 0xC69C6D;
        public static int LightWarmBrown = 0xA67C52;
        public static int MediumWarmBrown = 0x8C6239;
        public static int DarkWarmBrown = 0x754C24;
        public static int DarkerWarmBrown = 0x603913;
        #endregion

        internal static Dictionary<Generation.Theme, List<ColorPair>> ColorPairs = new Dictionary<Generation.Theme, List<ColorPair>>
        {
            { Generation.Theme.Acid, new List<ColorPair> { new ColorPair { Primary=PastelYellowGreen, Accent=PureYellowGreen } } },
            { Generation.Theme.Cold, new List<ColorPair> { new ColorPair { Primary=PastelBlue, Accent=PureBlue } } },
            { Generation.Theme.ConstructSlaying, new List<ColorPair> { new ColorPair { Primary=Black, Accent=MediumCoolBrown } } },
            { Generation.Theme.DemonSlaying, new List<ColorPair> { new ColorPair { Primary=White, Accent=PureBlue } } },
            { Generation.Theme.DevilSlaying, new List<ColorPair> { new ColorPair { Primary=White, Accent=PureGreen } } },
            { Generation.Theme.DragonSlaying, new List<ColorPair> { new ColorPair { Primary=White, Accent=PureViolet } } },
            { Generation.Theme.Electricity, new List<ColorPair> { new ColorPair { Primary=PastelBlue, Accent=PastelViolet } } },
            { Generation.Theme.FeySlaying, new List<ColorPair> { new ColorPair { Primary=PastelMagenta, Accent=PureMagenta } } },
            { Generation.Theme.Fire, new List<ColorPair> { new ColorPair { Primary=LightYellow, Accent=PureRedOrange } } },
            { Generation.Theme.GiantSlaying, new List<ColorPair> { new ColorPair { Primary=LightCoolBrown, Accent=MediumCoolBrown } } },
            { Generation.Theme.Holy, new List<ColorPair> { new ColorPair { Primary=White, Accent=LightYellow } } },
            { Generation.Theme.Sound, new List<ColorPair> { new ColorPair { Primary=PastelCyanBlue, Accent=LightBlue } } },
            { Generation.Theme.Themeless, new List<ColorPair> { new ColorPair { Primary=ThirtyGray, Accent=FiftyGray } } },
            { Generation.Theme.UndeadSlaying, new List<ColorPair> { new ColorPair { Primary=White, Accent=FiftyGray } } },
            { Generation.Theme.Unholy, new List<ColorPair> { new ColorPair { Primary=Black, Accent=PureRed } } },
        };
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Text;

namespace ALFA.Shared
{
    public static class DisplayString
    {
        static Graphics g = new System.Windows.Forms.Control().CreateGraphics();
        static PrivateFontCollection pfc = new PrivateFontCollection();
        public static string ShortenStringToWidth(string input, int pixels)
        {
            if (pfc.Families.Length == 0)
            {
                lock (pfc)
                {
                    if (pfc.Families.Length == 0)
                        pfc.AddFontFile(ALFA.SystemInfo.GetGameInstallationDirectory() + @"\UI\default\fonts\NWN2_Main.ttf");
                }
            }
            
            float width = g.MeasureString(input, new Font(pfc.Families[0], 10.0f)).Width;
            bool shortened = false;
            while (width > pixels)
            {
                input = input.Substring(0, input.Length - 1);
                width = g.MeasureString(input, new Font(pfc.Families[0], 10.0f)).Width;
                shortened = true;
            }
            input.Trim();
            if (shortened) input += "...";

            return input;
        }
    }
}

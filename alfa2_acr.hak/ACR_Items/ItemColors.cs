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
    public class ItemColors
    {
        public static int GetAccessoryColor(string partName, int colorNumber, ACR_Items.ColorType color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                switch (color)
                {
                    case ACR_Items.ColorType.All:
                        int retVal = colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte * 256 * 256;
                        retVal += colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte * 256;
                        retVal += colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte;
                        return retVal;
                    case ACR_Items.ColorType.Blue:
                        return colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte;
                    case ACR_Items.ColorType.Green:
                        return colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte;
                    case ACR_Items.ColorType.Red:
                        return colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte;
                }
            }
            catch { }
            return -1;
        }

        public static int SetAccessoryColor(string partName, int colorNumber, int color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                colorStruct[colorNumber.ToString()].ValueStruct["r"].ValueByte = (byte)(color & (255 * 256 * 256));
                colorStruct[colorNumber.ToString()].ValueStruct["g"].ValueByte = (byte)(color & (255 * 256));
                colorStruct[colorNumber.ToString()].ValueStruct["b"].ValueByte = (byte)(color & 255);
                return color;
            }
            catch { }
            return -1;
        }
    }
}

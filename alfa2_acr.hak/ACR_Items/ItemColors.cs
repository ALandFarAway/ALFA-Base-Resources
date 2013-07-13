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
        public static int GetAccessoryColor(string partName, int ColorNumber, ACR_Items.ColorType color)
        {
            try
            {
                GFFStruct colorStruct = ALFA.Shared.Modules.InfoStore.ModifiedGff[ACR_Items.ModelChangeVarName].TopLevelStruct[partName].ValueStruct["Tintable"].ValueStruct["Tint"].ValueStruct;
                switch (color)
                {
                    case ACR_Items.ColorType.All:
                        int retVal = colorStruct[ColorNumber.ToString()].ValueStruct["r"].ValueByte * 256 * 256;
                        retVal += colorStruct[ColorNumber.ToString()].ValueStruct["g"].ValueByte * 256;
                        retVal += colorStruct[ColorNumber.ToString()].ValueStruct["b"].ValueByte;
                        return retVal;
                    case ACR_Items.ColorType.Blue:
                        return colorStruct[ColorNumber.ToString()].ValueStruct["b"].ValueByte;
                    case ACR_Items.ColorType.Green:
                        return colorStruct[ColorNumber.ToString()].ValueStruct["g"].ValueByte;
                    case ACR_Items.ColorType.Red:
                        return colorStruct[ColorNumber.ToString()].ValueStruct["r"].ValueByte;
                }
            }
            catch { }
            return -1;
        }
    }
}

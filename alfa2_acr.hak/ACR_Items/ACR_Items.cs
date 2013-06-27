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
    public partial class ACR_Items : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Items([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Items([In] ACR_Items Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(uint), typeof(int), typeof(int), typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            uint Target = (uint)ScriptParameters[0];
            int Command = (int)ScriptParameters[1];
            int Param1 = (int)ScriptParameters[2];
            int Param2 = (int)ScriptParameters[3];
            
            switch((ItemCommand)Command)
            {
                case ItemCommand.AdjustPrice:
                    {
                        Pricing.AdjustPrice(this, Target, Param1);
                        break;
                    }
                case ItemCommand.CalculatePrice:
                    {
                        Pricing.product = OBJECT_INVALID;
                        Pricing.CalculatePrice(this, Target);
                        if (Pricing.product != OBJECT_INVALID &&
                            GetObjectType(OBJECT_SELF) != OBJECT_TYPE_PLACEABLE)
                        {
                            // We have to copy this again to make sure that
                            // this ends up in an inventory.
                            CopyItem(Pricing.product, OBJECT_SELF, FALSE);
                            DestroyObject(Pricing.product, 0.0f, FALSE);
                        }
                        break;
                    }
            }
            return 0;
        }

        public enum ItemCommand
        {
            AdjustPrice = 0,
            CalculatePrice = 1,
        }
    }
}

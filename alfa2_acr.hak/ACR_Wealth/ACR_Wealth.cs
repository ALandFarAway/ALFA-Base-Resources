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

namespace ACR_Wealth
{
    public partial class ACR_Wealth : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_Wealth([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_Wealth([In] ACR_Wealth Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int), typeof(int), typeof(uint), typeof(uint) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            switch((WealthCommands)ScriptParameters[0])
            {
                case WealthCommands.CalculateWealth:
                    return CountWealth.GetTotalValueOfKit(this, (uint)ScriptParameters[2]);
                case WealthCommands.CalculateAppropriateDrop:
                    return CountWealth.GetWealthMultiplierInt(this, (uint)ScriptParameters[2]);
                case WealthCommands.DropWealthInContainer:
                    break;
                case WealthCommands.DropUpToWealthInContainer:
                    break;
            }
            SendMessageToAllDMs(ScriptParameters[0].ToString());
            SendMessageToAllDMs(ScriptParameters[1].ToString());
            SendMessageToAllDMs(ScriptParameters[2].ToString());
            SendMessageToAllDMs(ScriptParameters[3].ToString());
            return 0;
        }

        public enum WealthCommands
        {
            CalculateWealth = 0,
            CalculateAppropriateDrop = 1,
            DropWealthInContainer = 2,
            DropUpToWealthInContainer = 3,
        }
    }
}

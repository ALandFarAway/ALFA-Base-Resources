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
                case WealthCommands.CalculateWealthMultiplier:
                    return CountWealth.GetWealthMultiplierInt(this, (uint)ScriptParameters[2]);
                case WealthCommands.CalculateAppropriateDrop:
                    break;
                case WealthCommands.DropWealthInContainer:
                    break;
                case WealthCommands.DropUpToWealthInContainer:
                    break;
                case WealthCommands.ItemDroppedBy:
                    CountWealth.TrackDroppedItem(this, (uint)ScriptParameters[2], (uint)ScriptParameters[3]);
                    return 0;
                case WealthCommands.PersistentStorageClosed:
                    CountWealth.TrackPersistentChestValues(this, (uint)ScriptParameters[2], (uint)ScriptParameters[3], (int)ScriptParameters[1]);
                    return 0;
            }
            SendMessageToAllDMs(ScriptParameters[0].ToString());
            SendMessageToAllDMs(ScriptParameters[1].ToString());
            SendMessageToAllDMs(ScriptParameters[2].ToString());
            SendMessageToAllDMs(ScriptParameters[3].ToString());
            return 0;
        }

        public enum WealthCommands
        {
            CalculateWealthMultiplier = 0,
            CalculateAppropriateDrop = 1,
            DropWealthInContainer = 2,
            DropUpToWealthInContainer = 3,
            ItemDroppedBy = 4,
            PersistentStorageClosed = 5,
        }
    }
}

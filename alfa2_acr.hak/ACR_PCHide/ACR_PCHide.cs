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

namespace ACR_PCHide
{
    public partial class ACR_PCHide : CLRScriptBase, IGeneratedScriptProgram
    {

        private static Dictionary<int, PCHide> m_HideMap = new Dictionary<int, PCHide>();

        public ACR_PCHide([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_PCHide([In] ACR_PCHide Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(uint), typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            // Decode parameters.
            uint oPC = (uint)ScriptParameters[0];
            int nAction = (int)ScriptParameters[1];

            // Get PID.
            int nCID = GetLocalInt(oPC, "ACR_CID");

            // Make sure the PC has a hide.
            uint oHide = GetItemPossessedBy(oPC, "acr_pchide");
            if (GetIsObjectValid(oHide) == CLRScriptBase.FALSE)
            {
                oHide = GetItemInSlot(CLRScriptBase.INVENTORY_SLOT_CARMOUR, oPC);
                if (GetIsObjectValid(oHide) == CLRScriptBase.FALSE || GetResRef( oHide ) != "acr_pchide")
                {
                    oHide = CreateItemOnObject("acr_pchide", oPC, 1, "acr_pchide", CLRScriptBase.FALSE);
                }
            }

            // If it doesn't exist, create it.
            if (!m_HideMap.ContainsKey(nCID))
            {
                m_HideMap.Add(nCID, new PCHide(oPC, oHide));
            }

            // Remake the hide.
            bool bRetState = m_HideMap[nCID].recalculate(this);
            if (bRetState == false)
            {
                m_HideMap.Remove(nCID);
            }

            return 0;
        }

        private enum ACTIONS
        {
            ACT_REFRESH
        }
    }
}

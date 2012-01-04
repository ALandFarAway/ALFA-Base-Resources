//
// This script issues a simple SQL query.
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace TestClrScript
{
    public partial class TestClrScript : CLRScriptBase, IGeneratedScriptProgram
    {

        public TestClrScript([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            Database = new ALFA.Database(this);
            InitScript(Intrinsics, Host);
        }

        private TestClrScript([In] TestClrScript Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            string ServerDescription;
            string Message;

            Database.ACR_SQLQuery(String.Format("SELECT Name FROM servers WHERE ID = {0}", Database.ACR_GetServerID()));

            if (Database.ACR_SQLFetch())
                ServerDescription = Database.ACR_SQLGetData();
            else
                ServerDescription = "<Database error>";

            Message = String.Format("This server (id {0}) is at {1} and is named {2}", Database.ACR_GetServerID(), Database.ACR_GetServerAddressFromDatabase(), ServerDescription);

            foreach (uint PCObject in GetPlayers(true))
            {
                SendMessageToPC(PCObject, Message);
                SendMessageToPC(PCObject, "Install directory: " + SystemInfo.GetGameInstallationDirectory());
                SendMessageToPC(PCObject, "Home directory: " + SystemInfo.GetHomeDirectory());
                SendMessageToPC(PCObject, "NWNX4 directory: " + SystemInfo.GetNWNX4InstallationDirectory());

                if (SystemInfo.GetModuleResourceName() != null)
                    SendMessageToPC(PCObject, "Module resource name: " + SystemInfo.GetModuleResourceName());
            }

            string ModName = SystemInfo.GetModuleResourceName();

            if (ModName == null)
                ModName = "alfa";

            ResourceManager ResMan = new ResourceManager(ModName);

            foreach (OEIShared.IO.IResourceEntry ResEntry in ResMan.GetResourcesByType(ResourceManager.ResUTI))
            {
                foreach (uint PCObject in GetPlayers(true))
                {
                    SendMessageToPC(PCObject, String.Format("Found resource {0} in repository {1}", ResEntry.FullName, ResEntry.Repository.Name));
                }
            }

            return DefaultReturnCode;
        }

        private ALFA.Database Database;
    }
}

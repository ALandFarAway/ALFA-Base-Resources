//
// This script provides miscellaneous server management functions that are best
// implemented in C# code.
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
using System.IO;
using System.Diagnostics;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_ServerMisc
{
    public partial class ACR_ServerMisc : CLRScriptBase, IGeneratedScriptProgram
    {

        public ACR_ServerMisc([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
            Database = new ALFA.Database(this);
        }

        private ACR_ServerMisc([In] ACR_ServerMisc Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int), typeof(int), typeof(int), typeof(string), typeof(string), typeof(uint) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode;
            int RequestType = (int)ScriptParameters[0];

            switch ((REQUEST_TYPE)RequestType)
            {

                case REQUEST_TYPE.EXECUTE_UPDATER_SCRIPT:
                    {
                        ReturnCode = ExecuteUpdaterScript() ? TRUE : FALSE;
                    }
                    break;

                default:
                    throw new ApplicationException("Invalid server misc command " + RequestType.ToString());

            }

            return ReturnCode;
        }

        /// <summary>
        /// This method is called to execute the server updater script, if one
        /// existed.
        /// </summary>
        /// <returns>True on success, else false if the updater couldn't be
        /// launched.</returns>
        private bool ExecuteUpdaterScript()
        {
            string UpdaterScriptPath = SystemInfo.GetNWNX4InstallationDirectory() + "ACR_UpdaterScript.cmd";

            if (!File.Exists(UpdaterScriptPath))
            {
                WriteTimestampedLogEntry(String.Format(
                    "ACR_ServerMisc.ExecuteUpdaterScript(): Updater script '{0}' doesn't exist.",
                    UpdaterScriptPath));
                return false;
            }

            try
            {
                ProcessStartInfo StartInfo = new ProcessStartInfo(UpdaterScriptPath);

                StartInfo.CreateNoWindow = true;
                StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                StartInfo.LoadUserProfile = false;
                StartInfo.UseShellExecute = false;

                Process.Start(StartInfo);
            }
            catch (Exception e)
            {
                WriteTimestampedLogEntry(String.Format(
                    "ACR_ServerMisc.ExecuteUpdaterScript(): Exception '{0}' starting updater script '{1}'.",
                    e,
                    UpdaterScriptPath));
                return false;
            }

            return true;
        }

        /// <summary>
        /// Get the associated database object, creating it on demand if
        /// required.
        /// </summary>
        /// <returns>The database connection object.</returns>
        private ALFA.Database GetDatabase()
        {
            if (Database == null)
                Database = new ALFA.Database(this);

            return Database;
        }

        /// <summary>
        /// Define type codes for requests to ScriptMain.
        /// </summary>
        private enum REQUEST_TYPE
        {
            EXECUTE_UPDATER_SCRIPT
        }

        /// <summary>
        /// The interop SQL database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;
    }
}

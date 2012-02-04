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
using System.Management.Automation;

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
            int P0 = (int)ScriptParameters[1];
            int P2 = (int)ScriptParameters[2];
            string P3 = (string)ScriptParameters[3];
            string P4 = (string)ScriptParameters[4];
            uint P5 = (uint)ScriptParameters[5];

            switch ((REQUEST_TYPE)RequestType)
            {

                case REQUEST_TYPE.EXECUTE_UPDATER_SCRIPT:
                    {
                        ReturnCode = ExecuteUpdaterScript() ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.CREATE_AREA_INSTANCE:
                    {
                        uint ReturnArea = CreateAreaInstance(P5);

                        if (ReturnArea == OBJECT_INVALID)
                            ReturnCode = FALSE;
                        else
                        {
                            ReturnCode = TRUE;
                            SetLocalObject(GetModule(), "ACR_SERVER_MISC_RETURN_OBJECT", ReturnArea);
                        }
                    }
                    break;

                case REQUEST_TYPE.RELEASE_AREA_INSTANCE:
                    {
                        ReleaseInstancedArea(P5);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.RUN_POWERSHELL_SCRIPTLET:
                    {
                        ReturnCode = RunPowerShellScriptlet(P3, P5) ? TRUE : FALSE;
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
        /// Create a new instanced area, or return one from the free list if
        /// there was a free instance.
        /// </summary>
        /// <param name="TemplateArea">Supplies the template area object id.
        /// </param>
        /// <returns>The instanced area, else OBJECT_INVALID.</returns>
        private uint CreateAreaInstance(uint TemplateArea)
        {
            Stack<uint> FreeList;

            if (InstancedAreaFreeList.TryGetValue(TemplateArea, out FreeList))
            {
                if (FreeList.Count != 0)
                    return FreeList.Pop();
            }

            return CreateInstancedAreaFromSource(TemplateArea);
        }

        /// <summary>
        /// Place an instanced area on the internal free list for its
        /// associated template area.
        /// </summary>
        /// <param name="InstancedArea">Supplies the instanced area to place on
        /// the free list.</param>
        private void ReleaseInstancedArea(uint InstancedArea)
        {
            uint TemplateArea = GetLocalObject(InstancedArea, "ACR_AREA_INSTANCE_PARENT_AREA");
            Stack<uint> FreeList;

            if (!InstancedAreaFreeList.TryGetValue(TemplateArea, out FreeList))
            {
                FreeList = new Stack<uint>();
                InstancedAreaFreeList.Add(TemplateArea, FreeList);
            }

            FreeList.Push(InstancedArea);
        }

        /// <summary>
        /// Run a PowerShell script and send the results to a player.
        /// </summary>
        /// <param name="Script">Supplies the script source text to
        /// execute.</param>
        /// <param name="PCObjectID">Supplies the PC object ID of the player
        /// to notify of the results.  If OBJECT_INVALID, then the results are
        /// written to the server log.</param>
        /// <returns></returns>
        private bool RunPowerShellScriptlet(string Script, uint PCObjectID)
        {
            string Result = null;
            bool CompletedOk = true;

            try
            {
                Script = "Param([Parameter()] $s, [Parameter()] [System.UInt32] $OBJECT_SELF, [Parameter()] [System.UInt32] $OBJECT_INVALID)" + Script;

                using (PowerShell Shell = PowerShell.Create())
                {
                    Dictionary<string, object> Arguments = new Dictionary<string, object>();

                    Arguments["s"] = this;
                    Arguments["OBJECT_SELF"] = PCObjectID;
                    Arguments["OBJECT_INVALID"] = OBJECT_INVALID;

                    Shell.AddScript(Script);
                    Shell.AddParameters(Arguments);
                    Shell.AddCommand("Out-String");

                    foreach (string Line in Shell.Invoke<string>())
                    {
                        if (String.IsNullOrEmpty(Result))
                            Result = "";
                        else
                            Result += "\n";

                        Result += Line;
                    }

                    if (String.IsNullOrWhiteSpace(Result))
                        Result = "<No output returned>";
                }
            }
            catch (Exception e)
            {
                Result = "Exception: " + e.ToString();
                CompletedOk = false;
            }

            if (PCObjectID == OBJECT_INVALID)
                WriteTimestampedLogEntry("ACR_ServerMisc.RunPowerShellScriptlet: Result: " + Result);
            else
                SendMessageToPC(PCObjectID, Result);

            return CompletedOk;
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
            EXECUTE_UPDATER_SCRIPT,
            CREATE_AREA_INSTANCE,
            RELEASE_AREA_INSTANCE,
            RUN_POWERSHELL_SCRIPTLET
        }

        /// <summary>
        /// The interop SQL database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;

        /// <summary>
        /// The list of free instance areas (for a given template area) is
        /// stored here.
        /// </summary>
        private static Dictionary<uint, Stack<uint>> InstancedAreaFreeList = new Dictionary<uint, Stack<uint>>();
    }
}

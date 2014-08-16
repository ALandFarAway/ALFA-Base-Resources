//
// This script provides miscellaneous server management functions that are best
// implemented in C# code.
//

using System;
using System.Collections;
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
using System.Security.Cryptography;

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

        public static Type[] ScriptParameterTypes = { typeof(int), typeof(int), typeof(int), typeof(string), typeof(string), typeof(string), typeof(uint) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode;
            int RequestType = (int)ScriptParameters[0];
            int P0 = (int)ScriptParameters[1];
            int P2 = (int)ScriptParameters[2];
            string P3 = (string)ScriptParameters[3];
            string P4 = (string)ScriptParameters[4];
            string P5 = (string)ScriptParameters[5];
            uint P6 = (uint)ScriptParameters[6];

            switch ((REQUEST_TYPE)RequestType)
            {

                case REQUEST_TYPE.EXECUTE_UPDATER_SCRIPT:
                    {
                        ReturnCode = ExecuteUpdaterScript() ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.CREATE_AREA_INSTANCE:
                    {
                        uint ReturnArea = CreateAreaInstance(P6);

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
                        ReleaseInstancedArea(P6);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.SET_DICTIONARY_VALUE:
                    {
                        DictionarySetString(P3, P4, P5);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.GET_DICTIONARY_VALUE:
                    {
                        string ReturnValue;
                        bool CompletedOk = DictionaryGetString(P3, P4, out ReturnValue);

                        if (!CompletedOk)
                            ReturnCode = FALSE;
                        else
                        {
                            SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", ReturnValue);
                            ReturnCode = TRUE;
                        }
                    }
                    break;

                case REQUEST_TYPE.FIRST_ITERATE_DICTIONARY:
                    {
                        string ReturnKey;
                        bool CompletedOk = DictionaryIterateFirst(P3, out ReturnKey);

                        if (!CompletedOk)
                            ReturnCode = FALSE;
                        else
                        {
                            SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", ReturnKey);
                            ReturnCode = TRUE;
                        }
                    }
                    break;

                case REQUEST_TYPE.NEXT_ITERATE_DICTIONARY:
                    {
                        string ReturnKey;
                        bool CompletedOk = DictionaryIterateNext(P3, out ReturnKey);

                        if (!CompletedOk)
                            ReturnCode = FALSE;
                        else
                        {
                            SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", ReturnKey);
                            ReturnCode = TRUE;
                        }
                    }
                    break;

                case REQUEST_TYPE.DELETE_DICTIONARY_KEY:
                    {
                        DictionaryDeleteKey(P3, P4);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.CLEAR_DICTIONARY:
                    {
                        DictionaryClear(P3);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.RUN_POWERSHELL_SCRIPTLET:
                    {
                        ReturnCode = RunPowerShellScriptlet(P3, P6) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.CREATE_DATABASE_CONNECTION:
                    {
                        ReturnCode = ScriptDatabaseConnection.CreateScriptDatabaseConnection(P3, (ScriptDatabaseConnectionFlags)P0);
                    }
                    break;

                case REQUEST_TYPE.DESTROY_DATABASE_CONNECTION:
                    {
                        ReturnCode = ScriptDatabaseConnection.DestroyDatabaseConnection(P0) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.QUERY_DATABASE_CONNECTION:
                    {
                        ReturnCode = ScriptDatabaseConnection.QueryDatabaseConnection(P0, P3, this) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.FETCH_DATABASE_CONNECTION:
                    {
                        ReturnCode = ScriptDatabaseConnection.FetchDatabaseConnection(P0, this) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.GET_COLUMN_DATABASE_CONNECTION:
                    {
                        string Data = ScriptDatabaseConnection.GetColumnDatabaseConnection(P0, P2, this);

                        if (Data == null)
                        {
                            ReturnCode = FALSE;
                        }
                        else
                        {
                            SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", Data);
                            ReturnCode = TRUE;
                        }
                    }
                    break;

                case REQUEST_TYPE.GET_AFFECTED_ROW_COUNT_DATABASE_CONNECTION:
                    {
                        ReturnCode = ScriptDatabaseConnection.GetAffectedRowCountDatabaseConnection(P0, this);
                    }
                    break;

                case REQUEST_TYPE.ESCAPE_STRING_DATABASE_CONNECTION:
                    {
                        string Data = ScriptDatabaseConnection.EscapeStringDatabaseConnection(P0, P3, this);

                        if (Data == null)
                        {
                            ReturnCode = FALSE;
                        }
                        else
                        {
                            SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", Data);
                            ReturnCode = TRUE;
                        }
                    }
                    break;

                case REQUEST_TYPE.GET_STACK_TRACE:
                    {
                        StackTrace Trace = new StackTrace(true);

                        SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", Trace.ToString());
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.GET_SALTED_MD5:
                    {
                        string SaltedMD5 = GetSaltedMD5(P3);

                        SetLocalString(GetModule(), "ACR_SERVER_MISC_RETURN_STRING", SaltedMD5);
                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.GET_HAS_DATABASE_STORE:
                    {
                        string Campaign = P3;

                        ReturnCode = CampaignObjectFileStore.GetHasDatabaseStore(Campaign) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.DELETE_DATABASE_STORE:
                    {
                        string Campaign = P3;

                        ReturnCode = CampaignObjectFileStore.DeleteDatabaseStore(Campaign) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.DELETE_DATABASE_STORE_AT_INDEX:
                    {
                        string Campaign = P3;
                        int Index = P0;

                        ReturnCode = CampaignObjectFileStore.DeleteDatabaseStoreAtIndex(Campaign, Index) ? TRUE : FALSE;
                    }
                    break;

                case REQUEST_TYPE.SHOW_COMPILER_LOG:
                    {
                        string FileName = String.Format("{0}{1}ALFAModuleRecompile.log", Path.GetTempPath(), Path.DirectorySeparatorChar);

                        SendMessageToPC(OBJECT_SELF, "Last module recompilation log:");

                        try
                        {
                            SendMessageToPC(OBJECT_SELF, File.ReadAllText(FileName));
                        }
                        catch (Exception)
                        {
                            SendMessageToPC(OBJECT_SELF, "<no log file exists>");
                        }

                        ReturnCode = TRUE;
                    }
                    break;

                case REQUEST_TYPE.RESTART_SERVER:
                    {
                        ALFA.SystemInfo.ShutdownGameServer(this);
                        ReturnCode = TRUE;
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

            uint AreaObject = CreateInstancedAreaFromSource(TemplateArea);

            if (AreaObject == OBJECT_INVALID)
                return OBJECT_INVALID;

            //
            // We've created a new area, so inform the AI subsystem that there
            // is a new area to add to its representation.
            //

            ClearScriptParams();
            AddScriptParameterInt(200); // AREA_ON_INSTANCE_CREATE
            ExecuteScriptEnhanced("ACR_CreatureBehavior", AreaObject, TRUE);

            return AreaObject;
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
        /// Set Dictionary DictID's Key to a String Value.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// If this Dictionary does not exist, create it. </param>
        /// <param name="Key">Supplies the Key for lookup of the target dictionary.
        /// If no such Key exists, create a new Key/Value pair. </param>
        /// <param name="Value">Supplies the Value to associate to the Key in the
        /// target dictionary. </param>
        private void DictionarySetString(string DictID, string Key, string Value)
        {
            SortedDictionary<string, string> Dict;

            // Create if does not exist
            if (StorageList.TryGetValue(DictID, out Dict) == false)
            {
                Dict = new SortedDictionary<string, string>();
                StorageList[DictID] = Dict;
            }

            Dict[Key] = Value;
            StorageIteratorList.Remove(DictID);
        }

        /// <summary>
        /// Get Value corresponding to Dictionary DictID's Key.  On error return
        /// null string.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// </param>
        /// <param name="Key">Supplies the Key for lookup of the target dictionary.
        /// </param>
        /// <param name="Value">Output is the Value corresponding to Key.
        /// </param>
        /// <returns>True if Dictionary DictID exists and Key exists within it,
        /// otherwise false.</returns>
        private bool DictionaryGetString(string DictID, string Key, out string Value)
        {
            SortedDictionary<string, string> Dict;

	         Value = "";

            if (StorageList.TryGetValue(DictID, out Dict) == false)
                return false;

            if (Dict.TryGetValue(Key, out Value) == false)
                return false;

            return true;
        }

        /// <summary>
        /// Set Dictionary Iterator to first Key-Value pair and return its Key.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// </param>
        /// <param name="Key">Output is the first Key in the SortedDictionary.
        /// </param>
        /// <returns>True if Dictionary DictID exists and contains elements,
        /// otherwise false.</returns>
        private bool DictionaryIterateFirst(string DictID, out string Key)
        {
            SortedDictionary<string, string> Dict;
            IDictionaryEnumerator ide;

            Key = "";

            if (StorageList.TryGetValue(DictID, out Dict) == false)
                return false;

            ide = Dict.GetEnumerator();

            // Confirm there exists an element within this dictionary,
            // if not simply return false
            if (ide.MoveNext() == false)
                return false;

            Key = (string)ide.Key;

            // Store iterator for future use
            StorageIteratorList[DictID] = ide;

            return true;
        }

        /// <summary>
        /// Advance Dictionary Iterator to next Key-Value pair and return its Key.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// </param>
        /// <param name="Key">Output is the first Key in the SortedDictionary.
        /// </param>
        /// <returns>True if Dictionary DictID exists (and its iterator has been
        /// properly initialized with DictionaryIterateFirst) and the next
        /// Key-Value pair exists, otherwise false.</returns>
        private bool DictionaryIterateNext(string DictID, out string Key)
        {
            IDictionaryEnumerator ide;

            Key = "";

            if (StorageIteratorList.TryGetValue(DictID, out ide) == false)
                return false;

            // If another element does not exist, return false
            if (ide.MoveNext() == false)
            {
                StorageIteratorList.Remove(DictID);
                return false;
            }

            Key = (string)ide.Key;

            return true;
        }

        /// <summary>
        /// Delete value from dictionary by key.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// </param>
        /// <param name="Key">Key to search for and delete from the dictionary.
        /// </param>
        private void DictionaryDeleteKey(string DictID, string Key)
        {
            SortedDictionary<string, string> Dict;

            if (StorageList.TryGetValue(DictID, out Dict) == false)
                return;

            Dict.Remove(Key);
            StorageIteratorList.Remove(Key);
        }

        /// <summary>
        /// Delete entire contents of dictionary by dictionary id.
        /// </summary>
        /// <param name="DictID">Supplies the id of the Dictionary to access.
        /// </param>
        private void DictionaryClear(string DictID)
        {
            StorageList.Remove(DictID);
            StorageIteratorList.Remove(DictID);
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
                Script = "Param([Parameter()] $s, [Parameter()] [System.UInt32] $OBJECT_SELF, [Parameter()] [System.UInt32] $OBJECT_INVALID, [Parameter()] [System.UInt32] $OBJECT_TARGET, [Parameter()] $sql, [Parameter()] $CreatureAI) try { " + Script + " } catch { $_ }";

                using (PowerShell Shell = PowerShell.Create())
                {
                    Dictionary<string, object> Arguments = new Dictionary<string, object>();
                    object AIServer = GetCreatureAIServer();

                    Arguments["s"] = this;
                    Arguments["OBJECT_SELF"] = PCObjectID;
                    Arguments["OBJECT_INVALID"] = OBJECT_INVALID;
                    Arguments["OBJECT_TARGET"] = GetPlayerCurrentTarget(PCObjectID);
                    Arguments["sql"] = GetDatabase();
                    Arguments["CreatureAI"] = AIServer;

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
        /// Get an instance of the ACR_CreatureBehavior.PowerShellInterop.
        /// </summary>
        /// <returns>An ACR_CreatureBehavior.PowerShellInterop on success, else
        /// null failure.</returns>
        private object GetCreatureAIServer()
        {
            Assembly CreatureBehaviorAsm;
            string AsmName;
            object AIServer;

            if (CreatureAIServer != null)
                return CreatureAIServer;

            AsmName = "ACR_CreatureBehavior, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null";
            CreatureBehaviorAsm = (from LoadedAsm in AppDomain.CurrentDomain.GetAssemblies()
                                   where LoadedAsm.FullName == AsmName
                                   select LoadedAsm).FirstOrDefault();

            if (CreatureBehaviorAsm == null)
                return null;

            try
            {
                AIServer = CreatureBehaviorAsm.CreateInstance(
                    "ACR_CreatureBehavior.PowerShellInterop",
                    false,
                    BindingFlags.CreateInstance,
                    null,
                    null,
                    null,
                    null);

                CreatureAIServer = AIServer;
            }
            catch (Exception e)
            {
                WriteTimestampedLogEntry(String.Format(
                    "ACR_ServerMisc.GetCreatureAIServer(): Exception creating ACR_CreatureBehavior interop object: {0}",
                    e));

                AIServer = null;
            }

            return AIServer;
        }

        /// <summary>
        /// Get a salted MD5 of a given string using a per-server-instance
        /// hash salt.
        /// </summary>
        /// <param name="S">Supplies the string to hash.</param>
        /// <returns>The salted MD5 is returned as a hex string.</returns>
        public static string GetSaltedMD5(string S)
        {
            using (MD5CryptoServiceProvider MD5Csp = new MD5CryptoServiceProvider())
            {
                string Salt;
                byte[] Data;
                StringBuilder ReturnString = new StringBuilder();

                Salt = GetSaltString();
                Data = MD5Csp.ComputeHash(Encoding.UTF8.GetBytes(Salt + S));

                for (int i = 0; i < Data.Length; i += 1)
                    ReturnString.Append(Data[i].ToString("x2"));

                return ReturnString.ToString();
            }
        }

        /// <summary>
        /// Create a randomized salt string, or return the existing one if the
        /// string has already been created for this server instance.
        /// </summary>
        /// <returns>The salt string.</returns>
        private static string GetSaltString()
        {
            if (PerInstanceSalt != null)
                return PerInstanceSalt;

            using (RandomNumberGenerator Rng = RandomNumberGenerator.Create())
            {
                byte[] RandomData = new byte[16];
                StringBuilder RandomDataString = new StringBuilder();

                Rng.GetBytes(RandomData);

                for (int i = 0; i < RandomData.Length; i += 1)
                    RandomDataString.Append(RandomData[i].ToString("x2"));

                PerInstanceSalt = RandomDataString.ToString();
            }

            return PerInstanceSalt;
        }

        /// <summary>
        /// Define type codes for requests to ScriptMain.
        /// </summary>
        private enum REQUEST_TYPE
        {
            EXECUTE_UPDATER_SCRIPT,
            CREATE_AREA_INSTANCE,
            RELEASE_AREA_INSTANCE,
            RUN_POWERSHELL_SCRIPTLET,
            CREATE_DATABASE_CONNECTION,
            DESTROY_DATABASE_CONNECTION,
            QUERY_DATABASE_CONNECTION,
            FETCH_DATABASE_CONNECTION,
            GET_COLUMN_DATABASE_CONNECTION,
            GET_AFFECTED_ROW_COUNT_DATABASE_CONNECTION,
            ESCAPE_STRING_DATABASE_CONNECTION,
            GET_STACK_TRACE,
            SET_DICTIONARY_VALUE,
            GET_DICTIONARY_VALUE,
            FIRST_ITERATE_DICTIONARY,
            NEXT_ITERATE_DICTIONARY,
            DELETE_DICTIONARY_KEY,
            CLEAR_DICTIONARY,
            GET_SALTED_MD5,
            GET_HAS_DATABASE_STORE,
            DELETE_DATABASE_STORE,
            DELETE_DATABASE_STORE_AT_INDEX,
            SHOW_COMPILER_LOG,
            RESTART_SERVER
        }

        /// <summary>
        /// The interop SQL database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;

        /// <summary>
        /// The creature AI server object type.
        /// </summary>
        private static object CreatureAIServer = null;

        /// <summary>
        /// The list of free instance areas (for a given template area) is
        /// stored here.
        /// </summary>
        private static Dictionary<uint, Stack<uint>> InstancedAreaFreeList = new Dictionary<uint, Stack<uint>>();

        /// <summary>
        /// A dictionary of all string dictionaries (referenced first by DictionaryID,
        /// then by individual Keys) is stored here.
        /// </summary>
        private static Dictionary<string, SortedDictionary<string, string>> StorageList = new Dictionary<string, SortedDictionary<string, string>>();

        /// <summary>
        /// A dictionary of all SortedDictionary Iterators is stored here.
        /// </summary>
        private static Dictionary<string, IDictionaryEnumerator> StorageIteratorList = new Dictionary<string, IDictionaryEnumerator>();

        /// <summary>
        /// A per server instance salt string, for checksum usage.
        /// </summary>
        private static string PerInstanceSalt = null;
    }
}

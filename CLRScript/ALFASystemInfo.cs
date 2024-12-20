//
// This module contains logic for dealing with game system information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
using System.Diagnostics;
using System.IO;
using System.Net;
using CLRScriptFramework;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ALFA
{

    /// <summary>
    /// This class encapsulates general system information about the game
    /// environment and configuration.
    /// </summary>
    public class SystemInfo
    {

        /// <summary>
        /// This method gets the directory where the game is installed.  The
        /// path has a trailing path separator.
        /// </summary>
        /// <returns>The game installation directory is returned.</returns>
        public static string GetGameInstallationDirectory()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (Args[i] == "-installdir" && i + 1 < Args.Length)
                    return Args[i + 1] + Path.DirectorySeparatorChar;
            }

            return Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName) + Path.DirectorySeparatorChar;
        }

        /// <summary>
        /// This method gets the directory where NWNX4 is installed.  The path
        /// has a trailing path separator.
        /// </summary>
        /// <returns>The NWNX4 installation directory is returned.</returns>
        public static string GetNWNX4InstallationDirectory()
        {
            ProcessModule NWScriptPluginModule = null;

            foreach (ProcessModule Module in Process.GetCurrentProcess().Modules)
            {
                if (Module.ModuleName == "xp_AuroraServerNWScript.dll")
                {
                    NWScriptPluginModule = Module;
                    break;
                }
            }

            if (NWScriptPluginModule == null)
                throw new ApplicationException("Couldn't locate xp_AuroraServerNWScript.dll in loaded module list!");

            return Path.GetDirectoryName(NWScriptPluginModule.FileName) + Path.DirectorySeparatorChar;
        }

        /// <summary>
        /// This routine gets the NWN2 "Home" directory, which is the directory
        /// name by -home on the command line, or else the user's NWN2
        /// directory under Documents.
        /// </summary>
        /// <returns>The game home directory is returned.</returns>
        public static string GetHomeDirectory()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (Args[i] == "-home" && i + 1 < Args.Length)
                    return Args[i + 1] + "\\";
            }

            return Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\Neverwinter Nights 2\\";
        }

        /// <summary>
        /// This routine gets the directory with the module data files for the
        /// current module.  The routine only works if the server was started
        /// with -moduledir.
        /// </summary>
        /// <returns>The module directory, else null if it could not be
        /// determined.</returns>
        public static string GetModuleDirectory()
        {
            string HomeDirectory = GetHomeDirectory();
            string ModuleResourceName = GetModuleResourceName();

            if (ModuleResourceName == null)
                return null;

            string ModuleDirectory = String.Format("{0}modules\\{1}", HomeDirectory, ModuleResourceName);

            if (!Directory.Exists(ModuleDirectory))
                return null;

            return ModuleDirectory;
        }

        /// <summary>
        /// This routine gets the override directory for the current NWN2Server
        /// instance.
        /// </summary>
        /// <returns>The override directory, with a trailing separator
        /// character.</returns>
        public static string GetOverrideDirectory()
        {
            return String.Format("{0}\\override\\", GetHomeDirectory());
        }

        /// <summary>
        /// This routine gets the home directory hak directory for the current
        /// NWN2Server instance.
        /// </summary>
        /// <returns>The user hak directory, with a trailing separator
        /// character.</returns>
        public static string GetHakDirectory()
        {
            return String.Format("{0}\\hak\\", GetHomeDirectory());
        }

        /// <summary>
        /// This routine gets the resource name of the module that was passed
        /// on the server command line.  Note that if the server did not have a
        /// module argument then null is returned.
        /// </summary>
        /// <returns>The module resource name is returned.</returns>
        public static string GetModuleResourceName()
        {
            string[] Args = Environment.GetCommandLineArgs();

            for (int i = 0; i < Args.Length; i += 1)
            {
                if (((Args[i] == "-module") || (Args[i] == "-moduledir")) && i + 1 < Args.Length)
                    return Args[i + 1];
            }

            return null;
        }

        /// <summary>
        /// This helper method loads an assembly from the NWNX4 installation
        /// directory.
        /// </summary>
        /// <param name="AssemblyName">Supplies the DLL file name of the
        /// assembly to load.  The assembly should be present in the NWNX4
        /// installation directory.</param>
        /// <returns>The loaded assembly is returned.</returns>
        public static Assembly LoadAssemblyFromNWNX4(string AssemblyName)
        {
            return Assembly.LoadFrom(GetNWNX4InstallationDirectory() + AssemblyName);
        }

        /// <summary>
        /// This routine determines the UDP listener endpoint for the server.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <returns>The listener endpoint for the server.</returns>
        public static IPEndPoint GetServerUdpListener(CLRScriptBase Script)
        {
            int CurrentProcessId = Process.GetCurrentProcess().Id;
            uint TableSize = 0;
            IntPtr Table = IntPtr.Zero;
            uint Status = NO_ERROR;
            int LocalPort;

            //
            // If we have cached the data, return it from the cache.
            //
            // It is important to check the cache if we spin up a secondary
            // UDP socket (and that the cache is first set before that is done)
            // or else we might return the wrong listener.
            //

            if ((LocalPort = Script.GetGlobalInt("ACR_SERVERLISTENER_PORT")) != 0)
            {
                return new IPEndPoint((long)(UInt32)Script.GetGlobalInt("ACR_SERVERLISTENER_ADDRESS"), LocalPort);
            }

            //
            // Find the first UDP listener owned by this process and assume
            // that it's the right one.
            //

            try
            {
                do
                {
                    if (Table != IntPtr.Zero)
                    {
                        Marshal.FreeHGlobal(Table);
                        Table = IntPtr.Zero;
                    }

                    if (TableSize != 0)
                    {
                        Table = Marshal.AllocHGlobal((int)TableSize);
                    }

                    Status = GetExtendedUdpTable(Table, ref TableSize, 1, AF_INET, UDP_TABLE_CLASS.UDP_TABLE_OWNER_PID, 0);
                } while (Status == ERROR_INSUFFICIENT_BUFFER);

                if (Status != NO_ERROR)
                {
                    throw new ApplicationException(String.Format("ALFA.SystemInfo.GetServerUdpListener: GetExtendedUdpTable failed, status = {0}", Status));
                }

                MIB_UDPTABLE_OWNER_PID UdpTable = (MIB_UDPTABLE_OWNER_PID) Marshal.PtrToStructure(Table, typeof(MIB_UDPTABLE_OWNER_PID));

                for (uint Row = 0; Row < UdpTable.dwNumEntries; Row += 1)
                {
                    IntPtr TableOffset = Marshal.OffsetOf(typeof(MIB_UDPTABLE_OWNER_PID), "table");
                    int RowSize = Marshal.SizeOf(typeof(MIB_UDPROW_OWNER_PID));
                    IntPtr RowOffset = IntPtr.Add(TableOffset, (int)(RowSize * Row));
                    MIB_UDPROW_OWNER_PID UdpRow = (MIB_UDPROW_OWNER_PID)Marshal.PtrToStructure(IntPtr.Add(Table, (int)RowOffset), typeof(MIB_UDPROW_OWNER_PID));

                    if (UdpRow.dwOwningPid != (uint)CurrentProcessId)
                        continue;

                    LocalPort = IPAddress.NetworkToHostOrder((short)UdpRow.dwLocalPort);

                    //
                    // Use loopback (disable deprecation warning) if we have no
                    // bound address.
                    //

#pragma warning disable 618
                    if (UdpRow.dwLocalAddr == 0)
                        UdpRow.dwLocalAddr = (uint)(ulong)IPAddress.Loopback.Address;
#pragma warning restore 618

                    //
                    // Cache the data and return a new endpoint object for the
                    // address.
                    //

                    Script.SetGlobalInt("ACR_SERVERLISTENER_PORT", LocalPort);
                    Script.SetGlobalInt("ACR_SERVERLISTENER_ADDRESS", (int)UdpRow.dwLocalAddr);

                    return new IPEndPoint((long)(ulong)UdpRow.dwLocalAddr, LocalPort);
                }
            }
            finally
            {
                if (Table != IntPtr.Zero)
                    Marshal.FreeHGlobal(Table);
            }

            throw new ApplicationException("Endpoint not found.");
        }

        /// <summary>
        /// This function sets the GameObjUpdate interval.  The default is 200
        /// milliseconds.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <param name="GameObjUpdateTime">Supplies the new game object update
        /// time, in milliseconds.</param>
        public static void SetGameObjUpdateTime(CLRScriptBase Script, int GameObjUpdateTime)
        {
            Script.SetGlobalInt("ACR_GAMEOBJUPDATE_TIME", GameObjUpdateTime);
            Script.NWNXSetInt("BUGF", "GAMEOBJUPDATETIME", "", 0, GameObjUpdateTime * 1000);
        }

        /// <summary>
        /// This function gets the current GameObjUpdate interval.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <returns>The current GameObjUpdate interval, in milliseconds, is
        /// returned.</returns>
        public static int GetGameObjUpdateTime(CLRScriptBase Script)
        {
            int Interval = Script.GetGlobalInt("ACR_GAMEOBJUPDATE_TIME");

            //
            // Assume default if it has not been set yet.
            //

            if (Interval == 0)
                Interval = DEFAULT_GAMEOBJUPDATE_TIME;

            return Interval;
        }

        /// <summary>
        /// Get the first object id corresponding to dynamic objects.  All
        /// object ids below this object id are static objects (excluding PC
        /// objects).
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <returns>The first dynamic object id is returned.</returns>
        public static uint GetFirstDynamicObjectId(CLRScriptBase Script)
        {
            if (FirstDynamicObjectId == ManagedNWScript.OBJECT_INVALID)
                FirstDynamicObjectId = (uint)Script.GetGlobalInt("ACR_FIRST_DYNAMIC_OBJECT_ID");

            return FirstDynamicObjectId;
        }

        /// <summary>
        /// Check whether an object is a dynamic object, i.e. one created after
        /// module startup.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <param name="ObjectId">Supplies the object id to check.</param>
        /// <returns>True if the object is dynamically created.</returns>
        public static bool IsDynamicObject(CLRScriptBase Script, uint ObjectId)
        {
            //
            // Check for PCs first as they start start at 7FFFFFFF and count
            // down.
            //

            if (Script.GetIsPC(ObjectId) != CLRScriptBase.FALSE)
                return true;

            if (ObjectId == ManagedNWScript.OBJECT_INVALID)
                return false;

            return (ObjectId > GetFirstDynamicObjectId(Script));
        }

        /// <summary>
        /// This structure contains SQL connection settings, used for the
        /// establishment of auxiliary MySQL connections to the central
        /// database server (e.g. for true asynchronous queries on a different
        /// thread).
        /// </summary>
        public class SQLConnectionSettings
        {
            /// <summary>
            /// The database server hostname.
            /// </summary>
            public string Server;

            /// <summary>
            /// The database server user.
            /// </summary>
            public string User;

            /// <summary>
            /// The database server password.
            /// </summary>
            public string Password;

            /// <summary>
            /// The database server schema.
            /// </summary>
            public string Schema;
        }

        /// <summary>
        /// Get the database connection settings from the SQL plugin, e.g. for
        /// use in setting up an auxiliary database connection.
        /// 
        /// Throws an exception if the settings could not be found.
        /// </summary>
        /// <returns>The database connection settings are returned.</returns>
        public static SQLConnectionSettings GetSQLConnectionSettings()
        {
            SQLConnectionSettings Settings = new SQLConnectionSettings();
            string[] Lines = File.ReadAllLines(GetNWNX4InstallationDirectory() + "xp_mysql.ini");
            string[] Keywords = {"server", "user", "password", "schema"};

            foreach (string Line in Lines)
            {
                foreach (string Keyword in Keywords)
                {
                    if (!Line.StartsWith(Keyword))
                        continue;

                    //
                    // Skip to the equals sign and check that the intervening
                    // characters were all whitespace.
                    //

                    int Equals = Line.IndexOf('=');

                    if (Equals == -1 || Equals < Keyword.Length)
                        continue;

                    for (int i = Keyword.Length; i < Equals; i += 1)
                    {
                        if (!Char.IsWhiteSpace(Line[i]))
                        {
                            Equals = -1;
                            break;
                        }
                    }

                    if (Equals == -1)
                        continue;

                    //
                    // Now get the value and set it in the structure.
                    //

                    string Value = Line.Substring(Equals + 1).TrimStart(new char[] { '\t', ' '});
                    FieldInfo Field = typeof(SQLConnectionSettings).GetField(Keyword, BindingFlags.Public | BindingFlags.IgnoreCase | BindingFlags.Instance);
                    
                    Field.SetValue(Settings, Value);
                }
            }

            if (String.IsNullOrWhiteSpace(Settings.Server))
                throw new ApplicationException("No database server specified in the configuraiton file.");
            if (String.IsNullOrWhiteSpace(Settings.User))
                throw new ApplicationException("No database user specified in the configuration file.");
            if (String.IsNullOrWhiteSpace(Settings.Password))
                throw new ApplicationException("No database password specified in the configuration file.");
            if (String.IsNullOrWhiteSpace(Settings.Schema))
                throw new ApplicationException("No database schema specified in the configuration file.");

            return Settings;
        }

        /// <summary>
        /// Read an INI file setting from a NWNX4 plugin INI.  The INI must
        /// follow the Windows INI format of [Sections] with Setting=Value .
        /// 
        /// Note that some plugins, such as xp_mysql, do NOT use this format
        /// and cannot use this function.
        /// 
        /// The maximum string length read from the INI file by this function
        /// is MAX_PATH.
        /// </summary>
        /// <param name="IniFileName">Supplies the INI file name, such as
        /// "AuroraServerVault.ini".  The file name should not include a path
        /// component.</param>
        /// <param name="SectionName">Supplies the section name, such as
        /// "Settings".</param>
        /// <param name="SettingName">Supplies the setting name, such as
        /// "LocalServerVaultPath".</param>
        /// <param name="DefaultValue">Supplies the default value to return if
        /// the setting didn't exist.</param>
        /// <returns>The value text (or default value) is returned.</returns>
        public static string GetNWNX4IniString(string IniFileName, string SectionName, string SettingName, string DefaultValue)
        {
            return GetNWNX4IniString(IniFileName, SectionName, SettingName, DefaultValue, MAX_PATH);
        }

        /// <summary>
        /// Read an INI file setting from a NWNX4 plugin INI.  The INI must
        /// follow the Windows INI format of [Sections] with Setting=Value .
        /// 
        /// Note that some plugins, such as xp_mysql, do NOT use this format
        /// and cannot use this function.
        /// </summary>
        /// <param name="IniFileName">Supplies the INI file name, such as
        /// "AuroraServerVault.ini".  The file name should not include a path
        /// component.</param>
        /// <param name="SectionName">Supplies the section name, such as
        /// "Settings".</param>
        /// <param name="SettingName">Supplies the setting name, such as
        /// "LocalServerVaultPath".</param>
        /// <param name="DefaultValue">Supplies the default value to return if
        /// the setting didn't exist.</param>
        /// <param name="MaxValueSize">Supplies the maximum length of the
        /// string value to read from the INI file.  This must be at least as
        /// long as the DefaultValue length.</param>
        /// <returns>The value text (or default value) is returned.</returns>
        public static string GetNWNX4IniString(string IniFileName, string SectionName, string SettingName, string DefaultValue, int MaxValueSize)
        {
            if (MaxValueSize < DefaultValue.Length + 1)
                throw new ApplicationException("MaxValueLength is shorter than the default value length.");

            StringBuilder ReturnedString = new StringBuilder(MaxValueSize);

            GetPrivateProfileStringW(
                SectionName,
                SettingName,
                DefaultValue,
                ReturnedString,
                (uint)MaxValueSize,
                GetNWNX4InstallationDirectory() + IniFileName);

            return ReturnedString.ToString();
        }

        /// <summary>
        /// Get the local server vault path for an account, given an account
        /// name.
        /// 
        /// Note that the server must be using the server vault plugin for this
        /// function to work.
        /// </summary>
        /// <param name="AccountName"></param>
        /// <returns>Returns the vault path for the account, with a path
        /// separator on the end, else null if vault path could not be found.
        /// </returns>
        public static string GetServerVaultPathForAccount(string AccountName)
        {
            string VaultPath = GetNWNX4IniString(
                "AuroraServerVault.ini",
                "Settings",
                "LocalServerVaultPath",
                "");

            if (String.IsNullOrEmpty(VaultPath))
                return null;

            return String.Format("{0}{1}{2}{3}", VaultPath, Path.DirectorySeparatorChar, AccountName, Path.DirectorySeparatorChar);
        }

        /// <summary>
        /// Get the filesystem path to the central, shared vault.
        /// 
        /// Note that the server must be using the server vault plugin for this
        /// function to work.
        /// </summary>
        /// <returns>Returns the path to the central server vault share, else
        /// null if the path couldn't be determined (usually because the plugin
        /// was not installed).</returns>
        public static string GetCentralVaultPath()
        {
            string VaultPath = GetNWNX4IniString(
                "AuroraServerVault.ini",
                "Settings",
                "RemoteServerVaultPath",
                "");

            if (String.IsNullOrEmpty(VaultPath))
                return null;

            //
            // Append a trailing path separator if one was not there already,
            // consistent with how the server vault plugin functions
            // internally.
            //

            if (!VaultPath.EndsWith(Path.DirectorySeparatorChar.ToString()) &&
                !VaultPath.EndsWith(Path.AltDirectorySeparatorChar.ToString()))
            {
                VaultPath = VaultPath + Path.DirectorySeparatorChar;
            }

            return VaultPath;
        }

        /// <summary>
        /// Get the remote server vault path for an account, given an account
        /// name.
        /// 
        /// Note that the server must be using the server vault plugin for this
        /// function to work.
        /// </summary>
        /// <param name="AccountName"></param>
        /// <returns>Returns the vault path for the account, with a path
        /// separator on the end, else null if vault path could not be found.
        /// </returns>
        public static string GetCentralVaultPathForAccount(string AccountName)
        {
            string CentralVaultPath = GetCentralVaultPath();

            if (String.IsNullOrEmpty(CentralVaultPath))
                return null;

            return String.Format("{0}{1}{2}", CentralVaultPath, AccountName, Path.DirectorySeparatorChar);
        }

        /// <summary>
        /// Check whether the storage plugin for xp_ServerVault is in use,
        /// implying that the central vault path is just a cache that can be
        /// purged for purge cached character requests.
        /// </summary>
        /// <returns>True if the storage plugin is in use.</returns>
        public static bool GetVaultStoragePluginInUse()
        {
            int StoragePluginInUse = Convert.ToInt32(GetNWNX4IniString(
                "AuroraServerVault.ini",
                "Settings",
                "UseStoragePlugin",
                "0"));

            return (StoragePluginInUse != 0);
        }

        /// <summary>
        /// Check whether a file name has dangerous characters, such as path
        /// characters or references to special device names.
        /// </summary>
        /// <param name="FileName">Supplies the file name to check.</param>
        /// <param name="AllowSeparators">Supplies true if separators are
        /// allowed.</param>
        /// <returns>True if the file name is safe.</returns>
        public static bool IsSafeFileName(string FileName, bool AllowSeparators = false)
        {
            if (FileName.IndexOf("..") != -1)
                return false;
            else if (!AllowSeparators && FileName.IndexOf(Path.DirectorySeparatorChar) != -1)
                return false;
            else if (!AllowSeparators && FileName.IndexOf(Path.AltDirectorySeparatorChar) != -1)
                return false;
            else if (!AllowSeparators && FileName.IndexOfAny(Path.GetInvalidFileNameChars()) != -1)
                return false;
            else if (AllowSeparators && FileName.IndexOfAny(Path.GetInvalidPathChars()) != -1)
                return false;
            else if (FileName == "PRN")
                return false;
            else if (FileName == "AUX")
                return false;
            else if (FileName == "CON")
                return false;
            else if (FileName == "NUL")
                return false;
            else if (FileName == "CONIN$")
                return false;
            else if (FileName == "CONOUT$")
                return false;
            else if (FileName == "CLOCK$")
                return false;

            return true;
        }

        /// <summary>
        /// Delete a file while ignoring any exceptions that may occur.
        /// </summary>
        /// <param name="FileName">Supplies the name of the file to
        /// delete.</param>
        public static void SafeDeleteFile(string FileName)
        {
            try
            {
                File.Delete(FileName);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Request that the game server cleanly shut down.  Note that NWNX4
        /// will restart the game server afterwards in the default ALFA
        /// configuration, so this function is usually used to restart the game
        /// server, not stop it permanently.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        public static void ShutdownGameServer(CLRScriptBase Script)
        {
            Script.NWNXSetString("SRVADMIN", "SHUTDOWNNWN2SERVER", "", 0, "");
        }

        /// <summary>
        /// Change the player password.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <param name="Password">Supplies the new password to set.</param>
        public static void SetPlayerPassword(CLRScriptBase Script, string Password)
        {
            Script.NWNXSetString("SRVADMIN", "SETPLAYERPASSWORD", Password, 0, "");
        }

        /// <summary>
        /// Change the DM password.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <param name="Password">Supplies the new password to set.</param>
        public static void SetDMPassword(CLRScriptBase Script, string Password)
        {
            Script.NWNXSetString("SRVADMIN", "SETDMPASSWORD", Password, 0, "");
        }

        /// <summary>
        /// Change the admin password.
        /// </summary>
        /// <param name="Script">Supplies the caller's script object.</param>
        /// <param name="Password">Supplies the new password to set.</param>
        public static void SetAdminPassword(CLRScriptBase Script, string Password)
        {
            Script.NWNXSetString("SRVADMIN", "SETADMINPASSWORD", Password, 0, "");
        }

        /// <summary>
        /// Adjust the difficulty level of the game.
        /// </summary>
        /// <param name="IncreaseDifficulty">Supplies true to increase
        /// difficulty, else false to reduce it.  Nothing happens if the game
        /// is already at the highest difficulty and an attempt to increase it,
        /// or vice versa, is made.</param>
        public static void AdjustGameDifficultyLevel(bool IncreaseDifficulty)
        {
            IntPtr ExoAppWindow = GetExoAppWindow();
            IntPtr DifficultySlider = GetExoAppDifficultySliderWindow(ExoAppWindow);

            //
            // Fake a SB_LINE[UP|DOWN] and SB_ENDSCROLL pair of notifications
            // to the parent window.  The actual scroll bar position is not
            // used (and, indeed, the scroll bar has a legal range of 0 - 0),
            // 

            SendMessage(ExoAppWindow,
                WM_VSCROLL,
                (IntPtr)(IncreaseDifficulty == true ? SB_LINEUP : SB_LINEDOWN),
                DifficultySlider);
            SendMessage(ExoAppWindow, WM_VSCROLL, (IntPtr)SB_ENDSCROLL, DifficultySlider);
        }

        /// <summary>
        /// Disable error reporting for the current process.
        /// </summary>
        public static void DisableWer()
        {
            try
            {
                WerAddExcludedApplication(Process.GetCurrentProcess().MainModule.FileName, 0);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Enable error reporting for the current process.
        /// </summary>
        public static void EnableWer()
        {
            try
            {
                WerRemoveExcludedApplication(Process.GetCurrentProcess().MainModule.FileName, 0);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Check whether the caller is running in the context of the game
        /// server process.
        /// </summary>
        /// <returns>True if the caller is running in the server process.
        /// </returns>
        public static bool IsRunningInNWN2Server()
        {
            try
            {
                if (GetExoAppWindow() != IntPtr.Zero)
                    return true;
            }
            catch (ApplicationException)
            {
            }

            return false;
        }



        /// <summary>
        /// Get the Exo main app window.
        /// </summary>
        /// <returns>The main app window hwnd.</returns>
        private static IntPtr GetExoAppWindow()
        {
            uint ProcessId = (uint)System.Diagnostics.Process.GetCurrentProcess().Id;
            IntPtr ExoAppWindow = IntPtr.Zero;
            uint WindowProcessId;

            do
            {
                ExoAppWindow = FindWindowEx(IntPtr.Zero, ExoAppWindow, ExoAppClassName, null);

                if (ExoAppWindow == IntPtr.Zero)
                {
                    throw new ApplicationException("Couldn't find ExoAppWindow");
                }

                WindowProcessId = 0;
                GetWindowThreadProcessId(ExoAppWindow, out WindowProcessId);
            } while (WindowProcessId != ProcessId);

            return ExoAppWindow;
        }

        /// <summary>
        /// Get the difficulty slider window from an Exo App window.
        /// </summary>
        /// <param name="ExoAppWindow">Supplies the Exo App hwnd.</param>
        /// <returns>The difficulty slider hwnd.</returns>
        private static IntPtr GetExoAppDifficultySliderWindow(IntPtr ExoAppWindow)
        {
            IntPtr hwnd = GetDlgItem(ExoAppWindow, ExoCtrlIdDifficultyScrollBar);

            if (hwnd == null)
                throw new ApplicationException("Couldn't find DifficultySliderWindow");

            return hwnd;
        }



        /// <summary>
        /// The first object id corresponding to dynamically created objects,
        /// that is, objects that are created after server startup, is recorded
        /// here.
        /// </summary>
        private static uint FirstDynamicObjectId = ManagedNWScript.OBJECT_INVALID;

        /// <summary>
        /// The default GameObjUpdate time is 200ms.  This is the value that
        /// the server uses unless modified.
        /// </summary>
        public const int DEFAULT_GAMEOBJUPDATE_TIME = 200;
        /// <summary>
        /// GameObjUpdate times above this value impact player experience in
        /// such a way that they should generally be avoided.
        /// </summary>
        public const int MAX_RECOMMENDED_GAMEOBJUPDATE_TIME = 600;

        //
        // The following are private interop members.
        //

        [StructLayout(LayoutKind.Sequential)]
        private struct MIB_UDPROW_OWNER_PID
        {
            public UInt32 dwLocalAddr;
            public UInt32 dwLocalPort;
            public UInt32 dwOwningPid;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct MIB_UDPTABLE_OWNER_PID
        {
            public UInt32 dwNumEntries;
            public MIB_UDPROW_OWNER_PID table;
        }

        private const UInt32 AF_INET = 2;
        private const UInt32 NO_ERROR = 0;
        private const UInt32 ERROR_INSUFFICIENT_BUFFER = 122;

        private const int MAX_PATH = 260;

        private enum UDP_TABLE_CLASS
        {
            UDP_TABLE_BASIC,
            UDP_TABLE_OWNER_PID,
            UDP_TABLE_OWNER_MODULE
        }

        [DllImport("iphlpapi.dll", ExactSpelling = true, SetLastError = false, CallingConvention = CallingConvention.StdCall)]
        private static extern UInt32 GetExtendedUdpTable(IntPtr pUdpTable, ref UInt32 pdwSize, Int32 bOrder, UInt32 ulAf, UDP_TABLE_CLASS TableClass, UInt32 Reserved);

        [DllImport("kernel32.dll", ExactSpelling = true, SetLastError = true, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private static extern UInt32 GetPrivateProfileStringW(string lpAppName, string lpKeyName, string lpDefault, StringBuilder lpReturnedString, UInt32 nSize, string lpFileName);

        [DllImport("wer.dll", ExactSpelling = true, SetLastError = false, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private static extern UInt32 WerAddExcludedApplication(string pwszExeName, int bAllUsers);

        [DllImport("wer.dll", ExactSpelling = true, SetLastError = false, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private static extern UInt32 WerRemoveExcludedApplication(string pwszExeName, int bAllUsers);


        //
        // Exo App window constants.
        //

        internal const string ExoAppClassName = "Exo - BioWare Corp., (c) 1999 - Generic Blank Application";
        internal const int ExoCtrlIdDifficultyScrollBar = 0x3F7;

        //
        // General WinUser structures, functions, & constants.
        //

        internal const uint WM_HSCROLL = 0x114;
        internal const uint WM_VSCROLL = 0x115;

        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true)]
        internal extern static IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall)]
        internal extern static uint GetWindowThreadProcessId(IntPtr hwnd, out uint lpdwProcessId);
        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, SetLastError = true)]
        internal extern static IntPtr GetDlgItem(IntPtr hDlg, int nIDDlgItem);
        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true)]
        internal extern static IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

        //
        // Scroll Bar structures, functions, & constants.
        //

        [StructLayout(LayoutKind.Sequential)]
        internal struct SCROLLINFO
        {
            public uint cbSize;
            public uint fMask;
            public int nMin;
            public int nMax;
            public uint nPage;
            public int nPos;
            public int nTrackPos;
        }

        internal const uint SIF_RANGE = 0x0001;
        internal const uint SIF_PAGE = 0x0002;
        internal const uint SIF_POS = 0x0004;
        internal const uint SIF_DISABLENOSCROLL = 0x0008;
        internal const uint SIF_TRACKPOS = 0x0010;
        internal const uint SIF_ALL = SIF_RANGE | SIF_PAGE | SIF_POS | SIF_DISABLENOSCROLL | SIF_TRACKPOS;

        internal const int SB_HORZ = 0;
        internal const int SB_VERT = 1;
        internal const int SB_CTL = 2;
        internal const int SB_BOTH = 3;

        internal const int SB_LINEUP = 0;
        internal const int SB_LINELEFT = 0;
        internal const int SB_LINEDOWN = 1;
        internal const int SB_LINERIGHT = 1;
        internal const int SB_PAGEUP = 2;
        internal const int SB_PAGELEFT = 2;
        internal const int SB_PAGEDOWN = 3;
        internal const int SB_PAGERIGHT = 3;
        internal const int SB_THUMBPOSITION = 4;
        internal const int SB_THUMBTRACK = 5;
        internal const int SB_TOP = 6;
        internal const int SB_LEFT = 6;
        internal const int SB_BOTTOM = 7;
        internal const int SB_RIGHT = 7;
        internal const int SB_ENDSCROLL = 8;


        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true)]
        internal extern static bool GetScrollInfo(IntPtr hwnd, int fnBar, [In, Out] ref SCROLLINFO lpsi);
        [DllImport("User32.dll", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true)]
        internal extern static int SetScrollInfo(IntPtr hwnd, int fnBar, [In] ref SCROLLINFO lpsi, bool fRedraw);
    }   
}


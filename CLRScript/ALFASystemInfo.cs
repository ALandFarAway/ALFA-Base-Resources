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
            Script.NWNXSetInt("BUGFIX", "GAMEOBJUPDATETIME", "", 0, GameObjUpdateTime * 1000);
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

        private enum UDP_TABLE_CLASS
        {
            UDP_TABLE_BASIC,
            UDP_TABLE_OWNER_PID,
            UDP_TABLE_OWNER_MODULE
        }

        [DllImport("iphlpapi.dll", ExactSpelling = true, SetLastError = false, CallingConvention = CallingConvention.StdCall)]
        private static extern UInt32 GetExtendedUdpTable(IntPtr pUdpTable, ref UInt32 pdwSize, Int32 bOrder, UInt32 ulAf, UDP_TABLE_CLASS TableClass, UInt32 Reserved);
    }   
}


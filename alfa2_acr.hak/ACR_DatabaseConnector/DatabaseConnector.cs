using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using Microsoft.Win32.SafeHandles;

using ALFA.Shared;

namespace ACR_DatabaseConnector
{
    /// <summary>
    /// This class handles secure database transport connection management.  In
    /// this implementation, a PLINK.EXE process is created and monitored for
    /// the SSH port forward used to access the central MySQL database server.
    /// </summary>
    class DatabaseConnector
    {

        /// <summary>
        /// Create a new DatabaseConnector object, which manages the secure
        /// tunnel to the database.  If the tunnel is not enabled, then the
        /// object does nothing and returns immediately, otherwise, the tunnel
        /// process is started (and monitored and restarted in the event of a
        /// connection failure).  In this case, the game server has two minutes
        /// to successfully connect to the tunnel or else the server process
        /// will be exited, because a game server does not function without a
        /// database being present during startup.
        /// 
        /// During the wait for the database to come online, the logger queue
        /// is periodically written out by this module as the
        /// ACR_ServerCommunicator (which normally assumes responsibility for
        /// flushing the logger queue to the server log file) has not yet been
        /// initialized.
        /// </summary>
        /// <param name="Script">Supplies a script object used to access the
        /// NWScript API.</param>
        public DatabaseConnector(CLRScriptFramework.CLRScriptBase Script)
        {
            SafeWaitHandle Job;
            int Timeouts;

            //
            // If the secure tunnel is not managed by this module, then return
            // without setting anything up.
            //

            if (String.IsNullOrEmpty(GetTunnelProcessCmdLine()))
            {
                Logger.Log("DatabaseConnector.DatabaseConnector: Not using secure tunnel process as <NWNX4-Install-Path>\\DatabaseConnector.ini, [Settings], CommandLine is not set.");
                Logger.FlushLogMessages(Script);
                return;
            }

            //
            // Create a job object and appropriately configure it.
            //

            Job = CreateJob();

            ConfigureJob(Job);

            JobObject = Job;

            //
            // Extract PLINK.EXE and store it to disk so that it may be used to
            // launch the secure tunnel.
            //

            PlinkFilePath = ExtractResource("PLINK.EXE", ModuleLinkage.KnownResources["SGTatham_Plink"]);

            //
            // Start the monitor thread for the PLINK.EXE process.  This will
            // also create the secure tunnel for the database connection.
            //

            MonitorThread = new Thread(DatabaseConnectionMonitorThread);
            MonitorThread.Start();

            //
            // Give the monitor two minutes to establish a secure tunnel and
            // for the MySQL client library to successfully execute one SQL
            // query before allowing the server to proceed.
            //

            Logger.Log("DatabaseConnector.DatabaseConnector: Waiting two minutes for database connection to come online...");

            Timeouts = 120;

            while (InitCompletedEvent.WaitOne(1000) == false)
            {
                Logger.FlushLogMessages(Script);

                Timeouts -= 1;
                if (Timeouts == 0)
                {
                    break;
                }
            }

            //
            // Create a database connection and wait for a SQL query to
            // complete successfully before allowing the server to proceed with
            // initialization.
            //
            // Note that this must be a query that succeeds even if the
            // database schema has not yet been initialized.  The old-style get
            // server address from database routine queries a built-in table.
            //

            ALFA.Database Database = new ALFA.Database(Script);

            while (Timeouts != 0)
            {
                Logger.FlushLogMessages(Script);

                if (String.IsNullOrEmpty(Database.ACR_GetServerAddressFromDatabase()))
                {
                    Thread.Sleep(1000);
                    Timeouts -= 1;
                    continue;
                }

                break;
            }

            if (Timeouts == 0)
            {
                throw new ApplicationException("Database connection did not start successfully in two minutes, exiting the server process.  Check that DatabaseConnector.ini is correctly configured, that the public key for the ALFA central server matches the PuTTY registry on this machine, and that the network is online and connectivity to the ALFA central server is functional.");
            }

            //
            // Fall through to allow the server to complete normal
            // initialization.  If a database connectivity break is encountered
            // then the monitor thread will attempt to reconnect.
            //
        }

        /// <summary>
        /// The thread procedure for the thread that monitors the PLINK.EXE
        /// instance that provides a secure SSH port forward to the MySQL
        /// database.  Initially, it creates a PLINK.EXE process, and from
        /// that point it ensures that if the PLINK.EXE process closes, that a
        /// new process is started to connect out to the database automatically
        /// in the event of a temporary connectivity interruption.
        /// </summary>
        private void DatabaseConnectionMonitorThread()
        {
            int Timeout = 1000;

            for (;;)
            {
                uint StartTick;

                try
                {
                    Process TunnelProcess;
                    string CmdLine = GetTunnelProcessCmdLine();

                    TunnelProcess = CreateProcessInJob(PlinkFilePath, CmdLine, JobObject);

                    try
                    {
                        TunnelProcess.WaitForInputIdle(20000);
                    }
                    catch (System.InvalidOperationException)
                    {
                        //
                        // Process wasn't a GUI app, don't bother waiting.
                        //
                    }
                    catch
                    {
                        try
                        {
                            TunnelProcess.Kill();
                        }
                        catch
                        {
                        }

                        throw;
                    }

                    InitCompletedEvent.Set();

                    StartTick = (uint)Environment.TickCount;

                    TunnelProcess.WaitForExit();

                    //
                    // Clear the reconnect timeout to the minimum value if the
                    // process appeared to start successfully and stay online
                    // for more than 30 seconds.
                    //

                    if ((uint)Environment.TickCount - StartTick > 30000)
                    {
                        Timeout = 1000;
                    }
                    else
                    {
                        if (Timeout < 32000)
                        {
                            Timeout *= 2;
                        }
                    }
                }
                catch (Exception e)
                {
                    Logger.Log("DatabaseConnector.DatabaseConnectionMonitorThread: Exception managing database secure tunnel: {0}", e);

                    if (Timeout < 32000)
                    {
                        Timeout *= 2;
                    }
                }

                //
                // Wait for a truncated expontential backoff before trying
                // again.
                //

                Logger.Log("DatabaseConnector.DatabaseConnectionMonitorThread: Database secure tunnel closed, attempting reconnect in {0} milliseconds.", Timeout);

                Thread.Sleep(Timeout);
            }
        }

        /// <summary>
        /// Extract a resource to disk.
        /// </summary>
        /// <param name="FileName">Supplies a file name of the resource to
        /// extract (the base name only, i.e. PLINK.EXE).</param>
        /// <param name="ResourceData">Supplies the data to write to disk.
        /// </param>
        /// <returns>The fully qualified path to the extracted resource.
        /// </returns>
        private static string ExtractResource(string FileName, byte[] ResourceData)
        {
            string TempPath = Path.GetTempPath() + "NWN2ACR";

            if (!Directory.Exists(TempPath))
                Directory.CreateDirectory(TempPath);

            string ResPath = TempPath + Path.DirectorySeparatorChar + FileName;

            File.WriteAllBytes(ResPath, ResourceData);
            return ResPath;
        }

        /// <summary>
        /// Create a job object.
        /// </summary>
        /// <returns>A SafeWaitHandle describing the job object.</returns>
        private static SafeWaitHandle CreateJob()
        {
            IntPtr JobObjectHandle = CreateJobObject(IntPtr.Zero, IntPtr.Zero);

            if (JobObjectHandle == IntPtr.Zero)
                throw new ApplicationException("CreateJobObject failed: " + Marshal.GetLastWin32Error());

            try
            {
                return new SafeWaitHandle(JobObjectHandle, true);
            }
            catch
            {
                CloseHandle(JobObjectHandle);
                throw;
            }
        }

        /// <summary>
        /// Configure a job object for use by the database connector.  It is
        /// set up so that once the last job handle lapses, all of the
        /// processes joined to the job are terminated.
        /// </summary>
        /// <param name="Job">Supplies a job object handle.</param>
        private static void ConfigureJob(SafeWaitHandle Job)
        {
            JOBOBJECT_EXTENDED_LIMIT_INFORMATION ExtendedLimit;

            ExtendedLimit.BasicLimitInformation.PerProcessUserTimeLimit = 0;
            ExtendedLimit.BasicLimitInformation.PerJobUserTimeLimit = 0;
            ExtendedLimit.BasicLimitInformation.LimitFlags = 0;
            ExtendedLimit.BasicLimitInformation.MinimumWorkingSetSize = UIntPtr.Zero;
            ExtendedLimit.BasicLimitInformation.MaximumWorkingSetSize = UIntPtr.Zero;
            ExtendedLimit.BasicLimitInformation.ActiveProcessLimit = 0;
            ExtendedLimit.BasicLimitInformation.Affinity = UIntPtr.Zero;
            ExtendedLimit.BasicLimitInformation.PriorityClass = 0;
            ExtendedLimit.BasicLimitInformation.SchedulingClass = 0;
            ExtendedLimit.IoInfo.ReadOperationCount = 0;
            ExtendedLimit.IoInfo.WriteOperationCount = 0;
            ExtendedLimit.IoInfo.OtherOperationCount = 0;
            ExtendedLimit.IoInfo.ReadTransferCount = 0;
            ExtendedLimit.IoInfo.WriteTransferCount = 0;
            ExtendedLimit.IoInfo.OtherTransferCount = 0;
            ExtendedLimit.ProcessMemoryLimit = UIntPtr.Zero;
            ExtendedLimit.JobMemoryLimit = UIntPtr.Zero;
            ExtendedLimit.PeakProcessMemoryUsed = UIntPtr.Zero;
            ExtendedLimit.PeakJobMemoryUsed = UIntPtr.Zero;

            //
            // Set the job to terminate all contained processes on last handle
            // close (for the job itself), and to terminate all processes that
            // are in the job and which have an unhandled exception in lieu of
            // blocking them on the hard error dialog box.
            //

            ExtendedLimit.BasicLimitInformation.LimitFlags = JOBOBJECTLIMIT.KillOnJobClose | JOBOBJECTLIMIT.DieOnUnhandledException;

            int LimitSize = Marshal.SizeOf(ExtendedLimit);
            IntPtr JobInformation = Marshal.AllocHGlobal(LimitSize);

            try
            {
                Marshal.StructureToPtr(ExtendedLimit, JobInformation, false);

                if (SetInformationJobObject(Job.DangerousGetHandle(),
                    JOBOBJECTINFOCLASS.ExtendedLimitInformation,
                    JobInformation,
                    (uint)LimitSize) == 0)
                {
                    throw new ApplicationException("SetInformationJobObject failed: " + Marshal.GetLastWin32Error());
                }
            }
            finally
            {
                Marshal.FreeHGlobal(JobInformation);
            }
        }

        /// <summary>
        /// Create a process and attach it to a job.  The process is resumed
        /// by the time the call returns if the call was successful.
        /// </summary>
        /// <param name="ExeFileName">Supplies the fully qualified exe file
        /// name of the main process image.</param>
        /// <param name="CommandLine">Supplies command line arguments that do
        /// not include the implicit exe file name argument.</param>
        /// <param name="Job">Supplies a job handle.</param>
        /// <returns>A System.Diagnostics.Process describing the created
        /// process object.</returns>
        private static Process CreateProcessInJob(string ExeFileName, string CommandLine, SafeWaitHandle Job)
        {
            PROCESS_INFORMATION ProcessInfo;
            STARTUPINFO StartupInfo;
            bool Succeeded = false;

            ProcessInfo.hProcess = IntPtr.Zero;
            ProcessInfo.hThread = IntPtr.Zero;

            StartupInfo.cb = 0;
            StartupInfo.lpReserved = null;
            StartupInfo.lpDesktop = null;
            StartupInfo.lpTitle = null;
            StartupInfo.dwX = 0;
            StartupInfo.dwY = 0;
            StartupInfo.dwXSize = 0;
            StartupInfo.dwYSize = 0;
            StartupInfo.dwXCountChars = 0;
            StartupInfo.dwYCountChars = 0;
            StartupInfo.dwFillAttribute = 0;
            StartupInfo.dwFlags = (UInt32)STARTFLAGS.UseShowWindow;
            StartupInfo.wShowWindow = (UInt16)SHOWCMD.SW_HIDE;
            StartupInfo.cbReserved2 = 0;
            StartupInfo.lpReserved2 = IntPtr.Zero;
            StartupInfo.hStdInput = IntPtr.Zero;
            StartupInfo.hStdOutput = IntPtr.Zero;
            StartupInfo.hStdError = IntPtr.Zero;

            StartupInfo.cb = Marshal.SizeOf(StartupInfo);

            try
            {
                string RealCommandLine = String.Format("\"{0}\" {1}", ExeFileName, CommandLine);

                //
                // Create the process.
                //

                if (CreateProcessA(ExeFileName,
                    CommandLine,
                    IntPtr.Zero,
                    IntPtr.Zero,
                    0,
                    PROCESSCREATIONFLAGS.CreateSuspended,
                    IntPtr.Zero,
                    null,
                    ref StartupInfo,
                    out ProcessInfo) == 0)
                {
                    ProcessInfo.hProcess = IntPtr.Zero;
                    ProcessInfo.hThread = IntPtr.Zero;

                    throw new ApplicationException(String.Format("CreateProcessA(ExeFileName = '{0}', CommandLine = '{1}') failed: {2}",
                        ExeFileName,
                        CommandLine,
                        Marshal.GetLastWin32Error()));
                }

                //
                // Join it to the job so that it will be cleaned up if the
                // nwn2server process exits unexpectedly.
                //

                if (AssignProcessToJobObject(Job.DangerousGetHandle(), ProcessInfo.hProcess) == 0)
                    throw new ApplicationException("AssignProcessToJobObject failed: " + Marshal.GetLastWin32Error());

                //
                // Attach a Process object to the process by ID.   Since a
                // handle to the process is currently open, the process ID is
                // guaranteed to not be recycled in this interval.  The .NET
                // Process object will be used to wait on the process to exit
                // in the monitor thread.
                //

                Process ProcessObject = Process.GetProcessById((int)ProcessInfo.dwProcessId);

                //
                // Finally, resume the thread and call it done.
                //

                if (ResumeThread(ProcessInfo.hThread) == UInt32.MaxValue)
                    throw new ApplicationException("ResumeThread failed: " + Marshal.GetLastWin32Error());

                Succeeded = true;
                return ProcessObject;
            }
            finally
            {
                if (ProcessInfo.hProcess != IntPtr.Zero)
                {
                    if (!Succeeded)
                        TerminateProcess(ProcessInfo.hProcess, 0);

                    CloseHandle(ProcessInfo.hProcess);
                    ProcessInfo.hProcess = IntPtr.Zero;
                }

                if (ProcessInfo.hThread != IntPtr.Zero)
                {
                    CloseHandle(ProcessInfo.hThread);
                    ProcessInfo.hThread = IntPtr.Zero;
                }
            }
        }

        /// <summary>
        /// Get the command line used to launch the secure tunnel manager
        /// process (i.e., PLINK.EXE).
        /// </summary>
        /// <returns>The tunnel process command line.</returns>
        private static string GetTunnelProcessCmdLine()
        {
            return ALFA.SystemInfo.GetNWNX4IniString("DatabaseConnector.ini", "Settings", "CommandLine", "");
        }

        /// <summary>
        /// P/Invoke wrapper for CreateJobObject.
        /// </summary>
        /// <param name="lpJobAttributes">Supplies security attributes.</param>
        /// <param name="lpName">Supplies a job object name.</param>
        /// <returns>A job object handle on success, else IntPtr.Zero on
        /// failure.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern IntPtr CreateJobObject(IntPtr lpJobAttributes, IntPtr lpName);

        /// <summary>
        /// P/Invoke wrapper for CloseHandle.
        /// </summary>
        /// <param name="hObject">Supplies the handle to close.</param>
        /// <returns>True on success.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern int CloseHandle(IntPtr hObject);

        /// <summary>
        /// P/Invoke wrapper for AssignProcessToJobObject.
        /// </summary>
        /// <param name="hJob">Supplies a job handle.</param>
        /// <param name="hProcess">Supplies a process to assign to the
        /// job.</param>
        /// <returns>True on success.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern int AssignProcessToJobObject(IntPtr hJob, IntPtr hProcess);

        /// <summary>
        /// P/Invoke type for SetInformationJobObject.
        /// </summary>
        private enum JOBOBJECTINFOCLASS
        {
            ExtendedLimitInformation = 9,
        }

        /// <summary>
        /// P/Invoke type for SetInformationJobObject.
        /// </summary>
        [Flags]
        private enum JOBOBJECTLIMIT : uint
        {
            //
            // Basic Limits
            //

            Workingset = 0x00000001,
            ProcessTime = 0x00000002,
            JobTime = 0x00000004,
            ActiveProcess = 0x00000008,
            Affinity = 0x00000010,
            PriorityClass = 0x00000020,
            PreserveJobTime = 0x00000040,
            SchedulingClass = 0x00000080,

            //
            // Extended Limits
            //

            ProcessMemory = 0x00000100,
            JobMemory = 0x00000200,
            DieOnUnhandledException = 0x00000400,
            BreakawayOk = 0x00000800,
            SilentBreakawayOk = 0x00001000,
            KillOnJobClose = 0x00002000,
            SubsetAffinity = 0x00004000,

            //
            // Notification Limits
            //

            JobReadBytes = 0x00010000,
            JobWriteBytes = 0x00020000,
            RateControl = 0x00040000,
        }

        /// <summary>
        /// P/Invoke type for SetInformationJobObject.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct JOBOBJECT_BASIC_LIMIT_INFORMATION
        {
            public Int64 PerProcessUserTimeLimit;
            public Int64 PerJobUserTimeLimit;
            public JOBOBJECTLIMIT LimitFlags;
            public UIntPtr MinimumWorkingSetSize;
            public UIntPtr MaximumWorkingSetSize;
            public UInt32 ActiveProcessLimit;
            public UIntPtr Affinity;
            public UInt32 PriorityClass;
            public UInt32 SchedulingClass;
        }

        /// <summary>
        /// P/Invoke type for SetInformationJobObject.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct IO_COUNTERS
        {
            public UInt64 ReadOperationCount;
            public UInt64 WriteOperationCount;
            public UInt64 OtherOperationCount;
            public UInt64 ReadTransferCount;
            public UInt64 WriteTransferCount;
            public UInt64 OtherTransferCount;
        }

        /// <summary>
        /// P/Invoke type for SetInformationJobObject.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct JOBOBJECT_EXTENDED_LIMIT_INFORMATION
        {
            public JOBOBJECT_BASIC_LIMIT_INFORMATION BasicLimitInformation;
            public IO_COUNTERS IoInfo;
            public UIntPtr ProcessMemoryLimit;
            public UIntPtr JobMemoryLimit;
            public UIntPtr PeakProcessMemoryUsed;
            public UIntPtr PeakJobMemoryUsed;
        }

        /// <summary>
        /// P/Invoke wrapper for SetInformationJobObject.
        /// </summary>
        /// <param name="hJob">Supplies a job handle.</param>
        /// <param name="JobObjectInfoClass">Supplies a job information class
        /// to set.</param>
        /// <param name="lpJobObjectInfo">Supplies job information to set.
        /// </param>
        /// <param name="cbJobObjectInfoLength">Supplies the length, in bytes,
        /// of the job information to set.</param>
        /// <returns>True on success.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern int SetInformationJobObject(IntPtr hJob,
           JOBOBJECTINFOCLASS JobObjectInfoClass, IntPtr lpJobObjectInfo,
           uint cbJobObjectInfoLength);


        /// <summary>
        /// P/Invoke wrapper for ResumeThread.
        /// </summary>
        /// <param name="hThread">Supplies a thread handle.</param>
        /// <returns>True on success.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern uint ResumeThread(IntPtr hThread);

        /// <summary>
        /// P/Invoke wrapper for TerminateProcess.
        /// </summary>
        /// <param name="hProcess">Supplies a handle to the process to
        /// terminate.</param>
        /// <param name="uExitCode">Supplies the exit code of the
        /// process.</param>
        /// <returns>True on success.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
        private static extern int TerminateProcess(IntPtr hProcess, uint uExitCode);



        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        private struct STARTUPINFO
        {
            public Int32 cb;
            public string lpReserved;
            public string lpDesktop;
            public string lpTitle;
            public UInt32 dwX;
            public UInt32 dwY;
            public UInt32 dwXSize;
            public UInt32 dwYSize;
            public UInt32 dwXCountChars;
            public UInt32 dwYCountChars;
            public UInt32 dwFillAttribute;
            public UInt32 dwFlags;
            public UInt16 wShowWindow;
            public UInt16 cbReserved2;
            public IntPtr lpReserved2;
            public IntPtr hStdInput;
            public IntPtr hStdOutput;
            public IntPtr hStdError;
        }

        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct PROCESS_INFORMATION
        {
            public IntPtr hProcess;
            public IntPtr hThread;
            public UInt32 dwProcessId;
            public UInt32 dwThreadId;
        }

        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        [StructLayout(LayoutKind.Sequential)]
        private struct SECURITY_ATTRIBUTES
        {
            public int nLength;
            public IntPtr lpSecurityDescriptor;
            public int bInheritHandle;
        }

        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        [Flags]
        private enum PROCESSCREATIONFLAGS : uint
        {
            CreateSuspended = 0x00000004,
            CreateNoWindow = 0x08000000,
        }

        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        [Flags]
        private enum STARTFLAGS : uint
        {
            UseShowWindow = 0x00000001,
        }

        /// <summary>
        /// P/Invoke type for CreateProcessA.
        /// </summary>
        private enum SHOWCMD : ushort
        {
            SW_HIDE = 0,
        }

        /// <summary>
        /// P/Invoke wrapper for CreateProcessA.  (ANSI version explicitly used
        /// because Unicode verison may write to lpCommandLine.)
        /// </summary>
        /// <param name="lpApplicationName">Supplies the app name.</param>
        /// <param name="lpCommandLine">Supplies the command line.</param>
        /// <param name="lpProcessAttributes">Supplies process
        /// attributes.</param>
        /// <param name="lpThreadAttributes">Supplies thread
        /// attributes.</param>
        /// <param name="bInheritHandles">Supplies true if handles are to be
        /// inherited to the new process.</param>
        /// <param name="dwCreationFlags">Supplies creation flags.</param>
        /// <param name="lpEnvironment">Supplies a pointer to an environment
        /// block to transfer to the new process.</param>
        /// <param name="lpCurrentDirectory">Supplies a current directory for
        /// the new process.</param>
        /// <param name="lpStartupInfo">Supplies startup parameters.</param>
        /// <param name="lpProcessInformation">Receives basic information
        /// about the created process and initial thread.</param>
        /// <returns>True on succes.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, CharSet = CharSet.Ansi, SetLastError = true)]
        private static extern int CreateProcessA(string lpApplicationName,
           string lpCommandLine, IntPtr lpProcessAttributes,
           IntPtr lpThreadAttributes, int bInheritHandles,
           PROCESSCREATIONFLAGS dwCreationFlags, IntPtr lpEnvironment, string lpCurrentDirectory,
           [In] ref STARTUPINFO lpStartupInfo,
           out PROCESS_INFORMATION lpProcessInformation);

        /// <summary>
        /// P/Invoke wrapper for GetCurrentProcess.
        /// </summary>
        /// <returns>A pseudohandle for the current process.</returns>
        [DllImport("kernel32.dll", CallingConvention = CallingConvention.Winapi, SetLastError = false)]
        private static extern IntPtr GetCurrentProcess();

        /// <summary>
        /// The underlying job object used to track PLINK.EXE instances.  It is
        /// used to ensure that when the NWN2SERVER.EXE process is terminated,
        /// that when the last handle (within the NWN2SERVER.EXE handle table)
        /// to the job object is closed, all of the PLINK.EXE processes are
        /// cleaned up appropriately.
        /// </summary>
        private SafeWaitHandle JobObject = null;

        /// <summary>
        /// The thread object that monitors the PLINK.EXE process.
        /// </summary>
        private Thread MonitorThread = null;

        /// <summary>
        /// A file path to the extracted PLINK.EXE file that should be created
        /// as a new process.
        /// </summary>
        private string PlinkFilePath = null;

        /// <summary>
        /// An event that is set when 
        /// </summary>
        private ManualResetEvent InitCompletedEvent = new ManualResetEvent(false);
    }
}

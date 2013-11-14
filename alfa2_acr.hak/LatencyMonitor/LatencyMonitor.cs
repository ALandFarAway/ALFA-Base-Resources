//
// This script monitors the response time of the server and provides that
// information to the latency response script.
//
// Server latency can be retrieved by several ways:
//
// 1) GetGlobalInt("ACR_SERVER_LATENCY") returns the current measurement.
//
// 2) Create a script with an entrypoint signature of:
//
//    void main(int CurrentLatency);
//
//    ... and register it via SetGlobalString("ACR_SERVER_LATENCY_SCRIPT", "module_on_latency_script");
//
//    This script is called every MEASUREMENT_INTERVAL with the current latency
//    measurement.
//
//    The latency script may be changed and will take effect on the next
//    update cycle.
//
// In both cases, the latency measurement is the count of milliseconds that the
// server takes to process a local network message.  A high latency value may
// indicate that the server is bogged down in processign.
//
// A latency value of -1 indicates that the last latency measurement did not
// succeed.  For example, the server may have taken an excessively long time,
// greater than MAX_PING, to respond.
//
// Similarly, the plugin periodically reports the status of the server vault
// health via the "ACR_VAULT_LATENCY" global int.  The latency can be retrieved
// via calling GetGlobalInt("ACR_VAULT_LATENCY").
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
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Threading;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace LatencyMonitor
{
    public partial class LatencyMonitor : CLRScriptBase, IGeneratedScriptProgram
    {

        public LatencyMonitor([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private LatencyMonitor([In] LatencyMonitor Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            if (LatencyMeasurementThread != null)
                return DefaultReturnCode;

            InitializeLatencyMonitor();

            return DefaultReturnCode;
        }

        private void InitializeLatencyMonitor()
        {
            try
            {
                ServerUdpListener = SystemInfo.GetServerUdpListener(this);
            }
            catch (Exception)
            {
                WriteTimestampedLogEntry("LatencyMonitor.InitializeLatencyMonitor(): Failed to query server data port, retrying in 10 minutes.");
                DelayCommand(600.0f, delegate() { InitializeLatencyMonitor(); });
                return;
            }

            //
            // Create a dummy object so that we may block on its SyncBlock.
            // This object forms the lock for CurrentLatency, which we cannot
            // directly use as boxing a new object would result in a new
            // SyncBlock for every lock attempt.
            //

            CurrentLatencyLock = new int();

            //
            // Create the new UDP socket.  This has to be done AFTER we get the
            // UDP listener, for the get UDP listener code to work, as it finds
            // the first UDP socket opened by nwn2server.
            //

            UdpSocket = new UdpClient(AddressFamily.InterNetwork);

            //
            // Set the default address to point to the server's local UDP
            // listener.
            //

            UdpSocket.Connect(ServerUdpListener);

            ALFA.Database Database = new ALFA.Database(this);

            LocalServerId = Database.ACR_GetServerID();

            //
            // Start the latency measurement thread and the vault ping thread.
            //

            LatencyMeasurementThread = new Thread(LatencyMeasurementThreadRoutine);
            LatencyMeasurementThread.Start();
            VaultPingThread = new Thread(VaultPingThreadRoutine);
            VaultPingThread.Start();

            PollServerLatency();

            WriteTimestampedLogEntry(String.Format("LatencyMonitor.InitializeLatencyMonitor(): Latency monitoring initialized on data port {0}.", ServerUdpListener));
        }

        /// <summary>
        /// This method runs periodically and updates the current server
        /// latency measurement (as reported by the measurement thread).
        /// </summary>
        private void PollServerLatency()
        {
            int Latency;
            int VaultLatency;
            string LatencyScript;

            //
            // Snap the current latency.
            //

            lock (CurrentLatencyLock)
            {
                Latency = CurrentLatency;
                VaultLatency = CurrentVaultLatency;
            }

            //
            // Save the latency away as the ACR_SERVER_LATENCY global variable.
            //

            SetGlobalInt("ACR_SERVER_LATENCY", Latency);
            SetGlobalInt("ACR_VAULT_LATENCY", VaultLatency);

            //
            // If we have a script configured to run on each latency
            // measurement, then start the script.
            //

            LatencyScript = GetGlobalString("ACR_SERVER_LATENCY_SCRIPT");

            if (!String.IsNullOrEmpty(LatencyScript))
            {
                ClearScriptParams();
                AddScriptParameterInt(Latency);
                ExecuteScriptEnhanced(LatencyScript, OBJECT_SELF, TRUE);
            }

            //
            // Start the next continuation going.
            //

            DelayCommand((float)MEASUREMENT_INTERVAL / 1000, delegate() { PollServerLatency(); });
        }

        /// <summary>
        /// This thread function measures server latency every
        /// MEASUREMENT_INTERVAL milliseconds.
        /// 
        /// Note that, because this function does not execute from a script
        /// context, it cannot call script functions.  Instead, a companion
        /// DelayCommand continuation on the main server thread will check the
        /// current latency value and save it as appropriate.
        /// </summary>
        private static void LatencyMeasurementThreadRoutine()
        {
            byte[] PingMessage = { (byte)'B', (byte)'N', (byte)'L', (byte)'M', 0, 0, 0, 0, 0, 0, 0 };
            byte[] Response;
            IPEndPoint SourceEndpoint = new IPEndPoint(0, 0);

            for (; ; )
            {
                //
                // Flush the socket receive queue.
                //

                UdpSocket.Client.ReceiveTimeout = 1;

                try
                {
                    for (;;)
                    {
                        UdpSocket.Receive(ref SourceEndpoint);
                    }
                }
                catch
                {
                
                }

                //
                // Now send a ping message and wait for a response or timeout.
                //

                UdpSocket.Client.ReceiveTimeout = MAX_PING;

                try
                {
                    uint Tick = (uint)Environment.TickCount;

                    UdpSocket.Send(PingMessage, PingMessage.Length);
                    Response = UdpSocket.Receive(ref SourceEndpoint);

                    Tick = (uint)Environment.TickCount - Tick;

                    if (Response.Length < 4 || Response[0] != (byte)'B' || Response[1] != (byte)'N' || Response[2] != (byte)'L' || Response[3] != (byte)'R')
                        throw new ApplicationException("Invalid BNLM response message received.");

                    //
                    // Report the response time.
                    //

                    lock (CurrentLatencyLock)
                    {
                        CurrentLatency = (int)Tick;
                    }
                }
                catch
                {
                    //
                    // Report a response time of -1 to indicate that no
                    // measurement could be taken.
                    //

                    lock (CurrentLatencyLock)
                    {
                        CurrentLatency = (int)-1;
                    }
                }

                Thread.Sleep(MEASUREMENT_INTERVAL);
            }
        }

        /// <summary>
        /// This thread function measures vault latency every
        /// VAULT_MEASUREMENT_INTERVAL milliseconds.
        /// 
        /// Note that, because this function does not execute from a script
        /// context, it cannot call script functions.  Instead, a companion
        /// DelayCommand continuation on the main server thread will check the
        /// current latency value and save it as appropriate.
        /// </summary>
        private static void VaultPingThreadRoutine()
        {
            string VaultPingFile = String.Format(
                "{0}Server{1}.txt",
                SystemInfo.GetCentralVaultPath(),
                LocalServerId);

            for (; ; )
            {
                //
                // Open the ping file on the vault.  If we fail to open it then
                // something has gone wrong with the vault connection.
                //

                try
                {
                    uint Tick = (uint)Environment.TickCount;

                    using (StreamWriter PingFile = File.CreateText(VaultPingFile))
                    {
                        PingFile.WriteLine(
                            "Server {0} is up at {1}.",
                            LocalServerId,
                            DateTime.UtcNow);
                    }

                    Tick = (uint)Environment.TickCount - Tick;

                    //
                    // Report the response time.
                    //

                    lock (CurrentLatencyLock)
                    {
                        CurrentVaultLatency = (int)Tick;
                    }
                }
                catch
                {
                    //
                    // Report a response time of -1 to indicate that no
                    // measurement could be taken.
                    //

                    lock (CurrentLatencyLock)
                    {
                        CurrentVaultLatency = (int)-1;
                    }
                }

                Thread.Sleep(VAULT_MEASUREMENT_INTERVAL);
            }
        }


        /// <summary>
        /// The maximum latency that we'll wait for a ping reply is set by this
        /// constant.
        /// </summary>
        private const int MAX_PING = 2000;

        /// <summary>
        /// The interval (in milliseconds) that we'll measure server latency is
        /// set here.
        /// </summary>
        private const int MEASUREMENT_INTERVAL = 1000;

        /// <summary>
        /// The interval (in milliseconds) that we'll measure vault latency is
        /// set here.
        /// </summary>
        private const int VAULT_MEASUREMENT_INTERVAL = 60000;

        /// <summary>
        /// This endpoint represents the server UDP listener socket.
        /// </summary>
        private static IPEndPoint ServerUdpListener;

        /// <summary>
        /// This UDP client manages server latency measurements.
        /// </summary>
        private static UdpClient UdpSocket;

        /// <summary>
        /// This thread periodically polls the server for its response time to
        /// UDP pings.
        /// </summary>
        private static Thread LatencyMeasurementThread;

        /// <summary>
        /// This thread periodically pings the vault to determine if the vault
        /// connection is healthy.
        /// </summary>
        private static Thread VaultPingThread;

        /// <summary>
        /// This value represents the current server latency.  The value must
        /// be accessed under CurrentLatencyLock.
        /// </summary>
        private static int CurrentLatency;

        /// <summary>
        /// This value represents the current vault latency.  The value must be
        /// accessed under CurrentLatencyLock.
        /// </summary>
        private static int CurrentVaultLatency;

        /// <summary>
        /// This value is the lock for the CurrentLatency member.
        /// </summary>
        private static object CurrentLatencyLock;

        /// <summary>
        /// This value is the server id of the local server.
        /// </summary>
        private static int LocalServerId;
    }
}

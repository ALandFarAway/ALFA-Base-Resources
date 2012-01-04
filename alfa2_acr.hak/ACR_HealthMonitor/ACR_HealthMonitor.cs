//
// This script monitors the health of the server, updating the database on
// health changes as well as taking remedial actions.
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

namespace ACR_HealthMonitor
{
    public partial class ACR_HealthMonitor : CLRScriptBase, IGeneratedScriptProgram
    {

        public ACR_HealthMonitor([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
            Database = new ALFA.Database(this);
        }

        private ACR_HealthMonitor([In] ACR_HealthMonitor Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes = { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int CurrentLatency = (int) ScriptParameters[0];

            if (FirstRun)
            {
                FirstRun = false;
                Database.ACR_SetPersistentInt(GetModule(), "ACR_HEALTHMONITOR_STATUS", (int)HealthStatus);

                LatencyMeasurements.AddRange(new int[LATENCY_MEASUREMENTS_TO_RECORD]);
            }

            //
            // Record the current latency measurement value.  If we have a full
            // set of history, the process this batch of historical data.
            //

            if (MeasurementIndex == LATENCY_MEASUREMENTS_TO_RECORD)
            {
                MeasurementIndex = 0;
                ProcessMeasuredLatency();
            }

            // WriteTimestampedLogEntry(String.Format("LatencyMeasurements[{0}] = {1}", MeasurementIndex, CurrentLatency));

            //
            // Consider measurement failures as high latency.  Usually these
            // are due to the measurement timing out entirely (2000ms+) anyway.
            //

            if (CurrentLatency == -1)
                CurrentLatency = LATENCY_HIGH_VALUE;

            LatencyMeasurements[MeasurementIndex++] = CurrentLatency;

            return DefaultReturnCode;
        }

        /// <summary>
        /// This method is called when we have a batch of latency measurements
        /// available.  Its purpose is to determine the current server health
        /// status, schedule a database update, and perform adjustment actions
        /// as necessary.
        /// </summary>
        private void ProcessMeasuredLatency()
        {
            LATENCY_HEALTH_STATUS NewStatus;
            int MedianLatency;
            uint ModuleObject = GetModule();

            //
            // Find the median latency for the past several measurements and
            // set the health status of the server based on that.
            //

            LatencyMeasurements.Sort();

            MedianLatency = LatencyMeasurements[LATENCY_MEASUREMENTS_TO_RECORD / 2];

            if (MedianLatency < LATENCY_LOW_VALUE)
                NewStatus = LATENCY_HEALTH_STATUS.Healthy;
            else if (MedianLatency < LATENCY_HIGH_VALUE)
                NewStatus = LATENCY_HEALTH_STATUS.Warning;
            else
                NewStatus = LATENCY_HEALTH_STATUS.Unhealthy;

            //
            // Log a message and update the database if the health status has
            // changed.
            //

            if (HealthStatus != NewStatus)
            {
                WriteTimestampedLogEntry(String.Format("ACR_HealthMonitor.ProcessMeasuredLatency(): Server health status is now {0} (median latency {1})", NewStatus, MedianLatency));
                Database.ACR_SetPersistentInt(ModuleObject, "ACR_HEALTHMONITOR_STATUS", (int)NewStatus);

                HealthStatus = NewStatus;

                //
                // Attempt to record some useful data about what is happening
                // on the server when we transition to the unhealthy state.
                //

                if (HealthStatus == LATENCY_HEALTH_STATUS.Unhealthy)
                    DiagnoseServerHealth();
            }

            //
            // If backoff for the GameObjUpdate time is enabled, then try and
            // adjust module performance.
            //

            if (GetLocalInt(ModuleObject, "ACR_HEALTHMONITOR_GAMEOBJUPDATE_BACKOFF") != FALSE)
            {
                int GameObjUpdateTime = SystemInfo.GetGameObjUpdateTime(this);
                bool SetTime = false;

                switch (HealthStatus)
                {

                    case LATENCY_HEALTH_STATUS.Healthy:
                        //
                        // If we are healthy, then keep adjusting the update
                        // time downwards until we hit the default value.  This
                        // trades performance for responsiveness.
                        //

                        if (GameObjUpdateTime != SystemInfo.DEFAULT_GAMEOBJUPDATE_TIME)
                        {
                            SetTime = true;
                            GameObjUpdateTime -= GAMEOBJUPDATE_ADJUSTMENT;
                        }
                        break;

                    case LATENCY_HEALTH_STATUS.Warning:
                        //
                        // Don't take any action if we are in the warning
                        // state; instead, keep the current update time where
                        // it is right now, to help avoid thrashing.
                        //

                        break;

                    case LATENCY_HEALTH_STATUS.Unhealthy:
                        //
                        // If we are unhealthy, then keep adjusting the update
                        // time upwards until we hit the maximum value.  This
                        // trades responsiveness for performance.
                        //

                        if (GameObjUpdateTime != SystemInfo.MAX_RECOMMENDED_GAMEOBJUPDATE_TIME)
                        {
                            SetTime = true;
                            GameObjUpdateTime += GAMEOBJUPDATE_ADJUSTMENT;
                        }
                        break;

                }

                if (SetTime)
                {
                    WriteTimestampedLogEntry(String.Format("ACR_HealthMonitor.ProcessMeasuredLatency(): Adjusting GameObjUpdateTime to {1}...", GameObjUpdateTime));
                    SystemInfo.SetGameObjUpdateTime(this, GameObjUpdateTime);
                }
            }

        }

        /// <summary>
        /// This function is called to diagnose the health of the server when
        /// the server is performing poorly.  It records information about the
        /// server status to the log.
        /// </summary>
        private void DiagnoseServerHealth()
        {
            uint Tick = (uint)Environment.TickCount;

            //
            // Don't perform another diagnosis dump if we have recorded data
            // recently.  The diagnosis process may take a little bit of time
            // in and of itself and it may write a lot of data to the log, so
            // be careful to protect against it being continually run.
            //

            if (Tick - LastDiagnosisTick < DIAGNOSIS_MIN_TIME)
                return;

            LastDiagnosisTick = Tick;

            WriteTimestampedLogEntry("ACR_HealthMonitor.ProcessMeasuredLatency(): *** Health diagnosis begins ***");
            WriteTimestampedLogEntry("== Active players ==\n");

            foreach (uint PlayerObject in GetPlayers(true))
            {
                WriteTimestampedLogEntry(String.Format("- Player {0} ({1}) in {2}, InCombat {3}, IsDM {4}",
                    GetName(PlayerObject),
                    GetPCPlayerName(PlayerObject),
                    GetName(GetArea(PlayerObject)),
                    GetIsInCombat(PlayerObject),
                    GetIsDM(PlayerObject)));
            }

            WriteTimestampedLogEntry("\n\n== Active Areas ==\n");

            foreach (uint AreaObject in GetAreas())
            {
                int TotalObjects = 0;
                int CreatureObjects = 0;
                int PlaceableObjects = 0;
                int InCombatObjects = 0;
                int PlayerObjects = 0;
                int DMObjects = 0;
                int DynamicObjects = 0;
                int AIVeryLowObjects = 0;
                int AILowObjects = 0;
                int AINormalObjects = 0;
                int AIHighObjects = 0;
                int AIVeryHighObjects = 0;
                int NonIdleObjects = 0;

                foreach (uint ObjectId in GetObjectsInArea(AreaObject))
                {
                    TotalObjects += 1;

                    switch (GetObjectType(ObjectId))
                    {

                        case OBJECT_TYPE_CREATURE:
                            CreatureObjects += 1;

                            switch (GetAILevel(ObjectId))
                            {

                                case AI_LEVEL_VERY_LOW:
                                    AIVeryLowObjects += 1;
                                    break;

                                case AI_LEVEL_LOW:
                                    AILowObjects += 1;
                                    break;

                                case AI_LEVEL_NORMAL:
                                    AINormalObjects += 1;
                                    break;

                                case AI_LEVEL_HIGH:
                                    AIHighObjects += 1;
                                    break;

                                case AI_LEVEL_VERY_HIGH:
                                    AIVeryHighObjects += 1;
                                    break;


                            }

                            break;

                        case OBJECT_TYPE_PLACEABLE:
                            PlaceableObjects += 1;
                            break;

                    }

                    if (GetIsInCombat(ObjectId) != FALSE)
                        InCombatObjects += 1;
                    if (GetIsPC(ObjectId) != FALSE)
                        PlayerObjects += 1;
                    if (GetIsDM(ObjectId) != FALSE)
                        DMObjects += 1;
                    if (SystemInfo.IsDynamicObject(this, ObjectId))
                        DynamicObjects += 1;
                    if (GetCurrentAction(ObjectId) != ACTION_INVALID)
                        NonIdleObjects += 1;
                }

                WriteTimestampedLogEntry(String.Format("- Area {0} with {1} total objects, {2} creatures, {3} placeables, {4} in-combat objects, {5} players, {6} DMs, {7} dynamically created objects, {8} non-idle objects, {9} AI_LEVEL_VERY_LOW objects, {10} AI_LEVEL_LOW objects, {11} AI_LEVEL_NORMAL objects, {12} AI_LEVEL_HIGH objects, {13} AI_LEVEL_VERY_HIGH objects.",
                    GetName(GetArea(AreaObject)),
                    TotalObjects,
                    CreatureObjects,
                    PlaceableObjects,
                    InCombatObjects,
                    PlayerObjects,
                    DMObjects,
                    DynamicObjects,
                    NonIdleObjects,
                    AIVeryLowObjects,
                    AILowObjects,
                    AINormalObjects,
                    AIHighObjects,
                    AIVeryHighObjects));
            }

            WriteTimestampedLogEntry("ACR_HealthMonitor.ProcessMeasuredLatency(): *** Health diagnosis ends ***");
        }

        /// <summary>
        /// Latency values for the server are distilled down into a health
        /// status described by the following enumeration.
        /// </summary>
        private enum LATENCY_HEALTH_STATUS
        {
            Healthy,
            Warning,
            Unhealthy
        };

        /// <summary>
        /// Latencies below LATENCY_LOW_VALUE are considered low.
        /// </summary>
        private const int LATENCY_LOW_VALUE = 50;

        /// <summary>
        /// Latencies above LATENCY_HIGH_VALUE are considered high.
        /// </summary>
        private const int LATENCY_HIGH_VALUE = 200;

        /// <summary>
        /// Each time a GameObjUpdate auto-adjustment is made, it is done by
        /// this amount (in milliseconds).
        /// </summary>
        private const int GAMEOBJUPDATE_ADJUSTMENT = 200;

        /// <summary>
        /// The minimum time between server diagnosis attempts is set here.
        /// Even if the server thrashes between healthy and unhealthy, a
        /// diagnosis data dump will not occur more often than this many
        /// milliseconds.
        /// </summary>
        private const uint DIAGNOSIS_MIN_TIME = 5 * 60 * 1000;

        /// <summary>
        /// The current health (latency) status.
        /// </summary>
        private LATENCY_HEALTH_STATUS HealthStatus = LATENCY_HEALTH_STATUS.Healthy;

        /// <summary>
        /// The number of latency measurements to sample before taking action
        /// is recorded here.  Normally, latency is sampled every second.
        /// </summary>
        private const int LATENCY_MEASUREMENTS_TO_RECORD = 14;

        /// <summary>
        /// The current index into the latency array.
        /// </summary>
        private int MeasurementIndex = 0;

        /// <summary>
        /// If we are the first script run, this value is set to true.
        /// </summary>
        private bool FirstRun = true;

        /// <summary>
        /// The list of latency samples recorded so far.
        /// </summary>
        private List<int> LatencyMeasurements = new List<int>(LATENCY_MEASUREMENTS_TO_RECORD);

        /// <summary>
        /// The database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;

        /// <summary>
        /// The last time in which we did a server diagnosis is stored here.
        /// </summary>
        private uint LastDiagnosisTick = (uint)Environment.TickCount - DIAGNOSIS_MIN_TIME;
    }
}

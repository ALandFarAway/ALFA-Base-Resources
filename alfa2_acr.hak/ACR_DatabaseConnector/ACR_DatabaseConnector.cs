//
// This module contains logic for providing secure database transport
// connectivity services for the ACR system.
// 

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
using ALFA.Shared;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_DatabaseConnector
{
    public partial class ACR_DatabaseConnector : CLRScriptBase, IGeneratedScriptProgram
    {
        public ACR_DatabaseConnector([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_DatabaseConnector([In] ACR_DatabaseConnector Other)
        {
            InitScript(Other);

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(int) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            int Cmd = (int)ScriptParameters[0]; // ScriptParameterTypes[0] is typeof(int)

            switch (Cmd)
            {

                case ACR_DATABASE_CONNECTOR_INITIALIZE:
                    {
                        InitializeDatabaseConnector();
                        break;
                    }
            }

            return 0;
        }

        /// <summary>
        /// Initialize the database connector.
        /// </summary>
        private void InitializeDatabaseConnector()
        {
            if (Connector != null)
                return;

            //
            // Create a secure tunnel to the database and wait for it to finish
            // coming online (internal to the DatabaseConnector).  In the event
            // of any failure, log an error and exit the server process as the
            // server cannot successfully initialize without a database (to do
            // so will result in the server getting into a potentially invalid
            // state and needing a manual reset later anyway when it might have
            // been less obvious why systems did not work properly).
            //

            try
            {
                Connector = new DatabaseConnector(this);
            }
            catch (Exception e)
            {
                Logger.FlushLogMessages(this);
                WriteTimestampedLogEntry(String.Format("ACR_DatabaseConnector.InitializeDatabaseConnector: DatabaseConnector.DatabaseConnector raised exception '{0}'.", e));
                WriteTimestampedLogEntry("Shutting down the game server because the database is unavailable.");
                ALFA.SystemInfo.ShutdownGameServer(this);
            }

            Logger.FlushLogMessages(this);
        }

        private const int ACR_DATABASE_CONNECTOR_INITIALIZE = 0;
        private static DatabaseConnector Connector = null;
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This event encapsulates data relating to a run script event from a
    /// remote server (or external mechanism).
    /// </summary>
    class RunScriptEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new RunScriptEvent.
        /// </summary>
        /// <param name="SourceServer">Supplies the sender server, which may be
        /// may be null if the request was not sent by a server but external
        /// automation.</param>
        /// <param name="ScriptName">Supplies the name of the script.</param>
        /// <param name="ScriptArgument">Supplies an optional argument for the
        /// script main function.</param>
        public RunScriptEvent(GameServer SourceServer, string ScriptName, string ScriptArgument)
        {
            this.SourceServer = SourceServer;
            this.ScriptName = ScriptName;
            this.ScriptArgument = ScriptArgument;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            int SourceServerId = (SourceServer != null) ? SourceServer.ServerId : 0;

            Script.WriteTimestampedLogEntry(String.Format("RunScriptEvent.DispatchEvent: Executing script {0} ({1}) on request from {2}.",
                ScriptName,
                ScriptArgument,
                SourceServerId));
            Script.AddScriptParameterInt(SourceServerId);
            Script.AddScriptParameterString(ScriptArgument);
            Script.ExecuteScriptEnhanced(ScriptName, Script.GetModule(), CLRScriptBase.TRUE);
        }

        /// <summary>
        /// The source server.
        /// </summary>
        private GameServer SourceServer;

        /// <summary>
        /// The script name.
        /// </summary>
        private string ScriptName;

        /// <summary>
        /// The script argument;
        /// </summary>
        private string ScriptArgument;
    }
}

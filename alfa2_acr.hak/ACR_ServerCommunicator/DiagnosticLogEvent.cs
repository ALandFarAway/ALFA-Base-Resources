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
    /// This event encapsulates data relating to a diagnostic log message.
    /// </summary>
    class DiagnosticLogEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new DiagnosticLogEvent.
        /// </summary>
        /// <param name="Message">Supplies the log message.</param>
        public DiagnosticLogEvent(string Message)
        {
            this.Message = Message;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            Script.WriteTimestampedLogEntry("ACR_ServerCommunicator: " + Message);
        }

        /// <summary>
        /// The message text.
        /// </summary>
        private string Message;
    }
}

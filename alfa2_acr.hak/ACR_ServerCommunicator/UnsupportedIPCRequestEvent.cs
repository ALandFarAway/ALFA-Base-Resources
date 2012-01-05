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
    /// This event encapsulates data relating to an IPC request of an
    /// unsupported type received in the IPC queue.
    /// </summary>
    class UnsupportedIPCRequestEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new UnsupportedIPCRequestEvent.
        /// </summary>
        /// <param name="RecordId">Supplies the associated record ID.</param>
        /// <param name="P0">Supplies the P0 parameter.</param>
        /// <param name="P1">Supplies the P1 parameter.</param>
        /// <param name="P2">Supplies the P2 parameter.</param>
        /// <param name="EventType">Supplies the IPC event type.</param>
        /// <param name="P3">Supplies the P3 parameter.</param>
        public UnsupportedIPCRequestEvent(int RecordId, int P0, int P1, int P2, int EventType, string P3)
        {
            this.RecordId = RecordId;
            this.P0 = P0;
            this.P0 = P1;
            this.P2 = P2;
            this.EventType = EventType;
            this.P3 = P3;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(CLRScriptBase Script, ALFA.Database Database)
        {
            string FormattedMessage = String.Format(
                "ACR_ServerCommunicator: Received unsupported IPC event {0}: {1}.{2}.{3}.{4}.  Record ID was {5}.",
                EventType,
                P0,
                P1,
                P2,
                P3,
                RecordId);

            Script.WriteTimestampedLogEntry(FormattedMessage);
        }

        /// <summary>
        /// The database record id.
        /// </summary>
        private int RecordId;

        /// <summary>
        /// The first event-specific parameter.
        /// </summary>
        private int P0;

        /// <summary>
        /// The second event-specific parameter.
        /// </summary>
        private int P1;

        /// <summary>
        /// The third event-specific parameter.
        /// </summary>
        private int P2;

        /// <summary>
        /// The IPC event type code.
        /// </summary>
        private int EventType;

        /// <summary>
        /// The fourth event-specific parameter.
        /// </summary>
        private string P3;
    }
}

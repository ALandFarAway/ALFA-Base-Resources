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
    /// This event encapsulates data relating to a server that has come online.
    /// </summary>
    class ServerJoinEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new ServerJoinEvent.
        /// </summary>
        /// <param name="Server">Supplies the server.</param>
        public ServerJoinEvent(GameServer Server)
        {
            this.Server = Server;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            //
            // If the event was for the local server, then don't re-broadcast
            // it.
            //

            if (Database.ACR_GetServerID() == Server.ServerId)
                return;

            string Message = String.Format(
                "<c=yellow>Server {0} is now online.</c>",
                Server.Name);

            foreach (uint PlayerObject in Script.GetPlayers(true))
            {
                Script.SendChatMessage(
                    CLRScriptBase.OBJECT_INVALID,
                    PlayerObject,
                    CLRScriptBase.CHAT_MODE_SERVER,
                    Message,
                    CLRScriptBase.FALSE);
            }

#if DEBUG_MODE
            Script.WriteTimestampedLogEntry(Message);
#endif
        }

        /// <summary>
        /// The associated server.
        /// </summary>
        private GameServer Server;
    }
}

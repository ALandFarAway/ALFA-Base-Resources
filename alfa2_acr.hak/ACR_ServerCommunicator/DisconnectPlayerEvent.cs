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
    /// This event encapsulates data relating to a request to disconnect a
    /// player from the local server.
    /// </summary>
    class DisconnectPlayerEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new DisconnectPlayerEvent.
        /// </summary>
        /// <param name="Player">Supplies the player to disconnect.</param>
        public DisconnectPlayerEvent(GamePlayer Player)
        {
            this.Player = Player;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            foreach (uint PlayerObject in Script.GetPlayers(true))
            {
                if (Database.ACR_GetPlayerID(PlayerObject) != Player.PlayerId)
                    continue;

                Script.WriteTimestampedLogEntry("DisconnectPlayerEvent.DispatchEvent: Disconnecting player " + Script.GetPCPlayerName(PlayerObject) + " due to IPC request.");
                Script.BootPC(PlayerObject);
                return;
            }

            Script.WriteTimestampedLogEntry("DisconnectPlayerEvent.DispatchEvent: No player '" + Player.PlayerName + "' found locally connected to disconnect.");
        }

        /// <summary>
        /// The associated player;
        /// </summary>
        private GamePlayer Player;
    }
}

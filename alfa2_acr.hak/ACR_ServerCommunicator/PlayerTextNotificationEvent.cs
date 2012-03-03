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
    /// This event encapsulates data relating to a directed text notification
    /// that is sent to a single local player.
    /// </summary>
    class PlayerTextNotificationEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new PlayerTextNotificationEvent.
        /// </summary>
        /// <param name="PlayerObject">Supplies the local object id of the
        /// player to send to.</param>
        /// <param name="Message">Supplies the message text.</param>
        public PlayerTextNotificationEvent(uint PlayerObject, string Message)
        {
            this.PlayerObject = PlayerObject;
            this.Message = Message;
        }

        /// <summary>
        /// Dispatch the event (in a script context).
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void DispatchEvent(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            Script.SendMessageToPC(PlayerObject, Message);
        }

        /// <summary>
        /// The object id of the player to send the message to.
        /// </summary>
        private uint PlayerObject;
        /// <summary>
        /// The message text.
        /// </summary>
        private string Message;
    }
}

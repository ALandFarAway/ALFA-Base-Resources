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
    /// This event encapsulates data relating to a page event from a remote
    /// server.
    /// </summary>
    class PageEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new PageEvent.
        /// </summary>
        /// <param name="Sender">Supplies the sender.</param>
        /// <param name="Recipient">Supplies the recipient.</param>
        /// <param name="Message">Supplies the message text.</param>
        public PageEvent(GamePlayer Sender, GamePlayer Recipient, string Message)
        {
            this.Sender = Sender;
            this.Recipient = Recipient;
            this.Message = Message;
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
                if (Database.ACR_GetPlayerID(PlayerObject) != Recipient.PlayerId)
                    continue;

                string FormattedMessage = String.Format(
                    "<c=#FFCC99>{0}: </c><c=#30DDCC>[Page] {1}</c>",
                    Sender.PlayerName,
                    Message);

                Script.SendChatMessage(
                    CLRScriptBase.OBJECT_INVALID,
                    PlayerObject,
                    CLRScriptBase.CHAT_MODE_SERVER,
                    FormattedMessage,
                    CLRScriptBase.FALSE);
                break;
            }
        }

        /// <summary>
        /// The message sender.
        /// </summary>
        private GamePlayer Sender;

        /// <summary>
        /// The message recipient.
        /// </summary>
        private GamePlayer Recipient;

        /// <summary>
        /// The message text.
        /// </summary>
        private string Message;
    }
}

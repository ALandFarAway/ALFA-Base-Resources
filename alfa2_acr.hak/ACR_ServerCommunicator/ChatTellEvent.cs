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
    /// This event encapsulates data relating to a chat tell event from a
    /// remote server.
    /// </summary>
    class ChatTellEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new ChatTellEvent.
        /// </summary>
        /// <param name="Sender">Supplies the sender.</param>
        /// <param name="Recipient">Supplies the recipient.</param>
        /// <param name="Message">Supplies the message text.</param>
        public ChatTellEvent(GameCharacter Sender, GamePlayer Recipient, string Message)
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
                    "<c=#FFCC99>{0}: </c><c=#30DDCC>[ServerTell] {1}</c>",
                    Sender.CharacterName,
                    Message);

                Script.SetLastTellFromPlayerId(PlayerObject, Sender.Player.PlayerId);
                Script.SendChatMessage(
                    CLRScriptBase.OBJECT_INVALID,
                    PlayerObject,
                    CLRScriptBase.CHAT_MODE_SERVER,
                    FormattedMessage,
                    CLRScriptBase.FALSE);

                //
                // If this is the first time that we have delivered a
                // cross-server tell to this player (since login), remind them
                // of how to respond.
                //

                if ((Database.ACR_GetPCLocalFlags(PlayerObject) & ALFA.Database.ACR_PC_LOCAL_FLAG_SERVER_TELL_HELP) == 0)
                {
                    Script.SendMessageToPC(
                        PlayerObject,
                        "To respond to a [ServerTell] from a player on a different server, type: #re <message>, or #t \"character name\" message, or #tp \"player name\" message.  Quotes are optional unless the name has spaces.");
                    Database.ACR_SetPCLocalFlags(
                        PlayerObject,
                        Database.ACR_GetPCLocalFlags(PlayerObject) | ALFA.Database.ACR_PC_LOCAL_FLAG_SERVER_TELL_HELP);
                }
                break;
            }
        }

        /// <summary>
        /// The message sender.
        /// </summary>
        private GameCharacter Sender;

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

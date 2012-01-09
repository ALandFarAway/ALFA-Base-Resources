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
    /// This event encapsulates data relating to a character that has gone
    /// offline from a given server.
    /// </summary>
    class CharacterPartEvent : IGameEventQueueEvent
    {

        /// <summary>
        /// Create a new CharacterPartEvent.
        /// </summary>
        /// <param name="Character">Supplies the character.</param>
        /// <param name="IsDM">Supplies true if the character was DM
        /// privileged at part time.</param>
        /// <param name="Server">Supplies the server that the character has
        /// parted.</param>
        public CharacterPartEvent(GameCharacter Character, bool IsDM, GameServer Server)
        {
            this.Character = Character;
            this.IsDM = IsDM;
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
            // If the event was for a player logging off of the local server,
            // then don't re-broadcast it.
            //

            if (Database.ACR_GetServerID() == Server.ServerId)
                return;

            string Message = String.Format(
                "{0}<c=#FF6600>{1} ({2}) left {3}.</c>",
                IsDM ? "<c=#99CCFF>[DM] </c>" : "",
                Character.Name,
                Character.Player.Name,
                Server.Name);

            foreach (uint PlayerObject in Script.GetPlayers(true))
            {
                if (!Script.IsCrossServerNotificationEnabled(PlayerObject))
                    continue;

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
        /// The associated character.
        /// </summary>
        private GameCharacter Character;

        /// <summary>
        /// Whether the character was a DM at part time.
        /// </summary>
        private bool IsDM;

        /// <summary>
        /// The server that the character had parted.  This may not be the
        /// current server for the character, however, at event dispatch time.
        /// </summary>
        private GameServer Server;
    }
}

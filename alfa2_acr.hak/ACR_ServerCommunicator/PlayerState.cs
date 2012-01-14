using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CLRScriptFramework;
using ALFA;
using NWScript;
using NWScript.ManagedInterfaceLayer.NWScriptManagedInterface;

using NWEffect = NWScript.NWScriptEngineStructure0;
using NWEvent = NWScript.NWScriptEngineStructure1;
using NWLocation = NWScript.NWScriptEngineStructure2;
using NWTalent = NWScript.NWScriptEngineStructure3;
using NWItemProperty = NWScript.NWScriptEngineStructure4;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This object maintains extended state internal to the server
    /// communicator with respect to a player.  It maintains data that is local
    /// to this server instance; the data is created at client enter, and
    /// removed at client leave.
    /// 
    /// N.B.  This state is intended for use by script code on the main thread.
    /// </summary>
    public class PlayerState
    {

        /// <summary>
        /// Construct a new PlayerState object.
        /// </summary>
        /// <param name="ObjectId">Supplies the NWScript object id of the PC
        /// object.</param>
        /// <param name="Communicator">Supplies the server communicator
        /// instance that the PlayerState object is bound to.</param>
        public PlayerState(uint ObjectId, ACR_ServerCommunicator Communicator)
        {
            ALFA.Database Database = Communicator.GetDatabase();

            this.Communicator = Communicator;
            this.PCObjectId = ObjectId;
            this.PCCharacterId = Database.ACR_GetCharacterID(ObjectId);
            this.PCPlayerId = Database.ACR_GetPlayerID(ObjectId);
            StateFlags = 0;

            //
            // Upgrade any legacy database settings to their new format.
            //

            UpgradeLegacySettings();
        }

        /// <summary>
        /// Get the object id (NWScript object) of the player.
        /// </summary>
        public uint ObjectId { get { return PCObjectId; } }

        /// <summary>
        /// Get the character id (database identifier) of the player's
        /// character.
        /// </summary>
        public int CharacterId { get { return PCCharacterId; } }

        /// <summary>
        /// Get the player id (database identifier) of the player.
        /// </summary>
        public int PlayerId { get { return PCPlayerId; } }

        /// <summary>
        /// The player state flags.
        /// </summary>
        public PlayerStateFlags Flags
        {
            get { return StateFlags; }
            set
            {
                if (StateFlags == value)
                    return;

                StateFlags = value;
            }
        }



        /// <summary>
        /// Convert legacy database settings to their new format.
        /// </summary>
        private void UpgradeLegacySettings()
        {
            ALFA.Database Database = Communicator.GetDatabase();

            if (Database.ACR_GetPersistentInt(ObjectId, "ACR_DISABLE_CROSS_SERVER_NOTIFICATIONS") != CLRScriptBase.FALSE)
            {
            }
        }


        /// <summary>
        /// Back link to the associated ACR_ServerCommunicator object.
        /// </summary>
        private ACR_ServerCommunicator Communicator;

        /// <summary>
        /// The object id of the player.
        /// </summary>
        private uint PCObjectId;

        /// <summary>
        /// The database id of the character.
        /// </summary>
        private int PCCharacterId;

        /// <summary>
        /// The database id of the player.
        /// </summary>
        private int PCPlayerId;

        /// <summary>
        /// The state flags for the player.
        /// </summary>
        private PlayerStateFlags StateFlags;
    }

    /// <summary>
    /// This enumeration describes player state flags that are saved in the
    /// database, e.g. for preference settings.
    /// </summary>
    public enum PlayerStateFlags : uint
    {
        /// <summary>
        /// Don't send cross-server join/leave notifications.
        /// </summary>
        DisableCrossServerNotifications = 0x00000001,

        /// <summary>
        /// Prefer to send cross-server join/leave notifications to the user's
        /// combat log and not the main chat log.  This changes the event type
        /// to a combat log message and not server chat.  If not set, then the
        /// notices go as server chat events to the main chat log.
        /// </summary>
        SendCrossServerNotificationsToCombatLog = 0x00000002,
    }
}

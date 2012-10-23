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
            this.StateFlags = (PlayerStateFlags) Database.ACR_GetPersistentInt(ObjectId, "ACR_COMMUNICATOR_STATE_FLAGS");
            this.LatencyTickCount = 0;
            this.LatencyToServer = 0;
            this.ChatSelectLocalPlayersShown = 0;
            this.ChatSelectLocalDMsShown = 0;
            this.ChatSelectRemotePlayersShown = 0;
            this.ChatSelectRemoteDMsShown = 0;

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
        /// Get whether the player is DM privileged.
        /// </summary>
        public bool IsDM { get { return Communicator.GetIsDM(ObjectId) != CLRScriptBase.FALSE;  } }

        /// <summary>
        /// Get the list of character IDs that the client-side GUI for quick
        /// chat is showing.
        /// </summary>
        public List<int> CharacterIdsShown { get { return PCCharacterIdsShown; } }

        /// <summary>
        /// The tick when the last latency check was initiated.
        /// </summary>
        public uint LatencyTickCount { get; set; }

        /// <summary>
        /// The combined latency to server and server response time for the
        /// player.
        /// </summary>
        public uint LatencyToServer { get; set; }

        /// <summary>
        /// The count of local players in the character id list.
        /// 
        /// N.B.  This is the GUI state value.  If the GUI is collapsed, all
        ///       players are considered "local".
        /// </summary>
        public int ChatSelectLocalPlayersShown { get; set; }

        /// <summary>
        /// The count of local DMs in the character id list.
        /// 
        /// N.B.  This is the GUI state value.  If the GUI is collapsed, all
        ///       DMs are considered "local".
        /// </summary>
        public int ChatSelectLocalDMsShown { get; set; }

        /// <summary>
        /// The count of remote players in the character id list.
        /// 
        /// N.B.  This is the GUI state value.  If the GUI is collapsed, all
        ///       players are considered "local".
        /// </summary>
        public int ChatSelectRemotePlayersShown { get; set; }

        /// <summary>
        /// The count of remote DMs in the character id list.
        /// 
        /// N.B.  This is the GUI state value.  If the GUI is collapsed, all
        ///       DMs are considered "local".
        /// </summary>
        public int ChatSelectRemoteDMsShown { get; set; }

        /// <summary>
        /// Get or set whether the chat select GUI is expanded.
        /// </summary>
        public bool ChatSelectGUIExpanded
        {
            get
            {
                return Communicator.GetLocalInt(ObjectId, "chatselect_expanded") != CLRScriptBase.FALSE;
            }
            set
            {
                if (value)
                    Communicator.SetLocalInt(ObjectId, "chatselect_expanded", CLRScriptBase.TRUE);
                else
                    Communicator.DeleteLocalInt(ObjectId, "chatselect_expanded");
            }
        }

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
                Communicator.GetDatabase().ACR_SetPersistentInt(ObjectId, "ACR_COMMUNICATOR_STATE_FLAGS", (int)StateFlags);
            }
        }


        /// <summary>
        /// This method updates the chat select GUI headers if the player had
        /// the GUI active.  It is called after the count of players displayed
        /// has changed.
        /// 
        /// N.B.  This routine is assumed to be called in-thread-context on the
        ///       main thread.
        /// </summary>
        public void UpdateChatSelectGUIHeaders()
        {
            bool Expanded = ChatSelectGUIExpanded;

            string LocalPlayerListHeading = (!Expanded ? "Players" : "Local Players");
            string LocalDMListHeading = (!Expanded ? "DMs" : "Local DMs");
            string RemotePlayerListHeading = "Remote Players";
            string RemoteDMListHeading = "Remote DMs";

            LocalPlayerListHeading += String.Format(" ({0})", ChatSelectLocalPlayersShown);
            LocalDMListHeading += String.Format(" ({0})", ChatSelectLocalDMsShown);

            Communicator.SetGUIObjectText(ObjectId, "ChatSelect", "HEADER_LPL", -1, LocalPlayerListHeading);
            Communicator.SetGUIObjectText(ObjectId, "ChatSelect", "HEADER_LDM", -1, LocalDMListHeading);

            if (!Expanded)
                return;

            RemotePlayerListHeading += String.Format(" ({0})", ChatSelectRemotePlayersShown);
            RemoteDMListHeading += String.Format(" ({0})", ChatSelectRemoteDMsShown);

            Communicator.SetGUIObjectText(ObjectId, "ChatSelect", "HEADER_RPL", -1, RemotePlayerListHeading);
            Communicator.SetGUIObjectText(ObjectId, "ChatSelect", "HEADER_RDM", -1, RemoteDMListHeading);
        }



        /// <summary>
        /// Convert legacy database settings to their new format.
        /// </summary>
        private void UpgradeLegacySettings()
        {
            ALFA.Database Database = Communicator.GetDatabase();

            //
            // If the user has the old ACR_DISABLE_CROSS_SERVER_NOTIFICATIONS
            // value set from the pre-1.85 release, clear that variable and set
            // the flags bitmap as appropriate.
            //

            if (Database.ACR_GetPersistentInt(ObjectId, "ACR_DISABLE_CROSS_SERVER_NOTIFICATIONS") != CLRScriptBase.FALSE)
            {
                StateFlags |= PlayerStateFlags.DisableCrossServerNotifications;
                Database.ACR_DeletePersistentVariable(ObjectId, "ACR_DISABLE_CROSS_SERVER_NOTIFICATIONS");
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

        /// <summary>
        /// The list of which character ids are shown in the augmented quick
        /// chat listbox is stored here.
        /// </summary>
        private List<int> PCCharacterIdsShown = new List<int>();
    }

    /// <summary>
    /// This enumeration describes player state flags that are saved in the
    /// database, e.g. for preference settings.
    /// </summary>
    [FlagsAttribute]
    public enum PlayerStateFlags : uint
    {
        /// <summary>
        /// No state flags set.
        /// </summary>
        None = 0x00000000,

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

        /// <summary>
        /// Only show local players when the chat select window is collapsed.
        /// </summary>
        ChatSelectShowLocalPlayersOnlyWhenCollapsed = 0x00000004,
    }
}

//
// This script manages server-to-server IPC communication.
//

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Reflection.Emit;
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
    public partial class ACR_ServerCommunicator : CLRScriptBase, IGeneratedScriptProgram
    {

        public ACR_ServerCommunicator([In] NWScriptJITIntrinsics Intrinsics, [In] INWScriptProgram Host)
        {
            InitScript(Intrinsics, Host);
        }

        private ACR_ServerCommunicator([In] ACR_ServerCommunicator Other)
        {
            InitScript(Other);
            Database = Other.Database;

            LoadScriptGlobals(Other.SaveScriptGlobals());
        }

        public static Type[] ScriptParameterTypes =
        { typeof(string), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode;
            string RequestType = (string)ScriptParameters[0];

            //
            // If we haven't yet done one time initialization, do so now.
            //

            if (!ScriptInitialized)
                InitializeServerCommunicator();

            //
            // Now dispatch the command request.
            //

            if (RequestType == "INITIALIZE")
            {
                ReturnCode = 0;
            }
            else if (RequestType == "SIGNAL_IPC_EVENT")
            {
                int SourcePlayerId = (int)ScriptParameters[1];
                int SourceServerId = (int)ScriptParameters[2];
                int DestinationPlayerId = (int)ScriptParameters[3];
                int DestinationServerId = (int)ScriptParameters[4];
                int EventType = (int)ScriptParameters[5];
                string EventText = (string)ScriptParameters[6];

                SignalIPCEvent(SourcePlayerId, SourceServerId, DestinationPlayerId, DestinationServerId, EventType, EventText);

                ReturnCode = 0;
            }
            else if (RequestType == "RESOLVE_CHARACTER_NAME_TO_PLAYER_ID")
            {
                string CharacterName = (string)ScriptParameters[6];

                ReturnCode = ResolveCharacterNameToPlayerId(CharacterName);
            }
            else if (RequestType == "RESOLVE_PLAYER_NAME")
            {
                string PlayerName = (string)ScriptParameters[6];

                ReturnCode = ResolvePlayerName(PlayerName);
            }
            else if (RequestType == "RESOLVE_PLAYER_ID_TO_SERVER_ID")
            {
                int PlayerId = (int)ScriptParameters[1];

                ReturnCode = ResolvePlayerIdToServerId(PlayerId);
            }
            else if (RequestType == "LIST_ONLINE_USERS")
            {
                uint PlayerObject = OBJECT_SELF;

                ListOnlineUsers(PlayerObject);

                ReturnCode = 0;
            }
            else
            {
                throw new ApplicationException("Invalid IPC script command " + RequestType);
            }

            //
            // Now that we are done, check if we've got any entries in the
            // local command queue to drain from the IPC worker thread, e.g. a
            // tell to deliver.
            //

            DrainCommandQueue();

            return ReturnCode;
        }

        /// <summary>
        /// This method initializes the server communicator (one-time startup
        /// processing).
        /// </summary>
        private void InitializeServerCommunicator()
        {
            Database = new ALFA.Database(this);
            WorldManager = new GameWorldManager(Database.ACR_GetServerID());

            //
            // Create the database tables as necessary.
            //

            Database.ACR_SQLQuery(
                "CREATE TABLE IF NOT EXISTS `server_ipc_events` ( " +
                "`ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, " +
                "`SourcePlayerID` mediumint(8) UNSIGNED NOT NULL, " +
                "`SourceServerID` smallint(5) UNSIGNED NOT NULL, " +
                "`DestinationPlayerID` mediumint(8) UNSIGNED NOT NULL, " +
                "`DestinationServerID` smallint(5) UNSIGNED NOT NULL, " +
                "`EventType` smallint(5) UNSIGNED NOT NULL, " +
                " `EventText` varchar(256) NOT NULL, " +
                "PRIMARY KEY(`ID`), UNIQUE KEY(`ID`, `DestinationServerID`) " +
                ") ENGINE=MyISAM DEFAULT CHARSET=latin1; ");

            //
            // Remove any stale IPC commands to this server, as we are starting
            // up fresh.
            //

            Database.ACR_SQLQuery(String.Format(
                "DELETE FROM `server_ipc_events` WHERE DestinationServerID={0}",
                Database.ACR_GetServerID()));

            WriteTimestampedLogEntry(String.Format(
                "ACR_ServerCommunicator.InitializeServerCommunicator(): Purged {0} old records from server_ipc_events for server id {1}.",
                Database.ACR_SQLGetAffectedRows(),
                Database.ACR_GetServerID()));

            //
            // Finally, drop into the command polling loop.
            //

            CommandDispatchLoop();
        }

        /// <summary>
        /// Signal an IPC event to a server's IPC event queue.
        /// </summary>
        /// <param name="SourcePlayerId">Supplies the source player id for the
        /// event originator.</param>
        /// <param name="SourceServerId">Supplies the source server id for the
        /// event originator.</param>
        /// <param name="DestinationPlayerId">Supplies the destination player
        /// id for event routing.</param>
        /// <param name="DestinationServerId">Supplies the destination server
        /// id for event routing.</param>
        /// <param name="EventType">Supplies the event type code.</param>
        /// <param name="EventText">Supplies the event data, which must be less
        /// than ACR_SERVER_IPC_MAX_EVENT_LENGTH bytes.</param>
        private void SignalIPCEvent(int SourcePlayerId, int SourceServerId, int DestinationPlayerId, int DestinationServerId, int EventType, string EventText)
        {
            if (EventText.Length > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
                throw new ApplicationException("IPC event text too long:" + EventText);

            Database.ACR_SQLQuery(String.Format(
                "INSERT INTO `server_ipc_events` (`ID`, `SourcePlayerID`, `SourceServerID`, `DestinationPlayerID`, `EventType`, `EventText`) VALUES (0, {0}, {1}, {2}, {3}, {5}, '{6}')",
                SourcePlayerId,
                SourceServerId,
                DestinationPlayerId,
                DestinationServerId,
                EventType,
                EventText));
        }

        /// <summary>
        /// Look up a character by name and return the owning player id.  The
        /// local cache is queried first, otherwise the necessary data is
        /// pulled in from the database.
        /// </summary>
        /// <param name="CharacterName">Supplies the object name to look up.
        /// </param>
        /// <returns>The object id, else 0 if the lookup failed.</returns>
        private int ResolveCharacterNameToPlayerId(string CharacterName)
        {
            lock (WorldManager)
            {
                GameCharacter Character = WorldManager.ReferenceCharacterByName(CharacterName);

                if (Character == null)
                    return 0;

                return Character.Player.PlayerId;
            }
        }

        /// <summary>
        /// Look up a player by name and return the character id.  The local
        /// cache is queried first, otherwise the necessary data is pulled in
        /// from the database.
        /// </summary>
        /// <param name="PlayerName">Supplies the object name to look up.
        /// </param>
        /// <returns>The object id, else 0 if the lookup failed.</returns>
        private int ResolvePlayerName(string PlayerName)
        {
            lock (WorldManager)
            {
                GamePlayer Player = WorldManager.ReferencePlayerByName(PlayerName);

                if (Player == null)
                    return 0;

                return Player.PlayerId;
            }
        }

        /// <summary>
        /// Look up a player by player id and return the server id of their
        /// primary logged on character.  If the player isn't logged on or the
        /// player id was invalid, zero is returned.
        /// </summary>
        /// <param name="PlayerId">Supplies the player id to look up.</param>
        /// <returns>The player's logged on server id, else 0.</returns>
        private int ResolvePlayerIdToServerId(int PlayerId)
        {
            lock (WorldManager)
            {
                GamePlayer Player = WorldManager.ReferencePlayerById(PlayerId);

                if (Player == null)
                    return 0;

                GameServer Server = Player.GetOnlineServer();

                if (Server == null)
                    return 0;

                return Server.ServerId;
            }
        }

        /// <summary>
        /// Send a textural description of the online player list to player on
        /// the local server.
        /// </summary>
        /// <param name="PlayerObject">Supplies the player object id for the
        /// player to send the player list to.</param> 
        private void ListOnlineUsers(uint PlayerObject)
        {
            lock (WorldManager)
            {
                var OnlineServers = from S in WorldManager.Servers
                                    where S.Online &&
                                    S.Characters.Count > 0
                                    select S;

                foreach (GameServer Server in OnlineServers)
                {
                }
            }
        }

        /// <summary>
        /// This method periodically runs as a DelayCommand continuation.  Its
        /// purpose is to check for commands from the worker thread and
        /// dispatch them as appropriate.
        /// </summary>
        private void CommandDispatchLoop()
        {
            DrainCommandQueue();

            //
            // Start a new dispatch cycle going.
            //

            DelayCommand(COMMAND_DISPATCH_INTERVAL, delegate() { CommandDispatchLoop(); });
        }

        /// <summary>
        /// This method drains items from the IPC thread command queue, i.e.
        /// those actions that must be performed in a script context because
        /// they need to call script APIs.
        /// </summary>
        private void DrainCommandQueue()
        {
            lock (WorldManager)
            {
                if (WorldManager.IsEventQueueEmpty())
                    return;

                if (Database == null)
                    Database = new ALFA.Database(this);

                WorldManager.RunQueue(this, Database);
            }
        }

        /// <summary>
        /// The interval between command dispatch polling cycles is set here.
        /// </summary>
        private const float COMMAND_DISPATCH_INTERVAL = 0.3f;

        /// <summary>
        /// The maximum length of a server IPC event is set here.  This is the
        /// length of the EventText field in the database table.
        /// </summary>
        private const int ACR_SERVER_IPC_MAX_EVENT_LENGTH = 256;

        /// <summary>
        /// If false, the script has not run initialization yet.
        /// </summary>
        private static bool ScriptInitialized = false;

        /// <summary>
        /// The game world state manager is stored here.
        /// </summary>
        private static GameWorldManager WorldManager = null;

        /// <summary>
        /// The interop SQL database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using ALFA;
using CLRScriptFramework;

namespace ACR_ServerCommunicator
{
    /// <summary>
    /// This object (which is a singleton) manages the local server's view of
    /// the game world wide state (data for all servers and players is locally
    /// stored here).
    /// 
    /// State elements are, generally, lazily added to the game world manager's
    /// state cache.  Only when a character, player, or server has actually
    /// been observed will it be added to the local cache.  This helps prevent
    /// the local cache from growing too large up front, as it does not need to
    /// have the entire database contents pre-downloaded.
    /// 
    /// As identifiers for unknown servers, players, or characters are seen,
    /// the local state cache is updated from the database.
    /// 
    /// The local state cache is also updated based on polling the online
    /// player list periodically.  In effect, the state cache serves as the
    /// current server's view of player presence across the entire game world,
    /// spanning every online server.
    /// 
    /// All internal operations on the GameWorldManager assume that the caller
    /// has provided appropriate synchronization.  Many operations may block on
    /// the first reference to a previously unresolved object identifier or
    /// object name.
    /// </summary>
    class GameWorldManager
    {

        /// <summary>
        /// Create a new GameWorldManager.
        /// </summary>
        /// <param name="LocalServerId">Supplies the server id of the local
        /// server.</param>
        /// <param name="LocalServerName">Supplies the server name of the local
        /// server, as referenced in the pwdata table in the database.</param>
        public GameWorldManager(int LocalServerId, string LocalServerName)
        {
            this.LocalServerId = LocalServerId;
            this.LocalServerName = LocalServerName;
            this.PauseUpdates = false;

            EventQueue = new GameEventQueue(this);
            QueryDispatchThread = new Thread(QueryDispatchThreadRoutine);
            ConfigurationSyncTimer = new Timer(new TimerCallback(OnConfigurationSyncTimer), null, 0, CONFIGURATION_SYNC_INTERVAL);
            UpdateServerCheckinTimer = new Timer(new TimerCallback(OnUpdateServerCheckinTimer), null, 0, UPDATE_SERVER_CHECKIN_INTERVAL);
            UpdateDatabaseOnlineTimer = new Timer(new TimerCallback(OnUpdateDatabaseOnlineTimer), null, 0, UPDATE_DATABASE_ONLINE_INTERVAL);

            QueryDispatchThread.Start();
        }

        /// <summary>
        /// Reference the data for a character by the character name.  If the
        /// data was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="CharacterName">Supplies the object name.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GameCharacter ReferenceCharacterByName(string CharacterName, IALFADatabase Database)
        {
            //
            // Check if the object is already known first.
            //

            GameCharacter Character = (from C in Characters
                                       where C.CharacterName.Equals(CharacterName, StringComparison.InvariantCultureIgnoreCase)
                                       select C).FirstOrDefault();

            if (Character != null)
                return Character;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            int ServerId;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `ID`, `PlayerID`, `IsOnline`, `ServerID`, `Name`, `Location` FROM `characters` WHERE `Name` = '{0}'",
                Database.ACR_SQLEncodeSpecialChars(CharacterName)));

            if (!Database.ACR_SQLFetch())
                return null;

            Character = new GameCharacter(this);

            Character.CharacterId = Convert.ToInt32(Database.ACR_SQLGetData(0));
            Character.PlayerId = Convert.ToInt32(Database.ACR_SQLGetData(1));
            Character.Online = ConvertToBoolean(Database.ACR_SQLGetData(2));
            ServerId = Convert.ToInt32(Database.ACR_SQLGetData(3));
            Character.CharacterName = Database.ACR_SQLGetData(4);
            Character.LocationString = Database.ACR_SQLGetData(5);

            InsertNewCharacter(Character, ServerId, Database, null);

            return Character;
        }

        /// <summary>
        /// Reference the data for a character by the character id.  If the
        /// data was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="CharacterId">Supplies the object id.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GameCharacter ReferenceCharacterById(int CharacterId, IALFADatabase Database)
        {
            return ReferenceCharacterById(CharacterId, Database, null);
        }

        /// <summary>
        /// Reference the data for a character by the character id.  If the
        /// data was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="CharacterId">Supplies the object id.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <param name="InitialDMState">Supplies the initial DM state of the
        /// backing player object to update, for a synchronization of an
        /// existing player with a new character.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GameCharacter ReferenceCharacterById(int CharacterId, IALFADatabase Database, bool? InitialDMState)
        {
            //
            // Check if the object is already known first.
            //

            GameCharacter Character = (from C in Characters
                                       where C.CharacterId == CharacterId
                                       select C).FirstOrDefault();

            if (Character != null)
                return Character;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            int ServerId;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `Name`, `PlayerID`, `IsOnline`, `ServerID`, `Location` FROM `characters` WHERE `ID` = {0}",
                CharacterId));

            if (!Database.ACR_SQLFetch())
                return null;

            Character = new GameCharacter(this);

            Character.CharacterName = Database.ACR_SQLGetData(0);
            Character.CharacterId = CharacterId;
            Character.PlayerId = Convert.ToInt32(Database.ACR_SQLGetData(1));
            Character.Online = ConvertToBoolean(Database.ACR_SQLGetData(2));
            ServerId = Convert.ToInt32(Database.ACR_SQLGetData(3));
            Character.LocationString = Database.ACR_SQLGetData(4);

            InsertNewCharacter(Character, ServerId, Database, InitialDMState);

            return Character;
        }

        /// <summary>
        /// Reference the data for a player by the player name.  If the data
        /// was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="PlayerName">Supplies the object name.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GamePlayer ReferencePlayerByName(string PlayerName, IALFADatabase Database)
        {
            //
            // Check if the object is already known first.
            //

            GamePlayer Player = (from P in Players
                                 where P.PlayerName.Equals(PlayerName, StringComparison.InvariantCultureIgnoreCase)
                                 select P).FirstOrDefault();

            if (Player != null)
                return Player;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `ID`, `IsDM`, `Name` FROM `players` WHERE `Name` = '{0}'",
                Database.ACR_SQLEncodeSpecialChars(PlayerName)));

            if (!Database.ACR_SQLFetch())
                return null;

            Player = new GamePlayer(this);

            Player.PlayerId = Convert.ToInt32(Database.ACR_SQLGetData(0));
            Player.IsDM = ConvertToBoolean(Database.ACR_SQLGetData(1));
            Player.PlayerName = Database.ACR_SQLGetData(2);

            InsertNewPlayer(Player, Database);

            return Player;
        }

        /// <summary>
        /// Reference the data for a player by the player id.  If the data
        /// was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="PlayerId">Supplies the object id.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GamePlayer ReferencePlayerById(int PlayerId, IALFADatabase Database)
        {
            //
            // Check if the object is already known first.
            //

            GamePlayer Player = (from P in Players
                                 where P.PlayerId == PlayerId
                                 select P).FirstOrDefault();

            if (Player != null)
                return Player;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `Name`, `IsDM` FROM `players` WHERE `ID` = {0}",
                PlayerId));

            if (!Database.ACR_SQLFetch())
                return null;

            Player = new GamePlayer(this);

            Player.PlayerName = Database.ACR_SQLGetData(0);
            Player.PlayerId = PlayerId;
            Player.IsDM = ConvertToBoolean(Database.ACR_SQLGetData(1));

            InsertNewPlayer(Player, Database);

            return Player;
        }

        /// <summary>
        /// Reference the data for a server by the server name.  If the data
        /// was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="ServerName">Supplies the object name.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GameServer ReferenceServerByName(string ServerName, IALFADatabase Database)
        {
            //
            // Check if the object is already known first.
            //

            GameServer Server = (from S in Servers
                                 where S.ServerName.Equals(ServerName, StringComparison.InvariantCultureIgnoreCase)
                                 select S).FirstOrDefault();

            if (Server != null)
                return Server;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `ID`, `IPAddress`, `Name` FROM `servers` WHERE `Name` = '{0}'",
                Database.ACR_SQLEncodeSpecialChars(ServerName)));

            if (!Database.ACR_SQLFetch())
                return null;

            Server = new GameServer(this);

            Server.ServerId = Convert.ToInt32(Database.ACR_SQLGetData(0));
            Server.SetHostnameAndPort(Database.ACR_SQLGetData(1));
            Server.ServerName = Database.ACR_SQLGetData(2);

            InsertNewServer(Server, Database);

            return Server;
        }

        /// <summary>
        /// Reference the data for a server by the server id.  If the data
        /// was not yet available, it is retrieved from the database.
        /// </summary>
        /// <param name="ServerId">Supplies the object id.</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <returns>The object data is returned, else null if the object did
        /// not exist.</returns>
        public GameServer ReferenceServerById(int ServerId, IALFADatabase Database)
        {
            //
            // Check if the object is already known first.
            //

            GameServer Server = (from S in Servers
                                 where S.ServerId == ServerId
                                 select S).FirstOrDefault();

            if (Server != null)
                return Server;

            //
            // Need to pull the data from the database.
            //

            if (Database == null)
                return null;

            Database.ACR_SQLQuery(String.Format(
                "SELECT `Name`, `IPAddress` FROM `servers` WHERE `ID` = {0}",
                ServerId));

            if (!Database.ACR_SQLFetch())
                return null;

            Server = new GameServer(this);

            Server.ServerName = Database.ACR_SQLGetData(0);
            Server.ServerId = ServerId;
            Server.SetHostnameAndPort(Database.ACR_SQLGetData(1));

            InsertNewServer(Server, Database);

            return Server;
        }

        /// <summary>
        /// Signal an IPC event on a remote server by adding the event to the
        /// outbound event queue.
        /// </summary>
        /// <param name="Event">Supplies the event to signal.</param>
        public void SignalIPCEvent(IPC_EVENT Event)
        {
            IPCEventQueue.Enqueue(Event);
        }

        /// <summary>
        /// Signal a request to invoke an action in the context of the query
        /// thread.
        /// 
        /// N.B.  The routine should NOT be invoked with the world manager
        ///       locked.  Internal synchronization is provided.
        /// </summary>
        /// <param name="Action">Supplies the action to enqueue to the query
        /// thread.</param>
        public void SignalQueryThreadAction(QueryThreadAction Action)
        {
            lock (QueryThreadActionQueue)
            {
                QueryThreadActionQueue.Enqueue(Action);
            }
        }

        /// <summary>
        /// Signal that the query thread should wake up to process IPC events
        /// soon.  This may reduce the time until the next outbound event is
        /// sent.
        /// 
        /// Note that, unlike most members, this method does not require any
        /// particular synchronization.
        /// </summary>
        public void SignalIPCEventWakeup()
        {
            QueryThreadWakeupEvent.Set();
        }

        /// <summary>
        /// This structure contains the raw data for an IPC event queue entry.
        /// </summary>
        public class IPC_EVENT
        {
            public int SourcePlayerId;
            public int SourceServerId;
            public int DestinationPlayerId;
            public int DestinationServerId;
            public int EventType;
            public string EventText;
        }

        /// <summary>
        /// This property returns the list of active servers.
        /// </summary>
        public IEnumerable<GameServer> Servers
        {
            get { return ServerList; }
        }

        /// <summary>
        /// This property returns the list of active players.
        /// </summary>
        public IEnumerable<GamePlayer> Players
        {
            get { return PlayerList; }
        }

        /// <summary>
        /// This property returns the list of active characters.
        /// </summary>
        public IEnumerable<GameCharacter> Characters
        {
            get { return CharacterList; }
        }

        /// <summary>
        /// This property returns the list of all online characters across all
        /// known servers.
        /// </summary>
        public IEnumerable<GameCharacter> OnlineCharacters
        {
            get { return OnlineCharacterList; }
        }

        /// <summary>
        /// This property indicates whether updates to the game state by the
        /// query thread should be paused.  It may be used to temporarly halt
        /// updates for debugging or diagnostic purposes.
        /// </summary>
        public bool PauseUpdates { get; set; }

        /// <summary>
        /// This property contains the configuration settings for the game
        /// world that are drawn from the database.
        /// </summary>
        public GameWorldConfiguration Configuration
        {
            get { return ConfigurationStore; }
        }
        
        /// <summary>
        /// Run the event queue down.  All events in the queue are given a
        /// chance to run.
        /// </summary>
        /// <param name="Script">Supplies the script object.</param>
        /// <param name="Database">Supplies the database connection.</param>
        public void RunQueue(ACR_ServerCommunicator Script, ALFA.Database Database)
        {
            EventQueue.RunQueue(Script, Database);
            EventsQueued = false;
        }

        /// <summary>
        /// Check whether the event queue is empty.
        /// </summary>
        /// <returns>True if the queue is empty.</returns>
        public bool IsEventQueueEmpty()
        {
            return EventQueue.Empty();
        }

        /// <summary>
        /// Check whether an event might be pending, without taking the lock.
        /// 
        /// Note that this is purely an advisory mechanism; the caller must
        /// repeatedly check as they may lose the race for when the event
        /// pending flag is set.  The purpose of this function is to allow the
        /// main thread to avoid needlessly blocking on the query thread.
        /// </summary>
        /// <returns>True if an event is pending and awaiting processing.
        /// </returns>
        public bool IsEventPending()
        {
            return EventsQueued;
        }

        /// <summary>
        /// Enqueue a message to a player for outbound transmission on the main
        /// server thread.
        /// 
        /// N.B.  The world manager is assumed to be locked.
        /// </summary>
        /// <param name="PlayerObject">Supplies the local object id of the
        /// player to send to.</param>
        /// <param name="Message">Supplies the message text.</param>
        public void EnqueueMessageToPlayer(uint PlayerObject, string Message)
        {
            EnqueueEvent(new PlayerTextNotificationEvent(PlayerObject, Message));
        }

        /// <summary>
        /// Enqueue an account association event to a player for processing in
        /// the main thread.
        /// 
        /// N.B.  The world manager is assumed to be locked.
        /// </summary>
        /// <param name="PlayerObject">Supplies the local object id of the
        /// player to send to.</param>
        /// <param name="AccountAssociationSecret">Supplies the account
        /// association secret.</param>
        /// <param name="AccountAssociationURL">Supplies the base URL of the
        /// account association service.</param>
        public void EnqueueAccountAssociationToPlayer(uint PlayerObject, string AccountAssociationSecret, string AccountAssociationURL)
        {
            EnqueueEvent(new PlayerAccountAssociationEvent(PlayerObject, AccountAssociationSecret, AccountAssociationURL));
        }


        /// <summary>
        /// This routine wrappers the process of enqueuing an event, and also
        /// sets the events queued flag if necessary.
        /// </summary>
        /// <param name="Event">Supplies the event to queue to the main game
        /// thread.</param>
        private void EnqueueEvent(IGameEventQueueEvent Event)
        {
            EventQueue.EnqueueEvent(Event);

            if (BlockEventsQueued)
                EventQueueModified = true;
            else
                EventsQueued = true;
        }

        /// <summary>
        /// This method is called to write a diagnostic log message to the main
        /// server log.  The method is called with synchronization held on the
        /// WorldManager object.
        /// </summary>
        /// <param name="Message">Supplies the message text to log.</param>
        public void WriteDiagnosticLog(string Message)
        {
            EnqueueEvent(new DiagnosticLogEvent(Message));
        }

        /// <summary>
        /// This method is called when a character is discovered to have come
        /// online.  The character is inserted already.
        /// </summary>
        /// <param name="Character">Supplies the character that is now
        /// considered to be online.</param>
        private void OnCharacterJoin(GameCharacter Character)
        {
            EnqueueEvent(new CharacterJoinEvent(Character, Character.Player.IsDM, Character.Server));
        }

        /// <summary>
        /// This method is called when a character is discovered to have gone
        /// offline.
        /// </summary>
        /// <param name="Character">Supplies the character that is now
        /// considered to be offline.</param>
        private void OnCharacterPart(GameCharacter Character)
        {
            EnqueueEvent(new CharacterPartEvent(Character, Character.Player.IsDM, Character.Server));
        }

        /// <summary>
        /// This method is called when a server is discovered to have come
        /// online.  The server is inserted already.
        /// </summary>
        /// <param name="Server">Supplies the server that is now considered to
        /// be online.</param>
        private void OnServerJoin(GameServer Server)
        {
            EnqueueEvent(new ServerJoinEvent(Server));
        }

        /// <summary>
        /// This method is called when a server is discovered to have gone
        /// offline.
        /// </summary>
        /// <param name="Server">Suplies the server that is now considered to
        /// be offline.</param>
        private void OnServerPart(GameServer Server)
        {
            EnqueueEvent(new ServerPartEvent(Server));
        }

        /// <summary>
        /// This method is called when a chat tell IPC event is received.
        /// </summary>
        /// <param name="Sender">Supplies the sender.</param>
        /// <param name="Recipient">Supplies the recipient.</param>
        /// <param name="Message">Supplies the message text.</param>
        private void OnChatTell(GameCharacter Sender, GamePlayer Recipient, string Message)
        {
            EnqueueEvent(new ChatTellEvent(Sender, Recipient, Message));
        }

        /// <summary>
        /// This method is called when a broadcast notification is received.
        /// </summary>
        /// <param name="Message">Supplies the message text.</param>
        private void OnBroadcastNotification(string Message)
        {
            EnqueueEvent(new BroadcastNotificationEvent(Message));
        }

        /// <summary>
        /// This method is called when a disconnect player request is received.
        /// </summary>
        /// <param name="Player">Supplies the player to disconnect.</param>
        private void OnDisconnectPlayer(GamePlayer Player)
        {
            EnqueueEvent(new DisconnectPlayerEvent(Player));
        }

        /// <summary>
        /// This method is called when a server shutdown request is received.
        /// </summary>
        /// <param name="Message">Supplies the message text.</param>
        private void OnShutdownServer(string Message)
        {
            EnqueueEvent(new ShutdownServerEvent(Message));

            if (Configuration.RestartWatchdogTimeout != 0)
                StartShutdownWatchdog(Configuration.RestartWatchdogTimeout);
        }


        /// <summary>
        /// This method is called when a purge cached character request is
        /// received.
        /// </summary>
        /// <param name="Player">Supplies the player whose cached vault
        /// contents are to be modified.</param>
        /// <param name="CharacterFileName">Supplies the file name of the
        /// character file to remove from the local cache.  Special file names
        /// and path characters are forbidden.</param>
        private void OnPurgeCachedCharacter(GamePlayer Player, string CharacterFileName)
        {
            if (!SystemInfo.IsSafeFileName(CharacterFileName))
            {
                WriteDiagnosticLog(String.Format(
                    "GameWorldManager.OnPurgeCachedCharacter: Invalid file name '{0}'.", CharacterFileName));
                return;
            }

            EnqueueEvent(new PurgeCachedCharacterEvent(Player, CharacterFileName));
        }

        /// <summary>
        /// This method is called when a page IPC event is received.
        /// </summary>
        /// <param name="Sender">Supplies the sender.</param>
        /// <param name="Recipient">Supplies the recipient.</param>
        /// <param name="Message">Supplies the message text.</param>
        private void OnPage(GamePlayer Sender, GamePlayer Recipient, string Message)
        {
            EnqueueEvent(new PageEvent(Sender, Recipient, Message));
        }

        /// <summary>
        /// This method is called when an unsupported IPC event code is
        /// received.
        /// </summary>
        /// <param name="RecordId">Supplies the associated record ID.</param>
        /// <param name="P0">Supplies the P0 parameter.</param>
        /// <param name="P1">Supplies the P1 parameter.</param>
        /// <param name="P2">Supplies the P2 parameter.</param>
        /// <param name="EventType">Supplies the IPC event type.</param>
        /// <param name="P3">Supplies the P3 parameter.</param>
        private void OnUnsupportedIPCEventType(int RecordId, int P0, int P1, int P2, int EventType, string P3)
        {
            EnqueueEvent(new UnsupportedIPCRequestEvent(RecordId, P0, P1, P2, EventType, P3));
        }

        /// <summary>
        /// This method is called when a player has had all of its data loaded
        /// from the database.  The player is inserted already.
        /// </summary>
        /// <param name="Player">Supplies the player object hwich has been
        /// loaded.</param>
        private void OnPlayerLoaded(GamePlayer Player)
        {
        }

        /// <summary>
        /// This method is called when a server has had all of its data loaded
        /// from the database.  The server is inserted already.
        /// </summary>
        /// <param name="Server">Supplies the server object hwich has been
        /// loaded.</param>
        private void OnServerLoaded(GameServer Server)
        {
            if (Server.Online)
                EnqueueEvent(new ServerJoinEvent(Server));
        }

        /// <summary>
        /// This function inserts a character into the various character lists
        /// and issues the character join event.
        /// </summary>
        /// <param name="Character">Supplies the character object to insert.
        /// </param>
        /// <param name="ServerId">Supplies the server id that the player is
        /// logged on to (only meaningful if the character is online).</param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        /// <param name="InitialDMState">Supplies the initial DM state of the
        /// backing player object to update, for a synchronization of an
        /// existing player with a new character.</param>
        private void InsertNewCharacter(GameCharacter Character, int ServerId, IALFADatabase Database, bool? InitialDMState)
        {
            GameServer Server;

            Character.Player = ReferencePlayerById(Character.PlayerId, Database);

            if (Character.Player == null)
                throw new ApplicationException(String.Format("Character {0} references invalid player id {1}", Character.CharacterId, Character.PlayerId));

            if (InitialDMState != null)
                Character.Player.IsDM = (InitialDMState != false);

            Character.Player.Characters.Add(Character);

            try
            {
                CharacterList.Add(Character);

                try
                {
                    if (Character.Online)
                    {
                        Server = ReferenceServerById(ServerId, Database);

                        if (Server == null)
                            throw new ApplicationException(String.Format("Character {0} is online but references invalid server id {1}", Character.CharacterId, ServerId));

                        Character.Server = Server;

                        //
                        // If the character is coming online, but its associated server is
                        // not actually online, then mark the character as offline.
                        //

                        if (Character.Online && !Character.Server.Online)
                        {
                            Character.Online = false;
                            return;
                        }

                        //
                        // Mark the character as visited so that if we come in
                        // on the main thread during the middle of a character
                        // synchronization cycle, we won't immediate offline
                        // the character.
                        //

                        Character.Visited = true;
                        Character.Server = Server;
                        Character.Server.Characters.Add(Character);

                        try
                        {
                            OnlineCharacterList.Add(Character);

                            try
                            {
                                Character.Player.UpdateOnlineCharacter();
                                OnCharacterJoin(Character);
                            }
                            catch
                            {
                                OnlineCharacterList.Remove(Character);
                                throw;
                            }
                        }
                        catch
                        {
                            Character.Server.Characters.Remove(Character);
                            throw;
                        }
                    }
                }
                catch
                {
                    CharacterList.Remove(Character);
                    throw;
                }
            }
            catch
            {
                Character.Player.Characters.Remove(Character);
                Character.Player.UpdateOnlineCharacter();
                throw;
            }
        }

        /// <summary>
        /// This function inserts a player into the various player lists and
        /// issues the player load event.
        /// </summary>
        /// <param name="Player">Supplies the player object to insert.
        /// </param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        private void InsertNewPlayer(GamePlayer Player, IALFADatabase Database)
        {
            PlayerList.Add(Player);
            OnPlayerLoaded(Player);
        }

        /// <summary>
        /// This function inserts a server into the various server lists and
        /// issues the server load event.
        /// </summary>
        /// <param name="Server">Supplies the server object to insert.
        /// </param>
        /// <param name="Database">Supplies the database connection to use for
        /// queries, if required.  The active rowset may be consumed.</param>
        private void InsertNewServer(GameServer Server, IALFADatabase Database)
        {
            //
            // Mark the server as visited so that if we come in on the main
            // thread during the middle of a server synchronization cycle, we
            // won't immediate offline the server.
            //

            Server.Visited = true;
            Server.RefreshOnlineStatus(Database);

            ServerList.Add(Server);
            OnServerLoaded(Server);
        }

        /// <summary>
        /// This thread routine periodically queries the database for new
        /// events and updates the local state cache as appropriate.  It also
        /// enqueues game events to the game event queue as required.
        /// </summary>
        private void QueryDispatchThreadRoutine()
        {
            bool InitialSync = true;

            for (; ; )
            {
                //
                // Run the query cycle and log any exceptions.  Also, block
                // ad-hoc modificatiosn to EventsQueued while we are running
                // the query cycle (as we're prone to long blocking cycles
                // there).
                //

                try
                {
                    BlockEventsQueued = true;

                    if (!PauseUpdates)
                    {
                        //
                        // The first time around, download everything all at
                        // once so we don't have a round-trip for every new
                        // database object referenced.
                        //

                        if (InitialSync)
                        {
                            InitialSync = false;
                            PerformInitialSynchronization();
                        }

                        RunQueryCycle();
                    }

                    BlockEventsQueued = false;

                    //
                    // If we had held back on notifying the main thread that it
                    // should try and dequeue events, notify it now.
                    //

                    if (EventQueueModified)
                    {
                        EventQueueModified = false;
                        EventsQueued = true;
                    }

                    if (DatabaseOnline == false)
                    {
                        DatabaseOnline = true;
                        DistributeDatabaseOnlineNotification(true);
                        OnBroadcastNotification("Database connectivity restored.");
                    }
                }
                catch (Exception e)
                {
                    //
                    // Try and log the exception.  If that fails, don't take
                    // any other actions.

                    try
                    {
                        string ExceptionDescription = e.ToString();

                        WriteDiagnosticLog(String.Format(
                            "GameWorldManager.QueryDispatchThreadRoutine: Exception {0} running query cycle.", ExceptionDescription));

                        if (IsConnectivityFailureException(e, ExceptionDescription))
                        {
                            DatabaseOnline = false;
                            DistributeDatabaseOnlineNotification(false);
                            OnBroadcastNotification("The server-side connection to the database has been lost.");
                        }
                    }
                    catch
                    {

                    }
                }

                QueryThreadWakeupEvent.WaitOne(DATABASE_POLLING_INTERVAL);
            }
        }

        /// <summary>
        /// This method polls the database for changes and updates the game
        /// world state as appropriate.
        /// </summary>
        private void RunQueryCycle()
        {
            DatabasePollCycle += 1;

            //
            // Coalesce and transmit outbound IPC requests.
            //

            TransmitOutboundIPCEvents();

            //
            // Always synchronize the IPC queue.
            //

            SynchronizeIPCEventQueue();

            //
            // Every POLLING_CYCLES_TO_CHARACTER_SYNC cycles, update the online
            // status of characters in the online character list.
            //

            if ((DatabasePollCycle - 1) % POLLING_CYCLES_TO_CHARACTER_SYNC == 0)
                SynchronizeOnlineCharacters();

            //
            // Every POLLING_CYCLES_TO_SERVER_SYNC cycles, update the online
            // status of known servers.
            //

            if ((DatabasePollCycle - 1) % POLLING_CYCLES_TO_SERVER_SYNC == 0)
                SynchronizeOnlineServers();

            //
            // If requested, synchronize updates to the configuration store.
            //

            if (NextCycleSynchronizeConfiguration)
            {
                NextCycleSynchronizeConfiguration = false;
                SynchronizeConfiguration();
            }

            //
            // If requested, refresh the last write time on the timestamp
            // persist variable in the persist store, indicating that the
            // server is still online.
            //

            if (NextCycleUpdateServerCheckinTimestamp)
            {
                NextCycleUpdateServerCheckinTimestamp = false;
                UpdateServerCheckinTimestamp();
            }

            //
            // If we had any general actions that had to be performed on the
            // database query/synchronizer thread, execute the queue now.
            //

            DispatchQueryThreadActions();

#if DEBUG_MODE
            ConsistencyCheck();
#endif
        }

#if DEBUG_MODE
        /// <summary>
        /// This debug routine verifies the consistency of the game world data
        /// model.
        /// </summary>
        private void ConsistencyCheck()
        {
            foreach (GameCharacter Character in OnlineCharacters)
            {
                GameServer Server = Character.Server;

                if (Character.Online == false)
                    throw new ApplicationException("Offline character " + Character.Name + " is in the global online list.");

                if (Server == null)
                    throw new ApplicationException("Character " + Character.CharacterName + " is online at no server.");

                var CharsInList = (from C in Server.Characters
                                   where C == Character
                                   select C);

                if (CharsInList.Count<GameCharacter>() != 1)
                {
                    throw new ApplicationException("Character " + Character.Name + " is in its parent servers character list an incorrect number of times: " + CharsInList.Count<GameCharacter>().ToString());
                }
            }

            foreach (GameServer Server in Servers)
            {
                foreach (GameCharacter Character in Server.Characters)
                {
                    if (Character.Online == false)
                        throw new ApplicationException("Offline character " + Character.Name + " is in server " + Server.Name + " online character list.");

                    if (Character.Server != Server)
                        throw new ApplicationException("Offline character " + Character.Name + " is in server " + Server.Name + " online character list, but claims to be in server " + (Character.Server == null ? "none" : Character.Server.Name) + " online list.");

                    var CharsInList = (from C in OnlineCharacters
                                       where C == Character
                                       select C);

                    if (CharsInList.Count<GameCharacter>() != 1)
                    {
                        throw new ApplicationException("GameServer " + Server.Name + " has online character " + Character.Name + " which is not in the global online list the correct number of times: " + CharsInList.Count<GameCharacter>().ToString());
                    }
                }
            }
        }
#endif

        /// <summary>
        /// This structure contains rowset data for a synchronization round of
        /// the online character query.
        /// </summary>
        private struct SynchronizeOnlineCharactersRow
        {
            public int CharacterId;
            public string LocationString;
            public bool IsDM;
            public int ServerId;
        };

        /// <summary>
        /// This method synchronizes the online character list with the central
        /// database.  Character join or part events are generated, as is
        /// appropriate.
        /// </summary>
        private void SynchronizeOnlineCharacters()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;

            //
            // Query the current player list and synchronize with our internal
            // state.
            //
            // There are several steps here:
            //
            // 1) Mark all online characters as "not visited".
            // 2) Retrieve the character list from the database.  For each
            //    character that wasn't already marked as online, or which has
            //    changed servers, update the state and fire the character join
            //    event.  Also, flag any character that is in the list from the
            //    database as "visited".
            // 3) Sweep the online character list for characters that are still
            //    flagged as "not visited".  These characters are those that
            //    have gone offline in the interim time and which need to have
            //    the character part event fired.
            //

            //
            // First - query the database.  This query returns a list of all
            // online characters from all servers that have checked in in the
            // past ten minutes.  We treat any server that has not checked in
            // within at least that long as having no online players.
            //

            List<SynchronizeOnlineCharactersRow> Rowset = new List<SynchronizeOnlineCharactersRow>();

            Database.ACR_SQLQuery(
                "SELECT " +
                    "`characters`.`ID` AS character_id, " +
                    "`characters`.`Location` as character_location, " +
                    "`players`.`IsDM` AS character_is_dm, " +
                    "`servers`.`ID` AS character_server_id " +
                "FROM `characters` " +
                "INNER JOIN `players` ON `players`.`ID` = `characters`.`PlayerID` " +
                "INNER JOIN `servers` ON `servers`.`ID` = `characters`.`ServerID` " +
                "INNER JOIN `pwdata` ON `pwdata`.`Name` = `servers`.`Name` " +
                "WHERE `characters`.`IsOnline` = 1 " +
                "AND pwdata.`Key` = 'ACR_TIME_SERVERTIME' " +
                "AND pwdata.`Last` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 MINUTE) "
                );

            //
            // Clear visited.
            //
            // N.B.  The Visited flag is only managed on the query thread or
            //       prior to list insertion during initial character creation.
            //
            //       Thus, while we must lock to protect the integrity of the
            //       list, there's no need to worry about another thread
            //       altering the Visited state after we drop the lock.
            //

            lock (this)
            {
                foreach (GameCharacter Character in OnlineCharacters)
                {
                    Character.Visited = false;
                }
            }

            //
            // Read each database row.
            //

            while (Database.ACR_SQLFetch())
            {
                SynchronizeOnlineCharactersRow Row;

                Row.CharacterId = Convert.ToInt32(Database.ACR_SQLGetData(0));
                Row.LocationString = Database.ACR_SQLGetData(1);
                Row.IsDM = ConvertToBoolean(Database.ACR_SQLGetData(2));
                Row.ServerId = Convert.ToInt32(Database.ACR_SQLGetData(3));

                Rowset.Add(Row);
            }

            lock (this)
            {
                //
                // Update entries.
                //

                foreach (SynchronizeOnlineCharactersRow Row in Rowset)
                {
                    int CharacterId = Row.CharacterId;
                    string LocationString = Row.LocationString;
                    bool IsDM = Row.IsDM;
                    int ServerId = Row.ServerId;

                    GameCharacter Character = ReferenceCharacterById(CharacterId, Database, IsDM);
                    GameServer Server = ReferenceServerById(ServerId, Database);

                    //
                    // Update the DM state of the character.
                    //

                    Character.Visited = true;
                    Character.Player.IsDM = IsDM;
                    Character.LocationString = LocationString;

                    if (Character.Server == Server)
                        continue;

                    //
                    // The character changed servers or came online from not
                    // being online, send the appropriate part and join events.
                    //

                    if (Character.Server != null && Character.Online)
                    {
                        OnCharacterPart(Character);
                        Character.Server.Characters.Remove(Character);
                        Character.Server = null;
                        OnlineCharacterList.Remove(Character);
                        Character.Online = false;
                    }

                    //
                    // If the user's server is still marked as offline, mark it
                    // as online now.  It has to have checked in for it to have
                    // been returned in the query as it is.
                    //

                    if (!Server.Online)
                    {
                        Server.Online = true;
                        Server.DatabaseOnline = true;
                        OnServerJoin(Server);
                    }

                    Character.Server = Server;

                    try
                    {
                        Character.Server.Characters.Add(Character);

                        try
                        {
                            OnlineCharacterList.Add(Character);
                        }
                        catch
                        {
                            Character.Server.Characters.Remove(Character);
                            throw;
                        }
                    }
                    catch
                    {
                        Character.Server = null;
                        Character.Online = false;
                        throw;
                    }

                    Character.Online = true;
                    OnCharacterJoin(Character);
                }

                //
                // Sweep offline characters.
                //

                var NowOfflineCharacters = (from C in OnlineCharacters
                                            where C.Visited == false
                                            select C);

                List<GameCharacter> ObjectsToRemove = new List<GameCharacter>(NowOfflineCharacters);

                foreach (GameCharacter Character in ObjectsToRemove)
                {
                    OnCharacterPart(Character);

                    if (Character.Server != null)
                        Character.Server.Characters.Remove(Character);

                    Character.Online = false;
                    OnlineCharacterList.Remove(Character);
                }
            }
        }

        /// <summary>
        /// This structure contains rowset data for a synchronization round of
        /// the online server query.
        /// </summary>
        private struct SynchronizeOnlineServersRow
        {
            public int ServerId;
            public string AddressString;
        };

        /// <summary>
        /// This method synchronizes the online status of the server list.
        /// </summary>
        private void SynchronizeOnlineServers()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;

            //
            // Query the current server list and synchronize with our internal
            // state.
            //
            // There are several steps here:
            //
            // 1) Mark all online servers as "not visited".
            // 2) Retrieve the server list from the database.  For each server
            //    that wasn't already marked as online, mark it as online.
            //    Also, flag any server that is in the list from the database
            //    as "visited".
            // 3) Sweep the online server list for servers that are still
            //    flagged as "not visited".  These servers are those that have
            //    gone offline in the interim time.  Note that we don't yet
            //    update the player list, as that is handled by the player list
            //    synchronization tep.
            //

            //
            // First - query the database.  This query returns a list of all
            // servers that have checked in during the past ten minutes.  We
            // treat any server that has not checked in within at least that
            // long as being offline.
            //

            List<SynchronizeOnlineServersRow> Rowset = new List<SynchronizeOnlineServersRow>();

            Database.ACR_SQLQuery(
                "SELECT " +
                    "`servers`.`ID` AS server_id, " +
                    "`servers`.`IPAddress` as ip_address " +
                "FROM `servers` " +
                "INNER JOIN `pwdata` ON `pwdata`.`Name` = `servers`.`Name` " +
                "WHERE pwdata.`Key` = 'ACR_TIME_SERVERTIME' " +
                "AND pwdata.`Last` >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 MINUTE) "
                );

            //
            // Clear visited.
            //
            // N.B.  The Visited flag is only managed on the query thread or
            //       prior to list insertion during initial server creation.
            //
            //       Thus, while we must lock to protect the integrity of the
            //       list, there's no need to worry about another thread
            //       altering the Visited state after we drop the lock.
            //

            lock (this)
            {
                foreach (GameServer Server in Servers)
                {
                    Server.Visited = false;
                }
            }

            //
            // Read each database row.
            //

            while (Database.ACR_SQLFetch())
            {
                SynchronizeOnlineServersRow Row;

                Row.ServerId = Convert.ToInt32(Database.ACR_SQLGetData(0));
                Row.AddressString = Database.ACR_SQLGetData(1);

                Rowset.Add(Row);
            }

            lock (this)
            {
                //
                // Update entries.
                //

                foreach (SynchronizeOnlineServersRow Row in Rowset)
                {
                    int ServerId = Row.ServerId;
                    string AddressString = Row.AddressString;

                    GameServer Server = ReferenceServerById(ServerId, Database);

                    Server.Visited = true;

                    if (!Server.Online)
                    {
                        Server.Online = true;
                        Server.DatabaseOnline = true;
                        OnServerJoin(Server);
                    }

                    Server.SetHostnameAndPort(AddressString);
                }

                //
                // Sweep offline servers.
                //

                var NowOfflineServers = (from S in Servers
                                         where S.Visited == false &&
                                         S.Online == true
                                         select S);

                List<GameServer> ObjectsToRemove = new List<GameServer>(NowOfflineServers);

                foreach (GameServer Server in ObjectsToRemove)
                {
                    Server.Online = false;
                    Server.DatabaseOnline = false;
                    OnServerPart(Server);
                }
            }

        }

        /// <summary>
        /// This structure contains rowset data for a synchronization round of
        /// the online character query.
        /// </summary>
        private struct SynchronizeIPCEventQueueRow
        {
            public int RecordId;
            public int SourcePlayerId;
            public int SourceServerId;
            public int DestinationPlayerId;
            public int DestinationServerId;
            public int EventType;
            public string EventText;
        };

        /// <summary>
        /// This method synchronizes the IPC event queue for the server.
        /// </summary>
        private void SynchronizeIPCEventQueue()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;
            int HighestRecordId = 0;

            //
            // Retrieve any new IPC events from the database.
            //

            List<SynchronizeIPCEventQueueRow> Rowset = new List<SynchronizeIPCEventQueueRow>();

            Database.ACR_SQLQuery(String.Format(
                "SELECT " +
                    "`server_ipc_events`.`ID` as record_id, " +
                    "`server_ipc_events`.`SourcePlayerID` as source_player_id, " +
                    "`server_ipc_events`.`SourceServerID` as source_server_id, " +
                    "`server_ipc_events`.`DestinationPlayerID` as destination_player_id, " +
                    "`server_ipc_events`.`DestinationServerID` as destination_server_id, " +
                    "`server_ipc_events`.`EventType` as event_type, " +
                    "`server_ipc_events`.`EventText` as event_text " +
                "FROM `server_ipc_events` " +
                "WHERE `server_ipc_events`.`DestinationServerID` = {0} " +
                "GROUP BY record_id " +
                "ORDER BY record_id " +
                "LIMIT 1000 ",
                LocalServerId
                ));

            //
            // Fetch and dispatch each of them.
            //

            try
            {
               while (Database.ACR_SQLFetch())
               {
                   SynchronizeIPCEventQueueRow Row;

                   Row.RecordId = Convert.ToInt32(Database.ACR_SQLGetData(0));
                   Row.SourcePlayerId = Convert.ToInt32(Database.ACR_SQLGetData(1));
                   Row.SourceServerId = Convert.ToInt32(Database.ACR_SQLGetData(2));
                   Row.DestinationPlayerId = Convert.ToInt32(Database.ACR_SQLGetData(3));
                   Row.DestinationServerId = Convert.ToInt32(Database.ACR_SQLGetData(4));
                   Row.EventType = Convert.ToInt32(Database.ACR_SQLGetData(5));
                   Row.EventText = Database.ACR_SQLGetData(6);

                   Rowset.Add(Row);
               }

               foreach (SynchronizeIPCEventQueueRow Row in Rowset)
               {
                   int RecordId = Row.RecordId;
                   int SourcePlayerId = Row.SourcePlayerId;
                   int SourceServerId = Row.SourceServerId;
                   int DestinationPlayerId = Row.DestinationPlayerId;
                   int DestinationServerId = Row.DestinationServerId;
                   int EventType = Row.EventType;
                   string EventText = Row.EventText;

                   HighestRecordId = RecordId;

                   switch (EventType)
                   {

                       case ACR_SERVER_IPC_EVENT_CHAT_TELL:
                           lock (this)
                           {
                               GamePlayer SenderPlayer = ReferencePlayerById(SourcePlayerId, Database);
                               GamePlayer RecipientPlayer = ReferencePlayerById(DestinationPlayerId, Database);

                               if (SenderPlayer == null || RecipientPlayer == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Source {0} or destination {1} player IDs invalid for ACR_SERVER_IPC_EVENT_CHAT_TELL.", SourcePlayerId, DestinationPlayerId));
                                   continue;

                               }

                               GameCharacter SenderCharacter = SenderPlayer.GetOnlineCharacter();
                               GameCharacter RecipientCharacter = RecipientPlayer.GetOnlineCharacter();

                               if (SenderCharacter == null || RecipientCharacter == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Source {0} or destination {1} player has already gone offline for ACR_SERVER_IPC_EVENT_CHAT_TELL.", SourcePlayerId, DestinationPlayerId));
                                   continue;
                               }

                               OnChatTell(SenderCharacter, RecipientPlayer, EventText);
                           }
                           break;

                       case ACR_SERVER_IPC_EVENT_BROADCAST_NOTIFICATION:
                           lock (this)
                           {
                               OnBroadcastNotification(EventText);
                           }
                           break;

                       case ACR_SERVER_IPC_EVENT_DISCONNECT_PLAYER:
                           lock (this)
                           {
                               GamePlayer Player = ReferencePlayerById(DestinationPlayerId, Database);

                               if (Player == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Target player {0} for ACR_SERVER_IPC_EVENT_DISCONNECT_PLAYER is an invalid player id reference.", DestinationPlayerId));
                                   continue;
                               }

                               OnDisconnectPlayer(Player);
                           }
                           break;

                       case ACR_SERVER_IPC_EVENT_PURGE_CACHED_CHARACTER:
                           lock (this)
                           {
                               GamePlayer Player = ReferencePlayerById(DestinationPlayerId, Database);

                               if (Player == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Target player {0} for ACR_SERVER_IPC_EVENT_PURGE_CACHED_CHARACTER is an invalid player id reference.", DestinationPlayerId));
                                   continue;
                               }

                               OnPurgeCachedCharacter(Player, EventText);
                           }
                           break;

                       case ACR_SERVER_IPC_EVENT_SHUTDOWN_SERVER:
                           lock (this)
                           {
                               OnShutdownServer(EventText);
                           }
                           break;

                       case ACR_SERVER_IPC_EVENT_PAGE:
                           lock (this)
                           {
                               GamePlayer SenderPlayer = ReferencePlayerById(SourcePlayerId, Database);
                               GamePlayer RecipientPlayer = ReferencePlayerById(DestinationPlayerId, Database);

                               if (SenderPlayer == null || RecipientPlayer == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Source {0} or destination {1} player IDs invalid for ACR_SERVER_IPC_EVENT_PAGE.", SourcePlayerId, DestinationPlayerId));
                                   continue;
                               }

                               GameCharacter RecipientCharacter = RecipientPlayer.GetOnlineCharacter();

                               if (RecipientCharacter == null)
                               {
                                   WriteDiagnosticLog(String.Format(
                                       "GameWorldManager.SynchronizeIPCEventQueue: Destination {1} player has already gone offline for ACR_SERVER_IPC_EVENT_PAGE.", DestinationPlayerId));
                                   continue;
                               }

                               OnPage(SenderPlayer, RecipientPlayer, EventText);
                           }
                           break;

                       default:
                           lock (this)
                           {
                               OnUnsupportedIPCEventType(RecordId, SourcePlayerId, SourceServerId, DestinationPlayerId, EventType, EventText);
                           }
                           break;

                   }
               }
            }
            finally
            {
               //
               // Now delete all of the records that we processed.
               //

               if (HighestRecordId != 0)
               {
                   Database.ACR_SQLQuery(String.Format(
                       "DELETE FROM `server_ipc_events` WHERE `DestinationServerID` = {0} AND `ID` < {1}",
                       LocalServerId,
                       HighestRecordId + 1));
               }
            }
        }

        /// <summary>
        /// This method transmits locally buffered, outboud IPC events to the
        /// routing entity (e.g. the database).
        /// </summary>
        private void TransmitOutboundIPCEvents()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;
            List<int> ServerIdsToNotify = new List<int>();

            lock (this)
            {
                if (IPCEventQueue.Count == 0)
                    return;

                StringBuilder Query = new StringBuilder(512);

                while (IPCEventQueue.Count != 0)
                {
                    while (Query.Length < TARGET_MAX_QUERY_LENGTH && IPCEventQueue.Count != 0)
                    {
                        IPC_EVENT Event = IPCEventQueue.Dequeue();

                        Query.AppendFormat(
                            "INSERT INTO `server_ipc_events` (`ID`, `SourcePlayerID`, `SourceServerID`, `DestinationPlayerID`, `DestinationServerID`, `EventType`, `EventText`) VALUES (0, {0}, {1}, {2}, {3}, {4}, '{5}');",
                            Event.SourcePlayerId,
                            Event.SourceServerId,
                            Event.DestinationPlayerId,
                            Event.DestinationServerId,
                            Event.EventType,
                            Database.ACR_SQLEncodeSpecialChars(Event.EventText));

                        if (!ServerIdsToNotify.Contains(Event.DestinationServerId))
                            ServerIdsToNotify.Add(Event.DestinationServerId);
                    }

                    Database.ACR_SQLExecute(Query.ToString());
                    Query.Clear();
                }

                //
                // Notify each server that had an entry enqueued that it should
                // wake up to process IPC events.
                //

                foreach (int ServerId in ServerIdsToNotify)
                {
                    GameServer Server = ReferenceServerById(ServerId, null);

                    if (Server != null)
                        ACR_ServerCommunicator.GetNetworkManager().SendMessageIPCWakeup(Server);
                }
            }
        }

        /// <summary>
        /// This method synchronizes the configuration settings block with the
        /// database.
        /// </summary>
        private void SynchronizeConfiguration()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;

            lock (this)
            {
                ConfigurationStore.ReadConfigurationFromDatabase(Database);
            }
        }

        /// <summary>
        /// This method updates the checkin timestamp for ACR_TIME_SERVERTIME,
        /// for the local server.  This must be periodically done from the
        /// query thread, as the main thread's DelayCommand (ACR_StoreTime())
        /// may not run for an extended duration if the server is paused by a
        /// DM.
        /// </summary>
        private void UpdateServerCheckinTimestamp()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;

            Database.ACR_SQLExecute(String.Format(
                "UPDATE `pwdata` SET `Last` = NOW() WHERE `Name` = '{0}' AND `Key` = 'ACR_TIME_SERVERTIME'",
                Database.ACR_SQLEncodeSpecialChars(LocalServerName)));
        }

        /// <summary>
        /// This structure contains rowset data for the initial synchronization
        /// step.
        /// </summary>
        private struct InitialSynchronizationRow
        {
            public int CharacterId;
            public int PlayerId;
            public string CharacterName;
            public int ServerId;
            public string CharacterLocation;
            public bool PlayerIsDM;
            public string PlayerName;
            public string ServerAddressString;
            public string ServerName;
        };

        /// <summary>
        /// This method performs the initial synchronization step at first run
        /// that downloads the initial character list.  A bulk query is issued
        /// here to reduce the number of database round-trips at startup time.
        /// 
        /// Note that no attempt is made to mark offline characters here.  That
        /// step is done in the normal synchronization round, as this is the
        /// initial round anyway.
        /// </summary>
        private void PerformInitialSynchronization()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;
            List<InitialSynchronizationRow> Rowset = new List<InitialSynchronizationRow>();

            Database.ACR_SQLQuery(
                "SELECT " +
                    "`characters`.`ID` AS character_id, " +                  //  0
                    "`characters`.`PlayerID` AS player_id, " +               //  1
                    "`characters`.`Name` AS character_name, " +              //  2
                    "`characters`.`ServerID` AS server_id, " +               //  3
                    "`characters`.`Location` AS character_location, " +      //  4
                    "`players`.`IsDM` AS player_is_dm, " +                   //  5
                    "`players`.`Name` AS player_name, " +                    //  6
                    "`servers`.`IPAddress` AS server_address_string, " +     //  7
                    "`servers`.`Name` AS server_name " +                     //  8
                "FROM " +
                    "`characters` " +
                "INNER JOIN `servers` ON `characters`.`ServerID` = `servers`.`ID` " +
                "INNER JOIN `players` ON `characters`.`PlayerID` = `players`.`ID` " +
                "WHERE " +
                    "`characters`.`IsOnline` = 1 "
                );

            while (Database.ACR_SQLFetch())
            {
                InitialSynchronizationRow Row;

                Row.CharacterId = Convert.ToInt32(Database.ACR_SQLGetData(0));
                Row.PlayerId = Convert.ToInt32(Database.ACR_SQLGetData(1));
                Row.CharacterName = Database.ACR_SQLGetData(2);
                Row.ServerId = Convert.ToInt32(Database.ACR_SQLGetData(3));
                Row.CharacterLocation = Database.ACR_SQLGetData(4);
                Row.PlayerIsDM = ConvertToBoolean(Database.ACR_SQLGetData(5));
                Row.PlayerName = Database.ACR_SQLGetData(6);
                Row.ServerAddressString = Database.ACR_SQLGetData(7);
                Row.ServerName = Database.ACR_SQLGetData(8);

                Rowset.Add(Row);
            }

            lock (this)
            {
                //
                // Update entries.
                //

                foreach (InitialSynchronizationRow Row in Rowset)
                {
                    GameServer Server = (from S in Servers
                                         where S.ServerId == Row.ServerId
                                         select S).FirstOrDefault();

                    if (Server == null)
                    {
                        Server = new GameServer(this);

                        Server.ServerName = Row.ServerName;
                        Server.ServerId = Row.ServerId;
                        Server.SetHostnameAndPort(Row.ServerAddressString);

                        InsertNewServer(Server, Database);
                    }

                    GamePlayer Player = (from P in Players
                                         where P.PlayerId == Row.PlayerId
                                         select P).FirstOrDefault();

                    if (Player == null)
                    {
                        Player = new GamePlayer(this);

                        Player.PlayerName = Row.PlayerName;
                        Player.PlayerId = Row.PlayerId;
                        Player.IsDM = Row.PlayerIsDM;

                        InsertNewPlayer(Player, Database);
                    }

                    GameCharacter Character = (from C in Characters
                                               where C.CharacterId == Row.CharacterId
                                               select C).FirstOrDefault();

                    if (Character == null)
                    {
                        Character = new GameCharacter(this);

                        Character.CharacterId = Row.CharacterId;
                        Character.PlayerId = Row.PlayerId;
                        Character.Online = true;
                        Character.CharacterName = Row.CharacterName;
                        Character.LocationString = Row.CharacterLocation;

                        InsertNewCharacter(Character, Row.ServerId, Database, null);
                    }
                }

#if DEBUG_MODE
                WriteDiagnosticLog(String.Format("GameWorldManager.PerformInitialSynchronization: Synchronized {0} servers, {1} players, {2} characters.",
                    ServerList.Count,
                    PlayerList.Count,
                    CharacterList.Count));
#endif
            }
        }

        /// <summary>
        /// This method dispatches query thread actions that have been queued
        /// to the database query/synchronizer thread.
        /// </summary>
        private void DispatchQueryThreadActions()
        {
            IALFADatabase Database = DatabaseLinkQueryThread;
            QueryThreadAction Action = null;
            uint StartTick = (uint)Environment.TickCount;

            //
            // Loop dispatching query thread actions.  Query thread actions are
            // executed in-order and on the query thread, with a reference to a
            // database object to perform potentially long-running queries.
            //
            // The world manager is NOT locked for the duration of the
            // execution request, and the action queue is also NOT locked for
            // the duration of the execution request.
            //

            for (; ; )
            {
                lock (QueryThreadActionQueue)
                {
                    if (QueryThreadActionQueue.Count == 0)
                        break;

                    Action = QueryThreadActionQueue.Dequeue();
                }

                Action(Database);

                //
                // If we have spent more than the alotted time this cycle in
                // processing generic actions, break out of the loop so that
                // other tasks (such as cross-server communication) have a
                // chance to run.
                //

                if ((uint)Environment.TickCount - StartTick >= QUERY_THREAD_ACTION_QUOTA)
                    break;
            }
        }

        /// <summary>
        /// This timer callback is invoked when the configuration sync timer
        /// has elapsed, in the context of a thread pool thread.  Its purpose
        /// is to record an activation event for the query thread.
        /// </summary>
        /// <param name="StateInfo">This argument is unused.</param>
        private void OnConfigurationSyncTimer(object StateInfo)
        {
            this.NextCycleSynchronizeConfiguration = true;
        }

        /// <summary>
        /// This timer callback is invoked when the update server checkin timer
        /// has elapsed, in the context of a thread pool thread.  Its purpose
        /// is to record an activation event for the query thread.
        /// </summary>
        /// <param name="StateInfo">This argument is unused.</param>
        private void OnUpdateServerCheckinTimer(object StateInfo)
        {
            NextCycleUpdateServerCheckinTimestamp = true;
        }

        /// <summary>
        /// This timer callback is invoked when it is time to rebroadcast the
        /// local server's view of whether the database is online or offline.
        /// </summary>
        /// <param name="StateInfo">This argument is unused.</param>
        private void OnUpdateDatabaseOnlineTimer(object StateInfo)
        {
            //
            // Rebroadcast our current view of the database online/offline
            // status to other servers.
            //

            try
            {
                DistributeDatabaseOnlineNotification(DatabaseOnline);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Convert a database string to a Boolean value.
        /// </summary>
        /// <param name="Str">Supplies the database string.</param>
        /// <returns>The corresponding Boolean value is returned.</returns>
        public static bool ConvertToBoolean(string Str)
        {
            Str = Str.ToLowerInvariant();

            if (Str.StartsWith("t"))
                return true;
            else if (Str.StartsWith("f"))
                return false;
            else
                return Convert.ToInt32(Str) != 0;
        }

        /// <summary>
        /// Start the shutdown server watchdog.  A timer is begun and if the
        /// server has not shut down cleanly before the timer elapses, then the
        /// process is hard aborted.
        /// </summary>
        /// <param name="WatchdogTimeout">Supplies the timeout, in seconds, for
        /// the shutdown watchdog to wait before aborting the process.</param>
        private void StartShutdownWatchdog(int WatchdogTimeout)
        {
            Timer WatchdogTimer;

            WatchdogTimer = new Timer(
                delegate(object State) { Environment.Exit(-1); },
                null,
                WatchdogTimeout * 1000, 
                Timeout.Infinite);

            ShutdownWatchdogTimer = WatchdogTimer;
        }

        /// <summary>
        /// Send a direct, database online/offline status update to all online
        /// servers.  Note that the update is sent as an unreliable datagram so
        /// it is possible that it may never arrive, or may arrive in the wrong
        /// order, etc.  The notification is purely advisory.
        /// </summary>
        /// <param name="Online">Supplies true if the database is considered to
        /// be online.</param>
        private void DistributeDatabaseOnlineNotification(bool Online)
        {
            ServerNetworkManager NetworkManager = ACR_ServerCommunicator.GetNetworkManager();

            lock (this)
            {
                foreach (GameServer Server in Servers)
                {
                    if (!Server.Online)
                        continue;

                    NetworkManager.SendMessageDatabaseStatus(Server, DatabaseOnline);
                }
            }
        }

        /// <summary>
        /// Check whether an exception might be a database connectivity related
        /// exception (versus any other reason).
        /// </summary>
        /// <param name="e">Supplies the exception object.</param>
        /// <param name="Description">Supplies the exception description.
        /// </param>
        /// <returns></returns>
        private static bool IsConnectivityFailureException(Exception e, string Description)
        {
            //
            // This is a giant hack.  Unfortunately the MySQL library doesn't
            // seem to expose any real indication of whether a failure was due
            // to a connectivity related issue or some unrelated cause (such as
            // a server-side processing error).
            //
            // Hence, English-language parse.
            //

            if (Description.Contains("Unable to connect to any of the specified MySQL hosts.") ||
                Description.Contains("A connection attempt failed") ||
                Description.Contains("Timeout in IO operation"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }



        /// <summary>
        /// This datatype wraps a delegate that is executed in the context of
        /// the database query/synchronizer thread.
        /// </summary>
        /// <param name="Database">Supplies the database object ot use when a
        /// query must be issued.</param>
        public delegate void QueryThreadAction(IALFADatabase Database);



        /// <summary>
        /// Chat tell IPC events use this event type.  For this event, there
        /// are five parameters.  The source and destination IDs represent the
        /// routing information for the chat tell originator and destination,
        /// and the event text represents the chat text to deliver.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_CHAT_TELL              = 0;

        /// <summary>
        /// Broadcast notifications use this event type.  For this event, there
        /// are three parameters.  The source and destination server IDs
        /// represent routing information, and the event text represents the
        /// notification text to deliver.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_BROADCAST_NOTIFICATION = 1;

        /// <summary>
        /// Disconnect player requests use this event type.  For this event,
        /// there are three parameters.  The source and destination server IDs
        /// represent routing information, and the destination player ID
        /// represents the player ID of the player to disconnect from the
        /// destination server.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_DISCONNECT_PLAYER      = 2;

        /// <summary>
        /// Requests to remove a locally cached character use this event type.
        /// For this event, there are four parameters.  The source and
        /// destination server IDs represent routing information, and the
        /// destination player ID represents the player whose vault contents
        /// should be modified.  The event text represents the file name of the
        /// locally cached character file to be purged.
        /// 
        /// Note that only the local vault cache, NOT the central server vault,
        /// is modified by this IPC event.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_PURGE_CACHED_CHARACTER = 3;

        /// <summary>
        /// Server shutdown requests use this event type.  For this event,
        /// there are three parameters.  The source and destination server IDs
        /// represent routing information, and the event text represents the
        /// shutdown reason text to deliver before shutting down the server.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_SHUTDOWN_SERVER        = 4;

        /// <summary>
        /// Page IPC events use this event type.  For this event, there are
        /// five parameters.  The source and destination IDs represent the
        /// routing information for the chat tell originator and destination,
        /// and the event text represents the chat text to deliver.
        /// </summary>
        public const int ACR_SERVER_IPC_EVENT_PAGE                   = 5;



        /// <summary>
        /// The count, in milliseconds, between database polling attempts in
        /// the context of the query dispatch thread.
        /// 
        /// Note that polling cycles do not represent a hard time interval
        /// because transaction latency for each database query is added on to
        /// the minimum interval below.  Long term tasks that require
        /// predictable updates should instead use a timer callback that sets a
        /// flag to run a task on the next cycle.
        /// </summary>
        private const int DATABASE_POLLING_INTERVAL = 1000;

        /// <summary>
        /// The number of polling cycles between a server online status
        /// synchronization attempt.
        /// </summary>
        private const int POLLING_CYCLES_TO_SERVER_SYNC = 60;

        /// <summary>
        /// The number of polling cycles between a character synchronization
        /// attempt.
        /// </summary>
        private const int POLLING_CYCLES_TO_CHARACTER_SYNC = 3;

        /// <summary>
        /// The interval between a configuration synchronization attempt.
        /// </summary>
        private const int CONFIGURATION_SYNC_INTERVAL = 1000 * 60 * 60;

        /// <summary>
        /// The interval before the ACR_TIME_SERVERTIME persist store variable
        /// for the server has its Last timestamp bumped forward, to account
        /// for a paused server not running DelayCommand continuations.
        /// </summary>
        private const int UPDATE_SERVER_CHECKIN_INTERVAL = 1000 * 60 * 8;

        /// <summary>
        /// The interval at which database online/offline status messages are
        /// sent to online servers, to resynchronize the state (a periodic
        /// rebroadcast is used as the online/offline state is managed as a
        /// fire-and-forget datagram with no reliability guarantees).
        /// </summary>
        private const int UPDATE_DATABASE_ONLINE_INTERVAL = 1000 * 60 * 10;

        /// <summary>
        /// The maximum target value for combined IPC event queries is stored
        /// here.  This dictates how much data will be coalesced into a single
        /// SQL statement during TransmitOutboundIPCEvents().
        /// </summary>
        private const int TARGET_MAX_QUERY_LENGTH = 16384;

        /// <summary>
        /// The query dispatch thread attempts to spend less than this amount
        /// of time (as expressed in milliseconds) on generic actions in a
        /// given polling cycle.  This ensures that responsiveness for other
        /// tasks, such as cross-server communication, is preserved.
        /// </summary>
        private const uint QUERY_THREAD_ACTION_QUOTA = 1000;


        /// <summary>
        /// The database connection object for the query thread.
        /// </summary>
        private ALFA.MySQLDatabase DatabaseLinkQueryThread = new ALFA.MySQLDatabase();

        /// <summary>
        /// The list of known servers is stored here.
        /// </summary>
        private List<GameServer> ServerList = new List<GameServer>();

        /// <summary>
        /// The list of known players is stored here.  The list may be
        /// incomplete and is expanded on demand.
        /// </summary>
        private List<GamePlayer> PlayerList = new List<GamePlayer>();

        /// <summary>
        /// The list of known characters is stored here.  The list may be
        /// incomplete and is expanded on demand.
        /// </summary>
        private List<GameCharacter> CharacterList = new List<GameCharacter>();

        /// <summary>
        /// The list of characters that are online is stored here.
        /// </summary>
        private List<GameCharacter> OnlineCharacterList = new List<GameCharacter>();

        /// <summary>
        /// The event queue for pending game events that require service from
        /// within an in-script is stored here.
        /// </summary>
        private GameEventQueue EventQueue = null;

        /// <summary>
        /// The thread object for the query dispatch thread is stored here.
        /// </summary>
        private Thread QueryDispatchThread = null;

        /// <summary>
        /// The current polling cycle for the database is stored here.
        /// </summary>
        private int DatabasePollCycle = 0;

        /// <summary>
        /// The server id of the local (current) server is stored here.
        /// </summary>
        private int LocalServerId = 0;

        /// <summary>
        /// The database name (as used in the pwdata field), of the current
        /// (local) server, is stored here.
        /// </summary>
        private string LocalServerName = null;

        /// <summary>
        /// The queue of outbound IPC events awaiting data transmission is
        /// stored here.
        /// </summary>
        private Queue<IPC_EVENT> IPCEventQueue = new Queue<IPC_EVENT>();

        /// <summary>
        /// The queue of delegates to invoke in the context of the database
        /// query/synchronizer thread is stored here.
        /// </summary>
        private Queue<QueryThreadAction> QueryThreadActionQueue = new Queue<QueryThreadAction>();

        /// <summary>
        /// The events queued flag, which allows a caller to quickly check if
        /// there are events to remove before taking the lock, is stored here.
        /// 
        /// Note that it is ok if the caller misses events one cycle.  They
        /// will check again, as we are polling and not operating in an event
        /// driven fashion.
        /// 
        /// The purpose of the flag is to avoid blocking the server main thread
        /// if the query thread happened to do a query under a lock.  While the
        /// query thread attempts to avoid this, it can happen when referencing
        /// a game entity by id for the first time, e.g. when pulling down the
        /// character list initially.
        /// </summary>
        private volatile bool EventsQueued = false;

        /// <summary>
        /// If true, don't actually set EventsQueued immediately.  Used to
        /// allow a batch of data to be processed before we unblock the main
        /// thread, so that it does not spend a long time blocking on the
        /// query thread when it is inserting multiple events under the
        /// lock.
        /// </summary>
        private bool BlockEventsQueued = false;

        /// <summary>
        /// Set to true whenever the event queue is modified.
        /// </summary>
        private bool EventQueueModified = false;

        /// <summary>
        /// This value is set based on whether the database is believed to be
        /// online or accessible.
        /// </summary>
        private bool DatabaseOnline = true;

        /// <summary>
        /// This value is set when it is time to run a configuration sync.  The
        /// next query thread cycle will reset the value.
        /// </summary>
        private volatile bool NextCycleSynchronizeConfiguration = false;

        /// <summary>
        /// This value is set when it is time to run an update server checkin.
        /// The next query thread cycle will reset the value.
        /// </summary>
        private volatile bool NextCycleUpdateServerCheckinTimestamp = false;

        /// <summary>
        /// The early wakeup event for the query thread, which is used to
        /// reduce latency for outbound IPC events, is stored here.  The event
        /// is typically set after pushing an element onto the IPCEventQueue in
        /// order to reduce the processing delay.
        /// </summary>
        private EventWaitHandle QueryThreadWakeupEvent = new EventWaitHandle(false, EventResetMode.AutoReset);

        /// <summary>
        /// This object stores the configuration data for the game world.  The
        /// configuration elements contained herein are backed by the database.
        /// </summary>
        private GameWorldConfiguration ConfigurationStore = new GameWorldConfiguration();

        /// <summary>
        /// The configuration synchronization timer object is stored here.
        /// When fired, it requests that the next update cycle perform a
        /// configuration resync.
        /// </summary>
        private Timer ConfigurationSyncTimer = null;

        /// <summary>
        /// The update server checkin timer object is stored here.  When fired,
        /// it requests that the next update cycle perform a database check-in
        /// to inform monitoring systems that the server is still running.
        /// </summary>
        private Timer UpdateServerCheckinTimer = null;

        /// <summary>
        /// The active shutdown watchdog timer, if any.
        /// </summary>
        private Timer ShutdownWatchdogTimer = null;

        /// <summary>
        /// The timer used to rebroadcast whether the database is viewed to be
        /// online or offline.
        /// </summary>
        private Timer UpdateDatabaseOnlineTimer = null;
    }
}

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
        { typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(int), typeof(string) };

        public Int32 ScriptMain([In] object[] ScriptParameters, [In] Int32 DefaultReturnCode)
        {
            Int32 ReturnCode;
            int RequestType = (int)ScriptParameters[0];

            //
            // If we haven't yet done one time initialization, do so now.
            //

            if (!ScriptInitialized)
            {
                InitializeServerCommunicator();
                ScriptInitialized = true;
            }

            //
            // Now dispatch the command request.
            //

            switch ((REQUEST_TYPE)RequestType)
            {

                case REQUEST_TYPE.INITIALIZE:
                    {
                        ReturnCode = 0;
                    }
                    break;

                case REQUEST_TYPE.SIGNAL_IPC_EVENT:
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
                    break;

                case REQUEST_TYPE.RESOLVE_CHARACTER_NAME_TO_PLAYER_ID:
                    {
                        string CharacterName = (string)ScriptParameters[6];

                        ReturnCode = ResolveCharacterNameToPlayerId(CharacterName);
                    }
                    break;

                case REQUEST_TYPE.RESOLVE_PLAYER_NAME:
                    {
                        string PlayerName = (string)ScriptParameters[6];

                        ReturnCode = ResolvePlayerName(PlayerName);
                    }
                    break;

                case REQUEST_TYPE.RESOLVE_PLAYER_ID_TO_SERVER_ID:
                    {
                        int PlayerId = (int)ScriptParameters[1];

                        ReturnCode = ResolvePlayerIdToServerId(PlayerId);
                    }
                    break;

                case REQUEST_TYPE.LIST_ONLINE_USERS:
                    {
                        uint PlayerObject = OBJECT_SELF;

                        ListOnlineUsers(PlayerObject);

                        ReturnCode = 0;
                    }
                    break;

                case REQUEST_TYPE.HANDLE_CHAT_EVENT:
                    {
                        int ChatMode = (int)ScriptParameters[1];
                        string ChatText = (string)ScriptParameters[6];
                        uint SenderObjectId = OBJECT_SELF;

                        ReturnCode = HandleChatEvent(ChatMode, ChatText, SenderObjectId);
                    }
                    break;

                case REQUEST_TYPE.HANDLE_CLIENT_ENTER:
                    {
                        uint SenderObjectId = OBJECT_SELF;

                        HandleClientEnter(SenderObjectId);

                        ReturnCode = 0;
                    }
                    break;

                default:
                    throw new ApplicationException("Invalid IPC script command " + RequestType.ToString());

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
            if (Database == null)
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

            InsertIPCEventDatabase.ACR_SQLQuery(String.Format(
                "INSERT INTO `server_ipc_events` (`ID`, `SourcePlayerID`, `SourceServerID`, `DestinationPlayerID`, `EventType`, `EventText`) VALUES (0, {0}, {1}, {2}, {3}, '{5}')",
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
                GameCharacter Character = WorldManager.ReferenceCharacterByName(CharacterName, GetDatabase());

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
                GamePlayer Player = WorldManager.ReferencePlayerByName(PlayerName, GetDatabase());

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
                GamePlayer Player = WorldManager.ReferencePlayerById(PlayerId, GetDatabase());

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
                StringBuilder Message = new StringBuilder();
                int UserCount = 0;

                foreach (GameServer Server in OnlineServers)
                    UserCount += Server.Characters.Count;

                Message.AppendFormat("{0} users on {1} servers:", UserCount, OnlineServers.Count<GameServer>());

                foreach (GameServer Server in OnlineServers)
                {
                    Message.AppendFormat("\n-- Server {0} --", Server.ServerName);

                    foreach (GameCharacter Character in Server.Characters)
                    {
                        Message.AppendFormat("\n{2}{0} ({1})", Character.CharacterName, Character.Player.PlayerName, Character.Player.IsDM ? "<c=#99CCFF>[DM] </c>" : "");
                    }
                }

                SendMessageToPC(PlayerObject, Message.ToString());
            }
        }

        /// <summary>
        /// This method dumps the internal state of the game world manager out.
        /// </summary>
        /// <param name="PlayerObject">Supplies the sender player
        /// object.</param>
        private void ShowInternalState(uint PlayerObject)
        {
            lock (WorldManager)
            {
                foreach (GameServer Server in WorldManager.Servers)
                {
                    SendMessageToPC(PlayerObject, String.Format(
                        "Server {0} - online {1}, {2} users.",
                        Server.Name,
                        Server.Online,
                        Server.Characters.Count
                        ));
                }

                foreach (GameCharacter Character in WorldManager.OnlineCharacters)
                {
                    SendMessageToPC(PlayerObject, String.Format(
                        "Online character {0} - player {1}, server {2}",
                        Character.Name,
                        Character.Player.Name,
                        Character.Server.Name));
                }

            }
        }

        /// <summary>
        /// This method filters module chat events.  Its purpose is to check
        /// for commands internal to the server-to-server communication system
        /// and dispatch these as appropriate.
        /// </summary>
        /// <param name="ChatMode">Supplies the chat mode
        /// (e.g. CHAT_MODE_TALK).</param>
        /// <param name="ChatText">Supplies the chat text to send.</param>
        /// <param name="SenderObjectId">Supplies the object id of the sender
        /// object which originated the chat event.</param>
        /// <returns>TRUE if the event was handled internally and should not
        /// undergo further processing in the server, else FALSE if the event
        /// was not handled internally and the server should handle it.
        /// </returns>
        private int HandleChatEvent(int ChatMode, string ChatText, uint SenderObjectId)
        {
            string CookedText;
            string Start;
            TELL_TYPE TellType;

            if (GetIsPC(SenderObjectId) != TRUE)
                return FALSE;

            if (ChatText.Length < 1 || (ChatText[0] != '#' && ChatText[0] != '!' && ChatText[0] != '.'))
                return FALSE;

            //
            // Check for a supported internal command.
            //

            CookedText = ChatText.Substring(1);

            if (CookedText.StartsWith("t "))
            {
                Start = CookedText.Substring(2);
                TellType = TELL_TYPE.ToChar;
            }
            else if (CookedText.StartsWith("tp "))
            {
                Start = CookedText.Substring(3);
                TellType = TELL_TYPE.ToPlayer;
            }
            else if (CookedText.StartsWith("o "))
            {
                Start = CookedText.Substring(2);
                TellType = TELL_TYPE.ToCharFirstName;
            }
            else if (CookedText.StartsWith("re "))
            {
                SendTellReply(SenderObjectId, CookedText.Substring(3), false);
                return TRUE;
            }
            else if (CookedText.StartsWith("r "))
            {
                SendTellReply(SenderObjectId, CookedText.Substring(2), false);
                return TRUE;
            }
            else if (CookedText.StartsWith("rt ") || CookedText.StartsWith("rw" ))
            {
                SendTellReply(SenderObjectId, CookedText.Substring(3), true);
                return TRUE;
            }
            else if (CookedText.Equals("users", StringComparison.InvariantCultureIgnoreCase) ||
                CookedText.Equals("who", StringComparison.InvariantCultureIgnoreCase))
            {
                ListOnlineUsers(SenderObjectId);
                return TRUE;
            }
#if DEBUG_MODE
            else if (CookedText.Equals("showstate", StringComparison.InvariantCultureIgnoreCase))
            {
                ShowInternalState(SenderObjectId);
                return TRUE;
            }
#endif
            else
            {
                return FALSE;
            }

            ProcessTellCommand(Start, SenderObjectId, TellType);
            return TRUE;
        }

        /// <summary>
        /// This method handles ClientEnter events and sends the banner to the
        /// entering PC.
        /// </summary>
        /// <param name="PlayerObject">Supplies the entering PC object id.
        /// </param>
        private void HandleClientEnter(uint PlayerObject)
        {
            if (GetLocalInt(PlayerObject, "ACR_SERVER_IPC_CLIENT_ENTERED") != FALSE)
                return;

            SetLocalInt(PlayerObject, "ACR_SERVER_IPC_CLIENT_ENTERED", TRUE);

            DelayCommand(3.0f, delegate()
            {
                AssignCommand(PlayerObject, delegate()
                {
                    lock (WorldManager)
                    {
                        int OnlineUserCount = WorldManager.OnlineCharacters.Count<GameCharacter>();
                        int OnlineServerCount = 0;

                        foreach (GameServer Server in WorldManager.Servers)
                        {
                            if (!Server.Online)
                                break;

                            OnlineServerCount += 1;
                        }

                        SendMessageToPC(OBJECT_SELF, String.Format(
                            "There are currently {0} player(s) logged in to {1} server(s).  Type \"#users\" for details.",
                            OnlineUserCount,
                            OnlineServerCount));
                    }
                });
            });

            DelayCommand(6.0f, delegate() { SetLocalInt(PlayerObject, "ACR_SERVER_IPC_CLIENT_ENTERED", FALSE); });
        }

        /// <summary>
        /// Parse and act on a tell style internal command.
        /// </summary>
        /// <param name="Start">Supplies the start of the tell command line,
        /// after the command prefix.</param>
        /// <param name="SenderObjectId">Supplies the object id of the object
        /// that initiated the tell request.</param>
        /// <param name="TellType">Supplies the type of tell command that was
        /// requested.</param>
        private void ProcessTellCommand(string Start, uint SenderObjectId, TELL_TYPE TellType)
        {
            //
            // Parse the destination field out.
            //

            string MessagePart;
            string NamePart;
//          int NameStartOffset;
            int NamePartEnd;
            string Destination;
            int Offset;
            GamePlayer Player;

            Destination = Start;

            if (Destination.Length < 2)
                return;

            //
            // Find the end of the name, which is ehter a second double quote,
            // or a space character.
            //

            if (Destination[0] == '\"')
            {
                Offset = Destination.IndexOf('\"', 1);

                if (Offset == -1)
                {
                    SendFeedbackError(SenderObjectId,
                        "Illegal tell command format (unmatched quote in destination).");
                    return;
                }

                Destination = Destination.Substring(0, Offset);

                NamePart = Destination.Substring(1); // Past the first quote
                NamePartEnd = Offset;
                MessagePart = Start.Substring(1 + Offset);
//              NameStartOffset = 1;

                //
                // Eat up to one single trailing space.
                //

                if (MessagePart.Length > 1 && Char.IsWhiteSpace(MessagePart[0]))
                    MessagePart = MessagePart.Substring(1);
            }
            else
            {
                Offset = Destination.IndexOf(' ');

                if (Offset == -1)
                {
                    SendFeedbackError(SenderObjectId,
                        "Illegal tell command format (missing destination).");
                    return;
                }

                Destination = Destination.Substring(0, Offset);

                NamePart = Destination;
                NamePartEnd = Offset;
                MessagePart = Start.Substring(Offset + 1); // After the space
//              NameStartOffset = 0;
            }

            if (String.IsNullOrEmpty(Destination))
            {
                SendFeedbackError(SenderObjectId,
                    "Illegal tell command format (empty destination).");
                return;
            }

            //
            // Message is parsed.  Figure out how to resolve the target name
            // and deliver it as appropriate.
            //

            lock (WorldManager)
            {
                switch (TellType)
                {

                    case TELL_TYPE.ToChar:
                        {
                            GameCharacter Character = WorldManager.ReferenceCharacterByName(NamePart, GetDatabase());

                            if (Character != null && Character.Online)
                                Player = Character.Player;
                            else
                            {
                                Player = null;
                                SendFeedbackError(SenderObjectId, "That player is not logged on.");
                                return;
                            }

                            /*
                            string First;
                            string Last;

                            //
                            // Note that we might have a last name along for the
                            // ride.  Split it out if we can.
                            //

                            First = NamePart;
                            Last = null;

                            if ((Offset = First.IndexOf(' ')) != -1)
                            {
                                First = First.Substring(0, Offset);
                                Last = NamePart + Offset + 1; // Skip the space.
                            }

                            Player = GetPlayerByName(First, Last);

                            if (Player == null && !String.IsNullOrEmpty(Last))
                            {
                                //
                                // If the last name was all spaces, then retry
                                // without a last name.
                                //

                                if (String.IsNullOrWhiteSpace(Last))
                                    Player = GetPlayerByName(First, null);

                                //
                                // If we still don't have a match, the player could
                                // have a first name of the form "first name", with
                                // spaces and trailing characters.  Just try and
                                // resolve it as the entire first name.
                                //

                                if (Player == null && Destination[0] == '\"')
                                {
                                    string NameStart;

                                    NameStart = Start.Substring(NameStartOffset);
                                    First = NameStart.Substring(NamePartEnd - NameStartOffset);

                                    Player = GetPlayerByName(First, null);

                                    //
                                    // Try stripping spaces from the end too.
                                    //

                                    if (Player == null && First.Length > 1)
                                    {
                                        if (First[First.Length - 1] == ' ')
                                            First = First.Substring(0, First.Length - 1);

                                        Player = GetPlayerByName(First, null);
                                    }
                                }
                            }*/
                        }
                        break;

                    case TELL_TYPE.ToPlayer:
                        {
                            //
                            // Look it up by account name.
                            //

                            Player = WorldManager.ReferencePlayerByName(NamePart, GetDatabase());
                            /*
                            Player = GetPlayerByAccountName(NamePart);
                             * */
                        }
                        break;

                    case TELL_TYPE.ToCharFirstName:
                        {
                            Player = GetPlayerByFirstName(NamePart);
                        }
                        break;

                    default:
                        return;

                }

                if (Player == null)
                {
                    SendFeedbackError(SenderObjectId, "Player not found.");
                }
                else
                {
                    SetLastTellToPlayerId(SenderObjectId, Player.PlayerId);
                    SendServerToServerTell(
                        SenderObjectId,
                        WorldManager.ReferencePlayerById(GetDatabase().ACR_GetPlayerID(SenderObjectId), GetDatabase()),
                        Player,
                        MessagePart);
                }
            }
        }

        /// <summary>
        /// Send a feedback error message to a player.
        /// </summary>
        /// <param name="PlayerObjectId">Supplies the player to send the
        /// message to.</param>
        /// <param name="Message">Suipplies the error message.</param>
        private void SendFeedbackError(uint PlayerObjectId, string Message)
        {
            SendChatMessage(
                OBJECT_INVALID,
                PlayerObjectId,
                CHAT_MODE_SERVER,
                "<c=red>Error: " + Message + "</c>",
                FALSE);
        }

        /// <summary>
        /// Get a local player by character name.
        /// </summary>
        /// <param name="First">Supplies the character first name.</param>
        /// <param name="Last">Optionally supplies the character last name.
        /// </param>
        /// <returns>The matched PC object id, else OBJECT_INVALID.</returns>
        public uint GetLocalPlayerByName(string First, string Last)
        {
            foreach (uint PlayerObject in GetPlayers(true))
            {
                if (GetFirstName(PlayerObject) != First)
                    continue;

                if (String.IsNullOrEmpty(Last))
                {
                    if (!String.IsNullOrEmpty(GetLastName(PlayerObject)))
                        continue;
                }
                else
                {
                    if (GetLastName(PlayerObject) != Last)
                        continue;
                }

                return PlayerObject;
            }

            string SearchDisplayName;
            string ThisDisplayName;

            //
            // Make a final pass that checks against the display names of
            // players in the game, to handle oddly named players (such as
            // those with spaces in their first name).
            //
            // N.B.  This match is ambiguous.
            //

            SearchDisplayName = First;

            if (Last != null)
            {
                SearchDisplayName += " ";
                SearchDisplayName += Last;
            }

            foreach (uint PlayerObject in GetPlayers(true))
            {
                string ThisLast;

                ThisDisplayName = GetFirstName(PlayerObject);
                ThisLast = GetLastName(PlayerObject);

                if (!String.IsNullOrEmpty(ThisLast))
                {
                    ThisDisplayName += " ";
                    ThisDisplayName += ThisLast;
                }

                if (ThisDisplayName != SearchDisplayName)
                    continue;

                return PlayerObject;
            }

            return OBJECT_INVALID;
        }

        /// <summary>
        /// Get a global player by character name.
        /// </summary>
        /// <param name="First">Supplies the character first name.</param>
        /// <param name="Last">Optionally supplies the character last name.
        /// </param>
        /// <returns>The matched player, else null.</returns>
        private GamePlayer GetPlayerByName(string First, string Last)
        {
            uint LocalPlayerObject = GetLocalPlayerByName(First, Last);

            if (LocalPlayerObject != OBJECT_INVALID)
                return WorldManager.ReferencePlayerById(GetDatabase().ACR_GetPlayerID(LocalPlayerObject), GetDatabase());

            string Name = First;

            if (!String.IsNullOrEmpty(Last))
            {
                Name += " ";
                Name += Last;
            }

            GameCharacter Character = WorldManager.ReferenceCharacterByName(Name, GetDatabase());

            if (Character == null)
                return null;

            return Character.Player;
        }

        /// <summary>
        /// Get a local player by account name.
        /// </summary>
        /// <param name="AccountName">Supplies the account name to look for.
        /// </param>
        /// <returns>The matched PC object id, else OBJECT_INVALID.</returns>
        public uint GetLocalPlayerByAccountName(string AccountName)
        {
            foreach (uint PlayerObject in GetPlayers(true))
            {
                if (GetPCPlayerName(PlayerObject) == AccountName)
                    return PlayerObject;
            }

            return OBJECT_INVALID;
        }

        /// <summary>
        /// Get a global player by account name.
        /// </summary>
        /// <param name="AccountName">Supplies the account name to look for.
        /// </param>
        /// <returns>The matched player, else null.</returns>
        private GamePlayer GetPlayerByAccountName(string AccountName)
        {
            uint LocalPlayerObject = GetLocalPlayerByAccountName(AccountName);

            if (LocalPlayerObject != OBJECT_INVALID)
                return WorldManager.ReferencePlayerById(GetDatabase().ACR_GetPlayerID(LocalPlayerObject), GetDatabase());

            GamePlayer Player = WorldManager.ReferencePlayerByName(AccountName, GetDatabase());

            if (Player == null)
                return null;

            return Player;
        }

        /// <summary>
        /// Get a local player by (ambiguous) first name lookup.
        /// </summary>
        /// <param name="FirstName">Supplies the first name to search for.
        /// </param>
        /// <returns>The matched PC object id, else OBJECT_INVALID.</returns>
        public uint GetLocalPlayerByFirstName(string FirstName)
        {
            foreach (uint PlayerObject in GetPlayers(true))
            {
                if (GetFirstName(PlayerObject) == FirstName)
                    return PlayerObject;
            }

            return OBJECT_INVALID;
        }

        /// <summary>
        /// Get a global player by (ambiguous) first name lookup.
        /// 
        /// Note that only locally resolveable players can be searched with the
        /// ambiguous lookup mode.
        /// </summary>
        /// <param name="FirstName">Supplies the first name to search for.
        /// </param>
        /// <returns>The matched player, else null.</returns>
        private GamePlayer GetPlayerByFirstName(string FirstName)
        {
            uint LocalPlayerObject = GetLocalPlayerByFirstName(FirstName);

            if (LocalPlayerObject != OBJECT_INVALID)
                return WorldManager.ReferencePlayerById(GetDatabase().ACR_GetPlayerID(LocalPlayerObject), GetDatabase());

            return null;
        }

        /// <summary>
        /// Set the last send tell to player id for a player.
        /// </summary>
        /// <param name="PlayerObject">Supplies the player that sent the
        /// tell.</param>
        /// <param name="PlayerId">Supplies the player id that the player last
        /// sent a tell to.</param>
        public void SetLastTellToPlayerId(uint PlayerObject, int PlayerId)
        {
            SetLocalInt(PlayerObject, "ACR_MOD_LAST_TELL_TO", PlayerId);
        }

        /// <summary>
        /// Get the last send tell to player id for a player.
        /// </summary>
        /// <param name="PlayerObject">Supplies the player whose last send tell
        /// to player id is to be retrieved.</param>
        /// <returns>The player id that the player had last sent a tell to is
        /// returned, else zero.</returns>
        public int GetLastTellToPlayerId(uint PlayerObject)
        {
            return GetLocalInt(PlayerObject, "ACR_MOD_LAST_TELL_TO");
        }

        /// <summary>
        /// Set the last receive tell from player id for a player.
        /// </summary>
        /// <param name="PlayerObject">Supplies the player to set the value
        /// for.</param>
        /// <param name="PlayerId">Supplies the player id that last sent a tell
        /// to the player.</param>
        public void SetLastTellFromPlayerId(uint PlayerObject, int PlayerId)
        {
            SetLocalInt(PlayerObject, "ACR_MOD_LAST_TELL_FROM", PlayerId);
        }

        /// <summary>
        /// Get the last receive tell from player id for a player.
        /// </summary>
        /// <param name="PlayerObject">Supplies the player to query.
        /// <returns>The player id that had last sent a tell to the player is
        /// returned, else zero.</returns>
        public int GetLastTellFromPlayerId(uint PlayerObject)
        {
            return GetLocalInt(PlayerObject, "ACR_MOD_LAST_TELL_FROM");
        }

        /// <summary>
        /// This method initiates a server-to-server tell.
        /// </summary>
        /// <param name="SenderObjectId">Supplies the local object id of the
        /// sender player.</param>
        /// <param name="SenderPlayer">Supplies the GamePlayer object for the
        /// sender player.</param>
        /// <param name="RecipientPlayer">Supplies the GamePlayer object for
        /// the recipient player.</param>
        /// <param name="Message">Supplies the message to send.</param>
        private void SendServerToServerTell(uint SenderObjectId, GamePlayer SenderPlayer, GamePlayer RecipientPlayer, string Message)
        {
            GameServer DestinationServer = RecipientPlayer.GetOnlineServer();

            if (!RecipientPlayer.IsOnline() || DestinationServer == null)
            {
                SendFeedbackError(SenderObjectId, "That player is not logged on.");
                return;
            }


#if DEBUG_MODE
            //
            // Debug mode always sends through the IPC queue for better
            // testing.
            //
#else
            //
            // If this is a local server tell, dispatch it locally.
            //

            if (DestinationServer.ServerId == Database.ACR_GetServerID())
            {
                foreach (uint PlayerObject in GetPlayers(true))
                {
                    if (Database.ACR_GetPlayerID(PlayerObject) != SenderPlayer.PlayerId)
                        continue;

                    //
                    // Note, we call the chat callback for the first event for
                    // two reasons:
                    //
                    // 1) Let the RP XP script notice the activity.
                    // 2) Set the last tell to/from player ids.
                    //

                    SendChatMessage(SenderObjectId, PlayerObject, CHAT_MODE_TELL, Message, TRUE);
                    return;
                }

                SendFeedbackError(SenderObjectId, "Internal error - attempted to re-route tell to local player, but player wasn't actually on this server.");
                return;
            }
#endif

            //
            // Otherwise, enqueue it.
            //

            if (Message.Length > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
            {
                Message = Message.Substring(ACR_SERVER_IPC_MAX_EVENT_LENGTH);

                SendFeedbackError(SenderObjectId,
                    String.Format("Message sent, but truncated to {0} characters: '{1}'.", ACR_SERVER_IPC_MAX_EVENT_LENGTH, Message));
            }

            SignalIPCEvent(
                SenderPlayer.PlayerId,
                Database.ACR_GetServerID(),
                RecipientPlayer.PlayerId,
                DestinationServer.ServerId,
                GameWorldManager.ACR_SERVER_IPC_EVENT_CHAT_TELL,
                Message);
            SetLocalInt(SenderObjectId, "ACR_XP_RPXP_ACTIVE", TRUE);
            SendChatMessage(
                OBJECT_INVALID,
                SenderObjectId,
                CHAT_MODE_SERVER,
                String.Format("<c=#FFCC99>{0}: </c><c=#30DDCC>[ServerTell] {1}</c>", RecipientPlayer.GetOnlineCharacter().CharacterName, Message),
                FALSE);
        }

        /// <summary>
        /// This method sends a reply tell to the last tell sender.
        /// </summary>
        /// <param name="SenderObjectId">Supplies the player that is to send
        /// the reply.</param>
        /// <param name="Message">Supplies the reply message.</param>
        /// <param name="ReTell">Supplies true if the message is to be sent to
        /// the last player we sent a tell to, else false if the message is to
        /// be sent to the last player that sent a tell to us.</param>
        private void SendTellReply(uint SenderObjectId, string Message, bool ReTell)
        {
            lock (WorldManager)
            {
                GamePlayer Sender = WorldManager.ReferencePlayerById(GetDatabase().ACR_GetPlayerID(SenderObjectId), GetDatabase());
                GamePlayer Recipient;
                int RecipientId;

                if (ReTell)
                {
                    RecipientId = GetLastTellToPlayerId(SenderObjectId);

                    if (RecipientId == 0)
                    {
                        SendFeedbackError(SenderObjectId, "You haven't sent a tell yet.");
                        return;
                    }
                }
                else
                {
                    RecipientId = GetLastTellFromPlayerId(SenderObjectId);

                    if (RecipientId == 0)
                    {
                        SendFeedbackError(SenderObjectId, "No one has sent you a tell yet.");
                        return;
                    }
                }

                Recipient = WorldManager.ReferencePlayerById(RecipientId, GetDatabase());

                if (Recipient == null)
                {
                    SendFeedbackError(SenderObjectId, "Internal error: Recipient doesn't exist anymore.");
                    return;
                }

                if (!Recipient.IsOnline())
                {
                    SendFeedbackError(SenderObjectId, "That player is no longer online.");
                    return;
                }

                SendServerToServerTell(SenderObjectId, Sender, Recipient, Message);
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
            //
            // If we were requested by script to pause updates, then stop now.
            //

            WorldManager.PauseUpdates = (GetGlobalInt("ACR_SERVER_IPC_PAUSED") != 0);

            lock (WorldManager)
            {
                if (WorldManager.IsEventQueueEmpty())
                    return;

                WorldManager.RunQueue(this, Database);
            }
        }

        /// <summary>
        /// Get the associated database object, creating it on demand if
        /// required.
        /// </summary>
        /// <returns>The database connection object.</returns>
        private ALFA.Database GetDatabase()
        {
            if (Database == null)
                Database = new ALFA.Database(this);

            return Database;
        }

        /// <summary>
        /// Define types of tell commands.
        /// </summary>
        private enum TELL_TYPE
        {
            ToChar,           // t "character name"
            ToPlayer,         // tp "player name"
            ToCharFirstName   // o "characterfirstname"
        }

        /// <summary>
        /// Define type codes for requests to ScriptMain.
        /// </summary>
        private enum REQUEST_TYPE
        {
            INITIALIZE,
            SIGNAL_IPC_EVENT,
            RESOLVE_CHARACTER_NAME_TO_PLAYER_ID,
            RESOLVE_PLAYER_NAME,
            RESOLVE_PLAYER_ID_TO_SERVER_ID,
            LIST_ONLINE_USERS,
            HANDLE_CHAT_EVENT,
            HANDLE_CLIENT_ENTER
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
        /// The database object that is used to insert IPC events is stored
        /// here.  This is generally NOT the main ALFA.Database so that its
        /// contents are not subject to logging.
        /// </summary>
        private static MySQLDatabase InsertIPCEventDatabase = new ALFA.MySQLDatabase();

        /// <summary>
        /// The interop SQL database instance is stored here.
        /// </summary>
        private ALFA.Database Database = null;
    }
}

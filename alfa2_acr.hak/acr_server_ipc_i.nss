////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_server_ipc_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-04#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: SERVER_IPC
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(acr_servercommunicator)
//
//  Description
//  This file contains logic for interfacing with the server IPC system.
//
//  Revision History
//  2012/01/04  Basilica    - Created.
//  2012/01/21  Basilica    - Added latency measure support.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_settings_i"
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Define to 1 to enable server IPC support.

#define SERVER_IPC_ENABLED 1

// The IPC C# script name.
const string ACR_SERVER_IPC_SERVERCOM_SCRIPT                 = "acr_servercommunicator";


// Commands for the IPC C# script:

// This command requests that initialization be performed for module startup.
const int ACR_SERVER_IPC_INITIALIZE                          = 0;

// This command requests that an IPC event be signaled.
const int ACR_SERVER_IPC_SIGNAL_IPC_EVENT                    = 1;

// This command resolves a character name to a player id.
const int ACR_SERVER_IPC_RESOLVE_CHARACTER_NAME_TO_PLAYER_ID = 2;

// This command resolves a player name to a player id.
const int ACR_SERVER_IPC_RESOLVE_PLAYER_NAME                 = 3;

// This command resolves a player id to an active server id.
const int ACR_SERVER_IPC_RESOLVE_PLAYER_ID_TO_SERVER_ID      = 4;

// This command lists online players to the current PC.
const int ACR_SERVER_IPC_LIST_ONLINE_USERS                   = 5;

// This command handles chat events for IPC commands.
const int ACR_SERVER_IPC_HANDLE_CHAT_EVENT                   = 6;

// This command handles client enter events.
const int ACR_SERVER_IPC_HANDLE_CLIENT_ENTER                 = 7;

// This command returns whether a server is online (by server id).
const int ACR_SERVER_IPC_IS_SERVER_ONLINE                    = 8;

// This command activates a server to server portal.
const int ACR_SERVER_IPC_ACTIVATE_SERVER_TO_SERVER_PORTAL    = 9;

// This command handles client leave events.
const int ACR_SERVER_IPC_HANDLE_CLIENT_LEAVE                 = 10;

// This command populates the chat select GUI window.
const int ACR_SERVER_IPC_POPULATE_CHAT_SELECT                = 11;

// This command completes a latency check for a player.
const int ACR_SERVER_IPC_HANDLE_LATENCY_CHECK_RESPONSE       = 12;

// This command retrieves the last latency measurement for a player.
const int ACR_SERVER_IPC_GET_PLAYER_LATENCY                  = 13;

// IPC event codes:

// The chat tell event is used to transport tells cross-server.
const int ACR_SERVER_IPC_EVENT_CHAT_TELL                     = 0;

// The broadcast notification event is used to transport a broadcast
// announcement cross-server.
const int ACR_SERVER_IPC_EVENT_BROADCAST_NOTIFICATION        = 1;

// The disconnect player event is used to disconnect a remote player.
const int ACR_SERVER_IPC_EVENT_DISCONNECT_PLAYER             = 2;

// The purge cached character event is used to remove a stale character cached
// in a server local vault cache after central character deletion.
const int ACR_SERVER_IPC_EVENT_PURGE_CACHED_CHARACTER        = 3;

// The server shutdown event is used to request that a server shut down or
// restart (in the default configuration).  Only the game server process is
// restarted, not the operating system.
const int ACR_SERVER_IPC_EVENT_SHUTDOWN_SERVER               = 4;

// Maximum length of an IPC event text field.

const int ACR_SERVER_IPC_MAX_EVENT_LENGTH                    = 256;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct ACR_SERVER_IPC_EVENT
{
	int SourcePlayerID;
	int SourceServerID;
	int DestinationPlayerID;
	int DestinationServerID;
	int EventType;
	string EventText;
};

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Signal an IPC event.
//!  - IPCEvent: Supplies the IPC event data for the event to signal.
void ACR_SignalServerIPCEvent(struct ACR_SERVER_IPC_EVENT IPCEvent);

//! Handle module load and start up the IPC subsystem.
void ACR_ServerIPC_OnModuleLoad();

//! Handle client enter and send the banner to the player if needed.
void ACR_ServerIPC_OnClientEnter(object EnteringPC);

//! Handle chat events for server IPC subsystem commands.
//!  - Returns: TRUE if the event was handled locally and should not be
//              processed by the server further.
int ACR_ServerIPC_OnChat(object Speaker, int Mode, string Text);

//! Signal a cross server chat tell by character name.
//!  - Sender: Supplies the PC that sent the message, else OBJECT_INVALID.
//!  - CharacterName: Supplies the destination character name.
//!  - TellText: Supplies the tell text to send.
void ACR_SendCrossServerTellByCharacter(object Sender, string CharacterName, string TellText);

//! Signal a cross server chat tell by player name.
//!  - Sender: Supplies the PC that sent the message, else OBJECT_INVALID.
//!  - PlayerName: Supplies the destination player name.
//!  - TellText: Supplies the tell text to send.
void ACR_SendCrossServerTellByPlayer(object Sender, string PlayerName, string TellText);

//! Send a broadcast message to the desired server.
//!  - ServerID: Supplies the server ID of the recipient server.
//!  - Message: Supplies the message to broadcast.
void ACR_SendBroadcastNotification(int ServerID, string Message);

//! Send a disconnect player request to the desired server.
//!  - ServerID: Supplies the server ID of the recipient server.
//!  - PlayerID: Supplies the player ID of the player to disconnect.
void ACR_SendDisconnectPlayer(int ServerID, int PlayerID);

//! Send a purge cached character request to the desired server.
//!  - ServerID: Supplies the server ID of the recipient server.
//!  - PlayerID: Supplies the player ID of the player whose vault cache should
//               be modified.
//!  - CharacterFileName: Supplies the character file name ("character.bic")
//                        that should be removed from the target server's vault
//                        cache (NOT the central vault itself).
void ACR_SendPurgeCachedCharacter(int ServerID, int PlayerID, string CharacterFileName);

//! Send a shutdown request to the desired server.
//!  - ServerID: Supplies the server ID of the recipient server.
//!  - Message: Supplies the message to broadcast (shutdown reason).
void ACR_SendShutdownServer(int ServerID, string Message);

//! Request that a text mode player list be sent to a user.
//!  - Sender: Supplies the PC to send the player list to.
void ACR_SendOnlineUserList(object Player);

//! Handle client leave and clean up internal player state.
void ACR_ServerIPC_OnClientEnter(object LeavingPC);

//! Send a feedback error message to a player.
//!  - Target: Supplies the player to send the message to.
//!  - Message: Supplies the error message.
void ACR_SendFeedbackError(object Target, string Message);

//! Deliver a server tell to a local player.  This is used when a server to
//  server tell is initiated, but it is then discovered that the destination of
//  the tell is actually on the local server.
//!  - Sender: Supplies the sender object.
//!  - PlayerID: Supplies the player id of the player to deliver the message
//               to.
//!  - Message: Supplies the tell text to deliver.
void ACR_DeliverLocalTell(object Sender, int PlayerID, string Message);

//! Deliver the confirmation message to the local sender of a cross server
//  tell.
//!  - Sender: Supplies the local sender.
//!  - Recipient: Supplies the recipient designator text.
//!  - Message: Supplies the tell text that was delivered.
void ACR_DeliverCrossServerTellConfirmation(object Sender, string Recipient, string Message);

//! Given a player ID for a player on the local server, return the PC object
//  for that player.
//!  - PlayerID: Supplies the player id of a player on this server.
//!  - Returns: The PC object of the player, else OBJECT_INVALID.
object ACR_GetLocalPlayerByPlayerID(int PlayerID);

//! Translate a character name to player id.
//!  - CharacterName: Supplies the character name to translate.
//!  - Returns: The player ID, else 0 if there was no mapping.
int ACR_GetPlayerIDByCharacterName(string CharacterName);

//! Translate a player name to player id.
//!  - PlayerName: Supplies the player name to translate.
//!  - Returns: The player ID, else 0 if there was no mapping.
int ACR_GetPlayerIDByPlayerName(string PlayerName);

//! Translate a player id to an active server id.
//!  - PlayerID: Supplies the player id to look up the logged on server for.
//!  - Returns: The server ID of the players logged on server, else 0 if they
//              were not logged on.
int ACR_GetPlayerLoggedOnServerID(int PlayerID);

//! Check whether a server is online and responding.
//!  - ServerID: Supplies the server id to query.
//!  - Returns: TRUE if the server is online and responding (has pinged the
//             database within the past 10 minutes or so).
int ACR_GetIsServerOnline(int ServerID);

//! Initiate the server to server portalling process for a player.  The
//  process doesn't complete immediately, but may take some time.  The
//  player should already have a passport assigned.
//!  - ServerID: Supplies the destination server id.
//!  - PortalID: Supplies the portal id.
//!  - PlayerObject: Supplies the player object to portal.
void ACR_StartServerToServerPortal(int ServerID, int PortalID, object PlayerObject);

//! Requests that the Chat Select GUI for a player be populated with entirely
//  new contents, e.g. for opening the dialog.
//!  - PlayerObject: Supplies the player object whose GUI should be refreshed.
void ACR_PopulateChatSelect(object PlayerObject);

//! Handle a latency check response to update the player's round trip latency.
//!  - PlayerObject: Supplies the player object that has completed a round trip
//                   latency/ping check transaction.
void ACR_HandleLatencyCheckResponse(object PlayerObject);

//! Get the last latency measurement for a player.
//!  - PlayerObject: Supplies the PC object of the player to inquire about.
//!  - Returns: The player's last reported latency, in milliseconds.
int ACR_GetPlayerLatency(object PlayerObject);

//! Make a raw call to the IPC C# control script.
//!  - Command: Supplies the command to request (e.g. ACR_SERVER_IPC_SIGNAL_IPC_EVENT).
//!  - P0: Supplies the first command-specific parameter.
//!  - P1: Supplies the second command-specific parameter.
//!  - P2: Supplies the third command-specific parameter.
//!  - P3: Supplies the fourth command-specific parameter.
//!  - P4: Supplies the fifth command-specific parameter.
//!  - P5: Supplies the sixth command-specific parameter.
//!  - ObjectSelf: Supplies the OBJECT_SELF to run the script on.
//!  - Returns: The command-specific return code is returned.
int ACR_CallIPCScript(int Command, int P0, int P1, int P2, int P3, int P4, string P5, object ObjectSelf = OBJECT_SELF);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SendCrossServerTellByCharacter(object Sender, string CharacterName, string TellText)
{
	int PlayerID = ACR_GetPlayerIDByCharacterName(CharacterName);
	int ServerID;
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	if (PlayerID == 0)
	{
		ACR_SendFeedbackError(Sender, "Unknown character " + CharacterName + ".");
		return;
	}

	ServerID = ACR_GetPlayerLoggedOnServerID(PlayerID);

	if (ServerID == 0)
	{
		ACR_SendFeedbackError(Sender, "That player is not logged on.");
		return;
	}

	// If we are delivering the message to a player on this server, send it
	// directly.  Otherwise, use the IPC queue.
	if (ServerID == ACR_GetServerID())
	{
		ACR_DeliverLocalTell(Sender, PlayerID, TellText);
		return;
	}

	if (GetStringLength(TellText) > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
	{
		TellText = GetStringLeft(TellText, ACR_SERVER_IPC_MAX_EVENT_LENGTH);
		ACR_SendFeedbackError(Sender, "Message sent, but truncated to " + IntToString(ACR_SERVER_IPC_MAX_EVENT_LENGTH) + " characters: '" + TellText + "'.");
	}

	IPCEvent.SourcePlayerID = ACR_GetPlayerID(Sender);
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = PlayerID;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_CHAT_TELL;
	IPCEvent.EventText = TellText;

	ACR_SignalServerIPCEvent(IPCEvent);
	ACR_DeliverCrossServerTellConfirmation(Sender, CharacterName, TellText);
}

void ACR_SendCrossServerTellByPlayer(object Sender, string PlayerName, string TellText)
{
	int PlayerID = ACR_GetPlayerIDByPlayerName(PlayerName);
	int ServerID;
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	if (PlayerID == 0)
	{
		ACR_SendFeedbackError(Sender, "Unknown player " + PlayerName + ".");
		return;
	}

	ServerID = ACR_GetPlayerLoggedOnServerID(PlayerID);

	if (ServerID == 0)
	{
		ACR_SendFeedbackError(Sender, "That player is not logged on.");
		return;
	}

	// If we are delivering the message to a player on this server, send it
	// directly.  Otherwise, use the IPC queue.
	if (ServerID == ACR_GetServerID())
	{
		ACR_DeliverLocalTell(Sender, PlayerID, TellText);
		return;
	}

	if (GetStringLength(TellText) > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
	{
		TellText = GetStringLeft(TellText, ACR_SERVER_IPC_MAX_EVENT_LENGTH);
		ACR_SendFeedbackError(Sender, "Message sent, but truncated to " + IntToString(ACR_SERVER_IPC_MAX_EVENT_LENGTH) + " characters: '" + TellText + "'.");
	}

	IPCEvent.SourcePlayerID = ACR_GetPlayerID(Sender);
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = PlayerID;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_CHAT_TELL;
	IPCEvent.EventText = TellText;

	ACR_SignalServerIPCEvent(IPCEvent);
	ACR_DeliverCrossServerTellConfirmation(Sender, PlayerName, TellText);
}

void ACR_SendBroadcastNotification(int ServerID, string Message)
{
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	if (GetStringLength(Message) > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
	{
		Message = GetStringLeft(Message, ACR_SERVER_IPC_MAX_EVENT_LENGTH);
	}

	IPCEvent.SourcePlayerID = 0;
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = 0;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_BROADCAST_NOTIFICATION;
	IPCEvent.EventText = Message;

	ACR_SignalServerIPCEvent(IPCEvent);
}

void ACR_SendDisconnectPlayer(int ServerID, int PlayerID)
{
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	IPCEvent.SourcePlayerID = 0;
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = PlayerID;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_DISCONNECT_PLAYER;
	IPCEvent.EventText = "";

	ACR_SignalServerIPCEvent(IPCEvent);
}

void ACR_SendPurgeCachedCharacter(int ServerID, int PlayerID, string CharacterFileName)
{
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	if (GetStringLength(CharacterFileName) > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
	{
		CharacterFileName = GetStringLeft(CharacterFileName, ACR_SERVER_IPC_MAX_EVENT_LENGTH);
	}

	IPCEvent.SourcePlayerID = 0;
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = PlayerID;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_PURGE_CACHED_CHARACTER;
	IPCEvent.EventText = CharacterFileName;

	ACR_SignalServerIPCEvent(IPCEvent);
}

void ACR_SendShutdownServer(int ServerID, string Message)
{
	struct ACR_SERVER_IPC_EVENT IPCEvent;

	if (GetStringLength(Message) > ACR_SERVER_IPC_MAX_EVENT_LENGTH)
	{
		Message = GetStringLeft(Message, ACR_SERVER_IPC_MAX_EVENT_LENGTH);
	}

	IPCEvent.SourcePlayerID = 0;
	IPCEvent.SourceServerID = ACR_GetServerID();
	IPCEvent.DestinationPlayerID = 0;
	IPCEvent.DestinationServerID = ServerID;
	IPCEvent.EventType = ACR_SERVER_IPC_EVENT_SHUTDOWN_SERVER;
	IPCEvent.EventText = Message;

	ACR_SignalServerIPCEvent(IPCEvent);
}


void ACR_SendOnlineUserList(object Player)
{
	if (!GetIsPC(Player))
		return;

	ACR_CallIPCScript(
		ACR_SERVER_IPC_LIST_ONLINE_USERS,
		0,
		0,
		0,
		0,
		0,
		"",
		Player);
}

void ACR_SendFeedbackError(object Target, string Message)
{
	if (Target == OBJECT_INVALID)
		return;

	SendChatMessage(OBJECT_INVALID, Target, CHAT_MODE_SERVER, "<c=red>Error: " + Message + "</c>");
}

void ACR_DeliverCrossServerTellConfirmation(object Sender, string Recipient, string Message)
{
	if (Sender == OBJECT_INVALID)
		return;

	SendChatMessage(OBJECT_INVALID, Sender, CHAT_MODE_SERVER, "<c=green>" + Recipient + ": [Tell] " + Message + "</c>");
}

void ACR_DeliverLocalTell(object Sender, int PlayerID, string Message)
{
	object DestinationPlayer = ACR_GetLocalPlayerByPlayerID(PlayerID);

	if (DestinationPlayer == OBJECT_INVALID)
	{
		ACR_SendFeedbackError(Sender, "Internal error - attempted to re-route tell to local player, but player wasn't actually on this server.");
		return;
	}

	SendChatMessage(Sender, DestinationPlayer, CHAT_MODE_TELL, Message, TRUE);
	SendChatMessage(DestinationPlayer, Sender, CHAT_MODE_TELL, Message, FALSE);
}

object ACR_GetLocalPlayerByPlayerID(int PlayerID)
{
	object PlayerObject = GetFirstPC();

	while (PlayerObject != OBJECT_INVALID)
	{
		if (ACR_GetPlayerID(PlayerObject) == PlayerID)
			return PlayerObject;

		PlayerObject = GetNextPC();
	}

	return OBJECT_INVALID;
}

int ACR_GetPlayerIDByCharacterName(string CharacterName)
{
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_RESOLVE_CHARACTER_NAME_TO_PLAYER_ID,
		0,
		0,
		0,
		0,
		0,
		CharacterName);
}

int ACR_GetPlayerIDByPlayerName(string PlayerName)
{
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_RESOLVE_PLAYER_NAME,
		0,
		0,
		0,
		0,
		0,
		PlayerName);
}

int ACR_GetPlayerLoggedOnServerID(int PlayerID)
{
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_RESOLVE_PLAYER_ID_TO_SERVER_ID,
		PlayerID,
		0,
		0,
		0,
		0,
		"");
}

int ACR_GetIsServerOnline(int ServerID)
{
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_IS_SERVER_ONLINE,
		ServerID,
		0,
		0,
		0,
		0,
		"");
}

void ACR_StartServerToServerPortal(int ServerID, int PortalID, object PlayerObject)
{
	ACR_CallIPCScript(
		ACR_SERVER_IPC_ACTIVATE_SERVER_TO_SERVER_PORTAL,
		ServerID,
		PortalID,
		0,
		0,
		0,
		"",
		PlayerObject);
}

void ACR_PopulateChatSelect(object PlayerObject)
{
	ACR_CallIPCScript(
		ACR_SERVER_IPC_POPULATE_CHAT_SELECT,
		0,
		0,
		0,
		0,
		0,
		"",
		PlayerObject);
}

void ACR_HandleLatencyCheckResponse(object PlayerObject)
{
	ACR_CallIPCScript(
		ACR_SERVER_IPC_HANDLE_LATENCY_CHECK_RESPONSE,
		0,
		0,
		0,
		0,
		0,
		"",
		PlayerObject);
}

int ACR_GetPlayerLatency(object PlayerObject)
{
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_GET_PLAYER_LATENCY,
		0,
		0,
		0,
		0,
		0,
		"",
		PlayerObject);
}

void ACR_SignalServerIPCEvent(struct ACR_SERVER_IPC_EVENT IPCEvent)
{
	ACR_CallIPCScript(
		ACR_SERVER_IPC_SIGNAL_IPC_EVENT,
		IPCEvent.SourcePlayerID,
		IPCEvent.SourceServerID,
		IPCEvent.DestinationPlayerID,
		IPCEvent.DestinationServerID,
		IPCEvent.EventType,
		IPCEvent.EventText);
}

void ACR_ServerIPC_OnModuleLoad()
{
#if SERVER_IPC_ENABLED
	ACR_CallIPCScript(
		ACR_SERVER_IPC_INITIALIZE,
		0,
		0,
		0,
		0,
		0,
		"");
#endif
}

void ACR_ServerIPC_OnClientEnter(object EnteringPC)
{
#if SERVER_IPC_ENABLED
	ACR_CallIPCScript(
		ACR_SERVER_IPC_HANDLE_CLIENT_ENTER,
		0,
		0,
		0,
		0,
		0,
		"",
		EnteringPC);
#endif
}

void ACR_ServerIPC_OnClientLeave(object LeavingPC)
{
#if SERVER_IPC_ENABLED
	ACR_CallIPCScript(
		ACR_SERVER_IPC_HANDLE_CLIENT_LEAVE,
		0,
		0,
		0,
		0,
		0,
		"",
		LeavingPC);
#endif
}

int ACR_ServerIPC_OnChat(object Speaker, int Mode, string Text)
{
#if SERVER_IPC_ENABLED
	return ACR_CallIPCScript(
		ACR_SERVER_IPC_HANDLE_CHAT_EVENT,
		Mode,
		0,
		0,
		0,
		0,
		Text,
		Speaker);
#else
	return FALSE;
#endif
}

int ACR_CallIPCScript(int Command, int P0, int P1, int P2, int P3, int P4, string P5, object ObjectSelf = OBJECT_SELF)
{
	AddScriptParameterInt(Command);
	AddScriptParameterInt(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterInt(P2);
	AddScriptParameterInt(P3);
	AddScriptParameterInt(P4);
	AddScriptParameterString(P5);

	return ExecuteScriptEnhanced(ACR_SERVER_IPC_SERVERCOM_SCRIPT, ObjectSelf, TRUE);
}


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

// The IPC C# script name.
const string ACR_SERVER_IPC_SERVERCOM_SCRIPT                    = "acr_servercommunicator";


// Commands for the IPC C# script:

// This command requests that initialization be performed for module startup.
const string ACR_SERVER_IPC_INITIALIZE                          = "INITIALIZE";

// This command requests that an IPC event be signaled.
const string ACR_SERVER_IPC_SIGNAL_IPC_EVENT                    = "SIGNAL_IPC_EVENT";

// This command resolves a character name to a player id.
const string ACR_SERVER_IPC_RESOLVE_CHARACTER_NAME_TO_PLAYER_ID = "RESOLVE_CHARACTER_NAME_TO_PLAYER_ID";

// This command resolves a player name to a player id.
const string ACR_SERVER_IPC_RESOLVE_PLAYER_NAME                 = "RESOLVE_PLAYER_NAME";

// This command resolves a player id to an active server id.
const string ACR_SERVER_IPC_RESOLVE_PLAYER_ID_TO_SERVER_ID      = "RESOLVE_PLAYER_ID_TO_SERVER_ID";


// IPC event codes:

// The chat tell event is used to transport tells cross-server.
const int ACR_SERVER_IPC_EVENT_CHAT_TELL                        = 0;



// Maximum length of an IPC event text field.

const int ACR_SERVER_IPC_MAX_EVENT_LENGTH                       = 256;

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
void ACR_SignalServerIPCEvent(ACR_SERVER_IPC_EVENT IPCEvent);

//! Handle module load and start up the IPC subsystem.
void ACR_ServerIPC_OnModuleLoad();

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

//! Make a raw call to the IPC C# control script.
//!  - Command: Supplies the command to request (e.g. ACR_SERVER_IPC_SIGNAL_IPC_EVENT).
//!  - P0: Supplies the first command-specific parameter.
//!  - P1: Supplies the second command-specific parameter.
//!  - P2: Supplies the third command-specific parameter.
//!  - P3: Supplies the fourth command-specific parameter.
//!  - P4: Supplies the fifth command-specific parameter.
//!  - P5: Supplies the sixth command-specific parameter.
//!  - Returns: The command-specific return code is returned.
int ACR_CallIPCScript(string Command, int P0, int P1, int P2, int P3, int P4, string P5);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_SendCrossServerTellByCharacter(object Sender, string CharacterName, string TellText)
{
	int PlayerID = ACR_GetPlayerIDByCharacterName(CharacterName);
	int ServerID;
	ACR_SERVER_IPC_EVENT IPCEvent;

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
		ACR_DeliverLocalTell(Sender, PlayerID, Message);
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
	ACR_SERVER_IPC_EVENT IPCEvent;

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
		ACR_DeliverLocalTell(Sender, PlayerID, Message);
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
	ACR_DeliverCrossServerTellConformation(Sender, PlayerName, TellText);
}

void ACR_SendFeedbackError(object Target, string Message)
{
	if (Sender == OBJECT_INVALID)
		return;

	SendChatMessage(OBJECT_INVALID, CHAT_MODE_SERVER, "<c=red>Error: " + Message + "</c>");
}

void ACR_DeliverCrossServerTellConfirmation(object Sender, string Recipient, string Message)
{
	if (Sender == OBJECT_INVALID)
		return;

	SendChatMessage(OBJECT_INVALID, CHAT_MODE_SERVER, "<c=green>" + Recipient + ": [Tell] " + Message + "</c>");
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
	SendChatMessage(DestinationPlayer, Sender, CHAT_MODE_TELL, Message, TRUE);
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

void ACR_SignalServerIPCEvent(ACR_SERVER_IPC_EVENT IPCEvent)
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
	ACR_CallIPCScript(
		ACR_SERVER_IPC_INITIALIZE,
		0,
		0,
		0,
		0,
		0,
		"");
}

int ACR_CallIPCScript(string Command, int P0, int P1, int P2, int P3, int P4, string P5)
{
	AddScriptParameterString(Command);
	AddScriptParameterInt(P0);
	AddScriptParameterInt(P1);
	AddScriptParameterInt(P2);
	AddScriptParameterInt(P3);
	AddScriptParameterInt(P4);
	AddScriptParameterString(P5);

	return ExecuteScriptEnhanced(ACR_SERVER_IPC_SERVERCOM_SCRIPT, OBJECT_SELF, TRUE);
}


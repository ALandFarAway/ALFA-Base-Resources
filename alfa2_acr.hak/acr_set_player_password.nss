////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_set_player_password.nss
//    $Revision:: 1          $ current version of the file
//        $Date:: 2014-01-24#$ date the file was created or modified
//       Author : Basilica
//
//  Description
//  This file contains a cross-server script that is called to set the player
//  password for the server.  The script argument is the new player password.
//
//  Revision History
//  2014/01/24  Basilica Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_server_ipc_i"

void main(int SourceServerId, string ScriptArgument)
{
	string PlayerPassword = ScriptArgument;

	//
	// To manually invoke this script to the player password for server with
	// server id <serverid> to new password <newpassword>, the following SQL
	// query could be used:
	//
	// insert into server_ipc_events (id, destinationserverid, destinationplayerid, sourceserverid, sourceplayerid, eventtype, eventtext) values (0, <serverid>, 0, 0, 0, 6, 'acr_set_player_password:<newpassword>');
	//

	//
	// Log the attempt to the server log and change the player password.
	//
	// N.B.  The change is only effective until the next change or a server
	//       reboot, unless the configuration file on the server is updated
	//       separately.
	//

	WriteTimestampedLogEntry("acr_set_player_password: Server " + IntToString(SourceServerId) + " requests player password change to: " + PlayerPassword);
	NWNXSetString("SRVADMIN", "SETPLAYERPASSWORD", PlayerPassword, 0, "");
}

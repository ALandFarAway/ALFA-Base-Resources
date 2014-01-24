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

	WriteTimestampedLogEntry("acr_set_player_password: Server " + IntToString(SourceServerId) + " requests player password change to: " + PlayerPassword);
	NWNXSetString("SRVADMIN", "SETPLAYERPASSWORD", PlayerPassword, 0, "");
}

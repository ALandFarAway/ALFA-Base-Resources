////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_server_ping_request.nss
//    $Revision:: 1          $ current version of the file
//        $Date:: 2013-11-13#$ date the file was created or modified
//       Author : Basilica
//
//  Description
//  This file contains a cross-server script that is called when a cross-server
//  ping request is received through the database IPC channel.
//
//  The script echoes the message back to the source server so that the channel
//  response time may be measured.
//
//  Revision History
//  2013/11/13  Basilica Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_server_ipc_i"

void main(int SourceServerId, string ScriptArgument)
{
	//
	// Pass the request back to the source server so that the response time of
	// the communication channel can be measured.
	//

	ACR_RunScriptOnServer(SourceServerId,
	                      "acr_server_ping_response",
	                      ScriptArgument);
}

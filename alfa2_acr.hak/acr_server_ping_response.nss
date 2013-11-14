////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_server_ping_response.nss
//    $Revision:: 1          $ current version of the file
//        $Date:: 2013-11-13#$ date the file was created or modified
//       Author : Basilica
//
//  Description
//  This file contains a cross-server script that is called when a cross-server
//  ping response is received through the database IPC channel.
//
//  The script passes the response data to the server communicator subsystem
//  so that the response time can be calculated and sent to the requesting PC.
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
	// Notify the server communicator to handle the request.
	//

	ACR_ServerIPC_OnServerPingResponse(SourceServerId, ScriptArgument);
}

////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_resync_gui.nss
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-10-22#$ date the file was created or modified
//       Author : Basilica
//
//  Description
//  This file contains a cross-server script that is called to register a
//  player to have their chat GUI resynchronized when a player is being
//  transferred from one server to another.
//
//  The destination player may or may not already be on the local server, and
//  they may or may not ever arrive.
//
//  The script invokes the server communicator so that it may set up state as
//  is appropriate.
//
//  Revision History
//  2012/10/22  Basilica Created.
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

	ACR_ServerIPC_OnGUIResynchronization(SourceServerId, ScriptArgument);
}

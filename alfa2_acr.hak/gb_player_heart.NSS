// gb_player_heart
/*	
	Script that runs when a player controls a companion
*/
// MDiekmann 8/7/07

#include "acr_server_ipc_i"

void main()
{
	// Dispatch periodic events while the server is paused, if we're a DM.
	ACR_PauseHeartbeat(OBJECT_SELF);
	//option for a custom hb script
	string sHBScript=GetLocalString(OBJECT_SELF,"hb_script");
	if (sHBScript!="")
		ExecuteScript(sHBScript,OBJECT_SELF);
}

// gb_player_ud
/*
	 user defined events template
*/
// ChazM 9/5/06 don't have leader follow himself
// BMA-OEI 09/12/06 -- Added EVENT_PLAYER_CONTROL_CHANGED handler
// MDiekmann 8/7/07 - Modified to run a custom user defined script based on the tag if one exists

#include "ginc_companion"
#include "ginc_debug"
#include "x0_i0_assoc"
// 		this includes: GetFollowDistance()
	
void main()
{
	string sMyTag = GetTag(OBJECT_SELF);		
	
    int iEvent = GetUserDefinedEventNumber();
	
	//execute custom user-defined script from local string if it exists
	string sUDScript=GetLocalString(OBJECT_SELF,"ud_script");
	if (sUDScript!="")
		ExecuteScript(sUDScript, OBJECT_SELF);
	
    switch (iEvent)
	{
		case EVENT_HEARTBEAT: 	// 1001
			break;	

		case EVENT_PERCEIVE: 	// 1002
			break;	

		case EVENT_END_COMBAT_ROUND: 	// 1003
			break;	

		case EVENT_DIALOGUE: 	// 1004
			break;	

		case EVENT_ATTACKED: 	// 1005
			break;	

		case EVENT_DAMAGED: 	// 1006
			break;
	
		case EVENT_DISTURBED: 	// 1008
			break;	

		case EVENT_SPELL_CAST_AT: 	// 1011
			break;	
			
		case EVENT_PLAYER_CONTROL_CHANGED: // 2052
		{
			HandlePlayerControlChanged( OBJECT_SELF );
			break;
		}			
	}
}
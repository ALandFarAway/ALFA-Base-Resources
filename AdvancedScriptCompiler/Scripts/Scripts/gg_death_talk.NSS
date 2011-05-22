// gg_death_talk.nss
/*
   Group DeathScript. Assigned using GroupOnDeathBeginConversation().
   Creates an IPoint Speaker when all group members have been killed to begin a conversation.
*/
// ChazM 6/16/05
// ChazM 6/20/05 - changed string to constant	
// ChazM 7/7/05 - func name fix
// ChazM 7/28/05 - Start conversation now ignores distance so we can be assured it starts.	
// ChazM 12/12/05 - clear PC actions
// BMA-OEI 1/13/06 - update for GetGroupIsValid, reset PC control, rez party
// BMA-OEI 1/23/06 - update to use IPSpeaker heartbeat
// BMA-OEI 2/8/06 - Updated ResetIPSpeaker to delete after use, fade out 
// DBR 2/09/06  - bFadeOut being put in wrong spot
// BMA-OEI 2/14/06 - Delays and Fades do more bad than good :(
// BMA-OEI 3/6/06 - revised comments
// BMA-OEI 5/23/06 - Updated w/ new group functions 

//#include "ginc_cutscene"
//#include "ginc_debug"	
#include "ginc_group"	
#include "ginc_ipspeaker"
//#include "ginc_misc"
//#include "nw_i0_plot"	
	
void main()
{
	string sGroupName = GetGroupName( OBJECT_SELF );

	// Update number of sGroupName members killed
	//PrettyMessage( "gg_death_talk: " + sGroupName + " death count = " + IntToString( IncGroupNumKilled( sGroupName ) ) );

	// If all group members are dead or invalid
	if ( GetIsGroupValid( sGroupName, TRUE ) == FALSE )
	{
		string sTalkerTag 	 = GetGroupString( sGroupName, "TalkerTag" );
		string sConversation = GetGroupString( sGroupName, "Conversation" );
		
		//PrettyDebug( "gg_death_talk: " + sGroupName + " wiped. Start IPSpeaker conversation: " + sConversation );

		// Spawn IPoint Speaker and setup one-shot pending conversation
		CreateIPSpeaker( sTalkerTag, sConversation, GetLocation( OBJECT_SELF ), 1.75f );
	}                       
}
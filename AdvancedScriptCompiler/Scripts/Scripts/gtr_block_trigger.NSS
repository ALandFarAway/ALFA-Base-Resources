// gtr_block_trigger
/*
	Used on enter of a trigger to block the player from entering and jump them to a nearby waypoint.
	Note that conversations should consist of one-line barkstrings only.
*/
// Tevans 1/24/06 - Created script and trigger

#include "ginc_debug"
#include "ginc_param_const"
	
void main ()
{
    object oEntering = GetEnteringObject();

    if ( !GetIsPC(oEntering) )	// if the entering object is not a PC, bail out
		return;

	// Get the trigger's local variables
	string sWP		= GetLocalString( OBJECT_SELF, "Waypoint" );
	string sVar		= GetLocalString( OBJECT_SELF, "Variable" );
	string sConv	= GetLocalString( OBJECT_SELF, "Conversation" );
	string sSpeaker	= GetLocalString( OBJECT_SELF, "Speaker" );
	int bBarkstring	= GetLocalInt( OBJECT_SELF, "PlayBarkstring" );
	
	if ( !GetGlobalInt(sVar) )
	{
		// The global flag for prohibiting entry into the trigger is off; bail out
		PrettyError( "Variable " + sVar + " is FALSE" );
		return;
	}

	object oWP = GetTarget( sWP );

	if ( !GetIsObjectValid(oWP) )
	{
		// The provided waypoint tag doesn't match a valid object; bail out
		PrettyError( "Waypoint " + sWP + " is INVALID" );
		return;
	}

	AssignCommand( oEntering, FadeToBlack(OBJECT_SELF, FADE_SPEED_FASTEST) );
	AssignCommand( oEntering, ClearAllActions() );
	DelayCommand( FADE_SPEED_FASTEST / 3.0f, AssignCommand(oEntering, JumpToObject( oWP )) );
	DelayCommand( FADE_SPEED_FASTEST * 1.5f, AssignCommand(oEntering, FadeFromBlack( OBJECT_SELF )) );

	if ( sSpeaker == "" && bBarkstring)
	{
		AssignCommand( oEntering, SpeakStringByStrRef(113518) );	// see dialog.tlk for entry 113518
	}

	else if (sSpeaker == "" && sConv == "")
		return;

	else
	{
		int bPrivateConversation	= FALSE;
		int bPlayHello				= FALSE;
		int bIgnoreStartDistance	= TRUE;
		int bDisableCutsceneBars	= FALSE;
		object oSpeaker = GetTarget( sSpeaker );

		if ( !GetIsObjectValid(oSpeaker) )
		{
			PrettyError( "Speaker " + sSpeaker + " is INVALID. Using PC" );
			oSpeaker = oEntering;
		}

		AssignCommand( oSpeaker, ActionStartConversation(oEntering, 
														 sConv, 
														 bPrivateConversation, 
														 bPlayHello, 
														 bIgnoreStartDistance, 
														 bDisableCutsceneBars) );	
	}
}
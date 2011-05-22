// gb_comp_conv.nss
/*
	Companion OnConversation handler
	Based on henchmen/associate OnDialogue handler (X0_CH_HEN_CONV)
*/
// ChazM 12/5/05
// ChazM 5/18/05 reference to master now uses GetCurrentMaster() - returns master for associate or companion
// BMA-OEI 7/14/06 -- Update to use CompanionRespondToShout(), follow mode interruptible
// BMA-OEI 7/17/06 -- Check if oShouter is valid, and OBJECT_SELF is AbleToTalk(), respond to master and friends
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// ChazM 8/30/06 FightIfYouAintBusy() clears actions if following; Don't respond to companion shouts if in puppet mode.
// ChazM 9/13/06 Added some debug (to help determine why PC doesn't always listen to commands).

#include "hench_i0_hensho"
#include "hench_i0_monsho"
#include "x0_i0_henchman"
//#include "ginc_companion"


//* GeorgZ - Put in a fix for henchmen talking even if they are petrified
int AbleToTalk( object oSelf );

// Companion reaction to shouts
void CompanionRespondToShout( object oShouter, int nShoutIndex, object oIntruder=OBJECT_INVALID );

// CompanionRespondToShout() helper
void FightIfYouAintBusy( object oTarget );


void main()
{
	//int i = GetLocalInt( OBJECT_SELF, sAssociateMasterConditionVarname );
    //PrettyDebug( "gb_comp_conv: " + GetName(OBJECT_SELF) + " - Associate State: " + IntToHexString(i) );
	//PrettyDebug( "gb_comp_conv: " + GetName(OBJECT_SELF) + " - Speaker: " + GetName(GetLastSpeaker()) + " - Heard Pattern: " + IntToString(GetListenPatternNumber()) );
	
	if ( ( !GetIsHenchmanDying(OBJECT_SELF) ) && ( !GetIsDead(OBJECT_SELF) ) )
	{
		object oShouter = GetLastSpeaker();
		int nMatch = GetListenPatternNumber();
		
		// BMA-OEI 7/17/06 -- Min. conditions to continue
		if ( ( GetIsObjectValid(oShouter) ) && ( AbleToTalk(OBJECT_SELF) ) )
		{
		    if ( nMatch == -1 )
		    {
		        // * September 2 2003
		        // * Added the GetIsCommandable check back in so that
		        // * Henchman cannot be interrupted when they are walking away
				if ( ( GetCommandable(OBJECT_SELF)) &&
					 ( GetCurrentAction() != ACTION_OPENLOCK ) )
				{
		 			//SetCommandable( TRUE );
					ClearActions( CLEAR_X0_CH_HEN_CONV_26 );
					//string sDialogFileToUse = GetDialogFileToUse( oShouter );
					BeginConversation( "", oShouter );
				}
			}
			else
			{
				object oMaster = GetCurrentMaster(); //GetPCLeader( OBJECT_SELF );
			    object oIntruder = OBJECT_INVALID;
		
//				Jug_Debug(GetName(OBJECT_SELF) + " - I heard shout: " + IntToString(nMatch) + " from: " + GetName(oShouter));
				// Speaker is our master
				if (GetIsObjectValid(oMaster) && ( oMaster == oShouter ) )
				{
					//sOut += " who is my master.";
					SetCommandable( TRUE );
                	HenchChRespondToShout(oShouter, nMatch, oIntruder);
				}
				// Speaker is our friend
				else if ((GetFactionEqual(oShouter) ) || ( GetIsFriend(oShouter) ) )
				{
					//sOut +=  " who is my friend.";
					if ( nMatch == 4 ) // ?
					{
						oIntruder = GetLocalObject( oShouter, "NW_BLOCKER_INTRUDER" );
					}
					else if ( nMatch == 5 ) // ?
					{
						oIntruder = GetLastHostileActor( oShouter );
					}
					//SetCommandable( TRUE );
//				Jug_Debug(GetName(OBJECT_SELF) + " - responding to shout: " + IntToString(nMatch) + " from: " + GetName(oShouter));
             		HenchMonRespondToShout(oShouter, nMatch, oIntruder);
				}
				/*else
				{
					sOut +=  " who is nothing to me.";
				}*/
				//PrettyDebug(sOut);
		    }
		}
	}

    if( GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT) )
	{
        SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE) );
    }
}


//* GeorgZ - Put in a fix for henchmen talking even if they are petrified
int AbleToTalk( object oSelf )
{
	if ( GetHasEffect( EFFECT_TYPE_CONFUSED, oSelf ) ||
		 GetHasEffect( EFFECT_TYPE_DOMINATED, oSelf ) ||
		 GetHasEffect( EFFECT_TYPE_FRIGHTENED, oSelf ) ||
		 GetHasEffect( EFFECT_TYPE_PARALYZE, oSelf ) ||
		 GetHasEffect( EFFECT_TYPE_PETRIFY, oSelf ) ||
		 GetHasEffect( EFFECT_TYPE_STUNNED, oSelf ) )
	{
		return ( FALSE );
	}
	
	return ( TRUE );
}

// Companion reaction to shouts
/*void CompanionRespondToShout( object oShouter, int nShoutIndex, object oIntruder=OBJECT_INVALID )
{
	//If I am a puppet. I put nothing on the ActionQueue myself.
	if (GetAssociateState(NW_ASC_MODE_PUPPET))
		return;

	int bSurrendered = GetLocalInt( OBJECT_SELF, "Generic_Surrender" );
	if ( bSurrendered ) return;

	switch ( nShoutIndex )
	{
		case 1: // NW_GENERIC_SHOUT_I_WAS_ATTACKED
		case 2: // NW_GENERIC_SHOUT_MOB_ATTACK			
		case 3: // NW_GENERIC_SHOUT_I_AM_DEAD
		case 6: // CALL_TO_ARMS
			FightIfYouAintBusy( GetLastHostileActor(oShouter) );
			break;
			
        //For this shout to work the object must shout the following
        //string sHelp = "NW_BLOCKER_BLK_" + GetTag(OBJECT_SELF);
		case 4: // BLOCKER OBJECT HAS BEEN DISTURBED
			FightIfYouAintBusy( oIntruder );
			break;
			
		case 5: // ATTACK MY TARGET
			AdjustReputation( oIntruder, OBJECT_SELF, -100 );
			SetIsTemporaryEnemy( oIntruder );
			FightIfYouAintBusy( oIntruder );
			break;

		default:
	}
}


// CompanionRespondToShout() helper
void FightIfYouAintBusy( object oTarget )
{
	// Ignore if you've been told to stand ground, already busy or already doing something, or following somebody
	if ( ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) &&
		 ( GetAssociateState(NW_ASC_IS_BUSY) == FALSE ) &&
		 //( GetIsInCombat(OBJECT_SELF) == FALSE ) && 
		 ( ( GetNumActions(OBJECT_SELF) == 0 ) || ( GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW ) ) )
	{
		 if (GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW )
		 	ClearAllActions();
		HenchmenCombatRound( oTarget );
	}
} */
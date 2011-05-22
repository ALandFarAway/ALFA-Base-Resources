// ginc_behavior
/*
    support file for behavior related functions (complex sets of actions and conditions)
*/
// ChazM 3/9/05
// DBR 5/30/06 - Added mutator SetIsFocused(). Also encapsulated explicit target check into a function.
// ChazM 1/26/07 - Added various new functions drawn from various "spell cast at" event scripts
// ChazM 2/27/07 - Removed "I was attacked" from top of ReactToHarmfulSpell()
// ChazM 6/18/07 - Modified IsBusy() - takes optional object param, no longer affects actions, checks var from nw_i0_assoc

#include "x2_i0_spells"
#include "X0_INC_HENAI"

const int FOCUSED_FULL 		= 2;	// fully focused
const int FOCUSED_PARTIAL 	= 1;	// will only become unfocused if attacked
const int FOCUSED_STANDARD 	= 0;	// treated as full focus when in conversations
const int FOCUSED_NONE 		= -1;	// same as original scripts
const string VAR_FOCUSED	= "Focused";

// ---------------------------------------------	
// Prototypes
// ---------------------------------------------	
int GetIsFocused(object oTarget=OBJECT_SELF);
void SetIsFocused(int nFocusLevel, object oTarget=OBJECT_SELF); //DBR 5/30/06
void StopBehavior(object oObject);
void StartBehavior(object oObject);
//int IsBusy();
int IsBusy(object oCreature = OBJECT_SELF);
int GetIsValidRetaliationTarget(object oTarget, object oRetaliator=OBJECT_SELF); //DBR 5/30/06

int GetIsOkayToCastSpell();
void MoveToAndAttack(object oTarget, int bPlayerInterruptible, int bUseHenchAI);
int DoAOEBehavior (int nBehavior, object oCaster, int bPlayerInterruptible, int bUseHenchAI);
int GetIsOkayToDoHenchmenCombatRound(object oTarget);
void ReactToHarmfulSpell(object oCaster, int nSpellID, int bPlayerInterruptible, int bUseHenchAI);

// ---------------------------------------------	
// Functions
// ---------------------------------------------	
int GetIsFocused(object oTarget=OBJECT_SELF)
{
    int iFocused = GetLocalInt(oTarget, VAR_FOCUSED);
	if (IsInConversation(oTarget)  && iFocused != FOCUSED_NONE)
	{
		iFocused = FOCUSED_FULL;
	}
	return (iFocused);
}

// Set a creature to be focused     DBR 5/30/06
void SetIsFocused(int nFocusLevel, object oTarget=OBJECT_SELF)
{
	SetLocalInt(oTarget, VAR_FOCUSED, nFocusLevel);
}	
	
// Flag creature's behavior to be stopped
void StopBehavior(object oObject)
{
    SetLocalInt(oObject, "Behavior", 1);
}

// Flag creature's behavior to be started
// (on by defualt)
void StartBehavior(object oObject)
{
    SetLocalInt(oObject, "Behavior", 0);
}


// check if creature is busy doing something else, be it combat, conversation,
// or some other action on the action queue
int IsBusy(object oCreature = OBJECT_SELF)
{
    // Behavior flagged to be stopped?
    if (GetLocalInt(oCreature, "Behavior") == 1)
        return FALSE;
				
	if (GetLocalInt(oCreature, "NW_ASSOCAMIBUSY") == TRUE)
		return TRUE;
		
    if (GetIsInCombat(oCreature))
	{
		return TRUE;
	/*
        //int iTargetType = GetObjectType(GetAttemptedAttackTarget());
        int nTargetType = GetObjectType(GetAttackTarget(oCreature));
        // only busy if target is a creature.
        if (nTargetType == OBJECT_TYPE_CREATURE)
            return TRUE;
        else if (Random(10)+1 >= 8) 
		{
            //SpeakString ("attacking a non creature");
            ClearAllActions(TRUE);
            return FALSE;
        }
        else
            return TRUE;
	*/			
    }


    int nAction = GetCurrentAction(oCreature);
/*
    if (iAction == ACTION_ATTACKOBJECT) {
        SpeakString ("attacking an object");
        int iTargetType = GetObjectType(GetAttackTarget());
        // only busy if target is a creature.
        if (iTargetType == OBJECT_TYPE_CREATURE)
            return TRUE;
        else {
            // SpeakString ("attacking a non creature");
            return FALSE;
        }

        //return FALSE;
    }
*/
    if (IsInConversation(oCreature))
        return TRUE;

    if (nAction != ACTION_INVALID)
        return TRUE;

    return FALSE;

}

// This check is run before the default scripts (nw_c2's) explicitly tell a creature to attack a target
// it is NOT checked in Determine Combat Round. 
int GetIsValidRetaliationTarget(object oTarget, object oRetaliator=OBJECT_SELF) 
{
	if (GetPlotFlag(oRetaliator) && !GetIsEnemy(oTarget, oRetaliator))	//please don't attack any neutral or friends if I am plot
		return FALSE; //not cool to attack this guy
	return TRUE; //ok to attack this guy
}

// Disable spell casting while Polymorphed and other criteria
int GetIsOkayToCastSpell()
{
	int iRet = TRUE;
	if (GetHasEffect( EFFECT_TYPE_POLYMORPH ) 
		|| GetHasEffect(EFFECT_TYPE_SILENCE)
		|| GetHasFeatEffect(FEAT_BARBARIAN_RAGE) 
		|| GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 10
		|| GetHasFeatEffect(FEAT_FRENZY_1) 
		|| GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION))
	{
		iRet = FALSE;
	}
	return (iRet);
}

void MoveToAndAttack(object oTarget, int bPlayerInterruptible, int bUseHenchAI)
{
	ClearActions( CLEAR_NW_C2_DEFAULTB_GUSTWIND );
	// attack the caster of this spell
	if (bPlayerInterruptible)
		ActionMoveToObject( oTarget, TRUE, 2.0f );
	else					
		ActionForceMoveToObject( oTarget, TRUE, 2.0f );
				
	if (bUseHenchAI)
		DelayCommand( 3.0f, ActionDoCommand( HenchmenCombatRound(oTarget) ) );
	else
		DelayCommand(2.0, ActionDoCommand(DetermineCombatRound(oTarget)));
}

// Perform the AOE Behavior we've chosed to use.
// returns whether we responded.
// int nBehavior	- Behavior constant  
// object oCaster	- caster of the AOE
// int bPlayerInterruptible - Might a player control this character?
// int bUseHenchAI 	- Hechmen (and companions) have a seperate DCR
int DoAOEBehavior (int nBehavior, object oCaster, int bPlayerInterruptible, int bUseHenchAI)
{
	int bResponded = FALSE;
	// int max=GetHitDice(OBJECT_SELF);
	switch ( nBehavior )
	{
		case X2_SPELL_AOEBEHAVIOR_DISPEL_N:
		case X2_SPELL_AOEBEHAVIOR_DISPEL_M:
		case X2_SPELL_AOEBEHAVIOR_DISPEL_G:
		case X2_SPELL_AOEBEHAVIOR_DISPEL_C:
		case X2_SPELL_AOEBEHAVIOR_DISPEL_L:
		case X2_SPELL_AOEBEHAVIOR_GUST:
			if (GetIsOkayToCastSpell())
			{
				if(nBehavior == X2_SPELL_AOEBEHAVIOR_GUST) 
					nBehavior = SPELL_GUST_OF_WIND;
					
				bResponded = TRUE;
				ClearActions( CLEAR_NW_C2_DEFAULTB_GUSTWIND );
				ActionCastSpellAtLocation( nBehavior, GetLocation(OBJECT_SELF) );
				//if (!bPlayerInterruptible)
				//{
	            //   	ActionDoCommand(SetCommandable(TRUE));
	            //   	SetCommandable(FALSE);
				//}							
			}
			break;
													
		case X2_SPELL_AOEBEHAVIOR_FLEE:
			if (GetCurrentAction() != ACTION_MOVETOPOINT
				&& GetIsValidRetaliationTarget(oCaster)) //DBR 5/30/06 - this if line put in for quest giving/plot NPC's
			{
				bResponded = TRUE;
				MoveToAndAttack(oCaster, bPlayerInterruptible, bUseHenchAI);
			}
			break;
			
		case X2_SPELL_AOEBEHAVIOR_IGNORE:
			// well ... nothing
			break;
			
		default:
			// this should never happen
	}
	
	return (bResponded);	
}

// Don't fire HenchmenCombatRound if other stuff is going on.
int GetIsOkayToDoHenchmenCombatRound(object oTarget)
{
	int iRet = TRUE;

	// Note that HenchmenCombatRound() already checks a number of other things such as Busy flag, if dying, etc. 
	if (GetAssociateState(NW_ASC_MODE_STAND_GROUND) 	// Standing ground, so don't attak
		|| ( GetNumActions(OBJECT_SELF) > 0  			// We're doing an action (other than following)
			&& GetCurrentAction(OBJECT_SELF) != ACTION_FOLLOW ) 
		|| !GetIsObjectValid(oTarget)					// Target not valid so don't do it
		|| GetIsObjectValid(GetAttackTarget())			// already have a valid attack target
		|| ( GetIsObjectValid(GetAttemptedSpellTarget())// already have a valid *enemy* spell target
			&& GetIsEnemy(GetAttemptedSpellTarget()) ))
	{
		iRet = FALSE;
	}
	return (iRet);
}

// Determine what to do based on who cast it and what they cast.
void ReactToHarmfulSpell(object oCaster, int nSpellID, int bPlayerInterruptible, int bUseHenchAI)
{
	int bResponded;

	//SpeakString( "NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK );
    //PrettyDebug(GetName(OBJECT_SELF) + ": on Spell Cast at!  Caster was: " + GetName(oCaster));
	
    // Don't hate those in same faction.
	if ( GetFactionEqual(oCaster, OBJECT_SELF) == TRUE )
	{
        //PrettyDebug("Caster was in my faction - aborting");
		ClearPersonalReputation( oCaster, OBJECT_SELF );
        //ClearAllActions(TRUE);
        //DelayCommand(1.2, ActionDoCommand(DetermineCombatRound(OBJECT_INVALID)));
		return;
	}
    //PrettyDebug("Caster was NOT in my faction!");
	
	// other reasons not to react - I'm dying or I'm in puppet mode
	if (bUseHenchAI 
		&& (GetIsHenchmanDying()
			|| GetAssociateState(NW_ASC_MODE_PUPPET)) )
	{
		return;
	}			
	
	// * AOE Behavior
	// BMA-OEI 7/08/06 -- Likely to lose action queue in this block
	if ( MatchAreaOfEffectSpell(nSpellID) == TRUE ) // ?
	{
		SetCommandable( TRUE );	
		int nBehavior = GetBestAOEBehavior( nSpellID, GetCasterLevel(oCaster) );
		bResponded = DoAOEBehavior(nBehavior, oCaster, bPlayerInterruptible, bUseHenchAI);
	}
	
	// Handle response to an attack
	if (bResponded == FALSE 
		&& !GetIsFighting(OBJECT_SELF)
		&& GetIsValidRetaliationTarget(oCaster) )
	{
		if (bUseHenchAI)
		{
			if (GetIsOkayToDoHenchmenCombatRound(oCaster))
			{
				HenchmenCombatRound( oCaster );
			}
		}
		else
		{
			if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
	       	{
	            DetermineSpecialBehavior(oCaster);
	       	}
	       	else
	       	{
	            DetermineCombatRound(oCaster);
	       	}
		}
					
	}
	// We were attacked, so yell for help
	//SetCommandable(TRUE);
	//Shout Attack my target, only works with the On Spawn In setup
	SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
	
	//Shout that I was attacked
	SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
}	
	
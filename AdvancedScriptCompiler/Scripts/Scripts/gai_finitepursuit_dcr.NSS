//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_finitepursuit_dcr
//::
//::	Determine Combat Round for the Finite "Break-Off" Pursuit AI.
//::
//::        Spell Queue AI's will cast spells form an ordered list attached to them.
//::		To Attach a list, use the function ******, the conversation script ******,
//::		or manually using these variables (must be done pre-spawn) *******.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/31/06

#include "nw_i0_generic"
#include "x2_inc_switches"
#include "ginc_param_const"
#include "ginc_ai"
#include "nw_i0_plot"

//#include "ginc_debug"

const string VAR_FP_COUNTDOWN = "FP_COUNTDOWN";
const string VAR_FP_HOMEBASE  = "FP_HOMEBASE";


void HomeBaseReset()
{
	int nCount = GetLocalInt(OBJECT_SELF,VAR_FP_COUNTDOWN)-1;
	SetLocalInt(OBJECT_SELF,VAR_FP_COUNTDOWN,nCount);
	if (nCount<=0)
	{
		//could have npc walk back to homebase here if wanted
	}
	else
	{
		DelayCommand(15.0f,HomeBaseReset());
	}
}



void main()
{
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget(); //Handling Determine Combat round red tape

    if (__InCombatRound())	//if I'm already doing stuff, don't overload me here.
	{
		SetCreatureOverrideAIScriptFinished();	//Running back home, DCR can stop
        return;
	}
	
	//If timer is at 0 (this is the first DCR in a while) make this homebase.
	if (GetLocalInt(OBJECT_SELF,VAR_FP_COUNTDOWN)<=0)
	{
		SetLocalLocation(OBJECT_SELF, VAR_FP_HOMEBASE,GetLocation(OBJECT_SELF));
		HomeBaseReset();								//Start Countdown
	}
	SetLocalInt(OBJECT_SELF,VAR_FP_COUNTDOWN,3);   //Reset Countdown


	//If I have wandered further off than I am allowed
	location lHomebase=GetLocalLocation(OBJECT_SELF,VAR_FP_HOMEBASE);
	float fWander=GetDistanceBetweenLocations(GetLocation(OBJECT_SELF),lHomebase);
	if (fWander > GetLocalFloat(OBJECT_SELF,VAR_FP_MAXDIST))
	{
//		PrettyDebug("I should be going home now");
		ClearAllActions(TRUE);
		__TurnCombatRoundOn(TRUE);
		ActionMoveToLocation(lHomebase,TRUE);
		__TurnCombatRoundOn(FALSE);
		ActionWait(2.0f);
		ActionDoCommand(DetermineCombatRound());
		SetCreatureOverrideAIScriptFinished();	//Running back home, DCR can stop
	}
}
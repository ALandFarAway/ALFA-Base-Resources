//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_damagetracker_b
//::
//::	Tracks those who have hurt me, much like my lists of names from high school.
//::	from ginc_ai, used by the "attack who damaged me most" AI type
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 2/1/06

#include "ginc_ai"
#include "nw_i0_generic"
//#include "ginc_debug"

void main()
{
	object oGuardee=GetLocalObject(OBJECT_SELF,VAR_P_GUARDTHIS);
//	PrettyMessage("Trying to stay close to: "+GetTag(oGuardee));
	float fThresh, fDist=GetDistanceBetween(oGuardee,OBJECT_SELF);
	if (GetIsInCombat())
	{
		fThresh=GetLocalFloat(OBJECT_SELF,VAR_P_PROXIMITY_COMBAT);
		if (fDist>fThresh)
		{
			ClearAllActions(TRUE);
			__TurnCombatRoundOn(TRUE);
			ActionMoveToObject(oGuardee,TRUE,fThresh/3.0f);
			__TurnCombatRoundOn(FALSE);
		}
	}
	else
	{
		fThresh=GetLocalFloat(OBJECT_SELF,VAR_P_PROXIMITY);
		if (fDist>fThresh)
		{
			ClearAllActions();		
			if (fDist>GetLocalFloat(OBJECT_SELF,VAR_P_PROXIMITY_RUN))	
				ActionMoveToObject(oGuardee,TRUE,fThresh/3.0f);
			else
				ActionMoveToObject(oGuardee,FALSE,fThresh/3.0f);
		}
		if (GetIsInCombat(oGuardee)) //they're in trouble, but I'm not.. better fight.
			DetermineCombatRound();
	}



	AIContinueInterruptedScript(CREATURE_SCRIPT_ON_HEARTBEAT); //this script is an interrupt script, so this must be called
																//when you want the original to play
}
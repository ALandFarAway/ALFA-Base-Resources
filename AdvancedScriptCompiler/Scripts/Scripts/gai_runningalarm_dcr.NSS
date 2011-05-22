//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_runningalarm_dcr
//::
//::	Determine Combat Round for the Running Alarm AI.
//::
//::        Spell Queue AI's will cast spells form an ordered list attached to them.
//::		To Attach a list, use the function ******, the conversation script ******,
//::		or manually using these variables (must be done pre-spawn) *******.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/30/06

#include "nw_i0_generic"
#include "x2_inc_switches"
#include "ginc_param_const"
#include "ginc_ai"
#include "nw_i0_plot"

//#include "ginc_debug"

#include "ginc_ai"


object GetSuitableHelp()
{
	int i=0;
	object oHelp=GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_FRIEND,OBJECT_SELF,++i,CREATURE_TYPE_IS_ALIVE,TRUE);

	while ((GetIsObjectValid(oHelp))&&( (GetIsInCombat(oHelp)) ||  (GetIsPC(oHelp))   ))
		oHelp=GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_FRIEND,OBJECT_SELF,++i,CREATURE_TYPE_IS_ALIVE,TRUE);

	return oHelp;
}

void main()
{
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget(); //Handling Determine Combat round red tape

    if (__InCombatRound())	//if I'm already doing stuff, don't overload me here.
        return;

	//I'm in combat?! eep! Run to friends!
	
	vector vSelf, vGood, vBad;
	vSelf = GetPosition(OBJECT_SELF);
	object oThreat=GetLastAttacker();
	if (!GetIsObjectValid(oThreat))
		oThreat=oIntruder;


	vBad = VectorNormalize(  GetPosition(oThreat)-vSelf) * 3.0f;
	object oHelp = GetSuitableHelp();
	if (GetIsObjectValid(oHelp))
		vGood = VectorNormalize(  GetPosition(oHelp)-vSelf ) * 3.0f;
	else
		vGood=vSelf-vSelf;
	
	__TurnCombatRoundOn(TRUE);
	ClearAllActions();
	ActionMoveToLocation(Location(GetArea(OBJECT_SELF), vSelf - vBad + vGood, 0.0f),TRUE);
	ActionDoCommand(SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK));//Help me!!!
	__TurnCombatRoundOn(FALSE);
	ActionMoveToObject(oHelp,FALSE, GetDistanceBetween(OBJECT_SELF,oHelp) - 3.0f);
	ActionMoveAwayFromObject(oThreat,TRUE,7.0f);

	SetCreatureOverrideAIScriptFinished();	//It's ok. I bravely handled things by bolting away from trouble.
}


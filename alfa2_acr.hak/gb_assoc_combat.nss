//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: gb_assoc_combat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "x0_inc_henai"
#include "x2_inc_spellhook"

void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()));

   	HenchResetCombatRound();	

	if (!GetAssociateState(NW_ASC_MODE_PUPPET) &&
		!GetSpawnInCondition(NW_FLAG_SET_WARNINGS) &&
		!HenchCheckEventClearAllActions(TRUE))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " end combat round combat round");
        HenchDetermineCombatRound();
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();
}
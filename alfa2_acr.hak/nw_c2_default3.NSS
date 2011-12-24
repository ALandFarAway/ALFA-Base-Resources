//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
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
#include "ginc_behavior"


void main()
{
//    Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()));

   	HenchResetCombatRound();

    int iFocused = GetIsFocused();
 
    if (iFocused <= FOCUSED_STANDARD)
    {
		if (!HenchCheckEventClearAllActions(TRUE))
		{
		    if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
		    {
		        HenchDetermineSpecialBehavior();
		    }
		    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
		    {
		        HenchDetermineCombatRound();
		    }
		}
	}
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND));
    }
}
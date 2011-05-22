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
// ChazM - 4/21/05 modified so NPC's can stay focused

#include "NW_I0_GENERIC"
#include "ginc_behavior"

void main()
{
    int iFocused = GetIsFocused();
 
    if (iFocused <= FOCUSED_STANDARD)
    {
        if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
        {
            DetermineSpecialBehavior();
        }
        else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
        {
           DetermineCombatRound();
        }
    }
    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}


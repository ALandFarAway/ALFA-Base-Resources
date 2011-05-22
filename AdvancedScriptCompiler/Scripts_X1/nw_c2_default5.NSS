//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "hench_i0_ai"
#include "ginc_behavior"


void main()
{
    int iFocused = GetIsFocused();

	// I've been attacked so no longer partially focused
	if (iFocused == FOCUSED_PARTIAL)
	{
		SetLocalInt(OBJECT_SELF, VAR_FOCUSED, FOCUSED_STANDARD); // no longer focused
	}
    if (iFocused == FOCUSED_FULL)
	{
        // remain focused
    }
	else if(GetFleeToExit())
    {
        ActivateFleeToExit();
    }
    else if (GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        // We give an attacker one warning before we attack
        // This is not fully implemented yet
        SetSpawnInCondition(NW_FLAG_SET_WARNINGS, FALSE);

        //Put a check in to see if this attacker was the last attacker
        //Possibly change the GetNPCWarning function to make the check
    }
    else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
        object oAttacker = GetLastAttacker();

        if (!GetIsObjectValid(oAttacker))
        {
            // Don't do anything, invalid attacker

        }
        else if (!GetIsFighting(OBJECT_SELF))
        {
            if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
            {
                if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
                {
					CheckRemoveStealth();
                }
                SetSummonHelpIfAttacked();
				if (GetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
				{
                	HenchDetermineSpecialBehavior(GetLastAttacker());
				}
            }
            else if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
            {
				CheckRemoveStealth();
                SetSummonHelpIfAttacked();
				if (GetIsValidRetaliationTarget(oAttacker))	//DBR 5/30/06 - this if line put in for quest giving/plot NPC's
				{
                	HenchDetermineCombatRound(GetLastAttacker());
				}
            }
        }
    }
    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_ATTACKED));
    }
}
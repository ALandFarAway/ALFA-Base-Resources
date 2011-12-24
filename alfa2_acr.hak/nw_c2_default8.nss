//::///////////////////////////////////////////////
//:: Default: On Disturbed
//:: NW_C2_DEFAULT8
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//::///////////////////////////////////////////

// * Make me hostile the faction of my last attacker (TEMP)
//  AdjustReputation(OBJECT_SELF,GetFaction(GetLastAttacker()),-100);
// * Determined Combat Round

#include "hench_i0_ai"


void main()
{
    object oTarget = GetLastDisturbed();

    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        if(GetIsObjectValid(oTarget))
        {
			if (GetIsEnemy(oTarget) || GetHenchOption(HENCH_OPTION_ENABLE_INVENTORY_DISTRURBED))
			{
				HenchDetermineCombatRound(oTarget);
			}
        }
    }
    if(GetSpawnInCondition(NW_FLAG_DISTURBED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DISTURBED));
    }
}
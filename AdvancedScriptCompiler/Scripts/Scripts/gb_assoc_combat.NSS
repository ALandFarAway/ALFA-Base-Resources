// gb_assoc_combat
/*
    Associate On Combat Round End
    
    Calls the end of combat script every round
*/
// ChazM 2/15/07

#include "X0_INC_HENAI"
#include "X2_inc_spellhook"

void main()
{

    if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       HenchmenCombatRound(OBJECT_INVALID);
    }


    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();
}
// gb_comp_combat.nss
/*
	Companion OnEndCombatRound handler
	
	Based off Associate End of Combat End (NW_CH_AC3)	
*/
// ChazM 12/5/05
// BMA-OEI 7/08/06
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// BMA_OEI 09/13/06 -- Added NW_ASC_MODE_STAND_GROUND check

#include "hench_i0_ai"
#include "x0_inc_henai"

void main()
{
//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
//	Jug_Debug("*****" + GetName(OBJECT_SELF) + " end combat round action " + IntToString(GetCurrentAction()) + " time " + FloatToString(time));

   	HenchResetCombatRound();

	if (!GetAssociateState(NW_ASC_MODE_PUPPET) &&
		!GetHasPlayerQueuedAction(OBJECT_SELF) &&
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
}
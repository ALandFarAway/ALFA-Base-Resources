// gb_comp_combat.nss
/*
	Companion OnEndCombatRound handler
	
	Based off Associate End of Combat End (NW_CH_AC3)	
*/
// ChazM 12/5/05
// BMA-OEI 7/08/06
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// BMA_OEI 09/13/06 -- Added NW_ASC_MODE_STAND_GROUND check

#include "x0_inc_henai"

void main()
{
	if ( ( GetSpawnInCondition(NW_FLAG_SET_WARNINGS) == FALSE ) && ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) )
	{
		if (GetAssociateState(NW_ASC_MODE_PUPPET)==FALSE)	//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
			HenchmenCombatRound( OBJECT_INVALID );
	}

	if ( GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_END_COMBAT_ROUND) );
	}
}
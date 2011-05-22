// gb_comp_attack.nss
/*
	Companion OnAttacked handler
	
	Based off Associate OnAttacked (NW_CH_AC5)
*/
// ChazM 12/5/05
// BMA-OEI 7/08/06 -- Rewrote to preserve action queue
// BMA-OEI 7/14/06 -- Follow mode interruptible
// BMA-OEI 7/17/06 -- Removed STAND_GROUND check, added spell target enemy check
// BMA-OEI 9/12/06 -- Added STAND_GROUND check back

#include "X0_INC_HENAI"

void main()
{
	SpeakString( "NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK );
	
	if ( ( GetAssociateState(NW_ASC_IS_BUSY) == FALSE ) && ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) )
	{
		if ( ( GetNumActions(OBJECT_SELF) == 0 ) || ( GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW ) )
		{
			// If I don't already have a valid target...
			if ( ( GetIsObjectValid(GetAttackTarget()) == FALSE ) &&
				 ( ( GetIsObjectValid(GetAttemptedSpellTarget()) == FALSE ) ||
				   ( GetIsEnemy(GetAttemptedSpellTarget()) == FALSE ) ) )
			{
				object oAttacker = GetLastAttacker();
								
				if ( GetIsObjectValid(oAttacker) == TRUE )
				{
					HenchmenCombatRound( oAttacker );
				}
			}
		}
	}

	if ( GetSpawnInCondition(NW_FLAG_ATTACK_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_ATTACKED) );
	}
}
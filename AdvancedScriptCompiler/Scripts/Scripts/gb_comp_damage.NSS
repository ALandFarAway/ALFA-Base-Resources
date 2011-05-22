// gb_comp_damage.nss
/*
	Companion OnDamaged handler
	
	Based off Associate OnDamaged (NW_CH_AC6)
*/
// ChazM 12/5/05
// ChazM 5/18/05 reference to master now uses GetCurrentMaster() - returns master for associate or companion
// BMA-OEI 7/08/06 -- Rewrote to preserve action queue
// BMA-OEI 7/14/06 -- Follow mode interruptible
// BMA-OEI 7/17/06 -- Removed STAND_GROUND check, added spell target checks
// BMA-OEI 9/13/06 -- Added STAND_GROUND check back

#include "X0_INC_HENAI"

void main()
{
	if ( ( GetAssociateState(NW_ASC_IS_BUSY) == FALSE ) && ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) )
	{
		if ( ( GetNumActions(OBJECT_SELF) == 0 ) || ( GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW ) )
		{
			object oDamager = GetLastDamager();
			object oTarget = GetAttackTarget();
            
			if ( GetIsObjectValid(oTarget) == FALSE ) 
			{
				oTarget = GetAttemptedSpellTarget();
			}
			
			if ( ( GetIsObjectValid(oTarget) == FALSE ) ||
				 ( GetIsEnemy(oTarget) == FALSE ) ||
				 ( GetIsDamagerABetterTarget(oDamager, oTarget) == TRUE ) )
			{
				oTarget = oDamager;
			}
				
			if ( GetIsObjectValid(oTarget) == TRUE )
			{
                //PrettyDebug(GetName(OBJECT_SELF) + ": on Damaged!  Retaliating against: " + GetName(oTarget));
				HenchmenCombatRound( oTarget );
			}
		}
    }

	if ( GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT) == TRUE )
	{
		SignalEvent( OBJECT_SELF, EventUserDefined(EVENT_DAMAGED) );
	}
}
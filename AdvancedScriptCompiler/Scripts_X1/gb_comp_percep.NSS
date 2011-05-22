// gb_comp_percep.nss
/*
	Companion OnPerception handler
	
	Based off Associate OnDamaged (X0_CH_HEN_PERCEP)
*/
// ChazM 12/5/05
// ChazM 5/18/05 reference to master now uses GetCurrentMaster() - returns master for associate or companion
// ChazM 7/11/06 added exception for force follow.
// BMA-OEI 7/14/06 -- Rewrote to preserve action queue, follow mode interruptible
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// DBR - 09/08/06 - fix for companions training down a line of hostiles - added GetCurrentAction/GetNumActions check
// DBR - 09/13/06 - Removed specific target for HenchmanCombatRound() when a hostile is seen
// DBR - 10/25/06 - Added checks for Defend Master new behavior - companions do not attack those that are not in combat.


//#include "X0_INC_HENAI"
//#include "ginc_companion"

// void OriginalHenchPercep();

void main()
{
	ExecuteScript("gb_assoc_percep", OBJECT_SELF);
}
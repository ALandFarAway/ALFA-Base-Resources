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

//#include "X0_INC_HENAI"

void main()
{
	ExecuteScript("gb_assoc_damage", OBJECT_SELF);
}
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

void main()
{
	ExecuteScript("gb_assoc_attack", OBJECT_SELF);
}
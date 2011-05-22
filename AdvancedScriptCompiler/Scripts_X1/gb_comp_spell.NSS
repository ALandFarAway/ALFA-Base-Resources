// gb_comp_spell.nss
/*
	Companion OnSpellCastAt handler
	
	Based off Henchmen On Spell Cast At (NW_CH_ACB)
*/
// ChazM 12/5/05
// ChazM 5/18/05 don't react if spell cast by someone else in the same party.  reference to master now uses GetCurrentMaster() - returns master for associate or companion
// BMA-OEI 7/08/06 -- Rewrote to preserve action queue
// BMA-OEI 7/14/06 -- Follow mode interruptible
// BMA-OEI 7/17/06 -- Removed STAND_GROUND check
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// BMA-OEI 09/20/06 -- AOEBEHAVIOR: Disable spell casting while Polymorphed, Removed ActionForceMove

#include "x0_i0_henchman"
#include "X0_INC_HENAI"
#include "x2_i0_spells"
#include "ginc_companion"

void OriginalHenchSpell();

void main()
{
	ExecuteScript("gb_assoc_spell", OBJECT_SELF);
}
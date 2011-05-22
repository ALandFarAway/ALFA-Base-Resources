// gui_death_respawn.nss
/*
	Death GUI 'Respawn' callback: wake up groggy
*/
// BMA-OEI 6/29/06


#include "ginc_death"


void main()
{
	// Resurrect PC
	object oPC = OBJECT_SELF;
	WakeUpCreature( oPC );
	RemoveDeathScreens( oPC );
	
	// Apply Groggy penalty
	effect eGroggy = EffectDazed();
	//eGroggy = EffectLinkEffects( EffectSlow(), eGroggy );	
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eGroggy, oPC, RoundsToSeconds( 2 ) );	
}
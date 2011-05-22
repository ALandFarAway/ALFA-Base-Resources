// gui_death_hidden_click.nss
/*
	Hidden Death GUI 'Click' callback
*/
// BMA-OEI 6/29/06


#include "ginc_death"


void main()
{
	object oPC = OBJECT_SELF;
	RemoveDeathScreens( oPC );
	
	// Check if there are any members left for PC to possess
	if ( GetIsDead(oPC) == TRUE )
	{
		if ( GetIsPartyPossessible(oPC) == FALSE )
		{
			ShowProperDeathScreen( oPC );
		}		
	}
}
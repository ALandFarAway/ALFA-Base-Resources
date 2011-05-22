// gui_death_respawn_self.nss
/*
	NWN2 Default Death Screen 'Respawn' callback
*/
// BMA-OEI 7/20/06
// BMA-OEI 11/08/06 -- Close SCREEN_DEATH_DEFAULT


#include "ginc_death"


void main()
{
	ResurrectCreature( OBJECT_SELF );
	CloseGUIScreen( OBJECT_SELF, "SCREEN_DEATH_DEFAULT" );
}
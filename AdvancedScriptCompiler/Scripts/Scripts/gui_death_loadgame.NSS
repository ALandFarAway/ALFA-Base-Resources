// gui_death_loadgame.nss
/*
	Death GUI 'Load Game' callback
*/
// BMA-OEI 6/29/06
// BMA-OEI 9/01/06: Override "Save First?" dialog in UIScene_OnAdd_CreateLoadGameList()


#include "ginc_death"
#include "ginc_gui"


void main()
{
	// BMA-OEI 9/01/06: Override "Save First?" dialog in UIScene_OnAdd_CreateLoadGameList()
	SetLocalGUIVariable( OBJECT_SELF, GUI_LOAD_GAME, 3, "1" );
	
	HideDeathScreen( OBJECT_SELF );
	ShowHiddenDeathScreen( OBJECT_SELF );
	ShowLoadGame( OBJECT_SELF );
}
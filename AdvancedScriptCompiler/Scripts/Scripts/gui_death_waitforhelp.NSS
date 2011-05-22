// gui_death_waitforhelp.nss
/*
	Death GUI 'Wait For Help' callback: displays full-screen hidden death button
*/
// BMA-OEI 08/06/06


#include "ginc_death"


void main()
{
	object oPC = OBJECT_SELF;
	ShowHiddenDeathScreen( oPC );
	HideDeathScreen( oPC );
}
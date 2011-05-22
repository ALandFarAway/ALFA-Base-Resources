// go_force_cutscene_cleanup
/*
	This script is called by ForceIPCleanerCleanup() in ginc_cutscene.
	It must be run on an IP Cleaner object.
*/
// ChazM 5/24/07

#include "ginc_cutscene"

void main()
{
	object oPC = GetFirstPC();
	CombatCutsceneCleanUp(oPC, GetArea(OBJECT_SELF));
	SetLocalInt(OBJECT_SELF, IPC_DELETE_SELF, 1);
}
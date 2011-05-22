// gp_ipcleaner_hb.nss
/*
	Heartbeat handler to clean up area after combat cutscene has ended.
	Used in conjunction with ginc_cutscene's CombatCutsceneSetup();
*/
// BMA-OEI 3/7/06

#include "ginc_cutscene"
#include "ginc_debug"		
	
void main()
{
	AttemptCombatCutsceneCleanUp();
	QueueCombatCutsceneCleanUp();		
}
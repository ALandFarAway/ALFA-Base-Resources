// ga_force_exit
/*
	Wrapper for ForceExit, which makes a creature "exit" by moving it to a location and then removing it.
	Params:
		sCreatureTag - tag of the exiting creature
		sWPTag - tag of the waypoint (or object) to move to.
		bRun - 0 = walk; 1 = run
		 
	When the creature reaches the specified loaction he will be destroyed, or in the case of roster members, despawned.
	Note: This is inteded to always work, and will remove flags such as plot and not-destroyable from the creature
	before attempting to destroy it.

*/
// EPF
// ChazM 6/22/06 - just a comment change.
// ChazM 9/18/06 - more comment changes.

#include "ginc_misc"
	
void main(string sCreatureTag, string sWPTag, int bRun)
{
	//PrettyDebug("Forcing Exit!");
	ForceExit(sCreatureTag, sWPTag, bRun);
}
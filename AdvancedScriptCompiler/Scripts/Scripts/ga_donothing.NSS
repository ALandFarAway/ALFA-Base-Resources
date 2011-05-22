// ga_donothing.nss
/*
   Do nothing, really.
*/
// BMA-OEI 8/17/05
// BMA-OEI 1/11/06 removed default param
		
#include "ginc_debug"
	
void main(string sDebugMessage)
{
	if (sDebugMessage == "") sDebugMessage = "this is a placeholder script";
	PrettyMessage("ga_donothing: rly " + sDebugMessage);
}
// ga_travel
/*
	 Moves sTarget to sDestination.  If Destination is in another area, sTarget will attempt to get there intelligently.
*/
// ChazM 12/01/06

#include "x0_i0_transport"
#include "ginc_param_const"

void main(string sDestination, string sTarget, int bRun, float fDelay)
{
    object oTarget = GetTarget(sTarget, TARGET_OBJECT_SELF);
    object oDestination = GetTarget(sDestination);

	//AssignCommand(oTarget, DelayCommand(fDelay, JumpToObject(oDestination)));

	if (fDelay == 0.0)	
		TravelToObject(oDestination, oTarget, bRun); // use the default for fDelay.
	else
		TravelToObject(oDestination, oTarget, bRun, fDelay);
		

}	
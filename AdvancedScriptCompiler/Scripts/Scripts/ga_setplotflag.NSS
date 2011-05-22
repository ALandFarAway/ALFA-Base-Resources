// ga_setplotflag(string sTarget, int bPlotFlag)
/*
	SetPlotFlag on target object to bPlotFlag.
	
	Parameters:
		string sTarget	= tag of target object, if blank use OWNER
		int bPlotFlag	= 0 for FALSE, else for TRUE
*/
// BMA-OEI 9/28/05

#include "ginc_param_const"
#include "ginc_debug"

void main(string sTarget, int bPlotFlag)
{
	object oTarget = GetTarget(sTarget, TARGET_OWNER);

	if (GetIsObjectValid(oTarget) == TRUE)
	{
		if (bPlotFlag != 0)
		{
			bPlotFlag = TRUE;
		}
		else
		{
			bPlotFlag = FALSE;
		}

		SetPlotFlag(oTarget, bPlotFlag);
	}
	else
	{
		ErrorMessage("ga_setplotflag: " + sTarget + " not found!");
	}
}
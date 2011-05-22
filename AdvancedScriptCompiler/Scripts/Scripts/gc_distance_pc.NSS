// gc_distance_pc(string sTag, string sCheck)
/*
   This script compares the distance between sTag and the nearest PC against sCheck.

   Parameters:
     string sTag   = Tag of object. If blank, use OWNER.
     string sCheck = Conditional to compare distance(object,PC) to.
                     "<3.0"  - distance < 3.0m
                     "=10.0" - distance == 10.0m
                     "!4.0"  - distance != 4.0m
*/
// BMA-OEI 1/14/06
// ChazM 9/20/06 - fixed inc.

#include "nw_i0_plot"
#include "ginc_param_const"
//#include "ginc_debug"
#include "ginc_var_ops"
	
int StartingConditional(string sTag, string sCheck)
{
	object oObject = GetTarget(sTag, TARGET_OWNER);
	object oPC = GetNearestPC(oObject);
	float fDistance = GetDistanceBetween(oObject, oPC);

	string sOperator = GetStringLeft(sCheck, 1);

	float fCompare = StringToFloat(GetStringRight(sCheck, GetStringLength(sCheck) - 1));

	return CheckVariableFloat(fDistance, sOperator, fCompare);
}
// gc_area
//
// True if creature with tag sTarget is in area with tag sArea.  Can use parameter constants like $OBJECT_SELF as defined in ginc_param_const.
// Empty string for sTarget defaults to OBJECT_SELF.
//
// EPF 8/2/05

#include "ginc_misc"	

int StartingConditional(string sArea, string sTarget)
{
	object oTarget = GetTarget(sTarget);
	object oArea = GetObjectByTag(sArea);

	if(sTarget == "")
	{
		oTarget = OBJECT_SELF;
	}

	
	if(!GetIsObjectValid(oArea) || !GetIsObjectValid(oTarget))
	{
		return FALSE;
	}

	if(GetArea(oTarget) == oArea)
	{
		return TRUE;
	}
	return FALSE;	
}
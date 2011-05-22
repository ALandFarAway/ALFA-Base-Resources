//::///////////////////////////////////////////////////////////////////////////
//::
//::	gc_henchman
//::
//::	Determines if a creature is a henchman or not.
//::
//::        Parameters:     
//::				- sTarget -  The tag of the potential henchman
//::				- sMaster -  The tag of the potential master. Uses PC Speaker if blank.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06 

#include "ginc_param_const"
#include "ginc_henchman"



int StartingConditional(string sTarget, string sMaster)
{
	object oMaster;
	object oHench=GetTarget(sTarget);

	if (sMaster=="")
		oMaster=GetPCSpeaker();
	else
		oMaster=GetTarget(sMaster);    

	if (!GetIsObjectValid(oMaster))
	{
		PrintString("gc_henchman: Could not referance a master In area " + GetName(GetArea(OBJECT_SELF)));
		return 0;
	}
	if (!GetIsObjectValid(oHench))
	{
		PrintString("gc_henchman: Could not find possible henchman: " + sTarget + " In area " + GetName(GetArea(OBJECT_SELF)));
		return 0;
	}

	return GetIsHenchman(oMaster,oHench);
}
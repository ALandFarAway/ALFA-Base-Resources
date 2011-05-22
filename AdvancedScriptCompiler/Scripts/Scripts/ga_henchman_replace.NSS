//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_henchman_replace
//::
//::	Repalces a target henchman from your party with another (henchmen are not companions).
//::
//::        Parameters:
//::			sOld - tag of the creature you want to remove as a companion.
//::			sNew - tag of the creature you want to add as a companion.
//::			bForce  - if set to 1, sTarget will be added even if player already has maximum henchman
//::            bOverrideBehavior - if set to 1, sTarget's event handlers (scripts) will be replaced with henchman ones.
//::			sOptionalMasterTag - OPTIONAL - if ga_henchman_add wasn't used to add the henchman, you can supply the master tag here.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06

#include "ginc_param_const"
#include "ginc_henchman"


void main(string sOld, string sNew, int bForce, int bOverrideBehavior, string sOptionalMasterTag)
{
	object oMaster=OBJECT_INVALID,oNew,oOld;

	if (sOld=="")				//Get the old henchman
		oOld =GetLastSpeaker();
	else
		oOld =GetTarget(sOld);
	if (!GetIsObjectValid(oOld))	//does he exist?
	{
		PrintString("ga_henchman_replace: Couldn't find henchman: "+sNew);
		return;
	}
	if (sNew=="")				//Get the new henchman
		oNew =GetLastSpeaker();
	else
		oNew =GetTarget(sNew);
	if (!GetIsObjectValid(oNew))	//does he exist?
	{
		PrintString("ga_henchman_replace: Couldn't find henchman: "+sOld);
		return;
	}

	//Get the Master
	if (sOptionalMasterTag!="")	//if a tag was supplied, use that
		oMaster=GetTarget(sOptionalMasterTag);
	if (!GetIsObjectValid(oMaster)) //if we still don't have a master, try checking for a stored value
		oMaster=GetLocalObject(oOld,sMasterRef);
	if (!GetIsObjectValid(oMaster)) //if we still don't have a master, try using the PC Speaker
		oMaster=(GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	if (!GetIsObjectValid(oMaster)) //Safety first, ladies and gentlemen
	{
		PrintString("ga_henchman_replace: Couldn't reference master.");
		return;
	}
	
	//Ok, boot out the old henchman
	HenchmanRemove(oMaster,oOld);
	//And welcome in the new henchman
	HenchmanAdd(oMaster,oNew,bForce,bOverrideBehavior);
}

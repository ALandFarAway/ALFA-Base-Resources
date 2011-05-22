//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_henchman_add
//::
//::	Adds a target creature to your party as a henchman (not a companion).
//::
//::        Parameters:
//::			sTarget - tag of the creature you want to add
//::			bForce  - if set to 1, sTarget will be added even if player already has maximum henchman
//::			sMaster - The Creature you are adding the henchman to (default is PC Speaker)
//::            bOverrideBehavior - if set to 1, sTarget's event handlers (scripts) will be replaced with henchman ones.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06

#include "ginc_param_const"
#include "ginc_henchman"



void main(string sTarget, int bForce, string sMaster, int bOverrideBehavior)
{
	object oMaster,oHench;

	if (sMaster=="")
		oMaster=(GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	else
		oMaster=GetTarget(sMaster);
	oHench =GetTarget(sTarget);

	if (!GetIsObjectValid(oMaster))//tests for safety
	{
		PrintString("ga_henchman_add: Couldn't find master: "+sMaster);
		return;
	}
	if (!GetIsObjectValid(oHench))
	{
		PrintString("ga_henchman_add: Couldn't find henchman: "+sTarget);
		return;
	}

	HenchmanAdd(oMaster,oHench,bForce,bOverrideBehavior);


}

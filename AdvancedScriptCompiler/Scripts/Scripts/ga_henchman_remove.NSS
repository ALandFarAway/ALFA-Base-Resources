//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_henchman_remove
//::
//::	Removes a target creature from your party (must be a henchman, not a companion).
//::
//::        Parameters:
//::			sTarget - tag of the creature you want to remove. Default is NPC speaker
//::			sOptionalMasterTag - No longer used.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/28/06
// ChazM 10/18/06 - sOptionalMasterTag no longer used.
// ChazM 7/17/07 - added clear actions to get rid of following

#include "ginc_param_const"
#include "ginc_henchman"

// sOptionalMasterTag no longer used
void main(string sTarget, string sOptionalMasterTag)
{
	object oMaster, oHench;
	
	oHench = GetTarget(sTarget);
		
	if (!GetIsObjectValid(oHench))	//does he exist?
	{
		PrettyDebug("ga_henchman_remove: Couldn't find henchman: " + sTarget);
		return;
	}
	
	oMaster = GetMaster(oHench);
	
	if (!GetIsObjectValid(oMaster)) //Safety first, ladies and gentlemen
	{
		PrettyDebug("ga_henchman_remove: Couldn't reference master.");
		return;
	}

	HenchmanRemove(oMaster,oHench);
	// Henchmen will still be following, so clear actions to get rid of that
	AssignCommand(oHench, ClearAllActions());
	
}
// gc_is_in_party(string sTargetTag)
/* 
	Check if target creature is in the party of the PC speaker

   Parameters:
     string sTargetTag = Tag of the creature to check. If empty, use dialog OWNER.
	 
*/
// ChazM 4/11
// BMA 4/28/05 added GetTarget()
// EPF 11/30/05 fixing to work for Roster companions.
// 12/2/05 fixed bug where it didn't check non-PC faction members.
// EPF 1/28/06 -- Created a new function in ginc_companions, now this script is just a wrapper.
// ChazM 5/29/07 - rewrite

#include "ginc_param_const"

int StartingConditional(string sTargetTag)
{
	object oPC = GetPCSpeaker();
	object oTarget = GetTarget(sTargetTag, TARGET_OWNER);
	int bRet = GetFactionEqual(oPC, oTarget);
	
	return (bRet);
}
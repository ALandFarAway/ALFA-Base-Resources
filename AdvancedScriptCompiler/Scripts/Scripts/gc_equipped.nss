// gc_equipped(string sItem, string sTarget, int bExactMatch)
/*
   Check to see if a given item is equipped by a given creature

   Parameters:
     string sItem    = The tag, or partial tag of the item.  
     string sTarget  = The tag of the creature. If blank, use PCSpeaker.
                       "$PARTY" is a non-standard target constant that will check the entire party.
     int bExactMatch = If 0, allow sItem to be a tag substring. 
*/
// TDE 3/11/04
// BMA 5/11/05 rewrite to include party, replaced UseName option with FindExact
// BMA-OEI 1/11/06 removed default param

#include "ginc_misc"
#include "ginc_param_const"

int StartingConditional(string sItem, string sTarget, int bExactMatch)
{
	object oTarget;
	
	if ("$PARTY" == sTarget)
	{
		// Check PC Speaker's party for equipped item
		oTarget = GetPCSpeaker();
		return (GetPartyMemberHasEquipped(sItem, oTarget, FALSE, bExactMatch));
	}
	else
	{
		// Find target, default PC Speaker to check equipped item
		oTarget = GetTarget(sTarget, TARGET_PC);
		return (GetIsItemEquipped(sItem, oTarget, bExactMatch));
	}
}
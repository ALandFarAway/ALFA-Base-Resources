// gc_is_in_combat
//
// Returns true if sTarget is in combat

// EPF 1/30/06

#include "ginc_misc"
		
int StartingConditional(string sTarget)
{
	return GetIsInCombat(GetTarget(sTarget));
}
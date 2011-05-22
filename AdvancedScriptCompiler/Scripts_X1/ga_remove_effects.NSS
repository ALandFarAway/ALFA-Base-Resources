// ga_remove_effects
//
// Remove all effects from sTarget. If sTarget is left blank, this script removes all effects from the party.

// EPF 7/11/07

#include "ginc_param_const"
#include "ginc_cutscene"


void RemoveAllEffectsFromParty()
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = GetFirstPC();
	}	
	
	object oFM = GetFirstFactionMember(oPC,FALSE);
	while(GetIsObjectValid(oFM))
	{
		RemoveAllEffects(oFM,FALSE);
		oFM = GetNextFactionMember(oPC,FALSE);
	}
}

void main(string sTarget)
{
	object oTarget = GetTarget(sTarget);
	if(sTarget != "")
	{
		if(GetIsObjectValid(oTarget))
		{
			RemoveAllEffects(oTarget, FALSE);
		}
	}
	else
	{
		RemoveAllEffectsFromParty();
	}
}
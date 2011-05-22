//	ga_initiate_encounter
/*
    Transitions the party to the encounter map and destroys the overland version
	of the creature.
*/
// JH/EF-OEI: 01/16/08
// NLC: 03/08 - Updated to use new Dialog Skills and to add Parameters for Forcing groups hostile.

#include "ginc_overland"

void main(int nDialogSkill, int nSkillDC, int bGroup1ForceHostile = FALSE, int bGroup2ForceHostile = FALSE, 
			int bGroup3ForceHostile = FALSE, int bGroup4ForceHostile = FALSE, int bGroup5ForceHostile = FALSE)
{
	object oPC = GetFactionLeader(GetFirstPC());
	InitiateEncounter(nDialogSkill, nSkillDC, bGroup1ForceHostile, bGroup2ForceHostile, bGroup3ForceHostile, bGroup4ForceHostile, bGroup5ForceHostile, oPC);
	
	/*	Removes the overland map version of the creature.	*/
	if (GetIsObjectValid(OBJECT_SELF))
	{
		DestroyObject(OBJECT_SELF, 0.2f);
	}
}
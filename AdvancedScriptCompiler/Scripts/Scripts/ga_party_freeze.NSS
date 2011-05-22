// ga_party_freeze()
/*
	Freeze PC party for cutscene. Temporarily save NW_ASC_MODE_STAND_GROUND state.
	Use ga_party_unfreeze() to restore NW_ASC_MODE_STAND_GROUND state.
*/
// BMA-OEI 3/7/06

#include "ginc_cutscene"	
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		// Save current stand ground state
		SaveStandGroundState(oMember);

		// Force all members to stand ground
		SetAssociateState(NW_ASC_MODE_STAND_GROUND, TRUE, oMember);

		// Clear action queue and combat state
		AssignCommand(oMember, ClearAllActions(TRUE));

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}
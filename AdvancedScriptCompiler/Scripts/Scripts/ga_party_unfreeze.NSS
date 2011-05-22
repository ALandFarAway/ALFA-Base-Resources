// ga_party_unfreeze()
/*
	Unfreeze PC party at end of cutscene. Restore NW_ASC_MODE_STAND_GROUND state.
	Use ga_party_freeze() to save NW_ASC_MODE_STAND_GROUND state.
*/
// BMA-OEI 3/7/06

#include "ginc_cutscene"	
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	object oFirstPCInFaction = GetFirstFactionMember(oPC,TRUE);
	
	if(!GetIsObjectValid(oFirstPCInFaction))
	{
		oPC = GetPrimaryPlayer();
		
		if(!GetIsObjectValid(oPC))
		{
			oPC = GetFirstPC();
		}
	}
	
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		// Set NW_ASC_MODE_STAND_GROUND to pre-ga_party_freeze() value
		LoadStandGroundState(oMember);
		
		oMember = GetNextFactionMember(oPC, FALSE);
	}
}
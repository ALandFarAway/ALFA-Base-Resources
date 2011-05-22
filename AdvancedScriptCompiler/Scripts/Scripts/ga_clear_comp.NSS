// ga_clear_comp()
/* 
   Removes all roster members from the PC party. Removed roster members are not despawned.
*/
// BMA-OEI 7/20/05
// EPF 1/9/06 -- added RemoveAllCompanions call.
// TDE 3/23/06 -- Replaced entire script with DespawnAllCompanions.
// BMA-OEI 5/23/06 -- replaced w/ RemoveRosterMembersFromParty(), updated comment
		
#include "ginc_companion"
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	RemoveRosterMembersFromParty(oPC, FALSE, FALSE); 
}
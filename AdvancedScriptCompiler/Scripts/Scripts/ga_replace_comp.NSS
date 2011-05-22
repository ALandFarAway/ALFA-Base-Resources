// ga_replace_comp(string sCompToRemove, string sCompToAdd)
//
// replace companion with tag sCompToRemove with companion with tag sCompToAdd
//
// EPF 6/14/05
// ChazM 8/3/05
// EPF 11/30/05 -- fixing to work with companions
	
#include "ginc_param_const"
#include "ginc_companion"
	
void main(string sCompToRemove, string sCompToAdd)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

	string sRosterToAdd = GetRosterNameFromObject(GetTarget(sCompToAdd));
	string sRosterToRemove = GetRosterNameFromObject(GetTarget(sCompToRemove));
	
	RemoveRosterMemberFromParty(sRosterToRemove, oPC);
	AddRosterMemberToParty(sRosterToAdd, oPC);
}
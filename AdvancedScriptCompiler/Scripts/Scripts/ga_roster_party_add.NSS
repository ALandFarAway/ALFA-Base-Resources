//ga_roster_party_add
/*
	add roster party member to PC Speaker's party	
	
//RWT-OEI 09/15/05
//This function will add a Roster Member to the same party that the
//player character object passed in belongs to. Note that if the
//Roster Member is already in another party, this function will not
//work. They must be removed from the other party first. You can check
//for this condition with the GetIsRosterMemberAvailable() function. 
//If the Roster Member is Available, then they can be added to the party.
//Also, if the RosterMember already exists somewhere in the module, 
//the RosterMember will be warped to be near the player character. If
//the RosterMember does not exist yet, they will be loaded into the module
//exactly as they were when they were last saved out. 
//Returns true on success
int AddRosterMemberToParty( string sRosterName, object oPC );
*/
// ChazM 12/2/05
// ChazM 12/13/05 - just does an add.

#include "ginc_debug"

void main(string sRosterName)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int bResult = AddRosterMemberToParty(sRosterName, oPC);
}
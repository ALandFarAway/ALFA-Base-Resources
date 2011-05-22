//::///////////////////////////////////////////////////////////////////////////
//::
//::	ga_party_add.nss
//::
//::	Attempt to add Roster Member to the PC's party. Fails if Roster Member
//::	is already a member of a party, or if party size limit has been reached.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: BMA-OEI
//::	Created on: 10/18/05
//::
//::///////////////////////////////////////////////////////////////////////////

#include "ginc_debug"

void main(string sRosterName)
{
	object oPC = GetFirstPC();
	//int nPartyLimit = GetRosterNPCPartyLimit();
	int bResult = 0;

	// TODO: replace with actual nPartyLimit < nCurrentPartySize
	if (1 > 0)
	{
		bResult = AddRosterMemberToParty(sRosterName, oPC);

		if (bResult == TRUE)
		{
			PrettyMessage("ga_party_add: successfully added " + sRosterName);
		}
		else
		{
			PrettyError("ga_party_add: error adding " + sRosterName);
		}
	}
	else
	{
		PrettyError("ga_party_add: party limit exceeded! could not add " + sRosterName);
	}
}
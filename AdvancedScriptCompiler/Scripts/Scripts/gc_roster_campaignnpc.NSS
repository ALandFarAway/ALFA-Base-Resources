// gc_roster_campaignnpc( string sRosterName )
/*
	Returns CampaignNPC flag T/F of roster member sRosterName.
	Returns FALSE if unable to find sRosterName in roster table.

	//RWT-OEI 09/29/05
	//This function returns whether or not a valid roster member is set
	//as a Campaign NPC.  See description of SetIsRosterMemberCampaignNPC
	//for details on Campaign NPCs.
	//Returns true or false, depending. False returned if unable to find the
	//roster member
	int GetIsRosterMemberCampaignNPC( string sRosterName );
*/
// BMA-OEI 4/01/06
	
int StartingConditional( string sRosterName )
{
	int bResult = GetIsRosterMemberCampaignNPC( sRosterName );
	return ( bResult );
}
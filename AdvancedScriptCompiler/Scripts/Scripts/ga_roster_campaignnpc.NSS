// ga_roster_campaignnpc
/*
//RWT-OEI 09/29/05
//This function flags a Roster Member as being a Campaign NPC
//Campaign NPCs are NPCs that are saved to the roster to make them
//persist across modules, but will not appear on the Roster Member
//Select Screen on clients as NPCs available for adding to the party.
//Note that scripts can still add and remove Campaign NPCs to the party,
//but the client will never be able to add them via the UI
//Returns false if it was unable to find the Roster Member to set them
//as a campaign NPC
*/
// BMA 02/27/06
	
void main( string sRosterName, int nCampaignNPC )
{
	int bResult =  SetIsRosterMemberCampaignNPC(sRosterName, nCampaignNPC);
}
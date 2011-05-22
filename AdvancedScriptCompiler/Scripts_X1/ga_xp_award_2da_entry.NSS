// ga_xp_award_2da_entry
/*
	NOTE: AWARD ENTRY MUST BE SET FOR THIS SCRIPT TO WORK.

	Award party XP from the experience point award table (k_xp_award.2da) for this campaign.
	Params:
		iXPAwardID - the row number of the entry to award.
		bIndividualOnly - Only award to the current speaker.
	
	To customize this for use in a campaign, add k_xp_award.2da into the campaign folder, 
	using new data for the XP awards as desired.
	

	// 2da table and column names 
	const string TABLE_XP_AWARD	= "k_xp_awards";
	const string COL_XP			= "XP";
	const string COL_STR_REF	= "DescStrRef";
	const string COL_TEXT		= "DescriptionText"; // If no string ref is given, this will be used instead.
*/
// ChazM 4/18/07

#include "ginc_journal"

void main(int iXPAwardID, int bIndividualOnly)
{
	int bWholeParty = !bIndividualOnly;
	//SpawnScriptDebugger();
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	AwardXP(oPC, iXPAwardID, bWholeParty);
}	



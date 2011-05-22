// ginc_journal
/*
    journal/quest related functions
*/
// ChazM 9/28/05
// ChazM 9/29/05 added GetQuestXPPercentRewarded(), RewardCappedQuestXP(), RewardPartyQuestXP(), RewardPartyCappedQuestXP(),
//				renamed N2_Reward* functions, some temp functions	
// ChazM 7/26/06 Added AwardXP(), SendMessageToParty()
	
#include "X0_I0_PARTYWIDE"
#include "ginc_vars"
#include "ginc_item"

//void main() {}

const string QPR_SUFFIX		= "_XP_QPR";

// 2da table and column names
const string TABLE_XP_AWARD	= "k_xp_awards";
const string COL_XP			= "XP";
const string COL_STR_REF	= "DescStrRef";
const string COL_TEXT		= "DescriptionText";


//-------------------------------------------------
// Function Prototypes
//-------------------------------------------------

// Quest Info
int GetIsJournalQuestAssigned(string sPlotID, object oCreature);
int GetJournalQuestEntry(string sPlotID, object oCreature);
int GetQuestXPPercentRewarded(object oPC, string sQuestTag);

// Neverwinter 2 quest reward functions
//   non-party rewards
int RewardCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100);

//   party rewards
void RewardPartyUniqueItem(object oPC, string sItemResRef);
void RewardPartyItem(object oPC, string sItemResRef);
void RewardPartyGold(object oPC, int iGold);
void RewardPartyXP(object oPC, int iXP);
int RewardPartyQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100);
void RewardPartyCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100);

// special objective rewards with accompanying text from k_xp_awards.2da
void AwardXP(object oPC, int iXPAwardID, int bWholeParty=TRUE);

// From: X0_I0_PARTYWIDE
//void GiveGoldToAllEqually(object oPC, int nGoldToDivide);
//void GiveGoldToAll(object oPC, int nGold);
//void GiveXPToAllEqually(object oPC, int nXPToDivide);
//void GiveXPToAll(object oPC, int nXP);
	

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

//----------------------------------------
// Quest Info
//----------------------------------------

// Determine if Quest sPlotID is not 0 (assumes non-zero as having been assigned).
int GetIsJournalQuestAssigned(string sPlotID, object oCreature)
{
	return (GetJournalQuestEntry(sPlotID, oCreature) > 0);
}
/*	
// Determine if Quest sPlotID is not 0, but has not reached an endpoint (entryID non-zero and non-endpoint).
GetIsJournalQuestActive(string sPlotID, object oCreature)

// Determine if Quest sPlotID has reached any endpoint.
GetIsJournalQuestFinished(string sPlotID, object oCreature)
*/

int GetJournalQuestEntry(string sPlotID, object oCreature)
{
    int iQuestEntry = GetLocalInt(oCreature, "NW_JOURNAL_ENTRY" + sPlotID);
 	return (iQuestEntry);
}

// get the percent rewarded so far to this PC for this quest
int GetQuestXPPercentRewarded(object oPC, string sQuestTag)
{
    string sXPQuestPercentRewarded = sQuestTag + QPR_SUFFIX;
	int iQuestXPPercentRewarded = GetLocalInt(oPC, sXPQuestPercentRewarded);
	return (iQuestXPPercentRewarded);

}

//----------------------------------------
// Quest Rewards (non-party)
//----------------------------------------
// reward xp amount to single player, subject to cap
// return amount awarded
int RewardCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100)
{
	int iQuestXPPercentRewarded = GetQuestXPPercentRewarded(oPC, sQuestTag);

	// reduce reward to cap amount if necessary
	if ((iQuestXPPercentRewarded + iQuestXPPercent) > iQuestXPPercentCap)
	{
		iQuestXPPercent = iQuestXPPercentCap - iQuestXPPercentRewarded;
		if (iQuestXPPercent < 0)
			return (0);
	}

    string sXPQuestPercentRewarded = sQuestTag + QPR_SUFFIX;
	int iQuestXPReward =  (GetJournalQuestExperience(sQuestTag) * iQuestXPPercent)/100;
	GiveXPToCreature(oPC, iQuestXPReward);
	ModifyLocalInt(oPC, sXPQuestPercentRewarded, iQuestXPPercent);

	return (iQuestXPReward);
}

//----------------------------------------
// Party Quest Rewards
//----------------------------------------
// reward w/ plot item - currently gives to all players so all can advance plot on their own
void RewardPartyUniqueItem(object oPC, string sItemResRef)
{
	CreateItemOnFaction(oPC, sItemResRef);
}

// reward player w/ item - currently gives only one of the item - party must decide how to split it up.
void RewardPartyItem(object oPC, string sItemResRef)
{
	CreateItemOnObject(sItemResRef, oPC);
}

// reward player w/ Gold - currently everyone gets full amount
void RewardPartyGold(object oPC, int iGold)
{
	GiveGoldToAll(oPC, iGold);
	//GiveGoldToAllEqually(oPC, iGold);
}

// reward player w/ XP - currently everyone gets full amount
// this should be used only for non-quest related XP rewards
void RewardPartyXP(object oPC, int iXP)
{
	GiveXPToAll(oPC, iXP);
	//GiveXPToAllEqually(oPC, iXP);
}


// Give XP rewards for quest.  Amount given is tracked, but there is no cap.
// return amount awarded
int RewardPartyQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100)
{
    // Give the party XP
	int iQuestXPReward =  (GetJournalQuestExperience(sQuestTag) * iQuestXPPercent)/100;
    GiveXPToAll(oPC, iQuestXPReward);

	// track amount given
    string sXPQuestPercentRewarded = sQuestTag + QPR_SUFFIX;
	ModifyLocalIntOnFaction(oPC, sXPQuestPercentRewarded, iQuestXPPercent);

	return (iQuestXPReward);
}

// reward xp amount to party, subject to cap
void RewardPartyCappedQuestXP(object oPC, string sQuestTag, int iQuestXPPercent = 100, int iQuestXPPercentCap = 100)
{
    object oPartyMem = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oPartyMem)) 
	{
		RewardCappedQuestXP(oPartyMem, sQuestTag, iQuestXPPercent, iQuestXPPercentCap);
        oPartyMem = GetNextFactionMember(oPC, TRUE);
    }
}	


void SendMessageToParty(object oPC, string sTlkText, int bNotice)
{
	object oPartyMember = GetFirstFactionMember(oPC, TRUE); // PC's only
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
	    SendMessageToPC(oPartyMember, sTlkText);
		if(bNotice)
		{
			SetNoticeText(oPartyMember,sTlkText);
		}
		// GiveXPToCreature(oPartyMember, iXP);
		oPartyMember = GetNextFactionMember(oPC, TRUE); // PC's only
	}		
}

void AwardXP(object oPC, int iXPAwardID, int bWholeParty=TRUE)
{
	string sWarnText;
	
    int iXP 		= StringToInt(Get2DAString(TABLE_XP_AWARD, COL_XP, iXPAwardID));
    int iStringRef 	= StringToInt(Get2DAString(TABLE_XP_AWARD, COL_STR_REF, iXPAwardID));
	string sTlkText = GetStringByStrRef(iStringRef);
    //string sText	= Get2DAString(TABLE_XP_AWARD, COL_TEXT, iXPAwardID);

	if (iStringRef == 0)
	{
		sWarnText = "DescStrRef not defined in k_xp_awards.2da for Row # " + IntToString(iXPAwardID);
		PrettyError(sWarnText);
	}
	else if (sTlkText == "")
	{
		sWarnText = "String # " + IntToString(iStringRef) + " is empty or not found in Tlk table as specified in k_xp_awards.2da for Row # " + IntToString(iXPAwardID);
		PrettyError(sWarnText);
	}
	
	if (bWholeParty)
	{
		SendMessageToParty(oPC, sTlkText, TRUE);
		
		RewardPartyXP(oPC, iXP);
	}
	else
	{				
    	SendMessageToPC(oPC, sTlkText);
		SetNoticeText(oPC,sTlkText);
    	GiveXPToCreature(oPC, iXP);
	}
}

// From: X0_I0_PARTYWIDE
/********* REWARD FUNCTIONS ******************/
/* 

// Given a gold amount, divides it equally among the party members
// of the given PC's party.
// None given to associates.
void GiveGoldToAllEqually(object oPC, int nGoldToDivide);

// Given a gold amount, gives that amount to all party members
// of the given PC's party.
// None given to associates.
void GiveGoldToAll(object oPC, int nGold);

// Given an XP amount, divides it equally among party members
// of the given PC's party.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>) to
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAllEqually(object oPC, int nXPToDivide);

// Given an XP amount, gives that amount to all party members
// of the given PC's party.
// None given to associates.
// Tip: use with GetJournalQuestExperience(<journal tag>)
//      get the amount of XP assigned to that quest in the
//      journal.
void GiveXPToAll(object oPC, int nXP);
*/
// ga_give_quest_xp
//
// Give everyone experience for completing a quest.  The experience goes to
// ALL PCs in the party.  
	
// EPF 3/15/06
	
#include "ginc_journal"
	
void main(string sQuestTag)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	RewardPartyQuestXP(oPC, sQuestTag);
}
// ga_give_partial_quest_xp
//
// Give everyone experience for completing a quest.  The experience goes to
// ALL PCs in the party.  Distinguished from ga_give_quest_xp in that you can specify the percentage
// of the quest experience you want to give out, so, say if you have a 4-part quest, you could
// award 25% of the experience for completing each portion.  There is a cap in place so you can't
// accidentally award more than 100% overall.
	
// EPF 3/15/06
	
#include "ginc_journal"
	
void main(string sQuestTag, int nPercentXP)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	RewardPartyCappedQuestXP(oPC, sQuestTag, nPercentXP);
}
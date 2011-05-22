// gdm_journal
/*
    update journal.  overrides normal restriciton preventing lower entry ids than current to be set.

    This script for use in normal conversation
*/
// ChazM 3/24/06

#include "gdm_inc"
#include "X0_I0_STRINGLIB"
#include "ginc_debug"
	
void main()
{
    string sInput = GetStringParam();
	string sCategoryTag = GetTokenByPosition(sInput, ",", 0);
	int nEntryID = StringToInt(GetTokenByPosition(sInput, ",", 1));
	PrettyDebug("sCategoryTag = " + sCategoryTag);
	PrettyDebug("nEntryID = " + IntToString(nEntryID));
    object oPC = GetPCSpeaker();
	AddJournalQuestEntry(sCategoryTag, nEntryID, oPC, TRUE, FALSE, TRUE);


}
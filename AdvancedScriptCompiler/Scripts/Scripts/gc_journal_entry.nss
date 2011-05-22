// gc_journal_entry
/*
    This script compares the state of specified journal quest to a check value.
		sQuestTag - tag of the quest to examine on the PC
		sCheck	- conditional to check against.  This param works the same as it does in gc_local_int.
*/
// ChazM 4/12/05


#include "ginc_var_ops"

// Will return 0 if no quest.
int StartingConditional(string sQuestTag, string sCheck)
{
	object oPC = GetPCSpeaker();
    int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
 	return (CompareInts(iQuestEntry, sCheck));
}
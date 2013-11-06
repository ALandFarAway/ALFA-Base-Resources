#include "ginc_journal"

void main() {
	object oPC = GetLastUnlocked();
	string sError = "ERROR: Improperly configured quest reward. Report this to a builder.";
	SendMessageToPC( oPC, "<C=red>" + sError + "</C>" );
	WriteTimestampedLogEntry( sError );
}
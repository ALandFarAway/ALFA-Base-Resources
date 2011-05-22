//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_blockedcount_b
//::
//::	Tallies how many times we've been blocked.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 2/1/06

#include "ginc_ai"
//#include "ginc_debug"	


void main()
{
	int nBlockCount=GetLocalInt(OBJECT_SELF, VAR_AP_BLOCKCOUNT);
	if (nBlockCount>=0)
		SetLocalInt(OBJECT_SELF, VAR_AP_BLOCKCOUNT,  nBlockCount + 1 );

	AIContinueInterruptedScript(CREATURE_SCRIPT_ON_BLOCKED_BY_DOOR); //this script is an interrupt script, so this must be called
																//when you want the original to play
}

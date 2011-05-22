//	ka_olmap_visit  
/*	Jumps the party to the waypoint whose tag is the same as the
	placeable's sTravelDest variable.
*/
//	Nchap
//	JSH-OEI 5/29/08 - Added autosave.

#include "ginc_debug"
#include "ginc_overland"
#include "ginc_companion"
void main()
{
	string sDestWP = GetDestWPTag();
	string sDestModule = GetLocalString(OBJECT_SELF, "sDestModule");
	
	object oPC = GetLastUsedBy();
	object oWP = GetWaypointByTag(sDestWP);
	
	if( GetModuleName() == sDestModule || sDestModule == "")
	{
		PrettyDebug("Jumping " + GetName(oPC) + " to " + GetTag(oWP));
		ExitOverlandMap(oPC);		//This is a sanity check to verify that we don't hit any bugs dealing with saving.
		DoSinglePlayerAutoSave(); // Autosave
		JumpPartyToArea( oPC, oWP );
	}
	
	else
	{
		ExitOverlandMap(oPC);
		SaveRosterLoadModule(sDestModule, sDestWP);
	}
}
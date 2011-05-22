// ga_xp_trap
/*
   Give player XP for disarming or recovering a trap.
*/
// KDS 05/21/07
#include "ginc_journal"

void main()
{
	object oTrap = OBJECT_SELF;
	object oPC = GetFirstPC();
	object oDisarmer = GetLastDisarmed();
		
	int iTrapXP = 5 * GetTrapDisarmDC (oTrap);
	
	string sMessage = GetStringByStrRef (8263) + IntToString (iTrapXP);
	
	RewardPartyXP(oPC, iTrapXP);
	if (GetIsPossessedFamiliar (oDisarmer))
	{
	SendMessageToPC(oDisarmer, sMessage);
	}

}
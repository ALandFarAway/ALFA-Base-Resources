// ga_xp_lock
/*
   Give player XP for unlocking a door.
*/
// KDS 05/21/07
#include "ginc_journal"

void main()
{
	object oLock = OBJECT_SELF;
	object oPC = GetFirstPC();
	object oUnlocker = GetLastUnlocked();
		
	int iLockXP = 3 * GetLockUnlockDC (oLock);
	
	
	string sVariable = "GotLockXP";
	string sMessage = GetStringByStrRef (8263) + IntToString (iLockXP);
	
	if (GetLocalInt(oLock, sVariable) != 1)
	{
		SetLocalInt(oLock, sVariable, 1);
		RewardPartyXP(oPC, iLockXP);
		if (GetIsPossessedFamiliar (oUnlocker))
		{
			SendMessageToPC(oUnlocker, sMessage);
		}
	}
}
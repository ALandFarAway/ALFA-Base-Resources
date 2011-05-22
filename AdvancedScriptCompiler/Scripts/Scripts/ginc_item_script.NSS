// ginc_item_script
/*
   include for item scripts
*/
// ChazM 9/8/06
// ChazM 9/12/06 added IsItemAcquiredByPartyMember()
// ChazM 3/30/07 - fixed IsItemAcquiredByPartyMember() prototype thanks to Sir Elric!

//#include "x2_inc_itemprop"
#include "ginc_param_const"
#include "ginc_vars"
#include "ginc_debug"

/*
int SCRIPT_MODULE_ON_ACTIVATE_ITEM          = 6;
int SCRIPT_MODULE_ON_ACQUIRE_ITEM           = 7;
int SCRIPT_MODULE_ON_LOSE_ITEM              = 8;

int SCRIPT_MODULE_ON_EQUIP_ITEM             = 15;
int SCRIPT_MODULE_ON_UNEQUIP_ITEM           = 16;
*/

//----------------------------------------------
// Prototypes
//----------------------------------------------

int IsItemAcquiredByPartyMember();
int IsItemMarkedAsDone(object oItem, int iFlag=0);
void MarkItemAsDone(object oItem, int iFlag=0);


//----------------------------------------------
// Functions
//----------------------------------------------

// Can only be run use in an onAquire script.
// Checks if the item was aquired by a member of a 
int IsItemAcquiredByPartyMember()
{
	// Because a player can drag an item from a placeable’s inventory directly onto a companion’s portrait, 
	// bypassing his own inventory. This means the onAquire event fires on an unpossessed companion, 
	// who returns FALSE on the GetIsPC().
	int iRet = FALSE;
	object oPC = GetModuleItemAcquiredBy();
	
 	//if (GetFactionEqual(GetFirstPC(), oPC)) // won't work in multi-party
	object oLeader = GetFactionLeader(oPC);
	// only PC parties have faction leaders.
	if (GetIsObjectValid(oLeader))
		iRet = TRUE;
		
	return (iRet);		
}



// Check if marked as done.  
// Optionally check if done for a specific flag
// recommened Usage: IsItemMarkedAsDone(oItem, SCRIPT_MODULE_ON_ACQUIRE_ITEM)
int IsItemMarkedAsDone(object oItem, int iFlag=0)
{
	string sNVPName = GetDoneFlag(iFlag);
	string sNVPList = GetLastName(oItem);
	int iDoneOnce = StringToInt(GetNVPValue(sNVPList, sNVPName));
	return (iDoneOnce);
}

// Set marked as done.  
// Optionally set as done for a specific flag
// recommened Usage: MarkItemAsDone(oItem, SCRIPT_MODULE_ON_ACQUIRE_ITEM)
void MarkItemAsDone(object oItem, int iFlag=0)
{
	string sNVPName = GetDoneFlag(iFlag);
	string sNVPList = GetLastName(oItem);
	sNVPList = AppendUniqueToNVP(sNVPList, sNVPName, IntToString(TRUE));
	SetLastName(oItem, sNVPList);
}

// to be removed
/*
int ItemScriptAcquireRunBefore(object oItem)
{
	return (FALSE);
}
*/

//void main(){}
/////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ABR Store OnOpen Script
//     Filename : abr_storeopen.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2009-03-08#$ date the file was created or modified
//       Author : AcadiusLost
//
//  Local Variable Prefix =
//
//  Dependencies external of nwscript:
//
//  Description
//  This script sets up pointers for logging and merchant returns.
//
//  Revision History
//    2009-02-01  AcadiusLost: Inception
//    2009-02-21  AcadiusLost: Fix for non-returns stores.
//    2009-03-09  AcadiusLost: Moved ACR_STORE setting outside returns conditional
//    2009-12-28  Wynna: Added Random Loot Generation Functions based on System_Crush 23-7-07
// 
////////////////////////////////////////////////////////////////////////////////

// 1sc_search_chest_Unique
/*
	Description:
	Goes on open of a container and fills it with random loot the first 
	time it is opened, the quality of the loot id defined by the values
	put into FillContainer() and scaled towards the first opener to
	determine in what level area the chest is placed in.
	
	If there is a container with the tag '1sc_unfound_loot' in the module
	then the loot will be hidden in that object;
	If so each opener must make a search check against the DC of each item
	hidden in the chest, in oder to reveal that item.
	Otherwise all generated loot will be available instantly, and the
	opening object will be inform that the script failed to hide the items.
*/

#include "1sc_searchable"
#include "1sc_searchable_treasure"

const string _ACR_RTN_POINTER = "ACR_RETURNS_POINTER";

void main() {


object oPC = GetLastOpenedBy();
object oReturnsTrigger = GetLocalObject(oPC, _ACR_RTN_POINTER);
SetLocalInt(oPC, "ACR_GOLD", GetGold(oPC));
SetLocalObject(oPC, "ACR_STORE", OBJECT_SELF);

if (oReturnsTrigger != OBJECT_INVALID) 
	{
	// PC is inside a Returns trigger, should be good to go
	// SendMessageToPC(oPC, "Gold stored: "+IntToString(GetGold(oPC)));
	SetLocalObject(oReturnsTrigger, _ACR_RTN_POINTER, OBJECT_SELF);
	
	}

	
	// This is the Unique version of the loot script 
	FillContainer(TREASURE_TYPE_UNIQUE,TREASURE_TYPE_UNIQUE,TREASURE_TYPE_UNIQUE,TREASURE_TYPE_UNIQUE);
	// Do a search check 
	int iCheck = d20(1);
	int iSkill = GetSkillRank(SKILL_SEARCH, GetLastOpenedBy(), FALSE);
	int iTotalDC = iCheck + iSkill;
	//SendMessageToPC(GetLastOpenedBy(), ("Searching container " + IntToString(iCheck) + 
	//									" + " + IntToString(iSkill) + 
	//									" = " +  IntToString(iTotalDC)));
	// Fill the chest with items that can be found with the 
	// DC that has been rolled							
	SearchChest(iTotalDC);
	}
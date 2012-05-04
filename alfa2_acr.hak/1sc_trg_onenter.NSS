////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : acf_trg_onenter.nss
//    $Revision:: 236        $ current version of the file
//        $Date:: 2007-01-21#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script calls the ACR's OnEnter code for triggers, and any
//  custom code a server may need. It is not updated in ACR updates.
//
//  Revision History
//  2007/01/20  Cipher  Inception
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_trigger_i"
#include "acr_quest_i"



////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{
	int iPower = Random(5);
	int nTrap_Power;
	object oTrap;
	object o = OBJECT_SELF;
	object oChest = GetLocalObject(o, "oChest");
	object oEntering = GetEnteringObject();
	object oArea = GetArea(o);
	int iUseableDC = 15 + Random(11) - Random(11);
	int iUnlockDC;
	int iDetectDC;
	int iDisableDC;
	int tmp;
	location loc = GetLocation(oEntering);
	
	
	ACR_TriggerOnEnter();
			
	// already spawned
	if (GetIsObjectValid(oChest))
		return;
			
	// this isn't supposed to spawn, leave
	if (GetLocalInt(o, "spawn_chest") == 0)
		return;
	
	// skip non pcs
	if (!GetIsPC(oEntering))
		return;

	WriteTimestampedLogEntry("phat_lewt: checking for "+GetName(oEntering)+" in "+GetName(oArea) + " (" + GetTag(o) + ")");

	// check was already done for player
	if (GetLocalString(o, GetName(oEntering)) == GetName(oEntering))
		return;
	
	SetLocalString(o, GetName(oEntering), GetName(oEntering));
	
	tmp = GetLocalInt(o, "iUsableDC");
	
	if (tmp > 0)
		iUseableDC = tmp;
	else
		SetLocalInt(o, "iUsableDC", iUseableDC);
			
	WriteTimestampedLogEntry("phat_lewt: search check, DC "+IntToString(iUseableDC));
	
	// search check
	if (GetIsSkillSuccessful(oEntering, SKILL_SEARCH, iUseableDC, FALSE) != TRUE)
		return;
					
	// finally, spawn chest
	switch (Random(3)) {
		case 0:
			oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "phat_lewt_chest_small", loc);
			break;
		case 1:
			oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "phat_lewt_chest_large", loc);
			break;
		default:
			oChest = CreateObject(OBJECT_TYPE_PLACEABLE, "phat_lewt_crate", loc);
	}
		
	WriteTimestampedLogEntry("phat_lewt: search check passed, creating");
	
	SendMessageToPC(oEntering, "You discover something!");
	
	SetLocalInt(o, "spawn_chest", 0);		
	SetLocalObject(OBJECT_SELF, "oChest", oChest);
		
	iUnlockDC = GetLocalInt(oChest, "iUnlockDC");
	
	if (iPower == 4)
		nTrap_Power = 1;

	if (iUnlockDC == 0) {
		iUnlockDC = 15 + Random(11) - Random(11) + (5 * nTrap_Power);
		SetLocalInt(oChest, "iUnlockDC", iUnlockDC);
	}
				
	if (GetLockLockable(oChest) == TRUE)
		SetLocked(oChest, TRUE);
						
	SetLockUnlockDC(oChest, iUnlockDC);
	
	WriteTimestampedLogEntry("phat_lewt: handle trapping");
				
	if (Random(2) == 1)
		return;
					
	iDetectDC = GetLocalInt(oChest, "iDetectDC");
	iDisableDC = GetLocalInt(oChest, "iDisableDC");
						
	if (iDetectDC == 0) {
		iDetectDC = 10 + Random(11) - Random(11) + (5 * nTrap_Power);
		SetLocalInt(oChest, "iDetectDC", iDetectDC);
	}
						 
	if (iDisableDC == 0) {
		iDisableDC = 15 + Random(11) - Random(11) + (5 * nTrap_Power);
		SetLocalInt(oChest, "iDisableDC", iDisableDC);
	}
						
	if (iPower == 4) {
		CreateTrapOnObject(4 * Random(11) + 1, oChest, STANDARD_FACTION_HOSTILE, "1sc_plc_ontrapdisarm");
	 	SetLocalInt(oChest, "Average_Trap", 1);
	}
	else
		CreateTrapOnObject(4 * Random(11), oChest, STANDARD_FACTION_HOSTILE, "1sc_plc_ontrapdisarm");
					
	oTrap = GetNearestTrapToObject(o, FALSE);
	SetTrapDisarmable(oTrap, TRUE);
	SetTrapDetectDC(oTrap, iDetectDC);
	SetTrapDisarmDC(oTrap, iDisableDC);
	SetTrapDisarmable(oChest, TRUE);
	SetTrapDetectDC(oChest, iDetectDC);
	SetTrapDisarmDC(oChest, iDisableDC);
	SetLocalInt(oChest, "DM_Trapped", 1);
	
	// Custom code goes here.
}

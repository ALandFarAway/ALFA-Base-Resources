////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ACR Configuration File
//     Filename : 1sc_trg_onenter.nss
//       Author : Cipher
//
//    Var Prefix:
//  Dependencies:
//
//  Description
//  This script is executed upon entering the AoE sphere of a loot drop.
//  It then may spawn a loot placeable within.
//
//  Revision History
//  2007/01/20  Cipher  Inception
//  2012/05/31  Paazin  Rewrote to not use triggers
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
	object oChest;
	object oEntering = GetEnteringObject();
	object oWP = GetLocalObject(o, "PL_WP");
	object oArea = GetArea(oWP);
	int iUnlockDC;
	int iDetectDC;
	int iDisableDC;
	int iSearchDC;
	location loc = GetLocation(oEntering);
	string sTag;
	string sResref;

	// Hack to prevent old trigger-style from executing
	if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER)
		return;
	
	// skip non pcs
	if (!GetIsPC(oEntering))
		return;

	WriteTimestampedLogEntry("phat_lewt: checking for "+GetName(oEntering)+" in "+ACR_SpawnPointToString(oWP));

	sTag = "PL_CHECK_" + ObjectToString(oEntering);

	// check was already done for player
	if (GetLocalInt(o, sTag))
		return;
	
	iSearchDC = GetLocalInt(o, "PL_SEARCH_DC");
	
	WriteTimestampedLogEntry("phat_lewt: search check, DC "+IntToString(iSearchDC));
	
	// search check, quit if fail
	if (GetIsSkillSuccessful(oEntering, SKILL_SEARCH, iSearchDC, FALSE) != TRUE) {
		SetLocalInt(o, sTag, 1);
		return;
	}

	// finally, spawn chest
	sResref = GetLocalString(o, "PL_RESREF");
					
	// Hook into spawn system
	oChest = ACR_SpawnObjectAtLocation(sResref, OBJECT_TYPE_PLACEABLE, loc, oWP);

	WriteTimestampedLogEntry("phat_lewt: search check passed, creating "+sResref);
	
	SendMessageToPC(oEntering, "You discover something!");
	
	// if no trap, ignore locking as well
	if (!GetLocalInt(o, "PL_NO_TRAP")) {

		iUnlockDC = GetLocalInt(oChest, "iUnlockDC");
	
		if (iPower == 4)
			nTrap_Power = 1;

		if (iUnlockDC == 0) {
			iUnlockDC = 15 + Random(11) - Random(11) + (5 * nTrap_Power);
			SetLocalInt(oChest, "iUnlockDC", iUnlockDC);
		}

				
		if (GetLockLockable(oChest) == TRUE) {
			SetLocked(oChest, TRUE);
			WriteTimestampedLogEntry("phat_lewt: unlock DC " + IntToString(iUnlockDC));
		}
						
		SetLockUnlockDC(oChest, iUnlockDC);
	
		// only half of trappable objects are actually trapped
		if (Random(2) == 1) {
					
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
					
			WriteTimestampedLogEntry("phat_lewt: disable DC " + IntToString(iDisableDC));
				
			oTrap = GetNearestTrapToObject(o, FALSE);
			SetTrapDisarmable(oTrap, TRUE);
			SetTrapDetectDC(oTrap, iDetectDC);
			SetTrapDisarmDC(oTrap, iDisableDC);
			SetTrapDisarmable(oChest, TRUE);
			SetTrapDetectDC(oChest, iDetectDC);
			SetTrapDisarmDC(oChest, iDisableDC);
			SetLocalInt(oChest, "DM_Trapped", 1);
		}
	}
	
	DestroyObject(OBJECT_SELF);
}

////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_traps_i    
//    $Revision:: 1          $ current version of the file
//        $Date:: 2013-04-30#$ date the file was created or modified
//       Author : Zelknolf
//
//    Var Prefix: ACR_TRAP
//  Dependencies: None
//
//  Description
//    This library includes functions for handling travel, both magical and
//    mundane.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_TRAPS_I
#define ACR_TRAPS_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int TRIGGER_SIZE_SMALL = 1;       // 5  feet
const int TRIGGER_SIZE_MEDIUM = 2;      // 10 feet
const int TRIGGER_SIZE_LARGE = 3;       // 15 feet aka one tile
const int TRIGGER_SIZE_HUGE = 4;        // 20 feet
const int TRIGGER_SIZE_GARGANTUAN = 5;  // 25 feet
const int TRIGGER_SIZE_COLOSSAL = 6;    // 30 feet aka four tiles

const int TRAP_EVENT_CREATE_GENERIC = 1;
const int TRAP_EVENT_CREATE_SPELL = 2;
const int TRAP_EVENT_DETECT_ENTER = 3;
const int TRAP_EVENT_DETECT_EXIT = 4;
const int TRAP_EVENT_TRIGGER_ENTER = 5;
const int TRAP_EVENT_TRIGGER_EXIT = 6;
const int TRAP_EVENT_DISARM_TRAP = 7;
const int TRAP_EVENT_DESPAWN_TRAP = 8;

const int SPECIAL_OBJECT_TYPE_TRAP = 99;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This creates a trap, assuming the trap to currently be hidden.
// lTarget - the center location and facing (if applicable) of the trap.
// nTriggerArea - the size of the trigger area of the trap, using TRIGGER_SIZE
//   constants
// nEffectShape - the shape of the effect from the trap.
// fEffectSize - the size of the trap's effect.
// nDamageType - a bitfield representing the types of damage (evenly-distributed) 
//   that the trap will do, using the DAMAGE_TYPE_* constants
// nDamageQuantity - the number of dice to roll when determining damage
// nDamageDiceType - the kind of dice rolled when determining damage
// nSaveDC - the reflex save DC of the trap. Overrides attack bonus.
// nAttackBonus - the attack bonus of the trap.
// nNumberOfShots - the number of times the trap will trigger before being 
//   considered exhausted
// oTrapOrigin - the object from which the hazard generated will appear. If it is
//   OBJECT_INVALID, then the trap will be used as the origin.
// nTargetAlignment - the alignment which will be targeted by the trap. While
//   creatures of other alignments may be struck as collateral, only creatures of
//   the targeted alignment will be targeted. Uses ALIGNMENT_* constants
// nTargetRace - the race which will be targeted by the trap. While creatures of
//   other races might be struck as collateral, only creatures of this race will
//   be targeted. Uses RACIAL_TYPE_* constants.
// nMinimumToTarget - the minimum number of qualifying creatures which must be in
//   the trap area before the trap is triggered. If set to 0 and oTrapOrigin is
//   defined, then the trap will fire every round from the origin to the trap
//   center.
// nDetectDC - the DC required to find this trap with a search check. If left as
//   -1, then the trap's detect DC will be calculated to match the CR established
//   by the trap's other features.
// nDisarmDC - the DC required to disarm this trap with a disable device check. If
//   left as -1, then the trap's disarm DC Will be calculated to match the CR
//   established by the trap's other features.
void SpawnGenericTrap( location lTarget, int nTriggerArea, int nEffectArea, float fEffectSize, int nDamageType, int nDamageDiceNumber, int nDamageDiceType, int nSaveDC=-1, int nAttackBonus=-1, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1);

// This creates a trap, assuming the trap to currently be hidden.
// lTarget - the center location and facing (if applicable) of the trap.
// nTriggerArea - the size of the trigger area of the trap, using TRIGGER_SIZE
//   constants
// nSpellId - the spell that the trap is to cast when triggered.
// nNumberOfShots - the number of times the trap will trigger before being 
//   considered exhausted
// oTrapOrigin - the object from which the hazard generated will appear. If it is
//   OBJECT_INVALID, then the trap will be used as the origin.
// nTargetAlignment - the alignment which will be targeted by the trap. While
//   creatures of other alignments may be struck as collateral, only creatures of
//   the targeted alignment will be targeted. Uses ALIGNMENT_* constants
// nTargetRace - the race which will be targeted by the trap. While creatures of
//   other races might be struck as collateral, only creatures of this race will
//   be targeted. Uses RACIAL_TYPE_* constants.
// nMinimumToTarget - the minimum number of qualifying creatures which must be in
//   the trap area before the trap is triggered. If set to 0 and oTrapOrigin is
//   defined, then the trap will fire every round from the origin to the trap
//   center
// nDetectDC - the DC required to find this trap with a search check. If left as
//   -1, then the trap's Detect DC will be 25 + the spell's level.
// nDisarmDC - the DC required to disarm this trap with a disable device check. If
//   left as -1, then the trap's Disable DC will be 25 + the spell's level.
void SpawnSpellTrap( location lTarget, int nTriggerArea, int nSpellId, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1);

// This calls into ACR_Traps to have OBJECT_SELF be treated as a detection
// trigger attempting to detect its associated trap.
void TrapDetectEnter();

// This calls into ACR_Traps to have OBJECT_SELF be treated as a detection
// trigger when a player has left the detection area.
void TrapDetectExit();

// This calls into ACR_Traps to have OBJECT_SELF be treated as the dangerous
// region of a trap being entered.
void TrapTriggerEnter();


// This calls into ACR_Traps to have OBJECT_SELF be treated as the dangerous
// region of a trap being exited.
void TrapTriggerExit();

// This calls into ACR_Traps to have OBJECT_SELF be treated as attempting to
// disarm a trap.
void TrapDisarmAttempt();

// Private-- this provides the passed params to C# and calls ACR_Traps
void _PassToCSharp( int nEvent, float fPosX=0.0f, float fPosY=0.0f, float fPosZ=0.0f, object oArea=OBJECT_INVALID, int nTriggerArea=-1, int nEffectArea=-1, float fEffectSize=-1.0f, int nDamageOrSpellType=-1, int nDamaceDiceNumber=-1, int nDamageDiceType=-1, int nSaveDC=-1, int nAttackBonus=-1, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1, string sResRef="");

// Private-- this performs cheap checks to see if we need to use anything in
// C# before calling into the project
int _IsTrapEventNeeded();

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PUBLIC ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void SpawnGenericTrap( location lTarget, int nTriggerArea, int nEffectArea, float fEffectSize, int nDamageType, int nDamageDiceNumber, int nDamageDiceType, int nSaveDC=-1, int nAttackBonus=-1, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1)
{
    vector vTarget = GetPositionFromLocation(lTarget);
    _PassToCSharp(TRAP_EVENT_CREATE_GENERIC, vTarget.x, vTarget.y, vTarget.z, GetAreaFromLocation(lTarget), nTriggerArea, nEffectArea, fEffectSize, nDamageType, nDamageDiceNumber, nDamageDiceType, nSaveDC, nAttackBonus, nNumberOfShots, oTrapOrigin, nTargetAlignment, nTargetRace, nMinimumToTrigger, nDetectDC, nDisarmDC);
    return;
}

void SpawnSpellTrap( location lTarget, int nTriggerArea, int nSpellId, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1)
{
    vector vTarget = GetPositionFromLocation(lTarget);
    _PassToCSharp(TRAP_EVENT_CREATE_SPELL, vTarget.x, vTarget.y, vTarget.z, GetAreaFromLocation(lTarget), nTriggerArea, -1, -1.0f, nSpellId, -1, -1, -1, -1, 1, oTrapOrigin, nTargetAlignment, nTargetRace, nMinimumToTrigger, nDetectDC, nDisarmDC);
    return;
}

void TrapDetectEnter()
{
    if(_IsTrapEventNeeded())
    {
        _PassToCSharp(TRAP_EVENT_DETECT_ENTER);
    }
}

void TrapDetectExit()
{
    if(_IsTrapEventNeeded())
    {
        _PassToCSharp(TRAP_EVENT_DETECT_EXIT);
    }
}

void TrapTriggerEnter()
{
    if(_IsTrapEventNeeded())
    {
        _PassToCSharp(TRAP_EVENT_TRIGGER_ENTER);
    }
}

void TrapTriggerExit()
{
    if(_IsTrapEventNeeded())
    {
        _PassToCSharp(TRAP_EVENT_TRIGGER_EXIT);
    }
}

void TrapDisarmAttempt()
{
    _PassToCSharp(TRAP_EVENT_DISARM_TRAP);
}

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PRIVATE //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int _IsTrapEventNeeded()
{
    object oEnter = GetEnteringObject();
    if(GetObjectType(oEnter) != OBJECT_TYPE_CREATURE) return FALSE;
    if(GetIsDM(oEnter) && !GetIsDMPossessed(oEnter)) return FALSE;
    return TRUE;
}

void _PassToCSharp( int nEvent, float fPosX=0.0f, float fPosY=0.0f, float fPosZ=0.0f, object oArea=OBJECT_INVALID, int nTriggerArea=-1, int nEffectArea=-1, float fEffectSize=-1.0f, int nDamageOrSpellType=-1, int nDamageDiceNumber=-1, int nDamageDiceType=-1, int nSaveDC=-1, int nAttackBonus=-1, int nNumberOfShots=1, object oTrapOrigin=OBJECT_INVALID, int nTargetAlignment=ALIGNMENT_ALL, int nTargetRace=RACIAL_TYPE_ALL, int nMinimumToTrigger=1, int nDetectDC=-1, int nDisarmDC=-1, string sResRef="")
{
    ClearScriptParams();
    AddScriptParameterInt(nEvent);
    AddScriptParameterFloat(fPosX);
    AddScriptParameterFloat(fPosY);
    AddScriptParameterFloat(fPosZ);
    AddScriptParameterObject(oArea);
    AddScriptParameterInt(nTriggerArea);
    AddScriptParameterInt(nEffectArea);
    AddScriptParameterFloat(fEffectSize);
    AddScriptParameterInt(nDamageOrSpellType);
    AddScriptParameterInt(nDamageDiceNumber);
    AddScriptParameterInt(nDamageDiceType);
    AddScriptParameterInt(nSaveDC);
    AddScriptParameterInt(nAttackBonus);
    AddScriptParameterInt(nNumberOfShots);
    AddScriptParameterObject(oTrapOrigin);
    AddScriptParameterInt(nTargetAlignment);
    AddScriptParameterInt(nTargetRace);
    AddScriptParameterInt(nMinimumToTrigger);
    AddScriptParameterInt(nDetectDC);
    AddScriptParameterInt(nDisarmDC);
	AddScriptParameterString(sResRef);
	if(nEvent > 2)
	{
		ExecuteScriptEnhanced("acr_traps", OBJECT_SELF, TRUE);
	}
	else
	{
		ExecuteScriptEnhanced("acr_traps", GetModule(), TRUE);
	}
}

#endif

////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_xp_i.nss
//    $Revision:: 654        $ current version of the file
//        $Date:: 2009-05-30#$ date the file was created or modified
//       Author : Ronan & AcadiusLost
//
//   Var Prefix : ACR_XPZ
//  Dependencies:
//
//  Description
//  This script represents ALFA's XP standards. It and it alone gives XP to PCs,
//  and it does so in accordance with ALFA's rules on XP gain. Any other method
//  to give XP to a PC will fail.
//
//  Revision History
//  2006/05/13  Ronan  Prototype Inception.
//  2007/07/04  AcadiusLost  Numerous changes with validation checks, StopLevelUp,
//              GetIsValidationNeededForLevel restructured.
//  2007/07/08  AcadiusLost  Changed _VALIDATIONS_START_AT_LEVEL to 21, removing 
//              validation requirements. Also retrofitted for NWNx4, except for 
//              level validation arrays.
//  2007/07/14  AcadiusLost  Added _ACR_XP_COMBAT_RANGE and handling, fixed party 
//              XP division, changes to ACR_AwardCombatXP().  Also added multiplier
//              for _ACR_XP_COMBAT_ANCHOR to _GetBaseCombatXP().
//  2007/08/11  Cipher  Used ECL in place of HD in all XP calcs to account for LA races.
//  2007/09/02  AcadiusLost:  included 1984 for logging, added combat XP logging, 
//               dropped combat anchor from 30 to 20.
//  2007/12/02  AcadiusLost: RP XP banking system added.
//  2007/12/11  AcadiusLost: XP_OnClientLoaded() event added to skip banking for dying/dead PCs
//               also commented out warnings to players when "non-ACR" xp is detected.
//  2007/12/17  AcadiusLost: added lifetime RPXP tracking, abstracted gain rate to a constant.
//  2008/03/01  AcadiusLost: Added handling for RPXP residual loop overlap. 
//  2008/04/15  Cipher  Removed level validation code, cleaned up reward XP functions
//  2008/04/18  Cipher  Fixed file header formatting
//  2008/05/13  AcadiusLost: Fixed RPXP backups not to blank total cache.
//  2008/09/27  AcadiusLost: Combat range for XP to 30.0 (from 100.0), altered combat logging
//  2008/11/15  AcadiusLost: Lowered Over-CR ceiling to 2.5 (x3.5), added overCR logging, added RPXP % logging
//  2009/01/16  AcadiusLost: XP penalty fix for solo PCs
//  2009/01/17  AcadiusLost: Combat radius expanded to account for far-range kills. (30 -> 45)
//  2009/02/01  AcadiusLost: Added exceptions for Quarantine
//  2009/05/14  AcadiusLost: RPXP heartbeat to 2/hour for the 14-minute hour test.
//  2009/05/15  AcadiusLost: Migrated RPXP checks per hour into a constant.
//  2009/05/30  AcadiusLost: RPXP checks to 1/hour (for 7 min-hour)
//  2011/06/04  Basilica   : Moved RPXP DelayCommand continuations to the PC
//                           object instead of the module object.  This fixes
//                           the duplicate RPXP cycle problem once and for all.
//  2012/01/14  Basilica   : Added ACR_RPXPMarkActive to encapsulate the
//                           necessary operations to record RP XP activity for
//                           a player.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_XP_I
#define ACR_XP_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// The local variable which stores the amount of experience this PC has which
// has been given by these scripts.
const string _STORED_XP = "ACR_XPZ_XP";

// Scripted RP XP system constants.
const float _RPXP_SCRIPT_ANCHOR = 15.0;    //  Base reward per RL hour for RP
const string _BANKED_RPXP_INCREMENTS = "ACR_XP_BANKED_RPHOURS";
const string _LIFETIME_RPXP = "ACR_XP_TOTAL_LIFETIME_RPXP";
const string _RPXP_ACTIVITY = "ACR_XP_RPXP_ACTIVE";
const string _RPINCREMENTS_PLAYERCACHE = "ACR_XP_RPCACHE";
const string _RPXP_LOCATION = "ACR_XP_RPLOCATION";
const string _RPXP_HB = "ACR_XP_RPXP_HB";
const string _RPXP_PERCENT = "ACR_RPXP_PERCENT";
// int to define how many RPXP checks per game-hour
//  more will be more stringent on enforcement, but higher performance cost.
const int _RPXP_CHECKS_PER_HOUR = 2;

// The fraction of XP gained from nonlethal challenges.
const float _ACR_XP_NONLETHAL_RATIO = 0.1;

// The base XP gained for combat kills.
// The DMG base would be 300.
const float _ACR_XP_COMBAT_ANCHOR = 20.0;

// The base XP gained for quests.
const float _ACR_XP_QUEST_ANCHOR = 80.0;

// The maximum amount of XP a PC can get for an hour's worth of roleplaying.
const float _ACR_XP_MAX_RP_HOUR = 70.0;

// The maximum amount of XP a PC can get for an hour's worth of questing.
const float _ACR_XP_MAX_CHALLENGE_HOUR = 80.0;

// The maximum range at which a PC can be considered to be a participant in a combat kill.
const float _ACR_XP_COMBAT_RANGE = 45.0;

// The "Danger factor" that triggers special logging in the ACR for DM team examination,
//  ie: 3rd level PC kills a CR 5.5 boss, danger factor is 2.5  (5.5 - 3, maximum XP boost of x3.5)
//  initial default is +1.5, so special logging will occur with 2nd level PC killing a CR >= 3.5
const float _ACR_XP_OVERCR_LOGGING = 1.5;

// Constant that defines the percentage of extra XP added per participant in a party combat
//  initial attemt is 0.25 (25%)
const float _ACR_XP_PARTYSCALE = 0.25;

const string _ACR_PPS_QUARANTINED = "ACR_PPS_QUARANTINED";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Segregate XP logs as follows
// Quest | RP | Bonus | Scripted | Static | Combat 

//! *** PUBLIC FUNCTIONS ***

//! Award XP to oPC for completing a static quest of some sort.
void ACR_AwardStaticQuestXP(object oPC, string sPlotID, int nQuestXP, float fCR = 0.0f);

//! Award XP to oPC for completing a static quest of fCR and taking fHours of time to
//! complete.
void ACR_AwardStaticQuestXPFromCR(object oPC, string sPlotID, float fCR, float fHours);

//! Award XP to oPC for a DM session.
void ACR_AwardDMSessionXP(object oPC, object oDM, float fSessionLength, int nRPXP, int nQuestXP = 0, int nBonusXP = 0);

//! Awards XP to the party which oPCParty is a member of, for killing oKill.
void ACR_AwardCombatXP(object oPCParty, object oKill);

//! Awards XP to a PC for overcoming a specific challenge which could have
//! lethal consequences.
void ACR_AwardLethalChallengeXP(object oPC, float fCR);

//! Awards XP to a PC for overcoming a specific challenge.
void ACR_AwardNonlethalChallengeXP(object oPC, float fCR);

//! Gives nXpAmount to oCreature.
//! This function, and none other, must be used whenever XP is directly given to
//! a PC. Any other function may not work reliably, if at all.
//! NOTE: LOGGING WILL NEED TO BE HANDLED BY THE CALLING APPLICATION
void ACR_GiveXPToPC(object oPC, int nXpAmount);

//! Checks oPC's XP totals to be sure they were all given by the proper scripts.
//! If they were not, the XP totals are corrected.
void ACR_CorrectXPTotals(object oPC);

// ! Determines a PC's Effective Character Level (needed for level adjusted races)
int ACR_GetECL(object oTarget);

//! Process's oPC's level-up attempt.
//! Returns 1 if the level-up is successfull, and 0 if not.
//! If it is not, the PC is restored to his previous level, but keeps all of his
//! experience points.
int ACR_ProcessLevelUpAttempt(object oPC);

//! Handles award of banked RP XP
void ACR_XPOnClientLoaded(object oPC);

//! Handles calculation and storing for RP XP banking
void ACR_XPOnClientExit(object oPC);

//! Marks a PC as active for purposes of RP XP.
//!  - oPC: Supplies the PC to mark as active.
void ACR_RPXPMarkActive(object oPC);

//! *** PRIVATE FUNCTIONS ***

//! Sets oPC's experience points to nXpAmount.
//! This function, and none other, must be used whenever XP is directly set on a
//! PC. Any other function may not work reliably, if at all.
//! Not for external use.
void _SetALFAXp(object oPC, int nXpAmount);

//! Corrects oPC's XP totals, to the DB stored versions.
void _CorrectXPTotals(object oPC);

//! Returns the base combat XP for a creature of a given CR.
float _GetBaseCombatXP(float fCR);

//! Returns the XP for overcoming a challenge, where fChallengeDifference is the
//! CR minus the PC's level.
int _GetXPForChallenge(float fChallengeDifference);

//! Returns the XP modifier for overcoming a lethal challenge of nDangerFactor,
//! where it equals the creature's CR minus the PC's level.
float _GetXPForDangerFactor(float fDangerFactor);

//! Returns the XP awarded for a lethal challenge of nCR for a PC of level
//! nPCLevel.
float _GetXPForLethalChallenge(int nPCLevel, float fCR);

//! Gets fPercent of fValue, provided fPercent is between 0 and 100.
float _GetPositivePercentageOf(float fPercent, float fValue);

//! Handles checking for RPXP activity
void _RPXP_PHeartbeat(object oPlayer);

//! Handles sliding scale for party combat XP
float _AdjustXPForParty(float fBaseXP, int nSize);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_tools_i"
#include "acr_1984_i"
#include "acr_db_persist_i"
#include "acr_time_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_AwardStaticQuestXP(object oPC, string sPlotID, int nQuestXP, float fCR = 0.0f)
{
    if(fCR < 0.5) fCR = 0.5;
    float fDiff = ACR_GetECL(oPC) - fCR;
    if(fDiff < 0.0f) fDiff = 0.0f;
    float fQuestXP = IntToFloat(nQuestXP) * pow(0.9, fDiff);
	nQuestXP = FloatToInt(fQuestXP);
	fQuestXP -= IntToFloat(nQuestXP);
	if(fQuestXP >= 0.5f) nQuestXP++;
    ACR_GiveXPToPC(oPC, nQuestXP);
    ACR_LogEvent(oPC, ACR_LOG_STATICXP, "Awarded " + IntToString(nQuestXP) + " for completing quest + " + sPlotID);
}

void ACR_AwardStaticQuestXPFromCR(object oPC, string sPlotID, float fCR, float fHours)
{
    if(fCR < 0.5) fCR = 0.5;
    int nRewardXP = FloatToInt(_ACR_XP_QUEST_ANCHOR * pow(fCR, 0.6) * fHours);
    ACR_AwardStaticQuestXP(oPC, sPlotID, nRewardXP, fCR);
}

void ACR_AwardDMSessionXP(object oPC, object oDM, float fSessionLength, int nRPXP, int nQuestXP = 0, int nBonusXP = 0)
{
    int nXP = FloatToInt((nQuestXP + nRPXP) * fSessionLength) + nBonusXP;
    string sLogEvent;

    // grant the XP
    ACR_GiveXPToPC(oPC, nXP);

    // determine what kind of XP reward this is - quest, rp, or bonus
    if (nQuestXP > 0) { sLogEvent = ACR_LOG_QUESTXP; }
    else if (nRPXP > 0) { sLogEvent = ACR_LOG_DMRPXP; }
    else { sLogEvent = ACR_LOG_BONUSXP; }

    string sPlus = " ";

    // construct the log message
    string sLogMsg = "DM awarded";
    if (nBonusXP) { sLogMsg += sPlus + IntToString(nBonusXP) + " bonus xp"; sPlus = " + "; }
    if (fSessionLength > 0.0)
    {
        sLogMsg += sPlus + "(";
        if (nQuestXP) { sLogMsg += " " + IntToString(nQuestXP) + " quest xp +"; }
        sLogMsg += " " + IntToString(nRPXP) + " rp xp) x " + FloatToString(fSessionLength,2,1) + " hrs";
        sLogMsg += " for a total of " + IntToString(nXP) + " experience";
    }

    // log the XP change
    if (GetIsPC(oPC)) { ACR_LogEvent(oPC, sLogEvent, sLogMsg, oDM); ACR_IncrementStatistic("DM_XP_AWARDS"); }
}

void ACR_AwardCombatXP(object oPCParty, object oKill) 
{
    if(!GetIsPC(oPCParty) && !GetIsPC(GetMaster(oPCParty))) { return; }
    
    // added tracking for number of PCs for Over-CR combat kill logging
    int nLevelSum = 0, nHighestLevel = 0, nHD = 0, nNumPCs = 0;

    float fCR = GetChallengeRating(oKill);
    if(GetLocalFloat(oKill, "CR") > 0.0f)
        fCR = GetLocalFloat(oKill, "CR");

    object oPC = GetFirstFactionMember(oPCParty);
    object oArea = GetArea(oPCParty);
    SetLocalObject(OBJECT_SELF, "Killer", oPCParty);

    // determine the highest pc level in the party
    while (oPC != OBJECT_INVALID)
    {
        // check to make sure the PC is actually nearby, since areas are BIG in NWN2, only factor in close PCs
        if ((GetArea(oPC) == oArea) && (GetDistanceToObject(oPC) < _ACR_XP_COMBAT_RANGE))
        {
            if(GetIsPC(oPC)) nNumPCs = nNumPCs + 1;
            nHD = ACR_GetECL(oPC);
            if (nHD > nHighestLevel) 
            { 
                nHighestLevel = nHD; 
                SetLocalObject(OBJECT_SELF, "Highest", oPC);
            }
            nLevelSum += nHD;
        }
        oPC = GetNextFactionMember(oPCParty);
    }
    SetLocalInt(OBJECT_SELF, "PartySize", nNumPCs);
    
    // calculate XP based on highest pc level
    float fXP = _GetXPForLethalChallenge(nHighestLevel, fCR);

    // adjust XP by number of party members
    fXP = _AdjustXPForParty(fXP, nNumPCs);

    // award XP to all pcs in party
    oPC = GetFirstFactionMember(oPCParty);
    while (oPC != OBJECT_INVALID)
    {
        // check to make sure the PC is actually nearby, since areas are BIG in NWN2, only award ones in range
        if ((GetArea(oPC) == oArea) && (GetDistanceToObject(oPC) < _ACR_XP_COMBAT_RANGE))
        {
            if(ACR_GetECL(oPC) - FloatToInt(fCR) <= 8)
            {
                int nXP = FloatToInt(fXP);
                ACR_GiveXPToPC(oPC, nXP);
                ACR_LogEvent(oPC, ACR_LOG_COMBATXP, IntToString(nXP) + " XP for combat against " + GetName(oKill) + " (resref: " + GetResRef(oKill) + ")");
            }
        }
        oPC = GetNextFactionMember(oPCParty);
    }
}

void ACR_AwardLethalChallengeXP(object oPC, float fCR) {
    ACR_LogEvent(oPC, ACR_LOG_COMBATXP, IntToString(FloatToInt(_GetXPForLethalChallenge(ACR_GetECL(oPC), fCR)))+" XP for Lethal Challenge in area "+GetName(GetArea(oPC)));
    ACR_GiveXPToPC(oPC, FloatToInt(_GetXPForLethalChallenge(ACR_GetECL(oPC), fCR)));
}

void ACR_AwardNonlethalChallengeXP(object oPC, float fCR) {
    ACR_GiveXPToPC(oPC, FloatToInt(_GetXPForLethalChallenge(ACR_GetECL(oPC), fCR) * _ACR_XP_NONLETHAL_RATIO));
}

void ACR_GiveXPToPC(object oPC, int nXpAmount) {
    if(!GetIsPC(oPC) || ACR_GetIsDMControlled(oPC)) {
        GiveXPToCreature(oPC, nXpAmount);
        return;
    }
    _CorrectXPTotals(oPC);
    GiveXPToCreature(oPC, nXpAmount);
    ACR_SetPersistentInt(oPC, _STORED_XP, GetXP(oPC));
}

void ACR_CorrectXPTotals(object oPC) {
    if(!GetIsPC(oPC) || ACR_GetIsDMControlled(oPC)) {
        return;
    }
    _CorrectXPTotals(oPC);
}

int ACR_GetECL(object oTarget)
{
    int nXP = GetXP(oTarget);
    if(nXP < 1000) return 1;
    if(nXP < 3000) return 2;
    if(nXP < 6000) return 3;
    if(nXP < 10000) return 4;
    if(nXP < 15000) return 5;
    if(nXP < 21000) return 6;
    if(nXP < 28000) return 7;
    if(nXP < 36000) return 8;
    if(nXP < 45000) return 9;
    if(nXP < 55000) return 10;
    if(nXP < 66000) return 11;
    if(nXP < 78000) return 12;
    if(nXP < 91000) return 13;
    if(nXP < 105000) return 14;
    if(nXP < 120000) return 15;
    if(nXP < 136000) return 16;
    if(nXP < 153000) return 17;
    if(nXP < 171000) return 18;
    if(nXP < 190000) return 19;
    return 20;
}

int ACR_ProcessLevelUpAttempt(object oPC) {
    ACR_CorrectXPTotals(oPC);

    // happens after leveling, so use "current" effective level
    int nTestLevel = ACR_GetECL(oPC);

    return (GetXP(oPC) < GetXpNeededForLevel(nTestLevel)) ? FALSE : TRUE;
}

void ACR_XPOnClientLoaded(object oPC) {

	// ** WARNING WARNING WARNING **
	// This function is DIRECTLY CALLED by the omega wand on validation.
	// For a quarantined PC, it may run TWICE, once at DelayCommand time
	// and again on validation.  It is possible for the function to be
	// run TWICE while a PC is NOT flagged as quarantined as a result of
	// the original invocation being DelayCommand-based.
	// ** WARNING WARNING WARNING **

	// this function is on a 30-second delay from the OnClientLoaded module event.
    // since we DelayCommand this, make sure the PC is actually around first.
    if (!GetIsObjectValid(oPC)) { return; }

	if (GetLocalInt(oPC, _ACR_PPS_QUARANTINED)) {
		SendMessageToPC(oPC, "RPXP banking is suspended due to being Quarantined.");
		return;
	}
    if (ACR_GetIsPlayerDead(oPC) || ACR_GetIsPlayerDying(oPC)) {
        // PC is dead or dying, don't award or initialize RP XP unless/until they're alive
        SendMessageToPC(oPC, "RP XP banking is suspended due to being dead/dying.");
        return;
    }
	
    int nGameHoursBanked = ACR_GetPersistentInt(oPC, _BANKED_RPXP_INCREMENTS) / _RPXP_CHECKS_PER_HOUR;
    if (nGameHoursBanked > 0) {
        SendMessageToPC(oPC, "Calculating banked RP XP: "+IntToString(nGameHoursBanked)+" game-hour(s).");
        float fHours = (HoursToSeconds(nGameHoursBanked)/(60.0*60.0));
        // SendMessageToPC(oPC, "Equivalent to "+FloatToString(fHours)+" RL Hours.");
        ACR_GiveXPToPC(oPC, FloatToInt(fHours*_RPXP_SCRIPT_ANCHOR));
        int nTotalScriptedRPXP = ACR_GetPersistentInt(oPC, _LIFETIME_RPXP);
        nTotalScriptedRPXP = nTotalScriptedRPXP + FloatToInt(fHours*_RPXP_SCRIPT_ANCHOR);
		float fRPpercent = 100 * (IntToFloat(nTotalScriptedRPXP) / IntToFloat(GetXP(oPC)));
        ACR_LogEvent(oPC, ACR_LOG_RPXP, IntToString(FloatToInt(fHours*_RPXP_SCRIPT_ANCHOR))+" XP for "+IntToString(nGameHoursBanked)+" game-hours. Lifetime total is "+IntToString(nTotalScriptedRPXP)+", for "+FloatToString(fRPpercent, 2, 1)+"% of their total XP.");
		SetLocalFloat(oPC, _RPXP_PERCENT, fRPpercent);
        ACR_SetPersistentInt(oPC, _BANKED_RPXP_INCREMENTS, 0);
        ACR_SetPersistentInt(oPC, _LIFETIME_RPXP, nTotalScriptedRPXP);
    }
    if (GetLocalInt(oPC, _RPINCREMENTS_PLAYERCACHE)) {
        // SendMessageToPC(oPC, "Arrived in module with player cache: "+IntToString(GetLocalInt(oPC, _RPHOURS_PLAYERCACHE)));
        DeleteLocalInt(oPC, _RPINCREMENTS_PLAYERCACHE);
    } 
    // start the RP XP psudoheartbeats for the player
    SetLocalInt(oPC, _RPXP_ACTIVITY, FALSE);
    SetLocalString(oPC, _RPXP_LOCATION, ACR_LocationToString(GetLocation(oPC)));

/*
  We're checking this against the zeroing of the variable that came on the instant of login. If it's
  not -still- zero, then we have another heartbeat running and counting already, and we don't need
  to initiate one. If it's zero, we don't know that we've killed all of the heartbeats, so we also
  have the old check to look for a heartbeat that fires between this moment and the actual scheduled
  heartbeat, as tracked by RPXP_SCHEDULE.
*/
  
    if(!GetLocalInt(oPC, _RPXP_HB))
    {
        // set blocking condition for overlapping heartbeats, record when the next authentic RPXP HB is scheduled
        SetLocalInt(oPC, "RPXP_OVERLAP", TRUE);
        SetLocalInt(oPC, "RPXP_SCHEDULE", (ACR_GetTimeStampInMinutes() + (60/_RPXP_CHECKS_PER_HOUR) - 5));
        // SendMessageToPC(oPC, "Currently "+IntToString(ACR_GetTimeStampInMinutes()));
        // SendMessageToPC(oPC, "Scheduled after "+IntToString(ACR_GetTimeStampInMinutes() + (60/_RPXP_CHECKS_PER_HOUR) - 5));
        // schedule first RP XP heartbeat.
        // running 2 of these per game hour for now
        AssignCommand(oPC, DelayCommand((HoursToSeconds(1)/IntToFloat(_RPXP_CHECKS_PER_HOUR)), _RPXP_PHeartbeat(oPC)));
    }
    return;
}


void ACR_XPOnClientExit(object oPC) {

	if (GetLocalInt(oPC, _ACR_PPS_QUARANTINED)) {
		return;
	}
	
    int nPlayerBank = GetLocalInt(oPC, _RPINCREMENTS_PLAYERCACHE);
    ACR_SetPersistentInt(oPC, _BANKED_RPXP_INCREMENTS, nPlayerBank);
    DeleteLocalInt(oPC, _RPINCREMENTS_PLAYERCACHE);

    return;
}

void ACR_RPXPMarkActive(object oPC) {

	SetLocalInt(oPC, _RPXP_ACTIVITY, TRUE);
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _CorrectXPTotals(object oPC) {
    int nStoredXP = ACR_GetPersistentInt(oPC, _STORED_XP);
    int nXP = GetXP(oPC);

    if(nXP > nStoredXP) {
        // XP is higher than recorded.
        int nExtraPoints = nXP - nStoredXP;
        // --------------removed warning to players for "non-ALFA" XP, until we have radial handling for ACR XP
        // SendMessageToPC(oPC, IntToString(nExtraPoints) + " of your experience points were given to you without the proper scripts. Your experience total is being corrected for this error. Please contact the staff of the server where you suspect this XP may have come from, so they may correct this mistake.");
        //SetXP(oPC, nStoredXP);
        //ACR_GiveXPToPC(oPC, nExtraPoints);
        ACR_SetPersistentInt(oPC, _STORED_XP, nXP);
    } else if(nXP < nStoredXP) {
        // XP is lower than recorded.
        ACR_SetPersistentInt(oPC, _STORED_XP, nXP);
    }
}

void _SetALFAXp(object oPC, int nXpAmount) {
    SetXP(oPC, nXpAmount);
    ACR_SetPersistentInt(oPC, _STORED_XP, nXpAmount );
}

float _GetBaseCombatXP(float fCR) {
    return (_ACR_XP_COMBAT_ANCHOR * pow(fCR, 3.0/5.0));
}

// From standards:
// - DangerFactor values:
// --- DangerFactor(< -3) = 0.1*BaseXP(CharLev) UnderCR Condition
// --- DangerFactor (-3 to -1) = (2/(2 - Argument))*BaseXP(CharLev)
// --- DangerFactor(0) = 1*BaseXP(CharLev)
// --- DangerFactor(+1 to +4) = ((2 + Argument)/2)*BaseXP(CharLev)
// --- DangerFactor(> +4) = 3.5*BaseXP(CharLev) OverCR Condition
float _GetXPForDangerFactor(float fDangerFactor) {
    if(fDangerFactor < -3.0) {
        return 0.1;
    } else if(fDangerFactor <= -1.0) {
        return 2.0/(2.0-fDangerFactor);
    } else if(fDangerFactor == 0.0) {
        return 1.0;
	// shifted maximum DangerFactor to 2.5 from 4.0
    } else if(fDangerFactor < 2.5) {
	    if (fDangerFactor >= _ACR_XP_OVERCR_LOGGING) {
			object oHighest = GetLocalObject(OBJECT_SELF, "Highest"), oKiller = GetLocalObject(OBJECT_SELF, "Killer");
			ACR_LogEvent(OBJECT_SELF, ACR_LOG_OVERCR, GetResRef(OBJECT_SELF)+": +"+FloatToString(fDangerFactor, 1, 2)+" over PC level ("+IntToString(GetHitDice(oHighest))+") for "+GetName(oHighest)+"; party of "+IntToString(GetLocalInt(OBJECT_SELF, "PartySize")));
		}
        return ((2.0+fDangerFactor)/2.0);
	// Maxium Multiplier to 2.5 from 3.5
    } else {
		object oHighest2 = GetLocalObject(OBJECT_SELF, "Highest"), oKiller2 = GetLocalObject(OBJECT_SELF, "Killer");
		ACR_LogEvent(OBJECT_SELF, ACR_LOG_OVERCR, "MAX: "+GetResRef(OBJECT_SELF)+" +"+FloatToString(fDangerFactor, 1, 2)+" over PC level ("+IntToString(GetHitDice(oHighest2))+") for "+GetName(oHighest2)+"; party of "+IntToString(GetLocalInt(OBJECT_SELF, "PartySize")));
		return 2.5;
	}
}

float _GetXPForLethalChallenge(int nPCLevel, float fCR) {
    return _GetBaseCombatXP(fCR) * _GetXPForDangerFactor(fCR - IntToFloat(nPCLevel));
}

float _GetPositivePercentageOf(float fPercent, float fValue) {
    if(fPercent <= 0.0) {
        return 0.0;
    } else if(fPercent >= 100.0) {
        return fValue;
    }
    return fPercent * fValue;
}


void _RPXP_PHeartbeat(object oPlayer) {
    
	// SendMessageToPC(oPlayer, "RPXP HB: Currently "+IntToString(ACR_GetTimeStampInMinutes()));
    if (!GetIsObjectValid(oPlayer)) {
        // player is logged off, stop polling for this PC
        return;
    } else if (GetLocalInt(oPlayer, "RPXP_OVERLAP")) {
        // then this is during the opening interval- check schedule
        //SendMessageToPC(oPlayer, "scheduled is "+IntToString(GetLocalInt(oPlayer, "RPXP_SCHEDULE"))+", current is "+IntToString(ACR_GetTimeStampInMinutes()));
        if (ACR_GetTimeStampInMinutes() >= GetLocalInt(oPlayer, "RPXP_SCHEDULE")) {
            // this is the correct time to run the heartbeat.
            DeleteLocalInt(oPlayer, "RPXP_OVERLAP");
            DeleteLocalFloat(oPlayer, "RPXP_SCHEDULE");
        } else {
            // this is a a residual loop- terminate and leave schedule posted.
            SendMessageToPC(oPlayer, "Residual RPXP loop terminated.");
            return;
        }
    }
    int nIteration = GetLocalInt(oPlayer, _RPXP_HB);
    
    int nBanked = GetLocalInt(oPlayer, _RPINCREMENTS_PLAYERCACHE);
    string sLoc = ACR_LocationToString(GetLocation(oPlayer));
    if (GetLocalInt(oPlayer, _RPXP_ACTIVITY)) {
        nBanked = nBanked + 1;
        SetLocalInt(oPlayer, _RPINCREMENTS_PLAYERCACHE, nBanked);
        SendMessageToPC(oPlayer, "RP increment");
    } else if (sLoc != GetLocalString(oPlayer, _RPXP_LOCATION)) {
        nBanked = nBanked + 1;
        SetLocalInt(oPlayer, _RPINCREMENTS_PLAYERCACHE, nBanked);
        SendMessageToPC(oPlayer, "Location increment");
    } else {
        SendMessageToPC(oPlayer, "no increment- inactive");
    }
    if (nIteration == 4) {
        // player has been on for 4 game-hours, back up banked RP XP to the DB
        SetLocalInt(oPlayer, _RPXP_HB, 0);
        ACR_SetPersistentInt(oPlayer, _BANKED_RPXP_INCREMENTS, nBanked);         
    } else { 
        SetLocalInt(oPlayer, _RPXP_HB, nIteration+1); 
    }
    // clear activity and reset location test
    SetLocalInt(oPlayer, _RPXP_ACTIVITY, FALSE);
    SetLocalString(oPlayer, _RPXP_LOCATION, sLoc);

    DelayCommand(HoursToSeconds(1)/IntToFloat(_RPXP_CHECKS_PER_HOUR), _RPXP_PHeartbeat(oPlayer));
    return;
}

float _AdjustXPForParty(float fBaseXP, int nSize) {
	float fMult = 0.9 - (((nSize-5)*(nSize-5))/35);
	if(nSize < 3 && fMult < 0.6) fMult = 0.6f;
	if(fMult < 0.0f) return 0.0f;
	return fBaseXP * fMult;
}

#endif

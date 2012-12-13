////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_resting_i
//    $Revision:: 620        $ current version of the file
//        $Date:: 2009-08-15#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_REST
//  Dependencies: Tent, Bedroll, Campfire, Herbs, Medicines, Holy Symbols, Spell Books
//
//  Description
//  Resting system implementation based on ALFA requirements:
//  http://www.alandfaraway.org/phpBB2/viewtopic.php?t=27478
//
//  Revision History
//  2006/05/25  Cipher  Inception
//  2006/07/31  Cipher  Leveraged PC persistence API
//  2006/08/01  Cipher  Renamed rest flag local variable
//  2006/08/17  Cipher  Revised per updated requirements & extracted spell tracking code
//  2006/09/09  Cipher  Changed ALFA prefix to ACR
//  2006/09/19  Cipher  Updated references to PC persistence functions
//  2006/11/07  Cipher  Added global set/get fatigued functions
//  2007/04/03  AcadiusLost  Added ACR_RestTriggerEnter() & exit functions, to hook from acr_trigger_i
//  2007/04/15  AcadiusLost  Added debugging for StudyForSpells
//  2007/04/28  AcadiusLost  Added debugging for PrayForSpells, control for "Not Tired enough" case
//  2007/05/02  AcadiusLost  Changed animations for Studying and Praying, stopped cancelled rests from 
//                           clearing all spells from memory, set resting to retain memorized spells for
//                           arcane and divine casters
//  2007/05/25  Cipher  Retrofit persistence calls with NWNX functions, misc code cleanup
//  2007/07/08  AcadiusLost Changed pray/study durations to floats, 0.25 game-hours each.
//                      also #included acr_time_i so we could use ACR_GameHoursToRealSeconds()
//  2007/07/10  AcadiusLost  changed _playerCanRest() to report time till you can rest again
//                           changed ACR_RestOnClientEnter() to only allow logging in rested if the player 
//                           has been logged out > 1 rest cycle. (currently 8 game-hours)
//  2007/07/15  Cipher  Bug fix: apply str and dex penalty on rest, not str penalty twice
//  2007/07/15  AcadiusLost  Altered _HealFromRest to be sensitive to multi-day resting from offline time.
//                      also set up ACR_REST_OFFCAMERA_DAYS to be passed as a local int from 
//                      _ProcessOffCameraRest(), which handles offcamera resting via ACR_RestOnClientEnter().
//  2007/07/16  Cipher  Revised spell tracking
//  2007/07/19  AcadiusLost  Some fixes with RestOnClientEnter and the offine rest handling, also added
//                      ability damage adjustment to _unHealFromRest().  Shifted zone check to after time 
//                      check in _playerCanRest()
//  2007/07/21  AcadiusLost  Altered offline resting not to apply to dead or dying PCs.  Initialized ACR_REST_HP
//                      for offline resting.
//  2007/07/21  Cipher  Misc code clean up and optimization, fixed healing on cancelled rests
//  2007/07/28  AcadiusLost  Shifted ACR_REST_HP initialization out of the ACR_PlayerOnRest() switch, changed 
//                      ACR_RestOnClientEnter() to work in game-hours.  Altered _playerOnRest() to report time to rest
//                      from outside legitimate rest triggers as well.  Cached attributes before a rest cancel is processed.
//  2007/08/20  Cipher  Reworked spell tracking per class
//  2007/09/14  AcadiusLost: altered offcamera resting to restore spells and not block prayers/studying
//  2007/09/18  AcadiusLost: changed _healfromrest() handling for fatigue from armor to no longer apply in the 1-day offline rest.
//  2007/10/27  AcadiusLost: Fixed a bug with offline resting not clearing spelltrack entries.
//  2007/10/29  AcadiusLost: Split spell restoration timestamps between Prayer and Study.  Also added handling for offline resting,
//                       so PCs can enter able to study or pray without resting first.
//  2008/02/27  AcadiusLost: Added RestoreSpells() call to the _playerrestorespells() function to handle multiclassed casters
//                       also expanded innate caster spell restoration for MotB classes (FS, SS). 
//                       Pushed HP caching to Rest event Started to stop 100% healing.
//  2008/03/29  AcadiusLost: tied outdoor resting to class and PC Tools tent placeable. edits to _PlayerCanRest()
//  2008/08/27  AcadiusLost: Added subdual healing to resting event
//  2009/02/01  AcadiusLost: Added exceptions for Quarantined PCs
//  2009/03/01  AcadiusLost: Fixes for attribute damage healing OnRest.
//  2009/08/08  AcadiusLost: Added hooks into rest/prayer/studying to block use on the travel maps.
//  2009/08/15  AcadiusLost: Cleaned up debugging info from Offline resting.
//
//  2011/04/19  Zelknolf: Fixing function declarations
//  2011/09/04  Paazin: Remove Fatigue code and place it into acr_effects_i
//  2012/04/04  FoamBats4All: Changed resting fatigue to be SRD-compliant.
//  2012/04/25  FoamBats4All: Corrected to properly allow resting in medium armor with the endurance feat.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_pps_i"
#include "acr_time_i"
#include "acr_nonlethal_i"
#include "acr_effects_i"
#include "acr_skills_i"

// REMOVE THESE WHEN INCLUDED OR ADDED TO NWSCRIPT
const int FEAT_ENDURANCE = 12;

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Enable/Disable the Rest System
const int ACR_REST_ENABLED = TRUE;

const string ACR_REST_EFFECT_SOURCE = "ACR_REST";

//! Local variable definitions
const string ACR_REST_FLAGS = "ACR_REST_FLAGS";
const string ACR_REST_TIMER = "ACR_REST_TIMER";
const string ACR_REST_NAP_TIMER = "ACR_REST_NAP_TIMER";
const string ACR_REST_PRAYER_TIMER = "ACR_REST_PRAYER_TIMER";
const string ACR_REST_STUDY_TIMER = "ACR_REST_STUDY_TIMER";
const string ACR_REST_LOGOUT_TIMER = "ACR_REST_LOGOUT_TIMER";
const string ACR_REST_HEAL_BONUS = "ACR_REST_HEAL_BONUS";
const string ACR_REST_NOT_TIRED = "ACR_REST_NOT_TIRED";
const string ACR_REST_HP = "ACR_REST_HP";
const string ACR_REST_ZONE = "ACR_REST_ZONE";
const string ACR_REST_BONUS = "ACR_REST_BONUS";
const string ACR_REST_STRENGTH = "ACR_REST_STRENGTH";
const string ACR_REST_CONSTITUTION = "ACR_REST_CONSTITUTION";
const string ACR_REST_DEXTERITY = "ACR_REST_DEXTERITY";
const string ACR_REST_INTELLIGENCE = "ACR_REST_INTELLIGENCE";
const string ACR_REST_WISDOM = "ACR_REST_WISDOM";
const string ACR_REST_CHARISMA = "ACR_REST_CHARISMA";
const string ACR_REST_DISEASE = "ACR_REST_DISEASE";
const string ACR_REST_DISEASE_CHANCE = "ACR_REST_DISEASE_CHANCE";
const string ACR_REST_TENT = "ACR_REST_TENT";
const string ACR_REST_BEDROLL = "ACR_REST_BEDROLL";
const string ACR_REST_OFFCAMERA_DAYS = "ACR_REST_OFFCAMERA_DAYS";
const string ACR_FREE_SPELL_PREP = "ACR_FREE_SPELL_PREP";

//! Resting object blueprint tags
//const string ACR_REST_TENT_TAG = "abr_plc_tent";
const string ACR_REST_TENT_TAG = "HSS_PCTOOLS_TENT";
const string ACR_REST_BEDROLL_TAG = "abr_plc_bedroll";
const string ACR_REST_CAMPFIRE_TAG = "abr_plc_campfire";

//! ACR_REST_FLAGS Bit Maps
//! Define all booleans as bits to conserve memory
const int ACR_REST_FLAG_FATIGUED = 0x01;
const int ACR_REST_FLAG_NAPPING  = 0x02;
const int ACR_REST_FLAG_PRAYING  = 0x04;
const int ACR_REST_FLAG_STUDYING = 0x08;
const int ACR_REST_FLAG_LTM_CARE = 0x10;

//! Rest Cycle(s)
const int ACR_REST_CYCLE = 24;

//! Rest Bonus(es)
const int ACR_REST_MIN_BONUS = 1;

//! Rest Zone Values
const int ACR_REST_ZONE_ILLEGAL  = 0;
const int ACR_REST_ZONE_INTERIOR = 1;
const int ACR_REST_ZONE_EXTERIOR = 2;

//! Rest Return Values
const int ACR_REST_TYPE_VALID		= 1;
const int ACR_REST_TYPE_INVALID		= -1;
const int ACR_REST_TYPE_NOTTIRED	= 0;

//! Maximum tent distance
const float ACR_REST_MAX_TENT_DIST	= 8.0f;

//! Rest Durations
const float ACR_REST_PRAY_DURATION = 0.25;     // IG hours - converted to seconds
const float ACR_REST_STUDY_DURATION = 0.25;    // IG hours - converted to seconds
const float ACR_REST_DURATION = 120.0;    // RL seconds
const float ACR_REST_NAP_DURATION = 10.0; // RL seconds

//! Rest Messages
const string ACR_REST_MSG_NOT_REST  = "You cannot rest here.";
const string ACR_REST_MSG_NOT_WELL  = "You are not well enough to rest yet.";
const string ACR_REST_MSG_NOT_TIRED = "You are not tired enough to rest yet.";
const string ACR_REST_MSG_FATIGUED  = "You are fatigued. Your armor hindered your rest!";

// Travel map indicator localint, important for blocking resting and spell restoration while on the travelmap.
const string ACR_IS_TRAVELMAP = "ACR_IS_TRAVEL_AREA";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! Main OnRest function
//!  - oPC: player attempting to rest
//!  - Returns: nothing
//! Call this function from the module OnPlayerRest event handler
void ACR_OnPlayerRest(object oPC, int nRestEvent);

//! Start the rest timer between logins if the PC is in a rest zone
//!  - oPC: player leaving the server
//!  - Returns: nothing
//! Call this function OnClientLeave event handler
void ACR_RestOnClientLeave(object oPC);

//! Apply the benefits of a rest if enough time has passed between logins
//!  - oPC: player entering the server
//!  - Returns: nothing
//! Call this function OnClientEnter event handler
void ACR_RestOnClientEnter(object oPC);

//! This function manages (toggles) the long term care status on demand
//!  - oPC: player to whom long term care applies
//!  - bStatus: boolean status - TRUE or FALSE
//!  - Returns: nothing
void ACR_SetLongTermCare(object oPC, int bStatus);

//! This function manages the herbal/medicinal heal bonus applied on rest
//!  - oPC: player to whom the healing bonus applies
//!  - nHeal: amount to heal - multiple bonuses will stack
//!  - Returns: nothing
void ACR_SetHealBonus(object oPC, int nHeal);

//! This function returns the current herbal/medicinal heal bonus to be applied on rest
//!  - oPC: player to whom the healing bonus applies
//!  - Returns: integer value representing the amount to be healed
int ACR_GetHealBonus(object oPC);

//! Pray for spells - this is how divine spell casters restore their spell uses
//!  - oCaster: player praying for spells
//!  - Returns: nothing
void ACR_PrayForSpells(object oCaster);

//! Study for spells - this is how arcane spell casters restore their spell uses
//!  - oCaster: player studying for spells
//!  - Returns: nothing
void ACR_StudyForSpells(object oCaster);

//! Handles entry into a rest area trigger, hooked into the acf OnEnter event via acr_trigger_i.nss
void ACR_RestTriggerEnter(object oArrived);

//! Handles exit from a rest area trigger, hooked into the acf OnEnter event via acr_trigger_i.nss
void ACR_RestTriggerExit(object oDeparted);

//! *** PRIVATE FUNCTIONS ***

//! This function determines if a player is allowed to rest (heal and restore spells)
//!  - oPC: player attempting to rest
//!  - Returns:
//!     1 - can rest
//!     0 - is not tired
//!    -1 - cannot rest
//! Triggers must be setup for the following:
//!  - indoor rest zone
//!  - outdoor rest zone
//! Create a spot/search widget - detect rest zones (terrain suitable for resting)
int _playerCanRest(object oPC);

//! This function restores a player's spells only
//!  - oCaster: player restoring spells
//!  - sClasses: comma separated list of CLASS_TYPE_* integers to clear logs for, or empty for all
//!  - nHitPoints: players current hit points
//!  - Returns: nothing
void _playerRestoreSpells(object oCaster, string sClasses, int nHitPoints);

//! This function processes a player's rest initiation event
//!  - oPC: player trying to rest
//!  - Returns: nothing
void _playerRestStart(object oPC);

//! This function processes a player's rest completion event
//!  - oPC: player trying to rest
//!  - Returns: nothing
void _playerRestFinish(object oPC);

//! This function processes a player's rest cancellation event
//!  - oPC: player trying to rest
//!  - Returns: nothing
void _playerRestCancel(object oPC);

//! This function applies sleep effects to the player resting
//!  - oPC: player resting
//!  - Returns: nothing
void _applySleepEffects(object oPC);

//! This function removes sleep effects from the player resting
//!  - oPC: player resting
//!  - Returns: nothing
void _removeSleepEffects(object oPC);

//! This function limits healing from NWN rests according to 3E rules
//!  - oCreature: object to apply heal limits on
//!  - nOriginalHitPoints: players hit points before resting
//!  - Returns: nothing
void _healFromRest(object oCreature, int nOriginalHitPoints);

//! This function restores the creatures original hit points if rest is cancelled
//!  - oCreature: creature who's health to restore
//!  - nOriginalHitPoints: creature's hit points before resting
//!  - Returns: nothing
void _unhealFromRest(object oCreature, int nOriginalHitPoints);

//! This function determines if the area grants a healing bonus
//! - oCreature: creature resting
//! - Returns: 1 + Constitution modifier
int _getAreaRestBonus(object oCreature);

//! This function determines if the area grants a healing bonus
//! - oCreature: creature resting
//! - Returns: % of hit die bonus a PC gets
//! Rest Zone Triggers must be setup to include a REST BONUS as a percentage of Hit Dice.
//! Adjust the variable called ACR_REST_BONUS and give it an integer value >= 0.
//! This value will allow the player to heal with a bonus of X% * HitDice.
int _getCustomRestBonus(object oCreature);

//! This function retrieves the familiar or animal companion of oPC
//!  - oPC: player acting as the master
//!  - Returns: creature object, either the familiar or OBJECT_INVALID
object _getPCFamiliar(object oPC);

//! This function purges all temporary data stored on the PC during the rest process to conserve memory
//!  - oPC: player object on which temp data is stored
//!  - Returns: nothing
void _garbageCollection(object oPC);

//! This function is an adaption of _playerRestFinish() for PCs who have been logged out over a complete
//! rest cycle or longer. It applies healing as if the PC has rested each day, and still leaves the PC
//! able to rest during the current cycle.
//!  - oPC: player object to calculate off camera healing for
//!  - nDuration: number of rest cycles (days) the player has been offline
void _ProcessOffCameraRest(object oPC, int nDuration);

//! Returns 1 if the user should be fatigued from wearing armor, else 0.
int _getSufferArmorFatigue(object oPC);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_OnPlayerRest(object oPC, int nRestEvent)
{
    // exit if the system is not enabled
    if (!ACR_REST_ENABLED) { return; }
	
	// do not permit dead players to rest
	if (ACR_GetIsPlayerDead(oPC)) { AssignCommand(oPC, ClearAllActions()); return; }

	// do not permit quarantined players to rest
	if (ACR_PPSIsPlayerQuarantined(oPC)) { AssignCommand(oPC, ClearAllActions()); return; }
	
	//SetLocalInt(oPC, ACR_REST_STRENGTH, GetAbilityScore(oPC, ABILITY_STRENGTH));
    //SetLocalInt(oPC, ACR_REST_DEXTERITY, GetAbilityScore(oPC, ABILITY_DEXTERITY));
    //SetLocalInt(oPC, ACR_REST_CONSTITUTION, GetAbilityScore(oPC, ABILITY_CONSTITUTION));
    //SetLocalInt(oPC, ACR_REST_INTELLIGENCE, GetAbilityScore(oPC, ABILITY_INTELLIGENCE));
    //SetLocalInt(oPC, ACR_REST_WISDOM, GetAbilityScore(oPC, ABILITY_WISDOM));
    //SetLocalInt(oPC, ACR_REST_CHARISMA, GetAbilityScore(oPC, ABILITY_CHARISMA));
	
    // determine the rest event that was triggered
    switch (nRestEvent)
    {
        // rest has been initiated
        case REST_EVENTTYPE_REST_STARTED:
		    
		    // store the player's current hitpoints prior to resting so we know the excess healing to remove
    		SetLocalInt(oPC, ACR_REST_HP, GetCurrentHitPoints(oPC));

            // check if the player can rest at the current location
            switch (_playerCanRest(oPC))
            {
                // the player can rest
                case ACR_REST_TYPE_VALID:
					
                    // start player resting
                    _playerRestStart(oPC);

                    // process familiar/animal companion/henchman resting?
                    _playerRestStart(_getPCFamiliar(oPC));
                    break;

                // the player isn't tired
                case ACR_REST_TYPE_NOTTIRED:
                    // stop the player from resting
                    AssignCommand(oPC, ClearAllActions());

                    // send a failure notice to the player
                    FloatingTextStringOnCreature(ACR_REST_MSG_NOT_TIRED, oPC, FALSE);
                    SetLocalInt(oPC, ACR_REST_NOT_TIRED, TRUE);
                    break;

                // the player can't rest
                case ACR_REST_TYPE_INVALID:
                default:
                    // stop the player from resting
                    AssignCommand(oPC, ClearAllActions());

                    // send a failure notice to the player
                    FloatingTextStringOnCreature(ACR_REST_MSG_NOT_REST, oPC, FALSE);
                    break;
            }
            break;

        // rest successfully completed
        case REST_EVENTTYPE_REST_FINISHED:
            // complete player resting
            _playerRestFinish(oPC);

            // complete familiar/animal companion/henchman resting?
            //_playerRestFinish(_getPCFamiliar(oPC));
            break;

        // rest cancelled before completion
        case REST_EVENTTYPE_REST_CANCELLED:

 			SetLocalInt(oPC, ACR_REST_STRENGTH, GetAbilityScore(oPC, ABILITY_STRENGTH));
    		SetLocalInt(oPC, ACR_REST_DEXTERITY, GetAbilityScore(oPC, ABILITY_DEXTERITY));
    		SetLocalInt(oPC, ACR_REST_CONSTITUTION, GetAbilityScore(oPC, ABILITY_CONSTITUTION));
    		SetLocalInt(oPC, ACR_REST_INTELLIGENCE, GetAbilityScore(oPC, ABILITY_INTELLIGENCE));
   		    SetLocalInt(oPC, ACR_REST_WISDOM, GetAbilityScore(oPC, ABILITY_WISDOM));
    		SetLocalInt(oPC, ACR_REST_CHARISMA, GetAbilityScore(oPC, ABILITY_CHARISMA));
            // cancel player resting
            _playerRestCancel(oPC);

            // cancel familiar/animal companion/henchman resting?
            //_playerRestCancel(_getPCFamiliar(oPC));
            break;

        default:
            // not a valid request - do nothing
            break;
    }
}

void ACR_RestOnClientLeave(object oPC)
{
    // PC object may not be available by the time this is invoked - might require workaround

    // store the logout time stamp, but only if the PC is not logging out of Quarantine
	if (!ACR_PPSIsPlayerQuarantined(oPC)) {
    	ACR_SetPersistentInt(oPC, ACR_REST_LOGOUT_TIMER, ACR_GetTimeStampInMinutes());
	}
}

void ACR_RestOnClientEnter(object oPC)
{
	// ** WARNING WARNING WARNING **
	// This function is DIRECTLY CALLED by the omega wand on validation.
	// For a quarantined PC, it may run TWICE, once at actual client
	// enter, and again on validation.
	// ** WARNING WARNING WARNING **

    // if PC is dead or dying, do not consider them for offcamera rest.
	if (ACR_GetIsPlayerDead(oPC) || ACR_GetIsPlayerDying(oPC)) { 
	    SendMessageToPC(oPC, "You are read as dead or dying- no offcamera rest for you!");
	    return; 
	}
	// do not process Quarantined PCs
	if (ACR_PPSIsPlayerQuarantined(oPC)) {
	    SendMessageToPC(oPC, "Offline resting is disabled for Quarantined PCs");
	    return; 	
	}
    // retrieve the logout time stamp
    int nLogOutTime = ACR_GetPersistentInt(oPC, ACR_REST_LOGOUT_TIMER);
		
	// if there is no logout timestamp, do not try to calculate offline time.
	if (nLogOutTime == 0) { return; }
		
    // compute the time between logins to the minute
    int nLogInTime = ACR_GetTimeStampInMinutes();
		    
	// determine the number of rest cycles that passed while the PC was offline
	int nOfflineCycles = FloatToInt((IntToFloat(nLogInTime - nLogOutTime)/60) / (IntToFloat(ACR_REST_CYCLE)));

    // exit if not enough time has passed between logins to simulate a rest
    if (nOfflineCycles < 1) { return; }
		
    // allow the simulated rest (login/out)
    _ProcessOffCameraRest(oPC, nOfflineCycles);
}

void ACR_SetLongTermCare(object oPC, int bStatus)
{
    // check if LTC is being activated or deactivated
    if (bStatus)
    {
        // set the persistent long term care status
        ACR_SetPersistentInt(oPC, ACR_REST_FLAGS, ACR_GetPersistentInt(oPC, ACR_REST_FLAGS) | ACR_REST_FLAG_LTM_CARE);
    }
    else
    {
        // unset the persistent long term care status
        ACR_SetPersistentInt(oPC, ACR_REST_FLAGS, ACR_GetPersistentInt(oPC, ACR_REST_FLAGS) & ~(ACR_REST_FLAG_LTM_CARE));
    }
}

void ACR_SetHealBonus(object oPC, int nHeal)
{
    // prevent stacking? only apply highest heal bonus per rest?

    // keep a running sum - add the heal bonus to the current amount
    ACR_SetPersistentInt(oPC, ACR_REST_HEAL_BONUS, ACR_GetPersistentInt(oPC, ACR_REST_HEAL_BONUS) | nHeal);
}

int ACR_GetHealBonus(object oPC)
{
    return ACR_GetPersistentInt(oPC, ACR_REST_HEAL_BONUS);
}

void ACR_PrayForSpells(object oCaster)
{
    // prayer is limited to divine spell casters
    if (ACR_HasCasterClass(oCaster, "DIVINE"))
    {
        if (GetLocalInt(GetArea(oCaster), ACR_IS_TRAVELMAP) == TRUE) 
        {
            // block if oCaster is on the travel map.
            SendMessageToPC(oCaster, "You cannot restore spells on the travel map.");
            return;
        }
        // block spell restoration for Quarantined PCs
        if (ACR_PPSIsPlayerQuarantined(oCaster)) 
        {
            SendMessageToPC(oCaster, "Spell restoration is disabled while in Quarantine.");
            return;
        }
        int nLastRestTimeStamp = ACR_GetPersistentInt(oCaster, ACR_REST_TIMER);
        int nLastPrayTimeStamp = ACR_GetPersistentInt(oCaster, ACR_REST_PRAYER_TIMER);
        
        // check if the caster has rested since the last prayer
        if (nLastPrayTimeStamp >= nLastRestTimeStamp)
        {
            // need to rest first
            FloatingTextStringOnCreature("You have already prayed for your spells today.", oCaster, FALSE);
        }
        // otherwise the caster can attempt to recover spells
        else
        {
            string sClasses = IntToString(CLASS_TYPE_CLERIC) + "," + IntToString(CLASS_TYPE_PALADIN) + "," + IntToString(CLASS_TYPE_RANGER) + "," + IntToString(CLASS_TYPE_DRUID);

            // pack the action queue first with the meditation animation for a set duration then restore spell uses
            AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, ACR_GameHoursToRealSeconds(ACR_REST_PRAY_DURATION)));
            AssignCommand(oCaster, ActionDoCommand(_playerRestoreSpells(oCaster, sClasses, GetCurrentHitPoints(oCaster))));
        
            FloatingTextStringOnCreature("You focus on your Holy Symbol and begin your prayers.", oCaster, FALSE);
        }
    }
    else
    {
        FloatingTextStringOnCreature("You don't know how to use this.", oCaster, FALSE);
    }
}

void ACR_StudyForSpells(object oCaster)
{
    // studying is limited to wizards
    if (ACR_HasCasterClass(oCaster, "ARCANE"))
    {
        if (GetLocalInt(GetArea(oCaster), ACR_IS_TRAVELMAP) == TRUE) 
        {
            // block if oCaster is on the travel map.
            SendMessageToPC(oCaster, "You cannot restore spells on the travel map.");
            return;
        }
        // block spell restoration for Quarantined PCs
        if (ACR_PPSIsPlayerQuarantined(oCaster)) 
        {
            SendMessageToPC(oCaster, "Spell restoration is disabled while in Quarantine.");
            return;
        }
        // otherwise, continue
        int nLastRestTimeStamp  = ACR_GetPersistentInt(oCaster, ACR_REST_TIMER);
        int nLastStudyTimeStamp = ACR_GetPersistentInt(oCaster, ACR_REST_STUDY_TIMER);
        
        // check if the caster has rested since the last study
        if (nLastStudyTimeStamp >= nLastRestTimeStamp)
        {
            // need to rest first
            FloatingTextStringOnCreature("You have already studied your spells today.", oCaster, FALSE);
        }
        // otherwise the caster can attempt to recover spells
        else
        {
            // pack the action queue first with the meditation animation for a set duration then restore spell uses
            AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, ACR_GameHoursToRealSeconds(ACR_REST_STUDY_DURATION)));
            AssignCommand(oCaster, ActionDoCommand(_playerRestoreSpells(oCaster, IntToString(CLASS_TYPE_WIZARD), GetCurrentHitPoints(oCaster))));

            FloatingTextStringOnCreature("You open your spellbook and begin to study your spells.", oCaster, FALSE);
        }
    }
    else
    {
        FloatingTextStringOnCreature("You don't know how to use this.", oCaster, FALSE);
    }
}

void ACR_RestTriggerEnter(object oArrived)
{
    // REST_ZONE != O, and the entering object is a PC, means we should set the variables accordingly.
    if (GetIsPC(oArrived) && GetLocalInt(OBJECT_SELF, ACR_REST_ZONE))
    {
        // set the rest zone type on the entering object
        SetLocalInt(oArrived, ACR_REST_ZONE, GetLocalInt(OBJECT_SELF, ACR_REST_ZONE));

        // set the rest zone healing bonus
        SetLocalInt(oArrived, ACR_REST_BONUS, GetLocalInt(OBJECT_SELF, ACR_REST_BONUS));

        // set the rest zone disease ID, DC, and % chance to contract
        SetLocalFloat(oArrived, ACR_REST_DISEASE, GetLocalFloat(OBJECT_SELF, ACR_REST_DISEASE));
        SetLocalInt(oArrived, ACR_REST_DISEASE_CHANCE, GetLocalInt(OBJECT_SELF, ACR_REST_DISEASE_CHANCE));
    }
}

void ACR_RestTriggerExit(object oDeparted)
{
    // Authentic rest zone, and an actual PC, so adjust their variables.
    if (GetIsPC(oDeparted) && GetLocalInt(OBJECT_SELF, ACR_REST_ZONE))
    {
	    // clear the rest zone data on the exiting object
        DeleteLocalInt(oDeparted, ACR_REST_ZONE);
        DeleteLocalInt(oDeparted, ACR_REST_BONUS);
        DeleteLocalInt(oDeparted, ACR_REST_DISEASE_CHANCE);
        DeleteLocalFloat(oDeparted, ACR_REST_DISEASE);
    }
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _playerCanRest(object oPC)
{
    object oTent;
    int nLastRestTimeStamp,nReturn=ACR_REST_TYPE_VALID;

    // do the simpler, local checks first before hitting the database for the rest cycle/time check
    
    // exit if the player is unconscious
    if (GetCurrentHitPoints(oPC) < 0)
    {
        return ACR_REST_TYPE_INVALID;
    }

    // block if is on the travel map.
    if (GetLocalInt(GetArea(oPC), ACR_IS_TRAVELMAP) == TRUE)
    {
        SendMessageToPC(oPC, "You cannot rest on the travel map.  Use the DMFI cancel button to drop to a fullscale area and make camp.");
        return ACR_REST_TYPE_INVALID;
    }
    
    // still exit if the player is not in a rest zone (even though they are tired enough to rest)
    if (GetLocalInt(oPC, ACR_REST_ZONE) == ACR_REST_ZONE_ILLEGAL) 
    {
        nReturn = ACR_REST_TYPE_INVALID;

        // check for other enabling conditions for resting, that might compensate for lack of a rest trigger
        if (GetIsAreaNatural(GetArea(oPC))) 
        {
            oTent = GetNearestObjectByTag(ACR_REST_TENT_TAG, oPC);

            // tent is set up nearby, allow rest.
            if (GetIsObjectValid(oTent) && (GetDistanceBetween(oPC, oTent) < ACR_REST_MAX_TENT_DIST)) 
            {
                SendMessageToPC(oPC, "Thanks to the shelter of the tent, you may rest here.");
                nReturn = ACR_REST_TYPE_VALID;
            }
            // don't need special shelter if you have survival ranks.
            else if (ACR_SkillCheck(SKILL_SURVIVAL, oPC, 15, TRUE))
            {
                SendMessageToPC(oPC, "Your knowledge of survival allows you to create a makeshift shelter comfortable enough for gainful rest.");
                nReturn = ACR_REST_TYPE_VALID;
            }
        }
    }

    // get the time the PC last rested (only if still valid)
    if (nReturn == ACR_REST_TYPE_VALID)
    {
        nLastRestTimeStamp = ACR_GetPersistentInt(oPC, ACR_REST_TIMER);
		int nHoursToWait = ACR_GetTimeStampInHours() - nLastRestTimeStamp;

        // check if enough time hasn't elapsed between attempts, and if the area is valid, make sure that the number of hours to rest isn't over the rest cycle.
        if ( nHoursToWait < ACR_REST_CYCLE && ( ACR_REST_CYCLE - nHoursToWait ) < ACR_REST_CYCLE )
        {
            SendMessageToPC(oPC, "You must wait another " + IntToString(ACR_REST_CYCLE - nHoursToWait) + " hours to rest."); 
            nReturn = ACR_REST_TYPE_NOTTIRED;
        }
    }

    return nReturn;
}

int _playerHasBedroll(object oPC)
{
    // check for a bedroll in inventory
    return (GetItemPossessedBy(oPC, ACR_REST_BEDROLL_TAG) != OBJECT_INVALID) ? TRUE : FALSE;
}

int _playerHasTent(object oPC)
{
    // check for a tent in inventory
    return (GetItemPossessedBy(oPC, ACR_REST_TENT_TAG) != OBJECT_INVALID) ? TRUE : FALSE;
}

void _playerRestoreSpells(object oCaster, string sClasses, int nHitPoints)
{
    // bank these so ability damage won't be healed by the spell restoration
    SetLocalInt(oCaster, ACR_REST_STRENGTH, GetAbilityScore(oCaster, ABILITY_STRENGTH));
    SetLocalInt(oCaster, ACR_REST_DEXTERITY, GetAbilityScore(oCaster, ABILITY_DEXTERITY));
    SetLocalInt(oCaster, ACR_REST_CONSTITUTION, GetAbilityScore(oCaster, ABILITY_CONSTITUTION));
    SetLocalInt(oCaster, ACR_REST_INTELLIGENCE, GetAbilityScore(oCaster, ABILITY_INTELLIGENCE));
    SetLocalInt(oCaster, ACR_REST_WISDOM, GetAbilityScore(oCaster, ABILITY_WISDOM));
    SetLocalInt(oCaster, ACR_REST_CHARISMA, GetAbilityScore(oCaster, ABILITY_CHARISMA));

    // force rest on the caster
    ForceRest(oCaster);

    // remove the healing benefits
    _unhealFromRest(oCaster, nHitPoints);
	
    // remove all logged spell uses
    ACR_RemoveSpellUses(oCaster, sClasses);

    // clear away any improperly restored spells (that retain spelltrack entries)
    ACR_RestoreSpellUses(oCaster);
	
    // restart the spell check timer - only needed for divine and wizard spells.  Each will be handled
    //  by a separate event, so either/or will work
    string sTest = GetStringLeft(sClasses, 2);
    if (sTest == IntToString(CLASS_TYPE_WIZARD)) 
    {
        ACR_SetPersistentInt(oCaster, ACR_REST_STUDY_TIMER, ACR_GetTimeStampInHours());
        SendMessageToPC(oCaster, "Wizard spells restored.");
    } 
    else if (sTest == IntToString(CLASS_TYPE_CLERIC)+"," ||
             sTest == IntToString(CLASS_TYPE_CLERIC) ||
             sTest == IntToString(CLASS_TYPE_PALADIN) ||
             sTest == IntToString(CLASS_TYPE_RANGER)) 
    {
        ACR_SetPersistentInt(oCaster, ACR_REST_PRAYER_TIMER, ACR_GetTimeStampInHours());
        SendMessageToPC(oCaster, "Divine spells restored.");	
    }
	
    // clean up cached variables
    _garbageCollection(oCaster);
	
    // memorized spells
    FloatingTextStringOnCreature("You have successfully memorized your spells for the day.", oCaster, FALSE);
}

int _getSufferArmorFatigue( object oPC ) {
    int maxRestArmor = ARMOR_RANK_LIGHT;
    if ( GetHasFeat( FEAT_ENDURANCE, oPC ) ) maxRestArmor = ARMOR_RANK_MEDIUM;
    return ( GetArmorRank( GetItemInSlot( INVENTORY_SLOT_CHEST, oPC ) ) > maxRestArmor );
}

void _playerRestStart(object oPC)
{
    // store the player's current ability scores prior to resting so we know the excess healing to remove
    SetLocalInt(oPC, ACR_REST_STRENGTH, GetAbilityScore(oPC, ABILITY_STRENGTH));
    SetLocalInt(oPC, ACR_REST_DEXTERITY, GetAbilityScore(oPC, ABILITY_DEXTERITY));
    SetLocalInt(oPC, ACR_REST_CONSTITUTION, GetAbilityScore(oPC, ABILITY_CONSTITUTION));
    SetLocalInt(oPC, ACR_REST_INTELLIGENCE, GetAbilityScore(oPC, ABILITY_INTELLIGENCE));
    SetLocalInt(oPC, ACR_REST_WISDOM, GetAbilityScore(oPC, ABILITY_WISDOM));
    SetLocalInt(oPC, ACR_REST_CHARISMA, GetAbilityScore(oPC, ABILITY_CHARISMA));

    // sleep
    _applySleepEffects(oPC);
    
    // Warn the player if he's resting in armor.
    if ( _getSufferArmorFatigue( oPC ) ) {
        FloatingTextStringOnCreature( "Warning: You are resting in significantly heavy armor, and will be fatigued.", oPC, FALSE );
    }
    

    // cancel full rest if this is a nap when the time is up
    if (GetLocalInt(oPC, ACR_REST_FLAGS) & ACR_REST_FLAG_NAPPING) { DelayCommand(ACR_REST_NAP_DURATION, AssignCommand(oPC, ClearAllActions())); }
}

void _playerRestFinish(object oPC)
{
    // Rest failed for lack of tiredness, do nothing
    if (GetLocalInt(oPC, ACR_REST_NOT_TIRED)) { DeleteLocalInt(oPC, ACR_REST_NOT_TIRED); return; }
	
    // bards/sorcerers restore spell uses automatically - DO THIS BEFORE RESTORING SPELL USES!
	if (ACR_HasCasterClass(oPC, "INNATE"))
	{
		// remove innate spell uses
		ACR_RemoveSpellUses(oPC, IntToString(CLASS_TYPE_SORCERER) + "," + IntToString(CLASS_TYPE_BARD) + "," + IntToString(CLASS_TYPE_FAVORED_SOUL) + "," + IntToString(CLASS_TYPE_SPIRIT_SHAMAN));
	}

    // wizards/druids/clerics/rangers/paladins do not restore spell uses automatically
    if (ACR_HasCasterClass(oPC, "DIVINE") || ACR_HasCasterClass(oPC, "ARCANE"))
    {
        // restore spell uses to prerest levels - pray/study restores full spells
        ACR_RestoreSpellUses(oPC);
    }

    // update the last rest time stamps - this should come after the spell restoration check
    ACR_SetPersistentInt(oPC, ACR_REST_TIMER, ACR_GetTimeStampInHours());
    
    // remove the extraneous healing received by the player
    _healFromRest(oPC, GetLocalInt(oPC, ACR_REST_HP));

	// Remove any residual subdual damage
	ACR_NLD_HealAll(oPC);
	
    // check the odds of contracting a disease at this rest zone
    if (d100() <= GetLocalInt(oPC, ACR_REST_DISEASE_CHANCE))
    {
        // compute the disease ID and DC for the rest zone
        float fDisease = GetLocalFloat(oPC, ACR_REST_DISEASE);
        int nDisease = FloatToInt(fDisease), nDiseaseDC = FloatToInt((fDisease - nDisease) * 100);

        // check if the player has contracted the disease
        if ((nDisease >= 0) && (!FortitudeSave(oPC, nDiseaseDC, SAVING_THROW_TYPE_DISEASE)))
        {
            // apply the disease to the player
            effect eDisease = EffectDisease(nDisease);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oPC);
        }
    }
    
    // Restart combat modes.
    DelayCommand( 0.5f, ExecuteScript( "acr_restartcombatmode", oPC ) );

    // remove temporary data
    _garbageCollection(oPC);

    // save the character
    ACR_PCSave(oPC);
}

void _playerRestCancel(object oPC)
{
    // remove any healing received by the player - the engine heals a player incrementally over time
     _unhealFromRest(oPC, GetLocalInt(oPC, ACR_REST_HP));

    // determine if a nap was successfully completed
    if (GetLocalInt(oPC, ACR_REST_FLAGS) & ACR_REST_FLAG_NAPPING)
    {
        // detect nap timer roll over
        int nEndTime = GetTimeSecond(), nStartTime = GetLocalInt(oPC, ACR_REST_NAP_TIMER);
        if (nStartTime >= nEndTime) { nEndTime += 60; }

        // check if the nap was completed
        if (nEndTime - nStartTime >= FloatToInt(ACR_REST_NAP_DURATION))
        {
            // manage the healing received from the nap
            _healFromRest(oPC, GetLocalInt(oPC, ACR_REST_HP));

            // update the last rest time stamps
            ACR_SetPersistentInt(oPC, ACR_REST_TIMER, ACR_GetTimeStampInHours());
        }

        // clear the nap flag
        SetLocalInt(oPC, ACR_REST_FLAGS, GetLocalInt(oPC, ACR_REST_FLAGS) & ~(ACR_REST_FLAG_NAPPING));

        // clear the timer
        DeleteLocalInt(oPC, ACR_REST_NAP_TIMER);
    }

    // remove temporary data
    _garbageCollection(oPC);

    // wake-up
    _removeSleepEffects(oPC);
}

void _applySleepEffects(object oPC)
{
    int nDodge = 0, nTumble = GetSkillRank(SKILL_TUMBLE, oPC);

    // determine the dodge bonus to deduct
    if (nTumble >= 5) { nDodge = (nTumble > 20) ? 4 : nTumble/5; }

    // force all effects to be extraordinary to avoid the possibility of being
    // abused or exploited with spells - these effects should be script removed

    // determine the duration of the sleep effects
    float fDuration = (GetLocalInt(oPC, ACR_REST_FLAGS) & ACR_REST_FLAG_NAPPING) ? ACR_REST_NAP_DURATION : ACR_REST_DURATION;

    // create the audio and visual effects
    effect eVis = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_SLEEP));
    int nRace = GetRacialType(oPC);
    if(nRace != RACIAL_TYPE_ELF && nRace != RACIAL_TYPE_HALFELF)
        eVis = EffectLinkEffects(ExtraordinaryEffect(EffectBlindness()), eVis);
    

    // create the effective AB bonus effect for attacking players
    // +1 to offset the NWN lower stat boundary of 3 - sleeping results it total dexterity loss
    effect eBonusAB = ExtraordinaryEffect(EffectACDecrease(4 + 1));

    // create the helpless effect - lose all dexterity
    effect eHelpless1 = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, GetAbilityScore(oPC, ABILITY_DEXTERITY)));

    // create the helpless effect - lose all dodge bonus to AC
    effect eHelpless2 = ExtraordinaryEffect(EffectACDecrease(nDodge));

    // link the sleep effects so they are applied and removed simultaneously
    effect eLink = EffectLinkEffects(eHelpless2, EffectLinkEffects(eHelpless1, EffectLinkEffects(eBonusAB, eVis)));

    // apply the linked effects to the player resting
    ApplyEffectFromSource(ACR_EFFECT_SOURCE_RESTING, DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration);

    // stop the rest button from flashing
    SetPanelButtonFlash(oPC, PANEL_BUTTON_REST, 0);
}

void _removeSleepEffects(object oPC)
{
    RemoveAllEffectsFromSource(oPC, ACR_EFFECT_SOURCE_RESTING);
}

object _getPCFamiliar(object oPC)
{
    // get the player's familiar
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);

    // get the player's animal companion, if no familiar is present
    if(!GetIsObjectValid(oFamiliar)) { oFamiliar = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC); }

    return oFamiliar;
}

void _healFromRest(object oCreature, int nOriginalHitPoints)
{
    int nDelta     = 0;
    int nHitDice   = GetHitDice(oCreature);
    int nCurrentHP = GetCurrentHitPoints(oCreature);

    // calculate bonus HP from herbs/medicines
    int nHerbsHP = ACR_GetPersistentInt(oCreature, ACR_REST_HEAL_BONUS);

    // calculate bonus HP from resting in certain areas
    int nBonusHP = _getAreaRestBonus(oCreature);

    // calculate bonus HD from resting in a specially marked place
    int nBonusHD = _getCustomRestBonus(oCreature);

    // calculate the maximum hit points and ability damage recoverable in this rest period
    int nMaxHitPoints = nOriginalHitPoints + nHitDice + nHerbsHP + nBonusHP + nBonusHD;
    int nMaxAbility   = 1;

    // double the recovery rate if long term care has been successfully applied
    if (ACR_GetPersistentInt(oCreature, ACR_REST_FLAGS) & ACR_REST_FLAG_LTM_CARE)
    {
        nMaxAbility   *= 2;
        nMaxHitPoints += nHitDice; // do not double heal bonuses
    }
	
	// Modify damage and ability damage recoverable for offcamera rest/login case
	int nDaysRest = GetLocalInt(oCreature, ACR_REST_OFFCAMERA_DAYS);
	if (nDaysRest >= 1)
	{
	    nMaxHitPoints = nMaxHitPoints + (nDaysRest * (nHitDice + nBonusHP + nBonusHD));
		nMaxAbility *= nDaysRest;
		
		// Since the rest itself isn't actually happening by the engine, need to do it manually here.
		ForceRest(oCreature);
		SendMessageToPC(oCreature, "Restoring spells and ability uses.");
	}

    // check if the player is just napping
    if (GetLocalInt(oCreature, ACR_REST_FLAGS) & ACR_REST_FLAG_NAPPING)
    {
        // limit healing from napping to a proportional amount (10 sec/120 sec)
        int nHeal = FloatToInt(((nMaxHitPoints - nOriginalHitPoints) * ACR_REST_NAP_DURATION)/ACR_REST_DURATION);

        // heal the player
        effect eHeal = EffectHeal(nHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCreature);
    }
    // if it's not just a nap, move to ability scores.
    else 
    {
		//SendMessageToPC(oCreature, "HealFromRest, checking attributes for healing, max repair is "+IntToString(nMaxAbility));
        // control ability damage healing - check all ability scores for FULL REST only
		//SendMessageToPC(oCreature, "Cached STR is "+IntToString(GetLocalInt(oCreature, ACR_REST_STRENGTH)));
        if (GetAbilityScore(oCreature, ABILITY_STRENGTH) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_STRENGTH))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_STRENGTH) - GetLocalInt(oCreature, ACR_REST_STRENGTH);
 			//SendMessageToPC(oCreature, "Applying limter for delta: "+IntToString(nDelta));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, nDelta - nMaxAbility), oCreature);
        }
        if (GetAbilityScore(oCreature, ABILITY_DEXTERITY) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_DEXTERITY))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_DEXTERITY) - GetLocalInt(oCreature, ACR_REST_DEXTERITY);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_DEXTERITY, nDelta - nMaxAbility), oCreature);
        }
        if (GetAbilityScore(oCreature, ABILITY_CONSTITUTION) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_CONSTITUTION))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_CONSTITUTION) - GetLocalInt(oCreature, ACR_REST_CONSTITUTION);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, nDelta - nMaxAbility), oCreature);
        }
        if (GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_INTELLIGENCE))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) - GetLocalInt(oCreature, ACR_REST_INTELLIGENCE);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_INTELLIGENCE, nDelta - nMaxAbility), oCreature);
        }
        if (GetAbilityScore(oCreature, ABILITY_WISDOM) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_WISDOM))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_WISDOM) - GetLocalInt(oCreature, ACR_REST_WISDOM);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_WISDOM, nDelta - nMaxAbility), oCreature);
        }
        if (GetAbilityScore(oCreature, ABILITY_CHARISMA) - nMaxAbility > GetLocalInt(oCreature, ACR_REST_CHARISMA))
        {
            // limit healing of ability damage
            nDelta = GetAbilityScore(oCreature, ABILITY_CHARISMA) - GetLocalInt(oCreature, ACR_REST_CHARISMA);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CHARISMA, nDelta - nMaxAbility), oCreature);
        }
    }

    // check if the current hit points exceed the maximum allowable	
    if (nCurrentHP > nMaxHitPoints)
    {
        // strip off the excess hit points
        effect eDamage = EffectDamage(nCurrentHP - nMaxHitPoints, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreature);
	}

    // remove the persistent fatigued status - longterm offcamera rest should always remove the persistent fatigued status
    ACR_SetIsFatigued(oCreature, 0);
    ACR_SetIsExhausted(oCreature, 0);

    // check for fatigue - sleeping in armor (if this isn't a longterm offcamera rest)
    if ( nDaysRest < 1 && _getSufferArmorFatigue( oCreature ) )
    {
        // flag the fatigued status for persistence
        ACR_SetIsFatigued(oCreature, 1);
        FloatingTextStringOnCreature(ACR_REST_MSG_FATIGUED, oCreature, FALSE);
    }

    // reset long term care and herbal/medicinal healing bonuses
    ACR_SetPersistentInt(oCreature, ACR_REST_FLAGS, ACR_GetPersistentInt(oCreature, ACR_REST_FLAGS) & ~(ACR_REST_FLAG_LTM_CARE));
    ACR_SetPersistentInt(oCreature, ACR_REST_HEAL_BONUS, 0);
}

void _unhealFromRest(object oCreature, int nOriginalHitPoints)
{
    int nCurrentHitPoints = GetCurrentHitPoints(oCreature);

    // remove the HP recovered
    effect eDamage = EffectDamage(nCurrentHitPoints - nOriginalHitPoints, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCreature);

    int nStatChange = 0;
   
    // remove any ability damage healing - ForceRest() may have applied.
    if (GetAbilityScore(oCreature, ABILITY_STRENGTH) > GetLocalInt(oCreature, ACR_REST_STRENGTH))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_STRENGTH) - GetLocalInt(oCreature, ACR_REST_STRENGTH);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_STRENGTH, nStatChange), oCreature);
    }
    if (GetAbilityScore(oCreature, ABILITY_DEXTERITY) > GetLocalInt(oCreature, ACR_REST_DEXTERITY))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_DEXTERITY) - GetLocalInt(oCreature, ACR_REST_DEXTERITY);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_DEXTERITY, nStatChange), oCreature);
    }
    if (GetAbilityScore(oCreature, ABILITY_CONSTITUTION) > GetLocalInt(oCreature, ACR_REST_CONSTITUTION))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_CONSTITUTION) - GetLocalInt(oCreature, ACR_REST_CONSTITUTION);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, nStatChange), oCreature);
    }
    if (GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) > GetLocalInt(oCreature, ACR_REST_INTELLIGENCE))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) - GetLocalInt(oCreature, ACR_REST_INTELLIGENCE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_INTELLIGENCE, nStatChange), oCreature);
    }
    if (GetAbilityScore(oCreature, ABILITY_WISDOM) > GetLocalInt(oCreature, ACR_REST_WISDOM))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_WISDOM) - GetLocalInt(oCreature, ACR_REST_WISDOM);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_WISDOM, nStatChange), oCreature);
    }
    if (GetAbilityScore(oCreature, ABILITY_CHARISMA) > GetLocalInt(oCreature, ACR_REST_CHARISMA))
    {
        nStatChange = GetAbilityScore(oCreature, ABILITY_CHARISMA) - GetLocalInt(oCreature, ACR_REST_CHARISMA);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CHARISMA, nStatChange), oCreature);
    }
}

int _getAreaRestBonus(object oCreature)
{
    int nRestBonus = 0;

    // NOT YET IMPLEMENTED - TBD
    return nRestBonus;

    // compute the rest bonus
    switch (GetLocalInt(oCreature, ACR_REST_ZONE))
    {
        case ACR_REST_ZONE_INTERIOR:
            // all classes get the full rest bonus when sleeping indoors
            nRestBonus = ACR_REST_MIN_BONUS + GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);
            break;

        case ACR_REST_ZONE_EXTERIOR:
            // determine if this creature has a wilderness class
            if (GetLevelByClass(CLASS_TYPE_DRUID, oCreature) ||
                GetLevelByClass(CLASS_TYPE_RANGER, oCreature) ||
                GetLevelByClass(CLASS_TYPE_BARBARIAN, oCreature))
            {
                // grant the full rest bonus - they can sleep equally well indoors or out
                nRestBonus = ACR_REST_MIN_BONUS + GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);
            }
            // otherwise the heal bonus is based on the presence of a campire, bedroll, or tent
            else
            {
                // get the tent/bedroll object references - stored when the object is used/activated
                object oTent     = GetLocalObject(oCreature, ACR_REST_TENT);
                object oBedroll  = GetLocalObject(oCreature, ACR_REST_BEDROLL);
                object oCampfire = GetNearestObjectByTag(ACR_REST_CAMPFIRE_TAG, oCreature);

                // get the creatures constitution modifier
                int nConModifier = GetAbilityModifier(ABILITY_CONSTITUTION, oCreature);

                // ignore negative modifiers for determining heal bonus
                if (nConModifier < 0) { nConModifier = 0; }

                // players with tents get the full heal bonus
                if (GetIsObjectValid(oTent) && GetDistanceBetween(oCreature, oTent) <= 15.0)
                {
                    nRestBonus = ACR_REST_MIN_BONUS + (nConModifier * 2) / 3;
                }
                // players with bedrolls get half their constitution modifier as a bonus
                else if (GetIsObjectValid(oBedroll) && GetDistanceBetween(oCreature, oBedroll) <= 15.0)
                {
                    nRestBonus = ACR_REST_MIN_BONUS + (nConModifier * 1) / 3;
                }
                // players within 15 ft of a campfire to get the minimum heal bonus
                else if (GetIsObjectValid(oCampfire) && GetDistanceBetween(oCreature, oCampfire) <= 15.0)
                {
                    nRestBonus = ACR_REST_MIN_BONUS;
                }
            }
            break;

        default:
            // no rest bonus
            break;
    }

    // return the rest bonus
    return (nRestBonus);
}

int _getCustomRestBonus(object oCreature)
{
    // grab the rest bonus specified for the Rest Zone
    return ((GetLocalInt(oCreature, ACR_REST_BONUS) * GetHitDice(oCreature)) / 100);
}


void _garbageCollection(object oPC)
{
    // delete all temp data to conserve memory
    DeleteLocalInt(oPC, "ACR_REST_HP");
    DeleteLocalInt(oPC, "ACR_REST_STRENGTH");
    DeleteLocalInt(oPC, "ACR_REST_DEXTERITY");
    DeleteLocalInt(oPC, "ACR_REST_CONSTITUTION");
    DeleteLocalInt(oPC, "ACR_REST_INTELLIGENCE");
    DeleteLocalInt(oPC, "ACR_REST_WISDOM");
    DeleteLocalInt(oPC, "ACR_REST_CHARISMA");
}

void _ProcessOffCameraRest(object oPC, int nDuration)
{
    // Inform player what is going on:
    SendMessageToPC(oPC, "Adjusting status for " + IntToString(nDuration) + " offline game-days.");
	
    // Cache the current attributes so they can be accounted for in _unHealFromRest()
    SetLocalInt(oPC, ACR_REST_STRENGTH, GetAbilityScore(oPC, ABILITY_STRENGTH));
    SetLocalInt(oPC, ACR_REST_DEXTERITY, GetAbilityScore(oPC, ABILITY_DEXTERITY));
    SetLocalInt(oPC, ACR_REST_CONSTITUTION, GetAbilityScore(oPC, ABILITY_CONSTITUTION));
    SetLocalInt(oPC, ACR_REST_INTELLIGENCE, GetAbilityScore(oPC, ABILITY_INTELLIGENCE));
    SetLocalInt(oPC, ACR_REST_WISDOM, GetAbilityScore(oPC, ABILITY_WISDOM));
    SetLocalInt(oPC, ACR_REST_CHARISMA, GetAbilityScore(oPC, ABILITY_CHARISMA));
    SetLocalInt(oPC, ACR_REST_HP, GetCurrentHitPoints(oPC));
		
    // amended this to take into account nDuration- passed via local INT on the PC.
    SetLocalInt(oPC, ACR_REST_OFFCAMERA_DAYS, nDuration);
    _healFromRest(oPC, GetLocalInt(oPC, ACR_REST_HP));
    DeleteLocalInt(oPC, ACR_REST_OFFCAMERA_DAYS);
	
    int nLastStudied = ACR_GetPersistentInt(oPC, ACR_REST_STUDY_TIMER);
    int nLastPrayed = ACR_GetPersistentInt(oPC, ACR_REST_PRAYER_TIMER);
    int nLastRested = ACR_GetTimeStampInHours();
    ACR_SetPersistentInt(oPC, ACR_REST_TIMER, ACR_GetTimeStampInHours());

    if(GetLevelByClass(CLASS_TYPE_CLERIC,  oPC) ||
       GetLevelByClass(CLASS_TYPE_DRUID,   oPC) ||
       GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 3 ||
       GetLevelByClass(CLASS_TYPE_RANGER,  oPC) > 3 ||
       GetLevelByClass(CLASS_TYPE_WIZARD,  oPC))
    {
        SetLocalInt(oPC, ACR_FREE_SPELL_PREP, 1);
        DisplayGuiScreen(oPC, "acr_resting", FALSE, "acr_resting.xml");
        DisplayGuiScreen(oPC, "SCREEN_SPELLS_MEMORIZED", FALSE, "spells_memorized.xml");
        DisplayGuiScreen(oPC, "SCREEN_SPELLS_KNOWN", FALSE, "spells_known.xml");
    }
    // check to see if the PC has studied or prayed since last rest.
    if ((nLastStudied >= nLastRested) || (nLastPrayed >= nLastRested)) {
        // treat a rest as having happened in between logout and login, so studying and praying become available.
        ACR_SetPersistentInt(oPC, ACR_REST_TIMER, (ACR_GetTimeStampInHours() - ACR_REST_CYCLE));
    }
	
    // clear any spell uses stored in the DB
    ACR_RemoveSpellUses(oPC);
	
    // remove temporary data
    _garbageCollection(oPC);

    // save the character
    ACR_PCSave(oPC);
}

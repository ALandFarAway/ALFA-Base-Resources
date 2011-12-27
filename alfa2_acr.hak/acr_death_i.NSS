////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_death_i
//    $Revision:: 592        $ current version of the file
//        $Date:: 2009-12-26#$ date the file was created or modified
//       Author : Cipher & AcadiusLost
//
//    Var Prefix: ACR_DTH
//  Dependencies: Corpse Placeable & Item, Morgue Cooler, Morgue Waypoint,
//                Fugue/Morgue
//
//  Description
//  Death system implementation based on ALFA requirements:
//  http://www.alandfaraway.org/phpBB2/viewtopic.php?t=27360
//
//  Revision History
//  2006/10/05  Cipher  Inception
//  2007/04/28  AcadiusLost  Commented out all uses of SetName() for 1.05, added SetDescription() calls
//                 as well as new local string ACR_DTH_CORPSE_NAME to store the corpse's name.
//  2007/05/02  AcadiusLost  Added _RetagCorpse() function, handling for destroying placeable corpses
//                 once the body has been looted (as well as what happens to the unlooted inventory)
//                 Also handled body identification OnCorpseAcquire and OnCorpseUnAcquire, changed VFX
//  2007/05/01  Cipher Added bleeding effects and morgue transition delay.
//  2007/06/10  AcadiusLost  Fixed GetPlayerFromCorpse(), adjusted damage effect for bleeding
//                 Altered ACR_OnPlayerDying() to help dissuade AI from continuing to attack
//                 Added a RemoveEffects() call to _applyDeathEffects() (from nw_i0_plot) to
//                 help clear dying effects (if we get any that work).
//  2007/06/11  Cipher  Retrofit persistence calls with NWNx4 functions, remove CreateItem workaround
//  2007/07/15  AcadiusLost  Added AoE handling for SetIsTemporaryNeutral() in dying code.  Set 
//                 _giveInventoryItems() to correctly handle corpses in inventory on death,
//                  and the OOC first aid item.
//  2007/07/18  AcadiusLost: Fixed a bug with RestoreCorpsesOnModuleLoad(), added _dropBodyFromDyingPC()
//                 also included acr_tools_i and acr_i, changed corpse and body tag conventions, gave 
//                 PC body placeables their own blueprint.  Moved stored DTH_HP decrement to ACR_StabilizePlayer()
//                 Also moved the deletion of DTH_LOCATION to OnCorpseDisturbed
//  2007/07/21  AcadiusLost: Fixed conditional for nSpellID in CorpseOnResurrect(), remove ghost VFX on rez
//                 and on DeathClientEnter when logging in from an offline rez.  Fixed _applyDeathPenalty() to 
//                 be correct for 1st level PCs who die, #included acr_xp_i
//  2007/07/22  Cipher  Fixed corpse loading on startup, misc code clean up and optimization
//  2007/07/27  Cipher  Replaced ACR_PLAYER_FLAGS with a bit field in the characters table
//						Used database name and character ID for tracking persistence and status via corpses
//  2007/07/29  Cipher  Replaced _dropBodyFromDyingPC() with special handling inside ACR_CorpseUnAcquire()
//						Dropped _BODY suffix from body items as that's no longer necessary - removed _CheckBodyIsDead()
//                      Fixed corpse/player item exchange on login when player has been resurrected, changed ghost effect
//  2007/08/11  Cipher  Used ECL in place of HD in all XP calcs to account for LA races.
//  2007/08/17  AcadiusLost: Fixed _applyDeathPenalty() to account for 1st level LA PCs who are rez'd.
//                  also altered ACR_CorpseOnResurrect: shifted death VFX removal method, and added DelayCommand 
//                  to destroy the empty corpse after resurrection.
//  2007/08/21  AcadiusLost: Edited ACR_CorpseOnUnAquire() to mark corpse placeables as mutilated when appropriate.
//  2007/08/26  AcadiusLost: Altered ACR_CorpseOnUnacquire() and ACR_RestoreCorpsesOnModuleLoad() to preload inventory.
//  2007/09/02  AcadiusLost: Added rez logging and XP validation.  Also added failsafe for logging in bleeding but undamaged.
//  2007/09/14  AcadiusLost: removed logging in bleeding stopgap.
//  2007/09/17  AcadiusLost: Removed booting for decayed PC login, added warning to player and all DMs online.
// 					also changed ACR_DTH_CORPSE_DECAY to 30 game-days to avoid premature dead PC decay.
//  2007/09/18  AcadiusLost: removed return call from DeathOnPCLoaded() that was allowing decayed PCs to exit the morgue
//                  also added logging for looting one's own corpse.
//  2008/03/19  AcadiusLost: fixes to bleeding check rates, cleaned up persistency calls, moved corpse preloading. Added death 
//                  floor, fixed GetCorpseFromPC(), decay handling, migrated death logging to the function here.
//  2008/03/23  AcadiusLost: cached killer with a Localstring, for logging and attention diversion while bleeding.
//  2008/04/12  AcadiusLost: special handling to cancel DMFI follow on death, also exempt rez for selflooting.
//  2008/04/17  AcadiusLost: revisions to fix exception to selflooting logs when rez'd
//  2008/05/25  AcadiusLost: fixed the selflooting exception during resurrection (wrong version was committed before)
//  2008/08/30  AcadiusLost: Shifted RandomFloat over to ACR_RandomFloat, added blood VFX
//  2008/09/19  AcadiusLost: changed to a CopyItem instead of GiveItem for death system.
//  2008/09/21  AcadiusLost: Added inventory transfer exceptions for OOC items.
//					Added handling for removal of Poison, Disease, and Ability Damage OnDeath().
//  2008/11/10  AcadiusLost: Clarified feedback on bleeding-out, text cleaning for attention diversion.
//  2008/11/12  AcadiusLost: Added consciousness for successful nat. healing roll.
//  2008/12/08  AcadiusLost: Untangled an imbricated query in RestoreCorpsesOnModuleLoad(). 
//  2008/12/10  AcadiusLost: delayed renaming of decayed corpses until after the location deletion.
//  2009/01/11  AcadiusLost: Modified RestoreCorpsesOnModuleLoad() to account for multiple servers.
//  2009/03/01  AcadiusLost: Fixes for SoZ/1.22.1587 patch, death item logging.
//  2009/12/26  AcadiusLost: Fixes to XP penalty calculation OnResurrect(), corpse decay to 500 days
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_i"
#include "acr_xp_i"
#include "acr_pps_i"
#include "acr_it_persist_i"
#include "acr_resting_i"
#include "acr_tools_i"
#include "acr_1984_i"
#include "acr_db_persist_i"
#include "acr_mobloot_i"
//#include "nw_i0_plot"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// TEMPORARY - THIS SHOULD EXIST FOR NWN2 OR BE DEFINED BY ALFA
const int SPELL_TRUE_RESURRECTION = 1123;

//! Number of days corpses will last
//! NOTE: this is in game-days.  At 7 min/hour, 30 ingame days is 3.5 RL days.
//!  Temporarily shifted to an arbitrarily high figure to avoid PC corpse problems from clock skip.
const int ACR_DTH_CORPSE_DECAY = 500;

//! The percent chance of stablizing, regaining consciousness, and healing naturally
const int ACR_DTH_PERCENT_CHANCE = 10;

//! ResRef of invisible undertakers (used for randomized weapon drops)
const string ACR_DTH_UNDERTAKER_RESREF = "abr_cr_sp_undertaker";

//! Tag of morgue area and waypoint
const string ACR_DTH_MORGUE_AR_TAG = "abr_ar_morgue";
const string ACR_DTH_MORGUE_WP_TAG = "abr_wp_morgue";

//! Local variable for morgue waypoint location
const string ACR_DTH_WAYPOINT = "ACR_DTH_WAYPOINT";

//! Local variable for player location of death
const string ACR_DTH_LOCATION = "ACR_DTH_LOCATION";

//! Local variable for player time of death
const string ACR_DTH_TIMESTAMP = "ACR_DTH_TIMESTAMP";

//! Local variable for player instant of death
const string ACR_DTH_INSTANT   = "ACR_DTH_INSTANT";

//! Local variable for player hitpoint tracker
const string ACR_DTH_HITPOINTS = "ACR_DTH_HITPOINTS";

//! Local variable for number of rounds player has stabilized
const string ACR_DTH_NUM_ROUNDS = "ACR_DTH_NUM_ROUNDS";

//! Debug ID string for debug messaging
const string ACR_DTH_DEBUG_ID = "acr_dth_i";

//! Float constants for bleeding system protections (diverts mob attention from dying PCs)
//!  sets how long in RL seconds mobs are forced to treat downed PC as neutral
const float _ACR_DTH_HOSTILE_DELAY = 30.0f;

//!  sets how wide an area effect the hostility removal stretches.
const float _ACR_DTH_RADIUS = 60.0f;

//!  sets the "floor" for single-hit into the negatives, all damage beyond is ignored.
const int _ACR_DTH_FLOOR = -6;

//!  Stores the last creature to have damaged a dying PC- usually will turn out to be the Killer.
const string _ACR_DTH_DAMAGER = "ACR_DTH_LAST_DAMAGER";

//! Constants relating to Recall Spirit.
const string _ACR_DTH_RECALLABLE = "ACR_DTH_RECALLABLE_";
const float ACR_DTH_RECALL_SPIRIT_WINDOW = 12.0;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! The number of rounds in between consciousness checks
int ACR_DTH_UNCONSCIOUS_ROUNDS = FloatToInt(TurnsToSeconds(1)/RoundsToSeconds(1));

//! The number of rounds in between natural healing checks
//int ACR_DTH_NATHEALING_ROUNDS = FloatToInt(HoursToSeconds(ACR_REST_CYCLE)/RoundsToSeconds(1));
int ACR_DTH_NATHEALING_ROUNDS = FloatToInt(TurnsToSeconds(2)/RoundsToSeconds(1));

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// *** PUBLIC FUNCTIONS ***

//! This is the event handler for player death. This function ports players to
//! the morgue and transfers all their gear to persistent corpses.
//!  - oPC: Player that died
//!  - oKiller: Creature that killed the player
//!  - Returns: nothing
void ACR_PlayerOnDeath(object oPC, object oKiller);

//! This is the event handler for player dying. This function bleeds players
//! until they either die or stabilize.
//!  - oPC: Player that is dying
//!  - oAttacker: Creature that knocked the player unconscious
//!  - Returns: nothing
void ACR_PlayerOnDying(object oPC, object oAttacker);

//! This function handles mutilation attempts by players on corpses.
//!  - oCorpse: The corpse a player wants to mutilate
//!  - oMutilator: The player who is doing the mutilation
//!  - Returns: nothing
void ACR_CorpseOnMutilate(object oCorpse, object oMutilator);

//! This function handles resurrection attempts by players (or NPCs) on corpses.
//!  - oCaster: The creature that is attempting to resurrect the corpse
//!  - oCorpse: The corpse that's being targetted for resurrection
//!  - nSpellId: The id of the spell being cast on the corpse
//!  - Returns: nothing
void ACR_CorpseOnResurrect(object oCaster, object oCorpse, int nSpellId);

//! This is the event handler for disturbing a placeable corpse.
//! This function handles the removal of a corpse token from a corpse.
//!  - oBody: The object being removed
//!  - oTaker: The player that's taking the object
//!  - oGiver: The current owner of the object being removed
//!  - Returns: nothing
void ACR_CorpseOnDisturbed(object oBody, object oTaker, object oGiver);

//! This is the event handler for acquiring a corpse token.
//!  - oBody: The object being acquired
//!  - oAcquiredBy: The player that's obtaining the object
//!  - oAcquiredFrom: The current owner of the object being acquired
//!  - Returns: nothing
void ACR_CorpseOnAcquire(object oBody, object oAcquiredBy, object oAcquiredFrom);

//! This is the event handler for unacquiring a corpse token.
//!  - oBody: The object being unacquired
//!  - oLostBy: The player that's dropping the object
//!  - Returns: nothing
void ACR_CorpseOnUnacquire(object oBody, object oLostBy);

//! This is the event handler for placeable corpse heartbeats.
//!  - oCorpse: The object on which the heartbeat occured
//!  - Returns: nothing
void ACR_CorpseOnHeartBeat(object oCorpse);

//! This is the event handler for dead players reentering the game world.
//!  - oPC: The player entering the game world
//!  - Returns: nothing
void ACR_DeathOnClientEnter(object oPC);

//! This is the event handler for dead players instantiating in the game world.
//!  - oPC: The player spawned in the game world
//!  - Returns: nothing
void ACR_DeathOnPCLoaded(object oPC);

//! This is the event handler for module load. This function restores all corpses.
//!  - Returns: nothing
void ACR_RestoreCorpsesOnModuleLoad();

//! This function determines if the object is a placeable corpse.
//  - oObject: A placeable object to be tested.
//  - Returns: TRUE if a corpse, FALSE if not a corpse
int ACR_GetIsCorpse(object oObject);

//! This function determines if the object is a corpse token.
//  - oObject: An item object to be tested.
//  - Returns: TRUE if a corpse token, FALSE if not a corpse token
int ACR_GetIsCorpseToken(object oObject);

//! This function determines if the corpse inventory has been cleared.
//  - oCorpse: A placeable corpse object to be tested.
//  - Returns: TRUE if empty, FALSE if not empty
int ACR_GetIsCorpseEmptied(object oCorpse);

//! This function determines if the corpse decay timer has expired.
//  - oCorpse: The player or corpse object whose status to check
//  - Returns: TRUE if decayed, FALSE if not decayed
int ACR_GetHasCorpseDecayed(object oCorpse);

//! This function locates the player's corpse in the game world
//! This is an expense operation so it should only be used under limited circumstances
//  - oPC: Player who's corpse you want to find
//  - Returns: The player's corpse object
object ACR_GetCorpseFromPlayer(object oPC);

//! This function locates the player that owns the corpse in the game world
//  - oCorpse: The corpse object
//  - Returns: The player object
object ACR_GetPlayerFromCorpse(object oCorpse);

//! This function stabilizes a dying player so they stop bleeding to death
//  - oPC: the player to stabilize
//  - Returns: noting
void ACR_StabilizePlayer(object oPC);

//! This function returns TRUE if oCorpse can be recalled via Recall Spirit.
int ACR_CanCorpseBeRecalled(object oCorpse);

// *** PRIVATE FUNCTIONS ***

//! Applies the appropriate effects to the dead player
void _applyDeathEffects(object oDead);

//! Applies an XP and GP penalty to the player being resurrected
void _applyDeathPenalty(object oDead);

//! Action command - drop a dead player's gear (weapons/shields fall, all else in inventory)
void _dropEquippedItems(object oTarget);

//! Action command - transfer inventory to oTarget
//!  - oTarget: Object to receive inventory items
//!  - oSource: Object to give inventory items
//!  - Returns: Nothing
void _giveInventoryItems(object oTarget, object oSource = OBJECT_SELF);

//! Action command - wrapper function for saving inventories
void _saveInventoryItems(object oCorpse, string sAreaTag);

//! Handles the player's transition to the morgue, including inventory processing
void _playerOnDeath(object oPC, object oKiller);

//! Handles the stabilization checks (including consciousness and natural healing) when a player is dying
void _playerStabilizeCheck(object oPC, int bHealed=FALSE);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_PlayerOnDeath(object oPC, object oKiller)
{
    // ignore dead players - this prevents duplicating player corpses and tokens
    if (ACR_GetIsPlayerDead(oPC)) { return; }
	
	// If this is a one-hit straight to morgue, there will be no HP cached on the PC
	if (GetLocalInt(oPC, ACR_DTH_HITPOINTS) == 0) {
	    // cache the identity of the damager
		object oFoe = GetLastDamager(oPC);
		SetLocalObject(oPC, _ACR_DTH_DAMAGER, oFoe);
	    // rez, then damage to the floor
		effect eLimit = EffectDamage((1-_ACR_DTH_FLOOR), DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eLimit, oPC);
		SendMessageToPC(oPC, "Damage limiter, death blocked at "+IntToString(_ACR_DTH_FLOOR));
		AssignCommand(oFoe, ClearAllActions(TRUE));
	    object odMob = GetFirstObjectInShape(SHAPE_SPHERE, _ACR_DTH_RADIUS, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	    while (GetIsObjectValid(odMob)) {
            if (!GetIsPC(odMob) && GetIsEnemy(oPC, odMob)) {
			    //SendMessageToPC(oPC, "Diverting attention of "+ACR_CleanCreatureNameTextForPlayers(GetName(odMob)));
			    AssignCommand(odMob, ClearAllActions(TRUE));
				//SetIsTemporaryNeutral(odMob, oPC, FALSE, _ACR_DTH_HOSTILE_DELAY);
	        } else {
		    }
	        odMob = GetNextObjectInShape(SHAPE_SPHERE, _ACR_DTH_RADIUS, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
        }
		return;
	}
	// clear any DMFI follow commands, set local int marker for canceling others following the dying PC.
	object oTool = GetLocalObject(oPC, "DMFITool");
	SetLocalInt(oPC, "ACR_DTH_DEAD", TRUE);
	DeleteLocalObject(oTool, "DMFIFollow");
		
	// increment death counter
	ACR_SQLQuery("UPDATE characters SET Deaths=Deaths+1 WHERE ID=" + IntToString(ACR_GetCharacterID(oPC)));

    // clear the action queue, including combat state, so we can manage inventory txfrs
    AssignCommand(oPC, ClearAllActions(TRUE));

    ACR_CheckLootByMob(oPC);
	
	// best way to work out who the killer was, is to check the pointer set OnDying(), or in the instakill protection.
    oKiller = GetLocalObject(oPC, _ACR_DTH_DAMAGER);
	
    // log player death
    ACR_LogEvent(oPC, ACR_LOG_DEATH, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oPC)) + " killed by: " + ACR_SQLEncodeSpecialChars(GetName(oKiller)));

    // log the kill if the killer is a PC
    if (GetIsPC(oKiller)) { ACR_LogEvent(oKiller, ACR_LOG_KILL, "Character: " + ACR_SQLEncodeSpecialChars(GetName(oKiller)) + " killed player: " + ACR_SQLEncodeSpecialChars(GetName(oPC))); }

    // delay processing to add a little dramatics
    DelayCommand(3.0, FadeToBlack(oPC, FADE_SPEED_SLOWEST));
    DelayCommand(3.2, _playerOnDeath(oPC, oKiller));
	// clean up cached integers
	DeleteLocalInt(oPC, ACR_DTH_HITPOINTS);
}

void ACR_PlayerOnDying(object oPC, object oLastAttacker)
{
    // apply the dying animation - need to make it permanent so it sticks
    AssignCommand(oPC, ClearAllActions(TRUE));

	// Deactivate any action modes that might interfere
	SetActionMode(oPC, ACTION_MODE_PARRY, FALSE);
    SetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE, FALSE);
	SetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, FALSE);
	SetActionMode(oPC, ACTION_MODE_DEFENSIVE_CAST, FALSE);	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oPC);
	PlayCustomAnimation(oPC, "proneb", 1);
	//DelayCommand(0.1, SetCommandable(FALSE, oPC));
	int bPreHealed = FALSE;
    int nHP = GetCurrentHitPoints(oPC);

	// pickup where the player left off if they are already dying (relogin)
	// otherwise, process the transition to bleeding/dying
	if (! ACR_GetIsPlayerDying(oPC))
	{
	    // first off, cache the creature/PC who knocked the PC into negatives.
		object oAttacker = GetLastDamager(oPC);
		SetLocalObject(oPC, _ACR_DTH_DAMAGER, oAttacker);
	    // if they're starting their bleeding from less than the set level, adjust them up to it.
	    if (nHP < _ACR_DTH_FLOOR) {
	        // manage single-hit floor
		    effect eFloor = EffectHeal(_ACR_DTH_FLOOR - nHP);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eFloor, oPC);
		    SendMessageToPC(oPC, "Damage limiter, dying blocked at "+IntToString(_ACR_DTH_FLOOR));
	    }
	    // fade the screen to black
    	//FadeToBlack(oPC, FADE_SPEED_SLOWEST);

    	// flag the player as bleeding
    	ACR_SetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_DYING | ACR_PLAYER_FLAG_BLEEDING | ACR_PLAYER_FLAG_UNCONSCIOUS);

	    FloatingTextStringOnCreature("You fall to the ground unconscious. You are bleeding badly!", oPC, FALSE);
	    // Stopgap measure to force mobs' attention to be diverted from downed PCs while there are others in combat. 
	    //   This should probably be removed in favor of something more nuanced.
		AssignCommand(oAttacker, ClearAllActions(TRUE));
		SendMessageToPC(oPC, ACR_CleanCreatureNameTextForPlayers(GetName(oAttacker))+" loses interest.");
	    object oMob = GetFirstObjectInShape(SHAPE_SPHERE, _ACR_DTH_RADIUS, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	    //SendMessageToPC(oPC, "Starting with "+GetTag(oMob));
	    while (GetIsObjectValid(oMob)) {
            if (!GetIsPC(oMob) && GetIsEnemy(oPC, oMob)) {
			    //SendMessageToPC(oPC, "Diverting attention of "+GetTag(oMob));				
			    AssignCommand(oMob, ClearAllActions(TRUE));
				//AssignCommand(oMob, ActionWait(30.0));
    	        //SetIsTemporaryNeutral(oMob, oPC, FALSE);
		    }
	        oMob = GetNextObjectInShape(SHAPE_SPHERE, _ACR_DTH_RADIUS, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
        }
	} else if (!ACR_GetIsPlayerBleeding(oPC)) {
	    // PC has been tended, should continue recovery
		SendMessageToPC(oPC, "You are stable, and will continue to recover slowly.");
		bPreHealed = TRUE;
		DeleteLocalObject(oPC, _ACR_DTH_DAMAGER);
	}
    // record the player's hit point total
    SetLocalInt(oPC, ACR_DTH_HITPOINTS, GetCurrentHitPoints(oPC));
    
    // schedule the bleeding
    DelayCommand(RoundsToSeconds(1), _playerStabilizeCheck(oPC, bPreHealed));
}

void ACR_CorpseOnMutilate(object oCorpse, object oMutilator)
{
    // make sure a corpse has been targeted
    if (! ACR_GetIsCorpse(oCorpse)) { return; }

    if (ACR_GetHasCorpseDecayed(oCorpse))
    {
        // flag the player as decayed (corpse)
        ACR_SetPlayerStatusFlags(oCorpse, ACR_PLAYER_FLAG_DECAYED);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oCorpse, ACR_DTH_LOCATION);

        // notify the mutilator
        SendMessageToPC(oMutilator, "The corpse has already decayed.");

        // label the corpse appropriately
        SetFirstName(oCorpse, "Decayed Corpse");
        SetDescription(oCorpse, "This corpse has decayed.");
    }
    else
    {
        // flag the corpse as mutilated
        ACR_SetPlayerStatusFlags(oCorpse, ACR_PLAYER_FLAG_MUTILATED);

        // notify the mutilator
        SendMessageToPC(oMutilator, "The corpse has been mutilated.");

        // label the corpse appropriately
        SetDescription(oCorpse, "This corpse has been mutilated beyond recognition.");
    }
}

void ACR_CorpseOnResurrect(object oCaster, object oCorpse, int nSpellId)
{
    // make sure a ressurection spell has been cast
    if (nSpellId != SPELL_RAISE_DEAD && nSpellId != SPELL_RESURRECTION && nSpellId != SPELL_TRUE_RESURRECTION && nSpellId != SPELL_RECALL_SPIRIT) { return; }
	
	if(nSpellId == SPELL_RECALL_SPIRIT && !ACR_CanCorpseBeRecalled(oCorpse)) {
		SendMessageToPC(oCaster, "Recall spirit only works on bodies less than " + FloatToString(ACR_DTH_RECALL_SPIRIT_WINDOW, 2, 0) + " seconds old.");
		return;
	}

    // make sure a corpse has been targetted
    if (! ACR_GetIsCorpse(oCorpse)) { return; }

	ACR_LogEvent(oCaster, ACR_LOG_REZ, GetName(oCaster) + " has cast a rez spell with id " + IntToString(nSpellId) + " at player corpse " + GetName(oCorpse));

    object oPC; location lLocation = GetLocation(oCaster);

    // check if raise dead is being attempted on a mutilated corpse
    if (ACR_GetIsCorpseMutilated(oCorpse) && (nSpellId == SPELL_RAISE_DEAD))
    {
        // alert the player that's raising the corpse and exit
        SendMessageToPC(oCaster, "The corpse has been mutilated and is unaffected by your spell."); return;
    }

    // check if the corpse has decayed
    if (ACR_GetHasCorpseDecayed(oCorpse))
    {
        // alert the player that's resurrecting the corpse
        SendMessageToPC(oCaster, "The corpse has decayed and is beyond resurrection.");

        // flag the corpse as decayed - a corpse will no longer appear for this character
        ACR_SetPlayerStatusFlags(oCorpse, ACR_PLAYER_FLAG_DECAYED);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oCorpse, ACR_DTH_LOCATION);

        // label the corpse appropriately
        SetFirstName(oCorpse, "Decayed Corpse");
        SetDescription(oCorpse, "This corpse has decayed.");
    }
    // check if the player is logged in
    else if (GetIsObjectValid(oPC = ACR_GetPlayerFromCorpse(oCorpse)))
    {
        // hide the player's screen
        BlackScreen(oPC);

        // heal the player if this is a resurrection spell
        if (nSpellId == SPELL_RESURRECTION || nSpellId == SPELL_TRUE_RESURRECTION) { ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC) - 1), oPC); }
		
	if (nSpellId != SPELL_RECALL_SPIRIT) {
		SetHitPoints(oPC, 0, DAMAGE_TYPE_NEGATIVE);
		DelayCommand(1.0, ACR_StabilizePlayer(oPC));
	}

        // apply the death penalties only if the caster is not a DM
        if (nSpellId != SPELL_RECALL_SPIRIT && nSpellId != SPELL_TRUE_RESURRECTION && !(GetIsDM(oCaster) || GetIsDMPossessed(oCaster))) { _applyDeathPenalty(oPC); }

        // clear the death flags on the player - necessary to be freed from the morgue
        ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_DEAD | ACR_PLAYER_FLAG_MUTILATED);
        DeleteLocalInt(oPC, "ACR_DTH_DEAD");
		SetLocalInt(oPC, "ACR_DTH_REZ", TRUE);
		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oCorpse, ACR_DTH_LOCATION);
		
	    // remove death VFX
		effect eTest = GetFirstEffect(oPC);
		do {
		    if (GetEffectType(eTest) == EFFECT_TYPE_VISUALEFFECT) {
			    RemoveEffect(oPC, eTest);
			} 
			eTest = GetNextEffect(oPC);
		} while (GetIsEffectValid(eTest));
		
		// Pre-load the corpse with persistent inventory, in case they are rezed before
		//   they can be opened.
		ACR_PreLoadStorageObject(oCorpse);
		
        // give the player back any items remaining on the corpse
        // uses action commands, which will always execute after the script ends
        AssignCommand(oCorpse, _giveInventoryItems(oPC));

        // save the player and corpse inventories (destroys corpse on completion)
        AssignCommand(oPC, _saveInventoryItems(oCorpse, GetTag(GetAreaFromLocation(lLocation))));

        // return the player to their original location and save their new status
        // delay the jump to allow inventory items to transfer first (important for saving)
        AssignCommand(oPC, DelayCommand(0.3, JumpToLocation(lLocation)));
		
		// get rid of the empty placeable corpse as well
		DelayCommand(3.0, DestroyObject(oCorpse));
		
		DelayCommand(5.0, DeleteLocalInt(oPC, "ACR_DTH_REZ"));
    }
    // otherwise, resurrection will be applied on the player's next login
    else
    {
        // clear the dead flag - the player will be resurrected on next login
        ACR_UnsetPlayerStatusFlags(oCorpse, ACR_PLAYER_FLAG_DEAD | ACR_PLAYER_FLAG_MUTILATED);

         // record the location of resurrection
        ACR_SetPersistentLocation(oCorpse, ACR_DTH_LOCATION, lLocation);

        // destroy the corpse - it should NOT auto drop inventory items by default
        // make sure the persistent corpse blueprint is configured correctly - ACR_PSO_ONDEATH = 0
		// inventory items will be transferred from the corpse the next time the player logs in
        DestroyInventory(oCorpse); DestroyObject(oCorpse);
    }
}

void ACR_CorpseOnDisturbed(object oBody, object oTaker, object oGiver)
{
    // determine if the disturbance was to a corpse object or not
    if (ACR_GetIsCorpse(oGiver))
    {
	    // check to make sure this isn't a previous character of the same player, unless it's a rez
		if (GetLocalInt(oTaker, "ACR_DTH_REZ")) {
		    // no need to log the item in this case, nor warn about selflooting- it's a rez mechanism;
		} else if (GetPCPublicCDKey(oTaker) == GetTag(oGiver)) {
		    ACR_LogEvent(oTaker, ACR_LOG_LOOTSELF, ACR_SQLEncodeSpecialChars(GetPCPlayerName(oTaker))+" looted previous PC: "+ACR_SQLEncodeSpecialChars(GetName(oGiver))+" with PC: "+ACR_SQLEncodeSpecialChars(GetName(oTaker)));
			FloatingTextStringOnCreature("YOU HAVE LOOTED A CORPSE OF A PREVIOUS PC OF YOURS.  THIS IS FORBIDDEN.  CONTACT A DM IMMEDIATELY!", oTaker, TRUE, 30.0);
			SendMessageToAllDMs(GetName(oTaker)+" has just looted his/herself in area "+GetName(GetArea(OBJECT_SELF))+", previous PC(corpse) was named "+GetName(oGiver));
		}    
	    // check if the item disturbed is a corpse token
		//  otherwise, we just need to check for decay.
        if (! ACR_GetIsCorpseToken(oBody)) 
		{
		    // check if the corpse has decayed
           if (ACR_GetHasCorpseDecayed(oGiver))
           {
               // alert the player that's obtaining the corpse
               SendMessageToPC(oTaker, "The corpse has decayed.");
               // flag the corpse as decayed so the player can no longer be resurrected
               ACR_SetPlayerStatusFlags(oGiver, ACR_PLAYER_FLAG_DECAYED);
               // label the corpse appropriately
               SetFirstName(oGiver, "Decayed Corpse");
               SetDescription(oGiver, "This corpse has decayed.");
            }
		    return; 
		}
        // prevent corpses and items from being duped - player is updated OnAcquired (triggers first)
        // save the corpse inventory to make sure whatever has been looted is gone from the database
        ACR_SavePersistentInventory(oGiver);
		
		// clear the body's death location (it's "in transit") so a corpse won't be created on the next OnModuleLoad
		ACR_DeletePersistentVariable(oGiver, ACR_DTH_LOCATION);

        // destroy the corpse - it should NOT auto drop inventory items by default
        // make sure the persistent corpse blueprint is configured correctly - ACR_PSO_ONDEATH = 0
        DestroyInventory(oGiver); DestroyObject(oGiver);
    }
}

void ACR_CorpseOnAcquire(object oBody, object oAcquiredBy, object oAcquiredFrom)
{
    // if the object is not a corpse token or the player has been raised, do nothing more
    if (! (ACR_GetIsCorpseToken(oBody) &&  ACR_GetIsPlayerDead(oBody))) { return; }
	
    // check if the corpse has decayed
    if (ACR_GetHasCorpseDecayed(oBody))
    {
        // alert the player that's obtaining the corpse
        SendMessageToPC(oAcquiredBy, "The corpse has decayed.");

        // flag the corpse as decayed so the player can no longer be resurrected
        ACR_SetPlayerStatusFlags(oBody, ACR_PLAYER_FLAG_DECAYED);

        // label the corpse appropriately
        SetFirstName(oBody, "Decayed Corpse");
        SetDescription(oBody, "This corpse has decayed.");
    }

    // save pc givers - keeps corpse and pc in sync
    if (GetIsPC(oAcquiredFrom)) { ACR_PCSave(oAcquiredFrom, TRUE); }
	
    // save the taker - keeps corpse and pc in sync
    ACR_PCSave(oAcquiredBy, TRUE);
}

void ACR_CorpseOnUnacquire(object oBody, object oLostBy)
{
    // if the object is not a corpse token, do nothing more
    if (!ACR_GetIsCorpseToken(oBody)) { return; }	
	
    // if the player being carried has been raised, do nothing more
	if (!ACR_GetIsPlayerDead(oBody)) { SendMessageToPC(oLostBy, "The corpse you were carrying has been raised."); return; }

    // get the database name and tag
    string sDatabaseName = ACR_GetDatabaseName(oBody), sTag = GetTag(oBody);
	location lLocation;
	
	// if the player doing the carrying died, drop the corpse beside (not on top) of them
	if (ACR_GetIsPlayerDead(oLostBy))
	{
	    // get the position of the carrier
    	vector vPos = GetPosition(oLostBy);
		
	    // calculate the location of the discarded body
	    lLocation = Location(GetArea(oLostBy), Vector(vPos.x + ACR_RandomFloat(0.3, 0.8), vPos.y + ACR_RandomFloat(0.3, 0.8), vPos.z), -90.0);
	}
	else
	{
	    // get the position of the body
    	vector vPos = GetPosition(oBody);

    	// determine corpse's distance to 0,0,0 as an indicator of whether it is being bartered or dropped
    	float fDistance = sqrt(vPos.x * vPos.x + vPos.y * vPos.y + vPos.z + vPos.z);

    	// exit if the corpse is being bartered
    	if (fDistance <= 0.01) { SendMessageToPC(oLostBy, "Corpse bartered."); return; }
    
		SendMessageToPC(oLostBy, "You set down " + GetName(oBody) + "'s remains.");

    	// get the location of the discarded body
    	lLocation = GetLocation(oLostBy);
	}

    // create the corpse object on the ground
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, ACR_DTH_CORPSE_RESREF, lLocation, FALSE, sTag);

	// update the name and description of the corpse	
	SetFirstName(oCorpse, GetName(oBody));
	SetDescription(oCorpse, GetDescription(oBody));

    // set the database name on the object (creates a persistent inventory that players can access/loot)
    ACR_SetDatabaseName(oCorpse, sDatabaseName);
	
	// update the corpses location so it can be recreated OnModuleLoad
    ACR_SetPersistentLocation(oCorpse, ACR_DTH_LOCATION, lLocation);

    // check if the corpse has decayed
    if (ACR_GetHasCorpseDecayed(oCorpse))
    {
        // alert the player that's discarding the corpse
        SendMessageToPC(oLostBy, "The corpse has decayed.");

        // flag the corpse as decayed - the corpse will no longer appear
        ACR_SetPlayerStatusFlags(oCorpse, ACR_PLAYER_FLAG_DECAYED);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oCorpse, ACR_DTH_LOCATION);

        // label the corpse appropriately
        SetFirstName(oCorpse, "Decayed Corpse");
        SetDescription(oCorpse, "This corpse has decayed.");
    }
	
	// check if corpse has been mutilated
	if (ACR_GetIsCorpseMutilated(oCorpse)) {
	    // label the corpse appropriately
        SetDescription(oCorpse, "This corpse has been mutilated beyond recognition.");
	}
    
	// handling for unloaded corpse inventories on module load, as they may be needed by scripts
	//   before OnOpen.
	ACR_PreLoadStorageObject(oCorpse);
	
    // create a new token on the corpse
	object oNewBody = CreateItemOnObject(ACR_DTH_BODY_RESREF, oCorpse, 1, sTag);
	
	// set the name, description, and database
    SetFirstName(oNewBody, GetName(oBody)); SetDescription(oNewBody, GetDescription(oBody));
	ACR_SetDatabaseName(oNewBody, sDatabaseName);

	// set the character ID on the corpse and token (for setting/clearing status flags)
	ACR_SetCharacterID(oNewBody, ACR_GetCharacterID(oBody), ACR_GetPlayerID(oBody));
	ACR_SetCharacterID(oCorpse, ACR_GetCharacterID(oBody), ACR_GetPlayerID(oBody));
	
	// destroy the discarded body (original corpse token)
	DestroyObject(oBody);

    // save the player - keeps corpse and pc in sync - do this last so it doesn't introduce processing delays midstream
    ACR_PCSave(oLostBy, TRUE);
}

void ACR_CorpseOnHeartBeat(object oCorpse)
{
// CHECK FOR DECAY? BETTER TO DO THIS WITH PSUEDO HB's OnLoad OR WHENEVER PICKED UP
}

void ACR_DeathOnClientEnter(object oPC)
{
    // boot players if a morgue doesn't exist on this server
	if (! GetIsObjectValid(GetLocalObject(GetModule(), ACR_DTH_WAYPOINT)))
	{
		BootPC(oPC); return;
      	ACR_PrintDebugMessage("acr_death_i: ERROR - Could not locate a morgue waypoint. Aborting login processing.", ACR_DTH_DEBUG_ID, DEBUG_LEVEL_FATAL);
	}
}

void ACR_DeathOnPCLoaded(object oPC)
{
	// process dead players
	if (ACR_GetIsPlayerDead(oPC))
	{
    	// if the player's corpse has decayed, they can no longer be resurrected - stop processing
    	if (ACR_GetHasCorpseDecayed(oPC))
		{
			// mark decayed players as unplayable - they will no longer be able to login with this character
			ACR_SQLQuery("UPDATE characters SET IsPlayable=0 WHERE ID=" + IntToString(ACR_GetCharacterID(oPC)));

			// clean up corpse tracking data
			ACR_DeletePersistentVariable(oPC, ACR_DTH_LOCATION);
		
			SendMessageToPC(oPC, "Your corpse has decayed, this character is currently unplayable.");
			SendMessageToAllDMs(GetPCPlayerName(oPC)+" has just logged in with a dead PC, "+GetName(oPC)+", whose corpse has decayed.");
		}
	    // if a dead player is not in the morgue, move them back
    	if (GetTag(GetArea(oPC)) != ACR_DTH_MORGUE_AR_TAG)
    	{
        	// teleportation out of the morgue by a DM should be temporary
	        // return the player to the morgue - a unique waypoint MUST exist in the morgue
        	AssignCommand(oPC, JumpToLocation(GetLocation(GetLocalObject(GetModule(), ACR_DTH_WAYPOINT))));
		
			// apply the death effects and make the player commandable
			_applyDeathEffects(oPC); //SetCommandable(TRUE, oPC);
    	}
	}
	// process bleeding players (that logged off)
	else if (ACR_GetIsPlayerBleeding(oPC))
	{
		// calculate bleeding while offline - the death system should not depend on a rest system timer (graduate to a global?)
		int nMissingTime = ACR_GetTimeStampInMinutes() - ACR_GetPersistentInt(oPC, "ACR_REST_LOGOUT_TIMER");
	    SendMessageToPC(oPC, "You have logged back in bleeding and should be adjusted for the time that has passed. (" + IntToString(nMissingTime) + " minutes)");
		// If the damage didn't get saved, knock the PC back into negatives.  -5 is a decent place.
		//if(GetCurrentHitPoints(oPC) > -1) {
        //    effect eReplacement = EffectDamage((GetCurrentHitPoints(oPC)+5), DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
        //    ApplyEffectToObject(DURATION_TYPE_INSTANT, eReplacement, oPC);		    
		//}
	}
    // liberate resurrected players
    else if (GetIsObjectValid(GetAreaFromLocation(ACR_GetPersistentLocation(oPC, ACR_DTH_LOCATION))))
    {
		// wait out any transitioning players
		if (!GetIsObjectValid(GetArea(oPC))) { DelayCommand(1.0, ACR_DeathOnPCLoaded(oPC)); return; }
		
		// wait for the player to instantiate in the morgue
		if (GetArea(oPC) != GetArea(GetLocalObject(GetModule(), ACR_DTH_WAYPOINT))) { DelayCommand(5.0, ACR_DeathOnPCLoaded(oPC)); return; }

// DO WE NEED TO DISTINGUISH RAISE FROM RESURRECT WITH SEPARATE FLAGS? DEPENDS ON THE PLAYER'S HP

		// give the player notice of their resurrection
		FloatingTextStringOnCreature("You have been resurrected. Prepare for your return.", oPC, FALSE);

	    location lLocation = ACR_GetPersistentLocation(oPC, ACR_DTH_LOCATION);
		string sDatabaseName = ACR_GetPCPublicCDKey(oPC) + "_" + IntToString(ACR_GetCharacterID(oPC));

    	// create the player corpse to load the player's inventory in it
    	// corpses for players pending resurrection are already destroyed (on rez)
   		object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, ACR_DTH_CORPSE_RESREF, lLocation);
		SetLocalInt(oPC, "ACR_DTH_REZ", TRUE);
		// set the database name for inventory retrieval
    	ACR_SetDatabaseName(oCorpse, sDatabaseName);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oPC, ACR_DTH_LOCATION);
		
	    // return the player to their original location
		AssignCommand(oCorpse, ActionDoCommand(BlackScreen(oPC)));
	   	AssignCommand(oCorpse, ActionDoCommand(AssignCommand(oPC, JumpToLocation(lLocation))));

    	// give the player back any items remaining on the corpse
    	// uses action commands, which will always execute after the script ends - SEQUENCE MATTERS
    	if (ACR_GetNumberOfItemsInStorage(oCorpse))	{ _giveInventoryItems(oPC, oCorpse); }

		// save the player - updates status, items, and location
		AssignCommand(oCorpse, ActionDoCommand(FadeFromBlack(oPC, FADE_SPEED_SLOWEST)));
		AssignCommand(oCorpse, ActionDoCommand(ACR_PCSave(oPC)));

		// remove the corpse and destroy the campaign database now that the player has their items back
		AssignCommand(oCorpse, ActionDoCommand(DestroyCampaignDatabase(sDatabaseName)));
		AssignCommand(oCorpse, ActionDoCommand(DestroyObject(oCorpse)));

	    // apply the death penalties at the time of resurrection to avoid
	    // having to rebuild characters/levels in the event of a tech raise
	    AssignCommand(oPC, _applyDeathPenalty(oPC));
		
		DeleteLocalInt(oPC, "ACR_DTH_DEAD");
		DelayCommand(5.0, DeleteLocalInt(oPC, "ACR_DTH_REZ"));
		// remove death VFX and restore the player's screen
		RemoveEffect(oPC, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
    }
}

void ACR_RestoreCorpsesOnModuleLoad()
{
	location lLocation;
	string sDatabaseName, sCorpseName, sTag, sCID;
	int nStatus, nDecayed, nPID;
	object oCorpse, oItem, oNewBody, oDeathMod = GetModule();	
	// create the debug system ID for reporting if it doesn't exist
	ACR_CreateDebugSystem(ACR_DTH_DEBUG_ID, DEBUG_TARGET_TALK, DEBUG_TARGET_LOG, DEBUG_TARGET_LOG | DEBUG_TARGET_DMS);
	
	// retrieve all the records of dead players with corpses in the game world
	//  - only pull those that corrspond with the current server.
	//ACR_SQLQuery("SELECT d1.Name, d1.Tag, d1.Value, d2.Value FROM pwdata as d1, pwdata as d2 WHERE d1.`Key`='" + ACR_DTH_LOCATION + "' and d1.Name=d2.Name and d1.Tag=d2.Tag and d2.`Key`='" + ACR_PLAYER_FLAGS + "' and d2.Value | " + IntToString(ACR_PLAYER_FLAG_DEAD));
	ACR_SQLQuery("SELECT pwdata.Name, pwdata.Tag, pwdata.Value, characters.ID, characters.Status, characters.PlayerID FROM characters JOIN players on players.ID=characters.PlayerID JOIN pwdata on pwdata.Name=characters.Name WHERE pwdata.Tag=players.CDKey and pwdata.`Key`='" + ACR_DTH_LOCATION + "' and characters.ServerID = '"+IntToString(ACR_GetServerId())+"' and characters.Status = characters.Status | " + IntToString(ACR_PLAYER_FLAG_DEAD));

	// loop through all the bodies at the morgue and recreate their corpses in the world
	while (ACR_SQLFetch() == SQL_SUCCESS)
	{
		// DO NOT RUN ANOTHER QUERY IN THIS WHILE LOOP - IT WILL RESET THE RESULTS
		
		// get the last resting place of the corpse
		lLocation = ACR_StringToLocation(ACR_SQLGetData(2));

		// ignore locations that are not valid - corpses in PC inventories should be left alone
		// corpses traveling in PC inventories will be recreated when the bodies are put down
		if (!GetIsObjectValid(GetAreaFromLocation(lLocation)))
			continue;

		sTag = ACR_SQLGetData(1); sCID = ACR_SQLGetData(3); nStatus = StringToInt(ACR_SQLGetData(4)); nPID = StringToInt(ACR_SQLGetData(5));
		
		// recreate the corpse placeable at its last resting place
		oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, ACR_DTH_CORPSE_RESREF, lLocation, FALSE, sTag);

		// set the id and database name on the corpse object to link to its persistent inventory
		ACR_SetCharacterID(oCorpse, StringToInt(sCID), nPID);
		sDatabaseName = sTag + "_" + sCID;

		ACR_SetDatabaseName(oCorpse, sDatabaseName);
		
		// set the name and description of the corpse
		sCorpseName = ACR_SQLGetData(0); SetFirstName(oCorpse, sCorpseName);

		if (nStatus & ACR_PLAYER_FLAG_DECAYED)
		{
			// we can't edit the persistent variables here without breaking the query, so save this
			// info for another quick loop afterwards.  Build a pointer array for this.
			nDecayed = nDecayed +1;
			SetLocalObject(oDeathMod, "ACR_DTH_DECAYED_"+IntToString(nDecayed), oCorpse);
			SetDescription(oCorpse, "This corpse has decayed.");
		}
		else if (nStatus & ACR_PLAYER_FLAG_MUTILATED)
		{
			SetDescription(oCorpse, "This corpse has been mutilated beyond recognition.");
		}
		else
		{
			SetDescription(oCorpse, "These are the remains of " + sCorpseName + ".");
		}
		ACR_PreLoadStorageObject(oCorpse);


		// Remove potential extras of the BODY item (due to database problems, etc.), then recreate afresh.
		for (ObjectToInt(oItem =GetFirstItemInInventory(oCorpse)); GetIsObjectValid(oItem); ObjectToInt(oItem = GetNextItemInInventory(oCorpse)))
		{
			if (GetResRef(oItem) == ACR_DTH_BODY_RESREF)
				DestroyObject(oItem);
		}


		object oNewBody = CreateItemOnObject(ACR_DTH_BODY_RESREF, oCorpse, 1, sTag);
		// set the name, description, and database
		SetFirstName(oNewBody, GetName(oCorpse)); SetDescription(oNewBody, GetDescription(oCorpse));
		ACR_SetDatabaseName(oNewBody, sDatabaseName);

		// set the character ID on the corpse and token (for setting/clearing status flags)
		ACR_SetCharacterID(oNewBody, ACR_GetCharacterID(oCorpse), ACR_GetPlayerID(oCorpse));

	}

	// now, go back and delete locations for any decayed corpses.
	while (nDecayed > 0) {
		oCorpse = GetLocalObject(oDeathMod, "ACR_DTH_DECAYED_"+IntToString(nDecayed));
		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oCorpse, ACR_DTH_LOCATION);
		// label the corpse appropriately
		SetFirstName(oCorpse, "Decayed Corpse");
		// clear the pointer
		DeleteLocalObject(oDeathMod, "ACR_DTH_DECAYED_"+IntToString(nDecayed));
		// decrement the counter
		nDecayed = nDecayed - 1;
	}
	
	// cache the morgue waypoint on the module for faster access
	SetLocalObject(GetModule(), ACR_DTH_WAYPOINT, GetWaypointByTag(ACR_DTH_MORGUE_WP_TAG));
}

int ACR_GetIsCorpse(object oObject)
{
    return (GetResRef(oObject) == ACR_DTH_CORPSE_RESREF) ? TRUE : FALSE;
}

int ACR_GetIsCorpseToken(object oObject)
{
    return (GetResRef(oObject) == ACR_DTH_BODY_RESREF) ? TRUE : FALSE;
}

int ACR_GetHasCorpseDecayed(object oCorpse)
{
    return (((GetCalendarYear() * 336) + (GetCalendarMonth() * 28) + GetCalendarDay()) - ACR_GetPersistentInt(oCorpse, ACR_DTH_TIMESTAMP) > ACR_DTH_CORPSE_DECAY) ? TRUE : FALSE;
}

int ACR_GetIsCorpseEmptied(object oCorpse)
{
    // be sure the persistent storage object counters are initialized onspawn
    return (ACR_GetNumberOfItemsInStorage(oCorpse) == 0) ? TRUE : FALSE;
}

object ACR_GetCorpseFromPlayer(object oPC)
{
    int i=0; 
	string sPCTag = ACR_GetPCPublicCDKey(oPC);
	object oObject = GetObjectByTag(sPCTag, i);
	
	// find the placeable corpse object that represents this player, may be more than 1 matching their CDKey
	while (oObject != OBJECT_INVALID) {
	    if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE) { 
			// if it's a placeable, check the name
		    if (GetName(oPC) == GetName(oObject)) { return oObject; }
		}
		i++;
		oObject = GetObjectByTag(sPCTag, i); 
	}
	
	return OBJECT_INVALID;
}

object ACR_GetPlayerFromCorpse(object oCorpse)
{
	string sDatabaseName = ACR_GetDatabaseName(oCorpse);
	int nCID = ACR_GetCharacterID(oCorpse);
    object oPC = GetFirstPC();

    // loop through the player list
    while (GetIsObjectValid(oPC))
    {
        // check if the character IDs match up
        if (ACR_GetCharacterID(oPC) == nCID) { return oPC; }

        // get the next player
        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}

void ACR_StabilizePlayer(object oPC)
{
    // clear the dying and bleeding flags
	ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_DYING | ACR_PLAYER_FLAG_BLEEDING);
	
	// in order to trigger the stop to bleeding, reduce the stored HP tally (so the PC appears partially healed.)
	SetLocalInt(oPC, ACR_DTH_HITPOINTS, GetCurrentHitPoints(oPC) - 1);
}

int ACR_CanCorpseBeRecalled(object oCorpse) {
	return GetLocalInt(GetModule(), _ACR_DTH_RECALLABLE + ACR_GetDatabaseName(oCorpse));
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _dropEquippedItems(object oTarget)
{
	object oDead = OBJECT_SELF;
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDead);
	object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDead);
	
	// Skipping the drop code for now, held items to corpse inventory instead.
	//AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDead), oTarget));
	//AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDead), oTarget));
	//AssignCommand(oDead, ActionPutDownItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)));
	if (GetIsObjectValid(oLefthand)) {
		ACR_LogOnUnacquired(oLefthand, oDead, FALSE);
		CopyItem(oLefthand, oTarget, TRUE);
		DestroyObject(oLefthand, 0.1, FALSE);
	}
	if (GetIsObjectValid(oRighthand)) {
		ACR_LogOnUnacquired(oRighthand, oDead, FALSE);
		CopyItem(oRighthand, oTarget, TRUE);
		DestroyObject(oRighthand, 0.1, FALSE);
	}
	/*
    // drop weapons in random locations within 5 ft
    vector vPos = GetPositionFromLocation(GetLocation(oDead));
    location l1 = Location(GetArea(oDead), Vector(vPos.x+0.75, vPos.y, vPos.z), -90.0);
    location l2 = Location(GetArea(oDead), Vector(vPos.x-0.75, vPos.y+1.0, vPos.z), 90.0);

    // if the player is wielding an item in his left hand, take it and drop it beside the corpse
    if (GetIsObjectValid(oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oDead)))
    {
        object oUndertaker1 = CreateObject(OBJECT_TYPE_CREATURE, ACR_DTH_UNDERTAKER_RESREF, l1);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oUndertaker1);
        AssignCommand(oUndertaker1, ActionTakeItem(oLefthand, oDead));
        AssignCommand(oUndertaker1, ActionPutDownItem(oLefthand));
        AssignCommand(oUndertaker1, ActionDoCommand(DestroyObject(oUndertaker1)));
        AssignCommand(oUndertaker1, SetCommandable(FALSE));
    }

    // if the player is wielding an item in his right hand, take it and drop it beside the corpse
    if (GetIsObjectValid(oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDead)))
    {
        object oUndertaker2 = CreateObject(OBJECT_TYPE_CREATURE, ACR_DTH_UNDERTAKER_RESREF, l2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oUndertaker2);
        AssignCommand(oUndertaker2, ActionTakeItem(oRighthand, oDead));
        AssignCommand(oUndertaker2, ActionPutDownItem(oRighthand));
        AssignCommand(oUndertaker2, ActionDoCommand(DestroyObject(oUndertaker2)));
        AssignCommand(oUndertaker2, SetCommandable(FALSE));
    }
    */
	
    // unequip everything else and drop it in the corpse's inventory
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_BELT, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_NECK, oDead), oTarget));
    //AssignCommand(oDead, ActionGiveItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oDead), oTarget));

	object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS, oDead);
	if (GetIsObjectValid(oArms)) {
		ACR_LogOnUnacquired(oArms, oDead, FALSE);
		CopyItem(oArms, oTarget, TRUE);
		DestroyObject(oArms, 0.10, FALSE);
	}
	object oArrows = GetItemInSlot(INVENTORY_SLOT_ARROWS, oDead);
	if (GetIsObjectValid(oArrows)) {
		ACR_LogOnUnacquired(oArrows, oDead, FALSE);
		CopyItem(oArrows, oTarget, TRUE);
		DestroyObject(oArrows, 0.11, FALSE);
	}
	object oBelt = GetItemInSlot(INVENTORY_SLOT_BELT, oDead);
	if (GetIsObjectValid(oBelt)) {
		ACR_LogOnUnacquired(oBelt, oDead, FALSE);
		CopyItem(oBelt, oTarget, TRUE);
		DestroyObject(oBelt, 0.12, FALSE);
	}
	object oBolts = GetItemInSlot(INVENTORY_SLOT_BOLTS, oDead);
	if (GetIsObjectValid(oBolts)) {
		ACR_LogOnUnacquired(oBolts, oDead, FALSE);
		CopyItem(oBolts, oTarget, TRUE);
		DestroyObject(oBolts, 0.13, FALSE);
	}
	object oBoots = GetItemInSlot(INVENTORY_SLOT_BOOTS, oDead);
	if (GetIsObjectValid(oBoots)) {
		ACR_LogOnUnacquired(oBoots, oDead, FALSE);
		CopyItem(oBoots, oTarget, TRUE);
		DestroyObject(oBoots, 0.14, FALSE);
	}
	object oBullets = GetItemInSlot(INVENTORY_SLOT_BULLETS, oDead);
	if (GetIsObjectValid(oBullets)) {
		ACR_LogOnUnacquired(oBullets, oDead, FALSE);
		CopyItem(oBullets, oTarget, TRUE);
		DestroyObject(oBullets, 0.15, FALSE);
	}
	object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oDead);
	if (GetIsObjectValid(oChest)) {
		ACR_LogOnUnacquired(oChest, oDead, FALSE);
		CopyItem(oChest, oTarget, TRUE);
		DestroyObject(oChest, 0.16, FALSE);
	}
	object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oDead);
	if (GetIsObjectValid(oCloak)) {
		ACR_LogOnUnacquired(oCloak, oDead, FALSE);
		CopyItem(oCloak, oTarget, TRUE);
		DestroyObject(oCloak, 0.17, FALSE);
	}
	object oHead = GetItemInSlot(INVENTORY_SLOT_HEAD, oDead);
	if (GetIsObjectValid(oHead)) {
		ACR_LogOnUnacquired(oHead, oDead, FALSE);
		CopyItem(oHead, oTarget, TRUE);
		DestroyObject(oHead, 0.18, FALSE);
	}
	object oLeftRing = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oDead);
	if (GetIsObjectValid(oLeftRing)) {
		ACR_LogOnUnacquired(oLeftRing, oDead, FALSE);
		CopyItem(oLeftRing, oTarget, TRUE);
		DestroyObject(oLeftRing, 0.19, FALSE);
	}
	object oNeck = GetItemInSlot(INVENTORY_SLOT_NECK, oDead);
	if (GetIsObjectValid(oNeck)) {
		ACR_LogOnUnacquired(oNeck, oDead, FALSE);
		CopyItem(oNeck, oTarget, TRUE);
		DestroyObject(oNeck, 0.2, FALSE);
	}
	object oRightRing = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oDead);
	if (GetIsObjectValid(oRightRing)) {
		ACR_LogOnUnacquired(oRightRing, oDead, FALSE);
		CopyItem(oRightRing, oTarget, TRUE);
		DestroyObject(oRightRing, 0.21, FALSE);
	}
}

void _giveInventoryItems(object oTarget, object oSource = OBJECT_SELF)
{
    object oItem = GetFirstItemInInventory(oSource);
	    // loop through inventory
	object oNew = OBJECT_INVALID;
	float fDelay = 0.1;
    while (GetIsObjectValid(oItem))
    {
        // do not transfer corpse/death tokens, instead call OnUnAquire for them
        if (GetResRef(oItem) == ACR_DTH_BODY_RESREF)
		{
			// only simulate a drop if the source is a player object, otherwise destroy the token
			// necessary to prevent a player's corpse token from being trapped in another dead player's inventory
		    if (GetIsPC(oSource)) {	ACR_CorpseOnUnacquire(oItem, oSource); } else {	DestroyObject(oItem); }
		}
		else
		{
		    //AssignCommand(oSource, ActionGiveItem(oItem, oTarget));
			if (GetLocalInt(oItem, "ACR_ITM_OOC") == FALSE) {
				// container objects cannot be copied, so try to re-create it.
				if (GetHasInventory(oItem)) {
					oNew = CreateItemOnObject(GetResRef(oItem), oTarget, 1, GetTag(oItem), FALSE);
					if (oNew == OBJECT_INVALID) {
					    SendMessageToPC(oSource, "Error copying, item lost: "+GetName(oItem));
						SendMessageToAllDMs("Error copying, item lost: "+GetName(oItem));
					}
				} else {	
					CopyItem(oItem, oTarget, TRUE);
				}
				ACR_LogOnUnacquired(oItem, oSource, FALSE);
				DestroyObject(oItem, fDelay, FALSE);
				fDelay = fDelay + 0.01;
			}  // else skip the item, as it's not supposed to be removed.
		}
		
        // get the next inventory item
        oItem = GetNextItemInInventory(oSource);
    }

	// explicitly transfer gold for PCs only since PCs do not carry gold as objects in inventory
	if (GetIsPC(oSource))
	{
	    int nGold = GetGold(oSource);

	    // transfer any gold as well
	    if (nGold > 0)
		{
        	CreateItemOnObject("NW_IT_GOLD001", oTarget, nGold);
        	TakeGoldFromCreature(nGold, oSource, TRUE);
			ACR_LogEvent(oSource, ACR_LOG_DROP, "Gold loss, "+IntToString(nGold)+" gp.");
		}
	}
}

void _saveInventoryItems(object oCorpse, string sAreaTag)
{
    object oPC = OBJECT_SELF;

    // check if the PC has arrived at the destination
    if (GetTag(GetArea(oPC)) == sAreaTag)
    {
        // save the inventory items to the database
        // delay the save to ensure inventory transfer happens first
        ACR_SavePersistentInventory(oCorpse);

        // save the player's new location and status
        ACR_PCSave(oPC);

        // destroy the corpse if the player has returned to the same location (resurrected)
        if (GetTag(GetArea(oCorpse)) == sAreaTag) { DestroyObject(oCorpse); }

        // restore the screen once the updates are complete
        DelayCommand(1.0, FadeFromBlack(oPC, FADE_SPEED_SLOWEST));
    }
    else
    {
        // reschedule the save
        DelayCommand(1.0, AssignCommand(oPC, _saveInventoryItems(oCorpse, sAreaTag)));
    }
}

void _applyDeathEffects(object oDead)
{
    // Remove negative effects?
    //RemoveEffects(oDead);

	effect eTest = GetFirstEffect(oDead);
	while (GetIsEffectValid(eTest)) {
	    if ((GetEffectType(eTest) == EFFECT_TYPE_POISON) || (GetEffectType(eTest) == EFFECT_TYPE_DISEASE)) {
			DelayCommand(0.2, RemoveEffect(oDead, eTest));
		} else if (GetEffectType(eTest) == EFFECT_TYPE_ABILITY_DECREASE) {
		    DelayCommand(0.2, RemoveEffect(oDead, eTest));
		}
		eTest = GetNextEffect(oDead);
	} 
	// takes care of any subdual commandability problems
	DelayCommand(10.0, SetCommandable(TRUE, oDead));
    // raise the player so they can be moved to the morgue and apply a ghost effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oDead);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE), oDead);
	
	//BlackScreen(oDead);

    SendMessageToPC(oDead, "You are dead.");
}

void _applyDeathPenalty(object oDead)
{
	int i, nXP = 0, nHD = GetHitDice(oDead);
	int nPriorXP = GetXP(oDead);
	int bFirstLevel = FALSE;

	// level 1 PCs lose all XP (2 points of constitution loss?)
	//  using hitdice at this stage so LA races also return to 1 xp from a rez at first.
	if (nHD == 1)
	{
	    SetXP(oDead, 1);
		bFirstLevel = TRUE;
	}
	// all others lose a level (meaning they were at least 2nd level)
	//  substitute nHD with ECL.
	else
	{
	    //  substitute nHD with ECL.
	    nHD = ACR_GetECL(oDead);
	    // add up the xp to the previous level
	    int nXP = GetXpNeededForLevel(nHD - 1);
		nXP = nXP + ((GetXpNeededForLevel(nHD) - nXP) / 2);	
	    // set the xp midway to the current level
	    SetXP(oDead, nXP );
	}
	// makes the XP award ALFA-official
	ACR_SetPersistentInt(oDead, _STORED_XP, GetXP(oDead));
	if (bFirstLevel) {
	    ACR_LogEvent(oDead, ACR_LOG_REZ, "Lost "+IntToString(nPriorXP - 1)+" XP to death penalty.");  
	    SendMessageToAllDMs("PC "+GetName(oDead)+" has lost "+IntToString(nPriorXP - 1)+" XP to death penalty.");
	} else {
	    ACR_LogEvent(oDead, ACR_LOG_REZ, "Lost "+IntToString(nPriorXP - nXP)+" XP to death penalty.");  
	    SendMessageToAllDMs("PC "+GetName(oDead)+" has lost "+IntToString(nPriorXP - nXP)+" XP to death penalty.");
	}
	
    DelayCommand(0.5, FloatingTextStringOnCreature("XP Loss", oDead, FALSE));
}

void _playerOnDeath(object oPC, object oKiller)
{
    // remove the player from their party
    RemoveFromParty(oPC);

    object oModule = GetModule();
    string sPlayerName = GetName(oPC);
    location lPlayerLocation = GetLocation(oPC);
    
    // generate a unique database identifier for the corpse to store items persistently
    string sDatabaseName = ACR_GetPCPublicCDKey(oPC) + "_" + IntToString(ACR_GetCharacterID(oPC));

    // create the player corpse and store the player's inventory on it
    object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, ACR_DTH_CORPSE_RESREF, lPlayerLocation, FALSE, ACR_GetPCPublicCDKey(oPC));

    // create the player body item on the player corpse object and set its name and tag
    // player bodies can be used to transport the corpse to another location and raise them
    object oBody = CreateItemOnObject(ACR_DTH_BODY_RESREF, oCorpse, 1, ACR_GetPCPublicCDKey(oPC));
	
    // name the corpse - this is necessary for accurate player/corpse data logging
	SetFirstName(oCorpse, sPlayerName);
    SetDescription(oCorpse, "These are the remains of " + sPlayerName + ".");
	
    // name the corpse token - this is necessary for accurate player/corpse data logging
	SetFirstName(oBody, sPlayerName);
    SetDescription(oBody, "These are the remains of " + sPlayerName + ".");

    // set the database name on the corpse object and token (creates a persistent inventory)
    ACR_SetDatabaseName(oCorpse, sDatabaseName); ACR_SetDatabaseName(oBody, sDatabaseName);
    
    // record the location of the player's death (necessary for recreating the corpse)
    ACR_SetPersistentLocation(oCorpse, ACR_DTH_LOCATION, lPlayerLocation);

    // record the time of death (in days) to track corpse decay
    ACR_SetPersistentInt(oCorpse, ACR_DTH_TIMESTAMP, (GetCalendarYear() * 336) + (GetCalendarMonth() * 28) + GetCalendarDay());
    ACR_SetPersistentInt(oCorpse, ACR_DTH_INSTANT, (GetTimeHour() * 3600) + (GetTimeMinute() * 60) + GetTimeSecond());

    // set the character ID on the corpse and token (for setting/clearing status flags)
    ACR_SetCharacterID(oBody, ACR_GetCharacterID(oPC), ACR_GetPlayerID(oPC));
	 ACR_SetCharacterID(oCorpse, ACR_GetCharacterID(oPC), ACR_GetPlayerID(oPC));

    // update the player status - set death flag, clear all others
    ACR_SetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_DEAD);
	ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_ALL & ~(ACR_PLAYER_FLAG_DEAD));

    // apply death effects to the player
    _applyDeathEffects(oPC);

    // move the inventory items from player to corpse
    // uses action commands, which will always execute after the script ends
    AssignCommand(oPC, _giveInventoryItems(oCorpse)); 
	AssignCommand(oPC, _dropEquippedItems(oCorpse));

// WHAT ABOUT WEIGHT CONSIDERATIONS?

    // load the respawn waypoint
    location lLocation = GetLocation(GetLocalObject(oModule, ACR_DTH_WAYPOINT));

    // save the player and corpse inventories
    DelayCommand(0.5, AssignCommand(oPC, _saveInventoryItems(oCorpse, GetTag(GetAreaFromLocation(lLocation)))));

    // jump the player to the respawn point in the morgue
    // delay the jump to allow inventory items to transfer first (important for saving)
    AssignCommand(oPC, DelayCommand(0.7, JumpToLocation(lLocation)));
}

void _playerStabilizeCheck(object oPC, int bHealed=FALSE)
{
	// stop performing stabilization checks if the player has logged off
	if (! GetIsObjectValid(oPC)) { return; }
	
    int nHP = GetCurrentHitPoints(oPC);
	int nRounds = ACR_GetPersistentInt(oPC, ACR_DTH_NUM_ROUNDS);
 
    // check if the player has been revived or has died - stop stabilization checks
    if (nHP > 0 || nHP < -9)
    {
        // clear the dying flags
        ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_DYING | ACR_PLAYER_FLAG_BLEEDING | ACR_PLAYER_FLAG_UNCONSCIOUS | ACR_PLAYER_FLAG_STABILIZED);
        ACR_DeletePersistentVariable(oPC, ACR_DTH_NUM_ROUNDS);
        DeleteLocalInt(oPC, ACR_DTH_HITPOINTS);
		DeleteLocalObject(oPC, _ACR_DTH_DAMAGER);

		// restore player control
		//SetCommandable(TRUE, oPC);

        // restore the player's screen
        //FadeFromBlack(oPC, FADE_SPEED_SLOWEST);
        return;
    }

    // check if a player needs to stabilize
    if (! ACR_GetIsPlayerStabilized(oPC))
    {
        // check the player's health - if they have been healed, they stop bleeding
        if (nHP > GetLocalInt(oPC, ACR_DTH_HITPOINTS))
        {
            // clear the bleeding flag and set the stabilized flag
            ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_BLEEDING);
			ACR_SetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_STABILIZED);

            // schedule another check
            DelayCommand(RoundsToSeconds(1), _playerStabilizeCheck(oPC, TRUE));
            FloatingTextStringOnCreature("You have been successfully stabilized and are no longer bleeding!", oPC, FALSE);
        }
        // check the player's health - 10%, the bleeding slows down
        else if (d100() <= ACR_DTH_PERCENT_CHANCE)
        {
            // set the stabilized flag
            ACR_SetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_STABILIZED);

            // schedule another check
            DelayCommand(RoundsToSeconds(1), _playerStabilizeCheck(oPC));
            FloatingTextStringOnCreature("Your bleeding has slowed, but you are still dying!", oPC, FALSE);
        }
        else
        {
            // decrement the players hit points
            effect eDamage = EffectDamage(1, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
            PlayVoiceChat(VOICE_CHAT_PAIN3, oPC);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oPC);

            // update the player's hit point total
            SetLocalInt(oPC, ACR_DTH_HITPOINTS, nHP - 1);
			
			// update the character stats - no need to export bic (stats changed, inventory hasn't)
			ACR_PCSave(oPC, FALSE);

            // schedule another check
            DelayCommand(RoundsToSeconds(1), _playerStabilizeCheck(oPC));
        }
    }
    // check if a player regains consciousness and/or heals naturally
    else
    {
        // check if the player has been healed - clear the bleeding flag once
		if (nHP > GetLocalInt(oPC, ACR_DTH_HITPOINTS) && !bHealed)
		{
            ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_BLEEDING);
			bHealed = TRUE;
		}
				
        // check if it's time for a natural healing check (this takes priority over a conciousness check
        if (nRounds % ACR_DTH_NATHEALING_ROUNDS == (ACR_DTH_NATHEALING_ROUNDS - 1))
        {
            // healed characters or those that make a successful check begin to heal naturally
            if (bHealed || (d100() <= ACR_DTH_PERCENT_CHANCE))
            {
                // restore the players hit points (1 at a time, since it's frequent)
                effect eHeal = EffectHeal(1);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);

                // once natural healing begins, the player can no longer lose hitpoints
	            ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_BLEEDING);
                bHealed = TRUE;
				// clear the unconscious flag and local data
                ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_UNCONSCIOUS);

				FloatingTextStringOnCreature("You are no longer bleeding, and are slowly recovering from your wounds.", oPC, FALSE);
            }
            // stabilized but unhealed characters keep bleeding
            else if (ACR_GetIsPlayerBleeding(oPC))
            {
                // decrement the players hit points
                effect eDamage = EffectDamage(1, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
                PlayVoiceChat(VOICE_CHAT_PAIN3, oPC);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oPC);
				
				SendMessageToPC(oPC, "You fail to begin natural healing, and instead slip closer to death.");

	            // update the player's hit point total
    	        SetLocalInt(oPC, ACR_DTH_HITPOINTS, nHP - 1);
            }
			
			// update the character stats - no need to export bic (stats changed, inventory hasn't)
			ACR_PCSave(oPC, FALSE);
        }
        // check if it's time for a consciousness check, only run this if it's not a natural healing check already.
        else if (ACR_GetIsPlayerUnconscious(oPC) &&
            nRounds % ACR_DTH_UNCONSCIOUS_ROUNDS == (ACR_DTH_UNCONSCIOUS_ROUNDS - 1))
        {
            // check if the player regains consciousness
            if (d100() <= ACR_DTH_PERCENT_CHANCE)
            {
                // clear the unconscious flag and local data
                ACR_UnsetPlayerStatusFlags(oPC, ACR_PLAYER_FLAG_UNCONSCIOUS);

                // restore the player's screen
                //FadeFromBlack(oPC, FADE_SPEED_SLOWEST);
                FloatingTextStringOnCreature("Your bleeding has slowed and you have regained consciousness, but you remain disabled and in danger of dying.", oPC, FALSE);
            }
            // stabilized but unhealed characters keep bleeding
            else if (ACR_GetIsPlayerBleeding(oPC))
            {
                // decrement the players hit points
                effect eDamage = EffectDamage(1, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
                PlayVoiceChat(VOICE_CHAT_PAIN3, oPC);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_REG_RED), oPC);
				
				SendMessageToPC(oPC, "You fail to gain consciousness, and slip closer to death.");

                // update the player's hit point total
                SetLocalInt(oPC, ACR_DTH_HITPOINTS, nHP - 1);
			
				// update the character stats - no need to export bic (stats changed, inventory hasn't)
				ACR_PCSave(oPC, FALSE);
            }
        }
		


        // increment the round counter
        ACR_SetPersistentInt(oPC, ACR_DTH_NUM_ROUNDS, nRounds + 1);

        // schedule another check
        DelayCommand(RoundsToSeconds(1), _playerStabilizeCheck(oPC, bHealed));
    }
}

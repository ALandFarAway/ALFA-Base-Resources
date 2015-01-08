/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_spellhook_i.nss
//    $Revision:: 336        $ current version of the file
//        $Date:: 2010-09-22#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_SHK
//  Dependencies: None
//
//  Description
//  This library provides functions for spellhooking.
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"
#include "acr_spelltrack_i"
#include "acr_tradescroll_i"
#include "acr_craft_progress_i"
#include "acr_combat_actions_i"

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

void ACR_Spellhook();

void ACR_PotionUse(object oOwner, object oDrinker, int nSpellID);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_Spellhook()
{
	int nSpellId = GetSpellId();
	object oCaster = OBJECT_SELF;
	object oItem = GetSpellCastItem();
	object oTarget = GetSpellTargetObject();
	location lTarget = GetSpellTargetLocation();
	int nItemType = GetBaseItemType(oItem);
	effect eFailure = EffectSpellFailure(100);
	int nRes;

	// Crafting hooks.
	if(ACR_CraftingSpellhook(oCaster, oTarget, oItem, nSpellId))
		return;

	// Hook spells cast by wizards at spellbooks for tradescrolls.
	_DoTradeScrollSpellHook();	
	// if it is a familiar casting, and the master is unconscious, the spell fails.
	if (GetIsPossessedFamiliar(oCaster)) {
	    if (GetCurrentHitPoints(GetMaster(oCaster)) < 1 ) {
		    SendMessageToPC(oCaster, "You cannot deliver touch spells from "+GetName(GetMaster(oCaster))+", must be conscious.");
			SetModuleOverrideSpellScriptFinished();
		} else {
			// if the master is conscious, log and track the spell as if cast by the master.
		    oCaster = GetMaster(oCaster);
		}
	}

	// Combat Mode Hooks
	if(GetIsFightingDefensively(oCaster))
	{
		FightNormally(oCaster);
		SetLocalInt(oCaster, POST_SPELLCAST_NO_COMBAT_MODE, 1);
		DelayCommand(4.5f, ExecuteScript("acr_restartcombatmode", oCaster)); // Because this is in the impact script, it's 4.5 seconds until next round.
	}
	
	
	
	//SendMessageToPC(oCaster, "Debug: spell item is "+GetName(oItem)+", with base item type "+IntToString(GetBaseItemType(oItem)));
	// scroll hook
	if ( nItemType == 75) {
		ACR_ScrollUse(oCaster, oItem, nSpellId);
	} else if ( nItemType == 49 ) {
	    // potion use, don't need to track it for persistency
	} else if ( nItemType == 96 ) {
	    // targetable potion, special handling
		ACR_PotionUse(oCaster, oTarget, nSpellId);
	} else if (GetIsObjectValid(oItem)) {
	    // miscellaneous cast spell item, don't need to track it for spell memory
	} else if (GetIsPC(oCaster) && !GetIsDM(oCaster) && !GetIsDMPossessed(oCaster)) { 
	    // if being cast by a PC (and not from a scroll), track use in the DB
	    ACR_RecordSpellUses(oCaster, nSpellId); 
	}
    // THIS IS A TEMPORARY HACK FOR A NON FUNCTIONING PC SPELLCASTAT EVENT
    // THIS SHOULD BE REMOVED ONCE OBSIDIAN REPAIRS THIS FUNCTIONALITY 
    if (GetIsPC(oTarget)) { ExecuteScript("acf_cre_onspellcastat", oTarget); }
	

}


void ACR_PotionUse(object oOwner, object oDrinker, int nSpellID) {

    // don't need to worry about checks if the potion is being used on onesself.
    if (oOwner != oDrinker) {
	    // potion is being used on another creature, need to determine if it's successful
		SendMessageToPC(oOwner, "You attempt to feed the potion to "+GetName(oDrinker));
		// if it's a downed PC that's being targeted, allow it. Otherwise, more checks.
		if (GetCurrentHitPoints(oDrinker) > 0) {
		    // is the target an enemy? If so, it will fail.
			if (GetIsEnemy(oDrinker, oOwner)) {
				// apply healing to potion holder instead.
			    AssignCommand(oOwner, ActionCastSpellAtObject(nSpellID, oOwner, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
			    //SendMessageToPC(oOwner, "You cannot force your enemy to drink a potion.  The contents spill to the ground.");
				SetModuleOverrideSpellScriptFinished();
			} else if (GetIsInCombat(oDrinker)) {
			    // can't really feed a potion to an ally who is busy fighting, this is what healing spells are for.
				// redirect healing to the owner (since we can't get the potion back at this point)
				SendMessageToPC(oOwner, GetName(oDrinker)+" is busy fighting and cannot be fed a potion now.");
				AssignCommand(oOwner, ActionCastSpellAtObject(nSpellID, oOwner, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
				SetModuleOverrideSpellScriptFinished();
			}
		} // target is nonhostile and not in combat, so allow the potion to be fed
	}
}
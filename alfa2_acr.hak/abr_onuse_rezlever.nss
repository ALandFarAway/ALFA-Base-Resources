#include "acr_death_i"
#include "acr_i"

//! Test placeholder for the resurrect function
//void ACA_CorpseOnResurrect(object oWaypoint, object oTargetCorpse, int nSpellId, object oInitiator);

void main()
{
    object oPC = GetLastUsedBy();
	object oCorpse = ACR_GetCorpseFromPlayer(oPC);
	object oRezWaypoint = GetObjectByTag("ABR_REZLEVER_WP");
	
	SendMessageToPC(oPC, "Used the rez lever.");
	
    if (!ACR_GetIsPlayerDead(oPC)) {
	    SendMessageToPC(oPC, "You are not flagged as dead.");
		return;
	} else if (!GetIsObjectValid(oCorpse)) {
	    SendMessageToPC(oPC, "Could not detect your corpse.");
		return;
	} else if (!GetIsObjectValid(oRezWaypoint)) {
	    SendMessageToPC(oPC, "Could not find the rez destination waypoint.");
		return;
	}
	if (!ACR_GetIsCorpse(oCorpse)) {
	    SendMessageToPC(oPC, "Corpse is not reading as valid");
		return;
	}
	ACR_CorpseOnResurrect(oRezWaypoint, oCorpse, SPELL_RESURRECTION);
	
    
}
/*
void ACA_CorpseOnResurrect(object oWaypoint, object oTargetCorpse, int nSpellId, object oInitiator)
{
    // make sure a ressurection spell has been cast
    if (nSpellId != SPELL_RAISE_DEAD && nSpellId != SPELL_RESURRECTION && nSpellId != SPELL_TRUE_RESURRECTION) { 
	    SendMessageToPC(oInitiator, "Spell ID is invalid.");
		return; 
	}
    SendMessageToPC(oInitiator, "starting: corpse has resref = "+GetResRef(oTargetCorpse)+", spell ID is "+IntToString(nSpellId));
    // make sure a corpse has been targetted
    if (! ACR_GetIsCorpse(oTargetCorpse)) { return; }

    object oRezee; location lLocation = GetLocation(oWaypoint);
    SendMessageToPC(oInitiator, "Entering Rez function.");
    // check if raise dead is being attempted on a mutilated corpse
    if (ACR_GetIsCorpseMutilated(oTargetCorpse) && (nSpellId == SPELL_RAISE_DEAD))
    {
        // alert the player that's raising the corpse and exit
        SendMessageToPC(oInitiator, "The corpse has been mutilated and is unaffected by your spell."); return;
    }

    // check if the corpse has decayed
    if (ACR_GetHasCorpseDecayed(oTargetCorpse))
    {
        // alert the player that's resurrecting the corpse
        SendMessageToPC(oInitiator, "The corpse has decayed and is beyond resurrection.");

        // flag the corpse as decayed - a corpse will no longer appear for this character
        ACR_SetPersistentInt(oTargetCorpse, ACR_PLAYER_FLAGS, ACR_PLAYER_FLAG_DECAYED);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oTargetCorpse, ACR_DTH_LOCATION);

        // label the corpse appropriately
        SetFirstName(oTargetCorpse, "Decayed Corpse");
        SetDescription(oTargetCorpse, "This corpse has decayed.");
    }
    // check if the player is logged in
    else if (GetIsObjectValid(oRezee = ACR_GetPlayerFromCorpse(oTargetCorpse)))
    {
        // hide the player's screen
        BlackScreen(oRezee);
        SendMessageToPC(oInitiator, "Rez PC is valid, trying to rez...");
        // heal the player if this is a resurrection spell
        if (nSpellId != SPELL_RAISE_DEAD) { ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oRezee) - 1), oRezee); }

        // apply the death penalties only if the caster is not a DM
        if (! (GetIsDM(oWaypoint) || GetIsDMPossessed(oWaypoint))) { _applyDeathPenalty(oRezee); }

        // clear the death flags on the player - necessary to be freed from the morgue
        ACR_DeletePersistentVariable(oRezee, ACR_PLAYER_FLAGS);

		// delete the corpse location so the corpse will be expunged from the game
		ACR_DeletePersistentVariable(oTargetCorpse, ACR_DTH_LOCATION);

        // give the player back any items remaining on the corpse
        // uses action commands, which will always execute after the script ends
        AssignCommand(oTargetCorpse, _giveInventoryItems(oRezee));

        // save the player and corpse inventories
        AssignCommand(oRezee, _saveInventoryItems(oTargetCorpse, GetTag(GetAreaFromLocation(lLocation))));

        // return the player to their original location and save their new status
        // delay the jump to allow inventory items to transfer first (important for saving)
        AssignCommand(oRezee, DelayCommand(0.3, JumpToLocation(lLocation)));
    }
    // otherwise, resurrection will be applied on the player's next login
    else
    {
        // clear the dead flag - the player will be resurrected on next login
        ACR_DeletePersistentVariable(oTargetCorpse, ACR_PLAYER_FLAGS);

         // record the location of resurrection
        ACR_SetPersistentLocation(oTargetCorpse, ACR_DTH_LOCATION, lLocation);
		SendMessageToPC(oInitiator, "Target PC, "+GetName(oTargetCorpse)+", is not online.  They will be processed when they log back in."); 
        // destroy the corpse - it should NOT auto drop inventory items by default
        // make sure the persistent corpse blueprint is configured correctly - ACR_PSO_ONDEATH = 0
		// inventory items will be transferred from the corpse the next time the player logs in
        DestroyInventory(oTargetCorpse); DestroyObject(oTargetCorpse);
    }
	SendMessageToPC(oInitiator, "Finished rez function.");
	// should we always destroy the corpse object?
}

*/


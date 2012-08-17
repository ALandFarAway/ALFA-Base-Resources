#include "acr_craft_progress_i"
#include "acr_resting_i"
#include "acr_spells_i"
#include "acr_1984_i"

void main() {
	object oTarget = GetSpellTargetObject();
	object oCrafter = OBJECT_SELF;
	
	if(oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) {
		// If we are not targeting an item, print error and abort.
		SendMessageToPC(oCrafter, "Crafting only works on items.");
		IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
		return;
	}
	
	struct CraftingStatus status = GetCraftingStatus(oTarget);
	
	if(GetIsDM(oCrafter) && !GetIsDMPossessed(oCrafter)) {
		// We're a DM.
		if(status.isProject) {
			// When a DM targets a crafting project, complete the project.
			SendMessageToPC(oCrafter, "Completing " + GetName(oTarget));
			MakeItemFromCraftingProject(status);
		} else {
			// When a DM targets a normal item, turn it into a crafting project.
			if(GetNumStackedItems(oTarget) > 1) {
				// Don't convert stacks of items - who knows what would happen. Later we might want to autmatically seperate them.
				SendMessageToPC(oCrafter, "You cannot convert a stack of items into a crafting project. Seperate one a single item first.");
			}
			SendMessageToPC(oCrafter, "Turning " + GetName(oTarget) + " into a crafting project.");
			MakeCraftingProjectFromItem(oTarget);
		}
	} else {
		// We're a (N)PC.
		if(status.isProject) {
			// Targetting a crafting project. Try to craft.
			struct CraftingProgress possible = PossibleProgress(oCrafter, status);
			int bIsNPC = GetIsDMPossessed(oCrafter);
			int highestCasterLevel = ACR_GetHighestCasterLevel(oCrafter);
			string errors;
			
			if(GetItemStackSize(oTarget) > 1)
				errors += "\nCrafting projects should not be stackable! This is a bug; please report it and ask for a refund for the stacked projects.";
			if(GetLocalInt(oCrafter, ACR_FREE_SPELL_PREP))
				errors += "\nYou must finish selecting spells before you can craft.";
			if(highestCasterLevel < status.casterLevel) 
				errors += "\nYou need a caster level of " + IntToString(status.casterLevel) + ", but your highest is " + IntToString(highestCasterLevel) + ".";
			if(GetIsInCombat(oCrafter))
				errors += "\nYou can't craft while in combat.";
			if(!GetLocalInt(oCrafter, ACR_REST_ZONE))
				errors += "\nYou must be inside a rest zone (such as an inn, home, etc.). This represents the PC having a quiet place to work with tools and other implements handy. Tents in the wilderness don't cut it.";
			if(!GetHasFeat(status.featRequired, oCrafter))
				errors += "\nYou need the feat " + GetFeatName(status.featRequired) + ".";
			if(possible.gp > GetGold(oCrafter) && !bIsNPC)
				errors += "\nYou need " + IntToString(possible.gp) + " GP.";
			if(possible.xp > XPGainedSinceLevel(oCrafter) && !bIsNPC)
				errors += "\nYou need " + IntToString(possible.xp) + " free XP.";
			if(!GetIsProjectReadyForWork(status))
				errors += "\nThe project needs additional spells imbued before any crafting can be done. See the item's description for details, and cast the indicated spells on the item.";
			
			if(errors == "") {
				// Craft!
				if(possible.xp > 0) SetXP(oCrafter, GetXP(oCrafter) - possible.xp);
				if(possible.gp > 0) TakeGoldFromCreature(possible.gp, oCrafter, TRUE);				
				
				status.gpInvested += possible.gp;
				status.xpInvested += possible.xp;
				string invested = "Invested " + IntToString(possible.gp) + " GP, " + IntToString(possible.xp) + " XP.";
				if(status.gpInvested >= status.gpTotal && status.xpInvested >= status.xpTotal) {
					MakeItemFromCraftingProject(status);
					SendMessageToPC(oCrafter, invested + " Crafting complete.");
					ACR_LogEvent(oCrafter, "Crafting", "Created " + status.name + " costing a total of " + IntToString(status.gpTotal) + " GP.");
				}
				else {
					status.spellsImbued = "";
					SaveCraftingStatus(status);
					SendMessageToPC(oCrafter, "Crafting progress made: " + invested);
				}
			} else {
				SendMessageToPC(oCrafter, "You cannot craft " + status.name + " for the following reason(s):" + errors);
				IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
			}
			
		} else {
			// Targeting something dumb.
			SendMessageToPC(oCrafter, "Use this feat to work on crafting projects. To start a crafting project, use the associated feat. Currently only Brew Potion, Craft Wand and Scribe Scroll are supported without DM aid.");
			IncrementRemainingFeatUses(oCrafter, FEAT_CRAFT);
		}
	}
}
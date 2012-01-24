#include "acr_craft_progress_i"
#include "acr_resting_i"

void main() {
	object oTarget = GetSpellTargetObject();
	
	if(GetIsDM(OBJECT_SELF)) {
		if(GetIsCraftingProject(oTarget)) {
			MakeItemFromCraftingProject(oTarget);
			SendMessageToPC(OBJECT_SELF, "Finishing the crafting project " + GetName(oTarget) + ".");
		} else {
			SendMessageToPC(OBJECT_SELF, "Turning " + GetName(oTarget) + " into a crafting project.");
			MakeCraftingProjectFromItem(oTarget);
		}
	}
	
	if(!GetIsCraftingProject(oTarget)) {
		SendMessageToPC(OBJECT_SELF, "This feat must be targeted on crafting projects. See its description for details.");
		// Restore feat use!
		return;
	}
	
	if(GetLocalInt(OBJECT_SELF, ACR_REST_ZONE) == ACR_REST_ZONE_ILLEGAL) {
		SendMessageToPC(OBJECT_SELF, "Cafting can only occur in rest areas, such as a PC's house or an inn room. Camping outdoors doesn't cut it.");
		// Restore feat use!
		return;
	}
	
	if(GetIsInCombat(OBJECT_SELF)) {
		SendMessageToPC(OBJECT_SELF, "You cannot craft while in combat!");
		return;
	}
	
	int nFeatNeeded = CraftingFeatNeeded(oTarget);
	if(!GetHasFeat(nFeatNeeded, OBJECT_SELF, TRUE)) {
		SendMessageToPC(OBJECT_SELF, "The " + GetFeatName(nFeatNeeded) + " feat is needed to craft this item.");
		return;
	}
	
	IncrementMagicalCrafting(OBJECT_SELF, oTarget);
}
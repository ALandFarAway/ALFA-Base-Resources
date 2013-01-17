#include "acr_craft_progress_i"

void main() {
	object oTarget = GetSpellTargetObject();
	object oCrafter = OBJECT_SELF;
	
	ACR_DoCrafting( oCrafter, oTarget );
}
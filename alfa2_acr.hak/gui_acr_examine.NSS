#include "acr_items_i"

void main() {
	// Get the examiner, and what they are examining.
	object oPC = OBJECT_SELF;
    object oTarget = GetPlayerCurrentTarget( oPC );
	
	// Spellcraft can reveal quite a bit about an target.
//	ACR_AttemptSpellcraftExamine( oPC, oTarget );
}

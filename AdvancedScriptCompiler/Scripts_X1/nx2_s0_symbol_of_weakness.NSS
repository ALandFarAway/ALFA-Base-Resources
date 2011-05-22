//::///////////////////////////////////////////////
//:: Symbol of Weakness
//:: nx2_s0_symbol_of_weakness.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Weakness
	Necromancy
	Level: Cleric 7, Sorceror/wizard 7
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Fortitude Negates
	Spell Resistance: Yes

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/31/2007
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ginc_symbol_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
	
	SetUpSymbol(SYMBOL_OF_WEAKNESS);
	
}
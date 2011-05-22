//::///////////////////////////////////////////////
//:: Symbol of Pain
//:: nx2_s0_symbol_of_pain.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Pain
	Necromancy[Evil]
	Level: Cleric 5, Sorceror/wizard 5
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Fortitude Negates
	Spell Resistance: Yes

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/05/2007
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
	
	SetUpSymbol(SYMBOL_OF_PAIN);
	
}
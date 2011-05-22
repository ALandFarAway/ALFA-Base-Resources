//::///////////////////////////////////////////////
//:: Symbol of Death
//:: nx2_s0_symbol_of_death.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Death
	Necromancy[Death]
	Level: Cleric 8, Sorceror/wizard 8
	Components: V, S
	Casting Time: 
	Range:60 feet
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

    SetUpSymbol(SYMBOL_OF_DEATH);
}
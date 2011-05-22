//::///////////////////////////////////////////////
//:: Symbol of Persuasion
//:: nx2_s0_symbol_of_persuasion.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Symbol of Persuasion
	Enchantment[Mind-Affecting]
	Level: Cleric 6, Sorceror/wizard 6
	Components: V, S
	Casting Time: 
	Range:
	Duration: See text
	Saving Throw: Will Negates
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
	
	SetUpSymbol(SYMBOL_OF_PERSUASION);
	
}
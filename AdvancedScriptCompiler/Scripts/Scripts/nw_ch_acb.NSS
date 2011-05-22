//::///////////////////////////////////////////////
//:: Henchmen: On Spell Cast At
//:: NW_CH_ACB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.
*/ 
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////
// ChazM - 1/26/07 - moved some shared code to ginc_behavior
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_SPELLCASTAT, SCRIPT_ASSOC_SPELL);
}    
/*
//#include "X0_INC_HENAI"
//#include "x2_i0_spells"
#include "ginc_behavior"

void main()
{
    object oCaster 		= GetLastSpellCaster();
	int nSpellID 		= GetLastSpell();
	
    if(GetLastSpellHarmful())
    {
		ReactToHarmfulSpell(oCaster, nSpellID, FALSE, TRUE); // Henchmen aren't player interruptible, they use henchman AI
    }
	
}
*/
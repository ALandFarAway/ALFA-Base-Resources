// nx_s2_mold_spirit
/*
    Spirit Eater Mold Spirit
    
Alignment: Neutral
The player gains the ability to use spirit-based crafting essences gained from Devour Spirit
in special new crafting recipes. This would be usable ability that counts as the “spell”
cast when crafting using one of the spirit recipes.
    
*/
// ChazM 4/2/07

#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
//#include "kinc_spirit_eater"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	
	// doesn't really do anything on its own.
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
}


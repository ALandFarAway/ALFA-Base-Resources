// nx_s2_malleate_spirit
/*
    Spirit Eater Malleate Spirit
    
This is the second-tier version of Mold Spirit. It’s acquired in Module E and allows
the player to craft with Pristine Spirit Essences.
    
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
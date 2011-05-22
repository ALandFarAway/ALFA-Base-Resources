// gb_assoc_userdef
/*
    Associate On User Defined
    
*/
// ChazM 2/15/07

#include "x2_inc_spellhook"
void main()
{
    int nEvent = GetUserDefinedEventNumber();

    // * If a creature has the integer variable X2_L_CREATURE_NEEDS_CONCENTRATION set to TRUE
    // * it may receive this event. It will unsommon the creature immediately
    if (nEvent == X2_EVENT_CONCENTRATION_BROKEN)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);	// cannot use NWN1 VFX
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(OBJECT_SELF));	// cannot use NWN1 VFX
        FloatingTextStrRefOnCreature(84481,GetMaster(OBJECT_SELF));
        DestroyObject(OBJECT_SELF,0.1f);
    }
}
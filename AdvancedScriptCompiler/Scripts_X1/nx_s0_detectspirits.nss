//::///////////////////////////////////////////////
//:: Detect Spirits
//:: nx_s0_detectspirits
//:://////////////////////////////////////////////
/*
    Allows the caster to sense spirit creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/14/2007
//:://////////////////////////////////////////////


#include "nwn2_inc_spells"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget  = GetSpellTargetObject();
    float fDuration = TurnsToSeconds(10);  // Fixed duration of 10 minutes
    int nDurType    = DURATION_TYPE_TEMPORARY;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    effect eDur   = EffectVisualEffect( VFX_DUR_SPELL_DETECT_SPIRITS );
    effect eSight = EffectDetectSpirits();
    effect eLink  = EffectLinkEffects(eDur, eSight);

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
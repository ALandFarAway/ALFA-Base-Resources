//::///////////////////////////////////////////////
//:: Fiendish Resilience
//:: NW_S0_FiendResl
//:://////////////////////////////////////////////
/*
    Grants the selected target 6 HP of regeneration
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 02/08/2007: Add support for Epic Fiendish Resilience

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHealAmt = 0;
    if ( GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_25, oTarget, TRUE) )
    {
        nHealAmt = 25;
    }
    else if ( GetHasFeat(FEAT_FIENDISH_RESILIENCE_5, oTarget, TRUE) )
    {
        nHealAmt = 5;
    }
    else if ( GetHasFeat(FEAT_FIENDISH_RESILIENCE_2, oTarget, TRUE) )
    {
        nHealAmt = 2;
    }
    else if ( GetHasFeat(FEAT_FIENDISH_RESILIENCE_1, oTarget, TRUE) )
    {
        nHealAmt = 1;
    }

    if ( nHealAmt > 0 )
    {
        int nDuration = 20;

        effect eRegen = EffectRegenerate(nHealAmt, 6.0);
//        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
        effect eDur = EffectVisualEffect(914);
        effect eLink = EffectLinkEffects(eRegen, eDur);

        //NO Meta-Magic Checks

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        //Apply effects and VFX
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
//        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
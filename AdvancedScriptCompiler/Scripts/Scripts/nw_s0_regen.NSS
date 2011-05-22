//::///////////////////////////////////////////////
//:: Regenerate
//:: NW_S0_Regen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the selected target 10% of Max HP of
    regeneration every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


// (Updated JLR - OEI 08/01/05 NWN2 3.5 -- Metamagic cleanup, Heal Amount change)
// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


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
    int nRegenAmt = GetMaxHitPoints(oTarget) / 10;
    if ( nRegenAmt < 1 )
    {
        nRegenAmt = 1;
    }
    effect eRegen = EffectRegenerate(nRegenAmt, 6.0);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eDur = EffectVisualEffect(VFX_DUR_REGENERATE);
    effect eLink = EffectLinkEffects(eRegen, eDur);


    float fDuration = RoundsToSeconds(10); //GetCasterLevel(OBJECT_SELF);
    //Meta-Magic Checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Apply effects and VFX
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
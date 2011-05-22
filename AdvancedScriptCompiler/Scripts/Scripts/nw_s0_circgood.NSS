//::///////////////////////////////////////////////
//:: Magic Circle Against Good
//:: NW_S0_CircGood.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 18, 2001
//:://////////////////////////////////////////////
//:: 6/68/06 - BDF-OEI: updated to use NWN2 VFX

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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL);
    //effect eVis = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);	// handled by CreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
    //effect eVis = EffectVisualEffect( VFX_DUR_SPELL_GOOD_CIRCLE );	// handled by CreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
    //effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_CIRCLE );	// handled by CreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
    //effect eEvil = EffectVisualEffect(VFX_IMP_EVIL_HELP);	// handled by CreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
    
    //effect eLink = EffectLinkEffects(eAOE, eDur);
    //eLink = EffectLinkEffects(eLink, eDur);	// no longer using NWN1 VFX

    object oTarget = GetSpellTargetObject();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, HoursToSeconds(nDuration));
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eEvil, oTarget);	// handled by CreateProtectionFromAlignmentLink(); see nw_i0_spells.nss
}
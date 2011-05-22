//::///////////////////////////////////////////////
//:: Premonition
//:: NW_S0_Premo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the gives the creature touched 30/Adamantine    
	damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

// (Update CGaw - OEI 08/22/06) -- Changed Damage Reduction

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,`
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();

    //Declare major variables
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageLimit = nCasterLevel * 10;
    int nMetaMagic = GetMetaMagicFeat();
    effect eStone = EffectDamageReduction(30, GMATERIAL_METAL_ADAMANTINE, nDamageLimit, DR_TYPE_GMATERIAL);
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	eStone = EffectLinkEffects(eStone, eVis);
	float fSpellDuration = HoursToSeconds(nCasterLevel);	
	
    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PREMONITION, FALSE));
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fSpellDuration = fSpellDuration * 2; //Duration is +100%
    }

	
    RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, fSpellDuration);
}
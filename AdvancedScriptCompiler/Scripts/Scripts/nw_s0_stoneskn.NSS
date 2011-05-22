//::///////////////////////////////////////////////
//:: Stoneskin
//:: NW_S0_Stoneskin
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the creature touched 10/Adamantine
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level (150 Max)
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001


// (Update JLR - OEI 07/22/05) -- Changed Damage Reduction

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "nw_i0_spells"
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
    effect eVis1 = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
    //effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );

    object oTarget = GetSpellTargetObject();
    int nAmount = GetCasterLevel(OBJECT_SELF) * 10;
    float fDuration = HoursToSeconds(GetCasterLevel(OBJECT_SELF));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));

    //Limit the amount protection to 100 points of damage
    if (nAmount > 150)
    {
        nAmount = 150;
    }

    //Meta Magic
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // (JLR - OEI 07/22/05) -- Changed Damage Reduction
    //Define the damage reduction effect
//    eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
    effect eStone = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, nAmount, DR_TYPE_GMATERIAL);	// JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	eStone = EffectLinkEffects( eStone, eVis1 );

    RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

    //Apply the linked effects.
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    //ApplyEffectToObject(nDurType, eVis1, oTarget, fDuration);
    ApplyEffectToObject(nDurType, eStone, oTarget, fDuration);
}
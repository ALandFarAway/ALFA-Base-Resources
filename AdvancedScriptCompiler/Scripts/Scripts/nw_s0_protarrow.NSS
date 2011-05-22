//::///////////////////////////////////////////////
//:: Protection from Arrows
//:: NW_S0_ProtArrow
//:://////////////////////////////////////////////
/*
    Gives the creature touched 10/+1 vs Ranged
    damage reduction.  This lasts for 1 minute per
    caster level or until 10 * Caster Level (100 Max)
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 21, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
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
    effect eLink;
    object oTarget = GetSpellTargetObject();
    int nAmount = GetCasterLevel(OBJECT_SELF) * 10;
    float fDuration = HoursToSeconds(GetCasterLevel(OBJECT_SELF));
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Limit the amount protection to 100 points of damage
    if (nAmount > 100)
    {
        nAmount = 100;
    }
    //Meta Magic
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Define the damage reduction effect
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PROT_ARROWS);
    effect eProt = EffectDamageReduction(10, 0, nAmount, DR_TYPE_NON_RANGED);	// JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
    //Link the effects
    eLink = EffectLinkEffects(eProt, eVis);

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemovePermanencySpells(oTarget);

    //Apply the linked effects.
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
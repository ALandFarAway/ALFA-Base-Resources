//::///////////////////////////////////////////////
//:: Least Spell Mantle
//:: NW_S0_LstSpTurn.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Absorbs 1d4 + 4 spell levels before collapsing

	Bold-faced rip-off from Lesser Spell Mantle
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/22/2006
//:://////////////////////////////////////////////
//: PKM-OEI 07.10.06 VFX pass

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
    object oTarget = GetSpellTargetObject();
    //effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);//nwn1 vfx
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);//nwn1 vfx
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_LESSER_SPELL_MANTLE);//nwn2 vfx
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nAbsorb = d4() + 4;
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nAbsorb = 8;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nAbsorb = nAbsorb + (nAbsorb/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Link Effects
    effect eAbsorb = EffectSpellLevelAbsorption(9, nAbsorb);
    //effect eLink = EffectLinkEffects(eVis, eAbsob);
    //eLink = EffectLinkEffects(eLink, eDur);
    effect eLink = EffectLinkEffects(eDur, eAbsorb);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEAST_SPELL_MANTLE, FALSE));
    RemoveEffectsFromSpell(oTarget, GetSpellId());
	RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}
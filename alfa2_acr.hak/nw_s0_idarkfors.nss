//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Dark Foresight
//:: nw_s0_idarkfors.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 12/08/05
//::////////////////////////////////////////////////
/*
        Dark Foresight  Complete Arcane, pg. 133
        Spell Level:	9
        Class:          Misc

        This is identical to the premonition spell (8th level wizard).

        Gives the gives the creature touched 30/+5
        damage reduction.  This lasts for 1 hour per
        caster level or until 10 * Caster Level
        is dealt to the person.


        [Rules Note] This is supposed to use the foresight spell, 
        which doesn't exist in NWN2. So it is mapped to an excellent spell 
        with the same sort of theme. High level wizards tend to have this 
        spell up all the time, any way, so it shouldn't unbalance the game.

*/

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "acr_spells_i" 

void main()
{
    if (!ACR_PrecastEvent())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    object oTarget = GetSpellTargetObject();

    // remove any previous effects of this spell
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Declare major variables
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nLimit = nDuration * 10;
	if ( nLimit > 150 )	nLimit = 150;
    int nMetaMagic = GetMetaMagicFeat();
    //effect eStone = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);	// 3.0 DR rules
    effect eStone = EffectDamageReduction( 10, GMATERIAL_METAL_ALCHEMICAL_SILVER, nLimit, DR_TYPE_GMATERIAL );		// 3.5 DR approximation
    //effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );	// NWN2 VFX
    
    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(eStone, eVis);
   
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PREMONITION, FALSE));
    
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    
    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

}
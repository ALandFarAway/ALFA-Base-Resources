//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Walk Unseen
//:: nw_s0_iwalkunsn.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        Complete Arcane, pg. 136
        Spell Level:	2
        Class: 		Misc

        This works like the invisibility spell (2nd level wizard) except 
        lasts up to 24 hours.

*/



// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"

#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


	//Declare major variables
    object oTarget = GetSpellTargetObject(); // Should be the caster.. 
    effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eDur     = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eLink = EffectLinkEffects(eInvis, eDur);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

    float fDuration = HoursToSeconds(24); // Hours

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);

}
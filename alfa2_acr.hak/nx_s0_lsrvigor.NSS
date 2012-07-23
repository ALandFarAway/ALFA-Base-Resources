//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_lsrVigor.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Vigor
	Conjuration (Healing)
	Level: Cleric 3, druid 3
	Components: V, S
	Range: Touch
	Target: Living creature touched
	Duration: 10 rounds + 1 round/level (max 25 rounds)
	 
	Target gains fast healing 1 for 10 rounds + 1
	round/level (max 15).
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//::	but versions of the same or greater strength will replace each other.
//
//  2008/08/30 - edits by ALFA for ACR subdual system

#include "nw_i0_spells" 
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

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRegen;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_LESSER_VIGOR );
	
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	
	if (nCasterLevel > 5)
	{
		nCasterLevel = 5;
	}

    int nBonus = 1;
    float fDuration = RoundsToSeconds(10+nCasterLevel); 

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1021, FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the bonus save effect
    eRegen = EffectRegenerate(nBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	// AFW-OEI 07/18/2007: Strip all weaker vigor effcts and replace them with this spell's effects;
	//	fizzle the spell if there is a stronger vigor effect active.
	RemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
	RemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
	if (GetHasSpellEffect(SPELL_VIGOR, oTarget) || GetHasSpellEffect(SPELL_VIGOROUS_CYCLE, oTarget))
	{
		FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}
	
	RemovePermanencySpells(oTarget);

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(nDurType, eRegen, oTarget, fDuration);
	// ALFA ACR Subdual edits
	ACR_NLD_Regen(oTarget, nBonus, GetSpellId(), 6.0);

}
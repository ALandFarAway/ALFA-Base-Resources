//::///////////////////////////////////////////////
//:: Vigor
//:: NX_s0_Vigor.nss
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
	 
	The subject gains fast healing 2, enabling it 
	to heal 2 hit points per round until the spell ends.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 06/07/2007: Spell should be single-target only.
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//::	but versions of the same or greater strength will replace each other.
//
//  2008/08/30 - ALFA ACR edit for Subdual system

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

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRegen;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_VIGOR );
	
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	
	if (nCasterLevel > 15)
	{
		nCasterLevel = 15;
	}

    int nBonus = 2;
    float fDuration = RoundsToSeconds(10+nCasterLevel); 
    
    //Set the bonus save effect
    eRegen = EffectRegenerate(nBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	//Check for metamagic
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    
	// AFW-OEI 07/18/2007: Strip all weaker vigor effcts and replace them with this spell's effects;
	//	fizzle the spell if there is a stronger vigor effect active.
	RemoveEffectsFromSpell(oTarget, SPELL_LESSER_VIGOR);
	RemoveEffectsFromSpell(oTarget, SPELL_MASS_LESSER_VIGOR);
	RemoveEffectsFromSpell(oTarget, SPELL_VIGOR);
	if (GetHasSpellEffect(SPELL_VIGOROUS_CYCLE, oTarget))
	{
		FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}
		
	//Fire cast spell at event for the specified target
   	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1020, FALSE));

	//Apply the bonus effect and VFX impact
   	ApplyEffectToObject(nDurType, eRegen, oTarget, fDuration);
	// ALFA ACR subdual edit
	ACR_NLD_Regen(oTarget, nBonus, GetSpellId(), 6.0);
}
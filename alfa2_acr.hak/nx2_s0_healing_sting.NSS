//::///////////////////////////////////////////////
//:: Healing Sting
//:: nx2_s0_healing_sting.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Healing Sting
	Necromancy
	Level: Druid 2
	Components: V, S
	Range: Touch
	Targets: You and one living creature
	Saving Throw: None
	Spell Resistance: Yes
	 
	Focusing the power of negative energy, you deal 1d12 points of damage +1 per caster level 
	(maximum 1d12+10) to a living creature and gain and equal amount of hit points if you make a successful melee touch attack.  
	A healing sting cannot give you more hit points than your full normal total.  
	Excess hit points are lost.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//
//  2008/08/30 - ALFA edit for ACR Subdual

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x0_i0_match"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	// Caster level
	int nCasterLevel		= GetCasterLevel(oCaster);
	if(nCasterLevel > 10)
		nCasterLevel = 10;
	// Effects
	int nDamage				= d12(1) + nCasterLevel;
	effect eDamage 			= EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
	int nHeal				= nDamage;
	int nMaxHP 				= GetMaxHitPoints(oCaster);
	int nCurrentHP			= GetCurrentHitPoints(oCaster);
	if(nHeal + nCurrentHP > nMaxHP)
		nHeal = nMaxHP - nCurrentHP;
	effect eHeal			= EffectHeal(nHeal);
	effect eVisual			= EffectVisualEffect(VFX_HIT_SPELL_HEALING_STING);
	effect eVisual2			= EffectVisualEffect(VFX_HEAL_SPELL_HEALING_STING);
	effect eLink			= EffectLinkEffects(eVisual, eDamage);
	eLink			= EffectLinkEffects(eVisual2, eHeal);
	
	// Make sure spell target is valid and living
	if (GetIsObjectValid(oTarget) && !MatchNonliving(GetRacialType(oTarget)))
	{
		// check to see if hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
			// ALFA ACR edit for Subdual
			ACR_NLD_HealNLD(oCaster, nHeal);
			//Fire cast spell at event for the specified target
  			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
}
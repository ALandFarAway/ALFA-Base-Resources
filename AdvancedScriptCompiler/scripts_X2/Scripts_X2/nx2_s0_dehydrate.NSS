//::///////////////////////////////////////////////
//:: Dehydrate
//:: nx2_s0_dehydrate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Dehydrate
	Necromancy
	Level: Druid 3
	Components: V, S
	Range: Medium
	Target: One living creature
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	 
	You afflict the target with a horrible, dessicating curse that deals 1d6 points of Constitution damage, plus 1 additional point of Constitution damage per three caster levels, to a maximum of 1d6+5 at 15th level.  
	Oozes and plants are more susceptible to this spell than other targets.  
	Such creatures take 1d8 points of Constitution damage plus 1 additional point of Constitution damage per three caster levels to a maximim of 1d8+5.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/29/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/22/2008: Added SR and Fortitude checks
//:: RPGplayer1 11/22/2008: Made Constitution damage stack
//:: RPGplayer1 12/22/2008: Constitution damage changed to Extraordinary (to prevent dispelling)

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
	object oTarget		= GetSpellTargetObject();
	object oCaster		= OBJECT_SELF;
	// Get caster level
	int nCasterLevel	= GetCasterLevel(oCaster);
	// check if plant or ooze
	int bSpecialCase;
	if(	GetClassByPosition(1, oTarget) == 35 
		|| GetClassByPosition(2, oTarget) == 35 
		|| GetClassByPosition(3, oTarget) == 35 
		|| GetRacialType(oTarget) == RACIAL_TYPE_OOZE)
			bSpecialCase 	= TRUE;
	// Cap caster level
	if(nCasterLevel > 15)
		nCasterLevel	= 15;
	if(bSpecialCase)
		nCasterLevel	= 12;
	//calculate extra damage
	int nExtraDamage;
	if(bSpecialCase)
		nExtraDamage 	= (nCasterLevel/3) + 1;
	else 
		nExtraDamage	= (nCasterLevel/3);
	// Effects
	int nDamage;
	if(bSpecialCase)
		nDamage = d8(1) + nExtraDamage;
	else 
		nDamage = d6(1) + nExtraDamage;
	nDamage = ApplyMetamagicVariableMods(nDamage, (bSpecialCase?8:6)+nExtraDamage);
	
	effect eDamage		= EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage);
	eDamage			= SetEffectSpellId(eDamage, -1); // set to invalid spell ID for stacking
	eDamage			= ExtraordinaryEffect(eDamage);
	effect eHit			= EffectVisualEffect(VFX_HIT_SPELL_DEHYDRATION);
	effect eLink		= EffectLinkEffects(eHit, eDamage);

	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		RemoveEffectsFromSpell(oTarget, GetSpellId());
		// check to see if hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
		{
			if (!MyResistSpell(oCaster, oTarget) && !FortitudeSave(oTarget, GetSpellSaveDC()))
			{
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			}
				//Fire cast spell at event for the specified target
	    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
}
//::///////////////////////////////////////////////
//:: Castigate
//:: nx2_s0_castigate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Castigate
	Evocation [Sonic]
	Level: Cleric 4, paladin 4
	Components: V
	Range: 10 ft.
	Area: 10-ft.-radius burst centered on you
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	 
	All creatures whose alignment differs from yours on both the law-chaos and good-evil axes take 1d4 points of 
	damage per caster level (maximum 10d4).  All creatures who alignment differs from yours 
	on one component take half damage, and this spell does not deal damage to those who share your alignment. 
	 
	For example, a lawful good cleric who casts this spell deals full damage to any creature that is not 
	lawful and not good, half damage to any creature that is lawful or good (but not both), and no 
	damage to lawful good creatures.
	 
	A fortitude saving throw reduces damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/04/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/22/2008: Added SR check
//:: RPGplayer1 12/22/2008: No need for save, if same alignment

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	// Get necessary objects
	object oCaster		= OBJECT_SELF;
	location lTarget	= GetLocation(oCaster);
	// Get caster level and alignment
	int nCasterLevel	= GetCasterLevel(oCaster);
	int nGoodEvil		= GetAlignmentGoodEvil(oCaster);
	int nLawChaos		= GetAlignmentLawChaos(oCaster);
	// Cap caster level
	if(nCasterLevel > 10)
		nCasterLevel	= 10;
	int nDamage;
	// Effects
	effect eDamage;
	effect eHit			= EffectVisualEffect(VFX_HIT_SPELL_CASTIGATE);
	effect eVisual		= EffectVisualEffect(VFX_AOE_SPELL_CASTIGATE);
	effect eLink;
	int nSaved;

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual, lTarget);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	// Make sure spell target is valid
	while (GetIsObjectValid(oTarget))
	{
		// check to see if hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
		{
			// initial damge
			nDamage = d4(nCasterLevel);
			nDamage = ApplyMetamagicVariableMods(nDamage, nCasterLevel * 4);
			
			// no difference in alignment, no damage
			if(GetAlignmentGoodEvil(oTarget) == nGoodEvil && GetAlignmentLawChaos(oTarget) == nLawChaos)
			{
				nDamage = 0;
			}
			// if differing from caster on one axis, half damage
			else if(GetAlignmentGoodEvil(oTarget) == nGoodEvil || GetAlignmentLawChaos(oTarget) == nLawChaos)
			{
				nDamage = nDamage/2;
			}
			// if differing from caster on both axis', full damage
			else
			{
				//no change needed
			}
			
			if (nDamage > 0 && !MyResistSpell(oCaster, oTarget))
			{
			// get saving throw
			nSaved = FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCaster);
			
			// spell resisted
			if(nSaved == 2)
			{
				//congratulations
			}
			//succesful saving throw
			else if(nSaved == 1)
			{
				nDamage = nDamage/2;
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
				eLink = EffectLinkEffects(eHit, eDamage);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				//Fire cast spell at event for the specified target
		    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			}
			// fail
			else if(nSaved == 0)
			{
				eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
				eLink = EffectLinkEffects(eHit, eDamage);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				//Fire cast spell at event for the specified target
		    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	}
}
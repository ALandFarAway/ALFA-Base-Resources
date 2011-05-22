// nx_s1_demilich_touch
//
// Demilich touch attack.
//
// JSH-OEI 6/21/07

#include "ginc_item"
#include "NW_I0_SPELLS"

void main()
{
	object oTarget		= GetSpellTargetObject();
		
	int nChaModifier	= GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int nHD				= GetTotalLevels(OBJECT_SELF, TRUE);
	int nDuration		= 5; // 5 rounds
	int nSaveDC			= (10 + nChaModifier + nHD);
	int nDamageAmt		= d6(10) + 20;
	
	effect eDamage		= EffectDamage(nDamageAmt, DAMAGE_TYPE_NEGATIVE);
	effect eHit 		= EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	
	effect eParalyze	= EffectParalyze(SAVING_THROW_FORT, FALSE);
	effect eVisual		= EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink		= EffectLinkEffects(eParalyze, eVisual);
	eLink				= ExtraordinaryEffect(eLink);
	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	
	// If target fails the Fortitude save
	if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE))
	{
		PrettyDebug("Charisma modifier is " + IntToString(nChaModifier) + ".");
		PrettyDebug("DC is " + IntToString(nSaveDC) + ".");
		PrettyDebug("Target is paralyzed for " + IntToString(nDuration) + " rounds.");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    } 
}
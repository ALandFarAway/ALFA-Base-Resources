// nx_s1_disruption
//
// Disruption property: undead must make a DC 14 Will save or be destroyed. This is meant
// to be applied to blunt weapons only.
//
// JSH-OEI 6/26/07

#include "NW_I0_SPELLS"

void main()
{
	object oTarget	= GetSpellTargetObject();
	effect eDisrupt	= EffectDeath(FALSE, TRUE, TRUE);
	effect eHit		= EffectNWN2SpecialEffectFile("sp_holy_hit");
	int nSaveDC		= 14;

	// Disruption has no effect against non-undead
	if (GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
		return;
		
	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDisrupt, oTarget);
    } 
}
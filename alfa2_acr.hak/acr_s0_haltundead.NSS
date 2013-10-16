//::///////////////////////////////////////////////
//	Halt Undead
//	Created by Riotnrrd for ALFA
//	02 / 2009	

#include "nwn2_inc_spells"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"
#include "acr_creature_i"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds(nCasterLvl);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
	int nSaveDC = GetSpellSaveDC();
	int nTargets = 3;
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HOLD_MONSTER);
	effect eLink = EffectLinkEffects(EffectPetrify(), eVis);

    //Do metamagic checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && (nTargets > 0))
    {
		if ((spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
			&& (ACR_GetIsUndead(oTarget)))	{
			nTargets -= 1;
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			if(!MyResistSpell(OBJECT_SELF, oTarget))
			{
				// Only Intelligent undead get to make a save, defined here as INT less than 5
				if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 5)
				{
					ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
				}
				else if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
				{
					ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}
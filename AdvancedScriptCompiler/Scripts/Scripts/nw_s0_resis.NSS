//::///////////////////////////////////////////////
//:: Resistance
//:: NW_S0_Resis
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: This spell gives the recipiant a +1 bonus to
//:: all saves.  It lasts for 1 Turn.
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/12/01
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: Aug 7, 2001
//:: AFW-OEI 07/18/2007: Does not stack with Greater or Superior Resistance.


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
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
    effect eSave;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_RESISTANCE );

    int nBonus = 1; //Saving throw bonus to be applied
    float fDuration = TurnsToSeconds(2); // Turns

	// AFW-OEI 07/18/2007: Does not stack with Greater or Superior Resistance.
	if (GetHasSpellEffect(SPELL_GREATER_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget))
	{
		FloatingTextStrRefOnCreature( STR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}

	    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESISTANCE, FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the bonus save effect
    eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
	eSave = EffectLinkEffects( eSave, eVis );

    RemovePermanencySpells(oTarget);

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(nDurType, eSave, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
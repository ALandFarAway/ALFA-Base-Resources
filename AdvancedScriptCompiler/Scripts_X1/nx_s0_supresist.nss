//::///////////////////////////////////////////////
//:: Resistance, Superior
//:: NX_s0_supresist.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	Resistance, Superior
	Abjuration
	Level: Bard 6, cleric 6, druid 6, sorceror/wizard 6
	Components: V, S
	Range: Touch
	Target: Creatue Touched
	Duration: 24 hours
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes (harmless)
	 
	You grant the subject a +6 bonus on all saves.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills, based on nw_s0_resis (1.12.01 Aidan Scanlan)
//:: Created On: 11.29.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Replaces Resistance and Greater Resistance.

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
    effect eSave;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_SUPERIOR_RESISTANCE );

    int nBonus = 6; //Saving throw bonus to be applied
    float fDuration = HoursToSeconds(24); 

	// AFW-OEI 07/18/2007: Replaces Resistance and Greater Resistance.
	RemoveEffectsFromSpell(oTarget, SPELL_RESISTANCE);
	RemoveEffectsFromSpell(oTarget, SPELL_GREATER_RESISTANCE);
	
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUPERIOR_RESISTANCE, FALSE));

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
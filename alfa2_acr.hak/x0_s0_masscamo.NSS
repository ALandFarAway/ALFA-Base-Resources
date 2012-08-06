//::///////////////////////////////////////////////
//:: Mass Camoflage
//:: x0_s0_masscamo.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    +10 hide bonus to all allies in area
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: RPGplayer1 01/31/2009:
//::  Should not stack with Camoflage
//::  Will affect area around target, not the caster

#include "X0_I0_SPELLS"

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    effect eVis = EffectVisualEffect( 631 );	// NWN2 VFX: VFX_DUR_SPELL_CAMOFLAGE
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);
    effect eLink = EffectLinkEffects(eHide, eVis);

    float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF) * 10);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) || GetFactionEqual(oTarget))
    	{
            RemoveEffectsFromSpell(OBJECT_SELF, SPELL_CAMOFLAGE);

            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oTarget, 454, FALSE));
            ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    }

}







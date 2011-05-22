//::///////////////////////////////////////////////
//:: Warpriest Fear Aura
//:: NW_S2_WPFearAura
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
// The Warpriest "bursts" a fear aura, causing all
// enemies within 20' to suffer the effects of a fear
// spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"   
#include "x0_i0_spells"
 
void main()
{
    //Declare major variables
    //effect eVis    = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eFear   = EffectFrightened();
    effect eDur    = EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
	effect eVis		= EffectVisualEffect( VFX_HIT_CURE_AOE );
    //effect eDur2   = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    //effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_MIND);

    effect eLink = EffectLinkEffects(eFear, eDur);
    //eLink = EffectLinkEffects(eLink, eDur2);
    
    float fDelay;
	int nLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);
    int nDC = 10 + nLevel + GetAbilityModifier(ABILITY_CHARISMA);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
    	if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{
            fDelay = GetDistanceToObject(oTarget)/10;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WARPRIEST_FEAR_AURA));

            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
	           //Make a saving throw check
	            if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
	            {
	                //Apply the VFX impact and effects
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nLevel)));
	                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	            }
			}
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(OBJECT_SELF));
    }
}
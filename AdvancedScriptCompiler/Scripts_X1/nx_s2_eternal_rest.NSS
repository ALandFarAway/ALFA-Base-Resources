// nx_s2_eternal_rest
/*
    Spirit Eater Eternal Rest Feat
    
Eternal Rest
Alignment: Good; Eternal Rest shifts alignment 2 points towards Good.
For one use of Devour Spirit, the PC may perform essentially the same function as Devour Spirit, but on undead 
creatures, feeding upon the negative energy that animates them. This ability causes no corruption.
Eternal Rest has potential to have interesting story implications with the undead companion, but that would be 
up to George to explore.
   
*/
// ChazM 2/23/07
// ChazM 4/2/07 - Eternal Rest no longer gives corruption penalty.
// ChazM 4/12/07 VFX/string update
// MDiekmann 7/3/07 - modified to meet new description
// MDiekmann 7/5/07 - various fixes for new implementation
// MDiekmann 7/13/07 - addition of Ravenous Incarnation to cooldown and other minor fixes

#include "kinc_spirit_eater"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster 	= OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();
   
	//if we have already attempted to devour said soul, give back use, inform user
	if (GetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED))
    {   
		ResetFeatUses(oCaster, FEAT_ETERNAL_REST, FALSE, TRUE);
		PostFeedbackStrRef(oCaster, STR_REF_MULTIPLE_DEVOUR);
        return;
    }
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
        && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        && GetIsUndead(oTarget)
        )
    {
		// sets up cooldown timer for devour abilities
		ResetFeatUses(oCaster, FEAT_ETERNAL_REST, FALSE, TRUE);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SOUL);
		DecrementRemainingFeatUses(oCaster, FEAT_SPIRIT_GORGE);
		DecrementRemainingFeatUses(oCaster, FEAT_ETERNAL_REST);
		DecrementRemainingFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		
		// Visual effect on caster
	    effect eVis = EffectVisualEffect(VFX_CAST_SPELL_BESTOW_LIFE);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
        // alignment shift: good, 2 point
        AdjustAlignment(oCaster, ALIGNMENT_GOOD, 2);
        DoDevour(oTarget, FALSE, VFX_HIT_SPELL_ETERNAL_REST); // no corruption penalty for Eternal Rest
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
		
		// Set flag showing a devour ability has been used
		SetGlobalInt(VAR_SE_HAS_USED_DEVOUR_ABILITY, TRUE);
		
		// Set local flag showing that a devour has been attempted
		SetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED, TRUE);
		
		// Clear out uses of suppress since it can no longer be used this day
		if(GetHasFeat(FEAT_SUPPRESS))
		{
			int nCount;
			for(nCount = 0; nCount < 10; nCount++)
			{
				DecrementRemainingFeatUses(oCaster, FEAT_SUPPRESS);
			}
			ResetFeatUses(oCaster, FEAT_SUPPRESS, FALSE, TRUE);
		}
    }
    else
    {   // used on invalid target, so abort and give back.
        PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
		ResetFeatUses(oCaster, FEAT_ETERNAL_REST, FALSE, TRUE);
        return;
    }
}
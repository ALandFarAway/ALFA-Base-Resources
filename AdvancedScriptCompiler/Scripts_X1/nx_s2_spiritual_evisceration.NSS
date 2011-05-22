// nx_s2_spiritual_evisceration
/*
    Spirit Eater Spiritual Evisceration Feat
    
This is an ultimate spirit-eater power acquired when the PC defeats Akachi in the
dreamscape in Module Z and chooses to embrace the evil of the curse. It's capable
of one-shotting any mortal creature and should be an insta-kill power. As this is
only acquired at the end of the game, only the companions (most of whom turn on
the player if he goes the evil route) are the viable targets.

Visual Effect: This should be appropriately impressive for an ultimate power and
the player should feel really cool when obliterating his traitorous companions.
   
*/
// ChazM 5/3/07
// ChazM 5/24/07 VFX update/Signal event
// ChazM 7/18/07 - fix constant VFX_CAST_SPELL_SPIRITUAL_EVISCERATION

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
   
    //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
    //    && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	//	)
	// works on any creature.
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
		// Visual effect on caster
	    effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_SPIRITUAL_EVISCERATION);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
		
        DoSpiritualEvisceration(oTarget);
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
    }
    else
    {   // used on invalid target, so abort and give back.
        PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
		// this has infinite uses, so no need to give back.
        // IncrementRemainingFeatUses(OBJECT_SELF, FEAT_SPIRITUAL_EVISCERATION);
        return;
    }
}
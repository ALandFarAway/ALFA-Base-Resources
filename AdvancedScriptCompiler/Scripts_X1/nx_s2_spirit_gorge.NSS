// nx_s2_spirit_gorge
/*
    Spirit Eater Spirit Gorge Feat
    
Spirit Gorge
Limitations: Costs 1 use of Devour Spirit
Alignment: Evil; Spirit Gorge shifts alignment 2 points towards Evil.
This ability is nothing more than Devour Spirit with area of effect. Like Devour Spirit, if the player has 
the ability Devour Soul, Spirit Gorge can be used on humanoids.
The amount of spirit energy regained is calculated as Devour Spirit, except that the kill bonus he gets accumulates. 
So if he kills two creatures, each at 10% HP with the attack, he regains the 5% baseline plus the 20% he drained 
off of the two creatures.
Spirit Gorge causes more corruption than Devour Spirit. If the player is between stages 0 and 2, it causes the 
same amount of corruption as the equation we use for Devour Spirit + 10%. After that it causes no corruption 
because it’s done out of necessity (just as no corruption is caused by Devour Spirit after stage 1), though 
the alignment shift will still occur.
    
*/
// ChazM 2/23/07
// ChazM 4/12/07 VFX/string update
// MDiekmann 6/8/07 - updated to not change alignment unless a target is devoured
// MDiekmann 7/3/07 - modified to meet new description
// MDiekmann 7/5/07 - various fixes for new implementation
// MDiekmann 7/13/07 - addition of Ravenous Incarnation to cooldown

#include "kinc_spirit_eater"
#include "x2_inc_spellhook"


void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    
    object oCaster 	= OBJECT_SELF;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
	int bHitATarget = FALSE;
	 
	// Visual effect on caster
    effect eVis = EffectVisualEffect(VFX_CAST_SPELL_SPIRIT_GORGE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
        
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
        
            if ( (GetIsSpirit(oTarget) && GetHasFeat(FEAT_DEVOUR_SPIRIT_1))
                || (GetIsSoul(oTarget) && GetHasFeat(FEAT_DEVOUR_SOUL)) )

            {
				//if we have already attempted to devour said soul inform user
				if (GetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED))
    			{   
					PostFeedbackStrRef(oCaster, STR_REF_MULTIPLE_DEVOUR);
        	    }
				else
				{
               		DoDevour(oTarget, TRUE, VFX_HIT_SPELL_SPIRIT_GORGE);
			    	//Fire cast spell at event for the specified target
			    	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
					bHitATarget = TRUE;
					
					// Set local flag showing that a devour has been attempted
					SetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED, TRUE);
				}
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	
	// if we devoured something
	if(bHitATarget)
	{
    	// sets up cooldown timer for devour abilities
		ResetFeatUses(oCaster, FEAT_SPIRIT_GORGE, FALSE, TRUE);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SOUL);
		DecrementRemainingFeatUses(oCaster, FEAT_SPIRIT_GORGE);
		DecrementRemainingFeatUses(oCaster, FEAT_ETERNAL_REST);
		DecrementRemainingFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		
		// Set flag showing a devour ability has been used
		SetGlobalInt(VAR_SE_HAS_USED_DEVOUR_ABILITY, TRUE);
	
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
	{
		PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
		ResetFeatUses(oCaster, FEAT_SPIRIT_GORGE, FALSE, TRUE);
	}
}
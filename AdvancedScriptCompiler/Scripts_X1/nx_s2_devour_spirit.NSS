// nx_s2_devour_spirit
/*
    Spirit Eater Devour Spirit Feat
    
Devour Spirit
Limitations: 1 use/day, potentially increasing to 2 or 3 uses/day based on story events.
This is the spirit-eater’s bread and butter. It will be the primary method with which the PC will be able to 
replenish spirit energy and stave off his affliction. It will be the first ability he receives.
Devour Spirit allows the player to consume “spirits” per the spirit shaman definition. 
The ability causes a fixed amount of damage to its target. This will start at 15% of a creature’s Max HP. 
(A percentage allows the player to “eyeball” whether he will be able to do a successful devour or not. 
It also gives incentive to attempt a devour on tougher creatures.) The player regains 5% of his spirit energy 
as a baseline, and if he kills the target with his devour attack, he gains a bonus percentage equivalent to the 
percent of HP he drained from the creature. This means he may gain 5 – 20% of his spirit energy back with Devour Spirit.
We might allow the player to upgrade this to a higher percentage as a quest reward. Should the attack fail to 
kill the target, the player will receive a small amount of spirit energy. Should it succeed, the player will 
receive a bonus to his spirit energy based on how many HP were drained off of the target before it died. The player’s 
goal is to attack the target at a point where he thinks he will be able to do the maximal amount of damage and kill 
the target.
The use limitation is important because it gives impact to the use of the power. At 1 use/day, the player may be in 
a much more severe state of affliction by the time he gets to use his power again, so making good use of Devour Spirit 
is critical to the PC’s state.
Those role-playing a good character would want to use this power a little as possible. Evil characters will want to 
use it frequently, sometimes just for its destructiveness in combat. As such, we will increase the PC’s level of 
corruption if this ability is used with a relatively full spirit energy level. Using it out of necessity will not 
have this effect.
Corruption will be represented in our game as a rate of decay of spirit energy. It starts at 100% of the baseline 
outlined in the Affliction section. For our initial implementation, use of Devour Spirit in stage 1 or later will 
not cause corruption. If it’s done while in stage 0, we use the following formula to determine the percentage value 
to add to current corruption:
			(100 – p) / 4
where p is the percent of current progress of the affliction from stage 0 to stage 1. Worst case, the player adds 
25% corruption if he devours a spirit while he has a completely full reserve of spirit energy.
In order to avoid a situation in which the player loses some of the value of this ability due to his companions 
hammering on the enemy to be devoured after the player has chosen to cast the spell, we will need to script it 
such that the player is awarded spirit energy based on the creature’s HP at the time the player targeted it with 
Devour Soul. We will store that HP value as a variable at conjure time that gets queried at impact time. Further, 
Devour Spirit will automatically issue a shout command that tells companions to either find another target, or, if 
none is available, to stand aside.
Devouring a spirit may cause it to drop a new kind of spirit-based crafting essence.
   
*/
// ChazM 2/23/07
// ChazM 4/5/07 - track use count
// ChazM 4/12/07 VFX/string update
// MDiekmann 7/3/07 - modified to meet new description
// MDiekmann 7/5/07 - various fixes for new implementation
// MDiekmann 7/13/07 - addition of Ravenous Incarnation to cooldown

#include "kinc_spirit_eater"
#include "nwn2_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ginc_vars"

// this accounts for Akachi and all his clones
const string TAG_AKACHI_PREFIX = "z_akachi";
const int AKACHI_PREFIX_LENGTH = 8;

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster 	= OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();
   
	//if we have already attempted to devour said spirit, give back use, inform user
	if (GetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED) && GetStringLeft(GetTag(oTarget),AKACHI_PREFIX_LENGTH) != TAG_AKACHI_PREFIX)
    {  
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1, FALSE, TRUE);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_2, FALSE, TRUE);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_3, FALSE, TRUE);
		IncrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
        PostFeedbackStrRef(oCaster, STR_REF_MULTIPLE_DEVOUR);
        return;
    }
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)
        && (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        && GetIsSpirit(oTarget)
        )
    {	
		// sets up cooldown timer for devour abilities
		//ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1, FALSE, TRUE);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SOUL);
		DecrementRemainingFeatUses(oCaster, FEAT_SPIRIT_GORGE);
		DecrementRemainingFeatUses(oCaster, FEAT_ETERNAL_REST);
		DecrementRemainingFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		IncrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		
		// Visual effect on caster
	    effect eVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
		
        // no alignment shift
        DoDevour(oTarget);
		
		ModifyGlobalInt(VAR_SE_USE_COUNT_DEVOUR_SPIRIT, 1);
		
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
        IncrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1, FALSE, TRUE);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_2, FALSE, TRUE);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_3, FALSE, TRUE);
        return;
    }
}
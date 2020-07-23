//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song of Freedom
//:: nw_s2_sngfreedm.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Song of Freedom (Req: 12th level, Perform 15): 
    At 12th level a bard gains this ability which allows them to do the 
    equivalent of a Break Enchantment spell, with the caster level being 
    equal to the bard's spell level.


        Break Enchantment
        Abjuration
        Level: 	Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5
        Components: 	    V, S
        Casting Time: 	    1 minute
        Range: 	            Close (25 ft. + 5 ft./2 levels)
        Targets: 	        Up to one creature per level, all within 30 ft. of each other
        Duration: 	        Instantaneous
        Saving Throw: 	    See text
        Spell Resistance: 	No

        This spell frees victims from enchantments, transmutations, and curses. 
        Break enchantment can reverse even an instantaneous effect. For each 
        such effect, you make a caster level check (1d20 + caster level, 
        maximum +15) against a DC of 11 + caster level of the effect. Success 
        means that the creature is free of the spell, curse, or effect. For a 
        cursed magic item, the DC is 25.

        If the spell is one that cannot be dispelled by dispel magic, break 
        enchantment works only if that spell is 5th level or lower.

        If the effect comes from some permanent magic item break enchantment 
        does not remove the curse from the item, but it does frees the victim 
        from the items effects. 

*/
//:://////////////////////////////////////////////////////////////////////////
//:: PKM-OEI 07.13.06 VFX Pass
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check


#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "acr_bard_i"


void main()
{
    if ( GetHasEffect(EFFECT_TYPE_SILENCE, OBJECT_SELF) )
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }


//    if(!AttemptNewSong(OBJECT_SELF))
//    {
//        return;  // Failed
//    }


    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }
	
	int		nPerform	= GetPerformRanks(OBJECT_SELF);;
	 
	if (nPerform < 15 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

    //Declare major variables
    string sTag = GetTag(OBJECT_SELF);
    int nLevel  = GetLevelByClass(CLASS_TYPE_BARD);
    int nRanks  = GetSkillRank(SKILL_PERFORM);
    int nChr    = GetAbilityModifier(ABILITY_CHARISMA);
	location lTarget = GetSpellTargetLocation();
	


    effect eBreakOther  = EffectBreakEnchantment( nLevel );
    effect eVisOther    = EffectVisualEffect( VFX_HIT_BARD_SONG_FREEDOM );
    effect eLinkOther   = EffectLinkEffects( eVisOther, eBreakOther );

    //effect eBreakBard   = EffectBreakEnchantment( nLevel );
    //effect eVisBard     = EffectVisualEffect( VFX_DUR_SPELL_GREATER_SPELL_BREACH ); 
    //effect eLinkBard    = EffectLinkEffects( eVisBard, eBreakBard );

 
    eLinkOther = ExtraordinaryEffect(eLinkOther);
    //eLinkBard = ExtraordinaryEffect(eLinkBard);

 	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);


    while(GetIsObjectValid(oTarget))
    {		
        if(!GetHasFeatEffect(FEAT_BARD_SONGS, oTarget) && !GetHasSpellEffect(GetSpellId(),oTarget))
        {
             // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
             if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
             {
                if(oTarget == OBJECT_SELF)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkOther, oTarget);
                }
                else if(spellsIsTarget( oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
                {
                    float fDist = GetDistanceBetween( OBJECT_SELF, oTarget );
                    float fDelay = fDist * 0.15;
                    DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkOther, oTarget) );
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);

    }
	
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}

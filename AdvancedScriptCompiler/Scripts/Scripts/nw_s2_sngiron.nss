//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Ironskin Chant
//:: nw_s2_sngiron.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/09/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Ironskin Chant (Req: 9th level, Perform 12): As a round action the player 
    can expend one daily uses of his bardic music ability to provide damage 
    reduction 5/- to the party for 4 rounds.

        [Rules Note] This is a Bardic Music feat from Complete Adventurer pg.113. 
        This is granted as a class ability instead of a feat and it differs 
        in several respects. It is a full round action to activate instead of 
        a swift action (which don't exist in NWN2), the duration is 2 rounds 
        instead of a single round, and it affects the entire party of 4 
        instead of one person. In real-time having such a short targeted 
        effect would be cumbersome for the user, so it's made simple.

*/
//:://////////////////////////////////////////////////////////////////////////
//:: PKM-OEI 07.13.06 VFX Pass
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check



#include "x0_i0_spells"
#include "nwn2_inc_spells"

void main()
{
	if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(	
	}

    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }

    //Declare major variables
    int nDuration       = ApplySongDurationFeatMods( 4, OBJECT_SELF ); // Rounds
    float fDuration 	= RoundsToSeconds(nDuration);

//    effect eDmgResist   = ExtraordinaryEffect( EffectDamageResistance( 5 , DAMAGE_TYPE_ALL, 0 ) );
    effect eDmgResist   = ExtraordinaryEffect( EffectDamageReduction( 5, 0, 0, DR_TYPE_NONE) );
    effect eDur         = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_BARD_SONG_IRONSKIN ) );
    effect eLink        = ExtraordinaryEffect( EffectLinkEffects( eDmgResist, eDur ) );
	int    nPerform     = GetSkillRank(SKILL_PERFORM);

    if (nPerform < 12 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}
	
//	if(AttemptNewSong(OBJECT_SELF))
    {
        ApplyFriendlySongEffectsToParty( OBJECT_SELF, GetSpellId(), fDuration, eLink );
	    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}
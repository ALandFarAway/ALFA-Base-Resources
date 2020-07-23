//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Countersong
//:: nw_s2_sngcountr.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*

	Countersong (Req: Perform 3): This song puts a buff on the targeted ally 
    that lasts for 10 rounds or until discharged. Any hostile magic spell 
    that would affect the countersong's target has to make a Spell Resistance 
    check of 10 + levels of bard the singer possesses. Whether the spell is
    blocked or not, the counter-song is discharged.

*/
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check
//:: PKM-OEI 07.30.06 VFX update



#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "acr_bard_i"


void main()
{
	//SpeakString("nw_s2_SngCountr: Entering spell script");

	if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(	
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
	 
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}


    //Declare major variables
	object oTarget = GetSpellTargetObject();


	if ( GetIsObjectValidSongTarget( oTarget ) )
	{
    	int 	nLevel 		= GetLevelByClass(CLASS_TYPE_BARD);
	    int 	nDuration 	= ApplySongDurationFeatMods( 10, OBJECT_SELF ); // Rounds
	    float 	fDuration 	= RoundsToSeconds( nDuration ); // Seconds

	    effect 	eResist   	= ExtraordinaryEffect( EffectSpellResistanceIncrease( 10 + nLevel, 1 ) );
	    effect 	eDur        = ExtraordinaryEffect( EffectVisualEffect( VFX_HIT_BARD_COUNTERSONG ) );
	    effect 	eLink       = ExtraordinaryEffect( EffectLinkEffects( eResist, eDur ) );

		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
    }

    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
	
	//SpeakString("nw_s2_SngCountr: Exiting spell script");
}

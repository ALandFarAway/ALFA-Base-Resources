//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Cloud Mind
//:: nw_s2_sngcldmnd.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/19/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Haven Song (Req: 3rd level, Perform 6): This song works like the Sanctuary 
    spell except the saving throw is a Will save against a DC of 11 + ( Perform / 2)
    and its duration is 10 rounds or until the bard does a hostile action. 
    The Fascinate and Cloud Mind songs do not count as hostile actions.

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
	if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(	
	}

//    if(!AttemptNewSong(OBJECT_SELF))  //, TRUE))
//    {
//        return;  // Failed
//    }

    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }

   	int 	nLevel 		= GetLevelByClass(CLASS_TYPE_BARD);
	int 	nDuration 	= ApplySongDurationFeatMods( 10, OBJECT_SELF ); // Rounds
	float 	fDuration 	= RoundsToSeconds( nDuration ); // Seconds
	int 	nBreakFlags	= MESMERIZE_BREAK_ON_ATTACKED; // + MESMERIZE_BREAK_ON_NEARBY_COMBAT;
	float	fBreakDist	= 90.0; // Units? 
	int		nPerform	= GetPerformRanks(OBJECT_SELF);;
    int     nSpellDC    = 11 + (nPerform/2);
    
    //effect 	eImpact 	= EffectVisualEffect( 259 ); // TEMP VISUAL EFFECT
	effect 	eMesmerized	= EffectMesmerize( nBreakFlags, fBreakDist );
	effect eDur = EffectVisualEffect( VFX_HIT_BARD_CLOUDMIND );
	effect eLink = EffectLinkEffects ( eMesmerized, eDur );

	if (nPerform < 9 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

	int nAffectedCreature = 0;

	object oTarget = GetSpellTargetObject();

    if (GetIsObjectValid(oTarget))
    {
		if ( GetIsObjectValidSongTarget( oTarget ) )
		{
			//if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
			if ( GetIsEnemy( oTarget ) )
            {
                // Make a Will save against a DC of 11 + ( Perform / 2)
                int nSave = WillSave( oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS , OBJECT_SELF );
                if ( nSave == 0 )
                {
                    //ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration ); 
                }
			}
		}
	}

    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}

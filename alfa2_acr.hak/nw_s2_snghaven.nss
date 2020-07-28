//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Haven Song
//:: nw_s2_snghaven.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/12/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*

    Haven Song (Req: 3rd level, Perform 6)
    This song works like the Sanctuary spell except the saving throw is a 
    Will save against a DC of 11 + ( Perform / 2) and its duration is 
    10 rounds or until the bard does a hostile action. The Fascinate and
    Cloud Mind songs do not count as hostile actions.

*/
//:: PKM-OEI 07.13.06 VFX Pass
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check


#include "x0_i0_spells"
#include "nwn2_inc_spells"
#include "acr_bard_i"

void main()
{

	if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
	{
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
	 
	if (nPerform < 6 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

    // At the moment, this is a self-only spell. 
	object oTarget = GetSpellTargetObject();

	if ( GetIsObjectValidSongTarget( oTarget ) )
	{
    
		int 	nSaveDC		= 11 + ( nPerform / 2 ); 
		int 	nDuration 	= ApplySongDurationFeatMods( 10, OBJECT_SELF ); // Rounds

		effect 	eVis 	= EffectVisualEffect(VFX_HIT_BARD_HAVEN_SONG);
		//effect 	eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect	eSanc	= EffectSanctuary( nSaveDC );
		
		
		effect eLink = EffectLinkEffects(eVis, eSanc);
		//eLink = EffectLinkEffects(eLink, eDur);
		
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SANCTUARY, FALSE));
		
		//Apply the VFX impact and effects
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }

	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}

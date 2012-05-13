//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Legion
//:: NW_S2_SngInLegn
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies bonuses to all allies
    within 60 feet.
*/
//:: PKM-OEI 07.13.06 VFX Pass
//:: AFW-OEI 07/14/2006: Check to see if you have bardsong feats left; if you do, execute
//::	script and decrement a bardsong use.
//:: PKM-OEI 07.20.06 Added Perform skill check
//:: RPGplayer1 03.19.08 modified to work with non-player faction
//:: RPGplayer1 12.29.08 only count BAB from allies within 60 feet

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
	
	int		nPerform	= GetSkillRank(SKILL_PERFORM);
	 
	if (nPerform < 21 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}


    //Declare major variables
    int nDuration   = ApplySongDurationFeatMods( 10, OBJECT_SELF ); // Rounds
    float fDuration = RoundsToSeconds(nDuration);
    int nDamage     = 4;
    int nBABMin     = 0;
    //object oLeader = GetFactionLeader( OBJECT_SELF );
    object oLeader = OBJECT_SELF; //FIX: NPC bards don't have faction leader
    int bPCOnly    = FALSE;
    int nTstBonus  = 0;
	
    object oTarget = GetFirstFactionMember( oLeader , bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
        float fDist = GetDistanceBetween(oLeader, oTarget); //returns 0.0 if they're in different areas
        if ((fDist > 0.0 && fDist < RADIUS_SIZE_COLOSSAL) || oTarget == oLeader) // Make sure to count the bard
        {
            nTstBonus = GetTRUEBaseAttackBonus(oTarget);
            if(nBABMin < nTstBonus)
            {
                nBABMin  = nTstBonus;
            }
        }
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }

    effect eDamage = ExtraordinaryEffect( EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING) );
    effect eBAB    = ExtraordinaryEffect( EffectBABMinimum(nBABMin) );
    effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_LEGION) );
    effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eDamage, eBAB) );
    eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );

//    if(AttemptNewSong(OBJECT_SELF))
    {
	    effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

        ApplyFriendlySongEffectsToArea( OBJECT_SELF, GetSpellId(), fDuration, RADIUS_SIZE_COLOSSAL, eLink );
	    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}
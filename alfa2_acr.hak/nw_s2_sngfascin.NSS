//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Fascinate
//:: nw_s2_sngfascin.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Fascinate
	This song acts like a mesmerization effect from a MMO. Every hostile 
	creature within 90’ must make a Will save (against a DC of 11 + CHA modifier). 
	This is an enchantment (compulsion) mind-affecting ability for purposes of 
	resistance. If the target fails this save, then they are dazed for as long 
	as the song is playing and the bard is within 90’ of them. The dazed 
	condition is identical to the Stinking Cloud spell, and means that the 
	target can’t attack or cast spells. This effect is instantly broken if 
	they are attacked by anyone. Additionally, if someone within 10’ is being 
	attacked the mesmerization effect automatically ends (potentially another 
	saving throw may be allowed). There is a cool down of 10 rounds before 
	this ability can be used again.
	Fascinate effects up to one enemy per level of the Bard.
	
	[Rules Note] The Fascinate ability has a different effect in 3.5, which 
	makes it so that the targets sit in place and listen to the bard unless 
	certain conditions are met (one of which is any obvious hostile actions).
	 This interpretation of that song is more concrete making it easier for 
	the computer to check. Unlike the PHB, this ability can be used in combat.

*/
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

//    if(!AttemptNewSong(OBJECT_SELF))  //, TRUE))
//    {
//        return;  // Failed
//    }

    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }
	
	int		nPerform	= GetSkillRank(SKILL_PERFORM);
	 
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}


	int 	nLevel 		= GetLevelByClass(CLASS_TYPE_BARD);
	int 	nDuration 	= ApplySongDurationFeatMods( 10, OBJECT_SELF ); // Rounds
	float 	fDuration 	= RoundsToSeconds( nDuration ); // Seconds
	int 	nBreakFlags	= MESMERIZE_BREAK_ON_ATTACKED + MESMERIZE_BREAK_ON_NEARBY_COMBAT;
	float	fBreakDist	= 90.0; // Units? 
	location locCaster	= GetLocation(OBJECT_SELF);
    int     nChaMod     = GetAbilityModifier(ABILITY_CHARISMA);
    int     nSpellDC    = 11 + nChaMod;
	
    effect 	eImpact 	= EffectVisualEffect( VFX_HIT_SPELL_ILLUSION ); // TEMP VISUAL EFFECT
	effect 	eMesmerized	= EffectMesmerize( nBreakFlags, fBreakDist );


	int nAffectedCreature = 0;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, locCaster );
    while(GetIsObjectValid(oTarget))
    {
		if ( GetIsObjectValidSongTarget( oTarget ) )
		{
			//if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
			if ( GetIsEnemy( oTarget ) )
			{
                // Make a Will save (against a DC of 11 + CHA modifier)
                int nSave = WillSave( oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS , OBJECT_SELF );
                if ( nSave == 0 )
                {
                        // Add a small delay based on the distance from the caster. 
                        float fDelay = 0.15 * GetDistanceToObject( oTarget );

                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eMesmerized, oTarget, fDuration ) ); 

                        nAffectedCreature = nAffectedCreature + 1;

                        if (nAffectedCreature >= nLevel )
                        {
                            break;
                        }
                }
			}
		}

		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, locCaster );
	}
	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Jarring
//:: NW_S2_SngInJrng
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/07/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies negative modifiers to all enemies
    within 20 feet.
*/
//:: AFW-OEI 06/06/2006:
//::	Change from a "Jarring" effect to -4 Discipline/Concentration
//::	and -2 to all Will saves.
//:: PKM-OEI 07.13.06 VFX Pass
//:: PKM-OEI 07.20.06 Added Perform skill check

#include "x0_i0_spells"
#include "nwn2_inc_spells"


void RunPersistentSong(object oCaster, int nSpellId)
{
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
	}
	
	int		nPerform	= GetSkillRank(SKILL_PERFORM);
	 
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

    // Verify that we are still singing the same song...
    int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
    if(nSingingSpellId == nSpellId)
    {
        // Sneaking and singing are mutually exclusive.
        if(GetActionMode(oCaster, ACTION_MODE_STEALTH))
        {
            SendMessageToPC(oCaster, "You cannot use stealth mode while singing.");
            SetActionMode(oCaster, ACTION_MODE_STEALTH, FALSE);
        }

        //Declare major variables
        float fDuration = 4.0; //RoundsToSeconds(5);

        //effect eJarring = ExtraordinaryEffect( EffectJarring() );
		effect eDiscPenalty = ExtraordinaryEffect( EffectSkillDecrease( SKILL_DISCIPLINE, 4 ) );
		effect eConcPenalty = ExtraordinaryEffect( EffectSkillDecrease( SKILL_CONCENTRATION, 4 ) );
		effect eWillPenalty = ExtraordinaryEffect( EffectSavingThrowDecrease( SAVING_THROW_WILL, 2) );
        effect eDur     = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_JARRING) );
        effect eLink    = EffectLinkEffects( eDiscPenalty, eConcPenalty );
		eLink			= EffectLinkEffects( eLink, eWillPenalty);
		eLink 			= ExtraordinaryEffect( EffectLinkEffects( eLink, eDur ) );

        ApplyHostileSongEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_HUGE, eLink );
        // Schedule the next ping
        DelayCommand(2.5f, RunPersistentSong(oCaster, nSpellId));
    }
}


void main()
{
    if ( GetCanBardSing( OBJECT_SELF ) == FALSE )
    {
        return; // Awww :(	
    }

    if(AttemptNewSong(OBJECT_SELF, TRUE))
    {
        if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
        {
            FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
            return;
        }
        effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));
	
        DelayCommand(0.1f, RunPersistentSong(OBJECT_SELF, GetSpellId()));
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
    }
}
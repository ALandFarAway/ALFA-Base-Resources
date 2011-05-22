//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Slowing
//:: NW_S2_SngInSlow
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/07/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies negative modifiers to all enemies
    within 20 feet.
*/
//:: AFW-OEI 06/06/2006:
//::	Reduced movement penalties from 25%/50% to 15%/30%
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
        //Declare major variables
        int nLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
        int nChr        = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
        int nWillSave   = 13 + (nLevel / 2) + nChr;
        int nMoveChng;

        if(nLevel >= 16)       { nMoveChng = 30; }
        else                   { nMoveChng = 15; }

        effect eMove   = ExtraordinaryEffect( EffectMovementSpeedDecrease(nMoveChng) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_SLOWING) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eMove, eDur) );

        ApplyHostileSongEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_HUGE, eLink, SAVING_THROW_WILL, nWillSave );
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
	    effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
	    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

		DelayCommand(0.1f, RunPersistentSong(OBJECT_SELF, GetSpellId()));
    }
}
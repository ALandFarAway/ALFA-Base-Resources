//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Competence
//:: NW_S2_SngInComp
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for as long as
    it is kept up.
*/
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
	 
	if (nPerform < 3 )//Checks your perform skill so nubs can't use this song
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
        int nLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
        int nSkill = 2; // AFW-OEI 02/09/2007: Default to +2

        /* AFW-OEI 02/09/2007: Switch to a formula instead of a hard-coded list.
        if(nLevel >= 19)       { nSkill = 6; }
        else if(nLevel >= 11)  { nSkill = 4; }
        else                   { nSkill = 2; }
        */
        
        if (nLevel >= 11)
        {   // +2 every 8 levels starting at level 3
            nSkill = nSkill + (2 * ((nLevel - 3) / 8));
        }

        effect eSkill  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eSkill, eDur) );

        ApplyFriendlySongEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
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
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
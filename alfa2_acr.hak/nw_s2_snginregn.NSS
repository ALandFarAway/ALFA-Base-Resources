//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Regeneration
//:: NW_S2_SngInRegn
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    This spells applies bonuses to all of the
    bard's allies within 30ft for as long as
    it is kept up.
*/
//:: AFW-OEI 06/06/2006:
//::	Double regeneration rate.
//:: PKM-OEI 07.13.06 VFX Pass
//:: PKM-OEI 07.20.06 Added Perform skill check

// 2008/08/30 - ALFA ACR edits for Subdual

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
        int nRegen = 1; // AFW-OEI 02/09/2007: Default to +1

        /* AFW-OEI 02/09/2007: Switch to a formula from hard-coded list.
        if(nLevel >= 17)       { nRegen = 3; }
        else if(nLevel >= 12)  { nRegen = 2; }
        else                   { nRegen = 1; }
        */
        
        if (nLevel >= 12)
        {   // +1 every 5 levels starting at level 7
            nRegen = nRegen + ((nLevel - 7) / 5);
        }

        effect eRegen  = ExtraordinaryEffect( EffectRegenerate(nRegen, RoundsToSeconds(2)) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_REGENERATION) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eRegen, eDur) );
		
		// ALFA ACR edit for Subdual - added nRegen parameter to ApplyFriendlySongEffects
        ApplyFriendlySongEffectsToArea( oCaster, nSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink, nRegen);
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
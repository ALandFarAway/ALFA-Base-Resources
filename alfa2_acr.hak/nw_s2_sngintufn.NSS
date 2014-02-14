//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Toughness
//:: NW_S2_SngInTufn
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
#include "acr_bard_i"

void RunPersistentSong(object oCaster, int nSpellId)
{

	int		nPerform	= GetPerformRanks(OBJECT_SELF);
	 
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(	
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
        int nLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        int nSave = 1;  // AFW-OEI 02/09/2007: Default to +1

        /* AFW-OEI 02/09/2007: switch to formula instead of hard-coded list.
        if(nLevel >= 18)       { nSave = 3; }
        else if(nLevel >= 13)  { nSave = 2; }
        else                   { nSave = 1; }
        */
        
        if (nLevel >= 13)
        {   // +1 every five levels starting at level 8
            nSave = nSave + ((nLevel - 8) / 5);
        }

        effect eSave   = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_ALL, nSave) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eSave, eDur) );

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
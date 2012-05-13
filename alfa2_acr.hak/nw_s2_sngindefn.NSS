//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Defense
//:: NW_S2_SngInDefn
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

#include "x0_i0_spells"
#include "nwn2_inc_spells"


void RunPersistentSong(object oCaster, int nSpellId)
{
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
        int nLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
        int nAC = 2;    // AFW-OEI 02/09/2007: Default to +2

        /* AFW-OEI 02/09/2007: Switch to a formula instead of a hard-coded list.
        if(nLevel >= 20)       { nAC = 5; }
        else if(nLevel >= 15)  { nAC = 4; }
        else if(nLevel >= 10)  { nAC = 3; }
        else                   { nAC = 2; }
        */
        
        if (nLevel >= 10)
        {   // +1 every five levels starting at level 5
            nAC = nAC + ((nLevel - 5) / 5);
        }

        effect eAC     = ExtraordinaryEffect( EffectACIncrease(nAC, AC_DODGE_BONUS) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_DEFENSE) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eAC, eDur) );

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
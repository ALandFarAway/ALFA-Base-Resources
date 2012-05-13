//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Courage
//:: NW_S2_SngInCour
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
        int nLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
        float fDuration = 4.0; //RoundsToSeconds(5);
        //int nAttack;
        //int nDamage;

        /* AFW-OEI 02/09/2007: switch to a formula instead of a hard-coded list.
        if(nLevel >= 20)       { nAttack = 4; nDamage = 4; }
        else if(nLevel >= 14)  { nAttack = 3; nDamage = 3; }
        else if(nLevel >= 8)   { nAttack = 2; nDamage = 2; }
        else                   { nAttack = 1; nDamage = 1; }
        */
        int nBonus = 1; // Default to +1
        if (nLevel >= 8)
        {   // +1 every six levels starting at level 2.
            nBonus = nBonus + ((nLevel - 2) / 6);
        }
        
        int nDamage = IPGetDamageBonusConstantFromNumber(nBonus);   // Map raw bonus to a DAMAGE_BONUS_* constant.

        effect eAttack = ExtraordinaryEffect( EffectAttackIncrease(nBonus) );
        effect eDamage = ExtraordinaryEffect( EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING) );
        effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eAttack, eDamage) );
        effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE) );
        eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );

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
//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song/Hymn of Requiem
//:: nx_s2_sngrequiem
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/23/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
    Song of Requiem:
    This song damages all enemies within 20 feet for 5 rounds.
    The total sonic damage caused is equal to 2*Perform skill; the minimum damage
    caused per target is Perform/3. For example, with Perform 30, a total of
    60 points of damage is inflicted each round. If six (or more) enemies are
    affected, they would each take 10 sonic damage per round. This ability has a
    cooldown of 20 rounds.
    
    Hymn of Requiem:
    The character's Song of Requiem now also heals all party members. The amount
    healed is the same as the damage caused by the Hymn and is divided among all
    party members; the minimum amount healed per ally is Perform/3. For example,
    if the total damage dealt is 60 and four characters are in the party, each is
    healed 15 hit points per round.
*/
// ChazM 5/31/07 renamed DoHealing() to DoPartyHealing() (DoHealing() is declared in nw_i0_spells)
// AFW-OEI 07/20/2007: NX1 VFX.

#include "x0_i0_spells"
#include "nwn2_inc_spells"

void DoDamage(object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering Do Damage");

	location locCaster	= GetLocation(oCaster);
    int nNumEnemies   = 0;
   
    // Count up enemy targets so we can divide up damage evenly.  Stop if there's more than 6, since min damage is floored at Total/6.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    while(GetIsObjectValid(oTarget))
    {
        if ( GetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
        {
            nNumEnemies = nNumEnemies + 1;
        }
        
        if (nNumEnemies >= 6)
        {   // Don't need to go higher than 6 enemies.
            break;
        }

    	oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    }
    //SpeakString("nx_s2_SngRequiem: DoDamage: nNumEnemies = " + IntToString(nNumEnemies));
    
    if (nNumEnemies <= 0)
    {
        return;
    }
    
    int nPerformSkill = GetSkillRank(SKILL_PERFORM, oCaster);
    int nDamage = (2 * nPerformSkill) / nNumEnemies;    // Damage per target is (2*Perform)/Number of Enemies, capped at most 6 enemies.
    
    // Inflict Sonic damage.  No save.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    while(GetIsObjectValid(oTarget))
    {
        //SpeakString("nx_s2_SngRequiem: DoDamage: iterating through damage while loop");
        if ( GetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
            
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
            float fDelay = 0.15 * GetDistanceToObject( oTarget );

            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) ); 
        }

    	oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
    }
    //SpeakString("nx_s2_SngRequiem: DoDamage: exiting function"); 
}

void DoPartyHealing(object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering DoHealing");

    // Count up party members so we can divide up damage evenly.  Stop if there's more than 6, since min damage is floored at Total/6.
    int nNumPartyMembers = 0;
    int bPCOnly    = FALSE;
    object oLeader = GetFactionLeader( oCaster );
    object oTarget = GetFirstFactionMember( oLeader, bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
            nNumPartyMembers = nNumPartyMembers + 1;
        }
        
        if ( nNumPartyMembers >= 6 )
        {
            break;
        }
        
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }
    
    if (nNumPartyMembers <= 0)
    {
        return;
    }
    
    int nPerformSkill = GetSkillRank(SKILL_PERFORM, oCaster);
    int nHeal = (2 * nPerformSkill) / nNumPartyMembers;
    
    // Apply healing to party members
    oTarget = GetFirstFactionMember( oLeader, bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsObjectValidSongTarget(oTarget) )
        {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
        
        effect eHeal = EffectHeal(nHeal);
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        float fDelay = 0.15 * GetDistanceToObject( oTarget );

        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget ) );
        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget ) ); 
        }
        
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }
}  
            
void RunSongEffects(int nCallCount, object oCaster, int nSpellId)
{
    //SpeakString("nx_s2_SngRequiem: Entering RunSongEffects");

    // See if you are still allowed to sing.
	if ( GetCanBardSing( oCaster ) == FALSE )
	{
		return;	
	}
	
    // Make sure you have enough perform ranks.
	int	nPerformRanks = GetSkillRank(SKILL_PERFORM, oCaster, TRUE);
	if (nPerformRanks < 24 )
	{
		FloatingTextStrRefOnCreature ( 182800, oCaster );
		return;
	}

    // Verify that we are still singing the same song...
    int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
    if(nSingingSpellId == nSpellId)
    {
		effect ePulse = EffectVisualEffect(VFX_HIT_BARD_REQUIEM);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, ePulse, oCaster);
			
		DoDamage(oCaster, nSpellId);
        
        // If you have Hymn of Requiem, heal your party, too
        if (GetHasFeat(FEAT_EPIC_HYMN_OF_REQUIEM, oCaster))
        {
            DoPartyHealing(oCaster, nSpellId);
        }
            
        // Schedule the next ping
        nCallCount = nCallCount + 1;
        if (nCallCount > ApplySongDurationFeatMods(5, OBJECT_SELF)) // Requiem is for 5 rounds.
        {
			RemoveBardSongSingingEffect(oCaster, GetSpellId());	// AFW-OEI 07/19/2007: Terminate song.
            return;
        }
        else
        {   // Run once per "round" (5.5 secs gives time for some processing lag).
            //SpeakString ("nx_s2_SngRequiem: RunSongEffects: queuing up call to RunSongEffects.  Call count: " + IntToString(nCallCount));
            DelayCommand(5.5f, RunSongEffects(nCallCount, oCaster, nSpellId));
        }
    }
}


void main()
{
	if ( !GetCanBardSing( OBJECT_SELF ) )
	{
        //SpeakString("nx_s2_SngRequiem: main: !GetCanBardSing()");
		return;	
	}

    if (!AttemptNewSong(OBJECT_SELF, TRUE))
    {
        //SpeakString("nxs_s2_SngRequiem: main: !AttemptNewSong()");
        return;
    }
    
    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
        return;
    }

	effect eFNF = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    DelayCommand(0.1f, RunSongEffects(1, OBJECT_SELF, GetSpellId()));
    
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
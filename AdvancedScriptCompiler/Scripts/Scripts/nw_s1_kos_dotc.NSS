//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s1_kos_dotc.nss
//::
//::	This is the OnHeartbeat script for a AOE_MOB_SHADOW_PLAGUE effect.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 8/30/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "x0_i0_spells"

const int NUM_LEVEL_IMPACTS_PER_ROUND = 3;
const int NUM_DAMAGE_IMPACTS_PER_ROUND = 6;
const int NEGATIVE_LEVEL_AMOUNT = 1;
const int NEGATIVE_ENERGY_DAM_AMOUNT = 5;

void RunPlagueDamageImpact( object oTarget )
{
	effect eDamage = EffectDamage( NEGATIVE_ENERGY_DAM_AMOUNT, DAMAGE_TYPE_NEGATIVE );
	
	if ( GetHasSpellEffect(GetSpellId(), oTarget) )
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	else return;
}

void RunPlagueDrainImpact( object oTarget )
{
	effect eNegativeLevel = EffectNegativeLevel( NEGATIVE_LEVEL_AMOUNT );
	
	if ( GetHasSpellEffect(GetSpellId(), oTarget) )
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNegativeLevel, oTarget);
	else return;
}

void ApplyPlagueEffects( object oTarget )
{
	float fSecondsPerRound = RoundsToSeconds( 1 );
	float fDeltaDamage = fSecondsPerRound / IntToFloat( NUM_DAMAGE_IMPACTS_PER_ROUND );
	float fDeltaDrain = fSecondsPerRound / IntToFloat( NUM_LEVEL_IMPACTS_PER_ROUND );
	int i;
	
	for ( i = 0; i < NUM_DAMAGE_IMPACTS_PER_ROUND; i++ )
	{
		DelayCommand( IntToFloat(i) * fDeltaDamage, RunPlagueDrainImpact(oTarget) );
	}
	
	for ( i = 0; i < NUM_LEVEL_IMPACTS_PER_ROUND; i++ )
	{
		DelayCommand( IntToFloat(i) * fDeltaDrain, RunPlagueDrainImpact(oTarget) );
	}
}


void main()
{
	object oTarget = GetFirstInPersistentObject();
	object oCreator = GetAreaOfEffectCreator();
	effect eImpact = EffectVisualEffect( VFX_HIT_SPELL_EVIL );	//
	
	while ( GetIsObjectValid(oTarget) )
	{	
		if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator) )
		{
			SignalEvent( oTarget, EventSpellCastAt(oCreator, GetSpellId()) );
			ApplyPlagueEffects( oTarget );
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
		}
		oTarget = GetNextInPersistentObject();
	}
}
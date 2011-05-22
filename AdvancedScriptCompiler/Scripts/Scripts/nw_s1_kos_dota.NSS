//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s1_kos_dota.nss
//::
//::	This is the OnEnter script for a AOE_MOB_SHADOW_PLAGUE effect.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 8/30/06
//::
//::///////////////////////////////////////////////////////////////////////////
#include "x0_i0_spells"

const int NEGATIVE_LEVEL_AMOUNT = 1;
const int NEGATIVE_ENERGY_DAM_AMOUNT = 5;

void ApplyInstantPlagueEffects( object oTarget )
{
	effect eNegativeLevel = EffectNegativeLevel( NEGATIVE_LEVEL_AMOUNT );
	effect eDuration = EffectLinkEffects( eNegativeLevel, EffectVisualEffect( 889 ) );	// VFX_DUR_SHADOW_PLAGUE

	effect eDamage = EffectDamage( NEGATIVE_ENERGY_DAM_AMOUNT, DAMAGE_TYPE_NEGATIVE );
	effect eImpact = EffectLinkEffects( eDamage, EffectVisualEffect( VFX_HIT_SPELL_EVIL ) );
	
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDuration, oTarget );
	ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
}

void main()
{
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();

	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator) )
	{
		SignalEvent( oTarget, EventSpellCastAt(oCreator, GetSpellId()) );
		ApplyInstantPlagueEffects( oTarget );
	}
}
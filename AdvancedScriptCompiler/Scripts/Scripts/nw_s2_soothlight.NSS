//::///////////////////////////////////////////////
//:: Feat: Soothing Light
//:: nw_s2_soothlight
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	The Target is cured of any negative effects.
	The Target regenerates 1 HP / level per round
	The effect lasts for 5 rounds.
	
	BDF-EDIT: now heals 1 negative level every second
	and 
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/09/06
//:://////////////////////////////////////////////
//:: AFW-OEI 04/25/2006: Major changes to 
//:: functionality as per GDD.
//:://////////////////////////////////////////////
// BMA-OEI 8/25/06 -- Updates to counter Shadow Plague
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox
//:: Modified On: 8/30/06
/*
	Soothing light should heal 1 negative level 
	every second and provide 1 point of negative 
	energy protection for every five levels of the caster.  
	It should affect the whole party and last for 10 rounds. 
*/
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

const string KOS_DOT_INFECTED 		= "__nKoSInfected";
const string SOOTH_LIGHT_REGEN 		= "__nSoothLightRegen";
const int SOOTH_LIGHT_DURATION	 	= 10;	// 9/1/06 -  BDF: modified from 5
const float SOOTH_LIGHT_RETRY 		= 1.0f;	// 9/1/06 -  BDF: modified from 6.0f

// * play generic heal vfx
void ApplyHealVisual( object oTarget );

// * removes all negative effects
void RemoveNegativeEffects( object oTarget );

// * removes Shadow Plague effects
void CounterShadowPlague( object oTarget );

// * apply recursive Heal regen
void ApplyRegenHealth( object oTarget );

// * apply recursive NegativeLevel regen
void ApplyRegenLevels( object oTarget );

// * attempt to remove NegativeLevels
void RemoveNegativeLevel( object oTarget );

void main()
{
	
    if (!X2PreSpellCastCode())
    {
        return;
    }

	int nSpellID 			= GetSpellId();
	object oCaster 			= OBJECT_SELF;
    //object 	oTarget 		= GetSpellTargetObject();
    object oTarget 			= GetFirstFactionMember( oCaster, FALSE );
	int nCasterLevel 		= GetTotalLevels( oCaster, TRUE );	
	//int nHealAmt			= nCasterLevel;
	int nNegEnergyProtection = nCasterLevel / 5;
	// Create the regen and duration VFX	
	//effect eHeal 			= EffectRegenerate( nHealAmt, RoundsToSeconds(1) );
	effect eVisual 			= EffectVisualEffect( 903 ); // VFX_DUR_SOOTHING_LIGHT
	effect eNegEnergyProt 	= EffectDamageResistance( DAMAGE_TYPE_NEGATIVE, nNegEnergyProtection );
	// Link the effects together
	effect eLink 			= EffectLinkEffects( eNegEnergyProt, eVisual );
	float fDuration			= RoundsToSeconds( SOOTH_LIGHT_DURATION );		// Spell is fixed to a 10 round duration
	
	while ( GetIsObjectValid(oTarget) )
	{
		SignalEvent( oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE) );
	
		//Apply the heal effect and the VFX impact
		//ApplyHealVisual( oTarget );
	
		// Remove all status effects
		//RemoveNegativeEffects( oTarget );
		
		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
		
		// Counter Shadow Plague
		CounterShadowPlague( oTarget );	
			
		oTarget = GetNextFactionMember( oCaster, FALSE );
	}
	
}

void ApplyHealVisual( object oTarget )
{
	effect eVisual = EffectVisualEffect( VFX_IMP_HEALING_X );
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
}

void RemoveNegativeEffects( object oTarget )	// 9/1/06 - BDF: no longer used
{
    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            //GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
            GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eBad) == EFFECT_TYPE_POISON ||
            GetEffectType(eBad) == EFFECT_TYPE_DISEASE
                )
            {
                //Remove effect if it is negative.
                RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }
}

void CounterShadowPlague( object oTarget )
{
	//SetLocalInt( oTarget, KOS_DOT_INFECTED, 0 );
	//SetLocalInt( oTarget, SOOTH_LIGHT_REGEN, SOOTH_LIGHT_DURATION );
	//DelayCommand( SOOTH_LIGHT_RETRY, ApplyRegenLevels( oTarget ) );
	ApplyRegenLevels( oTarget );
	ApplyRegenHealth( oTarget );
}

void ApplyRegenLevels( object oTarget )
{
	
	//int nRegen = GetLocalInt( oTarget, SOOTH_LIGHT_REGEN );
	//if ( nRegen > 0 )
	//{
	// check for soothing light duration
	// if yes, recursuively delay itself
	// otherwise bail out
	if ( GetHasSpellEffect(GetSpellId(), oTarget) )	// SPELLABILITY_SOOTHING_LIGHT
	{
		//SetLocalInt( oTarget, SOOTH_LIGHT_REGEN, nRegen - 1 );
		//RemoveNegativeLevel( oTarget );
		RemoveNegativeLevel( oTarget );
		DelayCommand( SOOTH_LIGHT_RETRY, ApplyRegenLevels(oTarget) );	
	}
	else return;
	//}
}

void ApplyRegenHealth( object oTarget )
{
	if ( GetHasSpellEffect( GetSpellId(), oTarget ) )
	{
		effect eHeal = EffectHeal( GetTotalLevels( OBJECT_SELF, TRUE ) );
		ApplyHealVisual( oTarget );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget );
		DelayCommand( RoundsToSeconds( 1 ), ApplyRegenHealth( oTarget ) );
	}
}

void RemoveNegativeLevel( object oTarget )
{
	effect eLevel = GetFirstEffect( oTarget );
	while ( GetIsEffectValid( eLevel ) == TRUE )
	{
		if ( GetEffectType( eLevel ) == EFFECT_TYPE_NEGATIVELEVEL )
		{
			ApplyHealVisual( oTarget );
			RemoveEffect( oTarget, eLevel );
			return;
		}
		else
		{
			eLevel = GetNextEffect( oTarget );	
		}
	}
}
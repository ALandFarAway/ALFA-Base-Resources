//::///////////////////////////////////////////////
//:: Special Ability King Of Shadows: DoT
//:: nw_s1_kos_dot
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
		This isn't a traditional 
		special ability. Rather, it is called
		during a cutscene by the King of Shadows.
	
		Any NPCs that are hostile to the KoS
		are debuffed and disabled. 
		Any PCs are debuffed. 
		
		BDF-EDIT: this has been revised to work
		as an aura, where any enemies in the aura
		suffer 1 negative level every 2 seconds and
		5 points of negative energy damage every 
		second.  The radius of effect is 5 m.
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/13/06
//:://////////////////////////////////////////////
// BMA-OEI 8/22/06 -- Implemented as Shadow Plague
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox
//:: Modified On: 8/30/06
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"   
#include "x0_i0_spells" 
#include "x2_inc_spellhook" 

const string SEF_KOS_DOT 		= "fx_shadow_plague";
const string SEF_KOS_DOT_IMPACT = "sp_acid_hit";
const string SEF_KOS_DOT_DUR 	= "fx_pois_DOT_linger";

const string KOS_DOT_INFECTED 	= "__nKoSInfected";
const int KOS_DOT_DURATION 		= 10;
const float KOS_DOT_RETRY 		= 6.0f;

void ApplyPlague( object oTarget );
void DoShadowPlague( object oTarget );
void RemovePlague( object oTarget );

void main()
{
	effect eAOE = EffectAreaOfEffect( 58 );		// AOE_MOB_SHADOW_PLAGUE
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF );
	
	
	// 8/30/06 - BDF: The code below is the previous version of the Shadow Plague ability and is
	// preserved for reference.
/*
	object oCaster = OBJECT_SELF;
	object oArea = GetArea( oCaster );
	location lTarget = GetSpellTargetLocation();
	
	//effect eVisual = EffectNWN2SpecialEffectFile( SEF_KOS_DOT );
	effect eVisual = EffectVisualEffect( 888 );	// VFX_AOE_SHADOW_PLAGUE
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVisual, GetLocation( oCaster ) );
	
	float fDelay;
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	while ( GetIsObjectValid( oTarget ) == TRUE )
	{
		// Determine if object within sphere is hostile
		if ( spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ) )
		{
			fDelay = GetRandomDelay( 0.3f, 1.2f );
			DelayCommand( fDelay, ApplyPlague( oTarget ) );
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	}
*/
}

/*
void ApplyPlague( object oTarget )
{
	int nInfected = GetLocalInt( oTarget, KOS_DOT_INFECTED );
	if ( nInfected == 0 )
	{
		SetLocalInt( oTarget, KOS_DOT_INFECTED, KOS_DOT_DURATION );
		DoShadowPlague( oTarget );
	}
}

void DoShadowPlague( object oTarget )
{
	int nInfected = GetLocalInt( oTarget, KOS_DOT_INFECTED ) - 1;
	
	if ( nInfected > 0 )
	{
		SetLocalInt( oTarget, KOS_DOT_INFECTED, nInfected );
	
		//effect eDur = EffectNWN2SpecialEffectFile( SEF_KOS_DOT_DUR );
		effect eDur = EffectVisualEffect( 889 );	// VFX_DUR_SHADOW_PLAGUE
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eDur, oTarget, KOS_DOT_RETRY );
		
		//effect eImpact = EffectNWN2SpecialEffectFile( SEF_KOS_DOT_IMPACT );
		effect eImpact = EffectVisualEffect( VFX_HIT_SPELL_ACID );	//
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, oTarget );
			
		effect eDamage = EffectDamage( 15, DAMAGE_TYPE_ACID );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

		effect eLevel = EffectNegativeLevel( 1 );
		ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLevel, oTarget, RoundsToSeconds( 10 ) );
		
		DelayCommand( KOS_DOT_RETRY, DoShadowPlague( oTarget ) );		
	}
	else
	{
		//RemovePlague( oTarget );
	}
}

void RemovePlague( object oTarget )
{
	effect ePlague = GetFirstEffect( oTarget );
	while ( GetIsEffectValid( ePlague ) == TRUE )
	{
		if ( GetEffectType( ePlague ) == EFFECT_TYPE_NEGATIVELEVEL )
		{
			RemoveEffect( oTarget, ePlague );
			ePlague = GetFirstEffect( oTarget );
		}
		else
		{
			ePlague = GetNextEffect( oTarget );
		}
	}
}
*/
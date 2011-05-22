//::///////////////////////////////////////////////
//:: Feat: Cleansing Nova
//:: nw_s2_clnsnova.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A persistent, immobile cylinder of light that
	inflicts 20 holy damage per round to any
	undead or outsiders in it.  No save, but spell
	resistance.	
	
	BDF-EDIT: this feat is no longer a persistent AOE
	and instead is an instant AOE that causes
	1 point of fire damage per character level
	for 4 seconds to everyone in its area of effect.
	Additionally, if any target of the Cleansing Nova
	is also currently under the effects of Web of
	Purity, then ALL creatures that are under the 
	effects of WoP will suffer the same effects from
	CN.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/24/2006
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF-OEI)
//:: Modified On: 08/30/2006
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

const float CLEANSING_NOVA_RADIUS_SIZE = RADIUS_SIZE_LARGE;
const int NUM_CLEANSING_NOVA_IMPACTS = 4;

int GetIsValidNovaTarget( object oTarget )
{
	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
		int nRacialType = GetRacialType(oTarget);
		
		if ( nRacialType == RACIAL_TYPE_UNDEAD ||	// Only target Undead OR Outsiders
			 nRacialType == RACIAL_TYPE_OUTSIDER )
			return TRUE;
	}

	return FALSE;
}

void ApplyCleansingNovaEffects( effect eEffect, 
								object oTarget, 
								int nDurationType = DURATION_TYPE_INSTANT, 
								int nNumImpacts = NUM_CLEANSING_NOVA_IMPACTS )
{
	float fDelay;
	int i;
	
	for ( i = 0; i < nNumImpacts; i++ )
	{
		if ( GetIsDead(oTarget) )	return;
		
		fDelay = IntToFloat(i);
		DelayCommand( fDelay, ApplyEffectToObject(nDurationType, eEffect, oTarget) );
	}
}

int HandleWebOfPurityVictims( effect eEffect, 
							  int nDurationType = DURATION_TYPE_INSTANT, 
							  int nNumImpacts = NUM_CLEANSING_NOVA_IMPACTS )
{
	int nCounter = 1;
	object oWebbed = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, 948, OBJECT_SELF, nCounter++ );	// 948 = SPELLABILITY_WEB_OF_PURITY
	
	while (GetIsObjectValid(oWebbed) )
	{
        ApplyCleansingNovaEffects( eEffect, oWebbed, nDurationType, nNumImpacts );
		
		oWebbed = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, 948, OBJECT_SELF, nCounter++ );	// 948 = SPELLABILITY_WEB_OF_PURITY
	}
	
	return TRUE;
}

void main()
{
	//SpawnScriptDebugger();
	
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
	object oCaster 		= OBJECT_SELF;
	int    nCasterLevel = GetTotalLevels( oCaster, TRUE );
    effect eDam    	 	= EffectDamage( nCasterLevel, DAMAGE_TYPE_FIRE );		// Nova damage = character level
    //object oTarget 		= GetSpellTargetObject();
	location lTarget 	= GetSpellTargetLocation();
	int bWebVictimsHandled = FALSE;
	effect eImpact = EffectVisualEffect( VFX_HIT_CLEANSING_NOVA );
	
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
	
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_FIRE );	//
	effect eLink = EffectLinkEffects( eDam, eVis );
	
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, CLEANSING_NOVA_RADIUS_SIZE, lTarget );
	
	while ( GetIsObjectValid(oTarget) )
	{
        //Fire cast spell at event for the specified target
        SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELLABILITY_CLEANSING_NOVA) );

		if ( GetIsValidNovaTarget(oTarget) )
		{
	        //Make SR check.
	        if ( !MyResistSpell(oCaster, oTarget) )
	        {
				if ( GetHasSpellEffect(948, oTarget) && !bWebVictimsHandled )	// 948 = SPELLABILITY_WEB_OF_PURITY
				{
					bWebVictimsHandled = HandleWebOfPurityVictims( eLink );
				}
				else if ( !GetHasSpellEffect(948, oTarget) )
				{
                	// Apply effects to the currently selected target.
                	ApplyCleansingNovaEffects( eLink, oTarget, DURATION_TYPE_INSTANT, NUM_CLEANSING_NOVA_IMPACTS );
				}
	        }
		}

		oTarget = GetNextObjectInShape( SHAPE_SPHERE, CLEANSING_NOVA_RADIUS_SIZE, lTarget );
	}	
	
	// The code below represents this feat's original implementation and is preserved for reference
/*	
	// Declare Area of Effect object using the appropriate constant
	effect eAOE = EffectAreaOfEffect(AOE_PER_CLEANSING_NOVA);
	
	// Get the location where the cylinder is to be placed
	location lTarget = GetSpellTargetLocation();

	float fDuration = RoundsToSeconds(5);		// Spell duration if fixed to 5 rounds

	// Create the Area of Effect Object declared above.
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
*/
}
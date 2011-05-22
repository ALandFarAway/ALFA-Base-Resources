//::///////////////////////////////////////////////
//:: Feat: Web of Purity
//:: nw_s2_webpurity
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A radius effect light burst emanating from the 
	caster (no aiming - it's like an explosion that 
	travels outward from the caster); paralyzes all
	undead enemies for character level/4 rounds.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/20/2006
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF-OEI)
//:: Modified On: 08/30/2006
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"    
#include "x0_i0_spells"
#include "x2_inc_spellhook"

const float WEB_OF_PURITY_RADIUS_SIZE = RADIUS_SIZE_GINORMOUS; 

int GetIsValidWebofPurityTarget( object oTarget )
{
	//if(!GetIsReactionTypeFriendly(oTarget))			// Only target enemies
	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
		int nRacialType = GetRacialType(oTarget);
		if ( nRacialType == RACIAL_TYPE_UNDEAD ||	// Only target Undead OR Outsiders
			 nRacialType == RACIAL_TYPE_OUTSIDER )	
			return TRUE;
	}
	
	return FALSE;
}

void ApplyBeamConnections( int nDurationType, float fDuration )
{
	int nCounter1 = 1, nCounter2 = 1;
	object oWebbed1 = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, GetSpellId(), OBJECT_SELF, nCounter1++ );
	object oWebbed2 = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, GetSpellId(), oWebbed1, nCounter2++ );
	effect eBeam;
	
	while ( GetIsObjectValid(oWebbed1) )
	{
		eBeam = EffectBeam( 900, oWebbed1, BODY_NODE_CHEST );	// VFX_BEAM_WEB_OF_PURITY
		
		while ( GetIsObjectValid(oWebbed2) )
		{
			ApplyEffectToObject( nDurationType, eBeam, oWebbed2, fDuration );
			oWebbed2 = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, GetSpellId(), oWebbed1, nCounter2++ );
		}
		
		oWebbed1 = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, GetSpellId(), OBJECT_SELF, nCounter1++ );
	}
}

void main()
{
	//SpawnScriptDebugger();

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	int 	nSpellID 	 = GetSpellId();
	object  oCaster 	 = OBJECT_SELF;
	int		nCasterLevel = GetTotalLevels( oCaster, TRUE );
	float	fDuration	 = RoundsToSeconds( nCasterLevel/4 );	// Effect lasts rouns = character level /4
	effect  eVisImp 	 = EffectVisualEffect( VFX_HIT_SPELL_ENCHANTMENT ); // visual impact effect on victim
	
	//int 	nDC			 = 10 + nCasterLevel/2 + GetAbilityModifier( ABILITY_INTELLIGENCE, oCaster );
	int 	nDC			 = 10 + nCasterLevel + GetAbilityModifier( ABILITY_INTELLIGENCE, oCaster );

	//effect  eParalyze	 = EffectParalyze(nDC, SAVING_THROW_WILL);	// 3.5 allows for per-round saving throws; we don't want that here
	effect  eParalyze	 = EffectCutsceneParalyze();
	effect	eEntangle	 = EffectEntangle();	// Undead are immune to paralysis, so add an entangle effect, too.
	effect 	eParalyzeVis = EffectVisualEffect( VFX_DUR_PARALYZED );
	effect	eLink		 = EffectLinkEffects( eEntangle, eParalyze );
	eLink 				 = EffectLinkEffects( eLink, eParalyzeVis );
	effect eBeam;
	float fDelay;		 

	 
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetLocation( oCaster );

    //Apply the AOE explosion at the location captured above.
    effect eExplode = EffectVisualEffect( 884 );		// VFX_DUR_WEB_OF_PURITY
    //ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eExplode, lTarget, fDuration );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eExplode, lTarget );

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, WEB_OF_PURITY_RADIUS_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	object oTarget2;
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
		if ( GetIsValidWebofPurityTarget( oTarget ) )
		{
			SignalEvent( oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE) );

            //Make SR Check
            if (!MyResistSpell( oCaster, oTarget ) )
    	    {
				// Make a will save
            	if( !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC ) )
				{
					if ( GetHasSpellEffect(GetSpellId(), oTarget) )
					{
						RemoveSpellEffects( GetSpellId(), OBJECT_SELF, oTarget );
					}
					
					eBeam = EffectBeam( 900, oTarget, BODY_NODE_CHEST );
					fDelay = 0.15f * GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
					//ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, fDuration );
					DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration ) );		
					DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisImp, oTarget ) );
										
					if ( GetIsObjectValid(oTarget2) )
					{
						DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget2, fDuration ) );
					}
										
					oTarget2 = oTarget;
				}	
			}
		}

     	//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, WEB_OF_PURITY_RADIUS_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	// Connect the last object in the shape to the first one, thus completing the circle
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, WEB_OF_PURITY_RADIUS_SIZE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	if ( oTarget != oTarget2 )
	{
		eBeam = EffectBeam( 900, oTarget, BODY_NODE_CHEST );
		DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget2, fDuration ) );
	}
}
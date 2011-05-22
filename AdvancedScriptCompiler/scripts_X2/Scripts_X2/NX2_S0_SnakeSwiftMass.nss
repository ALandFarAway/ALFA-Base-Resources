//::///////////////////////////////////////////////
//:: SnakesSwiftnessMass
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 09/05/2008
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells" 

void main()
{
	if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	float fSize = RADIUS_SIZE_HUGE;	// RADIUS_SIZE_COLOSSAL ~= 30.0 ft
	object oCreator = OBJECT_SELF;
	location lMyLocation = GetLocation( oCreator );
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE ); // here we go!
	
	while( GetIsObjectValid(oTarget) )
	{
	//	if ( !GetHasSpellEffect(SPELL_SNAKES_SWIFTNESS, oTarget) && GetIsReactionTypeFriendly(oTarget) )
	if (spellsIsTarget( oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF ) && !GetHasSpellEffect(SPELL_SNAKES_SWIFTNESS, oTarget))
	{
		effect eHaste = EffectHaste();
   		effect eDur = EffectVisualEffect( VFX_HIT_SPELL_SNAKESSWIFTNESS );
    	effect eLink = EffectLinkEffects(eHaste, eDur);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
	}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );

	}
}
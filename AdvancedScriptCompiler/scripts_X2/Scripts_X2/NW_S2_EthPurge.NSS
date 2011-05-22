//::///////////////////////////////////////////////
//:: Ethereal Purge
//:: NW_S2_EthPurge.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Doomguide ability.  At the 8th level, once per day
	the doomguide may surround himself with a sphere of
	power with a radius of 5 feet per class level that
	forces all ethereal creatures in the area to manifest
	themseves to the Material plane as appropriate.
	(Faith & Pantheons pg188)
	
	Note we don't have Etherealness, but we do have concealment.
	This ability has been adapted to negate concealment for 
	1 min/level on any creatures within the radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/30/2008
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "ginc_debug"

void main()
{
	int nDoomguideLevel = GetLevelByClass(CLASS_TYPE_DOOMGUIDE);
	int nWisMod = GetAbilityModifier(ABILITY_WISDOM);
	
	// basic variables for spell
	// radius is based on level 5* Doomguide class level
	float fSize = nDoomguideLevel * RADIUS_SIZE_SMALL; // RADIUS_SIZE_SMALL ~5ft
	location lMyLocation = GetLocation( OBJECT_SELF );
	float fDuration = 60.0 * nDoomguideLevel;
	int nDC = (nDoomguideLevel/2) + 10 + nWisMod;
	
	// visual effect
	effect eImpactVis = EffectVisualEffect(VFX_AOE_ETHEREAL_PURGE);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);
	
	// actual effect
	effect eNegConceal = EffectConcealmentNegated();
	
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	while( oTarget != OBJECT_INVALID ) 
	{
		// only apply effect to enemies in the radius, not self of allies :D
		if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )
		{
			//SpeakString("Attempting Will Save For :"+GetName(oTarget));
			// attempt Will Save
			if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
			{
				// apply effect
			//	SpeakString("Applying Ethereal Purge to "+GetName(oTarget));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegConceal, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	}	
}
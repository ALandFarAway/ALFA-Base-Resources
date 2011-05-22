//::///////////////////////////////////////////////
//:: Stabilize
//:: NX2_S0_Stabilize.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 07/31/2008
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	float fSize = 2.0 * RADIUS_SIZE_GARGANTUAN;	// RADIUS_SIZE_GARGANTUAN ~= 25.0 ft
	object oCreator = GetSpellTargetObject(); // hopefully OBJECT_SELF since this spell is a radius around you
	location lMyLocation = GetLocation( oCreator );
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE ); // here we go!

	effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);	// no longer using NWN1 VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);	// no longer using NWN1 VFX
	
	while( GetIsObjectValid(oTarget) )
	{
		if (!GetIsDead(oTarget, TRUE))
		{
			// they're alive
			if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				// we don't like undead
				if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
				{
					effect eDam = EffectDamage(1, DAMAGE_TYPE_POSITIVE);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
			else // we're alive and NOT undead...
			{
				effect eHeal = EffectHeal(1);
				effect eVFX   = EffectVisualEffect(VFX_IMP_HEALING_S);
				effect eLink = EffectLinkEffects(eHeal, eVFX);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );

	}
}
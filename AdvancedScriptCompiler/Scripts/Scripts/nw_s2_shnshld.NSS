//::///////////////////////////////////////////////
//:: Feat: Shining Shield
//:: nw_s2_shn_shld
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	All party memebers gain 4 Negative Energy Resistance and
		4 Cold Resistance per character level.
	The effect lasts for 2 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 02/09/06
//:://////////////////////////////////////////////
//:: AFW-OEI 04/25/2006: Major changes to functionality
//:: as per GDD.
//:: BMA-OEI 08/28/2006: Increased range to 100.0f
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox
//:: Modified On: 9/01/06
//:: Removed the distance check; this now affects ALL party members
//:: regardless of distance.
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

const float fSHINING_SHIELD_MAX_DIST = 100.0f; // (meters)
	
void main()
{

    if (!X2PreSpellCastCode())
    {
        return;
    }

	int 	nSpellID 		= GetSpellId();
	object  oCaster 		= OBJECT_SELF;
	int 	nCasterLevel 	= GetTotalLevels( oCaster, TRUE );
	float 	fDuration		= RoundsToSeconds( 2 );		// Shining Shield fixed to 2 round duration

	effect	eVisImp 		= EffectVisualEffect( VFX_DUR_SPELL_RESIST_ENERGY );	// Inital effect VFX

	object oTarget = GetFirstFactionMember( oCaster, FALSE );
    while (GetIsObjectValid(oTarget))
	{
		//float fDist = GetDistanceBetween( oCaster, oTarget ); // returns 0.0 if they're in different areas

		//if ( ( fDist > 0.0 && fDist < fSHINING_SHIELD_MAX_DIST ) ||	// Is the party member close enough to feel the effects?
		//	 ( oCaster == oTarget ) )								// OR it's the caster...	
		//{
			float fDelay = GetRandomDelay(0.1, 0.5);

			DelayCommand( fDelay, SignalEvent( oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE) ) );
			DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisImp, oTarget) );

			// Create and link effects
			//effect eNegImmunity = EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL);					// Negative Level Protection
			//effect eColdResist  = EffectDamageResistance( DAMAGE_TYPE_COLD, 3 * nCasterLevel, 0 );	// 3 * character level Cold Resistance
			effect eColdResist  = EffectDamageResistance( DAMAGE_TYPE_COLD, 4 * nCasterLevel, 0 );	// 4 * character level Cold Resistance
			effect eNegResist  = EffectDamageResistance( DAMAGE_TYPE_NEGATIVE, 4 * nCasterLevel, 0 );	// 4 * character level Negative Resistance
			//effect eVisPersist  = EffectVisualEffect( VFX_DUR_SPELL_PROT_ENERGY );					// Lasting VFX
			effect eVisPersist  = EffectVisualEffect( 893 );					// VFX_DUR_SHINING_SHIELD
		
			//effect eLink = EffectLinkEffects( eNegImmunity, eColdResist );
			effect eLink = EffectLinkEffects( eNegResist, eColdResist );
			eLink = EffectLinkEffects( eLink, eVisPersist);
			
			DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration ) );
		//}

		oTarget = GetNextFactionMember( oCaster, FALSE );
	}
}
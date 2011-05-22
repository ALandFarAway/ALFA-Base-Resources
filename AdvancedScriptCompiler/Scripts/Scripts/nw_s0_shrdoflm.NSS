//::///////////////////////////////////////////////
//:: Shroud of Flame 
//:: NW_S0_shdoflm
//:: Created By: Brock Heinz (JBH - OEI)
//:: Created On: August 9th, 2005
//:://////////////////////////////////////////////
/*
    From GDD:

	Player's Guide to Faern, pg. 110
	School:		Evocation [Fire]
	Components: 	Verbal, Somatic
	Range:		Close
	Target:		One creature
	Duration:	1 round / level
	Saving Throw:	Reflex negates
	Spell Resist:	Yes

	A single creature bursts into flames, taking 2d6 points of damage immediately 
	upon failing the saving throw. Each round the target makes a Reflex save, and 
	if unsuccessful takes an additional 2d6 points of damage. Any creature within 
	10 feet of the burning creature takes 1d4 points of fire damage per round, a 
	successful Reflex save negates all damage.

*/
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Metamagic changes
// BDF - OEI 10/16/06: revised RunRecurringEffects() so that DamageOther() is run each round
//	regardless of the target failing the saving throw; resolves TTP 17224

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells" 


const float SPELL_EFFECT_RADIUS = 3.0f;
const float DELAY_ONE_ROUND     = 6.0f;



int DamageShroudTarget( object oTarget, object oCaster, int nSpellSaveDC, int nMetaMagic )
{
	// Returns: 0 if the saving throw roll failed
	// Returns: 1 if the saving throw roll succeeded
	// Returns: 2 if the target was immune to the save type specified
    int nSave = ReflexSave( oTarget, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster );
	int nDidDamage = FALSE;
    if ( nSave == 0 )
    {
        int nDamage = d6(2);
		int nMaxVal = 2 * 6; // 2d6

        //Resolve metamagic
        //nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );               
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamage = nMaxVal;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);
        }

        effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oTarget );        

        effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

		nDidDamage = TRUE;
    }

	return nDidDamage;
}

void DamageOther( object oOther, object oCaster, int nSpellSaveDC, int nMetaMagic  )
{
    int nSave = ReflexSave( oOther, nSpellSaveDC, SAVING_THROW_TYPE_FIRE, oCaster );

    if ( nSave == 0 )
    {
        int nDamage = d4(1);
		int nMaxVal = 1 * 4; // 1d4
   
        //nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );           
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamage = nMaxVal;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);
        }

        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oOther );

        effect eVisual  = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		float fDuration = 0.75 + (nDamage*0.25);
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVisual, oOther, fDuration );        
    }

}

void RunRecurringEffects( object oTarget, object oCaster, float fDuration, int nMetaMagic )
{
	// uncomment for debugging.. 
	//SpawnScriptDebugger();
	
	// AFW-OEI 06/19/2007: If our (placeholder) Shroud of Flame VFX has been removed/dispelled,
	//	stop running the recurring effects loop.
	if (!GetHasSpellEffect(SPELL_SHROUD_OF_FLAME, oTarget))
	{
		return;
	}
	
	int nSpellSaveDC = GetDelayedSpellInfoSaveDC( SPELL_SHROUD_OF_FLAME, oTarget, oCaster );
	
    // Run the damage for this target this round
    //if ( DamageShroudTarget( oTarget, oCaster, nSpellSaveDC ) == TRUE )
	//{
		// If we actually hurt the guy, damage anybody nearby...
		// REVISED 10/16/06 BDF - OEI: run DamageOther() independently of DamageShroudTarget()
	DamageShroudTarget( oTarget, oCaster, nSpellSaveDC, nMetaMagic );
		
    location lTarget = GetLocation( oTarget );
    object oOther = GetFirstObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );

    while ( GetIsObjectValid(oOther) )
    {
        if ( spellsIsTarget( oOther, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oOther != oTarget) 
        {
			// Add a delay to the damage done to nearby enemies, based on their
			// distance from the target.
            float fDistance = GetDistanceBetweenLocations( lTarget, GetLocation(oOther) );
			float fDelay = 0.15f * fDistance;
			if ( fDelay > 1.75f )  // clamp it.. (it would be nice if this were a curve, but..)
				fDelay = 1.75f;
			DelayCommand(fDelay, DamageOther( oOther, oCaster, nSpellSaveDC, nMetaMagic ) );
        }

        oOther = GetNextObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
    }
	//}

	// If the target is still alive, and we've not run the max # of rounds for the spell...
	if ( GetIsDead(oTarget) == FALSE &&  fDuration > 0.0 )
	{
		// Que the effect to fire again.... 
        DelayCommand( DELAY_ONE_ROUND, RunRecurringEffects( oTarget, oCaster, fDuration-6.0, nMetaMagic) );
	}
	else
	{
		// The spell is not going to run another cycle, so get rid of the saved info
		RemoveDelayedSpellInfo( SPELL_SHROUD_OF_FLAME, oTarget, oCaster );
		RemoveSpellEffectsFromCaster( SPELL_SHROUD_OF_FLAME, oTarget, oCaster );
	}

}


void main()
{
	// uncomment for debugging.. 
	//SpawnScriptDebugger();


    if (!X2PreSpellCastCode())
    {
        return;
    }


    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    if ( GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster ))
    {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SHROUD_OF_FLAME, TRUE));

	    // Save the current save DC on the character because
        // GetSpellSaveDC won't work when delayed
		SaveDelayedSpellInfo( SPELL_SHROUD_OF_FLAME, oTarget, oCaster, GetSpellSaveDC() );
	
		// Play the effect of a visual explosion at the target location
   		location lTarget = GetLocation( oTarget );

	    float fDuration  = RoundsToSeconds(GetCasterLevel(oCaster));
		effect eDur = EffectVisualEffect(VFX_DUR_FIRE);
		fDuration = ApplyMetamagicDurationMods(fDuration);
		int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

        //effect eHand = EffectVisualEffect(VFX_DUR_GLOW_PURPLE);
        //ApplyEffectToObject(nDurType, eHand, oTarget, fDuration);

        //  Immediately damage the target, and any nearby enemies. 
		//	This will que the effect to run again if nessisary
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
        RunRecurringEffects( oTarget, oCaster, fDuration, nMetaMagic );
    }

}
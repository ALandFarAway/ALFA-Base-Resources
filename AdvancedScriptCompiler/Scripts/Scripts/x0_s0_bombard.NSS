//::///////////////////////////////////////////////
//:: Bombardment
//:: X0_S0_Bombard
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Rocks fall from sky
// 1d8 damage/level to a max of 10d8
// Reflex save for half
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nOrgDam;
    float fDelay;
    //effect eExplode = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eVis = EffectVisualEffect(VFX_HIT_AOE_FIRE);
    effect eDam;
	effect eKnockdown	=	EffectKnockdown();
    //Get the spell target location as opposed to the spell target.
	location lSourceLoc = GetLocation( OBJECT_SELF );
    location lTarget = GetSpellTargetLocation();
	int nCounter = 0;
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	
	
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10;
    }

    //Apply the fireball explosion at the location captured above.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
     	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {
           		float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				float fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCounter));
				nCounter++;

                //Roll damage for each target
                nDamage = d8(nCasterLvl);
                //Resolve metamagic
				nDamage = ApplyMetamagicVariableMods( nDamage, (8 * nCasterLvl) );
				nOrgDam = nDamage;
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                
				// Apply effects to the currently selected target.
				DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, SPELL_BOMBARDMENT, nPathType) );

                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

            if (nDamage > 0)
            {
                DelayCommand(fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				//if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ALL, OBJECT_SELF))
				if (nDamage == nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
				{
					DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds( 2 )) );
				}
            }
          	}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
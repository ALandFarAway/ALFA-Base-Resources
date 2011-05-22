//::///////////////////////////////////////////////
//:: Meteor Swarm
//:: NW_S0_MetSwarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Everyone in a 50ft radius around the caster
    takes 20d6 fire damage.  Those within 6ft of the
    caster will take no damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 24 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: 6/21/06 - BDF-OEI: modified to use NWN2 VFX

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

// stubs for possible extensions to the targeting
void HandleTargetSelf();
void HandleTargetCreature();
void HandleTargetLocation();

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
    int nMetaMagic;
    int nDamage;
    effect eFire;
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);	// no longer using NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_METEOR_SWARM );	// makes use of NWN2 VFX
    //Get first object in the spell area
//    float fTravelDelay;
//	float fHitDelay;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTargetLoc;
    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	int nCounter = 0;
	
    while(GetIsObjectValid(oTarget))
    {
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
    	{	 
			//Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM));
            //Make sure the target is outside the 2m safe zone
            if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
            {
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5))
    	        {
					lTargetLoc = GetLocation( oTarget );
            		float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );
					float fDelay;// = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCounter));
					if ( nCounter == 0 )	fDelay = 0.0f;
					else 					fDelay = GetRandomDelay( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCounter));
					nCounter++;
					
                    //Roll damage
                    nDamage = d6(20);

    		        //Enter Metamagic conditions
    		        if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		        {
    			       nDamage = 120;//Damage is at max
    		        }
    		        if (nMetaMagic == METAMAGIC_EMPOWER)
    		        {
    			       nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
             		}
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
                    //Set the damage effect
                    eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
					if(nDamage > 0)
                    {
                        //Apply damage effect and VFX impact.
						DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM, nPathType) );
                        DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget) );
                        DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                    }
				}
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
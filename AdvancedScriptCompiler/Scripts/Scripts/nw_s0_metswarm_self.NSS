//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s0_metswarm_self.nss
//::
//::	This is the spell script for the "target-self" version of Meteor Swarm.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 7/13/06
//::	Modified by: Constant Gaw
//::
//::///////////////////////////////////////////////////////////////////////////
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"
 

void HandleTargetSelf();


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

	object oTarget = GetSpellTargetObject();
	location lTarget;
	ExecuteDefaultMeteorSwarmBehavior( oTarget, lTarget );
	HandleTargetSelf();
}

void HandleTargetSelf()
{
    //Declare major variables
	int nMetaMagic;
    int nDamage;
    effect eFire;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM);	// makes use of NWN2 VFX
	effect eBump = EffectVisualEffect( VFX_FNF_SCREEN_BUMP );		
    //Get first object in the spell area
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTargetLoc;
    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	int nCounter = 0;
	float fDelay = 6.0f / IntToFloat( GetNumMeteorSwarmProjectilesToSpawnB(lSourceLoc) );
	float fDelay2 = 0.0f;
	float fTravelTime;
	
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lSourceLoc );
    while ( GetIsObjectValid(oTarget) )
    {
    	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
    	{	 
			//Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM) );
            //Make sure the target is outside the 2m safe zone
            if ( GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0 )
            {
                //Make SR check
                if ( !MyResistSpell(OBJECT_SELF, oTarget, 0.5) )
    	        {
					lTargetLoc = GetLocation( oTarget );
            		fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );
								
                    //Roll damage
                    nDamage = d6(6);

    		        //Enter Metamagic conditions
    		        if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		        {
    			       nDamage = 36;//Damage is at max
    		        }
    		        if (nMetaMagic == METAMAGIC_EMPOWER)
    		        {
    			       nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
             		}
                    nDamage = GetReflexAdjustedDamage( nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE );
                    //Set the damage effect
                    eFire = EffectDamage( nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
					
					if ( nDamage > 0 )
                    {
                        //Apply damage effect and VFX impact.
                        DelayCommand( fDelay2 + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget) );                     
                        DelayCommand( fDelay2 + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                        DelayCommand( fDelay2 + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBump, lTargetLoc) );												
                    }
					
					DelayCommand( fDelay2, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM, nPathType) );
					fDelay2 += fDelay;
				}
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lSourceLoc );
    }
}
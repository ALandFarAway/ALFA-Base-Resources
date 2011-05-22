//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s0_metswarm_other.nss
//::
//::	This is the spell script for the "target-location" version of Meteor Swarm.
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
 
void HandleTargetLocation( location lSpellTargetLocation );

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
	location lTarget = GetSpellTargetLocation();
	
	if ( oTarget == OBJECT_SELF )	oTarget = OBJECT_INVALID;
	
	ExecuteDefaultMeteorSwarmBehavior( oTarget, lTarget );
	
	HandleTargetLocation( lTarget );
}

void HandleTargetLocation( location lSpellTargetLocation )
{
    //Declare major variables
	int nMetaMagic;
    int nDamage;
    effect eFire;
	effect eVis;
	effect eBump = EffectVisualEffect( VFX_FNF_SCREEN_BUMP );
    //Get first object in the spell area

	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTargetLoc;
    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	int nCounter = 0;
	int i;
	float fDelay = 6.0f / IntToFloat( GetNumMeteorSwarmProjectilesToSpawnA(lSpellTargetLocation) );
	float fDelay2 = 0.0f;
	float fDelay3;
	float fTravelTime;
	float fRadiusSize;
	
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lSpellTargetLocation );	
	
    while ( GetIsObjectValid(oTarget) )
    {
    	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
    	{	 
			//Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM) );
			//Make SR check
			if ( !MyResistSpell(OBJECT_SELF, oTarget, 0.5) )
			{
				lTargetLoc = GetLocation( oTarget );
				fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );
									
				if (GetLocalInt(oTarget, "MeteorSwarmCentralTarget") == 1)				
				{
					i = 3;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_SML);	// makes use of NWN2 VFX
				}
				else if (GetLocalInt(oTarget, "MeteorSwarmNormalTarget") == 1)
				{
					i = 4;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_SML);	// makes use of NWN2 VFX
				}
				else	
				{
					i = 4;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM);	// makes use of NWN2 VFX				 
				}
							
				for (i; i <= 4; i++)
				{					
					if (GetLocalInt(oTarget, "MeteorSwarmCentralTarget") == 1 ||
						GetLocalInt(oTarget, "MeteorSwarmNormalTarget") == 1)			
					{
						//Roll damage
						nDamage = d6(12);
										
						//Enter Metamagic conditions
						if ( nMetaMagic == METAMAGIC_MAXIMIZE )
						{
							nDamage = 72;//Damage is at max
						}
						
						if ( nMetaMagic == METAMAGIC_EMPOWER )
						{
							nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
						}
					}
					
					else
					{
						//Roll damage
						nDamage = d6(6);
										
						//Enter Metamagic conditions
						if ( nMetaMagic == METAMAGIC_MAXIMIZE )
						{
							nDamage = 36;//Damage is at max
						}
						if ( nMetaMagic == METAMAGIC_EMPOWER )
						{
							nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
						}	
					}
					
					nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
	
					//Set the damage effect
					eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
								
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
				
				SetLocalInt(oTarget, "MeteorSwarmCentralTarget", 0);	
				SetLocalInt(oTarget, "MeteorSwarmNormalTarget", 0);				
			}
        }
		//Get next target in the spell area
   		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lSpellTargetLocation );	
    }	
}
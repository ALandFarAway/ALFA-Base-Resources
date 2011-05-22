//::///////////////////////////////////////////////////////////////////////////
//::
//::	nw_s0_metswarm_creature.nss
//::
//::	This is the spell script for the "target-creature" version of Meteor Swarm.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::	Created by: Brian Fox
//::	Created on: 7/13/06
//::	Modified by: Constant Gaw
//::
//::///////////////////////////////////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Fire damage gets doubled on criticals too
//::  No double damage on creatures immune to critical hits

#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"
 
void HandleTargetCreature(object oTarget);
effect DetermineFireEffect(object oTarget, int nTouchAttack);
effect DetermineBluntEffect(object oTarget, int nTouchAttack);
effect DetermineFireEffectNonTouch(object oTarget);
int DetermineFireDamageForTargetCreature(object oTarget, int nTouchAttackRanged);
int DetermineBluntDamageForTargetCreature(object oTarget, int nTouchAttackRanged);
int DetermineDamageForBlastCreature(object oTarget);

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
	
	if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
 		HandleTargetCreature( oTarget );
	}
}

int DetermineFireDamageForTargetCreature(object oTarget, int nTouchAttackRanged)
{
	int nDamage;
	int nMetaMagic;
	
	
	//Roll Damage for Main Target
	
	nDamage = d6(6);	

	if (nTouchAttackRanged == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		nDamage = d6(12);	
	}
			
	if (nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDamage = 36;//Damage is at max
	}
	
	if (nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%		
	}	
	
	if (nTouchAttackRanged < 1)
	{
		nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	}
	
	return nDamage;				
}	

int DetermineBluntDamageForTargetCreature(object oTarget, int nTouchAttackRanged)
{
	int nTouchAttack;
	int nBluntDamage;
	int nMetaMagic;
	
	switch(nTouchAttackRanged)
	{
		case 0:
			nBluntDamage = 0;	
			break;	
		case 2:
			nBluntDamage = d6(4);
			if (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
				break;
		case 1:
			nBluntDamage = d6(2);
			break;
	}
				
	if ((nMetaMagic == METAMAGIC_MAXIMIZE) && (nTouchAttackRanged = 3))
	{
		nBluntDamage = 24;//Damage is at max for a critical
	}
	else if (nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nBluntDamage = 12;
	}
	
	if (nMetaMagic == METAMAGIC_EMPOWER)
	{
		nBluntDamage = nBluntDamage + (nBluntDamage/2); //Damage/Healing is +50%
	}	
		
	return nBluntDamage;				
}	

int DetermineDamageForBlastCreature(object oTarget)
{
	int nDamage;
	int nMetaMagic;
	
	//Roll Damage for Main Target
	
	nDamage = d6(6);	
					
	if (nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDamage = 36;//Damage is at max
	}
	
	if (nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%		
	}	
	
	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
		
	return nDamage;
}

effect DetermineFireEffect(object oTarget, int nTouchAttack)
{
	//Set the damage effect	
//	int nTouchAttack = TouchAttackRanged(oTarget, TRUE); 	
	int nDamage = DetermineFireDamageForTargetCreature(oTarget, nTouchAttack);
	
	effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
	return eFire;
}

effect DetermineBluntEffect(object oTarget, int nTouchAttack)
{
	//Set the damage effect	
//	int nTouchAttack = TouchAttackRanged(oTarget, TRUE); 	
	int nDamage = DetermineBluntDamageForTargetCreature(oTarget, nTouchAttack);
		
	effect eBlunt = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY);
	return eBlunt;
}

effect DetermineFireEffectNonTouch(object oTarget)
{
	//Set the damage effect	
	int nDamage = DetermineFireDamageForTargetCreature(oTarget, 0);
	
	effect eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
	return eFire;
}

void HandleTargetCreature( object oTarget )
{
    //Declare major variables
	int nMetaMagic;
    int nDamage;
	int nBluntDamage;
	int nDamageMainTarget;
	int nBluntDamageMainTarget;
	effect eBlunt;
    effect eFire;	
	effect eBlunt2;
    effect eFire2;
	effect eBlunt3;
    effect eFire3;
	effect eBlunt4;
    effect eFire4;
//	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);	// makes use of NWN2 VFX 
	effect eVis = EffectNWN2SpecialEffectFile("sp_meteor_swarm_tiny_imp.sef");	// makes use of NWN2 VFX 
    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_LRG);	// makes use of NWN2 VFX
	effect eShake = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
    //Get first object in the spell area
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTargetLoc = GetLocation( oTarget );
    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	int nCounter;
	int i;
	int nTouchAttack;
	float fDelay = 6.0 / 4;
	object oTarget2;
	float fDelay2 = 2.0f;
	
	// SetLocalInt(oTarget, "MeteorSwarmPrimaryTarget", 1);
	
	//Travel Time Calculation for Main Target
	lTargetLoc = GetLocation( oTarget );
	float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );	
	
	// Check for Spell Resistance on Main Target
	
	if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5))
	{	
		nTouchAttack = TouchAttackRanged(oTarget, TRUE); 	
		eFire = DetermineFireEffect(oTarget, nTouchAttack);
		eBlunt = DetermineBluntEffect(oTarget, nTouchAttack);			

		DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget) );						
		DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlunt, oTarget) );	
		DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget) );	
		DelayCommand( fDelay + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lTargetLoc) );						
		DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM_TARGET_CREATURE, nPathType) );	
		
		nTouchAttack = TouchAttackRanged(oTarget, TRUE); 
		eFire2 = DetermineFireEffect(oTarget, nTouchAttack);
		eBlunt2 = DetermineBluntEffect(oTarget, nTouchAttack);
			
		DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire2, oTarget) );						
		DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlunt2, oTarget) );	
		DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget) );	
		DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lTargetLoc) );						
		DelayCommand( fDelay * 2, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM_TARGET_CREATURE, nPathType) );	

		nTouchAttack = TouchAttackRanged(oTarget, TRUE); 
		eFire3 = DetermineFireEffect(oTarget, nTouchAttack);
		eBlunt3 = DetermineBluntEffect(oTarget, nTouchAttack);
							
		DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire3, oTarget) );						
		DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlunt3, oTarget) );	
		DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget) );	
		DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lTargetLoc) );						
		DelayCommand( fDelay * 3, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM_TARGET_CREATURE, nPathType) );	

		nTouchAttack = TouchAttackRanged(oTarget, TRUE); 
		eFire4 = DetermineFireEffect(oTarget, nTouchAttack);	
		eBlunt4 = DetermineBluntEffect(oTarget, nTouchAttack);
				
		DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire4, oTarget) );						
		DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlunt4, oTarget) );	
		DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget) );	
		DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lTargetLoc) );						
		DelayCommand( fDelay * 4, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM_TARGET_CREATURE, nPathType) );		
	}	
	
	// Find the first object aside from the main target in blast radius.
	oTarget2 = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lTargetLoc );			
	
    while ( GetIsObjectValid(oTarget2) )
    {
		//if (GetLocalInt(oTarget2, "MeteorSwarmPrimaryTarget") == 0)
		if (oTarget2 != oTarget)
		{			
	    	if ( spellsIsTarget(oTarget2, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	    	{
				//Fire cast spell at event for the specified target
	            SignalEvent(oTarget2, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM));
				
				//Make SR check
				if (!MyResistSpell(OBJECT_SELF, oTarget2, 0.5))
				{
					eFire = DetermineFireEffectNonTouch(oTarget2);
					
				    //Apply damage effect and VFX impact.
				    DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget2) );
				    DelayCommand( fDelay + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget2) );	

					eFire2 = DetermineFireEffectNonTouch(oTarget2);					
													
				    DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire2, oTarget2) );
				    DelayCommand( (fDelay * 2) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget2) );

					eFire3 = DetermineFireEffectNonTouch(oTarget2);					
																			
				    DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire3, oTarget2) );
				    DelayCommand( (fDelay * 3) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget2) );							

					eFire4 = DetermineFireEffectNonTouch(oTarget2);					
																
				    DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire4, oTarget2) );
				    DelayCommand( (fDelay * 4) + fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget2) );
				}						
	        }
		}
		
	//Get next target in the spell area
	oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lTargetLoc);	
	}
		
//	SetLocalInt(oTarget, "MeteorSwarmPrimaryTarget", 0);
}
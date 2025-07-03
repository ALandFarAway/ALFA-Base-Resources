/*	Create two integer variables in the pleaceable.
	
	WORM_BLAST_DICE  The amount of damage dice to use (Be nice, it's doubled!)
	WORM_BLAST_RADIUS  From 1 to 6
	
	1 = Small Radius  	  = 1.524f; // ~5 feet
	2 = Medium Radius 	  = 3.048f; // ~10 feet
	3 = Large Radius 	  = 4.572f; // ~15 feet
	4 = Huge Radius   	  = 6.069f; // ~20 feet (Same as a Fireball)
	5 = Gargantuan Radius = 7.620f; // ~25 feet
	6 = Colossal Radius   = 9.144f; // ~30 feet
	
	Any other number or value will default to Large Radius
	
	Now you can place the items.  Add cold, and stand back and watch the fun!
/

#include "acr_vfx_i"
#include "acr_effects_i"
#include "acr_creature_i"

const string sDebris = "plc_mc_icerub03";  // Change tag to set new debris placeable
const float fBarrelTimeDelay = 0.5;	   // Changing this changes the base time delay
void main()
{
   ACR_CreatureOnDeath();
   
    object oWorm = OBJECT_SELF; 
	
	// Prevent the script from running again until the barrel has really died
	if (GetLocalInt(oWorm, "WORM_BLAST_EXPLODING")) return;
	SetLocalInt(oWorm, "WORM_BLAST_EXPLODING", TRUE);
	
		// Set initial variables
	location lBlastPoint = GetLocation(oWorm); 
	float fRadius;
	float fBangDelay;

	int nDice = GetLocalInt(OBJECT_SELF, "BARREL_BLAST_DICE");
	
	// Default to 1 Damage Die if none set
	nDice = nDice >= 1 ? nDice : 1;

	effect eColdDam   = EffectDamage(d6(nDice), DAMAGE_TYPE_COLD);
	effect ePierceDam = EffectDamage(d4(nDice), DAMAGE_TYPE_PIERCING);

	// Set Knockdown duration based on blast size
	float fDuration = IntToFloat(nDice) * 3.0;;
	
	effect eBlast = EffectKnockdown();
   
	// Check and set how big the damage radius is
	switch (GetLocalInt(OBJECT_SELF, "WORM_BLAST_RADIUS")) 
    { 
		case 1:  fRadius = RADIUS_SIZE_SMALL;      	break; 
		case 2:  fRadius = RADIUS_SIZE_MEDIUM; 	 	break; 
		case 3:  fRadius = RADIUS_SIZE_LARGE;		break; 
		case 4:  fRadius = RADIUS_SIZE_HUGE;		break; 
		case 5:  fRadius = RADIUS_SIZE_GARGANTUAN; 	break; 
		case 6:  fRadius = RADIUS_SIZE_COLOSSAL;	break; 
		default: fRadius = RADIUS_SIZE_LARGE;		break; 
    }
	
	effect eExplosion2 = EffectNWN2SpecialEffectFile( "sp_cold_hit.sef", oWorm);
	
	// If more than 4d6, BIG explosion and debris drops
    if (nDice >= 4)
	{
	    
        eExplosion2 = EffectNWN2SpecialEffectFile( "sp_ice_aoe.sef", oWorm);
        object oNewDebris = CreateObject(OBJECT_TYPE_PLACEABLE, sDebris, lBlastPoint, FALSE); 
        SetPlotFlag(oNewDebris, TRUE);
		
		// This is for Markshire's cleaning script
		// Leaving it in will not effect the object
		// unless you use the same variable for 
		// something else.
	    SetLocalInt(oNewDebris, "CLEANUP", 1);
      
		//Debug("Effect Object= " + ObjectToString(oBarrel));
	}
	
	// Fire the blast
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion2, lBlastPoint);

	// Look at all the Creatures, Placeables and Doors in the area and damage them  
	object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lBlastPoint, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR); 
	
	while (GetIsObjectValid(oVictim)) 
    { 
		// Set up delays and damage types
		fBangDelay = fBarrelTimeDelay + (GetDistanceBetween(oWorm, oVictim)/10.0);
		
		// If it's an environment object, leave it alone, otherwise BANG with Delay
		if (GetPlotFlag(oVictim) == FALSE)	
        {
			DelayCommand(fBangDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eColdDam , oVictim)); 
			DelayCommand(fBangDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePierceDam , oVictim));
			
			// If the Victim is a Creature knock em down
			// Blast has to be bigger then 2 to work 
			if (nDice > 2 & GetObjectType(oVictim) == OBJECT_TYPE_CREATURE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlast, oVictim, fDuration); 	   
			}
		  
			// Again if 4d6 or more, BIG bang		  
			if (nDice >= 4)
			{		  
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("sp_ice_storm_impact"), oVictim, 3.0); 
			}  
			// Again, if 2d6 or less small bang
			else
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("sp_rayfrost_hit"), oVictim, 3.0); 	  
			}	 
		}  
		// Get next victim!
		oVictim = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lBlastPoint, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR); 

	} // END WHILE
}
*/


#include "acr_vfx_i"
#include "acr_effects_i"
#include "acr_creature_i"

void main()
{
    effect eDamage;

    // Get the creature who triggered this event.
    object oPC = GetLastKiller();

    // We are really interested in the ultimate master of the killer.
    while ( GetMaster(oPC) != OBJECT_INVALID )
        oPC = GetMaster(oPC);

    // Cause damage.
    eDamage = EffectDamage(d6(8), DAMAGE_TYPE_PIERCING);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);

    // Cause damage.
   eDamage = EffectDamage(d6(12), DAMAGE_TYPE_COLD);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
}
  
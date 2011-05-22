// gc_is_enemy_near(float fRadius, int bLineOfSight)
/*
   This script checks if an enemy creature is within a given radius from the PC Speaker.

   Parameters:
     float fRadius    = The radius of the sphere to check within.
     int bLineOfSight =  If =1 check line of sight from PC.
*/
// TDE 3/9/05
// ChazM 3/10/05
// BMA-OEI 1/11/06 removed default param, change oPC from OBJECT_SELF to PC Speaker
// DBR 2/09/06 - Made sure enemy was alive as well

int StartingConditional(float fRadius, int bLineOfSight)
{
    object oPC = GetPCSpeaker();
    location lPC = GetLocation(oPC);

	// Search for any creatures that are the enemy of the PC.
    object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lPC, bLineOfSight, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(oCreature) == TRUE)
    {
        if (GetIsEnemy(oPC, oCreature) == TRUE)
			if (GetCurrentHitPoints(oCreature)>0)
				return (TRUE);

		oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lPC, bLineOfSight, OBJECT_TYPE_CREATURE);
    }

    // No objects found.
    return (FALSE);
}
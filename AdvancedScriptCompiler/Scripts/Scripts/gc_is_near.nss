// gc_is_near(string sTag, string sObjTypes, float fRadius, int bLineOfSight)
/*
   This script checks if any object within fRadius radius to the OWNER contains
   the partial tag sTag.
	
   Parameters:
     string sTag      = The tag or partial tag to match to objects nearby.
	                    e.g. "guard" will match "guard1", "guard2", "blackguard"
     string sObjTypes = Filter which types of objects to compare to.
                        C = creature
                        I = item
                        T = trigger
                        D = door
                        A = area of effect
                        W = waypoint
                        P = placeable
                        S = store
                        E = encounter
                        ALL = everything
                        e.g. "CPI" will search only creatures, placeables, and items
     float fRadius    = Radius of sphere to check within. e.g. "20.0f" = 20 meters
     int bLineOfSight = If =1 check line of sight from OWNER.
*/
// TDE 3/9/05
// ChazM 3/10/05
// BMA 4/28/05 replaced local function with ginc_param_const include
// BMA-OEI 1/11/06 removed default param

#include "ginc_param_const"

int StartingConditional(string sTag, string sObjTypes, float fRadius, int bLineOfSight)
{
    object oSelf = OBJECT_SELF;
    location lSelf = GetLocation(OBJECT_SELF);
    int iObjectFilter = GetObjectTypes(sObjTypes);     // Determine objects to filter
    object oObject = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lSelf, bLineOfSight, iObjectFilter);

    // Search for any objects whose tags contain sName.
    while(GetIsObjectValid(oObject) == TRUE)
    {
        if (FindSubString(GetTag(oObject), sTag) >= 0 )
            return (TRUE);

        oObject = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lSelf, bLineOfSight, iObjectFilter);
    }

    // No objects found.
    return (FALSE);
}

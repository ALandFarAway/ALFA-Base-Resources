//:://////////////////////////////////////////////////
//:: X0_I0_POSITION
/*
Include file for functions that can be used to determine
locations and positions.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/08/2002
//:://////////////////////////////////////////////////
// 5/17/05 ChazM modified GetNormalizedDirection(), added GetAngle(), GetAngleBetweenObjects(),
//          IsDirectionWithinTolerance(), IsFacingWithin(), IsCreatureInView(), IsPlaceableInView()
// 7/13/06 BDF added GetLeftLocation() and GetRightLocation()
// BMA-OEI 7/13/06 -- Updated GetRandomLocation()
// CG-OEI 7/16/06 -- Updated GetXLocation() functions to accept float distances.

/**********************************************************************
 * CONSTANTS
 **********************************************************************/

// Distances used for determining positions
const float DISTANCE_TINY = 1.0;
const float DISTANCE_SHORT = 3.0;
const float DISTANCE_MEDIUM = 5.0;
const float DISTANCE_LARGE = 10.0;
const float DISTANCE_HUGE = 20.0;




/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

// Turn a location into a string. Useful for debugging.
string LocationToString(location loc);

// Turn a vector into a string. Useful for debugging.
string VectorToString(vector vec);

// This actually moves the target to the given new location,
// and makes them face the correct way once they get there.
void MoveToNewLocation(location lNewLocation, object oTarget=OBJECT_SELF);

// This returns the change in X coordinate that should be made to
// cause an object to be fDistance away at fAngle.
float GetChangeInX(float fDistance, float fAngle);

// This returns the change in Y coordinate that should be made to
// cause an object to be fDistance away at fAngle.
float GetChangeInY(float fDistance, float fAngle);

// This returns a new vector representing a position that is fDistance
// meters away at fAngle from the original position.
// If a negative coordinate is generated, the absolute value will
// be used instead.
vector GetChangedPosition(vector vOriginal, float fDistance, float fAngle);

// This returns the angle between two locations
float GetAngleBetweenLocations(location lOne, location lTwo);

/********** DIRECTION *************/

// This returns the opposite direction (ie, this is the direction you
// would use to set something facing exactly opposite the way of
// something else that's facing in direction fDirection).
float GetOppositeDirection(float fDirection);

// This returns the direction directly to the right. (IE, what
// you would use to make an object turn to the right.)
float GetRightDirection(float fDirection);

// This returns a direction that's a half-turn to the right
float GetHalfRightDirection(float fDirection);

// This returns a direction one and a half turns to the right
float GetFarRightDirection(float fDirection);

// This returns a direction a specified angle to the right
float GetCustomRightDirection(float fDirection, float fAngle);

// This returns the direction directly to the left. (IE, what
// you would use to make an object turn to the left.)
float GetLeftDirection(float fDirection);

// This returns a direction that's a half-turn to the left
float GetHalfLeftDirection(float fDirection);

// This returns a direction one and a half turns to the left
float GetFarLeftDirection(float fDirection);

// This returns a direction a specified angle to the left
float GetCustomLeftDirection(float fDirection, float fAngle);

/******** LOCATION FUNCTIONS *********/
/*
 * These functions return new locations suitable for placing
 * created objects in relation to a target, for example.
 *
 */

// Turns the target object to face the specified object
void TurnToFaceObject(object oObjectToFace, object oTarget=OBJECT_SELF);

// Returns the location flanking the target to the right
// (slightly behind) and facing same direction as the target
// (useful for backup)
location GetFlankingRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns the location flanking the target to the left
// (slightly behind) and facing same direction as the target.
// (useful for backup)
location GetFlankingLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns a location directly opposite the target and
// facing the target
location GetOppositeLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location directly ahead of the target and facing
// same direction as the target
location GetAheadLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location directly behind the target and facing same
// direction as the target (useful for backstabbing attacks)
location GetBehindLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location to the forward right flank of the target
// and facing the same way as the target
// (useful for guarding)
location GetForwardFlankingRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location to the forward left flank of the target
// and facing the same way as the target
// (useful for guarding)
location GetForwardFlankingLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location to the forward right and facing the target.
// (useful for one of two people facing off against the target)
location GetAheadRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location to the forward left and facing the target.
// (useful for one of two people facing off against the target)
location GetAheadLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location just a step to the left
// (Let's do the time warp...)
location GetStepLeftLocation(object oTarget);

// Returns location just a step to the right
location GetStepRightLocation(object oTarget);

// Get a random location in a given area based on a given object,
// the specified distance away.
// If no object is given, will use a random object in the area.
// If that is not available, will use the roughly-center point
// of the area.
// If distance is <= to 0.0, a random distance will be used.
location GetRandomLocation( object oArea, object oSource=OBJECT_INVALID, float fDist=0.0f );

// new NWN2 funcs

// return angle from origin point to Target point (from 0 to 360)
float GetAngle(vector vOrigin, vector vTarget, float fDist);

// This returns the angle between two locations
float GetAngleBetweenObjects(object oBegin, object oEnd);

int IsDirectionWithinTolerance(float fCheckDirection, float fDirection, float fDegreesOfTolerance);

// see if I am faicing within fDegrees of Object
int IsFacingWithin(float fDegrees, object oObject);

// Is the placeable within view?
// oViewObj - placeable to look for
// fAngle - degrees to look to the right.  Full view Arc is twice this.
// fMaxDistance - No way to get percetption range, so a distance is needed
int IsPlaceableInView(object oViewObj, float fAngle=75.0f, float fMaxDistance = DISTANCE_LARGE);

// Is the creature within view?
// oViewObj - creature to look for
// fAngle - degrees to look to the right.  Full view Arc is twice this.
int IsCreatureInView(object oViewObj, float fAngle=75.0f);

// Returns location directly left of the target and facing same
// direction as the target
location GetLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

// Returns location directly right of the target and facing same
// direction as the target
location GetRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM);

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

// Speak location -- private function for debugging
void SpeakLocation(location lLoc)
{
    SpeakString(LocationToString(lLoc));
}

// Print location --- private function for debugging
void PrintLocation(location lLoc)
{
    PrintString(LocationToString(lLoc));
}

// Turn a location into a string. Useful for debugging.
string LocationToString(location loc)
{
    return "(" + GetTag(GetAreaFromLocation(loc)) + ")"
        + " " + VectorToString(GetPositionFromLocation(loc))
        + " (" + FloatToString(GetFacingFromLocation(loc)) + ")";
}


// Turn a vector into a string. Useful for debugging.
string VectorToString(vector vec)
{
    return "(" + FloatToString(vec.x)
        + ", " + FloatToString(vec.y)
        + ", " + FloatToString(vec.z) + ")";
}



// This actually moves the target to the given new location,
// and makes them face the correct way once they get there.
void MoveToNewLocation(location lNewLocation, object oTarget=OBJECT_SELF)
{
    AssignCommand(oTarget, ActionMoveToLocation(lNewLocation));
    AssignCommand(oTarget,
                  ActionDoCommand(
                        SetFacing(GetFacingFromLocation(lNewLocation))));
}


// This returns the change in X coordinate that should be made to
// cause an object to be fDistance away at fAngle.
float GetChangeInX(float fDistance, float fAngle)
{
    return fDistance * cos(fAngle);
}

// This returns the change in Y coordinate that should be made to
// cause an object to be fDistance away at fAngle.
float GetChangeInY(float fDistance, float fAngle)
{
    return fDistance * sin(fAngle);
}

// This returns a new vector representing a position that is fDistance
// meters away in the direction fAngle from the original position.
// If a negative coordinate is generated, the absolute value will
// be used instead.
vector GetChangedPosition(vector vOriginal, float fDistance, float fAngle)
{
    vector vChanged;
    vChanged.z = vOriginal.z;
    vChanged.x = vOriginal.x + GetChangeInX(fDistance, fAngle);
    if (vChanged.x < 0.0)
        vChanged.x = - vChanged.x;
    vChanged.y = vOriginal.y + GetChangeInY(fDistance, fAngle);
    if (vChanged.y < 0.0)
        vChanged.y = - vChanged.y;

    return vChanged;
}

// This returns the angle between two locations
float GetAngleBetweenLocations(location lOne, location lTwo)
{
    vector vPos1 = GetPositionFromLocation(lOne);
    vector vPos2 = GetPositionFromLocation(lTwo);
    float fDist = GetDistanceBetweenLocations(lOne, lTwo);

    float fChangeX = IntToFloat(abs(FloatToInt(vPos1.x - vPos2.x)));

    float fAngle = acos(fChangeX / fDist);
    return fAngle;
}


// This returns a direction normalized to the range 0.0 - 360.0
float GetNormalizedDirection(float fDirection)
{
    float fNewDir = fDirection;
    while (fNewDir >= 360.0) {
        fNewDir -= 360.0;
    }
    while (fNewDir <= 0.0) {
        fNewDir += 360.0;
    }

    return fNewDir;
}

// This returns the opposite direction (ie, this is the direction you
// would use to set something facing exactly opposite the way of
// something else that's facing in direction fDirection).
float GetOppositeDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection + 180.0);
}


// This returns the direction directly to the right. (IE, what
// you would use to make an object turn to the right.)
float GetRightDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection - 90.0);
}

// This returns a direction that's a half-turn to the right
float GetHalfRightDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection - 45.0);
}

// This returns a direction one and a half turns to the right
float GetFarRightDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection - 135.0);
}

// This returns a direction a specified angle to the right
float GetCustomRightDirection(float fDirection, float fAngle)
{
    return GetNormalizedDirection(fDirection - fAngle);
}

// This returns the direction directly to the left. (IE, what
// you would use to make an object turn to the left.)
float GetLeftDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection + 90.0);
}

// This returns a direction that's a half-turn to the left
float GetHalfLeftDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection + 45.0);
}

// This returns a direction one and a half turns to the left
float GetFarLeftDirection(float fDirection)
{
    return GetNormalizedDirection(fDirection + 135.0);
}

// This returns a direction a specified angle to the left
float GetCustomLeftDirection(float fDirection, float fAngle)
{
    return GetNormalizedDirection(fDirection + fAngle);
}

/**********************************************************************
 * LOCATION FUNCTIONS
 **********************************************************************/

// Turns the object to face the specified object
void TurnToFaceObject(object oObjectToFace, object oTarget=OBJECT_SELF)
{
    AssignCommand(oTarget,
                  SetFacingPoint(
                        GetPosition(oObjectToFace)));
}

// Private function -- we use this to get the new location
location GenerateNewLocation(object oTarget, float fDistance, float fAngle, float fOrientation)
{
    object oArea = GetArea(oTarget);
    vector vNewPos = GetChangedPosition(GetPosition(oTarget),
                                        fDistance,
                                        fAngle);
    return Location(oArea, vNewPos, fOrientation);
}

// Private function -- we use this to get the new location
// from a source location.
location GenerateNewLocationFromLocation(location lTarget, float fDistance, float fAngle, float fOrientation)
{
    object oArea = GetAreaFromLocation(lTarget);
    vector vNewPos = GetChangedPosition(GetPositionFromLocation(lTarget),
                                        fDistance,
                                        fAngle);
    return Location(oArea, vNewPos, fOrientation);
}



// This returns the location flanking the target to the right
location GetFlankingRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleToRightFlank = GetFarRightDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngleToRightFlank,
                               fDir);
}


// Returns the location flanking the target to the left
// (slightly behind) and facing same direction as the target.
// (useful for backup)
location GetFlankingLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleToLeftFlank = GetFarLeftDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngleToLeftFlank,
                               fDir);
}


// Returns a location directly ahead of the target and
// facing the target
location GetOppositeLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = GetOppositeDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fDir,
                               fAngleOpposite);
}

// Returns location directly ahead of the target and facing
// same direction as the target
location GetAheadLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fDir,
                               fDir);
}

// Returns location directly behind the target and facing same
// direction as the target (useful for backstabbing attacks)
location GetBehindLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngleOpposite = GetOppositeDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngleOpposite,
                               fDir);
}


// Returns location to the forward right flank of the target
// and facing the same way as the target
// (useful for guarding)
location GetForwardFlankingRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetHalfRightDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngle,
                               fDir);
}


// Returns location to the forward left flank of the target
// and facing the same way as the target
// (useful for guarding)
location GetForwardFlankingLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetHalfLeftDirection(fDir);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngle,
                               fDir);
}

// Returns location to the forward right and facing the target.
// (useful for one of two people facing off against the target)
location GetAheadRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetHalfRightDirection(fDir);
    float fFaceAngle = GetOppositeDirection(fAngle);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngle,
                               fFaceAngle);
}

// Returns location to the forward left and facing the target.
// (useful for one of two people facing off against the target)
location GetAheadLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetHalfLeftDirection(fDir);
    float fFaceAngle = GetOppositeDirection(fAngle);
    return GenerateNewLocation(oTarget,
                               fDistance,
                               fAngle,
                               fFaceAngle);
}


// Returns location just a step to the left
// (Let's do the time warp...)
location GetStepLeftLocation(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetLeftDirection(fDir);
    return GenerateNewLocation(oTarget,
                               DISTANCE_TINY,
                               fAngle,
                               fDir);
}

// Returns location just a step to the right
location GetStepRightLocation(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetRightDirection(fDir);
    return GenerateNewLocation(oTarget,
                               DISTANCE_TINY,
                               fAngle,
                               fDir);
}

// Get the (roughly) center point of an area.
// This works by going through all the objects in an area and
// getting their positions, so it is resource-intensive.
location GetCenterPointOfArea(object oArea)
{
    float fXMax = 0.0;
    float fXMin = 10000.0;
    float fYMax = 0.0;
    float fYMin = 10000.0;

    object oTmp = OBJECT_INVALID;
    vector vTmp;

    oTmp = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oTmp)) {
        vTmp = GetPositionFromLocation(GetLocation(oTmp));
        if (vTmp.x > fXMax)
            fXMax = vTmp.x;
        if (vTmp.x < fXMin)
            fXMin = vTmp.x;
        if (vTmp.y > fYMax)
            fYMax = vTmp.y;
        if (vTmp.y < fYMin)
            fYMin = vTmp.y;
        oTmp = GetNextObjectInArea(oArea);
    }

    // We now have the max and min positions of all objects in an area.
    vTmp = Vector( (fXMax + fXMin)/2.0, (fYMax + fYMin)/2.0, 0.0);

    //PrintString("Center vector: " + VectorToString(vTmp));

    return Location(oArea, vTmp, 0.0);
}

// Get a random location in a given area based on a given object,
// the specified distance away.
// If no object is given, will use a random object in the area.
// If that is not available, will use the roughly-center point
// of the area.
// If distance is <= to 0.0, a random distance will be used.
location GetRandomLocation( object oArea, object oSource=OBJECT_INVALID, float fDist=0.0f )
{
	location lStart;
	
	if ( GetIsObjectValid( oSource ) == FALSE )
	{
		lStart = GetCenterPointOfArea( oArea );
	}
	else
	{
		lStart = GetLocation( oSource );
	}
	
	// BMA-OEI 7/13/06 float precision
	if ( fDist <= 0.001f )
	{
		fDist = IntToFloat( Random( FloatToInt( DISTANCE_HUGE - DISTANCE_TINY ) * 10 ) ) / 10;
	}	
	
	float fAngle = IntToFloat( Random( 360 ) );
	float fOrient = IntToFloat( Random( 360 ) );
	location lRandLoc = GenerateNewLocationFromLocation( lStart, fDist, fAngle, fOrient );
	
	return ( lRandLoc );
	
/*    if (fDist == 0.0) {
        int nRoll = Random(3);
        switch (nRoll) {
        case 0:
            fDist = DISTANCE_MEDIUM; break;
        case 1:
            fDist = DISTANCE_LARGE; break;
        case 2:
            fDist = DISTANCE_HUGE; break;
        }
    }

    fAngle = IntToFloat(Random(140) + 40);
*/
}

///////////////////////////////////////////////
// NWN2 new functions
///////////////////////////////////////////////

// return angle from origin point to Target point (from 0 to 360)
float GetAngle(vector vOrigin, vector vTarget, float fDist)
{
    float fChangeX = vTarget.x - vOrigin.x;
    float fChangeY = vTarget.y - vOrigin.y;

    float fAngle = acos(fChangeX / fDist);
    // acos alway returns 0-180
    if (fChangeY < 0.0f){
        // GetNormalizedDirection doesn't work with negative angles
        fAngle = GetNormalizedDirection(-fAngle + 360.0f);
    }

    return fAngle;
}

// This returns the angle between two locations
float GetAngleBetweenObjects(object oBegin, object oEnd)
{
    vector vPos1 = GetPosition(oBegin);
    vector vPos2 = GetPosition(oEnd);
    float fDist = GetDistanceBetween(oBegin, oEnd);

    return (GetAngle(vPos1, vPos2, fDist));
}


int IsDirectionWithinTolerance(float fCheckDirection, float fDirection, float fDegreesOfTolerance)
{
    if (fDegreesOfTolerance >= 180.0f)
        return TRUE;


    int iRet = FALSE;
    float fLeftDir = GetNormalizedDirection (fDirection + fDegreesOfTolerance);
    float fRightDir = GetNormalizedDirection(fDirection - fDegreesOfTolerance);

    // is it left of the right most direction?
    // is it right of the left most direction?

    if (fRightDir < fLeftDir) {
        // 0<right<left<360 - andgle doesn't cross 360 boundary
        if ((fCheckDirection > fRightDir) && (fCheckDirection < fLeftDir))
            iRet = TRUE;
    }
    else {
        // 0<left<right<360 - angle crosses 360 boundary
        if ((fCheckDirection > fRightDir) || (fCheckDirection < fLeftDir))
            iRet = TRUE;

    }
    return iRet;
}

// see if I am faicing within fDegrees of Object
int IsFacingWithin(float fDegrees, object oObject)
{
    int iRet;
    // return direction in degrees.
    float fDirectionOfFacing = GetFacing(OBJECT_SELF);

    float fDirectionOfObject = GetAngleBetweenObjects(OBJECT_SELF, oObject);

    // float fDelta = GetNormalizedDirection(fDirectionOfFacing - fDirectionOfObject);

    iRet = IsDirectionWithinTolerance(fDirectionOfObject, fDirectionOfFacing, fDegrees);
    return (iRet);
}


// Is the placeable within view?
// oViewObj - placeable to look for
// fAngle - degrees to look to the right.  Full view Arc is twice this.
// fMaxDistance - No way to get percetption range, so a distance is needed
int IsPlaceableInView(object oViewObj, float fAngle=75.0f, float fMaxDistance = DISTANCE_LARGE)
{
    string msg2 = " No fire ";

    // is the object valid?
    if (!GetIsObjectValid(oViewObj))
        return FALSE;

    // is the object within range of seeing?
    if (GetDistanceToObject(oViewObj) > fMaxDistance)
        return FALSE;

    // am I facing the object?
    int bFacing = IsFacingWithin(fAngle, oViewObj);
    if (!bFacing)
        return FALSE;

    // is the object in my line of sight
    // presumed that this is the most expensive function and thus done last
    int bLoS = LineOfSightObject(OBJECT_SELF, oViewObj);
    if (!bLoS)
        return FALSE;


    return TRUE;
}

// Is the creature within view?
// oViewObj - creature to look for
// fAngle - degrees to look to the right.  Full view Arc is twice this.
int IsCreatureInView(object oViewObj, float fAngle=75.0f)
{
    // is the object valid?
    if (!GetIsObjectValid(oViewObj))
        return FALSE;

    // can I see the object?
    // this should take into account Line of sight and
    // distance based on percetption range
    int bSeen = GetObjectSeen(oViewObj);
    if (!bSeen)
        return FALSE;

    // am I facing the object?
    int bFacing = IsFacingWithin(fAngle, oViewObj);
    if (!bFacing)
        return FALSE;

    return TRUE;
}

// Returns location directly left of the target and facing same
// direction as the target
location GetLeftLocation(object oTarget, float fDistance=DISTANCE_MEDIUM )
{
	float fFacing = GetFacing( oTarget );
	float fLeftDir = GetLeftDirection( fFacing );
	return GenerateNewLocation( oTarget, fDistance, fLeftDir, fFacing );
}

// Returns location directly right of the target and facing same
// direction as the target
location GetRightLocation(object oTarget, float fDistance=DISTANCE_MEDIUM)
{
	float fFacing = GetFacing( oTarget );
	float fRightDir = GetRightDirection( fFacing );
	return GenerateNewLocation( oTarget, fDistance, fRightDir, fFacing );
}

//  void main() {} /* */
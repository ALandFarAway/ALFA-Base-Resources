/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_position_i.NSS
//    $Revision:: 1        $ current version of the file
//        $Date:: 2020-07-04 date the file was created or modified
//       Author : Paazin
//
//
//  Description
//  Include for handling position: directions and distances
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x0_i0_position"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float METER_TO_FEET = 3.28084;
const float NUMBER_OF_COMPASS_DIRECTIONS = 16.0;
const float HALF_COMPASS_ANGLE = 360.0/(NUMBER_OF_COMPASS_DIRECTIONS * 2.0);

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

float MetersToFeet(float fMeters);
string GetCompassDirectionOfBearing(float fDegrees);
string GetCompassDirectionOfAngle(float fAngle);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

float MetersToFeet(float fMeters)
{
    return METER_TO_FEET * fMeters;
}


string GetDisplayableDistance(float fDistance)
{
    /* Takes a distance in meters and returns a displayable value showing
     * relative distance
     */
    string sFeet, sRelativeDistance;

    // turns meter distance into displayable feet, e.g. 1.0 -> "3"
    sFeet = FloatToString(MetersToFeet(fDistance), 0, 0);

    if (fDistance < 0.8f) {
        sRelativeDistance = "very close";
    } else if (fDistance < 2.0f) {
        sRelativeDistance = "close";
    } else if (fDistance < 4.0f) {
        sRelativeDistance = "nearby";
    } else if (fDistance < 8.0f) {
        sRelativeDistance = "not too far away";
    } else if (fDistance < 16.0f) {
        sRelativeDistance = "moderately distant";
    } else if (fDistance < 32.0f) {
        sRelativeDistance = "far away";
    } else {
        sRelativeDistance = "very far away";
    }
    return sRelativeDistance + " (" + sFeet + " ft)";
}


string GetCompassDirectionOfBearing(float fDegrees)
{
    /* Takes a bearing from degrees (0.0 -> 360.0) where 0.0 is North and 90.0
     * is East and returns its corresponding compass direction
     */

    // Handle cases when the caller is lazy (i.e. passes in > 360 or < 0)
    while (fDegrees < 0.0) {
        fDegrees += 360.0;
    }
    while (fDegrees > 360.0) {
        fDegrees -= 360.0;
    }

    // Do the mapping
    if (fDegrees < HALF_COMPASS_ANGLE || fDegrees > HALF_COMPASS_ANGLE * 31) {
        return "north";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 3) {
        return "north-northeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 5) {
        return "northeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 7) {
        return "east-northeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 9) {
        return "east";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 11) {
        return "east-southeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 13) {
        return "southeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 15) {
        return "south-southeast";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 17) {
        return "south";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 19) {
        return "south-southwest";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 21) {
        return "southwest";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 23) {
        return "west-southwest";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 25) {
        return "west";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 27) {
        return "west-northwest";
    }
    else if (fDegrees < HALF_COMPASS_ANGLE * 29) {
        return "northwest";
    }
    return "north-northwest";
}


string GetCompassDirectionOfAngle(float fAngle)
{
    /* Takes an angle from degrees (0.0 -> 360.0) where 0.0 is the positive
     * X-axis and 90.0 is the positive Y-axis and returns its corresponding
     * compass direction
     */
    return GetCompassDirectionOfBearing(-fAngle + 90.0);
}

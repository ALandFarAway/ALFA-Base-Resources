/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_analyzeportal.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2020-06-10 date the file was created or modified
//       Author : Wynna, Paazin
//
//
//  Description
//  Analyze Portal as per FRCS
//  (Does require proper set up on portals ingame to function)
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x0_i0_position"
#include "acr_spells_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const float NUMBER_OF_COMPASS_DIRECTIONS = 16.0;
const float HALF_COMPASS_ANGLE = 360.0/(NUMBER_OF_COMPASS_DIRECTIONS * 2.0);

const string ACR_PORTAL_TAG_PREFIX = "alfa_portal_";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string GetCompassDirectionOfBearing(float fDegrees);
string GetCompassDirectionOfAngle(float fAngle);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string GetCompassDirectionOfBearing(float fDegrees)
{
    /* Takes a bearing from degrees (0.0 -> 360.0)
     * where 0.0 is North and 90.0 is West and
     * returns its corresponding compass direction
     */

    // Handle cases when the caller is lazy
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
    /* Takes an angle from degrees (0.0 -> 360.0)
     * where 0.0 is the positive X-axis and 90.0
     * is the positive Y-axis and returns its
     * corresponding compass direction
     */
    return GetCompassDirectionOfBearing(-fAngle + 90.0);
}


void main()
{
    int nSpellId = GetSpellId();
    object oCaster = OBJECT_SELF;
    object oTarget;
    object oPortal;
    int nCasterLevel;
    int nPortalNumber = 0;
    float fResultsDelay = 0.0;
    float fDuration;
    float fAngleCasterFacing;
    float fAnglePortalFromCaster;
    float fAnglePortalFacingFromCaster;
    location lTarget;
    string sTagPrefix;

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!ACR_PrecastEvent()) {
        return;
    }

    oTarget = oCaster;  // Target of spell is always caster, despite what someone might target

    lTarget = GetSpellTargetLocation();

    // Signal event successful
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

    nCasterLevel = ACR_GetCorrectCasterLevel(oCaster);
    fDuration = ACR_GetSpellDuration(oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_1R);

	SetLocalFloat(oCaster, "AnalyzePortalFloatDelay", 0.0);
	SendMessageToAllDMs(GetName(oCaster) + " is casting Analyze Portal");
	oPortal = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oCaster), FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR);
	while(oPortal != OBJECT_INVALID) {
		// Terminate check if the spell expires
		if (fDuration < fResultsDelay) {
			return;
		}
		fAnglePortalFromCaster = GetAngleBetweenObjects(oCaster, oPortal);
		fAngleCasterFacing = GetFacing(oCaster);
		fAnglePortalFacingFromCaster = fAnglePortalFromCaster - fAngleCasterFacing;
		sTagPrefix = GetStringLeft(GetTag(oPortal), GetStringLength(ACR_PORTAL_TAG_PREFIX));
		if(
			(fabs(fAnglePortalFacingFromCaster) <= 45.0) &&
			(sTagPrefix == ACR_PORTAL_TAG_PREFIX)
		) {
			if(GetObjectType(oPortal) == OBJECT_TYPE_PLACEABLE) {
				SetUseableFlag(oPortal, TRUE);
				}
			string sPortalLocation = GetLocalString(oPortal, "PORTAL_LOCATION");
			string sPortalCommand = GetLocalString(oPortal, "PORTAL_COMMAND");
			string sPortalCirc = GetLocalString(oPortal, "PORTAL_CIRCUMSTANCE");
			string sPortalDirection = GetLocalString(oPortal, "PORTAL_DIRECTION");
			string sPortalProps = GetLocalString(oPortal, "PORTAL_PROPERTIES");
			string sPortalDest = GetLocalString(oPortal, "PORTAL_DESTINATION");
			string sPortalFunc = GetLocalString(oPortal, "PORTAL_FUNCTIONALITY");
			string sPortalCompassDirection = GetCompassDirectionOfAngle(fAnglePortalFromCaster);

			if(nPortalNumber == 0) {
				SendMessageToPC(
					oCaster,
					"You have discovered a portal within 60 feet! " +
					"It is " + sPortalCompassDirection + " of your position. " +
					sPortalLocation
				);
				}
			else {
				fResultsDelay = GetLocalFloat(oCaster, "AnalyzePortalFloatDelay") + 12.0;
				SetLocalFloat(oCaster, "AnalyzePortalFloatDelay", fResultsDelay + 6.0);
				DelayCommand(
					fResultsDelay,
					SendMessageToPC(
						oCaster,
						"You have discovered another portal within 60 feet! " +
						"It is " + sPortalCompassDirection + " of your position. " +
						sPortalLocation
					)
				);
				}
			SendMessageToAllDMs(
				GetName(oCaster) +
				" has discovered a portal. " +
				" It is " + sPortalCompassDirection + " of the PC. " +
				sPortalLocation +
				" The PC will also learn the following information in increments of 6 seconds:"
				);
			int nCLCheck;
			string sPortalVariable;
			for(nCLCheck = 0; nCLCheck < 6; nCLCheck++) {

					switch(nCLCheck) {
					case 0:
						sPortalVariable = sPortalCommand;
						break;
					case 1:
						sPortalVariable = sPortalCirc;
						break;
					case 2:
						sPortalVariable = sPortalDirection;
						break;
					case 3:
						sPortalVariable = sPortalProps;
						break;
					case 4:
						sPortalVariable = sPortalDest;
						break;
					case 5:
						sPortalVariable = sPortalFunc;
						break;
					   }

				if(d20(1) + nCasterLevel >= 17) {
					SendMessageToAllDMs(GetName(oCaster) + " learned: " + sPortalVariable);
					SetLocalFloat(oCaster, "AnalyzePortalFloatDelay", fResultsDelay + 6.0);
					fResultsDelay = fResultsDelay + 6.0;
					DelayCommand(fResultsDelay, SendMessageToPC(oCaster, sPortalVariable));
					}
				else {SendMessageToAllDMs(GetName(oCaster) + " failed a caster level check on Analyze Portal and will learn no more about this portal.");
					  DelayCommand(fResultsDelay + 6.0, SendMessageToPC(oCaster, "You have failed a caster level check and will learn no more about this portal."));
					  break;
					 }
			}

		nPortalNumber++;
		}

		oPortal = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oCaster), FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR);
    }
}

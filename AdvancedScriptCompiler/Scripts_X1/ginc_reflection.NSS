// ginc_reflection
/*
	Description:
	functions for supporting beams reflecting off of objects.
	also has rotation related functions.
	
*/
// ChazM 4/19/07
// EPF 5/10/07 -- adding functionality for doors and obstructions that block the ray
// EPF 5/11/07 -- adding a beam type state variable that can be changed at any given reflector point

#include "ginc_math"
#include "NW_I0_GENERIC"

//=================================================================
// Constants
//=================================================================

// a module-level variable that keeps the present beam type -- this is referenced every time a beam propagates
const string VAR_MOD_fBEAM_TYPE = "BEAM_TYPE_MODULE";


// variables on the "mirror" object
// values specify the tag of the next object in the link.
// actual choice is based on direction mirror is facing and direction of previous object.
const string VAR_NORTH 		= "ToNorth";
const string VAR_SOUTH 		= "ToSouth";
const string VAR_EAST 		= "ToEast";
const string VAR_WEST 		= "ToWest";
const string VAR_bONE_SIDED = "ONE_SIDED"; 	// is this object reflective on just one side?


// these are appended with a number, and store a set of objects that obstruct a beam's path, in the order
// of closest to farthest obstruction. For example, NorthBlock1 contains the tag of the nearest obstruction to 
// a northbound ray.
const string VAR_NORTH_BLOCK_PREFIX = "NorthBlock";
const string VAR_SOUTH_BLOCK_PREFIX = "SouthBlock";
const string VAR_EAST_BLOCK_PREFIX = "EastBlock";
const string VAR_WEST_BLOCK_PREFIX = "WestBlock";

// Variables on the Beam Starter
const string VAR_fBEAM_DURATION 			= "BEAM_DURATION"; 				// float 
const string VAR_fBEAM_PROPAGATION_DELAY 	= "BEAM_PROPAGATION_DELAY";		// float 
const string VAR_fBEAM_TYPE					= "BEAM_TYPE";					// int 	
const string VAR_fFACING_OFFSET 			= "FACING_OFFSET"; 	// offset from defined front to desired front


// variables for rotation
const string VAR_fROTATION_DEGREES 		= "ROTATION_DEGREES"; // float
const string VAR_fINTERPOLATION_TIME 	= "INTERPOLATION_TIME"; // float
const string VAR_iINTERPOLATION_POINTS 	= "INTERPOLATION_POINTS"; // int
const string VAR_sROTATION_SOUND 		= "ROTATION_SOUND"; // string

const int EVENT_BEAM_STRIKE 			= 102;

// defaults
const float DEF_BEAM_DURATION 			= 1.7f;
const float DEF_BEAM_PROPAGATION_DELAY 	= 0.15f;
const int 	DEF_BEAM_TYPE				= VFX_BEAM_ICE;

const float DEF_ROTATION_DEGREES 		=  90.0f;
const float DEF_INTERPOLATION_TIME 		=  1.0f;
const int 	DEF_INTERPOLATION_POINTS 	=  4;
const string DEF_ROTATION_SOUND 		=  "as_cv_woodframe1";

// additional facings
const float DIRECTION_NE 		= 45.0f;
const float DIRECTION_NW 		= 135.0f;
const float DIRECTION_SW		= 225.0f;
const float DIRECTION_SE 		= 315.0f;

// internally used vars
const string VAR_FROM_OBJECT 			= "N2_FROM_OBJECT"; 	// internal
const string VAR_BEAM_STARTER_OBJECT	= "N2_BEAM_STARTER"; 	// internal
const string VAR_IS_ROTATING			= "N2_IS_ROTATING"; // used internally to lock out while rotating.
const string VAR_ROTATE_INIT			= "N2_ROTATE_INIT";

const string RR_I_POINT		= "plc_ipoint"; //"plc_nt_rocks09"; //"plc_ipoint"; // plc_mc_mirror

//=================================================================
// Prototypes
//=================================================================
void SetLocalFloatDefualt(object oTarget, string sVariable, float fDefualtValue);
void SetLocalIntDefualt(object oTarget, string sVariable, int iDefualtValue);
void SetLocalStringDefualt(object oTarget, string sVariable, string sDefualtValue);

// Rotation related
void InterpolatedRotation(float fRotationDegrees, float fInterpolationTime, int iNumInterpolationPoints, object oTarget=OBJECT_SELF);
void RotatePlaceable();
float GetNearestDiagonalFacing(object oTarget=OBJECT_SELF);

// Reflection related
float GetToFacing(float fFromFacing, float fMirrorFacing, int bOneSidedMirror);
string GetVarNameForDirection(float fFacing);
object GetNextBeamTarget();
void DoBeamToTarget(object oTarget, object oSelf=OBJECT_SELF);
void ReflectBeam();
void BeamStarterInitialization(object oBeamStarter, 
	float fBeamDuration=DEF_BEAM_DURATION, float fBeamPropagationDelay =DEF_BEAM_PROPAGATION_DELAY, int iBeamType=DEF_BEAM_TYPE);
object GetFirstBeamTarget(float fFacingOffset=0.0f);
void ActionStartBeam();
void StartBeam(object oBeamStarter=OBJECT_SELF);


//=================================================================
// Functions
//=================================================================
void SetLocalFloatDefualt(object oTarget, string sVariable, float fDefualtValue)
{
	if (fDefualtValue == 0.0f)
		return;
		
	if (GetLocalFloat(oTarget, sVariable) == 0.0f)
		SetLocalFloat(oTarget, sVariable, fDefualtValue);
}

void SetLocalIntDefualt(object oTarget, string sVariable, int iDefualtValue)
{
	if (iDefualtValue == 0)
		return;
		
	if (GetLocalInt(oTarget, sVariable) == 0)
		SetLocalInt(oTarget, sVariable, iDefualtValue);
}

void SetLocalStringDefualt(object oTarget, string sVariable, string sDefualtValue)
{
	if (sDefualtValue == "")
		return;
		
	if (GetLocalString(oTarget, sVariable) == "")
		SetLocalString(oTarget, sVariable, sDefualtValue);
}


void InterpolatedRotation(float fRotationDegrees, float fInterpolationTime, int iNumInterpolationPoints, object oTarget=OBJECT_SELF)
{
	// must always be at least 1 point
	if (iNumInterpolationPoints < 1)
		iNumInterpolationPoints = 1;
				
	float fCurrentFacing = GetFacing(oTarget);
	float fNewFinalFacing = fRotationDegrees + fCurrentFacing;
	PrettyDebug("Changing Facing to " + FloatToString(fNewFinalFacing));
	
	float fInterpolationDelay = fInterpolationTime/IntToFloat(iNumInterpolationPoints);
	float fInterpolationAngle = fRotationDegrees/IntToFloat(iNumInterpolationPoints);
	int i;
	for (i=1; i<=iNumInterpolationPoints; i++)
	{
		float fInterpolationPoint = IntToFloat(i);
		float fDelay = fInterpolationDelay * fInterpolationPoint;
		float fAngleDelta = fInterpolationAngle * fInterpolationPoint;
	 	float fNewFacing = GetNormalizedDirection(fCurrentFacing + fAngleDelta);
		DelayCommand(fDelay, SetFacing(fNewFacing));
	}
}

void RotatePlaceable()
{
	object oTarget = OBJECT_SELF;
	// don't allow more rotation until we are done.		
	if (GetLocalInt(oTarget, VAR_IS_ROTATING))
		return;

	// indicate we are rotating		
	SetLocalInt(oTarget, VAR_IS_ROTATING, TRUE);
	
	// initialize defualt values
	if (!GetLocalInt(oTarget, VAR_ROTATE_INIT))
	{
		SetLocalInt(oTarget, VAR_ROTATE_INIT, TRUE);
		SetLocalFloatDefualt(oTarget, VAR_fROTATION_DEGREES, DEF_ROTATION_DEGREES);
		SetLocalFloatDefualt(oTarget, VAR_fINTERPOLATION_TIME, DEF_INTERPOLATION_TIME);
		SetLocalIntDefualt(oTarget, VAR_iINTERPOLATION_POINTS, DEF_INTERPOLATION_POINTS);
		SetLocalStringDefualt(oTarget, VAR_sROTATION_SOUND, DEF_ROTATION_SOUND);
	}		
			
	float fRotationDegrees = GetLocalFloat(oTarget, VAR_fROTATION_DEGREES);
	float fInterpolationTime = GetLocalFloat(oTarget, VAR_fINTERPOLATION_TIME);
	int iInterpolationPoints = GetLocalInt(oTarget, VAR_iINTERPOLATION_POINTS);
	string sRotationSound = GetLocalString(oTarget, VAR_sROTATION_SOUND);
	
	// indicate we are done rotating		
	DelayCommand(fInterpolationTime, SetLocalInt(oTarget, VAR_IS_ROTATING, FALSE));
	PlaySound(sRotationSound);
	InterpolatedRotation(fRotationDegrees, fInterpolationTime, iInterpolationPoints);
}


// return  direction closest to a diagonal facing.
// used to initialize mirrors at diagonal angles.
float GetNearestDiagonalFacing(object oTarget=OBJECT_SELF)
{
	float fFacing = GetFacing(oTarget);
	float fDirection;
	
	if(IsDirectionWithinTolerance(fFacing, DIRECTION_NE, 45.0))
		fDirection = DIRECTION_NE;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_SE, 45.0))
		fDirection = DIRECTION_SE;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_NW, 45.0))
		fDirection = DIRECTION_NW;
	else // if(IsDirectionWithinTolerance(fFacing, DIRECTION_SW, 45.0))
		fDirection = DIRECTION_SW;

	return (fDirection);
}


// fFromFacing should be N, S, E, W.  If the ray came from the south (thus going north), this value would be north.
// fMirrorFacing should be NE, SE, NW, SW
// returns the facing the beam will go in.
// example GetToFacing(S, SE) = E
float GetToFacing(float fFromFacing, float fMirrorFacing, int bOneSidedMirror)
{
	float fFacingDelta = fFromFacing - fMirrorFacing; // this can be negative
	// if fAngleDelta to great, it won't bounce anywhere
	//is Mirror facing at less than right angle to incoming beam?
	int bWithin90 = IsDirectionWithinTolerance(fMirrorFacing, fFromFacing, 90.0);
	//if (fabs(fFacingDelta) >= 90.0f)
	if (!bWithin90)
	{ 
		if (!bOneSidedMirror)
		{
			fFacingDelta += 180.0f;	// change facing to opposite direction
			// no need to check again if within 90 - it must be.
		}
		else
		{
			//PrettyDebug("fFacingDelta > 90 - no bounce");
			return (-1.0f);
		}			
	}
	float fAngleOfBounce = fFromFacing - (fFacingDelta * 2);
	return (GetNormalizedDirection(fAngleOfBounce));
}

// fToFacing - a direction N,S,E,W
// return variable name (containing tag of next object) 
string GetVarNameForDirection(float fFacing)
{	
	string sVar;

	if(IsDirectionWithinTolerance(fFacing, DIRECTION_NORTH, 45.0))
		sVar = VAR_NORTH;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_SOUTH, 45.0))
		sVar = VAR_SOUTH;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_EAST, 45.0))
		sVar = VAR_EAST;
	else // if(IsDirectionWithinTolerance(fFacing, DIRECTION_WEST, 45.0))
		sVar = VAR_WEST;

	//PrettyDebug("Looking at variable: " + sVar);	
				
	return (sVar);
}		

// fToFacing - a direction N,S,E,W
// return a prefix name for a variable that stores the tags of obstructing objects in that direction
string GetPrefixForBlockVar(float fFacing)
{
	string sVar;

	if(IsDirectionWithinTolerance(fFacing, DIRECTION_NORTH, 45.0))
		sVar = VAR_NORTH_BLOCK_PREFIX;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_SOUTH, 45.0))
		sVar = VAR_SOUTH_BLOCK_PREFIX;
	else if(IsDirectionWithinTolerance(fFacing, DIRECTION_EAST, 45.0))
		sVar = VAR_EAST_BLOCK_PREFIX;
	else // if(IsDirectionWithinTolerance(fFacing, DIRECTION_WEST, 45.0))
		sVar = VAR_WEST_BLOCK_PREFIX;

	//PrettyDebug("Looking at variable: " + sVar);	
				
	return (sVar);
}

// return any doors or placeables obstructing a beam's path to its original target
object GetObstructingObject(float fFacing)
{
	string sPrefix = GetPrefixForBlockVar(fFacing);
	int i = 1;
	object oSelf = OBJECT_SELF;
	
	string sTarget = GetLocalString(oSelf, sPrefix + IntToString(i));
	object oTarget = OBJECT_INVALID;
	while(sTarget != "")
	{
		oTarget = GetNearestObjectByTag(sTarget);
		if(GetIsObjectValid(oTarget))
		{
			// closed doors or placeables are obstructing objects
			if(GetObjectType(oTarget) == OBJECT_TYPE_DOOR && !GetIsOpen(oTarget) ||GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
			{
				return oTarget;
			}			
		}
		i++;
		sTarget = GetLocalString(oSelf, sPrefix + IntToString(i));
	}
	return OBJECT_INVALID;
}



// look at the direction beam will go, get the corresponding tag, and return that object
object GetNextBeamTarget()
{
	object oSelf=OBJECT_SELF;
	object oNextTarget = OBJECT_INVALID;
	object oFromObject = GetLocalObject(oSelf, VAR_FROM_OBJECT);
	if (!GetIsObjectValid(oFromObject))
	{
		PrettyError("No defined oFromObject");
		return (OBJECT_INVALID);
		// we don't know the from object, so which way to fire???
	}
	// get the angle from us
	float fFromFacing = GetAngleBetweenObjects(oSelf, oFromObject);
	float fMirrorFacing = GetFacing(oSelf); // may need some adjustment
	int bOneSidedMirror = GetLocalInt(oSelf, VAR_bONE_SIDED);
	float fFacingOffset = GetLocalFloat(oSelf, VAR_fFACING_OFFSET);
	
	fMirrorFacing += fFacingOffset;
	fMirrorFacing = IntToFloat(FloatToInt(fabs(fMirrorFacing)) % 360);
	
	float fToFacing = GetToFacing(fFromFacing, fMirrorFacing, bOneSidedMirror);
	if (fToFacing<0.0f)
	{
		//PrettyDebug("Invalid Facing returned");
	}
	else
	{
		string sVarName = GetVarNameForDirection(fToFacing);
		object oObstruction = GetObstructingObject(fToFacing);
		if(GetIsObjectValid(oObstruction))
		{
			oNextTarget = oObstruction;
		}
		else
		{
			string sNextTargetTag = GetLocalString(OBJECT_SELF, sVarName);
			//PrettyDebug("sNextTargetTag = " + sNextTargetTag);
			oNextTarget = GetObjectByTag(sNextTargetTag);
		}
	}
	return (oNextTarget);
}

// move me to x0_i0_position
location ModifyLocationPosition(location lMyLocation, float DeltaX, float DeltaY, float DeltaZ)
{
    object   oArea       = GetAreaFromLocation (lMyLocation);
    vector   vPosition   = GetPositionFromLocation (lMyLocation);
    float    fFacing     = GetFacingFromLocation (lMyLocation);

	vPosition.x += DeltaX;
	vPosition.y += DeltaY;
	vPosition.z += DeltaZ;
	
    location lNewLocation = Location (oArea, vPosition, fFacing);
	return (lNewLocation);
}

void DoBeamToTarget(object oTarget, object oSelf=OBJECT_SELF)
{
	
	// if next target valid then create a beam to it and fire event on it.
	if(GetIsObjectValid(oTarget))
	{
		object oBeamStarter = GetLocalObject(oSelf, VAR_BEAM_STARTER_OBJECT); // get reference to beam Starter.
		SetLocalObject(oTarget, VAR_BEAM_STARTER_OBJECT, oBeamStarter); //propagate reference to beam Starter on next object
		
		int iBeamType = GetLocalInt(oSelf, VAR_fBEAM_TYPE);	//a local override to change the beam state
		
		if(iBeamType > 0)
		{
			SetLocalInt(GetModule(), VAR_MOD_fBEAM_TYPE, iBeamType);
		}
		
		float fBeamDuration 		= GetLocalFloat(oBeamStarter, VAR_fBEAM_DURATION);
		float fBeamPropagationDelay = GetLocalFloat(oBeamStarter, VAR_fBEAM_PROPAGATION_DELAY);
		iBeamType 					= GetLocalInt(GetModule(), VAR_MOD_fBEAM_TYPE);
	
		SetLocalObject(oTarget, VAR_FROM_OBJECT, oSelf); // store a reference back to us on the target.
		effect eRay = EffectBeam(iBeamType, oSelf, BODY_NODE_CHEST);
		// if target already has beam, then use an alternate object for actual effect.
		if (GetHasEffect(EFFECT_TYPE_BEAM, oTarget))
		{
			PrettyDebug (GetName(oTarget) + " currently emitting beam.  Createing alt object.");
 			location lTemp = GetLocation(oTarget);
			lTemp = ModifyLocationPosition(lTemp, 0.0f, 0.0f, 1.0f);
			object oTempObj = CreateObject(OBJECT_TYPE_PLACEABLE, RR_I_POINT, lTemp);
	 		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTempObj, fBeamDuration);
			DestroyObject(oTempObj, fBeamDuration+1.0f);
		}
		else
		{
	 		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, fBeamDuration);
		}			
		DelayCommand(fBeamPropagationDelay, SignalEvent(oTarget, EventUserDefined(EVENT_BEAM_STRIKE)));
	}
}

// Standard Beam reflection when hit
void ReflectBeam()
{
	//PrettyDebug(GetName(oSelf) + " EVENT_REFLECT_BEAM");
	object oNextTarget = GetNextBeamTarget();
	//PrettyDebug(GetName(oSelf) + " EVENT_REFLECT_BEAM: oNextTarget="+GetName(oNextTarget));
	DoBeamToTarget(oNextTarget);
}

// Change Beam-Starter's Beam properties.
void BeamStarterInitialization(object oBeamStarter, 
	float fBeamDuration=DEF_BEAM_DURATION, float fBeamPropagationDelay =DEF_BEAM_PROPAGATION_DELAY, int iBeamType=DEF_BEAM_TYPE)
{
	SetLocalFloat(oBeamStarter, VAR_fBEAM_DURATION, fBeamDuration);
	SetLocalFloat(oBeamStarter, VAR_fBEAM_PROPAGATION_DELAY, fBeamPropagationDelay);
	SetLocalInt(oBeamStarter, VAR_fBEAM_TYPE, iBeamType);
	SetLocalInt(GetModule(), VAR_MOD_fBEAM_TYPE, iBeamType);
}


// look at the direction we face, get the corresponding tag, and return that object
object GetFirstBeamTarget(float fFacingOffset=0.0f)
{
	object oBeamStarter=OBJECT_SELF;
	object oNextTarget = OBJECT_INVALID;
	
	float fFacing = GetNormalizedDirection(GetFacing(oBeamStarter) + fFacingOffset);
	PrettyDebug("fFacing w/offset = " + FloatToString(fFacing));
	string sVarName = GetVarNameForDirection(fFacing);
	string sNextTargetTag = GetLocalString(OBJECT_SELF, sVarName);
	oNextTarget = GetObjectByTag(sNextTargetTag);
	
	if (!GetIsObjectValid(oNextTarget))
	{
		PrettyDebug("GetFirstBeamTarget() - can't find first target object: " + sVarName + " = " + sNextTargetTag);
	}
	
	return (oNextTarget);
}


// run this to shoot the beam.
// oBeamStarter - the object from which the beam will emit.
void ActionStartBeam()
{
	object oBeamStarter=OBJECT_SELF;
	float fFacingOffset = GetLocalFloat(oBeamStarter, VAR_fFACING_OFFSET);
	
	object oNextTarget = GetFirstBeamTarget(fFacingOffset);
	if (!GetIsObjectValid(oNextTarget))
	{	// can't find next so exit.
		return;
	}
	SetLocalObject(oBeamStarter, VAR_BEAM_STARTER_OBJECT, oBeamStarter); // put reference to self which will be propagated to beams.
	
	// set defaults if no value currently set.
	SetLocalFloatDefualt(oBeamStarter, VAR_fBEAM_DURATION, DEF_BEAM_DURATION);
	SetLocalFloatDefualt(oBeamStarter, VAR_fBEAM_PROPAGATION_DELAY, DEF_BEAM_PROPAGATION_DELAY);
	SetLocalIntDefualt(oBeamStarter, VAR_fBEAM_TYPE, DEF_BEAM_TYPE);
	
	DoBeamToTarget(oNextTarget, oBeamStarter);
}

void StartBeam(object oBeamStarter=OBJECT_SELF)
{
	AssignCommand(oBeamStarter, ActionStartBeam());
}
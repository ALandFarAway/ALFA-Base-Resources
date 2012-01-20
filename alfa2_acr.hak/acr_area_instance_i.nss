////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_area_instance_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-08#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: AREA_INSTANCE
//  Dependencies: NWNX, MYSQL, CLRSCRIPT(acr_servermisc)
//
//  Description
//  This file contains logic for supporting instanced area management.
//
//  Revision History
//  2012/01/19  Basilica    - Created.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_server_misc_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This variable names the script to run when an instance is setup.
//
// The script runs with OBJECT_SELF being the new area instance.  It has an
// entry point function like this:
//
// void main();
//
// Common tasks may be setting a unique tag on the area if desired or other
// instance setup work.
//
// The area designer sets this local string variable on the area object.
const string ACR_AREA_INSTANCE_ON_CREATE_SCRIPT              = "ACR_AREA_INSTANCE_ON_CREATE_SCRIPT";

// This variable names the script to run when an area is released.
// The script can return FALSE to indicate that it does not want the area to
// be deleted.  This is useful if automatic area cleanup is enabled for the
// instance.  In this case, the cleanup timer starts up again if the request
// to delete the area is denied.
//
// The script runs with OBJECT_SELF being the existing area instance.  It has
// an entry point function like this:
//
// int StartingConditional(); // return TRUE to allow area to be deleted
//
// Common tasks may be to clean up the contents of the area if the area is one
// that has caching enabled, so that it will be 'fresh' if it is reused.
//
// The area designer sets this local string variable on the area object.
const string ACR_AREA_INSTANCE_ON_DELETE_SCRIPT              = "ACR_AREA_INSTANCE_ON_DELETE_SCRIPT";

// This variable indicates whether a script can have cached instances.  If set
// to TRUE, cached instances are allowed.  That is, if an area is deleted, it
// is not actually deleted but just returned to a pool of available instances.
//
// A cacheable area instance needs to clean up the instance when it is deleted,
// or when the creation script is called when the instance is re-activated for
// use.
//
// If caching is not allowed then an area is really deleted every time a delete
// request is made.  This simplifies cleanup but reduces performance.
//
// The area designer sets this local int variable on the area object.
const string ACR_AREA_INSTANCE_ENABLE_CACHE                  = "ACR_AREA_INSTANCE_ENABLE_CACHE";

// This variable indicates the delay for auto deleting an area when the last PC
// in the area leaves.  If not set or set to zero, then the instance does not
// automatically delete.  The delay is expressed as a count of seconds, with
// fractional values permitted.
//
// If the delay is set and a player has re-entered the area, then deletion is
// halted.  If a player leave the instance again then the timer starts up once
// more.
//
// If no player enters into the area within the cleanup delay of the area
// instance being created, then the area is removed.
//
// The area designer sets this local float variable on the area object.
const string ACR_AREA_INSTANCE_CLEANUP_DELAY                 = "ACR_AREA_INSTANCE_CLEANUP_DELAY";




// Remainder of variables are managed internally and not at design time.

// This variable names the parent area for an instance.
const string ACR_AREA_INSTANCE_PARENT_AREA                   = "ACR_AREA_INSTANCE_PARENT_AREA";

// This variable indicates if the area is on the free list.
const string ACR_AREA_INSTANCE_IS_ON_FREE_LIST               = "ACR_AREA_INSTANCE_IS_ON_FREE_LIST";

// This variable indicates if the area already has a cleanup task scheduled.
const string ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING          = "ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING";

// This variable contains the first dynamic object id in the area.
const string ACR_AREA_INSTANCE_FIRST_DYNAMIC_OBJECT          = "ACR_AREA_INSTANCE_FIRST_DYNAMIC_OBJECT";

// This variable is set to TRUE if an area has player activity since the last
// cleanup task ran.
const string ACR_AREA_INSTANCE_HAD_ACTIVITY                  = "ACR_AREA_INSTANCE_HAD_ACTIVITY";

const string ACR_AREA_INSTANCE_ORIGINAL_ONLEAVE_SCRIPT       = "ACR_AREA_INSTANCE_ORIGINAL_ONLEAVE_SCRIPT";


// The number of objects to remove each deletion cycle.  This value is used to
// allow cleanup of area objects to be spread out over time so as to not pause
// the server for an excessive time.
const int ACR_AREA_INSTANCE_OBJECTS_PER_DELETION_CYCLE       = 2;

// The OnLeave script that is hooked in for area instance is named here.  This
// script allows automatic instance cleanup to be enabled.
const string ACR_AREA_INSTANCE_ONLEAVE_ACR_SCRIPT            = "acr_area_instance_onleave";

// Define to 1 to enable debugging.
#define ACR_AREA_INSTANCE_DEBUG 1

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Create an instanced area.  If an available instance in the free pool can be
//  found, it will be reused.
//!  - TemplateArea: Supplies the area that serves as the template for the new
//                   instanced area.
//!  - CleanupDelay: Supplies the area cleanup delay.  If < 0.1f, then the
//                   value from the design time configuration setting on the
//                   template area is used instead.  If the design time
//                   setting did not specify a value then cleanup is not
//                   enabled for this instance.
//!  - Returns: The area instance, else OBJECT_INVALID on failure.
object ACR_CreateAreaInstance(object TemplateArea, float CleanupDelay = 0.0f);

//! Release an instanced area.  It will be put back onto the free list of the
//  area supports free list pooling, otherwise the area is deleted.
//!  - InstancedArea: Supplies the area instance to release.
void ACR_ReleaseAreaInstance(object InstancedArea);

//! Check whether an area is an instanced area or not.  It can be used for the
//  client enter script of a template area, for example, to create an instance
//  of the area and move the entering player to the instance.
//!  - Area: Supplies the area object to query.
//!  - Returns: TRUE if the area is an instance, else FALSE if it is a static
//              created area (which might be the template for an instance, or
//              might be any other static area).
int ACR_IsInstancedArea(object Area);

//! Return the template instance for an instanced area.  This is the area
//  object that had been created from.  Returns OBJECT_INVALID if the area was
//  not really an instanced area.
//!  - InstancedArea: Supplies the instanced area object to query.
//!  - Returns: The template (parent) area, else OBJECT_INVALID if the area
//     was not a valid instanced area.
object ACR_GetInstancedAreaTemplate(object Area);

//! Check whether an area has any player controlled objects in it.  The area
//  can be a normal or instanced area.
//!  - Area: Supplies the area to inquire about.
//!  - ExcludeObject: Optionally supplies an object to exclude from checking.
//!  - Returns: TRUE if the area has no player controlled objects.
int ACR_IsAreaEmptyOfPlayers(object Area, object ExcludeObject = OBJECT_INVALID);

//! Get the cleanup delay for a player.  < 0.1f returned if cleanup is not
//  enabled.
//!  - Area: Supplies the area to inquire about.
//!  - Returns: The delay, else a value < 0.1f if the delay was not set.
float ACR_GetAreaCleanupDelay(object InstancedArea);

//! Called when a player leaves the module or the area.
//!  - PC: Supplies the departing player.
//!  - FromAreaInstance: Supplies TRUE if the player left an instance, else
//                       FALSE if the player left the module.
void ACR_AreaInstance_OnClientLeave(object PC, int FromAreaInstance);

//! Internal function to run deletion of an area instance.
//!  - InstancedArea: Supplies the area to start deleting.
//!  - CurrentObject: Supplies the current object to delete, for throttling.
void ACR__DeleteAreaInstance(object InstancedArea, object CurrentObject = OBJECT_INVALID);

//! Internal function to check if an area is on the free list and this should
//  not perform cleanup tasks.
//!  - InstancedArea: Supplies the area instance to inquire about.
//!  - Returns: TRUE if the area instance is being deleted or is on the free
//              list, meaning cleanup tasks should not be run.
int ACR__IsAreaInstanceDeleting(object InstancedArea);

//! Internal function to start the cleanup task for an instanced area, if it is
//  not running.  No action is taken if the instanced area was already running.
//!  - InstancedArea: Supplies the area instance to start the task for.
//!  Delay: Supplies the area's cleanup delay time.
void ACR__StartAreaCleanupTask(object InstancedArea, float Delay);

//! Internal function to act as the cleanup task for an area.  It checks if the
//  area has been inactive for the required delay time and, if so, starts the
//  deletion process.
//!  InstancedArea: Supplies the current area instance.
//!  Delay: Supplies the area's cleanup delay time.
void ACR__AreaCleanupTask(object InstancedArea, float Delay);

//! Internal function to call the original OnLeave handler for an instanced
//  area object.
//!  InstancedArea: Supplies the current area instance.
void ACR__CallOriginalOnLeaveHandler(object InstancedArea);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

object ACR_CreateAreaInstance(object TemplateArea, float CleanupDelay)
{
	if (ACR_IsInstancedArea(TemplateArea))
		TemplateArea = ACR_GetInstancedAreaTemplate(TemplateArea);

	// First, get an actual area instance.
	object InstancedArea = ACR_InternalCreateAreaInstance(TemplateArea);
	string Script;

	if (InstancedArea == OBJECT_INVALID)
		return OBJECT_INVALID;

	// If we are setting up a non-cached area, record the start of the dynamic
	// object id range for the area.  This lets us completely delete all of the
	// static objects copied.
	//
	// For cacheable areas, we may run creation multiple times.  But we do not
	// need to bother with static object deletion at all, so don't bother to
	// create the dummy object in that case.
	if (GetLocalInt(TemplateArea, ACR_AREA_INSTANCE_ENABLE_CACHE) == FALSE)
	{
		object FirstDynamicObject = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetStartingLocation(), FALSE);
		DestroyObject(FirstDynamicObject);

		SetLocalObject(InstancedArea, ACR_AREA_INSTANCE_FIRST_DYNAMIC_OBJECT, FirstDynamicObject);
	}

	// Hook the OnLeave event so that we can fire instance cleanup automatically
	// if the designer requested that.  Note that the area might be a reused
	// copy, so only do this if we have not already hooked the script.
	Script = GetEventHandler(InstancedArea, SCRIPT_AREA_ON_EXIT);

	if (Script != ACR_AREA_INSTANCE_ONLEAVE_ACR_SCRIPT)
	{
		SetLocalString(InstancedArea, ACR_AREA_INSTANCE_ORIGINAL_ONLEAVE_SCRIPT, Script);
		SetEventHandler(InstancedArea, SCRIPT_AREA_ON_EXIT, ACR_AREA_INSTANCE_ONLEAVE_ACR_SCRIPT);
	}

	DeleteLocalInt(InstancedArea, ACR_AREA_INSTANCE_IS_ON_FREE_LIST);
	SetLocalObject(InstancedArea, ACR_AREA_INSTANCE_PARENT_AREA, TemplateArea);
	WriteTimestampedLogEntry("ACR_CreateAreaInstance(): Created instance of " + GetName(TemplateArea) + ": 0x" + ObjectToString(InstancedArea));

	// Set the activity flag in case we still had a cleanup task running.  That
	// could happen if a cacheable area gets put onto the deletion list and then
	// removed and re-instantiated quickly.  In that case we do not want the
	// area to be deleted prematurely.
	SetLocalInt(InstancedArea, ACR_AREA_INSTANCE_HAD_ACTIVITY, TRUE);

	// Call creation script.
	Script = GetLocalString(TemplateArea, ACR_AREA_INSTANCE_ON_CREATE_SCRIPT);

	if (Script != "")
		ExecuteScriptEnhanced(Script, InstancedArea);

	// Start cleanup task if cleanup is enabled.  This will remove the instance
	// if no player ever enters it.
	if (CleanupDelay < 0.1f)
		CleanupDelay = GetLocalFloat(TemplateArea, ACR_AREA_INSTANCE_CLEANUP_DELAY);
	else
		SetLocalFloat(TemplateArea, ACR_AREA_INSTANCE_CLEANUP_DELAY, CleanupDelay);

	if (CleanupDelay > 0.1f)
		ACR__StartAreaCleanupTask(InstancedArea, CleanupDelay);

	return InstancedArea;
}

void ACR_ReleaseAreaInstance(object InstancedArea)
{
	if (!ACR_IsInstancedArea(InstancedArea))
	{
		WriteTimestampedLogEntry("ACR_ReleaseAreaInstance(): Cannot release non-instanced area " + GetName(InstancedArea) + ": 0x" + ObjectToString(InstancedArea));
		return;
	}

	// Call deletion script.
	object TemplateArea = ACR_GetInstancedAreaTemplate(InstancedArea);
	string Script = GetLocalString(TemplateArea, ACR_AREA_INSTANCE_ON_DELETE_SCRIPT);

	if (Script != "")
	{
		if (!ExecuteScriptEnhanced(Script, InstancedArea))
		{
			float Delay = ACR_GetAreaCleanupDelay(InstancedArea);

			WriteTimestampedLogEntry("ACR_ReleaseAreaInstance(): Instance on delete script denied deletion of " + GetName(InstancedArea) + ": 0x" + ObjectToString(InstancedArea));

			if (Delay > 0.1f)
				ACR__StartAreaCleanupTask(InstancedArea, Delay);

			return; // Deletion script denied cleanup.
		}
	}

	SetLocalInt(InstancedArea, ACR_AREA_INSTANCE_IS_ON_FREE_LIST, TRUE);

	// If caching is not enabled, start the area hard deletion process.
	if (GetLocalInt(TemplateArea, ACR_AREA_INSTANCE_ENABLE_CACHE) == FALSE)
	{
		WriteTimestampedLogEntry("ACR_ReleaseAreaInstance(): Hard deleting area instance " + GetName(InstancedArea) + ": 0x" + ObjectToString(InstancedArea));
		AssignCommand(InstancedArea, ACR__DeleteAreaInstance(InstancedArea));
		return;
	}

	// Otherwise, put the area on the free list.
	WriteTimestampedLogEntry("ACR_ReleaseAreaInstance(): Adding area instance to free list - " + GetName(InstancedArea) + ": 0x" + ObjectToString(InstancedArea));
	ACR_InternalReleaseAreaInstance(InstancedArea);
}

int ACR_IsInstancedArea(object Area)
{
	return GetLocalObject(Area, ACR_AREA_INSTANCE_PARENT_AREA) != OBJECT_INVALID;
}

object ACR_GetInstancedAreaTemplate(object Area)
{
	return GetLocalObject(Area, ACR_AREA_INSTANCE_PARENT_AREA);
}

int ACR_IsAreaEmptyOfPlayers(object Area, object ExcludeObject = OBJECT_INVALID)
{
	object PC;

	for (PC = GetFirstPC(); PC != OBJECT_INVALID; PC = GetNextPC())
	{
		object ControlObject;

		if (PC == ExcludeObject)
			continue;

		if (GetArea(PC) == Area)
			return FALSE;

		ControlObject = GetControlledCharacter(PC);

		if (ControlObject != OBJECT_INVALID && GetArea(ControlObject) == Area)
			return FALSE;
	}

	return TRUE;
}

float ACR_GetAreaCleanupDelay(object InstancedArea)
{
	float Delay;

	// If a script override was set, use that.
	Delay = GetLocalFloat(InstancedArea, ACR_AREA_INSTANCE_CLEANUP_DELAY);

	// Otherwise get the value from the design time configuration setting.
	if (Delay < 0.1f)
		Delay = GetLocalFloat(ACR_GetInstancedAreaTemplate(InstancedArea), ACR_AREA_INSTANCE_CLEANUP_DELAY);

	return Delay;
}

void ACR_AreaInstance_OnClientLeave(object PC, int FromAreaInstance)
{
	object Area = FromAreaInstance ? OBJECT_SELF : GetArea(PC);
	float Delay;

	// Interested only in instanced areas.
	if (!ACR_IsInstancedArea(Area))
		return;

	// Mark activity so that we can reset the cleanup timer.  This only needs be
	// done here, on client leave, because the cleanup timer aborts if it sees
	// that there are PCs present.
	SetLocalInt(Area, ACR_AREA_INSTANCE_HAD_ACTIVITY, TRUE);

	Delay = ACR_GetAreaCleanupDelay(Area);

	// Interested only in instances with automatic cleanup configured.
	if (Delay < 0.1f)
		return;

	ACR__StartAreaCleanupTask(Area, Delay);
}


void ACR__DeleteAreaInstance(object InstancedArea, object CurrentObject = OBJECT_INVALID)
{
	object FirstDynamicObject = GetLocalObject(InstancedArea, ACR_AREA_INSTANCE_FIRST_DYNAMIC_OBJECT);
	int FirstDynamicObjectInt = ObjectToInt(FirstDynamicObject);
	int ObjectsDeleted = 0;
	int RemovingStaticObjects;

	// There are several tasks that must be performed for instanced area deletion.
	// First, all of the static objects have to be deleted.  Not all of these
	// are enumerated in GetFirstObjectInArea/GetNextObjectInArea, because some
	// objects are of a type that is not exposed to NWScript directly, for
	// example, an environmental object.
	//
	// Next, the dynamic objects in the area (with a standard
	// GetFirstObjectInArea, GetNextObjectInArea loop) can be removed.
	//
	// Finally, the area object itself can be removed.

	WriteTimestampedLogEntry("ACR__DeleteAreaInstance(): Deletion for " + GetName(InstancedArea) + ": " + ObjectToString(InstancedArea) + " is at objectid=" + ObjectToString(CurrentObject) + ", first dynamic objectid=" + ObjectToString(FirstDynamicObject));

	if (CurrentObject == OBJECT_INVALID)
	{
		// Starting deletion for the first time.  Begin sweeping static objects.

#if ACR_AREA_INSTANCE_DEBUG
		WriteTimestampedLogEntry("Starting deletion of static objects...");
#endif

		CurrentObject = IntToObject(ObjectToInt(InstancedArea) + 1);
		RemovingStaticObjects = TRUE;
	}
	else if (ObjectToInt(CurrentObject) < FirstDynamicObjectInt)
	{
		// Resuming deletion of static objects.

#if ACR_AREA_INSTANCE_DEBUG
		WriteTimestampedLogEntry("Resuming deletion of static objects...");
#endif

		RemovingStaticObjects = TRUE;
	}
	else
	{
		// Resuming (or beginning) deletion of dynamic objects.

#if ACR_AREA_INSTANCE_DEBUG
		WriteTimestampedLogEntry("In deletion of dynamic objects...");
#endif

		RemovingStaticObjects = FALSE;
	}

	while (ObjectsDeleted < ACR_AREA_INSTANCE_OBJECTS_PER_DELETION_CYCLE && RemovingStaticObjects)
	{
		if (GetIsObjectValid(CurrentObject) == FALSE)
		{
			CurrentObject = IntToObject(ObjectToInt(CurrentObject) + 1);
			RemovingStaticObjects = ObjectToInt(CurrentObject) < FirstDynamicObjectInt;
			continue;
		}

		ObjectsDeleted += 1;

#if ACR_AREA_INSTANCE_DEBUG
		WriteTimestampedLogEntry("Deleting static object " + ObjectToString(CurrentObject));
#endif

		DestroyObject(CurrentObject);
		CurrentObject = IntToObject(ObjectToInt(CurrentObject) + 1);
		RemovingStaticObjects = ObjectToInt(CurrentObject) < FirstDynamicObjectInt;
	}

	CurrentObject = GetFirstObjectInArea(InstancedArea);

	while (ObjectsDeleted < ACR_AREA_INSTANCE_OBJECTS_PER_DELETION_CYCLE)
	{
		// If the object appears to be related to a PC, try later.
		if (GetOwnedCharacter(CurrentObject) != OBJECT_INVALID ||
		    GetControlledCharacter(CurrentObject) != OBJECT_INVALID)
		{
			WriteTimestampedLogEntry("ACR__DeleteAreaInstance(): Found player-related object " + GetName(CurrentObject) + " in area, delaying.");
			SendMessageToPC(GetOwnedCharacter(CurrentObject), "This area instance is being destroyed.  Please exit the area.");
			break;
		}

#if ACR_AREA_INSTANCE_DEBUG
		WriteTimestampedLogEntry("Deleting dynamic object " + ObjectToString(CurrentObject));
#endif

		DestroyObject(CurrentObject);
		CurrentObject = GetNextObjectInArea(InstancedArea);
		ObjectsDeleted += 1;

		if (CurrentObject == OBJECT_INVALID)
			break;
	}

	// If we reached the end of the object list, it's time to delete the area
	// itself.
	if (CurrentObject == OBJECT_INVALID)
	{
		WriteTimestampedLogEntry("ACR__DeleteAreaInstance(): Removing area object " + ObjectToString(InstancedArea));
		DestroyObject(InstancedArea);
		return;
	}

	// Otherwise, queue up a continuation cycle to moderate CPU usage spikes on the server.
	WriteTimestampedLogEntry("ACR__DeleteAreaInstance(): Continuing instanced area deletion next cycle.");
	DelayCommand(6.0f, ACR__DeleteAreaInstance(InstancedArea, CurrentObject));
}

int ACR__IsAreaInstanceDeleting(object InstancedArea)
{
	return GetLocalInt(InstancedArea, ACR_AREA_INSTANCE_IS_ON_FREE_LIST) != FALSE;
}

void ACR__StartAreaCleanupTask(object InstancedArea, float Delay)
{
	// Don't start another task if one is scheduled.
	if (GetLocalInt(InstancedArea, ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING) != FALSE)
		return;

	SetLocalInt(InstancedArea, ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING, TRUE);
	AssignCommand(InstancedArea, DelayCommand(Delay, ACR__AreaCleanupTask(InstancedArea, Delay)));
	WriteTimestampedLogEntry("ACR__StartAreaCleanupTask(): Started area cleanup task for " + GetName(InstancedArea) + ": " + ObjectToString(InstancedArea));
}

void ACR__AreaCleanupTask(object InstancedArea, float Delay)
{
	// If we are already running deletion for the area, stop the task.
	if (ACR__IsAreaInstanceDeleting(InstancedArea))
	{
		WriteTimestampedLogEntry("ACR__AreaCleanupTask(): Area " + GetName(InstancedArea) + ": " + ObjectToString(InstancedArea) + " has already been marked for deletion, aborting cleanup task.");
		DeleteLocalInt(InstancedArea, ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING);
		return;
	}

	// Stop the task if the area has players in it.  When the last player leaves
	// the task will be started up again.
	if (!ACR_IsAreaEmptyOfPlayers(InstancedArea))
	{
		WriteTimestampedLogEntry("ACR__AreaCleanupTask(): Area " + GetName(InstancedArea) + ": " + ObjectToString(InstancedArea) + " has players, aborting cleanup task.");
		DeleteLocalInt(InstancedArea, ACR_AREA_INSTANCE_CLEANUP_TASK_RUNNING);
		return;
	}

	// Check if there was activity since the last player left.  If not, then let
	// the instance be released.  Otherwise, clear the activity flag and let the
	// task run again.
	if (GetLocalInt(InstancedArea, ACR_AREA_INSTANCE_HAD_ACTIVITY) == FALSE)
	{
		WriteTimestampedLogEntry("ACR__AreaCleanupTask(): Area " + GetName(InstancedArea) + ": " + ObjectToString(InstancedArea) + " is ready for cleanup.  Releasing area.");
		ACR_ReleaseAreaInstance(InstancedArea);

		// Note that we intentionally fall through here, because the deletion
		// script may have denied the cleanup request.  In that case, we will
		// periodically re-check for deletion unless the area goes into the free
		// list.
	}
	else
	{
		DeleteLocalInt(InstancedArea, ACR_AREA_INSTANCE_HAD_ACTIVITY);
	}

	DelayCommand(Delay, ACR__AreaCleanupTask(InstancedArea, Delay));
}

void ACR__CallOriginalOnLeaveHandler(object InstancedArea)
{
	string Script = GetLocalString(InstancedArea, ACR_AREA_INSTANCE_ORIGINAL_ONLEAVE_SCRIPT);

	if (Script == "" || Script == ACR_AREA_INSTANCE_ONLEAVE_ACR_SCRIPT)
		return;

	ExecuteScriptEnhanced(Script, InstancedArea);
}


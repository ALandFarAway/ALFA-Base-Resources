// gdm_load_area
/*
    load specified module.

    This script for use in normal conversation
*/
// ChazM 2/24/06

/*
int    OBJECT_TYPE_CREATURE         = 1;
int    OBJECT_TYPE_ITEM             = 2;
int    OBJECT_TYPE_TRIGGER          = 4;
int    OBJECT_TYPE_DOOR             = 8;
int    OBJECT_TYPE_AREA_OF_EFFECT   = 16;
int    OBJECT_TYPE_WAYPOINT         = 32;
int    OBJECT_TYPE_PLACEABLE        = 64;
int    OBJECT_TYPE_STORE            = 128;
int    OBJECT_TYPE_ENCOUNTER		= 256;
int    OBJECT_TYPE_LIGHT            = 512;
int    OBJECT_TYPE_PLACED_EFFECT    = 1024;
int    OBJECT_TYPE_ALL              = 32767;

int    OBJECT_TYPE_INVALID          = 32767;	

area object appear to return type 0.
*/	
	
//#include "gdm_inc"
#include "ginc_debug"	
#include "ginc_param_const"

object GetFirstWPInArea(object oArea)
{
    // Loop through objects in oArea until we find a waypoint
    object oObject = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(oObject))
    {
         // Destroy any objects tagged "DESTROY"
         if(GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT)
         {
             return(oObject);
         }
         oObject = GetNextObjectInArea(oArea);
    }
	return (OBJECT_INVALID);
}
	
	
void main()
{
    string sTag = GetLocalString(GetPCSpeaker(), "dm_param");
    object oPC = GetPCSpeaker();
	object oObject = GetTarget(sTag);
/*
	if (!GetIsObjectValid(oArea))
	{
		PrettyDebug("Target not a valid area.");
		return;
	}
*/	
	int iType = GetObjectType(oObject);
	PrettyDebug("Tagged object is Type: " + IntToString(iType));

	if (iType == 0) // areas are type 0
	{
		object oWP = GetFirstWPInArea(oObject);
		if (!GetIsObjectValid(oWP))
		{
			PrettyDebug("No waypoints found in target area.");
			return;
		}
		oObject = oWP;
	}
	PrettyDebug("Jumping to object " + GetName(oObject) + " - Tag: " + GetTag(oObject) + " which is type " + IntToString(GetObjectType(oObject)));
	AssignCommand(oPC, ActionJumpToObject(oObject));
}
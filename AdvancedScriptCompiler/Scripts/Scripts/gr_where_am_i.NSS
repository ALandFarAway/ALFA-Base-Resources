// gr_where_am_i
/*
    Reports current location

    This script for use with the dm_runscript console command
*/
// ChazM 11/13/05
#include "ginc_debug"
#include "x0_i0_position"
//	dfdsa	
void main()
{
    PrettyDebug(GetName(OBJECT_SELF) + " is currently in:");
	
	PrettyDebug(" Module: " + GetName(GetModule()) + " / Module Tag: " + GetTag(GetModule()) );
	PrettyDebug(" Area Name: " + GetName(GetArea(OBJECT_SELF)) + " / Area Tag: " + GetTag(GetArea(OBJECT_SELF)) );
	PrettyDebug(" Position: " +  VectorToString(GetPosition(OBJECT_SELF)) );
	PrettyDebug(" Facing: " +  FloatToString(GetFacing(OBJECT_SELF)) );

}
//::///////////////////////////////////////////////
//::
//:: c_gpc_HeartOn
//::
//:: c_gpc_HeartOn
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Will turn a heartbeat script on (0), if that heartbeat script
//:: has been written accordingly.
//::
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent Knowles
//:: Created On: April 20, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    SetLocalInt(OBJECT_SELF,"NW_L_HEARTBEAT",0);
}

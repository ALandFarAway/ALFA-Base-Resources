//::///////////////////////////////////////////////
//:: Name
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets current "type" of item property to add
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x2_inc_ws_smith"

void main()
{
        // * this variable set so that the generic Have Enough gold
        // * script knows which item property you are trying to add
        SetLocalInt(OBJECT_SELF, "X2_LAST_PROPERTY", IP_CONST_WS_TRUESEEING);

}

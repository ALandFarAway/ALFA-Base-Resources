//::///////////////////////////////////////////////
//:: x2_sig_state
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sends an event to every party member
    saying I've been put into a disabling state
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_inc_henai"

#include "hench_i0_generic"

void main()
{
     // TK removed SendForHelp
//    SendForHelp();
	InitializeCreatureInformation(OBJECT_SELF);
}
//::///////////////////////////////////////////////
//:: Deadly Spike Trap
//:: NW_T1_SpikeStrC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a spike for
    25d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
    DoTrapSpike(d6(25));
}


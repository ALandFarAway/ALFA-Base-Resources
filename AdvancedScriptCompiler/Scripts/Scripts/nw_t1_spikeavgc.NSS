//::///////////////////////////////////////////////
//:: Average Spike Trap
//:: NW_T1_SpikeAvgC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a spike for
    3d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th , 2001
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
    DoTrapSpike(d6(3));
}


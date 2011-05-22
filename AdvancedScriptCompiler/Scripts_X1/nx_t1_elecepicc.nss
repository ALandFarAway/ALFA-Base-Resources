//::///////////////////////////////////////////////
//:: Electrical Epic Trap
//:: NW_T1_ElecEpicC.nss
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 50d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.22.2007
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    TrapDoElectricalDamage(d6(50),35,6);
}

//::///////////////////////////////////////////////
//:: Protection from Law
//:: NW_S0_PrLaw.nss
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    When confronted by law the protected character
    gains +2 AC, +2 to Saves and immunity to all
    mind-affecting spells cast by law creatures
*/
//:://////////////////////////////////////////////

#include "nw_s0_prvalign_i"


void main()
{
    handle_protection_vs_align(ALIGNMENT_LAWFUL, FEAT_CHAOS_DOMAIN_POWER);
}

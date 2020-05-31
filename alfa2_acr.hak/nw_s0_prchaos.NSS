//::///////////////////////////////////////////////
//:: Protection from Chaos
//:: NW_S0_PrChaos.nss
//:: Copyright (c) 2020 A Land Far Away
//:://////////////////////////////////////////////
/*
    When confronted by chaos the protected character
    gains +2 AC, +2 to Saves and immunity to all
    mind-affecting spells cast by chaos creatures
*/
//:://////////////////////////////////////////////

#include "nw_s0_prvalign_i"


void main()
{
    handle_protection_vs_align(ALIGNMENT_CHAOTIC, FEAT_LAW_DOMAIN_POWER)
}

//::///////////////////////////////////////////////
//:: Protection from Good
//:: NW_S0_PrGood.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When confronted by good the protected character
    gains +2 AC, +2 to Saves and immunity to all
    mind-affecting spells cast by good creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////

#include "nw_s0_prvalign_i"


void main()
{
    handle_protection_vs_align(ALIGNMENT_GOOD, FEAT_EVIL_DOMAIN_POWER)
}

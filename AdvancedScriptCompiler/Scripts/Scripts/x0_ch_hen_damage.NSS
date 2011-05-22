//:://////////////////////////////////////////////////
//:: X0_CH_HEN_DAMAGE
/*
  OnDamaged event handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////
// ChazM 2/21/07 Script deprecated. Use gb_assoc_* scripts instead.

#include "ginc_event_handlers"

void main()
{
    ConvertToAssociateEventHandler(CREATURE_SCRIPT_ON_DAMAGED, SCRIPT_ASSOC_DAMAGE);
}    
/*



void main()
{
	ExecuteScript("nw_ch_ac6", OBJECT_SELF);
}
*/
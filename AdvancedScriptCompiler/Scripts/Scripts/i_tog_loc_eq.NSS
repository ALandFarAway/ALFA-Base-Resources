// i_tog_loc_eq
/*
	Activate Debug Doodad taking player to wp_party_central (or start if not defined) unless in same area,
	in which case we return to where we were.
*/	
// ChazM9/28/05	
	
#include "ginc_debug"
	
const string WP_PARTY_CENTRAL		= "wp_party_central";
const string VAR_RETURN_LOCATION 	= "ReturnLocation";
	
// if in the same area as the location, return to previous area.
// if not in same area, go to specified location
void ToggleLocation(object oPC, location lFixedLocation)	
{
    if (GetArea(oPC) != GetAreaFromLocation(lFixedLocation)) 
	{
        SetLocalLocation(oPC, VAR_RETURN_LOCATION, GetLocation(oPC));
        AssignCommand(oPC, ActionJumpToLocation(lFixedLocation));
        AssignCommand(oPC, DebugMessage("entering Debug Area"));
    } 
	else // we are in Party Central
	{
        location lReturnLocation = GetLocalLocation(oPC, VAR_RETURN_LOCATION);
        AssignCommand(oPC, ActionJumpToLocation(lReturnLocation));
        AssignCommand(oPC, DebugMessage("Leaving Debug Area"));
    }
}
	
void main()
{
    //object oUser=GetItemActivator();
    //object oTarget=GetItemActivatedTarget();
	
    // * This code runs when the item is acquired
    //object oPC      = GetModuleItemAcquiredBy();
    //object oItem    = GetModuleItemAcquired();
    //int iStackSize  = GetModuleItemAcquiredStackSize();
    //object oFrom    = GetModuleItemAcquiredFrom();

    object oPC      = GetPCItemLastEquippedBy();
    //object oItem    = GetPCItemLastEquipped();
	

	object oWP_PartyCentral = GetObjectByTag(WP_PARTY_CENTRAL);
	location lStartLocation = GetStartingLocation();

	if (GetIsObjectValid(oWP_PartyCentral))
		lStartLocation = GetLocation(oWP_PartyCentral);

	ToggleLocation(oPC, lStartLocation);	
}
	
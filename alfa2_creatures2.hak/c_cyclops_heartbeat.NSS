//::///////////////////////////////////////////////
//:: Heartbeat script
//:: for the creature c_cyclops
//:: Copyright (c) 2014 Thierry Petitjean (4760).
//:://////////////////////////////////////////////
/*

    Simple script to run a specific script when the catapult attacks
	(normal heartbeat script otherwise)

*/
//:://////////////////////////////////////////////
//:: Created By: Thierry Petitjean (4760)
//:: Created On: 2014-09-12
//:://////////////////////////////////////////////

void main()
{
	object oCatapult = OBJECT_SELF;
	if (GetIsInCombat(oCatapult))
 	{
		ExecuteScript("c_cyclops_attack", oCatapult);
	}
	else
	{
		ExecuteScript("nw_c2_default1", oCatapult);
	}
}
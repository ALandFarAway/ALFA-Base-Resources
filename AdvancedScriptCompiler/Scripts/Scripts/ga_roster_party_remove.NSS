//ga_roster_party_remove
/*
//RWT-OEI 09/19/05
//This function removes a roster member from the party. It does not
//despawn the roster member or save the roster member's state. 
//Couple with DespawnRosterMember() if you need to remove the roster
//member from the area or save their current state
void RemoveRosterMemberFromParty( string sRosterName, object oPC );
*/
// ChazM 12/2/05

#include "ginc_param_const"
	
void main(string sRosterName, string sTarget)
{
	object oTarget = GetTarget(sTarget, TARGET_PC);
	RemoveRosterMemberFromParty(sRosterName, oTarget);
}
	
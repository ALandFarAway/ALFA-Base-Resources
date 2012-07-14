// ga_faction_join
/*
    This script makes sTarget join a new faction.
	sTarget - The target who's faction will change (see Target's note).
	sTargetFaction - Either one of the 4 standard factions $COMMONER, $DEFENDER, $HOSTILE, $MERCHANT or
				a target who's faction is to be joined (must be a creature)
*/
//  ChazM 2/25/05
// DBR 11/09/06 - TargetFactionMember was using wrong target string

#include "ginc_param_const"
#include "nw_i0_generic"


void main(string sTarget, string sTargetFaction) 
{
	object oTarget = GetTarget(sTarget);
	int iFaction = GetStandardFaction(sTargetFaction);
	
	if (iFaction != -1) {
		ChangeToStandardFaction(oTarget, iFaction);
		PrintString ("Changed to standard faction " + sTargetFaction );
	}		
	else {
		object oTargetFactionMember = GetTarget(sTargetFaction);
 		ChangeFaction(oTarget, oTargetFactionMember);
		PrintString ("Changed to same faction as " + GetName(oTarget));
	}		

	// Force a perception re-check when a faction is changed of those nearby
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oTarget, 0.05);
	
	AssignCommand(oTarget, DetermineCombatRound());
	
}

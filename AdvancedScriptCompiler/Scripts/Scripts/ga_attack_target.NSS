// ga_attack_target
/*
   This script makes the sAttacker attack the sTarget. It should be placed on an [END DIALOG] node.

   Parameters:
     string sAttacker 	- Tag of attacker.  Default is OWNER.
     string sTarget 	- Tag of Target.  Default is PC.
	 int bMaintainFaction - 0 (FALSE) = change attacker to the standard HOSTILE faction. 1(TRUE) = don't change faction.  
*/
// FAB 10/7
// ChazM 4/26
// ChazM 5/10/07 - added bMaintainFaction

#include "ginc_param_const"
#include "ginc_actions"

void main(string sAttacker, string sTarget, int bMaintainFaction)
{
    object oAttacker = GetTarget(sAttacker, TARGET_OWNER);
    object oTarget = GetTarget(sTarget, TARGET_PC);
	StandardAttack(oAttacker, oTarget, !bMaintainFaction);
}
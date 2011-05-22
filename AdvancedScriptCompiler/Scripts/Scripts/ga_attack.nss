// ga_attack
/*
   This script makes the sAttacker attack the PC. It should be placed on an [END DIALOG] node.

   Parameters:
     string sAttacker = Tag of attacker whom will attack the PC.  Default is OWNER.
	 int bMaintainFaction - 0 (FALSE) = change attacker to the standard HOSTILE faction. 1(TRUE) = don't change faction.  
*/
// FAB 10/7
// ChazM 4/26
// ChazM 5/10/07 - added bMaintainFaction

#include "ginc_param_const"
#include "ginc_actions"

void main(string sAttacker, int bMaintainFaction)
{
    object oAttacker = GetTarget(sAttacker, TARGET_OWNER);
    object oTarget = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	StandardAttack(oAttacker, oTarget, !bMaintainFaction);
}
//::///////////////////////////////////////////////
//:: Behavior Screen - Follow Distance: Near 
//:: gui_bhvr_follownear.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 03/29/06
//:://////////////////////////////////////////////
// ChazM 4/26/06 - use SetBehavior()
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_FOLLOWDIST_NEAR, iExamined);
}
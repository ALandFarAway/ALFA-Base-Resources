// gui_bhvr_combat_mode_use_off.nss
/*
	Combat Mode Use Off Behavior script for the character sheet behavior sub-panel
*/
// BMA-OEI 10/12/06
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_COMBAT_MODE_USE_OFF, iExamined);
}
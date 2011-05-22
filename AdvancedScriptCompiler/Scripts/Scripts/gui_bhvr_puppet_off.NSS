// gui_bhvr_puppet_off
/*
	Behavior script for the character sheet behavior sub-panel
*/
// ChazM 8/9/06
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_PUPPET_OFF, iExamined);
}
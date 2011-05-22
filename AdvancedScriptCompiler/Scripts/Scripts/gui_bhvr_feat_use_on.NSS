// gui_bhvr_feat_use_on
/*
	Behavior script for the character sheet behavior sub-panel
*/
// ChazM 8/8/06
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_FEAT_USE_ON, iExamined);
}
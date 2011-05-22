// gui_bhvr_item_use_off
/*
	Behavior script for the character sheet behavior sub-panel
*/
// ChazM 8/7/06
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_ITEM_USE_OFF, iExamined);
}
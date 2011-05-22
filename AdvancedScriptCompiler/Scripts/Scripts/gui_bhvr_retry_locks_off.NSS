// gui_bhvr_retry_locks_off
/*
	Behavior script for the character sheet behavior sub-panel
*/
// ChazM 4/26/06
// ChazM 11/9/06 - Examined Creature update

#include "gui_bhvr_inc"

void main(int iExamined)
{
	SetBehavior(STR_REF_BEHAVIOR_RETRY_LOCKS_OFF, iExamined);
}
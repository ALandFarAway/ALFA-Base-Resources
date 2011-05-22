// ga_set_animation_condition(int nFlag, int bState, string sTarget)
/*

	Sets Animation Condition flag.  See below for list of flags.  
	Some flags should probably not be altered by this script.

*/
// ChazM 9/1/06


/*
NW_ANIM_CONDITION (int) – Various flags relating to the animations played by ambient characters.
const int NW_ANIM_FLAG_INITIALIZED             = 0x00000001; // 1       
const int NW_ANIM_FLAG_CONSTANT                = 0x00000002; // 2
const int NW_ANIM_FLAG_CHATTER                 = 0x00000004; // 4
const int NW_ANIM_FLAG_IS_ACTIVE               = 0x00000008; // 8
const int NW_ANIM_FLAG_IS_INTERACTING          = 0x00000010; // 16
const int NW_ANIM_FLAG_IS_INSIDE               = 0x00000020; // 32 
const int NW_ANIM_FLAG_HAS_HOME                = 0x00000040; // 64
const int NW_ANIM_FLAG_IS_TALKING              = 0x00000080; // 128
const int NW_ANIM_FLAG_IS_MOBILE               = 0x00000100; // 256
const int NW_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE   = 0x00000200; // 512
const int NW_ANIM_FLAG_IS_CIVILIZED            = 0x00000400; // 1024
const int NW_ANIM_FLAG_CLOSE_DOORS             = 0x00001000; // 2048

*/

#include "x0_i0_anims"
#include "ginc_param_const"
#include "ginc_debug"

void main(int nFlag, int bState, string sTarget)
{
	object oTarget = GetTarget(sTarget);
	int iAnim = GetLocalInt(oTarget, "NW_ANIM_CONDITION");
	SetAnimationCondition(nFlag, bState, oTarget);
	
	int iNewAnim = GetLocalInt(oTarget, "NW_ANIM_CONDITION");
	PrettyDebug (GetName(oTarget) + " NW_ANIM_CONDITION was = " + IntToString(iAnim) + " - now = " + IntToString(iNewAnim));
}
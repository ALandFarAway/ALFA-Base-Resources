//ga_play_animation(string sTarget, int nAnim, float fSpeed,  float fDurationSeconds, float fDelayUntilStart)
/*
 	Conversation script wrapper for ActionPlayAnimation() command.
 
	Parameters:
		sTarget - tag of creature to play animation - default is conversation owner.
		
   		nAnim   - ANIMATION CONSTANT.  These include ANIMATION_FIREFORGET_*, ANIMATION_LOOPING_*, 
				and ANIMATION_PLACEABLE_*.  The Globals tab of script assist can be used to get the numbers.
				For example ANIMATION_LOOPING_INJURED is 47.
	
   		fSpeed  - The fSpeed parameter can be used to speed up or slow down the animation. 1.0 is normal speed. 
	
 		fDurationSeconds - Duration of animation (doesn't apply to fire & forget animations).  A common parameter 
					for looping animations is 6.0, as it means that the creature spends a full round doing that animation.
	
   		fDelayUntilStart  - Not to be confused with DURATION, this controls how long after the node starts in seconds to play the animation.

		   
	Example 1: make a chest (tag of "PLC_ML_CHESTM01") container open:
		ga_play_animation("PLC_ML_CHESTM01", 202, 1.0, 0.0, 0.0)

      
	Example 2: make conversation owner appear injured for a round:
		ga_play_animation("", 47, 1.0, 6.0, 0.0)
		
*/
//ChazM 9/22/06
//ChazM 6/13/07 - added comments

#include "ginc_param_const"
#include "ginc_math"

void main(string sTarget, int nAnim, float fSpeed,  float fDurationSeconds, float fDelayUntilStart)
{
	if (IsFloatNearInt(fSpeed, 0))
		fSpeed = 1.0f;

	object oTarget = GetTarget(sTarget);
	
	if (GetIsObjectValid(oTarget))
	{
		if (IsFloatNearInt(fDelayUntilStart, 0))
			AssignCommand(oTarget, PlayAnimation(nAnim,fSpeed,fDurationSeconds));
		else
			AssignCommand(oTarget, DelayCommand(fDelayUntilStart,PlayAnimation(nAnim,fSpeed,fDurationSeconds)));
	}
}
//ga_play_custom_animation
/*
 	Conversation script wrapper for PlayCustomAnimation() command.

 	Parameters:
   		sTarget - tag of creature to play animation - default is conversation owner.
   		sAnim   - animation to play - uses PlayCustomAnimation's *, # and % rules.
   		bLoop   - TRUE for looping, FALSE for single-shot.
   		fDelayUntilStart  - Not to be confused with DURATION, this controls how long after 
							the node starts in seconds to play the animation.

Animation special symbols:
When "%" is passed to PlayCustomAnimation, it resets the creature to its idle animation, 
it kind of clears the current animation for the creature.

Asterisk "*" can be used to fill in the prefix of an animation. For example: PlayCustomAnimation("*dodge01")
will fill out the skeleton and gender data and choose correctly between MD009_dodge01, FH007_dodge01, etc.

Pound "#" is for facial animations.  For example #bigsmile to get a character to smile.  These didn't prove to
look as expected and are to be avoided if possible.
		
*/
// DBR 6/20/06
//EPF -- removed the AssignCommand from the delay code, since that seems to be a likely cause of interrupting animations.
// ChazM 5/1/07 added comments collected from DBR & EPF

#include "ginc_param_const"

void PlayCustomAnimationWrapper(object oTarget, string sAnim, int bLoop)	//so it returns a void
{
	PlayCustomAnimation(oTarget,sAnim,bLoop);
}

void main(string sTarget, string sAnim, int bLoop=0, float fDelayUntilStart=0.0f)
{
	object oTarget = GetTarget(sTarget);
	
	if (GetIsObjectValid(oTarget))
	{
		if (fDelayUntilStart==0.0f)
			PlayCustomAnimation(oTarget,sAnim,bLoop);
		else
			DelayCommand(fDelayUntilStart,PlayCustomAnimationWrapper(oTarget,sAnim,bLoop));//place the delaycommand on the creature as well
	}
}
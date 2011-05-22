// ga_play_sound
//
// Play sound file sSound on object with tag sTarget.
// Note: Advise using this on creatures only.  Typically calls to play the sound on the module,
// the area, or even a dynamic placeable fail, because I believe this actually goes into an action
// queue, despite the function's name lacking the word "action."

// Also Note: Do not specify the sound file's extension for sSound.  If you want to play
// as_pl_flatulence.wav, just enter in "as_pl_flatulence" for sSound.

// Supplying the empty string for sTarget will just use the conversation owner as the target object.

// EPF 7/6/06

#include "ginc_param_const"

void main(string sSound, string sTarget, float fDelay)
{
	object oTarget = GetTarget(sTarget, TARGET_OWNER);
	if(GetIsObjectValid(oTarget))
	{
		AssignCommand(oTarget, DelayCommand(fDelay,PlaySound(sSound)));
	}
}
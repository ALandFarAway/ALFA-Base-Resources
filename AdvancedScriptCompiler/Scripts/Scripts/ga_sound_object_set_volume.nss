// ga_sound_object_set_volume(string sTarget, int iVolume)
/*
	Sets the volume of a placed sound object
	
	Parameters:
		string sTarget	= tag of the sound object
		int iVolue = An integer value between 0 and 127
*/
//ChazM 8/17/06

#include "ginc_param_const"

void main(string sTarget, int iVolume)
{
	object oTarget = GetSoundObjectByTag(sTarget);
	if (GetIsObjectValid(oTarget)) 
		SoundObjectSetVolume(oTarget, iVolume);
}
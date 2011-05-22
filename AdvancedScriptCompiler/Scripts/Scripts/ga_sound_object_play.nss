// ga_sound_object_play(string sTarget)
/*
	plays a sound object, which may comprise many sound resources
	
	Parameters:
		string sTarget	= tag of the sound object

*/
//ChazM 8/17/06

#include "ginc_param_const"


void main(string sTarget)
{
	object oTarget = GetSoundObjectByTag(sTarget);
	if (GetIsObjectValid(oTarget)) 
		SoundObjectPlay(oTarget);
}
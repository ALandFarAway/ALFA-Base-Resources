// KEMO 2/09 --- called from KEMO_ANIM GUI

#include "kemo_includes"

void main(int bFull)
{
	object oPC = OBJECT_SELF;
	string sAnim = GetLocalString(oPC,"StoredAnimation");
	string sAnimB = GetLocalString(oPC,"StoredAnimationIdle");
	float fDelay = GetLocalFloat(oPC,"StoredDelay");
	SetLocalLocation(oPC,"AnimationLocation",GetLocation(oPC));
	
	if (!bFull)
	{
		AnimationLoop(oPC,GetLocation(oPC));
	}
	else
	{
		PlayKemoAnimation(oPC,sAnim);
		DelayCommand(fDelay,AnimationLoop(oPC,GetLocation(oPC)));
	}
}
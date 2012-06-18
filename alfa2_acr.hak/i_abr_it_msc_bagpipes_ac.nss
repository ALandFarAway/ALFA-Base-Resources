#define FLOAT_RANGE_SHORT 3.0f

void PlayCustomAnimationWrapper(object oTarget, string sAnim, int bLoop)	//so it returns a void
{
	PlayCustomAnimation(oTarget,sAnim,bLoop);
}

void main()
{
	object oPC  = GetItemActivator();
	object oTarget = GetItemActivatedTarget();

	DelayCommand(0.1f,PlayCustomAnimationWrapper(oPC,"bagpipes",1));
}


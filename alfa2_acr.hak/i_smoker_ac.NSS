void PlayCustomAnimationWrapper(object oTarget, string sAnim, int bLoop, float speed)   // so it returns a void
{
        PlayCustomAnimation(oTarget,sAnim, bLoop, speed);
}

void main()
{
        object oPC = GetItemActivator();

        // SetCollision(oPC, FALSE);
        ClearAllActions();

        // Slow the Animation down to half speed..
        PlayCustomAnimationWrapper(oPC, "smoking", 0, 0.5f);

        effect eSmoke = EffectNWN2SpecialEffectFile("fx_smoking_exhale");

        // Wait the "puff" keyframe is about 2 seconds in
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, oPC, 0.5f));
}
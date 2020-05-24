void main()
{
        object oPC = GetItemActivator();

        // SetCollision(oPC, FALSE);
        ClearAllActions();

        // Slow the Animation down to half speed..
        PlayCustomAnimation(oPC, "Smoking", 0, 0.25f);

        effect eSmoke = EffectNWN2SpecialEffectFile("fx_smoking_exhale");

        // Wait the "puff" keyframe is about 2 seconds in
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, oPC, 0.5f));
}
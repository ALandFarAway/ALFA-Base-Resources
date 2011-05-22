//::///////////////////////////////////////////////
//:: Intensity 3
//:: NW_S1_Intens3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Dex and Con of the target increases
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    int nIncrease = 9;
    //Determine the duration by getting the con modifier after being modified
    int nCon = GetAbilityModifier(ABILITY_CONSTITUTION);
    nCon = (((GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION) - 10) + nIncrease )/2) + nCon;
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nIncrease);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eCon, eDex);
    eLink = EffectLinkEffects(eLink, eDur);
    
    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);
    //effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_INTENSITY_3, FALSE));
    if (nCon > 0)
    {
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
    }
}

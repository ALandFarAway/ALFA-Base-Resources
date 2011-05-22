//::///////////////////////////////////////////////
//:: Name x2_sp_is_dred
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Deep Red
    Gives the user 1 hours worth of +2 Dexterity bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////

void main()
{
    //variables
    effect eVFX, eBonus, eLink, eEffect;

    //from any other ioun stones
    eEffect = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561)
        {
            RemoveEffect(OBJECT_SELF, eEffect);
        }
        eEffect = GetNextEffect(OBJECT_SELF);
    }

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(499);
    eBonus = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
    eLink = EffectLinkEffects(eVFX, eBonus);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 3600.0);

}

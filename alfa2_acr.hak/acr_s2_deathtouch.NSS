//::///////////////////////////////////////////////
//:: Death Domain Touch
//:: acr_s0_deathtouch.nss
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: Zelknolf
//:: Created On: September 24, 2012
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
        return;

    object oTarget = GetSpellTargetObject();
    int nMaxHitPoints = d6(GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF));

    if(TouchAttackMelee(oTarget) && 
       !ResistSpell(oTarget, OBJECT_SELF) && 
       GetCurrentHitPoints(oTarget) < nMaxHitPoints &&
       !GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF) )
           ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
}
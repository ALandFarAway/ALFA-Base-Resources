//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
	5.2.6.1.2	Harm
	This spell works very differently now. Negative energy deals 10 damage 
	per caster level (maximum 150). If the target makes a successful Will save, 
	they only take half damage and can’t be reduced below 1 hit point.

*/
// ChazM 5/15/07 - Now calls HealHarmTarget()

//#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

void main()
{
    if (!ACR_PrecastEvent()) return;

    object oCaster   = OBJECT_SELF;
    object oTarget   = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(oCaster);

    if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        effect eEffect = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eEffect))
        {
            int nType = GetEffectType(eEffect);
            if(nType == EFFECT_TYPE_ABILITY_DECREASE)
            {
                if(GetEffectSubType(eEffect) != SUBTYPE_SUPERNATURAL)
                    RemoveEffect(oTarget, eEffect);
            }
            if(nType == EFFECT_TYPE_BLINDNESS ||
               nType == EFFECT_TYPE_CONFUSED ||
               nType == EFFECT_TYPE_DAZED ||
               nType == EFFECT_TYPE_DEAF ||
               nType == EFFECT_TYPE_DISEASE ||
               nType == EFFECT_TYPE_STUNNED ||
               nType == EFFECT_TYPE_POISON)
                    RemoveEffect(oTarget, eEffect);
            eEffect = GetNextEffect(oTarget);
        }
    }


    // Harm target will figure out if whether it needs to heal or harm
    int bIsHealingSpell = FALSE;
    int nSpellID = SPELL_HARM;
    HealHarmTarget(oTarget, nCasterLevel, nSpellID, bIsHealingSpell);
}
//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
	5.2.6.1.3	Heal
	This spell works differently now. Positive energy cures 10 damage per caster 
	level (maximum 150). It also removes the following conditions: ability damage, 
	blinded, confuse, dazzled, deafened, diseased, feebleminded, insanity, nausea, 
	poison, and stunned. [Note: some of these conditions may not exist in NWN. If the 
	condition doesn’t exist, just ignore during implementation.]

*/
// ChazM 5/15/07 - Now calls HealHarmTarget()


//#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "nwn2_inc_spells"

void main()
{
    if (!ACR_PrecastEvent()) return;

    //Declare major variables
    object oCaster   = OBJECT_SELF;
    object oTarget   = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(oCaster);
	
    if(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
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

    // Heal target will figure out if whether it needs to heal or harm
    int bIsHealingSpell = TRUE;
    int nSpellID = SPELL_HEAL;
    HealHarmTarget(oTarget, nCasterLevel, nSpellID, bIsHealingSpell );	
}
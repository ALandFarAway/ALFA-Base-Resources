#ifndef ACR_COMBAT_EFFECTS_I
#define ACR_COMBAT_EFFECTS_I

#include "acr_tools_i"

void CheckIsFlatFooted(object oTarget, int nCount = 0);

void CheckIsFlatFooted(object oTarget, int nCount = 0)
{
    // pTarget isn't even a real person. Return.
    if(!GetIsObjectValid(oTarget)) return;

    // oTarget inanimate. Chairs can't dodge (usually).
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) return;

    // This code just fired. Don't double it up.
    if(GetLocalInt(OBJECT_SELF, "DODGE_ADJUST") == 1) return;
	
/*
    First, should this character be flat-footed? Characters with uncanny dodge should
    never be caught flat-footed, as such is the nature of the feat. Also, anyone who
    has taken an action in combat is not flat-footed.
*/
    if(GetIsInCombat(oTarget) || GetHasFeat(FEAT_UNCANNY_DODGE, oTarget))
    {
        int nTargetAction = GetCurrentAction(oTarget);
		
/*
    Is the target doing something that isn't part of combat directly, and would thus
    be called flat-footed by the engine, but is something that could be done during
    combat, and without thus not be called flat-footed by Dungeons and Dragons?
*/
        if(nTargetAction == ACTION_CLOSEDOOR ||
           nTargetAction == ACTION_DIALOGOBJECT ||
           nTargetAction == ACTION_DISABLETRAP ||
           nTargetAction == ACTION_DROPITEM ||
           nTargetAction == ACTION_EXAMINETRAP ||
           nTargetAction == ACTION_FLAGTRAP ||
           nTargetAction == ACTION_FOLLOW ||
           nTargetAction == ACTION_HEAL ||
           nTargetAction == ACTION_INVALID ||
           nTargetAction == ACTION_LOCK ||
           nTargetAction == ACTION_MOVETOPOINT ||
           nTargetAction == ACTION_OPENDOOR ||
           nTargetAction == ACTION_OPENLOCK ||
           nTargetAction == ACTION_PICKUPITEM ||
           nTargetAction == ACTION_RANDOMWALK ||
           nTargetAction == ACTION_RECOVERTRAP ||
           nTargetAction == ACTION_SETTRAP ||
           nTargetAction == ACTION_WAIT)
        {
            // Everybody gets their dexterity bonus to their AC.
            int nACDiff = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	
            // If a target's dexterity provides more benefit than max dex bonus, we presume
            // that the dex bonus had is the max dex bonus of the armor.
            int nArmorType = ACR_GetArmorRulesType(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget));
            int nMaxDex = StringToInt(Get2DAString("armorrulestats", "MAXDEXBONUS", nArmorType));
            if(nACDiff > nMaxDex) nACDiff = nMaxDex;

            if(GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 0)
            {
                //Monks get their wisdom bonus to AC if they are unarmored. OBJECT_INVALID is armor type 0, too.
                if( nArmorType == 0 )
                    nACDiff += GetAbilityModifier(ABILITY_WISDOM, oTarget);
            }
	
            effect eEffect = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eEffect))
            {
                if(GetEffectType(eEffect) == EFFECT_TYPE_AC_INCREASE)
                {
                    if(GetEffectInteger(eEffect, 0) == AC_DODGE_BONUS)
                        nACDiff += GetEffectInteger(eEffect, 1); // Integer 1 is the AC adjustment made by the effect
                }
                if(GetEffectType(eEffect) == EFFECT_TYPE_AC_DECREASE)
                {
                    if(GetEffectInteger(eEffect, 0) ==  AC_DODGE_BONUS)
                        nACDiff -= GetEffectInteger(eEffect, 1); // Integer 1 is the AC adjustment made by the effect
                }
                eEffect = GetNextEffect(oTarget);
            }

            // If this resolves to a negative number, set it to 0. Being flat-footed never
            // improves your AC.
            if(nACDiff < 0) nACDiff = 0;
	
            /* 
                If there is any difference to apply, apply it for 1.8 seconds. This will cause the round
                to evaluate three times:
                -- Initially
                -- At 1.8 seconds (before flurry 2, after flurry 1)
                -- At 3.6 seconds (before flurry 3, after flurry 2)
                The less-than-two-second interval is expected to avoid race conditions or performance
                from damaging the functionality.
            */			
            if(nACDiff)			
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(nACDiff), OBJECT_SELF, 1.8f);

            // We expect the AI to call again at the end of the round. If something goes amiss,
            // just let it die out.
            if(nCount < 2)
            {
                nCount++;
                SetLocalInt(OBJECT_SELF, "DODGE_ADJUST", 1);
                DelayCommand(1.7f, DeleteLocalInt(OBJECT_SELF, "DODGE_ADJUST"));
                DelayCommand(1.8f, CheckIsFlatFooted(oTarget, nCount));
            }
        }
    }
}

#endif
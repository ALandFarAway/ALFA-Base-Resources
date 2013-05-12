//::///////////////////////////////////////////////
//:: Frenzy
//:: NW_S1_Frenzy
//:://////////////////////////////////////////////
/*
    Similar to Barbarian Rage
    Gives +6 Str, -4 AC, extra attack at highest
    Base Attack Bonus (BAB), doesn't stack with Haste/etc.,
    receives 2 points of non-lethal dmg a round.
    Lasts 3+ Con Mod rounds.
    Greater Frenzy starts at level 8.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 22, 2005
//:://////////////////////////////////////////////
//:: AFW-OEI 08/07/2006: Now inflicts 12 points of
//::    damage per round.
//:: AFW-OEI 10/30/2006: Changed to 6 pts./rnd.

#include "x2_i0_spells"
#include "nwn2_inc_spells"
#include "acr_combat_actions_i"

void main()
{
    if(!GetHasFeatEffect(FEAT_FRENZY_1))
    {
        //Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER);
        int nIncrease;
        int nSave;

        if (GetHasFeat(FEAT_GREATER_FRENZY, OBJECT_SELF, TRUE))
        {
            nIncrease = 10;
        }
        else
        {
            nIncrease = 6;
        }

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
        //Determine the duration by getting the con modifier after being modified
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);

        // JLR - OEI 06/03/05 NWN2 3.5
        if (GetHasFeat(FEAT_EXTEND_RAGE))
        {
            nCon += 5;
        }
    

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
        effect eAC = EffectACDecrease(4, AC_DODGE_BONUS);
        effect eDot = EffectDamageOverTime(6, RoundsToSeconds(1), DAMAGE_TYPE_ALL);    // 6 points of damage per round
        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
        effect eAttackMod = EffectModifyAttacks(1);

        effect eLink = EffectLinkEffects(eStr, eAC);
        eLink = EffectLinkEffects(eLink, eDot);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eAttackMod);
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);

        if (nCon > 0)
        {
            float fDuration = RoundsToSeconds(nCon);
            fDuration        =    fDuration + 2.0;
        
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
            
            if (GetHasFeat(FEAT_DEATHLESS_FRENZY)) //Deathless frenzy check
            {
                effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
                effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
                effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
                effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
                
                effect eDeathless = EffectLinkEffects(eDeath, eDur);
                eDeathless = EffectLinkEffects(eDeathless, eNeg);
                eDeathless = EffectLinkEffects(eDeathless, eLevel);
                eDeathless = EffectLinkEffects(eDeathless, eAbil);
                
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathless, OBJECT_SELF, fDuration);
            }

            _ClearCombatModes(OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE, 1);
            DelayCommand(fDuration, DeleteLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE));
            
            // Start the fatigue logic half a second before the frenzy ends
            DelayCommand(fDuration - 0.5f, ApplyFatigue(OBJECT_SELF, 5, 0.6f));    // Fatigue duration fixed to 5 rounds
        }
    }
}

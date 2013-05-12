//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the Barbarian increases,
    Will Save are +2, AC -2.
    Greater Rage starts at level 15.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 04/12/2006: Made Greater and Mighty rage work as per 3.5 rules.
//::     Added fatigue after raging.
//::    Added Tireless Rage feat.
//:://////////////////////////////////////////////
//:: AFW-OEI 07/11/2007: New GetHasFeat() function call
//::    now returns false if a feat is not useable due to cooldown.
//::    So use new parameter to ignore remaining uses as we're merely doing
//::    an existence check.
//:: AFW-OEI 02/16/2007: Implement Epic Rage.
//:: AFW-OEI 06/25/2007: Implement Ice Troll Berserker.

#include "x2_i0_spells"
#include "nwn2_inc_spells"
#include "acr_combat_actions_i"

void ApplyFatigue2(object oTarget, int nFatigueDuration, float fDelay = 0.0f);
void ApplyFatigue3(object oTarget, int nFatigueDuration);

void main()
{
    // If you're already in a rage, don't apply effects again
    if(!GetHasFeatEffect(FEAT_BARBARIAN_RAGE))
    {
        // JLR - OEI 06/21/05 NWN2 3.5
        // AFW-OEI 04/11/2006: Implement Mighty Rage.
        int nIncrease;
        int nSave;
        int nNaturalAC = 0;
        if (GetHasFeat(FEAT_EPIC_BARBARIAN_RAGE, OBJECT_SELF, TRUE))    // Epic Rage
        {
            nIncrease = 10;
            nSave = 8;      // Intentional extra Will boost for Epic Barbs.
            nNaturalAC = 6;
        }
        else if (GetHasFeat(FEAT_BARBARIAN_RAGE7, OBJECT_SELF, TRUE))    // Mighty Rage
        {
            //SpeakString("nw_s1_barbrage: Has FEAT_BARBARIAN_RAGE7.");    // DEBUG
            nIncrease = 8;
            nSave = 4;
            nNaturalAC = 6;
        }
        else if (GetHasFeat(FEAT_BARBARIAN_RAGE4, OBJECT_SELF, TRUE))    // Greater Rage
        {
            //SpeakString("nw_s1_barbrage: Has FEAT_BARBARIAN_RAGE4.");    // DEBUG
            nIncrease = 6;
            nSave = 3;
            nNaturalAC = 4;
        }
        else    // Regular old rage
        {
            //SpeakString("nw_s1_barbrage: Default bonuses.");    // DEBUG
            nIncrease = 4;
            nSave = 2;
            nNaturalAC = 2;
        }

        //Determine the duration by getting the con modifier after being modified
        int nRageDuration = 3 + GetAbilityModifier(ABILITY_CONSTITUTION) + (nIncrease/2);
        if (GetHasFeat(FEAT_EXTEND_RAGE))        // JLR - OEI 06/03/05 NWN2 3.5
        {
            nRageDuration += 5;
        }

        // Apply rage bonuses, but only if your rage is going to last more than 0 rounds
        if (nRageDuration > 0)
        {    
            // Put together the positive rage effects
            effect eCon  = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
            effect eStr  = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
            effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave);
            effect eAC   = EffectACDecrease(2, AC_DODGE_BONUS);
            effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
    
            effect eLink = EffectLinkEffects(eCon, eStr);
            eLink = EffectLinkEffects(eLink, eSave);
            eLink = EffectLinkEffects(eLink, eAC);
            eLink = EffectLinkEffects(eLink, eDur);
            
            effect eNaturalAC;
            if (GetHasFeat(FEAT_ICE_TROLL_BERSERKER, OBJECT_SELF, TRUE))
            {
                eNaturalAC = EffectACIncrease(nNaturalAC, AC_NATURAL_BONUS);
                eLink = EffectLinkEffects(eLink, eNaturalAC); 
            }
            
            // Add Indomitable Will save bonus, if you have it
            if (GetHasFeat(FEAT_INDOMITABLE_WILL, OBJECT_SELF, TRUE))
            {
                effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);
                eLink = EffectLinkEffects(eLink, eWill);
            }
            
             eLink = ExtraordinaryEffect(eLink);     //Make effect extraordinary
    
            // Create the visual effect
            //effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX
                
            // "Cast" rage
            PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
            
            if ( PlayCustomAnimation(OBJECT_SELF, "sp_warcry", 0) )
            {
                //FloatingTextStringOnCreature( "I HAVE THE WARCRY ANIMATION!", OBJECT_SELF );
            }
            
            
            SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));
       
            //Apply the VFX impact and effects
            float fRageDuration = RoundsToSeconds(nRageDuration);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fRageDuration);
            _ClearCombatModes(OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE, 1);
            DelayCommand(fRageDuration, DeleteLocalInt(OBJECT_SELF, POST_SPELLCAST_NO_COMBAT_MODE));
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;

            // 2003-07-08, Georg: Rage Epic Feat Handling
            CheckAndApplyEpicRageFeats(nRageDuration);

            // Unless you have Tireless Rage, you're going to feel it in the morning
            if (!GetHasFeat(FEAT_TIRELESS_RAGE, OBJECT_SELF, TRUE))
            {
                // Start the fatigue logic half a second before the rage ends
                DelayCommand(fRageDuration - 0.5f, ApplyFatigue2(OBJECT_SELF, 5, 0.6f));    // Fatigue duration fixed to 5 rounds
            }
        }
    }
}

void ApplyFatigue2(object oTarget, int nFatigueDuration, float fDelay = 0.0f)
{
    //SpeakString("Entering ApplyFatigue");

    // Only apply fatigue ifyou're not resting.
    // This is to keep you from getting fatigued if you rest while raging.
    if( !GetIsResting() && (GetHasFeatEffect(FEAT_BARBARIAN_RAGE)) )
    {
        //SpeakString("Actually applying fatigue effect in ApplyFatigue");
        
        DelayCommand(fDelay, ApplyFatigue3(oTarget, nFatigueDuration));
    }
}

void ApplyFatigue3(object oTarget, int nFatigueDuration)
{
    if( !GetHasFeatEffect(FEAT_BARBARIAN_RAGE) )
    {
        // Create the fatigue penalty
        effect eFatigue = EffectFatigue();
    
        float fFatigueDuration = RoundsToSeconds(nFatigueDuration);
        
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFatigue, oTarget, fFatigueDuration);
    }
}

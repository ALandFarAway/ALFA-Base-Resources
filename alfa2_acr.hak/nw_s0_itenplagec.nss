//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Tenacious Plague   HEARTBEAT
//:: nw_s0_itenplagec.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Tenacious Plague [B]
        Complete Arcane, pg. 135
        Spell Level:	6
        Class: 			Misc

        This invocation functions similar to the creeping doom spell (7th level 
        druid). But the progression of damage works differently - 1d6 the first 
        round, 2d6 the second, 3d6 the third, etc. until the 10th round when the 
        invocation effect ends. Tenacious plagues cannot be stacked on top of 
        each other.

        [Rules Note] This spell is extremely different from the Complete Arcane 
        spell because in NWN2 we won't have swarms that can be summoned. So a 
        lesser version of the creeping doom spell is used here.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    object oTarget;
    float fDelay;
    if(nSwarm < 1)
    {
        nSwarm = 1;
    }

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Get first target in spell area
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        int bAttackRollMade = FALSE;
        fDelay = GetRandomDelay(1.0, 2.2);
        if(bAttackRollMade == FALSE)
        {
            if(d20() + 4 > GetAC(oTarget))
            {
                SignalEvent(oTarget,EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_I_TENACIOUS_PLAGUE));
                //Roll Damage
                nDamage = d6(2);
                //Set Damage Effect with the modified damage
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
                //Apply damage and visuals
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
        }
        if(!FortitudeSave(oTarget, 12 + GetAbilityModifier(GetAreaOfEffectCreator(), ABILITY_CHARISMA), SAVING_THROW_TYPE_DISEASE))
        {
            effect eNaus = EffectDazed();
            ApplyEffectToCreature(DURATION_TYPE_TEMPORARY, eNaus, oTarget, RoundsToSeconds(1));
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
}
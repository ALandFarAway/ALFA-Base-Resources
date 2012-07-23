//::///////////////////////////////////////////////
//:: Bless
//:: NW_S0_Bless.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 30ft of the caster gain a
    +1 attack bonus and a +1 save bonus vs fear
    effects

    also can be cast on crossbow bolts to bless them
    in order to slay rakshasa
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Added Bless item ability: Georg Z, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes

// Modified by Riotnrrd for ALFA 1/7/2009
// Changed duration to 1 min / level 

#include "nwn2_inc_spells"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!ACR_PrecastEvent())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF));

    //Metamagic duration check
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    // ---------------- TARGETED ON BOLT  -------------------
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {
           SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
           //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
           ApplyEffectToObject(nDurType, eVis, GetItemPossessor(oTarget), fDuration);
           return;
        }
    }


    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);*/
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eVis);

    float fDelay;

    //Apply Impact
    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());*/

    location lLoc = GetSpellTargetLocation();

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));
            //Apply VFX impact and bonus effects
            //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration));
			//SpeakString("Attempting to bless " + GetName(oTarget) + ". Duration Type: " + IntToString(nDurType) + " Duration:" + FloatToString(fDuration));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    }
}
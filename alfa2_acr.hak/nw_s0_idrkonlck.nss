//::///////////////////////////////////////////////
//:: Invocation: Dark One's Own Luck
//:: NW_S0_IDrkOnLck.nss
//:://////////////////////////////////////////////
/*
    Gives a +(Charisma Modifier) bonus to all Saving
    Throws for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"

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
    float fDuration = HoursToSeconds(24);
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    if(nBonus > GetCasterLevel(OBJECT_SELF))
        nBonus = GetCasterLevel(OBJECT_SELF);

    int nSpellId = GetSpellId();
    if(GetHasSpellEffect(nSpellId))
    {
        effect eEffect = GetFirstEffect(OBJECT_SELF);
        while(GetIsEffectValid(eEffect))
        {
            if(GetEffectSpellId(eEffect) == nSpellId)
                RemoveEffect(OBJECT_SELF, eEffect);
            eEffect = GetNextEffect(OBJECT_SELF);
        }
    }

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    int nSaveType = SAVING_THROW_FORT;
    if(GetFortitudeSavingThrow(OBJECT_SELF) > GetReflexSavingThrow(OBJECT_SELF) &&
       GetWillSavingThrow(OBJECT_SELF) > GetReflexSavingThrow(OBJECT_SELF))
        nSaveType = SAVING_THROW_REFLEX;
    if(GetFortitudeSavingThrow(OBJECT_SELF) > GetWillSavingThrow(OBJECT_SELF) &&
       GetReflexSavingThrow(OBJECT_SELF) > GetWillSavingThrow(OBJECT_SELF))
        nSaveType = SAVING_THROW_WILL;

    effect eSave = EffectSavingThrowIncrease(nSaveType, nBonus, SAVING_THROW_TYPE_ALL);
    effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_DARKONESLUCK);
    effect eLink = EffectLinkEffects(eSave, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
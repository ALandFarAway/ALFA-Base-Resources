//::///////////////////////////////////////////////
//:: Aid
//:: NW_S0_Aid.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature gains +1 to attack rolls and
    saves vs fear. Also gain +1d8 +1/lvl temporary HP.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 6, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// (Updated JLR - OEI 07/05/05 NWN2 3.5)
// (Updated JLR - OEI 08/01/05 NWN2 3.5 -- Metamagic cleanup)
// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nBonus = d8(1);

    //Enter Metamagic conditions
    nBonus = ApplyMetamagicVariableMods(nBonus, 8);

	// EDIT [Ryan Young, 1/15/2007]: capped the level at 10.
    if( nCasterLvl >= 10 )
    {
        nBonus = nBonus + 10;
    }
    else
    {
        nBonus = nBonus + nCasterLvl;
    }

    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eHP = EffectTemporaryHitpoints(nBonus);

    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AID);
    object oTarget = GetSpellTargetObject();
    
    //Does not stack with Mass Aid
    if (GetHasSpellEffect(1052, oTarget))
    {
        return;
    }

    effect eLink = EffectLinkEffects(eAttack, eSave);
	eLink = EffectLinkEffects(eLink, eVis);
	//eLink = EffectLinkEffects(eLink, eHP);

    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_AID));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eHP = EffectLinkEffects(eHP, eOnDispell);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eHP, oTarget, fDuration);
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
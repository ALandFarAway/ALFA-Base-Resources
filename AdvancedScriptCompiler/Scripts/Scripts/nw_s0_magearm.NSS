//::///////////////////////////////////////////////
//:: Mage Armor
//:: [NW_S0_MageArm.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the target +4 AC. (Updated JLR - OEI 07/05/05 NWN2 3.5)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
// BDF - OEI: 10/16/06 - added defense against stacking with Improved Mage Armor
#include "nwn2_inc_spells"


#include "nw_i0_spells"
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
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(GetCasterLevel(OBJECT_SELF));

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR, FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


    //Set the armor bonuses
    effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_MAGE_ARMOR);
    effect eLink = EffectLinkEffects(eAC, eDur);

    //RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);
    //RemoveEffectsFromSpell(oTarget, SPELL_IMPROVED_MAGE_ARMOR);	// 10/16/06 - BDF
    //RemovePermanencySpells(oTarget);

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
//::///////////////////////////////////////////////
//:: Improved Mage Armor
//:: [NW_S0_ImpMagArm.nss]
//:://////////////////////////////////////////////
/*
    Gives the target +3 +1/per 2 caster lvls AC.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/


// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - OEI: 10/16/06 - added defense against stacking with Mage Armor
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
    //effect eVis = EffectVisualEffect(VFX_DUR_SPELL_MAGE_ARMOR);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Set the unique armor bonus

    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nBonus;
//    if ( nCasterLvl < 10 )   { nBonus = 3 + ( nCasterLvl / 2 ); }
//    else                     { nBonus = 6; }
    nBonus = 6;
    effect eAC = EffectACIncrease(nBonus, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGE_ARMOR );
    effect eLink = EffectLinkEffects(eAC, eDur);

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);	// 10/16/06 - BDF

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
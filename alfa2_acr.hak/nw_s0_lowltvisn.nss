//::///////////////////////////////////////////////
//:: [Low Light Vision]
//:: [NW_S0_LowLtVisn.nss]
//:://////////////////////////////////////////////
/*
    Applies the low-light vision effect to the target for
    1 hour per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 12, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_pchide_i"


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    //Apply the Spell
    object oHide = ACR_GetPCHide(oTarget);

    if (oHide == OBJECT_INVALID)
	    return;

    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusFeat(IP_CONST_FEAT_LOWLIGHTVISION), oHide, fDuration);
    AssignCommand(oTarget, DelayCommand(2.0f, SetActionMode(oTarget, ACTION_MODE_DARKVISION, 1)));
}

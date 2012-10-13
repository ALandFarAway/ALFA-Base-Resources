//::///////////////////////////////////////////////
//:: [Barkskin]
//:: [NW_S0_BarkSkin.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Enhances the casters Natural AC by an amount
   dependant on the caster's level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 21, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - 6/20/06: revised to work with NWN2 visual effects

// Modified by Riotnrrd for ALFA 1/7/2009
// Correctly calculates value of bonus

// Modified by Ronan for ALFA 2011-06-14
// Removed VFX

#include "nwn2_inc_metmag"
#include "x2_inc_spellhook"
#include "acr_spells_i" 

void main()
{
    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nBonus;
    float fDuration = HoursToSeconds(nCasterLevel);

    effect eMove;

    //Signal spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BARKSKIN, FALSE));

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    eMove = EffectMovementSpeedIncrease(10);

    ApplyEffectToObject(nDurType, eMove, oTarget, fDuration);
}
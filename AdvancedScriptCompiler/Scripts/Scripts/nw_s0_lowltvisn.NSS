//::///////////////////////////////////////////////
//:: [Low Light Vision]
//:: [NW_S0_LowLtVisn.nss]
//:://////////////////////////////////////////////
/*
    All "party-members" gain Low-Light Vision (as
    the Elf Racial ability).
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
#include "ginc_henchman"


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

    // First, affect Caster...
    int nHenchmen = GetNumHenchmen(oTarget);
    int nCurHenchman = 0;

    // Now process all target critters, starting with the Caster
    while ( GetIsObjectValid(oTarget) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        //effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_LOWLIGHT_VISION );
        effect eSight = EffectLowLightVision();
        effect eLink = EffectLinkEffects(eDur, eSight);
        //eLink = EffectLinkEffects(eLink, eDur);

        //Apply the VFX impact and effects
        ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);

        // Now prep to do the next critter in the list...
        if ( nCurHenchman < nHenchmen )
        {
            oTarget = GetHenchman( OBJECT_SELF, nCurHenchman );
            nCurHenchman++;
        }
        else
        {
            oTarget = OBJECT_INVALID;
        }
    }
}
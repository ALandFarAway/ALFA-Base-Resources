//::///////////////////////////////////////////////
//:: See Invisibility
//:: NW_S0_SeeInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the mage to see creatures that are
    invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
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
    object oTarget = GetSpellTargetObject();
	//effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SEE_INVISIBILITY );
    effect eSight = EffectSeeInvisible();
    effect eLink = EffectLinkEffects(eDur, eSight);
    //eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SEE_INVISIBILITY, FALSE));

    float fDuration = TurnsToSeconds(GetCasterLevel(OBJECT_SELF) * 10 * 10);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    RemovePermanencySpells(oTarget);

    //Apply the VFX impact and effects
	ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
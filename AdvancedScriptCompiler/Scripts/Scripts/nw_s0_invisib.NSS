//::///////////////////////////////////////////////
//:: Invisibility
//:: NW_S0_Invisib.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature becomes invisibility
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// JLR - OEI 08/24/05 -- Metamagic changes
// PKM-OEI 08.09.06 -- VFX update
//:: AFW-OEI 08/03/2007: Account for Assassins.

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
    
	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); //NWN1 VFX

    //effect eLink = EffectLinkEffects(eInvis, eDur);
    //eLink = EffectLinkEffects(eLink, eVis);
	effect eLink = EffectLinkEffects( eInvis, eVis );

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

	int nDuration = GetCasterLevel(OBJECT_SELF);
	if (GetSpellId() == SPELLABILITY_AS_INVISIBILITY)
	{	// Duration is equal to Assassin level for Assassins.
		nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	}
	
    float fDuration = TurnsToSeconds(nDuration);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
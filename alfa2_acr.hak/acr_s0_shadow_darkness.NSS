//::///////////////////////////////////////////////
//:: Shadow Darkness
//:: acr_s0_Shadow_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 7/14/06 If cast on an object, signal the object cast on (needed for crafting)
//:: AFW-OEI 08/03/2007: Account for Assassins.

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "acr_spells_i"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!ACR_PrecastEvent())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS,  "acr_s0_shadow_darknessa", "acr_s0_shadow_darknessb");
    object oTarget = GetSpellTargetObject();
	if (GetIsObjectValid(oTarget))
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
	
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF);
	
	if (GetSpellId() == SPELLABILITY_AS_DARKNESS)
	{	// Duration is equal to Assassin level for Assassins.
		nDuration = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	}
	
	int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
}
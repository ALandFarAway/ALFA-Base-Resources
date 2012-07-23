//::///////////////////////////////////////////////
//:: Shadow Grease
//:: acr_S0_Shadow_Grease.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creatures entering the zone of grease must make
    a reflex save or fall down.  Those that make
    their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
// Modified by NESchampion 3 November 2011

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
    effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE, "acr_s0_shadow_greasea", "acr_s0_shadow_greaseb", "acr_s0_shadow_greasec");
	location lTarget = GetSpellTargetLocation();	
    //int nDuration = 2 + GetCasterLevel(OBJECT_SELF) / 3;
	int nDuration = GetCasterLevel(OBJECT_SELF);	// AFW-OEI 04/16/2007: Change duration to 1 round/level.
    int nMetaMagic = GetMetaMagicFeat();

	    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
}
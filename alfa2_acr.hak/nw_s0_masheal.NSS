//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2005 Obisidian Entertainment
//:://////////////////////////////////////////////
/*
	Mass Heal
	
	This acts like the Heal spell except it heals 
	multiple targets.
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz - OEI
//:: Created On: 10/06/05
//:://////////////////////////////////////////////
// ChazM 5/15/07 - modified CureObject()
// ChazM 6/7/07 - fixed, renamed and moved funcs to nwn2_inc_spells - HealHarm*()

//#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook"
#include "acr_spells_i" 
#include "nwn2_inc_spells"

void main()
{

    if (!ACR_PrecastEvent())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int 	nCasterLvl 	= GetCasterLevel(OBJECT_SELF);
    effect	eVis 		= EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect 	eVis2	 	= EffectVisualEffect(VFX_IMP_HEALING_M);
    effect 	eImpact 	= EffectVisualEffect(VFX_FNF_LOS_HOLY_20);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());    

	int nMaxToCure = nCasterLvl;
	int nCuredInFaction = HealHarmFaction( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	HealHarmNearby( nMaxToCure, eVis, eVis2, nCasterLvl, GetSpellId() );
}
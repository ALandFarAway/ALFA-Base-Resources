//::///////////////////////////////////////////////
//:: ginc_nx1spells.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
	 Include file for nx1 spells
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.13.06
//:://////////////////////////////////////////////
// ChazM 1/2/07 Added Placeholder effect for EffectFatigue()
// ChazM 1/8/07 removed EffectFatigue(), changed includes

#include "nwn2_inc_spells"
//#include "nwn2_inc_metmag"
//void main(){}

//creeping cold function
void EffectCreepingCold(int nNumDice, int nSave, object oTarget, int nMetaMagic)
{
	int		nDam 	= 	d6(nNumDice);
			//nDam	= 	ApplyMetamagicVariableMods(nDam, nNumDice * 6);

        //Resolve metamagic properly
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDam = nNumDice * 6;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDam = nDam + (nDam/2);
        }
						
	//Reduce damage based on fort save?
	if (nSave == 1)
	{
		nDam = nDam/2;
	}
					
	effect	eDam 	=	EffectDamage(nDam, DAMAGE_TYPE_COLD);
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_ICE);
	effect	eLink	=	EffectLinkEffects(eDam, eVis);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}

/*
effect EffectFatigue()
{
	//what will this do???  it is a mystery
	
	// placeholder effect
	effect	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_ICE);
	return (eVis);
}
*/

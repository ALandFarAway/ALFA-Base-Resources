//::///////////////////////////////////////////////
//:: Summon Planetar
//:: nx_s2_summon_planetar.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Just like Summon Creature IX, but summons a
	planetar.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/22/2007
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	effect eSummon = EffectSummonCreature("c_planetar", VFX_FNF_SUMMON_MONSTER_3);
	//SpeakString("Moo!  I am a planetar.  Or a placeholder creature template.  Take your pick.");
	
    //Check for metamagic extend
	int nDuration = GetHitDice(OBJECT_SELF) + 3;
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
	
    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
}
//::///////////////////////////////////////////////
//:: x0_s0_entEN
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies a miss chance to any enemies
    of the area of effect creator.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_spells"

void main()
{
    object oTarget = GetEnteringObject();
	//if(!GetIsReactionTypeFriendly(oTarget, GetAreaOfEffectCreator()))
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
        effect eMiss = EffectMissChance(20, MISS_CHANCE_TYPE_VS_RANGED);
        
        // * only leaving the area of effect removes the miss chance
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMiss, oTarget);
    }
}
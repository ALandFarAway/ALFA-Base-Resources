//::///////////////////////////////////////////////
//:: Shadow Evocation
//:: acr_S0_ShadowEvoc
//:: Copyright (c) 2011 NESchampion
//:://////////////////////////////////////////////
/*
    You tap energy from the Plane of Shadow to cast 
	a quasi-real, illusory version of a sorcerer or 
	wizard evocation spell of 4th level or lower.
*/
//:://////////////////////////////////////////////
//:: Created By: NESchampion
//:: Created On: 10 November 2011
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"

void main()
{
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCast;
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLevel);
	float fSummonDuration = RoundsToSeconds(nCasterLevel + 3);
    effect eVis;

    fDuration = ApplyMetamagicDurationMods(fDuration);
	fSummonDuration = ApplyMetamagicDurationMods(fSummonDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
}
//::///////////////////////////////////////////////
//:: Shadow Simulacrum
//:: nx_s0_shadow_simulacrum.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Illusion (Shadow)
	Level: Sor/Wiz 9
	Components: V, S
	Range: Touch
	Effect: One duplicate creature
	Duration: 1 round / caster level
	Saving Throw: None
	Spell Resistance: No 
	 
	Shadow Simulacrum reaches into the plane of
	shadow and creates a shadow duplicate of the
	creature touched by the caster. This shadow
	creature retains all the abilities of the
	original, but is created with only 3/4th the
	current hit points of the original and all
	memorized spells are lost.  Moreover, the
	simulacrum gains 20% concealment and immunity
	to negative energy damage.  Creatures with more
	than double the caster's level in hit dice are
	immune to this spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/11/2007
//:://////////////////////////////////////////////
// MDiekmann 6/13/07 - Added SignalEvent
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	object oTarget = GetSpellTargetObject();
	object oCaster = OBJECT_SELF;
	int nTargetHD = GetHitDice(oTarget);
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	
	//FIX: double, not half
	//if ((2 * nTargetHD) > nCasterLevel)
	if (nTargetHD > (2 * nCasterLevel))
	{	// It the target has more than double the caster's level, the target is immune.
		return;
	}
	
	string sTag = GetTag(oTarget);
	string sNewTag = IntToString(ObjectToInt(OBJECT_SELF)) + "_" + sTag;	// Create "unique" tag
	int nNewHP = (GetCurrentHitPoints(oTarget)*3)/4;	// Copy has 3/4 the HP of the target
    effect eSummon = EffectSummonCopy(oTarget, VFX_FNF_SUMMON_UNDEAD, 0.0f, sNewTag, nNewHP, "nx_s0_shadow_sim_buff");

    //Check for metamagic extend
    int nDuration = nCasterLevel;
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;	//Duration is +100%
    }
	
    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDuration));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
}
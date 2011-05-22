//::///////////////////////////////////////////////
//:: Summon Tanarri
//:: NW_S0_SummSlaad
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Quasit to aid the threatened Demon
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 05/31/2006:
//::	Updated creature blueprint
//::	Changed duration to 10 minutes

void main()
{
    //Declare major variables
    effect eSummon = EffectSummonCreature("c_summ_succubus",VFX_FNF_SUMMON_MONSTER_3);
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Apply the VFX impact and summon effect
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), 600.0f);
}
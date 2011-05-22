//::///////////////////////////////////////////////
//:: Summon Mephit
//:: NW_S1_SummMeph
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a Steam Mephit
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 14, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//::	Updated creature blueprint
//::	Changed duration to 10 minutes

void main()
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    effect eSummon = EffectSummonCreature("c_firemephit",VFX_FNF_SUMMON_MONSTER_1);
   // effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //Apply the VFX impact and summon effect
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), 600.0f);
}
//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: x2_s1_summbaatez
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an Erinyes to aid the caster in combat
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-24
//:://////////////////////////////////////////////
//:: AFW-OEI 05/31/2006:
//::	Update creature blueprints.
//::	Change duration to 10 minutes.

void main()
{
    effect eSummon = EffectSummonCreature("c_erinyes",VFX_FNF_SUMMON_MONSTER_3);
    //Summon
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), 600.0f);
}
//::///////////////////////////////////////////////
//:: x0_s2_blkdead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Level 3 - 6:  Summons Ghast
    Level 7 - 10: Doom Knight
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Updated creature blueprints.
//::	Change duration to 24 hours.
//:: PKM-OEI 08.30.06
//:: 	made work
//::	no more mummies

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    effect eSummon;
    float fDelay = 3.0;
    //int nDuration = nLevel;
    if (nLevel >= 7)
	{
        eSummon = EffectSummonCreature("c_skeleton9",VFX_FNF_SUMMON_UNDEAD);
	}
    else
	{
     	eSummon = EffectSummonCreature("c_skeleton7",VFX_FNF_SUMMON_UNDEAD);
	}
//The blackguard should never be able to summon a mummy.
//	else
//	{
//	   	eSummon = EffectSummonCreature("c_mummy",VFX_FNF_SUMMON_UNDEAD);
//	}

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));
    
}
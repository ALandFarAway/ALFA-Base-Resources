//::///////////////////////////////////////////////
//:: x0_s2_fiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Summons the 'fiendish' servant for the player.
This is a modified version of Planar Binding


At Level 5 the Blackguard gets a Succubus

At Level 9 the Blackguard will get a Vrock

Will remain for one hour per level of blackguard
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: April 2003
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Update creature blueprints
//::	Change duration to 24 hours
//::	Remove epic stuff

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, OBJECT_SELF);
    effect eSummon;
    float fDelay = 3.0;
    //int nDuration = nLevel;

    if (nLevel <= 7)
    {
        eSummon = EffectSummonCreature("c_fiendrat7",VFX_FNF_SUMMON_GATE, fDelay);
    }
    else if (nLevel <= 10 )
    {
        eSummon = EffectSummonCreature("c_fiendrat9", VFX_FNF_SUMMON_GATE, fDelay);
    }
	/*
    else
    {
       if (GetHasFeat(1003,OBJECT_SELF)) // epic fiend feat
       {
           eSummon = EffectSummonCreature("x2_s_vrock", VFX_FNF_SUMMON_GATE, fDelay);
       }
       else
       {
        eSummon = EffectSummonCreature("NW_S_VROCK", VFX_FNF_SUMMON_GATE, fDelay);
       }
    }
	*/

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(24));

}
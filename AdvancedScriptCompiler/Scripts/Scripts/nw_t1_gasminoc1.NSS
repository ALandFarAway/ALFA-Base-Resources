//::///////////////////////////////////////////////
//:: Gas Trap
//:: NW_T1_GasMinC1.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a  5m poison radius gas cloud that
    lasts for 2 rounds and poisons all creatures
    entering the area with Giant Wasp Venom
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 12/30/2008:
//::  Patched faction check to support Set Traps skill better
//::  Not a heartbeat script -> while loop removed

#include "nw_i0_spells"

void main()
{
    object oTarget = GetEnteringObject();
    effect ePoison = EffectPoison(POISON_GIANT_WASP_POISON);

    object oCreator = GetTrapCreator(GetAreaOfEffectCreator());
    if (oCreator == OBJECT_INVALID)
    {
        oCreator = OBJECT_SELF; //pre-placed traps have no creator
    }

    //oTarget = GetFirstInPersistentObject();
    //while(GetIsObjectValid(oTarget))
    //{
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
    	{
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget);
        }
    //    oTarget = GetNextInPersistentObject();
    //}

}
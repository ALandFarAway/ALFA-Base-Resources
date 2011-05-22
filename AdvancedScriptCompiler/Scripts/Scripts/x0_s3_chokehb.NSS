//::///////////////////////////////////////////////
//:: x0_s3_chokehb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Heartbeat script for choking powder.
    Every round make a saving throw
    or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
	int nSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
    spellsStinkingCloud(OBJECT_INVALID, nSaveDC); // Area of effect stinking cloud
}
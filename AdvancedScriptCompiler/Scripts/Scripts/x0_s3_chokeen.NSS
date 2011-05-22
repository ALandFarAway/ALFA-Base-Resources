//::///////////////////////////////////////////////
//:: x0_s3_chokeen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Choke effect on entering object
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "x0_i0_spells"

void main()
{
	int nSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
    spellsStinkingCloud(GetEnteringObject(), nSaveDC); // Area of effect stinking cloud
}
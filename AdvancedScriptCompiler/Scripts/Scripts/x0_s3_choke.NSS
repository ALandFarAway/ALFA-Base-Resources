//::///////////////////////////////////////////////
//:: Choking Powder
//:: x0_s3_choke
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a stinking cloud where thrown for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

string GetAOETag()
{
	object oAOE;
	int nCnt = 1;
	string sTag = "";
	string sAOE = "AOE_ChokePowder_";

	sTag = sAOE + IntToString(nCnt);
	oAOE = GetObjectByTag(sTag);
	while (oAOE != OBJECT_INVALID)
	{
		++nCnt;
		sTag = sAOE + IntToString(nCnt);
		oAOE = GetObjectByTag(sTag);
	}

	return sTag;
}

void main()
{
    //Declare major variables
	string sAOETag = GetAOETag();
    effect eAOE = EffectAreaOfEffect(AOE_PER_CHOKE_POWDER, "", "", "", sAOETag);
    location lTarget = GetSpellTargetLocation();
    int nDuration = 5;
	object oItem = GetSpellCastItem();
	string sTag = GetStringLowerCase(GetTag(oItem));
	int nSaveDC;

	if (sTag == "x1_wmgrenade004")
	{
		nSaveDC = 15;
	}
	else if (sTag == "n2_it_chok_2")
	{
		nSaveDC = 17;
	}
	else if (sTag == "n2_it_chok_3")
	{
		nSaveDC = 19;
	}
	else if (sTag == "n2_it_chok_4")
	{
		nSaveDC = 21;
	}

    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	object oAOE = GetObjectByTag(sAOETag);
	SetLocalInt(oAOE, "SaveDC", nSaveDC);
}
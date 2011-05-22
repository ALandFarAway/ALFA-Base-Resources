//::///////////////////////////////////////////////
//:: Holy Water
//:: x0_s3_holy
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
    - If target is valid attempt a hit
       - If miss then MISS
       - If hit then direct damage
    - If target is invalid or MISS
       - have area of effect near target
       - everyone in area takes splash damage
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
void main()
{
	object oItem = GetSpellCastItem();
	string sTag = GetStringLowerCase(GetTag(oItem));
	
	int nDmg = 0;
	int nSplashDmg = 0;
	
	if (sTag == "x1_wmgrenade005")
	{
		nDmg = d4(2);
		nSplashDmg = 1;
	}
	else if (sTag == "n2_it_holy_2")
	{
		nDmg = d6(2);
		nSplashDmg = 2;
	}
	else if (sTag == "n2_it_holy_3")
	{
		nDmg = d8(2);
		nSplashDmg = d4(1);
	}
	else if (sTag == "n2_it_holy_4")
	{
		nDmg = d10(2);
		nSplashDmg = d4(1) + 1;
	}
    DoGrenade(nDmg,nSplashDmg,VFX_HIT_SPELL_HOLY,VFX_HIT_AOE_HOLY,DAMAGE_TYPE_DIVINE,RADIUS_SIZE_MEDIUM,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, RACIAL_TYPE_UNDEAD);


}
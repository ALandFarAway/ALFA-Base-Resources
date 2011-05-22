//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: NX2_SummonBaatezu.NSS
//:://////////////////////////////////////////////
/*
	Summons a random demon to fight at your side.
	c_summon_baatezu_erinyes - 30%
	c_summon_baatezu_pitfiend - 10%
	c_summon_baatezu_mephasm - 25%
	c_summon_baatezu_neeshka - 5%
	c_summon_baatezu_horneddevil - 30%
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR - OEI)
//:: Created On: August 13, 2008
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

////////////////////////////////////////////////
// SelectDemon() - Randomly Selects which demon
// 				   to summon.
////////////////////////////////////////////////
string SelectDemon()
{
	int nRandom = Random(100);
	SpeakString(IntToString(nRandom));
	string sTag;
	
	if (0 <= nRandom && nRandom < 5)
	{
		sTag="c_summon_baatezu_neeshka";
	}	
	if (5 <= nRandom && nRandom < 30)
	{
		sTag = "c_summon_baatezu_mephasm";
	}	
	if (30 <= nRandom && nRandom < 60)
	{
		sTag = "c_summon_baatezu_horneddevil";
	}
	if (60 <= nRandom && nRandom < 70)
	{
		sTag = "c_summon_baatezu_pitfiend";
	}
	if (70 <= nRandom && nRandom < 99)
	{
		sTag = "c_summon_baatezu_erinyes";
	}	
	if (nRandom == 99)
	{
		SpeakString("SQUACK!! CHICKEN ATTACK!");
	}
	SpeakString(sTag);
	return sTag;
}

////////////////////////////////////////////////
// GoHostile() - Does Saving Throw to see if 
// 				 demon goes away or turns.
////////////////////////////////////////////////
void GoHostile(string sTag, int nChar)
{
	int nDie = d20();
	int nCheck = nDie + nChar;
	
	if (nCheck < 10 || nDie == 1)
	{ // fail
		SpeakString(GetName(OBJECT_SELF)+GetStringByStrRef(233589)); // 's devil returns to the Nine Hells.
		location lLocation = GetLocation(OBJECT_SELF);
		CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocation, TRUE);	
	}
	else
	{
		SpeakString(GetName(OBJECT_SELF)+GetStringByStrRef(233588)); // 's devil returns to the Nine Hells.
	}
	
	
}

////////////////////////////////////////////////
// main()
////////////////////////////////////////////////
void main()
{
	if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	// Choose Demon
	string sTag = SelectDemon();
	int nHellfireLevel = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK);
	int nWarlockLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nTotalLevel = nHellfireLevel + nWarlockLevel;
	int nCharBonus = GetAbilityModifier(ABILITY_CHARISMA);
	
	// total rounds
	int nTotalRounds = nTotalLevel + nCharBonus;
	SpeakString("Total Rounds: "+IntToString(nTotalRounds));
	
	effect eSummon = EffectSummonCreature(sTag, VFX_FNF_SUMMON_UNDEAD);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nTotalRounds));
	DelayCommand(RoundsToSeconds(nTotalRounds), GoHostile(sTag, nCharBonus)); 
	
}
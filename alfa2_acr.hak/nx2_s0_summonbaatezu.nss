//::///////////////////////////////////////////////
//:: Summon Baatezu
//:: NX2_SummonBaatezu.NSS
//:://////////////////////////////////////////////
/*
	Summons a random demon to fight at your side.
	c_summon_baatezu_erinyes - 29%
	c_summon_baatezu_pitfiend - 10%
	c_summon_baatezu_mephasm - 25%
	c_summon_baatezu_neeshka - 5%
	c_summon_baatezu_horneddevil - 30%
	c_summon_baatezu_chicken - 1%
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR - OEI)
//:: Created On: August 13, 2008
//:: Modified On: September 04, 2008
//:: 10.10.08 - JWR - Added EffectDamage() so that
//:: devil has the same HP when he turns on you as when
//:: he was friendly
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

////////////////////////////////////////////////
// SelectDemon() - Randomly Selects which demon
// 				   to summon.
////////////////////////////////////////////////
string SelectDemon()
{
	int nRandom = Random(100);
	//SpeakString(IntToString(nRandom));
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
		sTag = "c_summon_baatezu_chicken";
	}
	return sTag;
}

////////////////////////////////////////////////
// IsDevilStillActive(oDevil) -hack hack hack
////////////////////////////////////////////////
int IsDevilStillActive(object oDevil)
{
	if (oDevil == OBJECT_INVALID)
		return FALSE;
	object oTest = GetFirstObjectInArea();	
	while(GetIsObjectValid(oTest))
	{
		if (oTest == oDevil)
		{
			return TRUE;
		}
		oTest = GetNextObjectInArea();
	}	
	return FALSE;
}

////////////////////////////////////////////////
// GetDevilObject() -hack hack hack
////////////////////////////////////////////////
object GetDevilObject(string sTag)
{
	int i = 0;
	object oTest = GetObjectByTag(sTag, i);
	while (GetIsObjectValid(oTest))
	{
		//Debug(oTest);
		if (GetMaster(oTest) == OBJECT_SELF)
		{
			return oTest;
		}
		++i;
		oTest = GetObjectByTag(sTag, i);	
	}
	return OBJECT_INVALID;	
}
////////////////////////////////////////////////
// UhOh() - You be dead, now, warlock!
////////////////////////////////////////////////
void UhOh(string sTag, object oDevil, int nDamage)
{
	location lLocation = GetLocation(OBJECT_SELF);
	string sNewTag = sTag + IntToString(Random(100)); // Just in case!
	string sDisp = GetName(oDevil)+ " " + GetStringByStrRef(233589);
	FloatingTextStringOnCreature(sDisp, OBJECT_SELF); // turns on the party.
	object oBadDevil = CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocation, TRUE, sNewTag);	
	effect eDam = EffectDamage(nDamage);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oBadDevil);
	
}

////////////////////////////////////////////////
// CheckArea() - logic to see if 
// 				 the area is ok to go hostile
// make sure the devil doesn't respawn someplace
// like a city where the NPC's will freak out.
////////////////////////////////////////////////
int CheckArea(object oDevil)
{
	// make sure devil is still alive!
	if (!IsDevilStillActive(oDevil))
		return 0;	
	// make sure we're not on the overland map :D
	if (GetIsOverlandMap(GetArea(oDevil)))
		return 0;
	// make sure we're in a hostile area!
	object oObject = GetFirstObjectInArea();
	while (GetIsObjectValid(oObject))
	{
		if (GetIsReactionTypeHostile(oObject))
		{
			//FloatingTextStringOnCreature("Hostile!: "+GetName(oObject), OBJECT_SELF);
			if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
				return 1;
		}
		oObject = GetNextObjectInArea();
	}	
	return 0;
}

////////////////////////////////////////////////
// CheckHostile() - logic to see if 
// 				 demon goes away or turns.
////////////////////////////////////////////////
void CheckHostile(object oDevil)
{
	if (CheckArea(oDevil) == 0)
		return;
		
	string sTag = GetTag(oDevil);
	int nCurrHP = GetCurrentHitPoints(oDevil);
	int nTotalHP = GetMaxHitPoints(oDevil);
	int nDiffHP = nTotalHP - nCurrHP;
	// these two never turn on you.
	if ( (sTag == "c_summon_baatezu_neeshka" || sTag == "c_summon_baatezu_mephasm") )
	{
		
		FloatingTextStringOnCreature(GetName(oDevil)+ " " + GetStringByStrRef(233588), OBJECT_SELF); // returns to the nine hells.
			
	}
	else  // uh-oh! Should have unsummoned the big devil! EPIC FAIL!
	{
		UhOh(sTag, oDevil, nDiffHP);
	}
}

////////////////////////////////////////////////
// CalcRounds() - how long do we get the devil for
////////////////////////////////////////////////
int CalcRounds(int nHellfireLevel, int nCharBonus)
{
	// minimum rounds
	int nMin = nHellfireLevel + nCharBonus; 
	// maximum rounds
	int nMax = nMin + d8();
	
	int nRounds = Random(nMax);
	nRounds += nMin;
	if ( nRounds > nMax )
		nRounds = nMax;
	
	return nRounds;
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
	// Get Variables
	int nHellfireLevel = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK);
	int nCharBonus = GetAbilityModifier(ABILITY_CHARISMA);
	// calculate rounds
	int nTotalRounds = CalcRounds(nHellfireLevel, nCharBonus);
	float nSeconds = RoundsToSeconds(nTotalRounds);
	// Choose Demon
	string sTag = SelectDemon();
	
	// Summon the Creature
	effect eSummon = EffectSummonCreature(sTag, VFX_FNF_SUMMON_UNDEAD);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), nSeconds);
	
	// Grab ahold of the Devil's Object ID
	object oDevil = GetDevilObject(sTag);
	
	// Delay the CheckHostile command until the "friendly" despawns.
	DelayCommand(nSeconds, CheckHostile(oDevil)); 
	
}

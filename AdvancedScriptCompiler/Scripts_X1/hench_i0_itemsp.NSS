/*

    Companion and Monster AI

    This file contains routines used for casting spells, using feats, items (potions,
    scrolls, and rods by companions and monsters. Several options are tried and the highest
    weighted options is what is finally cast.

    Also deals with creatures with a negative effect on them that
    impacts spellcasting (silence, primary ability drain)

*/


#include "hench_i0_generic"
#include "hench_i0_equip"
#include "hench_i0_spells"
#include "hench_i0_heal"
#include "hench_i0_attack"
#include "hench_i0_buff"
#include "hench_i0_dispel"

const int HENCH_ITEM_TYPE_NONE      = 0;
const int HENCH_ITEM_TYPE_OTHER     = 1;
const int HENCH_ITEM_TYPE_POTION    = 2;

const int HENCH_TALENT_USE_SPELLS_ONLY = 3;
const int HENCH_TALENT_USE_ABILITIES_ONLY = 5;
const int HENCH_TALENT_USE_ITEMS_ONLY = 6;


// checks if spell has already been tested
int HasItemTalentSpell(int spellID);

// add spell to list that has already been tested
void AddItemTalentSpell(int spellID);

// dispatches the spell to the correct handling routine (buff, attack, protection, etc.)
// nItemType is HENCH_ITEM_TYPE_*
void DispatchSpell(int nItemType);

// most standard spells are sent into this function
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchTalentSpellDispatch(talent tTalent, int nSpellID, int spellIDInfo, int nItemType, int bIsSubSpell, int nSpellLevel);

// most feats are sent into this function
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchFeatDispatch(int nFeatID, int nSpellID, int bUseCheatCast);

// spontaneously cast spells sent to this function (cure, inflict, summons, and possibly others)
// fills in fields of gsCurrentspInfo and calls DispatchSpell
void HenchSpontaneousDispatch(int nSpellID);

// tries to find all talents for a particular talent type in a category
int FindItemSpellTalentsByCategory(int nCategory, int maximumToFind, int talentExclude, int nItemType);

// checks and casts spontaneous cure or inflict spells, returns TRUE if one already found or cast
int CheckSpontaneousCureOrInflictSpell(int nSpellID);

// checks and casts spontaneous mass cure or inflict spells, returns TRUE if one already found or cast
int CheckSpontaneousMassCureOrInflictSpell(int nSpellID);

// tries to find all talents for a category, cycles allowed talent types and calls FindItemSpellTalentsByCategory
void InitializeSpellTalentCategory(int nCategory);

// tries to find all talents for a category except items, cycles allowed talent types and calls FindItemSpellTalentsByCategory
void InitializeSpellTalentCategoryNoItems(int nCategory);

// find spell talents for all categories
void InitializeSpellTalents();

// Return TRUE if oObject is affected by an Inspire Bard Song
int HenchGetHasInspireBardSongSpellEffect(object oObject=OBJECT_SELF);

// Test all feats than can be used
void InitializeFeats();

// test various spell shapes for the warlock spell
void InitializeWarlockAttackSpell(int nSpellID, int nSpellLevel);

// test various warlock essences, then call InitializeWarlockAttackSpell to test shapes
void InitializeWarlockAttackSpells();

// gets spell casting information from a class position (class, level, primary ability, etc.)
int InitializeClassByPosition(int iPosition);

// gets spell casting information (class, level, primary ability, etc.)
int InitializeSpellCasting();

// test various spells, feats, etc. calling the correct dispatch function
void InitializeItemSpells(int nClass, int negativeEffects, int positiveEffects);

// decrement spell for spontaneous spell cast, tries various means to decrement
void HenchDecrementSpontaneousSpell(int nSpellID);

// cast a given spell given the sSpellInformation structure
void HenchCastSpell(struct sSpellInformation spInfo);

// determine what if any spell, feat, etc. should be cast, used, etc.
int HenchCheckSpellToCast(int currentRound, int bTestOnly = FALSE);

// determine persistent area of effect spells that could cause problems
int CheckAOEForSelf(int currentNegEffects, int currentPosEffects);


int bgDisablingEffect;      // disabling effect for spells

// void main() {  InitializeItemSpells(0, 0, 0);  }


int itemTalentSpellCount;
const int maxItemTalentSpellCount = 10;
int itemSpellID1, itemSpellID2, itemSpellID3, itemSpellID4, itemSpellID5,
        itemSpellID6, itemSpellID7, itemSpellID8, itemSpellID9, itemSpellID10;

int HasItemTalentSpell(int spellID)
{
    if (itemTalentSpellCount < 1)
    {
        return FALSE;
    }
    if (spellID == itemSpellID1)
    {
        return 1;
    }
    if (itemTalentSpellCount < 2)
    {
        return FALSE;
    }
    if (spellID == itemSpellID2)
    {
        return 2;
    }
    if (itemTalentSpellCount < 3)
    {
        return FALSE;
    }
    if (spellID == itemSpellID3)
    {
        return 3;
    }
    if (itemTalentSpellCount < 4)
    {
        return FALSE;
    }
    if (spellID == itemSpellID4)
    {
        return 4;
    }
    if (itemTalentSpellCount < 5)
    {
        return FALSE;
    }
    if (spellID == itemSpellID5)
    {
        return 5;
    }
    if (itemTalentSpellCount < 6)
    {
        return FALSE;
    }
    if (spellID == itemSpellID6)
    {
        return 6;
    }
    if (itemTalentSpellCount < 7)
    {
        return FALSE;
    }
    if (spellID == itemSpellID7)
    {
        return 7;
    }
    if (itemTalentSpellCount < 8)
    {
        return FALSE;
    }
    if (spellID == itemSpellID8)
    {
        return 8;
    }
    if (itemTalentSpellCount < 9)
    {
        return FALSE;
    }
    if (spellID == itemSpellID9)
    {
        return 9;
    }
    if (itemTalentSpellCount < 10)
    {
        return FALSE;
    }
    if (spellID == itemSpellID10)
    {
        return 10;
    }
    return TRUE;
}


void AddItemTalentSpell(int spellID)
{
    if (itemTalentSpellCount >= maxItemTalentSpellCount)
    {
        return;
    }
    itemTalentSpellCount ++;

    if (itemTalentSpellCount == 1)
    {
        itemSpellID1 = spellID;
        return;
    }
    if (itemTalentSpellCount == 2)
    {
        itemSpellID2 = spellID;
        return;
    }
    if (itemTalentSpellCount == 3)
    {
        itemSpellID3 = spellID;
        return;
    }
    if (itemTalentSpellCount == 4)
    {
        itemSpellID4 = spellID;
        return;
    }
    if (itemTalentSpellCount == 5)
    {
        itemSpellID5 = spellID;
        return;
    }
    if (itemTalentSpellCount == 6)
    {
        itemSpellID6 = spellID;
        return;
    }
    if (itemTalentSpellCount == 7)
    {
        itemSpellID7 = spellID;
        return;
    }
    if (itemTalentSpellCount == 8)
    {
        itemSpellID8 = spellID;
        return;
    }
    if (itemTalentSpellCount == 9)
    {
        itemSpellID9 = spellID;
        return;
    }
    if (itemTalentSpellCount == 10)
    {
        itemSpellID10 = spellID;
        return;
    }
}


void DispatchSpell(int nItemType)
{
    int targetInformation = GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_TARGET_COLUMN_NAME);
    gsCurrentspInfo.shape = targetInformation & HENCH_SPELL_TARGET_SHAPE_MASK;
    switch (targetInformation & HENCH_SPELL_TARGET_RANGE_MASK)
    {
    case HENCH_SPELL_TARGET_RANGE_PERSONAL:
        gsCurrentspInfo.range = 0.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_TOUCH:
        gsCurrentspInfo.range = 4.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_SHORT:
        gsCurrentspInfo.range = 8.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_MEDIUM:
        gsCurrentspInfo.range = 20.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_LONG:
        gsCurrentspInfo.range = 40.0;
        break;
    case HENCH_SPELL_TARGET_RANGE_INFINITE:
        gsCurrentspInfo.range = 300.0;
        break;
    }
    if (nItemType)
    {
        gsCurrentspInfo.spellInfo |= HENCH_SPELL_INFO_ITEM_FLAG;
        if (nItemType == HENCH_ITEM_TYPE_POTION)
        {
            gsCurrentspInfo.range = 0.0;
        }
        else
        {
                // wands, etc. don't have AoO
            gsCurrentspInfo.spellInfo &= HENCH_SPELL_INFO_REMOVE_CONCENTRATION_FLAG;
        }
    }
    gsCurrentspInfo.radius = IntToFloat((targetInformation & HENCH_SPELL_TARGET_RADIUS_MASK) >> 6) / 10.0;

//	Jug_Debug(GetName(OBJECT_SELF) + " spell type " + IntToHexString(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK));
//	Jug_Debug(GetName(OBJECT_SELF) + " dispatching spell " + IntToString(gsCurrentspInfo.spellID) + " " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " other "  + IntToString(gsCurrentspInfo.otherID));

    int spellType = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK;
    if (!(gsCurrentspInfo.spellInfo & gbSpellInfoCastMask))
    {
        return;
    }

    switch (spellType)
    {
    case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK:
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
    case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
        HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_BUFF:
        HenchCheckBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF:
        HenchCheckACBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF:
        HenchCheckDRBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PERSISTENTAREA:
        // just activate with quick cast if not present
        if(!GetHasSpellEffect(gsCurrentspInfo.spellID))
        {
            ActionCastSpellAtObject(gsCurrentspInfo.spellID, OBJECT_SELF, METAMAGIC_ANY, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH:
        if (!GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH))
        {
            HenchCheckPolymorph();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
        HenchCheckDispel();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE:
        if (gbCheckInvisbility)
        {
            HenchCheckInvisibility();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION:
        HenchCheckCureCondition();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
        if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)) && !GetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS))
        {
            HenchCheckSummons();
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF:
        HenchCheckAttrBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT:
        HenchCheckEnergyProt();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK:
        GetMeleeAttackInfo();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ARCANE_ARCHER:
        {
            int itemType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
            if ((itemType == BASE_ITEM_LONGBOW) || (itemType == BASE_ITEM_SHORTBOW))
            {
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT:
        HenchCheckSpellProtections();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
        {
            int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
            int lastDragonBreath = GetLocalInt(OBJECT_SELF, henchLastDraBrStr);
            if (lastDragonBreath == 0 || lastDragonBreath < combatRoundCount - 2)
            {
                // breath is unlimited
                gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
				gsCurrentspInfo.otherID = METAMAGIC_NONE;
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS:
        HenchCheckDetectInvisibility();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
        if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED)))
        {
            int lastDominate = GetLocalInt(OBJECT_SELF, henchLastDomStr);
            int combatRoundCount = GetLocalInt(OBJECT_SELF, henchCombatRoundStr);
            if (lastDominate == 0 && lastDominate >= combatRoundCount - 7)
            {
                HenchSpellAttack(GetCurrentSpellSaveType(), targetInformation);
            }
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF:
        HenchCheckWeaponBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_BUFF_ANIMAL_COMP:
        HenchCheckAnimalCompanionBuff();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PROT_EVIL:
        HenchCheckProtEvil();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_PROT_GOOD:
        HenchCheckProtGood();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
        HenchCheckRegeneration();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_GUST_OF_WIND:
        gsGustOfWind = gsCurrentspInfo;
// TODO MotB disabled for now, check friendly AoEs HenchSpellAttack(GetCurrentSpellSaveType());
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_ELEMENTAL_SHIELD:
        HenchCheckElementalShield();
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
        HenchCheckTurnUndead();
        break;
    case HENCH_SPELL_INFO_TYPE_MELEE_ATTACK_BUFF:
        HenchMeleeAttackBuff();
        break;
    case HENCH_SPELL_INFO_TYPE_RAISE_DEAD:
        HenchRaiseDead();
        break;
    case HENCH_SPELL_INFO_TYPE_CONCEALMENT:
        HenchConcealment();
        break;
    case HENCH_SPELL_INFO_TYPE_ATTACK_SPECIAL:
        HenchSpellAttackSpecial();
		break;
    case HENCH_SPELL_INFO_TYPE_HEAL_SPECIAL:
		HenchCheckHealSpecial();
		break;
    }
}


void HenchTalentSpellDispatch(talent tTalent, int nSpellID, int spellIDInfo, int nItemType, int bIsSubSpell, int nSpellLevel)
{
//	Jug_Debug(GetName(OBJECT_SELF) + " found spell " + IntToString(nSpellID) + " level " + IntToString(nSpellLevel));
//  Jug_Debug(GetName(OBJECT_SELF) + " spell info " + IntToHexString(spellIDInfo));

    if ((spellIDInfo == 0) || (spellIDInfo & HENCH_SPELL_INFO_IGNORE_FLAG))
    {
        return;
    }
    if (spellIDInfo & HENCH_SPELL_INFO_MASTER_FLAG)
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " running sub spell code");
        if (nItemType)
        {
            // not supported for now
            return;
        }
        int currentIndex = 1;
        int spellLevel = (spellIDInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
        while (currentIndex <= 5)
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " running sub spell code index " + IntToString(currentIndex));
            int subSpellID = GetLocalInt(GetModule(), HENCH_SPELL_ID_INFO + IntToString(nSpellID) + "SubRadSpell" + IntToString(currentIndex));
            if (subSpellID <= 0)
            {
                break;
            }
            int iSubSpellInformation = GetSpellInformation(subSpellID);
            HenchTalentSpellDispatch(tTalent, subSpellID, iSubSpellInformation, nItemType, TRUE, spellLevel);
            currentIndex++;
        }
    }
    else
    {
        if (gbDisableCastMeleeConcentration && (spellIDInfo & HENCH_SPELL_INFO_CONCENTRATION_FLAG))
        {
            return;
        }

        if (nSpellLevel < 0)
        {
            nSpellLevel = (spellIDInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
        }

        gsCurrentspInfo.spellID = nSpellID;
        if (bIsSubSpell)
        {
            gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR;
        	gsCurrentspInfo.otherID = METAMAGIC_ANY;
        }
		else
		{
	        gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_TALENT;
	        gsCurrentspInfo.tTalent = tTalent;
        	gsCurrentspInfo.otherID = -1;
		}
        gsCurrentspInfo.spellLevel = nSpellLevel;
        gsCurrentspInfo.spellInfo = spellIDInfo;

        DispatchSpell(nItemType);
    }
}


void HenchFeatDispatch(int nFeatID, int nSpellID, int bUseCheatCast)
{
    if (bUseCheatCast)
    {
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
    }
	else
	{
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID;
	}
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = nFeatID;
	int spellInformation = GetSpellInformation(nSpellID);
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;

    if (gbDisableCastMeleeConcentration && (spellInformation & HENCH_SPELL_INFO_CONCENTRATION_FLAG))
    {
        return;
    }

    DispatchSpell(HENCH_ITEM_TYPE_NONE);
}


void HenchSpontaneousDispatch(int nSpellID)
{
//Jug_Debug(GetName(OBJECT_SELF) + " doing spontaneous dispatch " + IntToString(nSpellID));
   	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = METAMAGIC_NONE;
	int spellInformation = GetSpellInformation(nSpellID) | HENCH_SPELL_INFO_UNLIMITED_FLAG;
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;

    if (gbDisableCastMeleeConcentration && (spellInformation & HENCH_SPELL_INFO_CONCENTRATION_FLAG))
    {
        return;
    }

    DispatchSpell(HENCH_ITEM_TYPE_NONE);
}


int giCheckSpontaneousFlags;
int giCheckSpontaneousLevels;
string gsSpontaneousClassColumn;
string gsSpontaneousClassCache;

int FindItemSpellTalentsByCategory(int nCategory, int maximumToFind, int talentExclude, int nItemType)
{
//  Jug_Debug(GetName(OBJECT_SELF) + " find spells by cat " + IntToString(nCategory) + " max " + IntToString(maximumToFind) + " exclude " + IntToString(talentExclude));
    int spellsFound;
    int testCR = 20;
    talent tBest;
	
    while (testCR >= 0)
    {
//		Jug_Debug("testing talent type " + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
        talent tBest = GetCreatureTalentBest(nCategory, testCR, OBJECT_SELF, talentExclude);
        if (!GetIsTalentValid(tBest))
        {
            if (spellsFound == 0)
            {
                return 0;
            }
            break;
        }
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
//			Jug_Debug(">>>found talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
			int iSpellInformation = GetSpellInformation(nNewSpellID);
            if (!HasItemTalentSpell(nNewSpellID))
            {
//				Jug_Debug(">>>dispatch talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude) + " cr " + IntToString(testCR));
                AddItemTalentSpell(nNewSpellID);
                spellsFound ++;

                HenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType, FALSE, -1);
				
				if (giCheckSpontaneousFlags == talentExclude)
				{
					string cacheName = gsSpontaneousClassCache + IntToString(nNewSpellID);
					int cacheValue = GetLocalInt(GetModule(), cacheName);
					if (!cacheValue)
					{
	                	string columnInfo = Get2DAString("spells", gsSpontaneousClassColumn , nNewSpellID);
						int spontaneousSpellLevel = StringToInt(columnInfo);
						if ((spontaneousSpellLevel != 0) || (FindSubString("*", columnInfo) < 0))
						{
							cacheValue = (1 << spontaneousSpellLevel);
	//						Jug_Debug(GetName(OBJECT_SELF) + " spontaneous " + Get2DAString("spells", "Label", nNewSpellID) + " level " + IntToString(spontaneousSpellLevel) + " mask " + IntToHexString(giCheckSpontaneousLevels));					
						}
						else
						{
							cacheValue = 0x80000000;
	//						Jug_Debug(GetName(OBJECT_SELF) + " spontaneous no match " + Get2DAString("spells", "Label", nNewSpellID));					
						}
						SetLocalInt(GetModule(), cacheName, cacheValue);
					}
					giCheckSpontaneousLevels |= cacheValue;				
				}
                if (spellsFound >= maximumToFind)
                {
                    return spellsFound;
                }
            }
	        if (nItemType)
	        {
	            // you can only find one item with GetCreatureTalentBest
	            break;
	        }			
			int curCR = (iSpellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> 12; // HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT - 1 makes it two times spell level
			testCR = testCR < curCR ? testCR : curCR;
        }
		else
		{
/*			if (nType == TALENT_TYPE_FEAT)
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("feat", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
			else
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("skills", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			} */
			break;
		}
        testCR -= 2;
    }
	
    int nTry;

    while (nTry < 5)
    {
        tBest = GetCreatureTalentRandom(nCategory, OBJECT_SELF, talentExclude);
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
            int iSpellInformation = GetSpellInformation(nNewSpellID);

//			if (nItemType)
//			{
//				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
//			}
            if (!HasItemTalentSpell(nNewSpellID))
            {
//				Jug_Debug(">>>dispatch talent type " + IntToString(nType) + " id " + Get2DAString("spells", "Label", nNewSpellID) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
                AddItemTalentSpell(nNewSpellID);
                spellsFound ++;
                HenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType, FALSE, -1);				
            }
        }
/*		else
		{
			if (nType == TALENT_TYPE_FEAT)
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("feat", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
			else
			{
				Jug_Debug("!!!!Found talent type " + IntToString(nType) + " id " + Get2DAString("skills", "Label", GetIdFromTalent(tBest)) + " category " + IntToString(nCategory) + " exclude " + IntToString(talentExclude));
			}
		} */
        if (spellsFound >= maximumToFind)
        {
            return spellsFound;
        }
        nTry ++;
    }
    return spellsFound;
}


int CheckSpontaneousCureOrInflictSpell(int nSpellID)
{
	if (!GetHasSpell(nSpellID))
	{
		return FALSE;
	}
    int spellInfo = GetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " cure spell " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID) + " spell level " + IntToString(spellLevel) + " mask " + IntToString(giCheckSpontaneousLevels));
		gsCurrentspInfo.spellInfo = spellInfo;	
	    gsCurrentspInfo.spellLevel = spellLevel;
	    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
	    gsCurrentspInfo.range = 4.0;
	    gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
	    gsCurrentspInfo.spellID = nSpellID;
	    gsCurrentspInfo.otherID = METAMAGIC_NONE;
	    HenchSpellAttack(GetCurrentSpellSaveType(), HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);	
	}

    return TRUE;
}


int CheckSpontaneousMassCureOrInflictSpell(int nSpellID)
{
	if (!GetHasSpell(nSpellID))
	{
		return FALSE;
	}
    int spellInfo = GetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " cure spell " + IntToString(nSpellID) + " " + Get2DAString("spells", "Label", nSpellID) + " spell level " + IntToString(spellLevel) + " mask " + IntToString(giCheckSpontaneousLevels));
		gsCurrentspInfo.spellInfo = spellInfo;	
	    gsCurrentspInfo.spellLevel = spellLevel;
	    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
		gsCurrentspInfo.range = 8.0;
		gsCurrentspInfo.radius = RADIUS_SIZE_LARGE;
		gsCurrentspInfo.shape = SHAPE_SPHERE;
		gsCurrentspInfo.spellID = nSpellID;
	    gsCurrentspInfo.otherID = METAMAGIC_NONE;
		HenchSpellAttack(GetCurrentSpellSaveType(), HENCH_SPELL_TARGET_SHAPE_LOOP);
	}

    return TRUE;
}


int gExcludedItemTalents;   // global flags for excluded talent types, polymorph can change setting
int gbUseSpells;
int gbUseAbilities;
int gbUseItems;


void InitializeSpellTalentCategory(int nCategory)
{
	itemTalentSpellCount = 0;
	int spellCount = 10;
	if (gbUseSpells)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE);
	}
	if (gbUseAbilities)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
	}
}


void InitializeSpellTalentCategoryNoItems(int nCategory)
{
	itemTalentSpellCount = 0;
	int spellCount = 10;
	if (gbUseSpells)
	{
		spellCount -= FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE);
	}
	if (gbUseAbilities)
	{
		FindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}
}


int gbDisableHighLevelSpells;

void InitializeEpicSpells()
{
	if ((GetHitDice(OBJECT_SELF) <= 20) || gbDisableHighLevelSpells)
	{
		return;
	}
	// the DC get done wrong due to cheat casting appears to be fixed at +3 ability mod	
	if (GetHasFeat(FEAT_EPIC_SPELL_HELLBALL))
    {
        HenchFeatDispatch(FEAT_EPIC_SPELL_HELLBALL, SPELL_EPIC_HELLBALL, TRUE);
    }
    if (GetHasFeat(1991))
    {
        HenchFeatDispatch(1991, 1076, FALSE);
    }
    if (GetHasFeat(1992))
    {
        HenchFeatDispatch(1992, SPELL_ENTROPIC_HUSK, FALSE);
    }
    if (GetHasFeat(1993))
    {
        HenchFeatDispatch(1993, 1078, FALSE);
    }
/*    if (GetHasFeat(1994)) mass fowl, ResistSpell doesn't work with cheat cast,
	plus it leaves PC permanently as a chicken.
    {
        HenchFeatDispatch(1994, 1079, TRUE);
    } */
    if (GetHasFeat(1995))
    {
        HenchFeatDispatch(1995, 1080, FALSE);
    }
}


const int HENCH_CHECK_SPONTANEOUS_HEAL		= 1;
const int HENCH_CHECK_SPONTANEOUS_HARM		= 2;
const int HENCH_CHECK_SPONTANEOUS_SUMMON	= 3;

void InitializeSpellTalents()
{
	int iCheckSpontaneousSpells;
	int iCheckSpontaneousLevels;
	
	if (!bgDisablingEffect)
    {
		if ((gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE) &&
			(GetLevelByClass(CLASS_TYPE_CLERIC) > 0))
		{		
			giCheckSpontaneousFlags = HENCH_TALENT_USE_SPELLS_ONLY;
			gsSpontaneousClassColumn = "Cleric";
			gsSpontaneousClassCache = "HenchSpontCleric";
			iCheckSpontaneousSpells = (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL) ?
				HENCH_CHECK_SPONTANEOUS_HARM : HENCH_CHECK_SPONTANEOUS_HEAL;
		}
	}	

	if (gbUseAbilities)
	{	
		InitializeEpicSpells();	
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_DRAGONS_BREATH, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE);
	}

	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_RANGED);	
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_TOUCH);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (HasItemTalentSpell(SPELL_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (HasItemTalentSpell(SPELL_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (HasItemTalentSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT);
	
	if (gbUseItems)
	{
    	itemTalentSpellCount = 0;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_RANGED, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
    	itemTalentSpellCount = 0;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
    	itemTalentSpellCount = 0;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
    	itemTalentSpellCount = 0;
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
	}	

	InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES);	
	InitializeSpellTalentCategory(TALENT_CATEGORY_DISPEL);
	InitializeSpellTalentCategory(TALENT_CATEGORY_SPELLBREACH);
		
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT);
    InitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE);
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
		
    // 0 talent category is misc spells (***** category in spells.2da)
    InitializeSpellTalentCategory(0);
		
    InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (HasItemTalentSpell(SPELL_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (HasItemTalentSpell(SPELL_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (HasItemTalentSpell(SPELL_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (HasItemTalentSpell(SPELL_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
    InitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (HasItemTalentSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (HasItemTalentSpell(SPELL_MASS_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	if (gbUseItems)
	{
		FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
	}
	
	InitializeSpellTalentCategory(TALENT_CATEGORY_CANTRIP);
	if (iCheckSpontaneousSpells)
	{
		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{
			if (HasItemTalentSpell(SPELL_CURE_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{
			if (HasItemTalentSpell(SPELL_INFLICT_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		
		giCheckSpontaneousLevels &= ~iCheckSpontaneousLevels;

		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{		
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_CRITICAL_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_SERIOUS_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_MODERATE_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_LIGHT_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_CURE_MINOR_WOUNDS);
			
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_MODERATE_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_LIGHT_WOUNDS);
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{				
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_CRITICAL_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_SERIOUS_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MODERATE_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_LIGHT_WOUNDS);
			CheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MINOR_WOUNDS);
			
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS);
			CheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS);
		}
	}
}
	

int HenchGetHasInspireBardSongSpellEffect( object oObject=OBJECT_SELF )
{
    if ( GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COURAGE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COMPETENCE, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_DEFENSE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_REGENERATION, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_SLOWING, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_JARRING, oObject ) ||
         GetHasSpellEffect( 1074, oObject )) // FEAT_EPIC_SONG_OF_REQUIEM
    {
        return ( TRUE );
    }

    return ( FALSE );
}


void InitializeFeats()
{
    if (GetLevelByClass(CLASS_TYPE_MONK) > 0)
    {
        if (GetHasFeat(FEAT_WHOLENESS_OF_BODY))
        {
            HenchFeatDispatch(FEAT_WHOLENESS_OF_BODY, SPELLABILITY_WHOLENESS_OF_BODY, FALSE);
        }
        if (GetHasFeat(FEAT_EMPTY_BODY))
        {
            HenchFeatDispatch(FEAT_EMPTY_BODY, SPELLABILITY_EMPTY_BODY, FALSE);
        }
        if (GetHasFeat(1955))
        {
            HenchFeatDispatch(1955, SPELLABILITY_BLAZING_AURA, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_DRUID) > 0)
    {
        if (GetHasFeat(FEAT_ELEMENTAL_SHAPE))
        {
            HenchFeatDispatch(FEAT_ELEMENTAL_SHAPE, 397, TRUE);
            HenchFeatDispatch(FEAT_ELEMENTAL_SHAPE, 398, TRUE);
            HenchFeatDispatch(FEAT_ELEMENTAL_SHAPE, 399, TRUE);
            HenchFeatDispatch(FEAT_ELEMENTAL_SHAPE, 400, TRUE);
        }
        if (GetHasFeat(FEAT_WILD_SHAPE))
        {
                // note: elephant's hide and oaken resilience are free actions
            if (GetHasFeat(FEAT_ELEPHANTS_HIDE) && !GetHasSpell(SPELL_TORTOISE_SHELL)
                && (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
            {
                int posEffects = GetCreaturePosEffects(OBJECT_SELF);
                if (!(posEffects & HENCH_EFFECT_TYPE_POLYMORPH))
                {
                    if (!(posEffects & HENCH_EFFECT_TYPE_AC_INCREASE) ||
                        (GetCreatureACBonus(OBJECT_SELF, AC_NATURAL_BONUS) <= 5))
                    {
//						Jug_Debug(GetName(OBJECT_SELF) + " using elephant hide");
                        ActionUseFeat(FEAT_ELEPHANTS_HIDE, OBJECT_SELF);
                    }
                }
            }
            if (GetHasFeat(FEAT_OAKEN_RESILIENCE) && !(GetHasFeat(FEAT_ELEMENTAL_SHAPE) ||
                GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON) || GetHasFeat(2111) ||
                GetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH)) &&
                (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
            {
                if (!GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_CRITICAL_HIT))
                {
//					Jug_Debug(GetName(OBJECT_SELF) + " using oaken resilience");
                    ActionUseFeat(FEAT_OAKEN_RESILIENCE, OBJECT_SELF);
                }
            }
            HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_WILD_SHAPE_BROWN_BEAR, TRUE);

            if (GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON))
            {
                HenchFeatDispatch(FEAT_WILD_SHAPE, 707, TRUE);
                HenchFeatDispatch(FEAT_WILD_SHAPE, 708, TRUE);
                HenchFeatDispatch(FEAT_WILD_SHAPE, 709, TRUE);
            }
            if (GetHasFeat(2001))
            {
                HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF, TRUE);
            }
            if (GetHasFeat(2111))
            {
                HenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_PLANT_WILD_SHAPE_TREANT, TRUE);
            }
        }
    }
    if (GetLevelByClass(CLASS_TYPE_CLERIC) > 0)
    {
        if (GetHasFeat(FEAT_WAR_DOMAIN_POWER))
        {
            HenchFeatDispatch(FEAT_WAR_DOMAIN_POWER, SPELLABILITY_BATTLE_MASTERY, FALSE);
        }
        if (GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER))
        {
            HenchFeatDispatch(FEAT_STRENGTH_DOMAIN_POWER, SPELLABILITY_DIVINE_STRENGTH, FALSE);
        }
        if (GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER))
        {
            HenchFeatDispatch(FEAT_PROTECTION_DOMAIN_POWER, SPELLABILITY_DIVINE_PROTECTION, FALSE);
        }
        if (GetHasFeat(FEAT_DEATH_DOMAIN_POWER))
        {
            HenchFeatDispatch(FEAT_DEATH_DOMAIN_POWER, SPELLABILITY_NEGATIVE_PLANE_AVATAR, FALSE);
        }
        if (GetHasFeat(FEAT_TRICKERY_DOMAIN_POWER))
        {
            HenchFeatDispatch(FEAT_TRICKERY_DOMAIN_POWER, SPELLABILITY_DIVINE_TRICKERY, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER) > 0)
    {
        if (GetHasFeat(FEAT_SHADOW_DAZE))
        {
            HenchFeatDispatch(FEAT_SHADOW_DAZE, SPELL_SHADOW_DAZE, FALSE);
        }
        if (GetHasFeat(FEAT_SUMMON_SHADOW))
        {
            HenchFeatDispatch(FEAT_SUMMON_SHADOW, SPELL_SUMMON_SHADOW, TRUE);
        }
        if (GetHasFeat(FEAT_SHADOW_EVADE))
        {
            HenchFeatDispatch(FEAT_SHADOW_EVADE, SPELL_SHADOW_EVADE, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_HARPER) > 0)
    {
        if (GetHasFeat(FEAT_TYMORAS_SMILE))
        {
            HenchFeatDispatch(FEAT_TYMORAS_SMILE, SPELL_TYMORAS_SMILE, FALSE);
        }
        if (GetHasFeat(FEAT_HARPER_INVISIBILITY))
        {
            HenchFeatDispatch(FEAT_HARPER_INVISIBILITY, 483, FALSE);
        }
        if (GetHasFeat(1584))
        {
            HenchFeatDispatch(1584, 947, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER) > 0)
    {
        if (GetHasFeat(FEAT_PRESTIGE_SEEKER_ARROW_1))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_SEEKER_ARROW_1, SPELLABILITY_AA_SEEKER_ARROW_1, FALSE);
        }
        if (GetHasFeat(FEAT_PRESTIGE_HAIL_OF_ARROWS))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_HAIL_OF_ARROWS, SPELLABILITY_AA_HAIL_OF_ARROWS, FALSE);
        }
        if (GetHasFeat(FEAT_PRESTIGE_ARROW_OF_DEATH))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_ARROW_OF_DEATH, SPELLABILITY_AA_ARROW_OF_DEATH, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_ASSASSIN) > 0)
    {
        if (GetHasFeat(FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE, SPELLABILITY_AS_GHOSTLY_VISAGE, FALSE);
        }
        if (GetHasFeat(FEAT_PRESTIGE_DARKNESS))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_DARKNESS, SPELLABILITY_AS_DARKNESS, TRUE);
        }
        if (GetHasFeat(FEAT_PRESTIGE_INVISIBILITY_1))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_INVISIBILITY_1, SPELLABILITY_AS_INVISIBILITY, FALSE);
        }
        if (GetHasFeat(FEAT_PRESTIGE_INVISIBILITY_2))
        {
            HenchFeatDispatch(FEAT_PRESTIGE_INVISIBILITY_2, SPELLABILITY_AS_GREATER_INVISIBLITY, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_BLACKGUARD) > 0)
    {
        if (GetHasFeat(FEAT_INFLICT_LIGHT_WOUNDS))
        {
            HenchFeatDispatch(FEAT_INFLICT_LIGHT_WOUNDS, SPELLABILITY_BG_CREATEDEAD, TRUE);
        }
        if (GetHasFeat(FEAT_INFLICT_MODERATE_WOUNDS))
        {
            HenchFeatDispatch(FEAT_INFLICT_MODERATE_WOUNDS, SPELLABILITY_BG_FIENDISH_SERVANT, TRUE);
        }
        if (GetHasFeat(FEAT_INFLICT_SERIOUS_WOUNDS))
        {
            HenchFeatDispatch(FEAT_INFLICT_SERIOUS_WOUNDS, SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS, FALSE);
        }
        if (GetHasFeat(FEAT_INFLICT_CRITICAL_WOUNDS))
        {
            HenchFeatDispatch(FEAT_INFLICT_CRITICAL_WOUNDS, SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS, FALSE);
        }
        if (GetHasFeat(FEAT_BULLS_STRENGTH))
        {
            HenchFeatDispatch(FEAT_BULLS_STRENGTH, SPELLABILITY_BG_BULLS_STRENGTH, FALSE);
        }
        if (GetHasFeat(FEAT_CONTAGION))
        {
            HenchFeatDispatch(FEAT_CONTAGION, SPELLABILITY_BG_CONTAGION, FALSE);
        }
        if (GetHasFeat(1832))
        {
            HenchFeatDispatch(1832, SPELLABLILITY_AURA_OF_DESPAIR, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_PALEMASTER) > 0)
    {
        if (GetHasFeat(FEAT_ANIMATE_DEAD))
        {
            HenchFeatDispatch(FEAT_ANIMATE_DEAD, SPELLABILITY_PM_ANIMATE_DEAD, TRUE);
        }
        if (GetHasFeat(FEAT_SUMMON_UNDEAD))
        {
            HenchFeatDispatch(FEAT_SUMMON_UNDEAD, SPELLABILITY_PM_SUMMON_UNDEAD, TRUE);
        }
        if (GetHasFeat(FEAT_UNDEAD_GRAFT_1))
        {
            HenchFeatDispatch(FEAT_UNDEAD_GRAFT_1, SPELLABILITY_PM_UNDEAD_GRAFT_1, FALSE);
        }
        if (GetHasFeat(FEAT_SUMMON_GREATER_UNDEAD))
        {
            HenchFeatDispatch(FEAT_SUMMON_GREATER_UNDEAD, SPELLABILITY_PM_SUMMON_GREATER_UNDEAD, TRUE);
        }
        if (GetHasFeat(FEAT_DEATHLESS_MASTER_TOUCH))
        {
            HenchFeatDispatch(FEAT_DEATHLESS_MASTER_TOUCH, SPELLABILITY_PM_DEATHLESS_MASTER_TOUCH, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER) > 0)
    {
        if (GetHasFeat(FEAT_FRENZY_1))
        {
            HenchFeatDispatch(FEAT_FRENZY_1, SPELLABILITY_FRENZY, FALSE);
        }
        if (GetHasFeat(FEAT_INSPIRE_FRENZY_1))
        {
            HenchFeatDispatch(FEAT_INSPIRE_FRENZY_1, SPELLABILITY_INSPIRE_FRENZY, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_SACREDFIST) > 0)
    {
        if (GetHasFeat(1558))
        {
            HenchFeatDispatch(1558, 1123, FALSE);
        }
        if (GetHasFeat(1560))
        {
            HenchFeatDispatch(1560, 1124, FALSE);
        }
    }
    if (GetLevelByClass(CLASS_TYPE_WARPRIEST) > 0)
    {
        if (GetHasFeat(1807))
        {
            HenchFeatDispatch(1807, SPELLABILITY_WAR_GLORY, FALSE);
        }
        if (GetHasFeat(1813))
        {
            HenchFeatDispatch(1813, SPELLABILITY_INFLAME, FALSE);
        }
        if (GetHasFeat(1814))
        {
            HenchFeatDispatch(1814, 961, FALSE);
        }
        if (GetHasFeat(1815))
        {
            HenchFeatDispatch(1815, SPELLABILITY_WARPRIEST_FEAR_AURA, FALSE);
        }
        if (GetHasFeat(1816))
        {
            HenchFeatDispatch(1816, 963, FALSE);
        }
        if (GetHasFeat(1817))
        {
            HenchFeatDispatch(1817, SPELLABILITY_WARPRIEST_HASTE, FALSE);
        }
        if (GetHasFeat(1818))
        {
            HenchFeatDispatch(1818, 965, TRUE);
        }
    }
    if (GetHasFeat(FEAT_LAY_ON_HANDS))
    {
        HenchFeatDispatch(FEAT_LAY_ON_HANDS, SPELLABILITY_LAY_ON_HANDS, FALSE);
    }
    if (GetHasFeat(FEAT_REMOVE_DISEASE))
    {
        HenchFeatDispatch(FEAT_REMOVE_DISEASE, SPELLABILITY_REMOVE_DISEASE, FALSE);
    }
    if (GetHasFeat(FEAT_EPIC_BLINDING_SPEED))
    {
        HenchFeatDispatch(FEAT_EPIC_BLINDING_SPEED, SPELLABILITY_EPIC_SHAPE_DRAGON, FALSE);
    }
    if (GetHasFeat(FEAT_ENLARGE))
    {
        HenchFeatDispatch(FEAT_ENLARGE, 803, FALSE);
    }
    if (GetHasFeat(FEAT_INVISIBILITY))
    {
        HenchFeatDispatch(FEAT_INVISIBILITY, 804, FALSE);
    }
    if (GetHasFeat(FEAT_DROW_DARKNESS))
    {
        HenchFeatDispatch(FEAT_DROW_DARKNESS, SPELLABILITY_DARKNESS, TRUE);
    }
    if (GetHasFeat(FEAT_SVIRFNEBLIN_BLIND))
    {
        HenchFeatDispatch(FEAT_SVIRFNEBLIN_BLIND, 946, FALSE);
    }
    if (GetHasFeat(FEAT_SVIRFNEBLIN_CHANGE_SELF))
    {
        HenchFeatDispatch(FEAT_SVIRFNEBLIN_CHANGE_SELF, 387, TRUE);
        HenchFeatDispatch(FEAT_SVIRFNEBLIN_CHANGE_SELF, 388, TRUE);
        HenchFeatDispatch(FEAT_SVIRFNEBLIN_CHANGE_SELF, 389, TRUE);
    }
    if (GetHasFeat(1089))
    {
        HenchFeatDispatch(1089, SPELLABILITY_DARKNESS, TRUE);
    }
    if (GetHasFeat(1494))
    {
        HenchFeatDispatch(1494, SPELLABILITY_FURIOUS_ASSAULT, FALSE);
    }
    if (GetHasFeat(1749))
    {
        HenchFeatDispatch(1749, 943, FALSE);
    }
    if (GetHasFeat(1756))
    {
        HenchFeatDispatch(1756, 944, FALSE);
    }
    if (GetHasFeat(1757))
    {
        HenchFeatDispatch(1757, SPELLABILITY_ENTROPIC_SHIELD, FALSE);
    }
    if (GetHasFeat(1812))
    {
        HenchFeatDispatch(1812, SPELL_REMOVE_FEAR, FALSE);
    }
    if (GetHasFeat(1872))
    {
        HenchFeatDispatch(1872, SPELLABILITY_SUMMON_GALE, TRUE);
    }
    if (GetHasFeat(1873))
    {
        HenchFeatDispatch(1873, SPELLABILITY_MERGE_WITH_STONE, FALSE);
    }
    if (GetHasFeat(1874))
    {
        HenchFeatDispatch(1874, SPELLABILITY_REACH_TO_THE_BLAZE, FALSE);
    }
    if (GetHasFeat(1875))
    {
        HenchFeatDispatch(1875, SPELLABILITY_SHROUDING_FOG, TRUE);
    }
    if (GetHasFeat(1971) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
    {
        HenchFeatDispatch(1971, SPELLABILITY_LAST_STAND, FALSE);
    }
    if (GetHasFeat(2121))
    {
        HenchFeatDispatch(2121, SPELL_RESURRECTION, FALSE);
    }
    if (GetHasFeat(2122))
    {
        HenchFeatDispatch(2122, SPELLABILITY_WORD_OF_FAITH, TRUE);
    }
    if (GetHasFeat(2123))
    {
        HenchFeatDispatch(2123, SPELLABILITY_MASS_CHARM_MONSTER, TRUE);
    }
    if (GetHasFeat(2124))
    {
        HenchFeatDispatch(2124, SPELLABILITY_SUMMON_PLANETAR, TRUE);
    }
    if (GetHasFeat(2126))
    {
        HenchFeatDispatch(2126, SPELLABILITY_AURA_PROTECTION, FALSE);
    }
    if (GetHasFeat(FEAT_BARBARIAN_RAGE))
    {
        HenchFeatDispatch(FEAT_BARBARIAN_RAGE, SPELLABILITY_BARBARIAN_RAGE, FALSE);
    }
    if (GetHasFeat(FEAT_AURA_OF_COURAGE))
    {
        HenchFeatDispatch(FEAT_AURA_OF_COURAGE, SPELLABILITY_AURA_OF_COURAGE, FALSE);
    }
    if (GetHasFeat(FEAT_DIVINE_WRATH))
    {
        HenchFeatDispatch(FEAT_DIVINE_WRATH, SPELLABILITY_DC_DIVINE_WRATH, FALSE);
    }
    if (GetHasFeat(FEAT_FIENDISH_RESILIENCE_1))
    {
        HenchFeatDispatch(FEAT_FIENDISH_RESILIENCE_1, SPELLABILITY_FIENDISH_RESILIENCE, FALSE);
    }
    if (GetHasFeat(FEAT_IMPROVED_REACTION))
    {
        HenchFeatDispatch(FEAT_IMPROVED_REACTION, SPELLABILITY_IMPROVED_REACTION, FALSE);
    }
    if (GetHasFeat(1805))
    {
        HenchFeatDispatch(1805, SPELLABILITY_PROTECTIVE_AURA, FALSE);
    }
    if (GetHasFeat(1853))
    {
        HenchFeatDispatch(1853, SPELLABILITY_PILFER_MAGIC, FALSE);
    }
    if (GetHasFeat(2045))
    {
        HenchFeatDispatch(2045, 1107, FALSE);
    }
    if (GetHasFeat(2081))
    {
        HenchFeatDispatch(2081, SPELLABILITY_FAVORED_SOUL_HASTE, FALSE);
    }


    if (GetHasFeat(FEAT_TURN_UNDEAD))
    {
        HenchFeatDispatch(FEAT_TURN_UNDEAD, SPELLABILITY_TURN_UNDEAD, FALSE);

        int abilityModifier = GetAbilityModifier(ABILITY_CHARISMA);
        // in order to prevent constant calling if Charisma low, do random check
        if ((abilityModifier > 0) && ((abilityModifier * abilityModifier) >= Random(100)))
        {
            if (GetHasFeat(FEAT_DIVINE_MIGHT))
            {
                HenchFeatDispatch(FEAT_DIVINE_MIGHT, SPELL_DIVINE_MIGHT, FALSE);
            }
            if (GetHasFeat(FEAT_DIVINE_SHIELD) && (GetPercentageHPLoss(OBJECT_SELF) < 50))
            {
                HenchFeatDispatch(FEAT_DIVINE_SHIELD, SPELL_DIVINE_SHIELD, FALSE);
            }
        }
    }

    if (GetLevelByClass(CLASS_TYPE_BARD) > 0)
    {
        if (!(GetCreatureNegEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_SILENCE))
        {
            if (GetHasFeat(FEAT_BARD_SONGS))
            {
                if (!GetHasNormalBardSongSpellEffect())
                {
                    if (GetHasFeat(FEAT_BARDSONG_COUNTERSONG))
                    {
                        HenchFeatDispatch(FEAT_BARDSONG_COUNTERSONG, SPELLABILITY_SONG_COUNTERSONG, FALSE);
                    }
                    if (GetHasFeat(FEAT_BARDSONG_FASCINATE))
                    {
                        HenchFeatDispatch(FEAT_BARDSONG_FASCINATE, SPELLABILITY_SONG_FASCINATE, FALSE);
                    }
                    if (GetHasFeat(FEAT_BARDSONG_HAVEN_SONG))
                    {
                        HenchFeatDispatch(FEAT_BARDSONG_HAVEN_SONG, SPELLABILITY_SONG_HAVEN_SONG, FALSE);
                    }
	                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_HEROICS))
	                {
	                    if (GetHasFeat(FEAT_EPIC_CHORUS_OF_HEROISM, OBJECT_SELF, TRUE))
	                    {
							if (GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
							{						
		                        HenchFeatDispatch(FEAT_EPIC_CHORUS_OF_HEROISM, 1158, FALSE);
							}
	                    }
	                    else
	                    {
	                        HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_HEROICS, SPELLABILITY_SONG_INSPIRE_HEROICS, FALSE);
	                    }
	                }
	                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_LEGION) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
	                {
	                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_LEGION, SPELLABILITY_SONG_INSPIRE_LEGION, FALSE);
	                }
                    // Not done FEAT_BARDSONG_IRONSKIN_CHANT (faction only), FEAT_BARDSONG_SONG_OF_FREEDOM, Song_Cloud_Mind
                }
                if (GetHasFeat(FEAT_CURSE_SONG))
				{
					object oTest = GetLocalObject(OBJECT_SELF, sLineOfSight);
					int bUseCurseSong;
					while (GetIsObjectValid(oTest))
					{
						if (GetHasSpellEffect(SPELLABILITY_EPIC_CURSE_SONG, oTest))
						{
							bUseCurseSong = FALSE;
							break;
						}					
						bUseCurseSong = TRUE;
						oTest = GetLocalObject(oTest, sLineOfSight);					
					}
        			if (bUseCurseSong)
	                {
	                    HenchFeatDispatch(FEAT_CURSE_SONG, SPELLABILITY_EPIC_CURSE_SONG, FALSE);
	                }
				}
 				if (GetHasFeat(1988) && !GetHasSpellEffect(1074, OBJECT_SELF)) // FEAT_EPIC_SONG_OF_REQUIEM
				{
                    HenchFeatDispatch(1988, 1074, FALSE);
				}
            }

            if (!HenchGetHasInspireBardSongSpellEffect())
            {
                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COURAGE))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_COURAGE, SPELLABILITY_SONG_INSPIRE_COURAGE, FALSE);
                }
                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_DEFENSE))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_DEFENSE, SPELLABILITY_SONG_INSPIRE_DEFENSE, FALSE);
                }
/*              if (GetHasFeat(FEAT_BARDSONG_INSPIRE_JARRING))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_JARRING, SPELLABILITY_SONG_INSPIRE_JARRING, FALSE);
                } */
                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_REGENERATION, SPELLABILITY_SONG_INSPIRE_REGENERATION, FALSE);
                }
/*              if (GetHasFeat(FEAT_BARDSONG_INSPIRE_SLOWING))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_SLOWING, SPELLABILITY_SONG_INSPIRE_SLOWING, FALSE);
                } */
                if (GetHasFeat(FEAT_BARDSONG_INSPIRE_TOUGHNESS))
                {
                    HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_TOUGHNESS, SPELLABILITY_SONG_INSPIRE_TOUGHNESS, FALSE);
                }
		        // Not done FEAT_BARDSONG_INSPIRE_COMPETENCE
			}
        }
    }

    if (GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN) > 0)
    {
        if (GetIsSpirit(GetLocalObject(OBJECT_SELF, sLineOfSight)))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " checking spirit shaman abilities");
            if (GetHasFeat(FEAT_CHASTISE_SPIRITS))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman chastise");
                HenchFeatDispatch(FEAT_CHASTISE_SPIRITS, 1094, FALSE);
                // TODO Weaken Spirits?
            }
            if (GetHasFeat(2021) && GetIsObjectValid(GetFactionLeader(OBJECT_SELF)))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman warding");
                HenchFeatDispatch(2021, SPELLABILITY_WARDING_OF_THE_SPIRITS, FALSE);
            }
            if (GetHasFeat(2020))
            {
//              Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman blessing");
                HenchFeatDispatch(2020, SPELLABILITY_BLESSING_OF_THE_SPIRITS, FALSE);
            }
        }

        if (GetHasFeat(2027))       // Raise Dead
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman raise dead");
            HenchFeatDispatch(2027, 1157, TRUE);
        }
        if (GetHasFeat(2022))       // Spirit Form
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman spirit form");
            HenchFeatDispatch(2022, 1102, FALSE);
        }
        if (GetHasFeat(2028))       // Spirit Journey
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " spirit shaman spirit journey");
            HenchFeatDispatch(2028, 1103, FALSE);
        }
    }
}


void InitializeWarlockAttackSpell(int nSpellID, int nSpellLevel)
{
    int originalSpellInformation = GetSpellInformation(nSpellID);
    int saveType = GetCurrentSpellSaveType();

//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock spell " + IntToString(nSpellID));

//      spInfo.tTalent = tTalent;
    gsCurrentspInfo.spellInfo = originalSpellInformation;
    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_WARLOCK;
    gsCurrentspInfo.spellID = nSpellID;

    if (GetHasSpell(SPELL_I_ELDRITCH_SPEAR))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock spear");
        gsCurrentspInfo.spellLevel = 1;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_SPEAR;
        gsCurrentspInfo.range = 40.0;
        gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
        HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);
    }
    if (GetHasSpell(SPELL_I_HIDEOUS_BLOW))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock hideous has weapon " + IntToString(GetInitWeaponStatus() & HENCH_AI_HAS_MELEE));
        if ((GetDistanceToObject(ogClosestSeenOrHeardEnemy) < 5.0) &&
            (GetInitWeaponStatus() & HENCH_AI_HAS_MELEE))
        {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock hideous");
            gsCurrentspInfo.spellLevel = 1;
            gsCurrentspInfo.otherID = SPELL_I_HIDEOUS_BLOW;
            gsCurrentspInfo.range = 5.0;
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            HenchSpellAttack(saveType, 0);
        }
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_CONE))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock cone");
        gsCurrentspInfo.spellLevel = 3;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CONE;
        gsCurrentspInfo.shape = SHAPE_SPELLCONE;
        gsCurrentspInfo.radius = 11.0;
        gsCurrentspInfo.range = 8.0;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;		
        HenchSpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG | originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP);
    }
    gsCurrentspInfo.range = 20.0;       // the rest of the spells have range 20
    if (GetHasSpell(SPELL_I_ELDRITCH_CHAIN))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock chain");
        gsCurrentspInfo.spellLevel = 2;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CHAIN;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_COLOSSAL;
        HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG | HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG, HENCH_SPELL_TARGET_SHAPE_LOOP | HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG | HENCH_SPELL_TARGET_SECONDARY_TARGETS | HENCH_SPELL_TARGET_CHECK_COUNT | HENCH_SPELL_TARGET_SECONDARY_HALF_DAM);
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_DOOM))
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock doom");
        gsCurrentspInfo.spellLevel = 4;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_DOOM;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_HUGE;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;		
        HenchSpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP);
    }
//  Jug_Debug(GetName(OBJECT_SELF) + " test warlock none");
    gsCurrentspInfo.spellLevel = nSpellLevel;
    gsCurrentspInfo.otherID = -1;
    gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
	if ((nSpellID == SPELLABILITY_I_ELDRITCH_BLAST) && (giWarlockDamageDice > 9))
	{
		// for some reason raw eldritch blast ingnores spell resistance at the 10th dice
		saveType &= ~HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	}
    HenchSpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG);
}


void InitializeWarlockAttackSpells()
{
    if (!gbUseSpells)
    {
        return;
    }
    int warlockLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
    if (warlockLevel < 1)
    {
        return;
    }
    if (!(HENCH_SPELL_INFO_UNLIMITED_FLAG & gbSpellInfoCastMask))
    {
        return;
    }
    if (warlockLevel > 20)
    {
        giWarlockDamageDice = (warlockLevel - 2) / 2;
    	giWarlockMinSaveDC = nMySpellCasterDC + 9 + (warlockLevel - 20) / 3;
    }
	else
	{
	    if (warlockLevel <= 12)
	    {
	        giWarlockDamageDice = (warlockLevel + 1) / 2;
	    }
	    else
	    {
	        giWarlockDamageDice = (warlockLevel + 7) / 3;
	    }
	    giWarlockMinSaveDC = nMySpellCasterDC + giWarlockDamageDice;
	}
	
	int saveOldSpellCasterSpellPenetration = nMySpellCasterSpellPenetration;
	if (warlockLevel > 9)
	{
		// warlock caster level seems to be capped at level 9 for spell resistance
		nMySpellCasterSpellPenetration -= warlockLevel - 9;
	}	
	
    int featIndex;
    for (featIndex = FEAT_EPIC_ELDRITCH_BLAST_1; featIndex <= FEAT_EPIC_ELDRITCH_BLAST_10; featIndex++)
    {
        if (!GetHasFeat(featIndex))
        {
            break;
        }
        giWarlockDamageDice++;
    }
    gbWarlockMaster = GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER);

    InitializeWarlockAttackSpell(SPELLABILITY_I_ELDRITCH_BLAST, giWarlockDamageDice);
    if (GetHasSpell(SPELL_I_VITRIOLIC_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_VITRIOLIC_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_UTTERDARK_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_UTTERDARK_BLAST, 4);
    }
    if (GetHasSpell(SPELL_I_NOXIOUS_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_NOXIOUS_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_BEWITCHING_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BEWITCHING_BLAST, 3);
    }
    if (GetHasSpell(1131))	// binding blast
    {
        InitializeWarlockAttackSpell(1131, 7);
    }
    if (GetHasSpell(1130))	// hindering blast
    {
        InitializeWarlockAttackSpell(1130, 4);
    }
    if (GetHasSpell(SPELL_I_HELLRIME_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_HELLRIME_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BRIMSTONE_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BRIMSTONE_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BESHADOWED_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_BESHADOWED_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_DRAINING_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_DRAINING_BLAST, 1);
    }
    if (GetHasSpell(SPELL_I_FRIGHTFUL_BLAST))
    {
        InitializeWarlockAttackSpell(SPELL_I_FRIGHTFUL_BLAST, 1);
    }
	
	nMySpellCasterSpellPenetration = saveOldSpellCasterSpellPenetration;
}


int InitializeClassByPosition(int iPosition)
{
    int iAbility, iAbilityMod;
    int nClass = GetClassByPosition(iPosition);
    int nClassLevel = GetLevelByPosition(iPosition);

    switch (nClass)
    {
        case CLASS_TYPE_INVALID:
            return FALSE;
        case CLASS_TYPE_FIGHTER:
        case CLASS_TYPE_ROGUE:
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_DIVINECHAMPION:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_SHIFTER:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_DRAGONDISCIPLE:
        case CLASS_TYPE_INVISIBLE_BLADE:
        case CLASS_TYPE_ARCANE_ARCHER:
            break;
        case CLASS_TYPE_PALEMASTER:
        case CLASS_TYPE_WARPRIEST:
            nMySpellCasterLevel += (nClassLevel + 1) / 2;
            break;
        case CLASS_TYPE_HARPER:
        case CLASS_TYPE_ELDRITCH_KNIGHT:
            nMySpellCasterLevel += nClassLevel - 1;
            break;
		case CLASS_TYPE_SACREDFIST:
            nMySpellCasterLevel += nClassLevel - nClassLevel / 4;
			break;
        case CLASS_TYPE_RED_WIZARD:			
			nMySpellCasterDC += 1 + nClassLevel / 2;
        case CLASS_TYPE_ARCANETRICKSTER:
        case CLASS_TYPE_ARCANE_SCHOLAR:
        case CLASS_TYPE_STORMLORD:
            nMySpellCasterLevel += nClassLevel;
            break;
        case CLASS_TYPE_PALADIN:
            if (nClassLevel < 4)
            {
                break;
            }
            nClassLevel /= 2;
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        case CLASS_TYPE_RANGER:
            if (nClassLevel < 4)
            {
                break;
            }
            nClassLevel /= 2;
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        case CLASS_TYPE_CLERIC:
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_CLERIC))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        case CLASS_TYPE_DRUID:
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_DRUID))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        case CLASS_TYPE_WIZARD:
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_WIZARD))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_INTELLIGENCE);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
            break;
        case CLASS_TYPE_BARD:
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_BARD))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
            break;
        case CLASS_TYPE_SORCERER:
            if (GetHasFeat(FEAT_PRACTICED_SPELLCASTER_SORCERER))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
            break;
        case CLASS_TYPE_WARLOCK:
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
            break;
        case CLASS_TYPE_FAVORED_SOUL:
            if (GetHasFeat(2068 /*FEAT_PRACTICED_SPELLCASTER_x*/))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        case CLASS_TYPE_SPIRIT_SHAMAN:
            if (GetHasFeat(2003 /*FEAT_PRACTICED_SPELLCASTER_x*/))
            {
                nClassLevel += 4;
            }
            if (nMySpellCasterLevel < nClassLevel)
            {
                nMySpellCasterLevel = nClassLevel;
            }
            iAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
            bAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
            break;
        default:
            if (GetCasterLevel(OBJECT_SELF) > 0)
            {
                nMySpellCasterLevel = GetCasterLevel(OBJECT_SELF);
            }
            else if (nMySpellCasterLevel < GetHitDice(OBJECT_SELF))
            {
                nMySpellCasterLevel = GetHitDice(OBJECT_SELF);
/*                if (nMySpellCasterLevel > 15)
                {
                    // special abilities now limited to 15
                    nMySpellCasterLevel = 15;
                } */
            }
            iAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
            if (nMySpellCasterDC < iAbilityMod)
            {
                nMySpellCasterDC = iAbilityMod;
            }
    }
    return FALSE;
}


int InitializeSpellCasting()
{
    int bResult1 = InitializeClassByPosition(1);
    int bResult2 = InitializeClassByPosition(2);
    int bResult3 = InitializeClassByPosition(3);
    int bResult4 = InitializeClassByPosition(4);
    if (nMySpellCasterLevel > GetHitDice(OBJECT_SELF))
    {
        nMySpellCasterLevel = GetHitDice(OBJECT_SELF);
    }
    if (nMySpellCasterLevel > 22)
    {
        nMySpellCasterDC += (nMySpellCasterLevel - 20) / 3;
    }
    nMySpellCasterDC += 10;
    int nMySpellCasterSpellPenetrationBonus;

    if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 6;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 4;
    }
    else if (GetHasFeat(FEAT_SPELL_PENETRATION))
    {
        nMySpellCasterSpellPenetrationBonus = 2;
    }

    nMySpellCasterSpellPenetration = nMySpellCasterLevel + nMySpellCasterSpellPenetrationBonus;
    nMySpellCastingConcentration = GetSkillRank(SKILL_CONCENTRATION);
    if (GetHasFeat(FEAT_COMBAT_CASTING))
    {
        nMySpellCastingConcentration += 4;
    }

    nMyRangedTouchAttack = GetBaseAttackBonus(OBJECT_SELF) + GetLocalInt(OBJECT_SELF, attackBonusStr) + 11 /* 21 - 10 */;
    nMyMeleeTouchAttack = nMyRangedTouchAttack + GetAbilityModifier(ABILITY_STRENGTH);
    nMyRangedTouchAttack += GetAbilityModifier(ABILITY_DEXTERITY);

    return bResult1 || bResult2 || bResult3 || bResult4;
}


void InitializeItemSpells(int nClass, int negativeEffects, int positiveEffects)
{
    SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, OBJECT_SELF);
    gbNoTrueSeeing = !(positiveEffects & HENCH_EFFECT_TYPE_TRUESEEING);

    int itemSpellsFound = FALSE;

//  Jug_Debug(GetName(OBJECT_SELF) + " arc spell fail " + IntToString(GetArcaneSpellFailure(OBJECT_SELF)));
	int bArcaneSpellFailure;
	if (!GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3))
	{
	    if (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD)
	    {
	        if (GetArcaneSpellFailure(OBJECT_SELF) > 20)
	        {
	            bArcaneSpellFailure = TRUE;
	        }
	    }
	    else if (nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_WARLOCK)
	    {
	                                    // FEAT_ARMORED_CASTER_BARD FEAT_ARMORED_CASTER_WARLOCK
	        if (GetArcaneSpellFailure(OBJECT_SELF) > ((GetHasFeat(1859) || GetHasFeat(1860)) ? 45 : 30))
	        {
	            bArcaneSpellFailure = TRUE;
	        }
	    }
	}

    bgDisablingEffect = negativeEffects & HENCH_EFFECT_TYPE_SILENCE;

    int bSpellCastingProblem = InitializeSpellCasting();

    gExcludedItemTalents = GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);

//  Jug_Debug(GetName(OBJECT_SELF) + " start exclude " + IntToString(gExcludedItemTalents));
    //Jug_Debug(GetName(OBJECT_SELF) + " spell failure chance " + FloatToString(gfSpellFailureChance));

    if (!bAnySpellcastingClasses || bArcaneSpellFailure || (gfSpellFailureChance > 0.5))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " excluding spells !!!");
        gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
    }
    int bPolymorphed = positiveEffects & (HENCH_EFFECT_TYPE_POLYMORPH | HENCH_EFFECT_TYPE_WILDSHAPE);
    int bCheckForHealingAndCuringItems;
//  Jug_Debug(GetName(OBJECT_SELF) + " start exclude " + IntToString(gExcludedItemTalents) +  " spells " + IntToString(bAnySpellcastingClasses) + " arcane spell failure " + IntToString(bArcaneSpellFailure));
    if (bPolymorphed || !GetIsObjectValid(GetFirstItemInInventory()) || !GetCreatureUseItems(OBJECT_SELF))
    {
//      Jug_Debug(";;;;;;" + GetName(OBJECT_SELF) + " can't use items");
        gExcludedItemTalents |= TALENT_EXCLUDE_ITEM;
    }
    else if ((gExcludedItemTalents & TALENT_EXCLUDE_ITEM) && GetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE))
    {
        bCheckForHealingAndCuringItems = TRUE;
    }

    if (bPolymorphed)
    {
//          Jug_Debug(GetName(OBJECT_SELF) + " poly effects " + IntToHexString(positiveEffects));

        if (!(positiveEffects & HENCH_EFFECT_TYPE_WILDSHAPE) || !GetHasFeat(FEAT_NATURAL_SPELL))
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " exclude spells");
            gExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
        }

        gExcludedItemTalents |= TALENT_EXCLUDE_ABILITY;
/*
        no polymorph spell use in NWN2
        int polymorphShape = GetLocalInt(OBJECT_SELF, sPolymorphTypeStr);
        int polymorphSpellIndex;
        for (polymorphSpellIndex = 1; polymorphSpellIndex <= 3; polymorphSpellIndex++)
        {
            int polymorphSpell = StringToInt(Get2DAString("polymorph", "SPELL" + IntToString(polymorphSpellIndex), polymorphShape));
            if (polymorphSpell <= 0)
            {
                break;
            }
            HenchSpontaneousDispatch(polymorphSpell, TRUE);
        } */
/*
        no potion use in NWN2
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION); */
    }
    else if (GetHasSkill(SKILL_HEAL) &&
        ((!(gExcludedItemTalents & TALENT_EXCLUDE_ITEM)) || bCheckForHealingAndCuringItems) &&
        (gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE))
    {
        goHealingKit = GetBestHealingKit();
        if (GetIsObjectValid(goHealingKit))
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " checking healing kit " + GetName(goHealingKit));
            gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_HEALING_KIT;
            gsCurrentspInfo.spellID = HENCH_HEALING_KIT_ID;
            gsCurrentspInfo.otherID = -1;
            gsCurrentspInfo.spellInfo = HENCH_SPELL_INFO_TYPE_HEAL_SPECIAL | HENCH_SPELL_INFO_ITEM_FLAG;
            gsCurrentspInfo.spellLevel = 6;     // make this equivalent to a heal spell
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            gsCurrentspInfo.range = 4.0;

            HenchCheckHealSpecial();
        }
    }
	
	gbUseSpells = !(gExcludedItemTalents & TALENT_EXCLUDE_SPELL);
	gbUseAbilities = !(gExcludedItemTalents & TALENT_EXCLUDE_ABILITY);
	gbUseItems = !(gExcludedItemTalents & TALENT_EXCLUDE_ITEM);
	
	InitializeWarlockAttackSpells();
	InitializeSpellTalents();

    if (bCheckForHealingAndCuringItems)
    {
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
        FindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER);
    }

    if (gbUseAbilities)
    {
        InitializeFeats();
    }
}


void HenchDecrementSpontaneousSpell(int nSpellID)
{
	int originalCount = GetHasSpell(nSpellID);
	DecrementRemainingSpellUses(OBJECT_SELF, nSpellID);
	int newCount = GetHasSpell(nSpellID);
	
//	Jug_Debug(GetName(OBJECT_SELF) + " first spell decr result " + IntToString(newCount) + " orig " + IntToString(originalCount));
	
	if (newCount < originalCount)
	{	
		return;
	}
	
	int spellInfo = GetSpellInformation(nSpellID);
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	int spellCR = spellLevel * 2;
	
	int talentCategory;
	int highestLevelSpell = -1;
	int decrementSpellID;
	for (talentCategory = TALENT_CATEGORY_CANTRIP; talentCategory--; talentCategory >= 0)
	{	
        talent tBest = GetCreatureTalentBest(talentCategory, spellCR, OBJECT_SELF, HENCH_TALENT_USE_SPELLS_ONLY);
		if (GetIsTalentValid(tBest))
		{		
            int testSpellID = GetIdFromTalent(tBest);
//			Jug_Debug(GetName(OBJECT_SELF) + " found spell " + IntToString(testSpellID));
			int testSpellInfo = GetSpellInformation(testSpellID);
			int testSpellLevel = (testSpellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
			if (testSpellLevel > highestLevelSpell)
			{
				highestLevelSpell = testSpellLevel;
				decrementSpellID = testSpellID;
 				if (highestLevelSpell >= spellLevel)
				{
					break;
				}			
			}
		}
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " highest spell level " + IntToString(highestLevelSpell));
	if (highestLevelSpell >= 0)
	{	
		DecrementRemainingSpellUses(OBJECT_SELF, decrementSpellID);
//		Jug_Debug(GetName(OBJECT_SELF) + " decrementing " + IntToString(decrementSpellID));
	}
}


void HenchCheckPolymorphFeatDecrement(int featID)
{
	if (GetHasEffect(EFFECT_TYPE_POLYMORPH))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " current feat uses " + IntToString(GetHasFeat(featID)));
		DecrementRemainingFeatUses(OBJECT_SELF, featID);
//		Jug_Debug(GetName(OBJECT_SELF) + " new feat uses " + IntToString(GetHasFeat(featID)));
	}
/*	else
	{
		Jug_Debug(GetName(OBJECT_SELF) + " doesn't have polymorph effect");
	} */
}


void HenchCastSpell(struct sSpellInformation spInfo)
{
	int castingType = spInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK;
    if ((castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK) &&
        (spInfo.otherID == SPELL_I_HIDEOUS_BLOW))
    {
		object oRightHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        HenchEquipAppropriateWeapons(spInfo.oTarget, 100.0, FALSE, FALSE);
        if (GetWeaponRanged(oRightHandWeapon))
        {
            ActionWait(1.0);
        }
        else if (GetHasEffect(EFFECT_TYPE_HIDEOUS_BLOW))
        {
            if ((GetCurrentAction() != ACTION_ATTACKOBJECT) ||
                (GetAttackTarget(OBJECT_SELF) != spInfo.oTarget))
            {
                ClearAllActions();
                ActionAttack(spInfo.oTarget);
            }
            return;
        }
    }
	else
	{
    	ClearAllActions();
	}

//	Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell " + IntToString(spInfo.spellID) + " " + Get2DAString("spells", "Label", spInfo.spellID) + " other "  + IntToString(spInfo.otherID) + " casting info " + IntToString(spInfo.castingInfo));

    switch (spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK)
    {
    case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
    case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
    case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
    case HENCH_SPELL_INFO_TYPE_HEAL_SPECIAL:
        if (spInfo.oTarget == OBJECT_SELF && GetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_CANT)
        {
            if (bgAnyValidTarget && (gsBestSelfInvisibility.spellID > 0))
            {
                    // become invisible
                spInfo = gsBestSelfInvisibility;
                spInfo.oTarget = OBJECT_SELF;
            }
            // indicate to others that going to heal self
            SetLocalInt(OBJECT_SELF, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_IN_PROG);
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
        SetLocalInt(OBJECT_SELF, henchLastDispelStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
        if (spInfo.range == 0.0)
        {
            spInfo.oTarget = OBJECT_SELF;
        }
        else
        {
            spInfo.oTarget = OBJECT_INVALID;
            spInfo.lTargetLoc =  GetSummonLocation(spInfo.range);
        }
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
       SetLocalInt(OBJECT_SELF, henchLastDraBrStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
//     Jug_Debug("@@@@" + GetName(OBJECT_SELF) + " doing dragon breath");
       break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
        SetLocalInt(OBJECT_SELF, henchLastDomStr, GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
        SetLocalInt(OBJECT_SELF, henchLastTurnStr,  GetLocalInt(OBJECT_SELF, henchCombatRoundStr));
        break;
    }

    if (bgMeleeAttackers && !GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
    {
        EquipShield(FALSE);
    }

    if (bgEnableMoveAway && GetIsObjectValid(spInfo.oTarget) && ((((spInfo.shape == HENCH_SHAPE_NONE) &&
        ((spInfo.range > 5.0) || (spInfo.oTarget == OBJECT_SELF)))) || (spInfo.castingInfo & HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG)))
    {
//      Jug_Debug(GetName(OBJECT_SELF) + " move away for spell " + IntToString(spInfo.spellID) + " " + Get2DAString("spells", "Label", spInfo.spellID) + " other "  + IntToString(spInfo.otherID));
        bgEnableMoveAway = FALSE;
        if (spInfo.oTarget == OBJECT_SELF)
        {
            if (MoveAwayFromEnemies(ogClosestSeenOrHeardEnemy, 9.0))
            {
                HenchStartCombatRoundAfterAction(OBJECT_INVALID);
                return;
            }
        }
        else
        {
            if (MoveAwayFromEnemies(spInfo.oTarget, spInfo.range > 10.0 ? 8.0 : spInfo.range - 1.0))
            {
                HenchStartCombatRoundAfterAction(spInfo.oTarget);
                return;
            }
        }
    }

//  Jug_Debug(GetName(OBJECT_SELF) + " def casting mode is " + IntToString(GetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST)) + " melee attackers " + IntToString(bgMeleeAttackers));

    if ((spInfo.spellInfo & HENCH_SPELL_INFO_CONCENTRATION_FLAG) &&
        !(spInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG))
    {
		if (!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED))
		{
	        int bCurrentDefCastMode = GetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST);
	        int bNewDefCastMode = bgMeleeAttackers && (Getd20Chance(nMySpellCastingConcentration - 15 - spInfo.spellLevel) > 0.67);
	
//      	Jug_Debug(GetName(OBJECT_SELF) + " check def casting old " + IntToString(bCurrentDefCastMode) + " new " + IntToString(bNewDefCastMode) + " chance " + FloatToString(Getd20Chance(nMySpellCastingConcentration - 15 - spInfo.spellLevel)));
	
	        if (bCurrentDefCastMode != bNewDefCastMode)
	        {
//      		Jug_Debug(GetName(OBJECT_SELF) + " change def casting");
	            SetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST, bNewDefCastMode);
	        }
			if (!bNewDefCastMode)
			{
				if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE))
				{
					if (!GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
					{
	            		SetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, TRUE);
					}
				}
				else if (GetHasFeat(FEAT_COMBAT_EXPERTISE))
				{		
					if (!GetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE))
					{
	            		SetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE, TRUE);
					}
				}
			}
		}
    }

    if (castingType == HENCH_CASTING_INFO_USE_SPELL_TALENT)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
//  Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell on object " + IntToString(spInfo.spellID) + " on " + GetName(spInfo.oTarget));
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            ActionUseTalentOnObject(spInfo.tTalent, spInfo.oTarget);
        }
        else
        {
//  Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast spell at location " + IntToString(spInfo.spellID));
            ActionUseTalentAtLocation(spInfo.tTalent, spInfo.lTargetLoc);
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_FEATID)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            if (spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG)
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat cheat on object " + IntToString(spInfo.otherID) + " on " + GetName(spInfo.oTarget));
                ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, METAMAGIC_NONE, TRUE);				
				if ((spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK) == HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH)
				{
//					Jug_Debug(GetName(OBJECT_SELF) + " polymorph option");
					DelayCommand(4.5, HenchCheckPolymorphFeatDecrement(spInfo.otherID));
				}
				else
				{				
                	ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, spInfo.otherID));
				}
            }
            else
            {
//				Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat on object " + IntToString(spInfo.otherID) + " on " + GetName(spInfo.oTarget));
                ActionUseFeat(spInfo.otherID, spInfo.oTarget);
            }
        }
        else
        {
//			Jug_Debug(GetName(OBJECT_SELF) + " attempt to cast feat at location " + IntToString(spInfo.spellID));
            ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, METAMAGIC_NONE, TRUE);
            ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, spInfo.otherID));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
        }
        if (spInfo.otherID > 0)
        {
            int nMetamagicEssence = METAMAGIC_NONE;
            switch (spInfo.spellID)
            {
            case SPELL_I_FRIGHTFUL_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_FRIGHTFUL_BLAST;
                break;
            case SPELL_I_DRAINING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_DRAINING_BLAST;
                break;
            case SPELL_I_BESHADOWED_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BESHADOWED_BLAST;
                break;
            case SPELL_I_BRIMSTONE_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BRIMSTONE_BLAST;
                break;
            case SPELL_I_HELLRIME_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_HELLRIME_BLAST;
                break;
            case SPELL_I_BEWITCHING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BEWITCHING_BLAST;
                break;
            case SPELL_I_NOXIOUS_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_NOXIOUS_BLAST;
                break;
            case SPELL_I_VITRIOLIC_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_VITRIOLIC_BLAST;
                break;
            case SPELL_I_UTTERDARK_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_UTTERDARK_BLAST;
                break;
			case 1131:	// binding blast
                nMetamagicEssence = METAMAGIC_INVOC_BINDING_BLAST;
                break;			
			case 1130:	// hindering blast
                nMetamagicEssence = METAMAGIC_INVOC_HINDERING_BLAST;
                break;
            }
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting " + IntToString(spInfo.otherID) + " meta " + IntToString(nMetamagicEssence) + " meta spell " + IntToString(spInfo.spellID));
            if (GetIsObjectValid(spInfo.oTarget))
            {
				if ((spInfo.otherID == SPELL_I_HIDEOUS_BLOW) && GetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT))
				{
					// make hideous blow instance so it doesn' take two rounds
//					Jug_Debug(GetName(OBJECT_SELF) + " use hideous blow");
                	ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
				}
				else
				{
                	ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence);
				}
            }
            else
            {
                ActionCastSpellAtLocation(spInfo.otherID, spInfo.lTargetLoc, nMetamagicEssence);
            }
        }
        else if (spInfo.spellID != SPELLABILITY_I_ELDRITCH_BLAST)
        {
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting " + IntToString(spInfo.spellID));
            ActionCastSpellAtObject(spInfo.spellID,  spInfo.oTarget);
        }
        else
        {
            int nFeat = GetBestEldritchBlastFeat();
//          Jug_Debug(GetName(OBJECT_SELF) + " warlock casting feat " + IntToString(nFeat));
            ActionUseFeat(nFeat, spInfo.oTarget);
        }
    }
    else if ((castingType == HENCH_CASTING_INFO_USE_SPELL_REGULAR) ||
		(castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT))
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " attempt to cast spontaneous spell on object " + IntToString(spInfo.spellID) + " on " + GetName(spInfo.oTarget));
            SetLocalObject(OBJECT_SELF, sLastSpellTargetObject, spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(OBJECT_SELF, sHenchLastTarget, spInfo.oTarget);
            }
            ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, spInfo.otherID, spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG);
        }
        else
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " attempt to cast spontaneous spell at location " + IntToString(spInfo.spellID));
            ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, spInfo.otherID, spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG);
        }
        if (castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT)
        {
//  Jug_Debug("^^^^^^^^" + GetName(OBJECT_SELF) + " decrementing spell " + IntToString(spInfo.spellID));
            int nMainSpell = spInfo.spellID;
            ActionDoCommand(HenchDecrementSpontaneousSpell(nMainSpell));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_HEALING_KIT)
    {
        ActionUseSkill(SKILL_HEAL, spInfo.oTarget, 0, goHealingKit);
    }
}


int HenchCheckSpellToCast(int currentRound, int bTestOnly)
{
//  Jug_Debug(GetName(OBJECT_SELF) + " attack target weight " + FloatToString(gfTargetWeight));

    HenchGetBestDispelTarget();

    struct sSpellInformation spInfo;
    int bFound;
	
	// check best option for invisibility and
	// check if some pending buff or early rounds with sneak attacks and melee attack chosen	
	if ((gsBestSelfHide.spellID > 0) && (((bfBuffTargetAccumWeight > gfAttackTargetWeight) && 
		(giNumberOfPendingBuffs > 2)) || ((currentRound < 3) &&
		GetHasFeat(FEAT_SNEAK_ATTACK) && (gsAttackTargetInfo.spellID < 0))))
	{
        spInfo = gsBestSelfHide;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsAttackTargetInfo.spellID >= 0) && (gfAttackTargetWeight >= gfBuffTargetWeight))
    {
        spInfo = gsAttackTargetInfo;
        bFound = TRUE;
    }
    else if ((gsBuffTargetInfo.spellID >= 0) && (gfBuffTargetWeight > gfAttackTargetWeight))
    {
        spInfo = gsBuffTargetInfo;
        bFound = TRUE;
    }
    else if ((gsMeleeAttackspInfo.spellID > 0) && (GetConcetrationWeightAdjustment(gsMeleeAttackspInfo.spellInfo, gsMeleeAttackspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsMeleeAttackspInfo;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsDelayedAttrBuff.spellID > 0) && (GetConcetrationWeightAdjustment(gsDelayedAttrBuff.spellInfo, gsDelayedAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsDelayedAttrBuff;
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }
    else if ((gsPolymorphspInfo.spellID > 0) && (GetConcetrationWeightAdjustment(gsPolymorphspInfo.spellInfo, gsPolymorphspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        if ((gsPolyAttrBuff.spellID > 0) && (GetConcetrationWeightAdjustment(gsPolyAttrBuff.spellInfo, gsPolyAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
        {
            spInfo = gsPolyAttrBuff;
        }
        else
        {
            spInfo = gsPolymorphspInfo;
        }
        spInfo.oTarget = OBJECT_SELF;
        bFound = TRUE;
        bgEnableMoveAway = FALSE;
    }

    if (bFound)
    {
        if (!bTestOnly)
        {
            HenchCastSpell(spInfo);
        }
        return TRUE;
    }

    return FALSE;
}


int CheckAOEForSelf(int currentNegEffects, int currentPosEffects)
{
    struct sPersistSpellInfo sPersistInfo = GetAOEProblem(currentNegEffects, currentPosEffects);
    object oAOEProblem = sPersistInfo.oPersistSpell;

    if (!GetIsObjectValid(oAOEProblem))
    {
        return FALSE;
    }
//  Jug_Debug("(((((((((" + GetName(OBJECT_SELF) + " has problem with " + GetName(oAOEProblem));

    int bUseDispel = TRUE;

    if (GetObjectType(oAOEProblem) == OBJECT_TYPE_CREATURE)
    {
        if (GetFactionEqual(oAOEProblem) || GetIsFriend(oAOEProblem))
        {
            bUseDispel = FALSE;
        }
    }
    else
    {
        if (GetFactionEqual(GetAreaOfEffectCreator(oAOEProblem)) || GetIsFriend(GetAreaOfEffectCreator(oAOEProblem)))
        {
            bUseDispel = FALSE;
        }
    }
    if (bUseDispel && (gsGustOfWind.spellID > 0))
    {
/*        if (GetObjectType(oAOEProblem) == OBJECT_TYPE_CREATURE)
        {
            gsGustOfWind.oTarget = oAOEProblem;
            HenchCastSpell(gsGustOfWind);
            return TRUE;
        } */
        gsGustOfWind.oTarget = OBJECT_INVALID;
        gsGustOfWind.lTargetLoc = FindBestDispelLocation(oAOEProblem);
        HenchCastSpell(gsGustOfWind);
        return TRUE;
    }
    if (bUseDispel && (gsBestDispel.spellID > 0) && !GetLocalInt(OBJECT_SELF, sHenchDontDispel))
    {
        if (GetObjectType(oAOEProblem) == OBJECT_TYPE_CREATURE)
        {
            gsBestDispel.oTarget = oAOEProblem;
            HenchCastSpell(gsBestDispel);
            return TRUE;
        }
        gsBestDispel.oTarget = OBJECT_INVALID;
        gsBestDispel.lTargetLoc = FindBestDispelLocation(oAOEProblem);
        HenchCastSpell(gsBestDispel);
        return TRUE;
    }
/*    if (bInDarkness)
    {
        if (GetHasFixedSpell(SPELL_TRUE_SEEING))
        {
            CastFixedSpellOnObject(SPELL_TRUE_SEEING, OBJECT_SELF, 5);
            return TRUE;
        }
        if (GetHasFixedSpell(SPELL_DARKVISION))
        {
            CastFixedSpellOnObject(SPELL_DARKVISION, OBJECT_SELF, 2);
            return TRUE;
        }
    } */
    if (!bgMeleeAttackers && !sPersistInfo.bDisableMoveAway && !(currentNegEffects & HENCH_EFFECT_IMMOBILE))
    {
            // run away if no melee attackers
        ActionMoveAwayFromLocation(GetLocation(oAOEProblem), TRUE, 10.0);
        return TRUE;
    }
    return FALSE;
}
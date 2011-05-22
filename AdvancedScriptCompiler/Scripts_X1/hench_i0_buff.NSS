/*

    Companion and Monster AI

    This file contains routines that are used for buffing and protecting creatures. Uses defines
    and functions in hench_i0_spells and is called by hench_i0_itemsp.

*/

#include "hench_i0_spells"


// test general buff spell
void HenchCheckBuff();

// check melee attacker threat to self
void HenchInitMeleeAttackers();

// test mage armor type spells (stoneskin, etc.)
void HenchCheckACBuff();

// test if damage reduction spells (stoneskin, etc.) should be used
void HenchCheckDRBuff();

// test if spell protections should be used
void HenchCheckSpellProtections();

// test melee attack option, not cast unless no other choice but to go melee
void HenchMeleeAttackBuff();

// get energy immunity and resistances weight for a target
float HenchGetEnergyImmunityWeight(object oTarget, int baseImmunityFlags);

// test elemental or death shield spell option
void HenchCheckElementalShield();

// test energy spell protection spell option
void HenchCheckEnergyProt();

// test attribute buff spell option
void HenchCheckAttrBuff();

// determine best location to summon creature at
location GetSummonLocation(float spellRange);

// determine best object to summon creature at
object GetSummonObject(float spellRange);

// test summon spell option
void HenchCheckSummons();

// test prot. from evil spell option
void HenchCheckProtEvil();

// test prot. from good spell option
void HenchCheckProtGood();

// test weapon buffing spell option
void HenchCheckWeaponBuff();

// test polymorph spell option
void HenchCheckPolymorph();

// test concealment or invisibility with concealment spell
void HenchCheckConcealment(float fConcealAmount, float fWeight);

// test concealment spell
void HenchConcealment();

// test buffing animal companion
void HenchCheckAnimalCompanionBuff();

// test to determine if should become invisible
void HenchCheckInvisibility();


const float attributeHighBuffScale = 0.05;
const float attributeMedBuffScale = 0.04;
const float attributeLowBuffScale = 0.025;


void HenchCheckBuff()
{
    int saveType = GetCurrentSpellSaveType();
//	Jug_Debug(GetName(OBJECT_SELF) + " checking buff " + IntToString(gsCurrentspInfo.spellID) + " shape " + IntToString(gsCurrentspInfo.shape) + " st " + IntToHexString(saveType));

    int effectTypes = GetCurrentSpellEffectTypes();

    if (effectTypes == HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE)
    {
        if (!HenchUseSpellProtections())
        {
    //  Jug_Debug("?????????????" + GetName(OBJECT_SELF) + " skipping prot spells");
            return;
        }
    }
    int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
//  int nItemProp =  (saveType & HENCH_SPELL_SAVE_TYPE_SAVES_MASK) >> 18;

    float effectWeight = GetCurrentSpellEffectWeight();

    object oFriend;
    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
//  Jug_Debug(GetName(OBJECT_SELF) + " not self");
        oFriend = GetLocalObject(OBJECT_SELF, henchAllyStr);
    }
    else
    {
        oFriend = OBJECT_SELF;
    }

	int spellShape = gsCurrentspInfo.shape;
	float spellRadius =  gsCurrentspInfo.radius;

    int iLoopLimit = ((spellShape == HENCH_SHAPE_NONE) && (gsCurrentspInfo.range == 0.0)) ? 1 : 10;
	
	if (spellShape != HENCH_SHAPE_NONE)
	{
		// for an area of effect spell (i.e. bless), don't cast if you already have the effect
		if (GetHasSpellEffect(gsCurrentspInfo.spellID, OBJECT_SELF))
		{
			return;
		}	
	}
    int curLoopCount = 1;

    float maxEffectWeight;

//	Jug_Debug(GetName(OBJECT_SELF) + " checking buff " + IntToString(gsCurrentspInfo.spellID) + " immunity " + IntToHexString(immunity1) + " effect " + IntToHexString(effectTypes) + " weight " + FloatToString(effectWeight) + " starting target " + GetName(oFriend));

    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
//		Jug_Debug("||" + GetName(OBJECT_SELF) + " testing buff target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
        int  skip;
        if (spellShape == HENCH_SHAPE_FACTION)
        {
            skip = !GetFactionEqual(oFriend);
        }
        else if (spellShape != HENCH_SHAPE_NONE)
        {
            skip = GetDistanceToObject(oFriend) > spellRadius;
        }
        if (!skip)
        {
//			Jug_Debug("||" + GetName(OBJECT_SELF) + " testing buff target 2 " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
            float curEffectWeight = effectWeight;
            if (!immunity1 || !GetIsImmune(oFriend, immunity1))
            {
                if (effectTypes != 0)
                {
//					Jug_Debug("||" + GetName(OBJECT_SELF) + " testing buff target 3 " + GetName(oFriend) + " pos effects result " + IntToHexString(GetCreaturePosEffects(oFriend)));
                    int maskResult = GetCreaturePosEffects(oFriend) & effectTypes;
//					Jug_Debug("||" + GetName(OBJECT_SELF) + " testing buff target " + GetName(oFriend) + " mask result " + IntToHexString(maskResult));
                    if (maskResult == effectTypes)
                    {
                        skip = TRUE;
                    }
                    else if (maskResult != 0)
                    {
                        curEffectWeight /= 2.0;
                    }
                }
                if (!skip)
                {
                       // found target
                    curEffectWeight *= GetThreatRating(oFriend);
                    if (oFriend == OBJECT_SELF)
                    {
                        curEffectWeight *= gfBuffSelfWeight;
                    }
                    else
                    {
                        // adjust for compassion
                        curEffectWeight *= gfBuffOthersWeight;
                    }

//					Jug_Debug("use target " + GetName(oFriend) + " weight " + FloatToString(curEffectWeight));

                    maxEffectWeight += curEffectWeight;

                    if (spellShape == HENCH_SHAPE_NONE)
                    {
                        break;
                    }
                }
            }
        }
        oFriend = GetLocalObject(oFriend, henchAllyStr);
        curLoopCount ++;
    }

    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfHighestSpellLevelToCast(maxEffectWeight, spellShape != HENCH_SHAPE_NONE ? OBJECT_SELF : oFriend);
    }
}


const string friendMeleeTargetStr = "HenchMeleeTarget";
const string friendMeleeWeaponTargetStr = "HenchMeleeWeaponTarget";

int gbMeleeTargetInit;
int gbIAmMeleeTarget;

void HenchInitMeleeAttackers()
{
    if (gbMeleeTargetInit)
    {
        return;
    }
    gbMeleeTargetInit = 1;
    DeleteLocalObject(OBJECT_SELF, friendMeleeTargetStr);
    DeleteLocalFloat(OBJECT_SELF, friendMeleeTargetStr);
	DeleteLocalObject(OBJECT_SELF, friendMeleeWeaponTargetStr);
    float fDistanceThreshold = bgMeleeAttackers ? 5.0 : 20.0;

    object oEnemy = GetLocalObject(OBJECT_SELF, sLineOfSight);
    while (GetIsObjectValid(oEnemy))
    {
        object oFriend = GetAttackTarget(oEnemy);		
//		Jug_Debug(GetName(OBJECT_SELF) + " enemy " + GetName(oEnemy) + " is attacking " + GetName(oFriend));		
        if (GetIsObjectValid(oFriend) && ((gbMeleeTargetInit < 6) || oFriend == OBJECT_SELF) &&
            (GetDistanceToObject(oFriend) < fDistanceThreshold))
        {
            int nAssocType = GetAssociateType(oFriend);
            if (oFriend == OBJECT_SELF || (nAssocType != ASSOCIATE_TYPE_DOMINATED &&
                nAssocType != ASSOCIATE_TYPE_SUMMONED && nAssocType != ASSOCIATE_TYPE_FAMILIAR))
            {
                object oList = OBJECT_SELF;
                while (GetIsObjectValid(oList))
                {
                    if (oList == oFriend)
                    {
                        break;
                    }
                    oList = GetLocalObject(oList, friendMeleeTargetStr);
                }
                float currentValue;
                if (GetIsObjectValid(oList))
                {
                    currentValue = GetLocalFloat(oFriend, friendMeleeTargetStr);
                }
                else
                {
                    oList = GetLocalObject(OBJECT_SELF, friendMeleeTargetStr);
                    SetLocalObject(oFriend, friendMeleeTargetStr, oList);
                    SetLocalObject(OBJECT_SELF, friendMeleeTargetStr, oFriend);
                    gbMeleeTargetInit ++;					
					
                	DeleteLocalObject(oFriend, friendMeleeWeaponTargetStr);
                }
				float meleeChance = Getd20ChanceLimited(GetBaseAttackBonus(oEnemy) +
                    GetAttackBonus(oEnemy, oFriend).attackBonus - GetAC(oFriend) + 21);
//				Jug_Debug(GetName(OBJECT_SELF) + " enemy " + GetName(oEnemy) + " melee chance " + FloatToString(meleeChance));		
				if (!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy)))
				{
					meleeChance *= (1.0 - GetLocalFloat(oFriend, meleeConcealmentStr));				
                	object oFirstEnemy = GetLocalObject(oFriend, friendMeleeWeaponTargetStr);
                	SetLocalObject(oFriend, friendMeleeWeaponTargetStr, oEnemy);
                	SetLocalObject(oEnemy, friendMeleeWeaponTargetStr, oFirstEnemy);				
                	SetLocalFloat(oEnemy, friendMeleeWeaponTargetStr, meleeChance);
				}
				else
				{
					meleeChance *= (1.0 - GetLocalFloat(oFriend, rangedConcealmentStr));				
				}
                currentValue += (1.0 - currentValue) * meleeChance;
                SetLocalFloat(oFriend, friendMeleeTargetStr, currentValue);
                if (oFriend == OBJECT_SELF)
                {
                    gbIAmMeleeTarget++;
                }
            }
        }
        oEnemy = GetLocalObject(oEnemy, sLineOfSight);
    }
//  Jug_Debug(GetName(OBJECT_SELF) + " found melee target friends " + IntToString(gbMeleeTargetInit));

/*  object oFriend = OBJECT_SELF;
    while (GetIsObjectValid(oFriend))
    {
        Jug_Debug(GetName(OBJECT_SELF) + " friend " + GetName(oFriend) + " is melee target chance " + FloatToString( GetLocalFloat(oFriend, friendMeleeTargetStr)));
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }   */
}


const int HENCH_AC_CHECK_ARMOR						= 1;
const int HENCH_AC_CHECK_SHIELD						= 2;
const int HENCH_AC_CHECK_EQUIPPED_ITEMS				= 0xf;
const int HENCH_AC_CHECK_MOVEMENT_SPEED_DECREASE	= 0x10000000;

void HenchCheckACBuff()
{
//  Jug_Debug(GetName(OBJECT_SELF) + " HenchCheckACBuff " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " " + IntToString(gsCurrentspInfo.spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel));
    HenchInitMeleeAttackers();

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

	int spellID = gsCurrentspInfo.spellID;
    int saveType = GetCurrentSpellSaveType();
    int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
    int amount = GetCurrentSpellBuffAmount(bFoundItemSpell ? (gsCurrentspInfo.spellLevel * 2) - 1 : nMySpellCasterLevel);
    int acType =  (saveType & HENCH_SPELL_SAVE_TYPE_SAVES_MASK) >> 18;
    float effectWeight = GetCurrentSpellEffectWeight();
	int checkItems = GetCurrentSpellSaveDCType();
	int checkMoveSpeedDecrease = checkItems & HENCH_AC_CHECK_MOVEMENT_SPEED_DECREASE;
	checkItems = checkItems & HENCH_AC_CHECK_EQUIPPED_ITEMS;

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = OBJECT_SELF;

    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }

//  Jug_Debug(GetName(OBJECT_SELF) + " checking ac buff " + IntToString(spellID) + " amount " + IntToString(amount) + " ac type " + IntToString(acType) + " weight " + FloatToString(effectWeight));

    while (GetIsObjectValid(oFriend))
    {
        int curACBonus = amount;
		
		if (checkItems)
		{
	        if (checkItems == HENCH_AC_CHECK_ARMOR)
	        {
	            object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oFriend);
	            if (!GetIsObjectValid(oArmor) || (GetBaseItemType(oArmor) != BASE_ITEM_ARMOR))
	            {
	                curACBonus = 0;
	            }
	        }
			else
			{
				object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oFriend);
				if (!GetIsObjectValid(oShield) || (GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD &&
					GetBaseItemType(oShield) != BASE_ITEM_SMALLSHIELD &&
					GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD))
				{
	                curACBonus = 0;
	            }
			}
		}
        if (checkMoveSpeedDecrease && !GetIsImmune(oFriend, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
        {
			if (!bgMeleeAttackers || (GetPercentageHPLoss(oFriend) > 30))
			{
            	curACBonus = 0;
			}
        }		
        if (curACBonus > 0)
		{
			if (acType != AC_DODGE_BONUS)
			{
				if (GetCreaturePosEffects(oFriend) & HENCH_EFFECT_TYPE_AC_INCREASE)
		        {
		            curACBonus -= GetCreatureACBonus(oFriend, acType);
		        }
			}
			else if (GetHasSpellEffect(spellID, oFriend))
			{				
				curACBonus = 0;
			}
		}
        if (curACBonus > 1)
        {
            float targetChance = GetLocalFloat(oFriend, friendMeleeTargetStr);
            if (oFriend == OBJECT_SELF && targetChance < 0.01)
            {
//          Jug_Debug("||" + GetName(OBJECT_SELF) + " setting melee ac buff target " + GetName(oFriend) + " spell " + IntToString(spellID));
                if ((gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel))
                {
                    gsMeleeAttackspInfo = gsCurrentspInfo;
                }
            }
            else
            {
//          Jug_Debug("||" + GetName(OBJECT_SELF) + " testing ac buff target " + GetName(oFriend) + " spell " + IntToString(spellID));
                float curEffectWeight = effectWeight * curACBonus * targetChance;

                    // found target
                curEffectWeight *= GetThreatRating(oFriend);
                if (oFriend == OBJECT_SELF)
                {
                    curEffectWeight *= gfBuffSelfWeight;
                }
                else
                {
                    // adjust for compassion
                    curEffectWeight *= gfBuffOthersWeight;
                }

                if (curEffectWeight > maxEffectWeight)
                {
//          Jug_Debug(GetName(OBJECT_SELF) + " doing ac buff " + IntToString(spellID) + " weight " + FloatToString(curEffectWeight));
                    maxEffectWeight = curEffectWeight;
                    oBestFriend = oFriend;
                }
            }
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }
    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


void HenchCheckDRBuff()
{
    HenchInitMeleeAttackers();
	
//	Jug_Debug(GetName(OBJECT_SELF) + " start checking dr buff " + IntToString(gsCurrentspInfo.spellID) + " melee target " + IntToString(gbIAmMeleeTarget));

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

    int saveType = GetCurrentSpellSaveType();
    float effectWeight = GetCurrentSpellEffectWeight();

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = OBJECT_SELF;

    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }

//	Jug_Debug(GetName(OBJECT_SELF) + " checking dr buff " + IntToString(gsCurrentspInfo.spellID) + " weight " + FloatToString(effectWeight));

    while (GetIsObjectValid(oFriend))
    {
        if (!(GetCreaturePosEffects(oFriend) & HENCH_EFFECT_TYPE_DAMAGE_REDUCTION))
        {
            float targetChance = GetLocalFloat(oFriend, friendMeleeTargetStr);
            if (oFriend == OBJECT_SELF && targetChance < 0.01)
            {
//				Jug_Debug("||" + GetName(OBJECT_SELF) + " setting melee ac buff target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
                if ((gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel))
                {
                    gsMeleeAttackspInfo = gsCurrentspInfo;
                }
            }
            else
            {
//				Jug_Debug("||" + GetName(OBJECT_SELF) + " testing dr buff target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
                float curEffectWeight = effectWeight * targetChance;
                    // found target
                curEffectWeight *= GetThreatRating(oFriend);
                if (oFriend == OBJECT_SELF)
                {
                    curEffectWeight *= gfBuffSelfWeight;
                }
                else
                {
                    // adjust for compassion
                    curEffectWeight *= gfBuffOthersWeight;
                }
                if (curEffectWeight > maxEffectWeight)
                {
//					Jug_Debug(GetName(OBJECT_SELF) + " doing dr buff " + IntToString(gsCurrentspInfo.spellID) + " weight " + FloatToString(curEffectWeight));
                    maxEffectWeight = curEffectWeight;
                    oBestFriend = oFriend;
                }
            }
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }
    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


void HenchCheckSpellProtections()
{
    if (!HenchUseSpellProtections())
    {
//  Jug_Debug("?????????????" + GetName(OBJECT_SELF) + " skipping prot spells");
        return;
    }

    int protMask = GetCurrentSpellEffectTypes();

    float maxEffectWeight = GetThreatRating(goBestSpellCaster) * 0.9;

//  Jug_Debug("?????????????" + GetName(OBJECT_SELF) + " checking prot spells " + IntToString(gsCurrentspInfo.spellID) + " prot mask " + IntToString(protMask) + " weight " + FloatToString(maxEffectWeight));

    object oBestTarget;

    int estResistance = 12 + (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? 9 : nMySpellCasterLevel;
    estResistance *= 2;
    estResistance /= 3;

    object oFriend = OBJECT_SELF;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 10;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
//      Jug_Debug("%%" + GetName(OBJECT_SELF) + " testing spell prot target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));

        if (curLoopCount == 2)
        {
            // adjust for compassion
            maxEffectWeight *= gfBuffOthersWeight;
        }

        if (protMask == 0)
        {
            if (GetSpellResistance(oFriend) < estResistance)
            {
                oBestTarget = oFriend;
                break;
            }
        }
        else
        {
            if (!(GetCreaturePosEffects(oFriend) & protMask))
            {
                oBestTarget = oFriend;
                break;
            }
        }
        oFriend = GetLocalObject(oFriend, henchAllyStr);
        curLoopCount ++;
    }
    if (GetIsObjectValid(oBestTarget))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " doing spell prot " + IntToString(gsCurrentspInfo.spellID) + " weight " + FloatToString(maxEffectWeight));
        HenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}


struct sSpellInformation gsMeleeAttackspInfo;

void GetMeleeAttackInfo()
{
    if (!(bgMeleeAttackers || gbDoingBuff))
    {
        return;
    }
	int spellID = gsCurrentspInfo.spellID;
    if ((spellID == SPELL_RIGHTEOUS_MIGHT) ||
        (spellID == 803 /* for feat enlarge */))
    {
        if (HasSizeIncreasingSpellEffect(OBJECT_SELF))
        {
            return;
        }
    }
    if ((gsCurrentspInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK) == HENCH_CASTING_INFO_USE_SPELL_TALENT)
    {
        if (!GetHasSpellEffect(spellID) && (gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel))
        {
            gsMeleeAttackspInfo = gsCurrentspInfo;
        }
    }
    else if ((gsCurrentspInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK) == HENCH_CASTING_INFO_USE_SPELL_FEATID)
    {
//  	Jug_Debug("******" + GetName(OBJECT_SELF) + " testing feat " + IntToString(gsCurrentspInfo.otherID) + " spell " +  IntToString(GetHasSpellEffect(spellID)));
        if (!GetHasSpellEffect(spellID))
        {
            gsMeleeAttackspInfo = gsCurrentspInfo;
        }
    }
}


void HenchMeleeAttackBuff()
{
//  Jug_Debug("||" + GetName(OBJECT_SELF) + " testing melee attack buff spell " + IntToString(gsCurrentspInfo.spellID));

    object oBestFriend = OBJECT_SELF;
    float maxEffectWeight;

    object oFriend = OBJECT_SELF;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
    int curLoopCount = 1;
    float effectWeight = GetCurrentSpellEffectWeight();

    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
//      Jug_Debug("||" + GetName(OBJECT_SELF) + " testing melee attack target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
        int posEffects = GetCreaturePosEffects(oFriend);
        int bMeleeChar = (posEffects & HENCH_EFFECT_TYPE_POLYMORPH) ||
            (GetBaseAttackBonus(oFriend) >= (3 * GetHitDice(oFriend) / 4));

        object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
        int bRanged = GetWeaponRanged(oRightWeapon);

        if (!bRanged && (GetIsHumanoid(GetRacialType(oFriend)) ||
            (GetSubRace(oFriend) == RACIAL_SUBTYPE_GITHYANKI) ||
            (GetSubRace(oFriend) == RACIAL_SUBTYPE_GITHZERAI)) &&
            !HasSizeIncreasingSpellEffect(oFriend))
        {
//      	Jug_Debug("||" + GetName(OBJECT_SELF) + " testing 2 melee attack target " + GetName(oFriend) + " spell " + IntToString(gsCurrentspInfo.spellID));
            if (bMeleeChar)
            {
                float adjustment;
                if (curLoopCount == 1)
                {
                    adjustment = gfBuffSelfWeight;
                }
                else
                {
                    adjustment = gfBuffOthersWeight;
                }
                float curEffectWeight = GetThreatRating(oFriend) * effectWeight * adjustment;
                if (curEffectWeight > maxEffectWeight)
                {
                    oBestFriend = oFriend;
                    maxEffectWeight = curEffectWeight;
                }
            }
            else if (oFriend == OBJECT_SELF)
            {
                GetMeleeAttackInfo();
            }
        }
        oFriend = GetLocalObject(oFriend, henchAllyStr);
        curLoopCount ++;
    }

    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


const int HENCH_IMMUNITY_WEIGHT_AMOUNT_MASK = 0xff000;
const int HENCH_IMMUNITY_WEIGHT_AMOUNT_SHIFT = 12;
const int HENCH_IMMUNITY_WEIGHT_RESISTANCE = 0x100000;
const int HENCH_IMMUNITY_ONLY_ONE = 0x200000;
const int HENCH_IMMUNITY_GENERAL = 0x400000;

float HenchGetEnergyImmunityWeight(object oTarget, int baseImmunityFlags)
{
	int resistanceFlag = baseImmunityFlags & HENCH_IMMUNITY_WEIGHT_RESISTANCE;	
	int resistanceAmount = (baseImmunityFlags & HENCH_IMMUNITY_WEIGHT_AMOUNT_MASK) >> HENCH_IMMUNITY_WEIGHT_AMOUNT_SHIFT;
	int damageTypeInfo = baseImmunityFlags & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;
	
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchGetEnergyImmunityWeight " + IntToHexString(baseImmunityFlags) + " for target " + GetName(oTarget) + " amount " + IntToString(resistanceAmount));	

	float testDamageAmount;
	if (resistanceFlag)
	{
		testDamageAmount = IntToFloat(resistanceAmount);
	}
	else
	{
		testDamageAmount = 100.0;
	}	
	float curEffectWeight;
	int numDamageTypes;
	if (baseImmunityFlags & HENCH_IMMUNITY_ONLY_ONE)
	{
		curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, damageTypeInfo, 1);
		numDamageTypes ++;	
	}
	else
	{
		if (damageTypeInfo & DAMAGE_TYPE_ACID)
		{
			curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_ACID, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_COLD)
		{
			curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_COLD, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_ELECTRICAL)
		{
			curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_ELECTRICAL, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_FIRE)
		{
			curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_FIRE, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_SONIC)
		{
			curEffectWeight += GetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_SONIC, 1);	
			numDamageTypes ++;	
		}
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " scaled effect weight " + FloatToString(curEffectWeight));		
	if (curEffectWeight <= 4.0)
	{
		return 0.0;
	}
	int damageDealtByType;
	if (gbDoingBuff)
	{
		if (baseImmunityFlags & HENCH_IMMUNITY_GENERAL)
		{
			damageDealtByType = GetMaxHitPoints(oTarget);
		}
		else
		{		
			damageDealtByType = FloatToInt(curEffectWeight - testDamageAmount * numDamageTypes - 5);			
		}
	}
	else
	{
		damageDealtByType = GetDamageDealtByType(damageTypeInfo);
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " damage dealt by type " + IntToString(damageDealtByType));		
	if (damageDealtByType <= 0)
	{
		curEffectWeight = 0.0;
	}
	else
	{
		if (resistanceFlag)
		{
			damageDealtByType *= 3;
			if (damageDealtByType > resistanceAmount)
			{
				damageDealtByType = resistanceAmount;
			}		
		}
		else
		{
			damageDealtByType = (damageDealtByType * resistanceAmount) / 100;
		}
		curEffectWeight *= GetThreatRating(oTarget) * IntToFloat(damageDealtByType)
			/ IntToFloat(GetMaxHitPoints(oTarget));
	}
	if ((baseImmunityFlags & HENCH_IMMUNITY_GENERAL) && HenchUseSpellProtections())
	{	
		curEffectWeight += GetThreatRating(goBestSpellCaster) * 0.55;
	}
//	Jug_Debug(GetName(OBJECT_SELF) + " returned effect weight " + FloatToString(curEffectWeight));		
	return curEffectWeight;	
}


void HenchCheckElementalShield()
{
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchCheckElementalShield " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " " + IntToString(gsCurrentspInfo.spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel));	
    if ((GetCreaturePosEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_ELEMENTALSHIELD))
    {
        return;
    }
	
    HenchInitMeleeAttackers();
	
	float curEffectWeight;
	
	object oEnemy = GetLocalObject(OBJECT_SELF, friendMeleeWeaponTargetStr);
	if (GetIsObjectValid(oEnemy))
	{
		int spellLevel = gsCurrentspInfo.spellLevel;
		int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
	    int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : nMySpellCasterLevel;		
		struct sDamageInformation spellDamage = GetCurrentSpellDamage(nCasterLevel, bFoundItemSpell);
		float spellDamageAmount = spellDamage.amount;
		int spellDamageType = spellDamage.damageType1;
		
		do
		{			
//			Jug_Debug(GetName(OBJECT_SELF) + " melee attacker " + GetName(oEnemy));
			int testCount = (GetBaseAttackBonus(oEnemy) / 7 + 1) * 3;	
			float damageAmount = GetDamageResistImmunityAdjustment(oEnemy, spellDamageAmount * testCount, spellDamageType, testCount);
			float damageWeight = CalculateDamageWeight(damageAmount, oEnemy);
			curEffectWeight += damageWeight * GetThreatRating(oEnemy) * GetLocalFloat(oEnemy, friendMeleeWeaponTargetStr);
//			Jug_Debug(GetName(OBJECT_SELF) + " cur dam weight " + FloatToString(curEffectWeight) + " damage weight " + FloatToString(damageWeight) + " damage amount " + FloatToString(damageAmount) + " attack chance " + FloatToString(GetLocalFloat(OBJECT_SELF, friendMeleeWeaponTargetStr)));	
		
			oEnemy = GetLocalObject(oEnemy, friendMeleeWeaponTargetStr);			
		} while (GetIsObjectValid(oEnemy));
		
		curEffectWeight += HenchGetEnergyImmunityWeight(OBJECT_SELF, GetCurrentSpellSaveType());
		
		if (curEffectWeight > 0.0)
		{
		    HenchCheckIfLowestSpellLevelToCast(curEffectWeight, OBJECT_SELF);
		}	
	}
}


void HenchCheckEnergyProt()
{	
	int spellID = gsCurrentspInfo.spellID; 
	int baseImmunityFlags = GetCurrentSpellSaveType();

//  Jug_Debug("?????????????" + GetName(OBJECT_SELF) + " checking prot spells " + IntToString(spellID) + " weight " + FloatToString(maxEffectWeight));
    float maxEffectWeight;
    object oBestTarget;
    object oFriend = OBJECT_SELF;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
//      Jug_Debug("%%" + GetName(OBJECT_SELF) + " testing spell prot target " + GetName(oFriend) + " spell " + IntToString(spellID));
		if (!GetHasSpellEffect(spellID, oFriend))
		{
			float curEffectWeight = HenchGetEnergyImmunityWeight(oFriend, baseImmunityFlags);
	        if (curLoopCount == 2)
	        {
	            // adjust for compassion
	            curEffectWeight *= gfBuffOthersWeight;
	        }
			if (curEffectWeight > maxEffectWeight)
	        {
				maxEffectWeight = curEffectWeight;
				oBestTarget = oFriend;
	        }
		}
        oFriend = GetLocalObject(oFriend, henchAllyStr);
        curLoopCount ++;
    }	
	if (maxEffectWeight > 0.0)
	{	
		HenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestTarget);
	}
}


struct sSpellInformation gsDelayedAttrBuff;
struct sSpellInformation gsPolyAttrBuff;

void HenchCheckAttrBuff()
{
	int spellID = gsCurrentspInfo.spellID; 
    int abilityType = GetCurrentSpellEffectTypes();
    int baseIncreaseAmount;
    if (spellID == SPELL_HENCH_Owl_Insight)
    {
        baseIncreaseAmount = nMySpellCasterLevel / 2;
    }
    else
    {
        baseIncreaseAmount = GetCurrentSpellDamageInfo();
    }
	
//  Jug_Debug("||" + GetName(OBJECT_SELF) + " testing attr spell " + IntToString(spellID));
	
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;	
	if (bIsAreaSpell)
	{
		fRange = gsCurrentspInfo.range;
	}
	else
	{
		fRange = 1000.0;
	}

    object oBestFriend = OBJECT_SELF;
    float maxEffectWeight;

	object oFriend = OBJECT_SELF;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
	int curLoopCount;
	while ((curLoopCount < iLoopLimit) && GetIsObjectValid(oFriend))
	{
		if (GetDistanceToObject(oFriend) <= fRange)
		{
			int posEffects = GetCreaturePosEffects(oFriend);	
			int curIncreaseAmount = baseIncreaseAmount - GetCreatureAbilityIncrease(oFriend, abilityType);
			
			if (curIncreaseAmount > 1)
			{		
//				Jug_Debug("||" + GetName(OBJECT_SELF) + " testing attr buff target " + GetName(oFriend) + " spell " + IntToString(spellID) + " " + Get2DAString("spells", "Label", spellID));
	            float adjustment;
	            if (curLoopCount == 0)
	            {
	                adjustment = gfBuffSelfWeight;
	            }
	            else
	            {
	                adjustment = gfBuffOthersWeight;
	            }
				// TODO add more checks/change checks				
				if (abilityType < 3 /* str, dex, con */)
				{	
		            int bMeleeChar = (posEffects & HENCH_EFFECT_TYPE_POLYMORPH) ||
		                (GetBaseAttackBonus(oFriend) >= (3 * GetHitDice(oFriend) / 4));
		
		            object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
		            int bRanged = GetWeaponRanged(oRightWeapon);
		
		            if (gbDoingBuff && bMeleeChar && GetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR | HENCH_ASC_MELEE_DISTANCE_ANY, oFriend))
		            {
		//              Jug_Debug(GetName(OBJECT_SELF) + " turning ranged buff off melee char using ranged for " + GetName(oFriend));
		                bRanged = FALSE;
		            }
		
		            if (abilityType == ABILITY_CONSTITUTION)
		            {
		                if (!bRanged || (GetPercentageHPLoss(oFriend) <= 90))
		                {
		                    if (bMeleeChar)
		                    {
			                    float curEffectWeight = GetThreatRating(oFriend) * attributeMedBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
		                    }
		                    else if (oFriend == OBJECT_SELF)
		                    {
			                    if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
			                    {
			                        gsDelayedAttrBuff = gsCurrentspInfo;
			                    }
		                    }
		                }
		                else if (oFriend == OBJECT_SELF)
		                {
		                    if (gsCurrentspInfo.spellLevel > gsPolyAttrBuff.spellLevel)
		                    {
		                        gsPolyAttrBuff = gsCurrentspInfo;
		                    }
		                }
		            }
		            else if (abilityType == ABILITY_STRENGTH)
		            {
		                if (!bRanged && !GetHasFeat(FEAT_WEAPON_FINESSE, oFriend))
		                {
		                    if (bMeleeChar)
		                    {
			                    float curEffectWeight = GetThreatRating(oFriend) * attributeHighBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
		                    }
		                    else if (oFriend == OBJECT_SELF)
		                    {
			                    if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
			                    {
			                        gsDelayedAttrBuff = gsCurrentspInfo;
			                    }
		                    }
		                }
		                else if (oFriend == OBJECT_SELF)
		                {
		                    if (gsCurrentspInfo.spellLevel > gsPolyAttrBuff.spellLevel)
		                    {
		                        gsPolyAttrBuff = gsCurrentspInfo;
		                    }
		                }
		            }
		            else /* abilityType == ABILITY_DEXTERITY */
		            {
		                if (bRanged || GetHasFeat(FEAT_WEAPON_FINESSE, oFriend))
		                {
		                    if (bMeleeChar)
		                    {
			                    float curEffectWeight = GetThreatRating(oFriend) * attributeHighBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
		                    }
		                    else if (oFriend == OBJECT_SELF)
		                    {
			                    if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
			                    {
			                        gsDelayedAttrBuff = gsCurrentspInfo;
			                    }
		                    }
		                }
					}
				}
				else if (abilityType == ABILITY_WISDOM)
			    {
			        if ((GetLevelByClass(CLASS_TYPE_CLERIC, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_DRUID, oFriend) > 0) ||
			            (GetLevelByClass(CLASS_TYPE_MONK, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oFriend) > 0))
			        {
			            float curEffectWeight = GetThreatRating(oFriend) * attributeLowBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
			        }
			    }
			    else if (abilityType == ABILITY_INTELLIGENCE)
			    {
			        if (GetLevelByClass(CLASS_TYPE_WIZARD, oFriend) > 0)
			        {
			            float curEffectWeight = GetThreatRating(oFriend) * attributeLowBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
			        }
			    }
			    else /* abilityType == ABILITY_CHARISMA */
			    {
			        if ((GetLevelByClass(CLASS_TYPE_BARD, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_SORCERER, oFriend) > 0) ||
			            (GetLevelByClass(CLASS_TYPE_WARLOCK, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_PALADIN, oFriend) > 0)  ||
						(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oFriend) > 0))
			        {
			            float curEffectWeight = GetThreatRating(oFriend) * attributeLowBuffScale * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
			        }
			    }
            }
        }
		oFriend = GetLocalObject(oFriend, henchAllyStr);
		curLoopCount ++;
    }

	if (maxEffectWeight > 0.0)
	{		
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, bIsAreaSpell ? OBJECT_SELF : oBestFriend);
    }
}


object GetSummonObject(float spellRange)
{
    object oTarget;
    if (GetIsObjectValid(ogClosestSeenOrHeardEnemy))
    {
        oTarget = ogClosestSeenOrHeardEnemy;
    }
    else if (GetIsObjectValid(ogNotHeardOrSeenEnemy))
    {
        oTarget = ogNotHeardOrSeenEnemy;
    }
    else if (GetIsObjectValid(GetMaster()))
    {
        oTarget = GetMaster();
    }
    else
    {
        return OBJECT_SELF;
    }
	if (GetDistanceToObject(oTarget) > spellRange)
	{
		return OBJECT_SELF;
	}
	return oTarget;
}


location GetSummonLocation(float spellRange)
{
    object oTarget;
    if (GetIsObjectValid(ogClosestSeenOrHeardEnemy))
    {
        oTarget = ogClosestSeenOrHeardEnemy;
    }
    else if (GetIsObjectValid(ogNotHeardOrSeenEnemy))
    {
        oTarget = ogNotHeardOrSeenEnemy;
    }
    else if (GetIsObjectValid(GetMaster()))
    {
        oTarget = GetMaster();
    }
    else
    {
        return GetLocation(OBJECT_SELF);
    }
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(OBJECT_SELF);
    vector vDirection = vTarget - vSource;
    float fDistance = VectorMagnitude(vDirection);
    // try to get summons just in front of target
    fDistance -= 3.0;
    if (fDistance < 0.5)
    {
        return GetLocation(OBJECT_SELF);
    }
    // maximum distance is spellrange
    if (fDistance > spellRange)
    {
        fDistance = spellRange;
    }
    vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
    return Location(GetArea(OBJECT_SELF), vPoint, GetFacing(OBJECT_SELF));
}


void HenchCheckSummons()
{
    float effectWeight = GetCurrentSpellEffectWeight() * gfSummonAdjustment * gfBuffSelfWeight;
    // the summon location spell is set during casting
    HenchCheckIfHighestSpellLevelToCast(effectWeight, OBJECT_SELF);
}


void HenchCheckProtEvil()
{
//Jug_Debug(GetName(OBJECT_SELF) + " putting in prot evil");
    object oBestEnemy = GetLocalObject(OBJECT_SELF, sLineOfSight);
    if (gbDoingBuff ||
        (GetIsObjectValid(oBestEnemy) && (GetAlignmentGoodEvil(oBestEnemy) == ALIGNMENT_EVIL)))
    {
//Jug_Debug(GetName(OBJECT_SELF) + " testing prot evil");
        HenchCheckBuff();
    }
}


void HenchCheckProtGood()
{
    object oBestEnemy = GetLocalObject(OBJECT_SELF, sLineOfSight);
    if (GetIsObjectValid(oBestEnemy) && (GetAlignmentGoodEvil(oBestEnemy) == ALIGNMENT_GOOD))
    {
        HenchCheckBuff();
    }
}


const int HENCH_WEAPON_STAFF_FLAG      = 0x1;
const int HENCH_WEAPON_SLASH_FLAG      = 0x2;
const int HENCH_WEAPON_HOLY_SWORD      = 0x4;
const int HENCH_WEAPON_BLUNT_FLAG      = 0x8;
const int HENCH_WEAPON_UNDEAD_FLAG     = 0x10;
const int HENCH_WEAPON_DRUID_FLAG      = 0x1000;

void HenchCheckWeaponBuff()
{
    int nItemProp = GetCurrentSpellEffectTypes();	
	int nEnhanceLevel = GetCurrentSpellSaveDCType();
    int nDamageType = GetCurrentSpellDamageInfo();
    if (nEnhanceLevel >= 100)
    {
        int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ?
            (gsCurrentspInfo.spellLevel * 2) - 1 : nMySpellCasterLevel;
        if (nEnhanceLevel == 100)
        {
            nEnhanceLevel = nCasterLevel / 4;
            if (nEnhanceLevel > 5)
            {
                nEnhanceLevel = 5;
            }
        }
        else if (nEnhanceLevel == 101)
        {
            nEnhanceLevel = (nCasterLevel + 1) / 3;
            if (nEnhanceLevel > 5)
            {
                nEnhanceLevel = 5;
            }
        }
		else if (nEnhanceLevel == 102)
		{
			nEnhanceLevel = nCasterLevel / 3 - 1;
			if (nEnhanceLevel > 5)
			{
				nEnhanceLevel = 5;
			}
			else if (nEnhanceLevel < 1)
			{
				nEnhanceLevel = 1;
			}
		}
        else
        {
            // error
            nEnhanceLevel = 1;
        }
    }
    int nFlags = GetCurrentSpellSaveType();
		
	if (nFlags & HENCH_WEAPON_HOLY_SWORD)
	{
	    if (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) <= 0)
	    {
	        return;
	    }
		// make this spell self only
		gsCurrentspInfo.range = 0.0;
	}
	if (nFlags & HENCH_WEAPON_UNDEAD_FLAG)
	{
		if (GetRacialType(goSaveMeleeAttackTarget) != RACIAL_TYPE_UNDEAD)
		{
			return;
		}
	}
	
    float effectWeight = GetCurrentSpellEffectWeight();
	int spellID = gsCurrentspInfo.spellID; 
		
	if (GetIsObjectValid(goSaveMeleeAttackTarget))
	{
		effectWeight *= GetThreatRating(goSaveMeleeAttackTarget);
		if (nDamageType)
		{
			effectWeight *= GetDamageResistImmunityAdjustment(goSaveMeleeAttackTarget, 5.0, nDamageType, 1) / 5.0;
			if (effectWeight <= 0.01)
			{
				return;
			}
		}		
	}	
	
    int bDruidSpell = nFlags & HENCH_WEAPON_DRUID_FLAG;

//    Jug_Debug("||" + GetName(OBJECT_SELF) + " testing weapon buff spell " + IntToString(spellID) + " itemprop " + IntToString(nItemProp) +
//      " en " + IntToString(nEnhanceLevel) + " flags " + IntToString(nFlags) + " weight " + FloatToString(effectWeight) + " druid " + IntToString(bDruidSpell));

    object oBestFriend;
    float maxEffectWeight;

    object oFriend = OBJECT_SELF;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
//		Jug_Debug("||" + GetName(OBJECT_SELF) + " start loop target " + GetName(oFriend));
		if (bDruidSpell)
		{
            if (curLoopCount == 1)
            {
                oFriend = OBJECT_SELF;
                if (!HenchCheckDruidAnimalTarget(OBJECT_SELF))
                {
//					Jug_Debug("||" + GetName(OBJECT_SELF) + " not a loop target " + GetName(oFriend) + " racial type " + IntToString(GetRacialType(oFriend)));
                    curLoopCount ++;
                    continue;
                }
            }
            else if (curLoopCount == 2)
            {
                oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
                if (!GetIsObjectValid(oFriend) || !HenchCheckDruidAnimalTarget(oFriend))
                {
//					Jug_Debug("||" + GetName(oFriend) + " secondary not a loop target " + GetName(oFriend));
                    break;
                }
            }
            else
            {
                break;
            }
        }
//        Jug_Debug("||" + GetName(OBJECT_SELF) + " testing weapon buff friend " + GetName(oFriend));

        if (!GetHasSpellEffect(spellID, oFriend))
        {
            // get weapon
            object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
            if (!GetIsObjectValid(oWeapon1))
            {
                oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oFriend);
                if (!GetIsObjectValid(oWeapon1))
                {
                    oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFriend);
                    if (!GetIsObjectValid(oWeapon1))
                    {
                        oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFriend);
                    }
                }
            }
            if (GetIsObjectValid(oWeapon1) && !GetWeaponRanged(oWeapon1))
            {
                int nWeaponType = GetWeaponType(oWeapon1);
                if (nWeaponType != WEAPON_TYPE_NONE)
                {
                    int bValid = TRUE;
                    float curEffectWeight = effectWeight;

                    if (nFlags & HENCH_WEAPON_STAFF_FLAG)
                    {
                        if (GetBaseItemType(oWeapon1) != BASE_ITEM_QUARTERSTAFF)
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nFlags & HENCH_WEAPON_SLASH_FLAG)
                    {
                        if (nWeaponType != WEAPON_TYPE_PIERCING &&
                            nWeaponType != WEAPON_TYPE_SLASHING &&
                            nWeaponType != WEAPON_TYPE_PIERCING_AND_SLASHING)
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nFlags & HENCH_WEAPON_BLUNT_FLAG)
                    {
        //          Jug_Debug("||" + GetName(OBJECT_SELF) + " test not blunt " + GetName(oWeapon1));
                        if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
                        {
    //              Jug_Debug("||" + GetName(OBJECT_SELF) + " test isn't blunt " + GetName(oWeapon1));
                            bValid = FALSE;
                        }
                    }
                    if (nItemProp > 0)
                    {
    //              Jug_Debug("||" + GetName(OBJECT_SELF) + " test item prop " + GetName(oWeapon1));
                        if (GetItemHasItemProperty(oWeapon1, nItemProp))
                        {
    //              Jug_Debug("||" + GetName(OBJECT_SELF) + " has item prop " + GetName(oWeapon1));
                            bValid = FALSE;
                        }
                    }
                    if (nEnhanceLevel > 0)
                    {
                        int nBonus = nEnhanceLevel - GetItemAttackBonus(goSaveMeleeAttackTarget, oWeapon1).attackBonus;
                        if (nBonus > 0)
                        {
                            curEffectWeight *= IntToFloat(nBonus);
                        }
                        else
                        {
                            bValid = FALSE;
                        }
                    }
					if (nDamageType)
					{
			            itemproperty curItemProp = GetFirstItemProperty(oWeapon1);
			            while(GetIsItemPropertyValid(curItemProp))
			            {
//							Jug_Debug(GetName(oWeapon1) + 
//								" isub type " + IntToString(GetItemPropertySubType(curItemProp)) + " cost table " + IntToString(GetItemPropertyCostTableValue(curItemProp)) +
//								" item param 1 " + IntToString(GetItemPropertyParam1(curItemProp)) + " item param 1 value " + IntToString(GetItemPropertyParam1Value(curItemProp)));				
							if ((GetItemPropertyType(curItemProp) == ITEM_PROPERTY_DAMAGE_BONUS) &&
								(GetItemPropertyDurationType(curItemProp) == DURATION_TYPE_TEMPORARY))
							{					
								bValid = FALSE;
								break;
							}			
		                	curItemProp = GetNextItemProperty(oWeapon1);			
						}
					}
                    if (bValid)
                    {
//						Jug_Debug("||" + GetName(OBJECT_SELF) + " found match " + GetName(oFriend));
                        if (oFriend == OBJECT_SELF)
                        {
                            if (!((GetCreaturePosEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_POLYMORPH) ||
                                (GetBaseAttackBonus(OBJECT_SELF) >= (3 * GetHitDice(OBJECT_SELF) / 4))))
                            {
//								Jug_Debug("||" + GetName(OBJECT_SELF) + " melee buff");
                                curEffectWeight = -1.0;
                                if (gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel)
                                {
                                    gsMeleeAttackspInfo = gsCurrentspInfo;
                                }
                            }
                            else
                            {
                                curEffectWeight *= gfBuffSelfWeight;
                            }
                        }
                        else
                        {
                            // adjust for compassion
                            curEffectWeight *= gfBuffOthersWeight;
                        }
                        if (curEffectWeight > maxEffectWeight)
                        {
//							Jug_Debug("||" + GetName(OBJECT_SELF) + " regular buff " + FloatToString(curEffectWeight));
                            oBestFriend = oFriend;
                            maxEffectWeight = curEffectWeight;
                        }
                    }
                }
            }
        }
        oFriend = GetLocalObject(oFriend, henchAllyStr);
        curLoopCount ++;
    }

    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


const int HENCH_POLYMORPH_CHECK_NATURAL_SPELL	= 0x01;
const int HENCH_POLYMORPH_CHECK_NON_POLYMORPH	= 0x02;
const int HENCH_POLYMORPH_CHECK_MAGIC_FANG		= 0x04;

struct sSpellInformation gsPolymorphspInfo;
float gfMaxPolymorph;

void HenchCheckPolymorph()
{
	int nPolymorphFlags = GetCurrentSpellEffectTypes();
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchCheckPolymorph " + Get2DAString("spells", "Label", spellID) + " " + IntToString(spellID) + " flags " + IntToString(nPolymorphFlags));
    int nPosEffects = GetCreaturePosEffects(OBJECT_SELF);
	
	if (nPolymorphFlags & HENCH_POLYMORPH_CHECK_NON_POLYMORPH)
	{
		if (nPosEffects & HENCH_EFFECT_TYPE_DAMAGE_REDUCTION)
		{
//			Jug_Debug(GetName(OBJECT_SELF) + " exit 1a");
	        return;
		}
	}
	else
	{
	    if (nPosEffects & HENCH_EFFECT_TYPE_POLYMORPH)
	    {
//			Jug_Debug(GetName(OBJECT_SELF) + " exit 1");
	        return;
	    }
	}
	if (!(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NON_POLYMORPH) || (bAnySpellcastingClasses & HENCH_ARCANE_SPELLCASTING) ||
		!GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
	{
	    if (!bgMeleeAttackers && !GetHasFeat(FEAT_NATURAL_SPELL) && !(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NATURAL_SPELL))
	    {
//			Jug_Debug(GetName(OBJECT_SELF) + " exit 2");
	        return;
	    }
	    if (GetHasFeat(FEAT_NATURAL_SPELL) && (GetHasFeat(FEAT_ELEMENTAL_SHAPE) || GetHasFeat(FEAT_WILD_SHAPE)) &&
	        !(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NATURAL_SPELL))
	    {
	        // don't polymorph into a shape with no spellcasting
//			Jug_Debug(GetName(OBJECT_SELF) + " exit 3");
	        return;
	    }
	}
	else
	{
		// this spell is a buff, treat as a damage reduction spell (stoneskin for cleric)
    	HenchInitMeleeAttackers();
		if (gbIAmMeleeTarget)
		{
            float targetChance = GetLocalFloat(OBJECT_SELF, friendMeleeTargetStr);
            if (targetChance >= 0.01)
			{
//				Jug_Debug("||" + GetName(OBJECT_SELF) + " testing dr buff target " + GetName(OBJECT_SELF) + " spell " + IntToString(spellID));
                float curEffectWeight = 0.9 * targetChance;
                    // found target
                curEffectWeight *= GetThreatRating(OBJECT_SELF);
                curEffectWeight *= gfBuffSelfWeight;				
        		HenchCheckIfLowestSpellLevelToCast(curEffectWeight, OBJECT_SELF);
				return;
			} 		
		}	
	}
	
    float effectWeight = GetCurrentSpellEffectWeight();
	if ((nPolymorphFlags & HENCH_POLYMORPH_CHECK_MAGIC_FANG) && GetHasSpell(SPELL_GREATER_MAGIC_FANG))
	{
//		Jug_Debug(GetName(OBJECT_SELF) + " adjust for greater magic fang");
		effectWeight += 5.0;
	}
    if (effectWeight > gfMaxPolymorph)
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " use polymorph");
        gsPolymorphspInfo = gsCurrentspInfo;
        gfMaxPolymorph = effectWeight;
    }
}


void HenchCheckConcealment(float fConcealAmount, float fWeight)
{
//  Jug_Debug(GetName(OBJECT_SELF) + " HenchCheckConcealment " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " " + IntToString(gsCurrentspInfo.spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel));
    HenchInitMeleeAttackers();

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = OBJECT_SELF;
	
    while (GetIsObjectValid(oFriend))
    {	
		int curNegEffects = GetCreatureNegEffects(oFriend);	
	
        float curConcealment = fConcealAmount - GetLocalFloat(oFriend, rangedConcealmentStr);
		
        if (curConcealment > 0.15)
        {
            float targetChance = GetLocalFloat(oFriend, friendMeleeTargetStr);
//          Jug_Debug("||" + GetName(OBJECT_SELF) + " testing ac buff target " + GetName(oFriend) + " spell " + IntToString(spellID));
			float curEffectWeight = fWeight * curConcealment * targetChance;

			// found target
			curEffectWeight *= GetThreatRating(oFriend);
			if (oFriend == OBJECT_SELF)
			{
				curEffectWeight *= gfBuffSelfWeight;
			}
			else
			{
				// adjust for compassion
				curEffectWeight *= gfBuffOthersWeight;
			}
			
			if (curEffectWeight > maxEffectWeight)
			{
//          	Jug_Debug(GetName(OBJECT_SELF) + " doing conceal buff " + IntToString(spellID) + " weight " + FloatToString(curEffectWeight));
				maxEffectWeight = curEffectWeight;
				oBestFriend = oFriend;
			}
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, friendMeleeTargetStr);
    }
    if (maxEffectWeight > 0.0)
    {
        HenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


const int HENCH_DARKNESS_CHECK_NOT_INITIALIZED = 0;          
const int HENCH_DARKNESS_CHECK_ENABLE = 1;
const int HENCH_DARKNESS_CHECK_DISABLE = 2;

int giDarknessCheck;

void HenchConcealment()
{
	int bIsDarkness = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fWeight;
	if (bIsDarkness)
	{
	    if (HENCH_DARKNESS_CHECK_NOT_INITIALIZED == giDarknessCheck)
	    {
			if (!GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
	        {
	            HenchInitMeleeAttackers();
	            if (gbIAmMeleeTarget && (GetLocalFloat(OBJECT_SELF, friendMeleeTargetStr) > 0.5))
	            {
	                giDarknessCheck = HENCH_DARKNESS_CHECK_ENABLE;
	            }
	            else
	            {
	                giDarknessCheck = HENCH_DARKNESS_CHECK_DISABLE;
	            }
	        }
	        else
	        {
	            giDarknessCheck = HENCH_DARKNESS_CHECK_DISABLE;
	        }
	    }
	    if (giDarknessCheck != HENCH_DARKNESS_CHECK_ENABLE)
	    {
	        return;
	    }
		fWeight = 1.0;
	}
	else
	{
		fWeight = 2.0;
	}	
	HenchCheckConcealment(GetCurrentSpellEffectWeight(), fWeight);	
}


void HenchCheckAnimalCompanionBuff()
{
    object oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    if (!GetIsObjectValid(oFriend) || !HenchCheckDruidAnimalTarget(oFriend) ||
        (GetDistanceToObject(oFriend) > (bgMeleeAttackers ? 5.0 : 20.0)))
    {
        return;
    }	
	int spellID = gsCurrentspInfo.spellID;
    if (GetHasSpellEffect(spellID, oFriend))
	{
		return;
	}
    if (spellID == SPELL_AWAKEN)
    {
        int strIncAmount = 4 - GetCreatureAbilityIncrease(oFriend, ABILITY_STRENGTH);
        if (strIncAmount < 0)
        {
            strIncAmount = 0;
        }
        int conIncAmount = 4 - GetCreatureAbilityIncrease(oFriend, ABILITY_CONSTITUTION);
        if (conIncAmount < 0)
        {
            conIncAmount = 0;
        }
        float curEffectWeight = 0.06 + attributeHighBuffScale * (strIncAmount + conIncAmount) * GetThreatRating(oFriend);
        HenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
    else if (spellID == SPELL_NATURE_AVATAR)
    {
        int posEffects = GetCreaturePosEffects(oFriend);
        float curEffectWeight;
        if (!(posEffects & HENCH_EFFECT_TYPE_HASTE))
        {
            curEffectWeight += 0.3;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS))
        {
            curEffectWeight += 0.2;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_DAMAGE_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        curEffectWeight *= GetThreatRating(oFriend);
        HenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
    else if (spellID == 1828)		// Nature's Favor
    {
        int posEffects = GetCreaturePosEffects(oFriend);
        float curEffectWeight;
        if (!(posEffects & HENCH_EFFECT_TYPE_DAMAGE_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_ATTACK_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        curEffectWeight *= GetThreatRating(oFriend);
        HenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
}


void HenchCheckInvisibility()
{
    int spellEffectTypes = GetCurrentSpellEffectTypes();
	
//	Jug_Debug(GetName(OBJECT_SELF) + " HenchCheckInvisibility " + Get2DAString("spells", "Label", gsCurrentspInfo.spellID) + " " + IntToString(gsCurrentspInfo.spellID) + " level " + IntToString(gsCurrentspInfo.spellLevel) + " effect type " + IntToHexString(spellEffectTypes) + " pos effects " + IntToHexString(GetCreaturePosEffects(OBJECT_SELF)));
	
	if (spellEffectTypes & HENCH_EFFECT_TYPE_CONCEALMENT)
	{
		HenchCheckConcealment(0.5, 2.5);	
	}	
	float curWeight = GetCurrentSpellEffectWeight();
	if (spellEffectTypes & HENCH_EFFECT_TYPE_ETHEREAL)
	{
		if (GetCreaturePosEffects(OBJECT_SELF) & HENCH_EFFECT_TYPE_ETHEREAL)
		{
			return;
		}	
	}
	else
	{
		if (gbTrueSeeingNear)
		{
			return;
		}
		if (spellEffectTypes & HENCH_EFFECT_TYPE_INVISIBILITY)
		{
			if (gbSeeInvisNear)
			{
				return;
			}		
		}
		else if (spellEffectTypes & HENCH_EFFECT_TYPE_SANCTUARY)
		{		
			int saveDC;
			int spellID = gsCurrentspInfo.spellID;
			
			if (spellID == SPELLABILITY_DIVINE_PROTECTION)
			{
				saveDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + GetLevelByClass(CLASS_TYPE_CLERIC);			
			}
			else if (spellID == SPELLABILITY_SONG_HAVEN_SONG)
			{
				saveDC = 11 + (GetSkillRank(SKILL_PERFORM) / 2);
			}		
			else // SPELL_SANCTUARY
			{
				saveDC = GetCurrentSpellSaveDC(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG, 1);
			}
			object oTarget = GetLocalObject(OBJECT_SELF, sLineOfSight);
			if (!GetIsObjectValid(oTarget))
			{			
				oTarget = ogClosestSeenOrHeardEnemy;
			}
			if (GetIsObjectValid(oTarget))
			{
				float fChance = Getd20ChanceLimited(saveDC - GetWillSavingThrow(oTarget));
				if (fChance < 0.67)
				{
					return;
				}
				curWeight *= fChance;
			}
		}
		else if (spellEffectTypes == 0)
		{
			if (!GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) || GetHasSpellEffect(gsCurrentspInfo.spellID))
			{
				return;
			}
		    if (curWeight > gfSelfHideWeight)
		    {
		        gfSelfHideWeight = curWeight;
		        gsBestSelfHide = gsCurrentspInfo;
		    }
			return;
	    }
	}
    if (curWeight > gfSelfInvisiblityWeight)
    {
        gfSelfInvisiblityWeight = curWeight;
        gsBestSelfInvisibility = gsCurrentspInfo;
    }
    if (curWeight > gfSelfHideWeight)
    {
        gfSelfHideWeight = curWeight;
        gsBestSelfHide = gsCurrentspInfo;
    }
}
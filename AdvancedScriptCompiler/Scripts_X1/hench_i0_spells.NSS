/*

    Companion and Monster AI

    This file contains the defines and utility functions for spellcasting. Also contains
    invisibility become and detect code.

*/

#include "hench_i0_equip"
#include "hench_i0_target"
#include "hench_i0_generic"
#include "hench_i0_ai"
#include "x2_i0_spells"
#include "nwn2_inc_spells"

// void main() {    }

// this is the structure that is used to store information about a potential spell to cast
struct sSpellInformation
{
    talent tTalent;
    int spellLevel;
    int spellInfo;
    int spellID;
    int otherID;
    int castingInfo;

    int shape;
    float range;
    float radius;

    object oTarget;
    location lTargetLoc;
};

// gets the effect weight 1.0 (best) to 0.0 (worst)
float GetCurrentSpellEffectWeight();

// gets the effect types (can be positive or negative) HENCH_EFFECT_TYPE_*
int GetCurrentSpellEffectTypes();

// damage information about a spell (damage dice, type, etc.)
int GetCurrentSpellDamageInfo();

// information about the saves (will, fort, reflex, spell resistance, touch, etc.)
int GetCurrentSpellSaveType();

// get information about the DC of a spell
int GetCurrentSpellSaveDCType();

// set up healing information for casting (HENCH_HEAL_*)
void IntitializeHealingInfo(int healingFlags);

// limit is 1 to 20 (1d20 roll)
float Getd20Chance(int limit);

// limit is 1 to 20 (1d20 roll) but 1 always fails, 20 always succeeds
float Getd20ChanceLimited(int limit);

// limit is -19 to 19 (1d20 opposed rolls)
float Get2d20Chance(int limit);

// grapple check, assumes large object (Bigby's and Evard's)
float CheckGrappleResult(object oTarget, int nCasterCheck, int nCheckType);

// poison DC taken from spell code
int GetCreaturePoisonDC();

// disease DC taken from spell code
int GetCreatureDiseaseDC(int checkType);

// gets the current spell DC
int GetCurrentSpellSaveDC(int bFoundItemSpell, int spellLevel);

// information about the spells damage
struct sDamageInformation
{
    float amount;
    int damageTypeMask;
    int count;
    int damageType1;
    int damageType2;
    int numberOfDamageTypes;
};

// returns the amount of buff (i.e. amount of AC increase)
int GetCurrentSpellBuffAmount(int casterLevel);

// returns information about the spells damage (type, amount, etc.)
struct sDamageInformation GetCurrentSpellDamage(int casterLevel, int bIsItem);

// adjust damage based on creatures resistances, etc., returns estimated damage amount
float GetDamageResistImmunityAdjustment(object oTarget, float damageAmount, int damageType, int count);

// gets the weight of the damage (1.0 kills, 0.0 none)
float CalculateDamageWeight(float damageAmount, object oTarget);

// gets a number from 1.0 to 0.0 for decreasing spell use chance based on concentration
float GetConcetrationWeightAdjustment(int spellInformation, int spellLevel);

// gets basic information about a spell using a 2da lookup and caching to the module
// basic spell information includes its type, level, concentration, etc. (HENCH_SPELL_INFO_*)
int GetSpellInformation(int nSpellID);

// returns TRUE if there are significant enemy spell casters
int HenchPerceiveSpellcasterThreat();

// check for use of spell mantles, globes, etc.
int HenchUseSpellProtections();

// check if invisible creatures are present that need detecting
void HenchCheckDetectInvisibility();

// initialize invisibility checks
void HenchInitializeInvisibility(int posEffectsOnSelf);

// test to see if stealth should be enabled
void HenchTalentStealth(int iMeleeAttackers, int bCheckStealthDetect = TRUE);

// check if attack spell to be cast, stored in global gsTargetInfo
void HenchCheckIfAttackSpellToCastOnObject(float fFinalTargetWeight, object oTarget);

// check if attack spell to be cast, stored in global gsTargetInfo
void HenchCheckIfAttackSpellToCastAtLocation(float fFinalTargetWeight, location lTargetLocation);

// check if general spell to be cast, replace lower level spell, stored in global gsTargetInfo
void HenchCheckIfHighestSpellLevelToCast(float fFinalTargetWeight, object oTarget);

// check if general spell to be cast, replace higher level spell, stored in global gsTargetInfo
void HenchCheckIfLowestSpellLevelToCast(float fFinalTargetWeight, object oTarget);

// check if spell is suitable druid target (animal only)
int HenchCheckDruidAnimalTarget(object oTarget);


const float gfHealSelfWeightAdjustment = 1000.0;
const float gfHealOthersWeightAdjustment = 50.0;


const string HENCH_SPELL_ID_TABLE = "henchspells";  // AI 2da look up name

const string HENCH_SPELL_ID_INFO = "HENCH_SPELL_ID_INFO";   // general spell information column

const string HENCH_SPELL_INFO_COLUMN_NAME           = "SpellInfo";
const int HENCH_SPELL_INFO_VERSION                  = 0x10000000;
const int HENCH_SPELL_INFO_VERSION_MASK             = 0xff000000;

const int HENCH_SPELL_INFO_SPELL_TYPE_MASK          = 0x000000ff;

const int HENCH_SPELL_INFO_SPELL_TYPE_ATTACK        = 1;
const int HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF       = 2;
const int HENCH_SPELL_INFO_SPELL_TYPE_BUFF          = 3;
const int HENCH_SPELL_INFO_SPELL_TYPE_PERSISTENTAREA = 4;
const int HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH     = 5;
const int HENCH_SPELL_INFO_SPELL_TYPE_DISPEL        = 6;
const int HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE     = 7;
const int HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION = 8;
const int HENCH_SPELL_INFO_SPELL_TYPE_SUMMON        = 9;
const int HENCH_SPELL_INFO_SPELL_TYPE_HEAL          = 10;
const int HENCH_SPELL_INFO_SPELL_TYPE_HARM          = 11;
const int HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF     = 12;
const int HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT     = 13;
const int HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK  = 14;
const int HENCH_SPELL_INFO_SPELL_TYPE_ARCANE_ARCHER = 15;
const int HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT    = 16;
const int HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH = 17;
const int HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS  = 18;
const int HENCH_SPELL_INFO_SPELL_TYPE_WARLOCK       = 19;
const int HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE      = 20;
const int HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF   = 21;
const int HENCH_SPELL_INFO_SPELL_TYPE_BUFF_ANIMAL_COMP = 22;
const int HENCH_SPELL_INFO_SPELL_TYPE_PROT_EVIL     = 23;
const int HENCH_SPELL_INFO_SPELL_TYPE_PROT_GOOD     = 24;
const int HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE    = 25;
const int HENCH_SPELL_INFO_SPELL_TYPE_GUST_OF_WIND  = 26;
const int HENCH_SPELL_INFO_SPELL_TYPE_ELEMENTAL_SHIELD = 27;
const int HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD   = 28;
const int HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF       = 29;
const int HENCH_SPELL_INFO_TYPE_MELEE_ATTACK_BUFF   = 30;
const int HENCH_SPELL_INFO_TYPE_RAISE_DEAD          = 31;
const int HENCH_SPELL_INFO_TYPE_CONCEALMENT         = 32;
const int HENCH_SPELL_INFO_TYPE_ATTACK_SPECIAL		= 33;
const int HENCH_SPELL_INFO_TYPE_HEAL_SPECIAL		= 34;

const int HENCH_SPELL_INFO_MASTER_FLAG              = 0x00000100;
const int HENCH_SPELL_INFO_IGNORE_FLAG              = 0x00000200;
const int HENCH_SPELL_INFO_CONCENTRATION_FLAG       = 0x00000400;
const int HENCH_SPELL_INFO_REMOVE_CONCENTRATION_FLAG= 0xfffffbff;
const int HENCH_SPELL_INFO_UNLIMITED_FLAG           = 0x00000800;
const int HENCH_SPELL_INFO_SPELLLIKE_ABILITY		= 0x00001000;
const int HENCH_SPELL_INFO_SPELL_LEVEL_MASK         = 0x0001e000;
const int HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT        = 13;
const int HENCH_SPELL_INFO_HEAL_OR_CURE             = 0x00020000;
const int HENCH_SPELL_INFO_SHORT_DUR_BUFF           = 0x00040000;
const int HENCH_SPELL_INFO_MEDIUM_DUR_BUFF          = 0x00080000;
const int HENCH_SPELL_INFO_LONG_DUR_BUFF            = 0x00100000;

// flags that are added on
// spell is from item
const int HENCH_SPELL_INFO_ITEM_FLAG                = 0x00800000;


const string  HENCH_SPELL_TARGET_COLUMN_NAME        = "TargetInfo"; // spell targeting information column
const int HENCH_SPELL_TARGET_SHAPE_MASK             = 0x00000007;
// standard spell shapes in mask
/*
int    SHAPE_SPELLCYLINDER      = 0;
int    SHAPE_CONE               = 1;
int    SHAPE_CUBE               = 2;
int    SHAPE_SPELLCONE          = 3;
int    SHAPE_SPHERE             = 4;
*/
const int HENCH_SHAPE_NONE                          = 7;        // indicates no shape
const int HENCH_SHAPE_FACTION                       = 6;        // indicates faction targets

const int HENCH_SPELL_TARGET_RANGE_MASK             = 0x00000038;
const int HENCH_SPELL_TARGET_RANGE_PERSONAL         = 0x00000000;
const int HENCH_SPELL_TARGET_RANGE_TOUCH            = 0x00000008;
const int HENCH_SPELL_TARGET_RANGE_SHORT            = 0x00000010;
const int HENCH_SPELL_TARGET_RANGE_MEDIUM           = 0x00000018;
const int HENCH_SPELL_TARGET_RANGE_LONG             = 0x00000020;
const int HENCH_SPELL_TARGET_RANGE_INFINITE         = 0x00000028;

const int HENCH_SPELL_TARGET_RADIUS_MASK            = 0x0000ffc0;   // 10 bits radius * 10

const int HENCH_SPELL_TARGET_SHAPE_LOOP				= 0x00010000;
const int HENCH_SPELL_TARGET_CHECK_COUNT			= 0x00020000;
const int HENCH_SPELL_TARGET_MISSILE_TARGETS		= 0x00040000;
const int HENCH_SPELL_TARGET_SECONDARY_TARGETS		= 0x00080000;
const int HENCH_SPELL_TARGET_SECONDARY_HALF_DAM		= 0x00100000;
const int HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG      = 0x00200000;
const int HENCH_SPELL_TARGET_RANGED_SEL_AREA_FLAG   = 0x00400000;
const int HENCH_SPELL_TARGET_PERSISTENT_SPELL		= 0x00800000;
const int HENCH_SPELL_TARGET_SCALE_EFFECT			= 0x01000000;


const string  HENCH_SPELL_SAVE_TYPE_COLUMN_NAME     = "SaveType"; // spell save information mask

const int HENCH_SPELL_SAVE_TYPE_CUSTOM_MASK         = 0x0000003f;
const int HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK      = 0x00000fc0;
const int HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK      = 0x0003f000;

const int HENCH_SPELL_SAVE_TYPE_SAVES_MASK          = 0x03fc0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_SAVE_MASK    = 0x000c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_FORT          = 0x00040000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX        = 0x00080000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_WILL          = 0x000c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_KIND_MASK    = 0x00300000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY   = 0x00000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_HALF   = 0x00100000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_DAMAGE = 0x00200000;
const int HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION= 0x00300000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_MASK    		= 0x003c0000;
const int HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE	= 0xffc3ffff;
const int HENCH_SPELL_SAVE_TYPE_SAVES2_SAVE_MASK    = 0x00c00000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_FORT          = 0x00400000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_REFLEX        = 0x00800000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_WILL          = 0x00c00000;
const int HENCH_SPELL_SAVE_TYPE_SAVES2_KIND_MASK    = 0x03000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_ONLY   = 0x00000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_HALF   = 0x01000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_DAMAGE = 0x02000000;
const int HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION= 0x03000000;

const int HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT    	= 0x10;

const int HENCH_SPELL_SAVE_TYPE_SR_FLAG             = 0x80000000;
const int HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG = 0x40000000;
const int HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG        = 0x20000000;
const int HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG    = 0x10000000;
const int HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG    = 0x08000000;
const int HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG     = 0x04000000;


const string  HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME     = "EffectWeight";
const string  HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME      = "EffectTypes";
const string  HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME       = "DamageInfo";
const string  HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME      = "SaveDCType";


// caster level (spell resistance)
int nMySpellCasterLevel;
int nMySpellCasterSpellPenetration;
// DC for spells
int nMySpellCasterDC;
// touch attacks
int nMyRangedTouchAttack;
int nMyMeleeTouchAttack;

int nMySpellCastingConcentration;
int gbNoTrueSeeing;

const int HENCH_NO_SPELLCASTING		= 0;
const int HENCH_DIVINE_SPELLCASTING = 1;
const int HENCH_ARCANE_SPELLCASTING = 2;

int bAnySpellcastingClasses;

int giWarlockDamageDice;
int giWarlockMinSaveDC;
int gbWarlockMaster;


int gbDisableNonHealorCure;
int gbDoingBuff;
int gbDisableCastMeleeConcentration;        // TODO not currently implemented
int gbDisableNonUnlimitedOrHealOrCure;
int gbSpellInfoCastMask;

int gbGlobalAttrBuffOver;       // TODO not currently implemented

// adjustments for spellcasting chances
float gfBuffSelfWeight;
float gfBuffOthersWeight;
float gfAttackWeight;
const float gfSummonAdjustment = 0.75;


// options for how to cast sSpellInformation
const int HENCH_CASTING_INFO_USE_SPELL_TALENT			= 0;
const int HENCH_CASTING_INFO_USE_SPELL_FEATID			= 1;
const int HENCH_CASTING_INFO_USE_SPELL_WARLOCK			= 2;
const int HENCH_CASTING_INFO_USE_SPELL_REGULAR			= 3;
const int HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT	= 4;
const int HENCH_CASTING_INFO_USE_HEALING_KIT			= 5;

const int HENCH_CASTING_INFO_USE_MASK					= 0x0000000f;

const int HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG		= 0x00000010;
const int HENCH_CASTING_INFO_CHEAT_CAST_FLAG			= 0x00000020; 


object goSaveMeleeAttackTarget;		// saved melee attack target

struct sSpellInformation gsAttackTargetInfo;  // main global for holding best attack option
float gfAttackTargetWeight;   // weight of current best attack option

struct sSpellInformation gsBuffTargetInfo;  // main global for holding best buff option
float gfBuffTargetWeight;   // weight of current best buff option

float bfBuffTargetAccumWeight;	// accumulated weight of pending buffs
int giNumberOfPendingBuffs;			// number of pending buffs

struct sSpellInformation gsBestSelfInvisibility;	// best self invisibility
float gfSelfInvisiblityWeight;	// weight of best self invisibility

struct sSpellInformation gsBestSelfHide;	// best self hide (early rounds)
float gfSelfHideWeight;	// weight of best self hide (early rounds)

int gbCheckInvisbility;
int gbTrueSeeingNear;
int gbSeeInvisNear;

string gCurrentSpellInfoStr;

struct sSpellInformation gsCurrentspInfo;


float GetCurrentSpellEffectWeight()
{
    return GetLocalFloat(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME);
}

int GetCurrentSpellEffectTypes()
{
    return GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME);
}

int GetCurrentSpellDamageInfo()
{
    return GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME);
}

int GetCurrentSpellSaveType()
{
    return GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_SAVE_TYPE_COLUMN_NAME);
}

int GetCurrentSpellSaveDCType()
{
    return GetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME);
}


float gfHealingThreshold;
int giRegenHealScaleAmount;
int giHealingDivisor;

object goHealingKit;

const int HENCH_HEALING_KIT_ID  = 1000000;

int gbDisabledAllyFound;

void IntitializeHealingInfo(int bForce)
{
	if (bForce)
	{
	    gfHealingThreshold = 0.9999;
		giRegenHealScaleAmount = 4;
		giHealingDivisor = 10000;	
	}
	else
	{	
		gfHealingThreshold = 0.5;
	    if (GetAssociateState(NW_ASC_HEAL_AT_75))
	    {
	        gfHealingThreshold = 0.75;
	    }
	    else if (GetAssociateState(NW_ASC_HEAL_AT_25))
	    {
	        gfHealingThreshold = 0.25;
	    }
		giRegenHealScaleAmount = 1;
		giHealingDivisor = bgMeleeAttackers ?  8 : 15;
	}	
}


const int HENCH_SAVEDC_SPELL  = -1000;
/*const int HENCH_SAVEDC_SPELL_PLUS_1 = -999;
const int HENCH_SAVEDC_SPELL_PLUS_2 = -998;
const int HENCH_SAVEDC_SPELL_PLUS_3 = -997;
const int HENCH_SAVEDC_SPELL_PLUS_4 = -996;
const int HENCH_SAVEDC_SPELL_PLUS_5 = -995;
const int HENCH_SAVEDC_SPELL_PLUS_6 = -994; */

const int HENCH_SAVEDC_NONE = 0;
/*
const int HENCH_SAVEDC_FIXED_10 = 10;
const int HENCH_SAVEDC_FIXED_11 = 11;
const int HENCH_SAVEDC_FIXED_12 = 12,
const int HENCH_SAVEDC_FIXED_13 = 13,
const int HENCH_SAVEDC_FIXED_14 = 14,
const int HENCH_SAVEDC_FIXED_15 = 15,
const int HENCH_SAVEDC_FIXED_16 = 16,
const int HENCH_SAVEDC_FIXED_17 = 17,
const int HENCH_SAVEDC_FIXED_18 = 18,
const int HENCH_SAVEDC_FIXED_19 = 19,
const int HENCH_SAVEDC_FIXED_20 = 20,
const int HENCH_SAVEDC_FIXED_21 = 21,
const int HENCH_SAVEDC_FIXED_22 = 22,
const int HENCH_SAVEDC_FIXED_23 = 23,
const int HENCH_SAVEDC_FIXED_24 = 24,
const int HENCH_SAVEDC_FIXED_25 = 25, */

const int HENCH_SAVEDC_HD_1 = 1000;
const int HENCH_SAVEDC_HD_2 = 1001;
const int HENCH_SAVEDC_HD_4 = 1002;
const int HENCH_SAVEDC_HD_2_CONST = 1003;
const int HENCH_SAVEDC_HD_2_CONST_MINUS_5 = 1004;
const int HENCH_SAVEDC_HD_2_WIS = 1005;
const int HENCH_SAVEDC_HD_2_PLUS_5 = 1006;
const int HENCH_SAVEDC_HD_2_CHA = 1007;

const int HENCH_SAVEDC_DISEASE_BOLT = 1010;
const int HENCH_SAVEDC_DISEASE_CONE = 1011;
const int HENCH_SAVEDC_DISEASE_PULSE = 1012;
const int HENCH_SAVEDC_POISON = 1013;

const int HENCH_SAVEDC_EPIC = 1014;

const int HENCH_SAVEDC_DEATHLESS_MASTER_TOUCH = 1020;
const int HENCH_SAVEDC_UNDEAD_GRAFT = 1021;

const int HENCH_SAVEDC_DRAGON_DIS_BREATH = 1022;
const int HENCH_SAVEDC_WARPRIEST_FEAR_AURA = 1023;
const int HENCH_SAVEDC_BARD_SLOWING = 1024;
const int HENCH_SAVEDC_BARD_FASCINATE = 1025;

// missing or wrong numbered spell and feat definitions in nwscript
const int SPELL_HENCH_RedDragonDiscipleBreath = 690;
const int SPELL_HENCH_Owl_Insight = 438;


float Getd20Chance(int limit)
{
    limit += 21;
    if (limit >= 20)
    {
        return 1.0;
    }
    if (limit <= 0)
    {
        return 0.0;
    }
    return IntToFloat(limit) / 20.0;
}


float Getd20ChanceLimited(int limit)
{
    if (limit <= 1)
    {
        return 0.05;
    }
    if (limit >= 19)
    {
        return 0.95;
    }
    return IntToFloat(limit) / 20.0;
}


float Get2d20Chance(int limit)
{
    if (limit <= -20)
    {
        return 0.0;
    }
    if (limit >= 19)
    {
        return 1.0;
    }
    if (limit <= 0)
    {
        limit += 20;
        return IntToFloat((limit + 1) * limit) / 800.0;
    }
    limit = 19 - limit;
    return 1.0 - IntToFloat((limit + 1) * limit) / 800.0;
}


const int GRAPPLE_CHECK_HIT = 0x1;
const int GRAPPLE_CHECK_HOLD = 0x2;
const int GRAPPLE_CHECK_RUSH = 0x4;
const int GRAPPLE_CHECK_STR = 0x8;


float CheckGrappleResult(object oTarget, int nCasterCheck, int nCheckType)
{
    float fResult = 1.0;

    // grapple hit check
    if (nCheckType & GRAPPLE_CHECK_HIT)
    {
        int nGrappleCheck = nCasterCheck - 1 /* large size */ - GetAC(oTarget);
	    if (HasSizeIncreasingSpellEffect(oTarget) || GetHasSpellEffect(803, oTarget))
		{
	        nGrappleCheck -= 4;
		}			
        fResult *= Getd20Chance(nGrappleCheck);
    }
     // grapple hold check
    if (nCheckType & GRAPPLE_CHECK_HOLD)
    {
        int nGrappleCheck = nCasterCheck + 4 /* large size */ -
            (GetBaseAttackBonus(oTarget) + GetSizeModifier(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget));
	    if (HasSizeIncreasingSpellEffect(oTarget) || GetHasSpellEffect(803, oTarget))
		{
	        nGrappleCheck -= 4;
		}			
        fResult *= Get2d20Chance(nGrappleCheck);
    }
    // bull rush
    if (nCheckType & GRAPPLE_CHECK_RUSH)
    {
        int nRushCheck = nCasterCheck -
            (GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget));
        fResult *= Get2d20Chance(nRushCheck);
    }
    // strength
    if (nCheckType & GRAPPLE_CHECK_STR)
    {
        int nStrCheck = nCasterCheck - GetAbilityScore(oTarget, ABILITY_STRENGTH);
        fResult *= Get2d20Chance(nStrCheck);
    }
    return fResult;
}


int GetCreaturePoisonDC()
{
    int nRacial = GetRacialType(OBJECT_SELF);
    int nHD = GetHitDice(OBJECT_SELF);

    //Determine the poison type based on the Racial Type and HD
    switch (nRacial)
    {
        case RACIAL_TYPE_OUTSIDER:
            if (nHD <= 9)
            {
                return 13; // POISON_QUASIT_VENOM;
            }
            if (nHD < 13)
            {
                return 20; // POISON_BEBILITH_VENOM;
            }
            return 21; // POISON_PIT_FIEND_ICHOR;
        case RACIAL_TYPE_VERMIN:
            if (nHD < 3)
            {
                return 11; // POISON_TINY_SPIDER_VENOM;
            }
            if (nHD < 6)
            {
                return 11; // POISON_SMALL_SPIDER_VENOM;
            }
            if (nHD < 9)
            {
                return 14; // POISON_MEDIUM_SPIDER_VENOM;
            }
            if (nHD < 12)
            {
                return 18; // POISON_LARGE_SPIDER_VENOM;
            }
            if (nHD < 15)
            {
                return 26; // POISON_HUGE_SPIDER_VENOM;
            }
            if (nHD < 18)
            {
                return 36; // POISON_GARGANTUAN_SPIDER_VENOM;
            }
            return 35;  // POISON_COLOSSAL_SPIDER_VENOM;
        default:
            if (nHD < 3)
            {
                return 10; // POISON_NIGHTSHADE;
            }
            if (nHD < 6)
            {
                return 15; // POISON_BLADE_BANE;
            }
            if (nHD < 9)
            {
                return 12; // POISON_BLOODROOT;
            }
            if (nHD < 12)
            {
                return 18; // POISON_LARGE_SPIDER_VENOM;
            }
            if (nHD < 15)
            {
                return 17; // POISON_LICH_DUST;
            }
            if (nHD < 18)
            {
                return 18; // POISON_DARK_REAVER_POWDER;
            }
            return 20; //  POISON_BLACK_LOTUS_EXTRACT;
    }
    return 10;
}

const int DISEASE_CHECK_BOLT = 1;
const int DISEASE_CHECK_CONE = 2;
const int DISEASE_CHECK_PULSE = 3;


int GetCreatureDiseaseDC(int checkType)
{
    //Determine the disease type based on the Racial Type and HD
    int nRacial = GetRacialType(OBJECT_SELF);
    if (checkType == DISEASE_CHECK_CONE)
    {
        int nHD = GetHitDice(OBJECT_SELF);
        switch (nRacial)
        {
            case RACIAL_TYPE_OUTSIDER:
                return 18; // DISEASE_DEMON_FEVER
            case RACIAL_TYPE_VERMIN:
                return 13; // DISEASE_VERMIN_MADNESS
            case RACIAL_TYPE_UNDEAD:
                if(nHD <= 3)
                {
                    return 15; // DISEASE_ZOMBIE_CREEP;
                }
                else if (nHD > 3 && nHD <= 10)
                {
                    return 18; // DISEASE_GHOUL_ROT
                }
                else
                {
                    return 20; // DISEASE_MUMMY_ROT
                }
        }
        if(nHD <= 3)
        {
           return 12; // DISEASE_MINDFIRE
        }
        else if (nHD > 3 && nHD <= 10)
        {
            return 15; // DISEASE_RED_ACHE
        }
        return 13; // DISEASE_SHAKES
    }

    switch (nRacial)
    {
        case RACIAL_TYPE_VERMIN:
            return 13; // DISEASE_VERMIN_MADNESS
        case RACIAL_TYPE_UNDEAD:
            return 12; // DISEASE_FILTH_FEVER
        case RACIAL_TYPE_OUTSIDER:
            if(checkType == DISEASE_CHECK_BOLT && GetTag(OBJECT_SELF) == "NW_SLAADRED")
            {
                return 17; // DISEASE_RED_SLAAD_EGGS
            }
            return 18; // DISEASE_DEMON_FEVER
        case RACIAL_TYPE_MAGICAL_BEAST:
            return 25; // DISEASE_SOLDIER_SHAKES
        case RACIAL_TYPE_ABERRATION:
            return 16; // DISEASE_BLINDING_SICKNESS
    }

    if(checkType == DISEASE_CHECK_BOLT)
    {
        return 25; // DISEASE_SOLDIER_SHAKES
    }
    return 12; // DISEASE_MINDFIRE
}


int GetCurrentSpellSaveDC(int bFoundItemSpell, int spellLevel)
{
    int saveDCType = GetCurrentSpellSaveDCType();
    int saveDC;

    if (saveDCType < 0)
    {
        saveDC = (bFoundItemSpell ? (spellLevel * 3) / 2 + 10 : nMySpellCasterDC + spellLevel) + saveDCType - HENCH_SAVEDC_SPELL;
    }
    else if (saveDCType < HENCH_SAVEDC_HD_1)
    {
        saveDC = saveDCType;
    }
    else
    {
        switch (saveDCType)
        {
        case HENCH_SAVEDC_HD_1:
            saveDC = 10 + GetHitDice(OBJECT_SELF);
            break;
        case HENCH_SAVEDC_HD_2:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2;
            break;
        case HENCH_SAVEDC_HD_4:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 4;
            break;
        case HENCH_SAVEDC_HD_2_CONST:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2 + GetAbilityModifier(ABILITY_CONSTITUTION);
            break;
        case HENCH_SAVEDC_HD_2_CONST_MINUS_5:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2 + GetAbilityModifier(ABILITY_CONSTITUTION) - 5;
            break;
        case HENCH_SAVEDC_HD_2_WIS:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2 + GetAbilityModifier(ABILITY_WISDOM);
            break;
        case HENCH_SAVEDC_HD_2_PLUS_5:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2 + 5;	
            break;
		case HENCH_SAVEDC_HD_2_CHA:
            saveDC = 10 + GetHitDice(OBJECT_SELF) / 2 + GetAbilityModifier(ABILITY_CHARISMA);
			break;
        case HENCH_SAVEDC_DISEASE_BOLT:
            saveDC = GetCreatureDiseaseDC(DISEASE_CHECK_BOLT);
            break;
        case HENCH_SAVEDC_DISEASE_CONE:
            saveDC = GetCreatureDiseaseDC(DISEASE_CHECK_CONE);
            break;
        case HENCH_SAVEDC_DISEASE_PULSE:
            saveDC = GetCreatureDiseaseDC(DISEASE_CHECK_PULSE);
            break;
        case HENCH_SAVEDC_POISON:
            saveDC = GetCreaturePoisonDC();
            break;
        case HENCH_SAVEDC_EPIC:
			if ((gsCurrentspInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK) == HENCH_CASTING_INFO_USE_SPELL_TALENT)
			{
				saveDC = 25 + GetAbilityModifier(ABILITY_CHARISMA);
			}
			else
			{
				saveDC = 5 + GetEpicSpellSaveDC(OBJECT_SELF);
			}
			break;
        case HENCH_SAVEDC_DEATHLESS_MASTER_TOUCH:
            saveDC = 17 + ((GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF) > 10) ? ((GetLevelByClass(CLASS_TYPE_PALEMASTER,OBJECT_SELF) - 10) / 2) : 0);
            break;
        case HENCH_SAVEDC_UNDEAD_GRAFT:
            saveDC = /* 14 - 5 */ 9 + GetLevelByClass(CLASS_TYPE_PALEMASTER)/2;
            break;
        case HENCH_SAVEDC_DRAGON_DIS_BREATH:
            saveDC = 10 + GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF) + GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);
            break;
        case HENCH_SAVEDC_WARPRIEST_FEAR_AURA:
            saveDC = 10 + GetLevelByClass(CLASS_TYPE_WARPRIEST) + GetAbilityModifier(ABILITY_CHARISMA);
            break;
        case HENCH_SAVEDC_BARD_SLOWING:
            saveDC =  13 + (GetLevelByClass(CLASS_TYPE_BARD) / 2) + GetAbilityModifier(ABILITY_CHARISMA);
            break;
        case HENCH_SAVEDC_BARD_FASCINATE:
            saveDC =  11 + GetAbilityModifier(ABILITY_CHARISMA);
            break;
        default:
        // shouldn't get here
            saveDC = 15;
        }
    }
    return saveDC;
}


const int HENCH_SPELL_INFO_BUFF_MASK                = 0x0f000000;
const int HENCH_SPELL_INFO_BUFF_CASTER_LEVEL        = 0x01000000;
const int HENCH_SPELL_INFO_BUFF_HD_LEVEL            = 0x02000000;
const int HENCH_SPELL_INFO_BUFF_FIXED               = 0x03000000;
const int HENCH_SPELL_INFO_BUFF_CHARISMA            = 0x0b000000;
const int HENCH_SPELL_INFO_BUFF_BARD_LEVEL          = 0x0c000000;
const int HENCH_SPELL_INFO_BUFF_DRAGON				= 0x0d000000;

const int HENCH_SPELL_INFO_BUFF_LEVEL_ADJ_MASK      = 0x00f00000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_DIV_MASK      = 0x000f0000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_MASK     = 0x0000c000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_DICE     = 0x00000000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_ADJ      = 0x00004000;
//const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_COUNT  = 0x00008000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_CONST    = 0x0000c000;
const int HENCH_SPELL_INFO_BUFF_LEVEL_LIMIT_MASK    = 0x00003f00;
const int HENCH_SPELL_INFO_BUFF_AMOUNT_MASK         = 0x000000ff;


int GetCurrentSpellBuffAmount(int casterLevel)
{
    int buffInfo = GetCurrentSpellDamageInfo();

//  Jug_Debug(" buff Info " + IntToHexString(buffInfo) + " CL " + IntToString(casterLevel));
    int buffAmount = HENCH_SPELL_INFO_BUFF_AMOUNT_MASK & buffInfo;
    int buffType = buffInfo & HENCH_SPELL_INFO_BUFF_MASK;
    switch (buffType)
    {
    case HENCH_SPELL_INFO_BUFF_CASTER_LEVEL:
        break;
    case HENCH_SPELL_INFO_BUFF_HD_LEVEL:
        casterLevel = GetHitDice(OBJECT_SELF);
        break;
    case HENCH_SPELL_INFO_BUFF_FIXED:
//      Jug_Debug("buff amount " + IntToString(buffAmount));
        return buffAmount;
    case HENCH_SPELL_INFO_BUFF_CHARISMA:
        return GetAbilityModifier(ABILITY_CHARISMA);
    case HENCH_SPELL_INFO_BUFF_BARD_LEVEL:
        casterLevel = GetLevelByClass(CLASS_TYPE_BARD);
        break;
    case HENCH_SPELL_INFO_BUFF_DRAGON:
        casterLevel = GetHitDice(OBJECT_SELF);
        if (casterLevel > 37)
        {
            casterLevel = 12;
        }
        else if (casterLevel > 33)
        {
            casterLevel = 11;
        }
        else
        {
            casterLevel = (casterLevel - 1) / 3 + 3;
        }
        break;
    }

    int maxCasterLevel = (HENCH_SPELL_INFO_BUFF_LEVEL_LIMIT_MASK & buffInfo) >> 8;
    if (maxCasterLevel > 0)
    {
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }
    casterLevel -= (HENCH_SPELL_INFO_BUFF_LEVEL_ADJ_MASK & buffInfo) >> 20;

    if (maxCasterLevel > 0)
    {
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }

    int levelDiv = ((HENCH_SPELL_INFO_BUFF_LEVEL_DIV_MASK & buffInfo) >> 16) + 1;

//	Jug_Debug("caster level " + IntToString(casterLevel) + " div " + IntToString(levelDiv) + " amount " + IntToString(buffAmount) + " case " + IntToHexString(HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_MASK & buffInfo));

    switch (HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_MASK & buffInfo)
    {
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_DICE:
        return (buffAmount * (casterLevel / levelDiv) + 1) / 2;
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_ADJ:
        return buffAmount + casterLevel / levelDiv;
//  case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_COUNT:
//      return buffAmount * result.count;
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_CONST:
        return buffAmount * casterLevel / levelDiv;
    }
    return 3;
}


const int HENCH_SPELL_INFO_DAMAGE_MASK              = 0xf0000000;
const int HENCH_SPELL_INFO_DAMAGE_CASTER_LEVEL      = 0x00000000;
const int HENCH_SPELL_INFO_DAMAGE_HD_LEVEL          = 0x10000000;
const int HENCH_SPELL_INFO_DAMAGE_FIXED             = 0x20000000;
const int HENCH_SPELL_INFO_DAMAGE_CURE              = 0x30000000;
const int HENCH_SPELL_INFO_DAMAGE_DRAGON            = 0x40000000;
const int HENCH_SPELL_INFO_DAMAGE_SPECIAL_COUNT     = 0x50000000;
const int HENCH_SPELL_INFO_DAMAGE_CUSTOM	        = 0x60000000;
const int HENCH_SPELL_INFO_DAMAGE_DRAG_DISP         = 0x70000000;
const int HENCH_SPELL_INFO_DAMAGE_AA_LEVEL          = 0x80000000;
const int HENCH_SPELL_INFO_DAMAGE_WP_LEVEL          = 0x90000000;
const int HENCH_SPELL_INFO_DAMAGE_LAY_ON_HANDS      = 0xa0000000;
//const int HENCH_SPELL_INFO_DAMAGE_CHARISMA            = 0xb0000000;
const int HENCH_SPELL_INFO_DAMAGE_BARD_PERFORM      = 0xc0000000;
const int HENCH_SPELL_INFO_DAMAGE_WARLOCK           = 0xd0000000;

const int HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK    = 0x0c000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK   = 0x03000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE   = 0x00000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_ADJ    = 0x01000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_COUNT  = 0x02000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_CONST  = 0x03000000;
const int HENCH_SPELL_INFO_DAMAGE_FIXED_COUNT		= 0x0f000000;
const int HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK  = 0x00f00000;
const int HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK       = 0x000ff000;
const int HENCH_SPELL_INFO_DAMAGE_TYPE_MASK         = 0x00000fff;


struct sDamageInformation GetCurrentSpellDamage(int casterLevel, int bIsItem)
{
    struct sDamageInformation result;

    result.count = 1;

    int damageInfo = GetCurrentSpellDamageInfo();

    int curDamageScan = damageInfo & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;
    result.damageTypeMask = curDamageScan;

    int curDamageIndex;

    while (curDamageScan > 0)
    {
        if (curDamageScan & 0x1)
        {
            result.numberOfDamageTypes ++;
            if (result.numberOfDamageTypes == 1)
            {
                result.damageType1 = 1 << curDamageIndex;
            }
            else
            {
                result.damageType2 = 1 << curDamageIndex;
            }
        }
        curDamageScan = curDamageScan >> 1;
        curDamageIndex ++;
    }

//  Jug_Debug(" damage Info " + IntToHexString(damageInfo) + " CL " + IntToString(casterLevel) + " item " + IntToString(bIsItem));
    int damageAmount =  (HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK & damageInfo) >> 12;
    int damageType = damageInfo & HENCH_SPELL_INFO_DAMAGE_MASK;
    switch (damageType)
    {
    case HENCH_SPELL_INFO_DAMAGE_CASTER_LEVEL:
    case HENCH_SPELL_INFO_DAMAGE_CURE:
        break;
    case HENCH_SPELL_INFO_DAMAGE_HD_LEVEL:
        casterLevel = GetHitDice(OBJECT_SELF);
        break;
    case HENCH_SPELL_INFO_DAMAGE_FIXED:
        result.amount = IntToFloat(damageAmount);
        result.count = ((HENCH_SPELL_INFO_DAMAGE_FIXED_COUNT & damageInfo) >> 24) + 1;
//      Jug_Debug("damage amount " + IntToString(result.amount) + " count " + IntToString(result.count));
        return result;
    case HENCH_SPELL_INFO_DAMAGE_DRAGON:
        casterLevel = GetHitDice(OBJECT_SELF);
        if (casterLevel > 37)
        {
            casterLevel = 12;
        }
        else if (casterLevel > 33)
        {
            casterLevel = 11;
        }
        else
        {
            casterLevel = (casterLevel - 1) / 3 + 3;
        }
        break;
    case HENCH_SPELL_INFO_DAMAGE_SPECIAL_COUNT:
		{
			int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
		    if (maxCasterLevel > 0)
		    {
		        maxCasterLevel ++;
		        if (casterLevel > maxCasterLevel)
		        {
		            casterLevel = maxCasterLevel;
		        }
		    }
	        casterLevel ++;
			int levelDiv = ((HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK & damageInfo) >> 26) + 1;
	        casterLevel /= levelDiv;
	        result.count = casterLevel;
        	result.amount = IntToFloat(damageAmount * casterLevel);			
//			Jug_Debug("damage amount special count " + IntToString(result.count) + " amount " + FloatToString(result.amount));
		}
        return result;
    case HENCH_SPELL_INFO_DAMAGE_CUSTOM:
        casterLevel += 15;  // this is divided by three
        break;
    case HENCH_SPELL_INFO_DAMAGE_DRAG_DISP:
        casterLevel = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, OBJECT_SELF);
        if (casterLevel < 7)
        {
            casterLevel = 2;
        }
        else if (casterLevel < 10)
        {
            casterLevel = 4;
        }
        else if (casterLevel == 10)
        {
            casterLevel = 6;
        }
        else
        {
            casterLevel = 6 + ((casterLevel - 10) / 3);
        }
        break;
    case HENCH_SPELL_INFO_DAMAGE_AA_LEVEL:
        if ((HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK & damageInfo) == HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE)
        {
            casterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER);
            if (casterLevel > 10)
            {
                casterLevel = 10 + ((casterLevel - 10) / 2);
            }
            else
            {
                casterLevel = 10;
            }
        }
        else
        {
            result.amount = IntToFloat(ArcaneArcherDamageDoneByBow());
            return result;
        }
        break;
    case HENCH_SPELL_INFO_DAMAGE_WP_LEVEL:
        casterLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST, OBJECT_SELF);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LAY_ON_HANDS:
        {
            int nAmount = GetAbilityModifier(ABILITY_CHARISMA);
            if (nAmount <= 0)
            {
                result.amount = 0.0;
                return result;
            }
            nAmount *= GetLevelByClass(CLASS_TYPE_PALADIN) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);
            if (nAmount <= 0)
            {
                result.amount = 0.0;
                return result;
            }
            result.amount = IntToFloat(nAmount);
            return result;
        }
/*  case HENCH_SPELL_INFO_DAMAGE_CHARISMA:
        result.amount = GetAbilityModifier(ABILITY_CHARISMA);
        return result; */
    case HENCH_SPELL_INFO_DAMAGE_BARD_PERFORM:
		{
			location locCaster	= GetLocation(OBJECT_SELF);
		    int nNumEnemies   = 0;		   
		    // Count up enemy targets so we can divide up damage evenly.  Stop if there's more than 6, since min damage is floored at Total/6.
		    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
		    while(GetIsObjectValid(oTarget))
		    {
		        if ( GetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
		        {
		            nNumEnemies ++;
		        }		        
		        if (nNumEnemies >= 6)
		        {   // Don't need to go higher than 6 enemies.
		            break;
		        }		
		    	oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
		    }
		    if (nNumEnemies <= 0)
		    {
                result.amount = 0.0;
                return result;
		    }		    
		    int nPerformSkill = GetSkillRank(SKILL_PERFORM, OBJECT_SELF);
		    result.amount = (2.0 * nPerformSkill) / nNumEnemies;    // Damage per target is (2*Perform)/Number of Enemies, capped at most 6 enemies.
			result.count = 3;
			return result;
		}
        return result;
    case HENCH_SPELL_INFO_DAMAGE_WARLOCK:
        result.amount = IntToFloat((7 * giWarlockDamageDice + 1 ) / 2);
        if (gbWarlockMaster)
        {
            result.amount *= 1.5;
        }
        return result;
    }

    int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
    if (maxCasterLevel > 0)
    {
        maxCasterLevel *= 5;
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }

    if (damageType == HENCH_SPELL_INFO_DAMAGE_CURE)
    {
        damageAmount += casterLevel;
        if (!bIsItem && GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
        {
            damageAmount += (damageAmount / 2);
        }
        if (!bIsItem && GetHasFeat(FEAT_AUGMENT_HEALING))
        {
            // max caster level related to spell level * 5
            damageAmount += 2 * (maxCasterLevel / 5);
        }
        result.amount = IntToFloat(damageAmount);
        return result;
    }

    int levelDiv = ((HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK & damageInfo) >> 26) + 1;

//  Jug_Debug("caster level " + IntToString(casterLevel) + " div " + IntToString(levelDiv) + " amount " + IntToString(damageAmount) + " case " + IntToHexString(HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK & damageInfo));

    switch (HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK & damageInfo)
    {
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE:
        result.amount = IntToFloat((damageAmount * (casterLevel / levelDiv) + 1) / 2);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_ADJ:
        result.amount = IntToFloat(damageAmount + casterLevel / levelDiv);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_COUNT:
        result.count = casterLevel / levelDiv;
        result.amount = IntToFloat(damageAmount * result.count);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_CONST:
        result.amount = IntToFloat(damageAmount * casterLevel / levelDiv);
        break;
    default:
        result.amount = 10.0;
    }
    return result;
}


float GetDamageResistImmunityAdjustment(object oTarget, float damageAmount, int damageType, int count)
{
    if (GetLocalInt(oTarget, damageInformationStr) & damageType)
    {
//		Jug_Debug(GetName(oTarget) + " doing damage adjust start " + FloatToString(damageAmount) + " damage type " + IntToHexString(damageType));
        damageAmount *= GetFloatArray(oTarget, HENCH_DAMAGE_IMMUNITY_STR, damageType);
        damageAmount -= GetIntArray(oTarget, HENCH_DAMAGE_RESIST_STR, damageType) * count;
//			Jug_Debug(GetName(oTarget) + " doing damage adjust immunity " + FloatToString(damageAmount));
//		Jug_Debug(GetName(oTarget) + " doing damage adjust resist " + FloatToString(damageAmount));
        if (damageAmount < 0.5)
        {
            damageAmount = 0.0;
        }
    }
    return damageAmount;
}


float CalculateDamageWeight(float damageAmount, object oTarget)
{
//Jug_Debug(GetName(oTarget) + " HP " + IntToString(GetCurrentHitPoints(oTarget)));
    int currentHitPoints = GetCurrentHitPoints(oTarget);
    if (currentHitPoints < 1)
    {
        // assume a bleed system is used (HENCH_BLEED_NEGHPS is a negative number)
        if(GetPartyMembersDyingFlag() == FALSE)
			currentHitPoints -= HENCH_BLEED_NEGHPS;

        if (currentHitPoints < 1)
        {
            currentHitPoints = 1;
        }
    }
    damageAmount /= IntToFloat(currentHitPoints);
    if (damageAmount > 1.0)
    {
        damageAmount = 1.0;
    }
    return damageAmount;
}


float GetConcetrationWeightAdjustment(int spellInformation, int spellLevel)
{
    float result = 1.0;
    if (spellInformation & HENCH_SPELL_INFO_UNLIMITED_FLAG)
    {
        result *= 1.2;
    }
    if (bgMeleeAttackers & (spellInformation & HENCH_SPELL_INFO_CONCENTRATION_FLAG))
    {
        if (spellInformation & HENCH_SPELL_INFO_ITEM_FLAG)
        {
            result *= 0.33;
        }
        else
        {
            result *= Getd20Chance(nMySpellCastingConcentration - 15 - spellLevel);
        }
    }
    return result;
}


int GetSpellInformation(int nSpellID)
{
    gCurrentSpellInfoStr = HENCH_SPELL_ID_INFO + IntToString(nSpellID);

    int spellIDInfo = GetLocalInt(GetModule(), gCurrentSpellInfoStr);

    if ((spellIDInfo & HENCH_SPELL_INFO_VERSION_MASK) != HENCH_SPELL_INFO_VERSION)
    {
        string columnInfo = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_INFO_COLUMN_NAME, nSpellID);
//      Jug_Debug(GetName(OBJECT_SELF) + " loading 2da " + columnInfo + " prev version " + IntToHexString(spellIDInfo & HENCH_SPELL_INFO_VERSION_MASK));
        spellIDInfo = StringToInt(columnInfo);
        if (spellIDInfo == 0)
        {
            // don't know anything about this spell
            spellIDInfo = HENCH_SPELL_INFO_VERSION | HENCH_SPELL_INFO_IGNORE_FLAG;
        }
        else if (spellIDInfo & HENCH_SPELL_INFO_MASTER_FLAG)
        {
            int currentIndex = 1;
            while (currentIndex <= 5)
            {
                string subSpellStr = "SubRadSpell" + IntToString(currentIndex);

                string columnInfo = Get2DAString("spells", subSpellStr ,nSpellID);
                int subSpellID = StringToInt(columnInfo);
//  Jug_Debug(GetName(OBJECT_SELF) + "init sub spell " + IntToString(subSpellID));
                if (subSpellID <= 0)
                {
                	DeleteLocalInt(GetModule(), gCurrentSpellInfoStr + subSpellStr);
                    break;
                }
                SetLocalInt(GetModule(), gCurrentSpellInfoStr + subSpellStr, subSpellID);
                currentIndex++;
            }
        }
        else
        {
            string targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_TARGET_COLUMN_NAME, nSpellID);
            SetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_TARGET_COLUMN_NAME, StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME, nSpellID);
            SetLocalFloat(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_EFFECT_WEIGHT_COLUMN_NAME, StringToFloat(targetInfoStr));

            targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME, nSpellID);
            SetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_EFFECT_TYPES_COLUMN_NAME, StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME, nSpellID);
            SetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_DAMAGE_INFO_COLUMN_NAME, StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_SAVE_TYPE_COLUMN_NAME, nSpellID);
            SetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_SAVE_TYPE_COLUMN_NAME, StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString(HENCH_SPELL_ID_TABLE, HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME, nSpellID);
            SetLocalInt(GetModule(), gCurrentSpellInfoStr + HENCH_SPELL_SAVE_DC_TYPE_COLUMN_NAME, StringToInt(targetInfoStr));
        }
        SetLocalInt(GetModule(), gCurrentSpellInfoStr, spellIDInfo);
    }

    return spellIDInfo;
}


object goBestSpellCaster;

int HenchPerceiveSpellcasterThreat()
{
    int mageThreshold = GetHitDice(OBJECT_SELF) * 2 / 3;
    if (mageThreshold > 15)
    {
        mageThreshold = 15;
    }
    int clericThreshold = GetHitDice(OBJECT_SELF) * 4 / 5;
    if (clericThreshold > 15)
    {
        clericThreshold = 15;
    }
	
    object goBestSpellCaster = GetLocalObject(OBJECT_SELF, sLineOfSight);

    while (GetIsObjectValid(goBestSpellCaster))
    {
        if (GetLevelByClass(CLASS_TYPE_WIZARD, goBestSpellCaster) >= mageThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_SORCERER, goBestSpellCaster) >= mageThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_CLERIC, goBestSpellCaster) >= clericThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_DRUID, goBestSpellCaster) >= clericThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_WARLOCK, goBestSpellCaster) >= clericThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, goBestSpellCaster) >= clericThreshold)
        {
            return TRUE;
        }
        if (GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, goBestSpellCaster) >= clericThreshold)
        {
            return TRUE;
        }
        goBestSpellCaster = GetLocalObject(goBestSpellCaster, sLineOfSight);
    }
    return FALSE;
}


const int HENCH_GLOBAL_FLAG_UNCHECKED   = 0;
const int HENCH_GLOBAL_FLAG_TRUE        = 1;
const int HENCH_GLOBAL_FLAG_FALSE       = 2;

int gHenchUseSpellProtectionsChecked;

int HenchUseSpellProtections()
{
// only do the first check
    if (gHenchUseSpellProtectionsChecked)
    {
        return gHenchUseSpellProtectionsChecked == HENCH_GLOBAL_FLAG_TRUE ? TRUE : FALSE;
    }
    if (gbGlobalAttrBuffOver || HenchPerceiveSpellcasterThreat())
    {
        gHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_TRUE;
        return TRUE;
    }
    gHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_FALSE;
    return FALSE;
}


void HenchCheckDetectInvisibility()
{
/*    if (spellID == SPELL_BLINDSIGHT || spellID == SPELL_TRUE_SEEING ||
        spellID == SPELL_I_DEVILS_SIGHT)
    {
        int negEffects = GetCreatureNegEffects(OBJECT_SELF);
        if (negEffects & HENCH_EFFECT_TYPE_DARKNESS)
        {
            float effectWeight = gsCurrentspInfo.spellID == SPELL_TRUE_SEEING ? 5001.0 : 5000.0;			
			HenchCheckIfHighestSpellLevelToCast(effectWeight, OBJECT_SELF);
            return;
        }
    } */

    object oTarget;
    if (GetIsObjectValid(ogClosestHeardEnemy))
    {
        oTarget = ogClosestHeardEnemy;
    }
    else if (GetIsObjectValid(ogNotHeardOrSeenEnemy))
    {
        oTarget = ogNotHeardOrSeenEnemy;
    }
    else
    {
        return;
    }

    float effectWeight;
	int spellID = gsCurrentspInfo.spellID;
    if (spellID == SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE)
    {
        if ((GetStealthMode(oTarget) == STEALTH_MODE_ACTIVATED) &&
            !GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE) &&
            !GetHasSpellEffect(SPELL_AMPLIFY))
        {
            effectWeight = 0.4;
        }
    }
    else if (spellID == SPELL_AMPLIFY)
    {
        if ((GetStealthMode(oTarget) == STEALTH_MODE_ACTIVATED) &&
            !GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE) &&
            !GetHasSpellEffect(SPELL_AMPLIFY) &&
            !GetObjectHeard(oTarget))
        {
            effectWeight = 0.3;
        }
    }
    else if (spellID == SPELL_TRUE_SEEING)
    {
        if (GetStealthMode(oTarget) == STEALTH_MODE_ACTIVATED)
        {
            effectWeight = 0.75;
        }
        else
        {
            int enemyPosEffects = GetCreaturePosEffects(oTarget);
            if (enemyPosEffects & (HENCH_EFFECT_TYPE_INVISIBILITY | HENCH_EFFECT_TYPE_SANCTUARY))
            {
                effectWeight = 0.75;
            }
        }
    }
    else
    {
        int enemyPosEffects = GetCreaturePosEffects(oTarget);
        if (enemyPosEffects & (HENCH_EFFECT_TYPE_INVISIBILITY))
        {
            effectWeight = 0.70;
        }
    }
	effectWeight *= GetThreatRating(oTarget);
    if (effectWeight > 0.0)
    {
        HenchCheckIfLowestSpellLevelToCast(effectWeight, OBJECT_SELF);
    }
}


void HenchInitializeInvisibility(int posEffectsOnSelf)
{
    if (posEffectsOnSelf & HENCH_EFFECT_INVISIBLE)
    {
        return;
    }
    gbCheckInvisbility = TRUE;

    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_TRUE_SEEING)))
    {
        gbTrueSeeingNear = TRUE;
        return;
    }
    // since GetCreatureHasItemProperty is an expensive call, only do for closest
    if (GetIsObjectValid(ogClosestSeenEnemy))
    {
     /*   if (GetHasFeat(FEAT_BLINDSIGHT_60_FEET, oTarget))
        {
            return TRUE;
        } */
        if (GetCreatureHasItemProperty(ITEM_PROPERTY_TRUE_SEEING, ogClosestSeenEnemy))
        {
            gbTrueSeeingNear = TRUE;
            return;
        }
    }
    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_SEE_INVISIBILITY)))
    {
        gbSeeInvisNear = TRUE;
        return;
    }
}


void HenchTalentStealth(int iMeleeAttackers, int bCheckStealthDetect = TRUE)
{
    if (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
    {
        return;
    }
    int bHideInPlainSight = GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT) /* ||
        (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT_OUTDOORS) && GetIsAreaNatural(GetArea(OBJECT_SELF)))*/;
    if (!bHideInPlainSight && !GetSpawnInCondition(NW_FLAG_STEALTH) &&
        !(GetHenchOption(HENCH_OPTION_STEALTH) & HENCH_OPTION_STEALTH))
    {
        return;
    }
    if (bCheckStealthDetect)
    {
        if (gbTrueSeeingNear)
        {
            return;
        }
    }

    int nThreshold = GetHitDice(OBJECT_SELF) / 2;
    if ((GetSkillRank(SKILL_HIDE, OBJECT_SELF, TRUE) <= nThreshold) &&
        (GetSkillRank(SKILL_MOVE_SILENTLY, OBJECT_SELF, TRUE) <= nThreshold))
    {
        return;
    }

    if (bHideInPlainSight ||
        (!GetIsObjectValid(ogClosestSeenEnemy) &&
        !LineOfSightObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY), OBJECT_SELF)))
    {
//		Jug_Debug(GetName(OBJECT_SELF) + " using stealth");
        // try to sneak up to target
        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
    }
}


void HenchCheckIfAttackSpellToCastOnObject(float fFinalTargetWeight, object oTarget)
{
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= GetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);

        if (fFinalTargetWeight >= gfAttackTargetWeight)
        {
//			Jug_Debug("&&&&" + GetName(OBJECT_SELF) + " putting attack spell in weight " + FloatToString(fFinalTargetWeight));

            if ((gfAttackTargetWeight == 0.0) || (fFinalTargetWeight >= gfAttackTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsAttackTargetInfo.spellLevel) ||
                !GetIsObjectValid(gsAttackTargetInfo.oTarget))
            {
//				Jug_Debug("****" + GetName(OBJECT_SELF) + " really putting attack spell in weight " + FloatToString(fFinalTargetWeight));
                gfAttackTargetWeight = fFinalTargetWeight;
                gsAttackTargetInfo = gsCurrentspInfo;
                gsAttackTargetInfo.oTarget = oTarget;
            }
        }
    }
}


void HenchCheckIfAttackSpellToCastAtLocation(float fFinalTargetWeight, location lTargetLocation)
{
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= GetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);

        if (fFinalTargetWeight >= gfAttackTargetWeight)
        {
//			Jug_Debug("&&&&" + GetName(OBJECT_SELF) + " putting attack spell in weight " + FloatToString(fFinalTargetWeight));

            if ((gfAttackTargetWeight == 0.0) || (fFinalTargetWeight >= gfAttackTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsAttackTargetInfo.spellLevel))
            {
//				Jug_Debug("****" + GetName(OBJECT_SELF) + " really putting attack spell in weight " + FloatToString(fFinalTargetWeight));
                gfAttackTargetWeight = fFinalTargetWeight;

                gsAttackTargetInfo = gsCurrentspInfo;
                gsAttackTargetInfo.oTarget = OBJECT_INVALID;
                gsAttackTargetInfo.lTargetLoc = lTargetLocation;
            }
        }
    }
}


void HenchCheckIfHighestSpellLevelToCast(float fFinalTargetWeight, object oTarget)
{
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= GetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);
		giNumberOfPendingBuffs++;
        if ((fFinalTargetWeight >= gfBuffTargetWeight) &&
			((gfBuffTargetWeight == 0.0) || (fFinalTargetWeight >= gfBuffTargetWeight * 1.02) ||
            (gsCurrentspInfo.spellLevel > gsBuffTargetInfo.spellLevel)))
        {
//          Jug_Debug("****" + GetName(OBJECT_SELF) + " really putting global attack spell in weight " + FloatToString(fFinalTargetWeight));
			bfBuffTargetAccumWeight = fFinalTargetWeight + bfBuffTargetAccumWeight / 2.0;
            gfBuffTargetWeight = fFinalTargetWeight;
            gsBuffTargetInfo = gsCurrentspInfo;
            gsBuffTargetInfo.oTarget = oTarget;
        }
		else
		{
			bfBuffTargetAccumWeight += fFinalTargetWeight / 2.0;
		}
    }
}


void HenchCheckIfLowestSpellLevelToCast(float fFinalTargetWeight, object oTarget)
{
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= GetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);
		giNumberOfPendingBuffs++;
        if ((fFinalTargetWeight >= gfBuffTargetWeight) && 
			((gfBuffTargetWeight == 0.0) || (fFinalTargetWeight >= gfBuffTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsBuffTargetInfo.spellLevel)))
        {
//          Jug_Debug("****" + GetName(OBJECT_SELF) + " really putting global attack spell in weight " + FloatToString(fFinalTargetWeight));
			bfBuffTargetAccumWeight = fFinalTargetWeight + bfBuffTargetAccumWeight / 2.0;
            gfBuffTargetWeight = fFinalTargetWeight;
            gsBuffTargetInfo = gsCurrentspInfo;
            gsBuffTargetInfo.oTarget = oTarget;
        }
		else
		{
			bfBuffTargetAccumWeight += fFinalTargetWeight / 2.0;
		}
    }
}


int HenchCheckDruidAnimalTarget(object oTarget)
{
    int iRacialType = GetRacialType(oTarget);
    return (iRacialType == RACIAL_TYPE_ANIMAL)
        || (iRacialType == RACIAL_TYPE_BEAST)
        || (iRacialType == RACIAL_TYPE_VERMIN);
}
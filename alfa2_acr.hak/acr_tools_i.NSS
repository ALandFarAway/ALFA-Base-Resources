////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_tools_i
//    $Revision:: 571        $ current version of the file
//        $Date:: 2008-11-10#$ date the file was created or modified
//       Author : Ronan
//
//  Local Variable Prefix = None, stand-alone functions shouldn't need any!
//
//  Description
//  Various tools used in conjuction with the ALFA core scripts. Only stand-
//  alone functions should go here! Anything more complex should get its own
//  file.
//
//  Revision History
//  2006/11/21   i p h  r  Added transfer inventory function
//  2006/12/25  Ronan:       Added GetIsPlayer()
//  2007/02/28  v220 AcadiusLost	  Changed RandomFloat (no longer uses MAX_INT)
//  2007/03/04  v221 AcadiusLost      Changed/Fixed GetIsIntegerInWindow() 
//  2007/03/05  v222 AcadiusLost      Another fix to RandomFloat (halved the integer range)
//                                     also added debugging reports to GetIsIntegerInWindow, commented out.
//  2007/03/13  v223 AcadiusLost      changed GetPiecewiseInteger() to perform logical shifts (no more
//                                     negative number results, full range of integers can result now.
//                                     also cleared some debugging reports.
//  2008/08/30  v224 AcadiusLost	  Changed RandomFloat() to ACR_RandomFloat() to stop conflict with ginc_math
//  2008/11/10 		 AcadiusLost      Migrated ACR_CleanCreatureNameTextForPlayers(string sRawInput)
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "ginc_math"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int BIT_0     = 1;
const int BIT_1     = 2;
const int BIT_2     = 4;
const int BIT_3     = 8;
const int BIT_4     = 16;
const int BIT_5     = 32;
const int BIT_6     = 64;
const int BIT_7     = 128;
const int BIT_8     = 256;
const int BIT_9     = 512;
const int BIT_10    = 1024;
const int BIT_11    = 2048;
const int BIT_12    = 4096;
const int BIT_13    = 8192;
const int BIT_14    = 16384;
const int BIT_15    = 32768;
const int BIT_16    = 65536;
const int BIT_17    = 131072;
const int BIT_18    = 262144;
const int BIT_19    = 524288;
const int BIT_20    = 1048576;
const int BIT_21    = 2097152;
const int BIT_22    = 4194304;
const int BIT_23    = 8388608;
const int BIT_24    = 16777216;
const int BIT_25    = 33554432;
const int BIT_26    = 67108864;
const int BIT_27    = 134217728;
const int BIT_28    = 268435456;
const int BIT_29    = 536870912;
const int BIT_30    = 1073741824;
const int BIT_31    = 2147483648;

const int MAX_INT = 2147483647;
const int MIN_INT = -2147483648;
const float MAX_FLOAT = 340282300000000000000000000000000000000.0;
const float MIN_FLOAT = -340282300000000000000000000000000000000.0;

const float MAX_RND_FLOAT = 32767.0;
const int MAX_RND_INT = 32767;

const int INT_SIZE = 32;

const int DAYS_PER_MONTH = 28;

const float PC_PERCEPTION_RANGE = 40.0;

const int ARMOR_TYPE_INVALID = 0;
const int ARMOR_TYPE_CLOTHING = 1;
const int ARMOR_TYPE_LIGHT = 2;
const int ARMOR_TYPE_MEDIUM = 3;
const int ARMOR_TYPE_HEAVY = 4;

const float MATH_CONSTANT_E = 2.718281828459045235360287471352662497757247093699959574966;

location LOCATION_INVALID;


const float ACR_LOCATION_SEARCH_RADIUS = 2.0f;

const float ACR_AREA_TRANSITION_ZDIFF_MAX = 1.0f;


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Removes all the effects on oObject which were created by oSource.
//! Returns the number of effects removed.
int RemoveAllEffectsFrom(object oObject, object oSource);

// Gets the effective caster level oPC has in nClass's spell list.
// Returns 0 on error.
int GetClassCasterLevel(int nClass, object oPC);

// Returns the ability score (one of the ABILITY_* constants) nClasses uses
// to cast spells.
// Returns 0 on error.
int GetCasterClassAbilityScore(int nClass);

// Destroy oObject's inventory, but does not touch equiped items.
// Returns the number of items destroyed.
int DestroyInventory(object oObject);

//! Transfer inventory from oSource to oTarget
//!  - oSource: Source object with inventory to transfer
//!  - oTarget: Target object with inventory to receive
//!  - sResRef: Blueprint ResRef that you want to ignore
//!  - Returns: Nothing
void ACR_TransferInventory(object oSource, object oTarget, string sResRef = "");

// Returns an area based on its tag and resref.
// Returns OBJECT_INVALID if no matching area is found.
object GetAreaFromTagAndResref(string sResRef, string sTag);

// Returns a location in oNewArea with the same position and facing as
// lOldLocation.
location GetLocationInDifferentArea(location lOldLocation, object oNewArea);

// Sets oCreature's hit points to nHp, healing or harming the target as is
// necissary. Any damage delt is done using nDamageType.
// This function cannot set a creature's hit points above its maximum, and it
// does not account for damage resistances or immunities to nDamageType.
void SetHitPoints(object oCreature, int nHp, int nDamageType);

// If nInt is less than nMin, nMin is returned.
// If nInt is greater than nMax, nMax is returned.
// Otherwise nInt is returned.
int ApplyIntegerLimit(int nInt, int nMin, int nMax);

// Returns the experience points normal creatures need to reach nLevel;
int GetXpNeededForLevel(int nLevel);

// Returns 1 if oArea is an area, 0 otherwise.
int GetIsArea(object oArea);

// Increments local integer sVarName on oObject by nIncrement, then returns the
// final value.
int IncrementLocalInt(object oObject, string sVarName, int nIncrement);

// Increments local float sVarName on oObject by fIncrement, then returns the
// final value.
float IncrementLocalFloat(object oObject, string sVarName, float fIncrement);

// Sets the nBit of local integer sVarName on oObject to 1 if nValue is nonzero.
// Otherwise, sets the bit to 0.
int SetLocalBit(object oObject, string sVarName, int nBit, int nValue);

//! Exponential function
float exp(float f);

//! Generates a random float value between fMin and fMax.
//! Does not error checking on inputs.
float ACR_RandomFloat(float fMin = 0.0, float fMax = 1.0);

//! Returns a randomized value on a gaussian (normal) distribution using the polar form of the Box-Muller Transformation.
//! taking into account mean fMean and standard deviation fStd
float ACR_RandomNormal(float fMean=0.0f, float fStd=1.0f);

// Makes a new interger out of nNum, starting at bit nStartBit and ending at
// nEndBit.  Returned value is an unsigned integer only.
// Does not error checking on inputs. Valid values for nStartBit and nEndBit are
// from 0 to INT_MAX - 1.
int GetPiecewiseInteger(int nNum, int nStartBit, int nEndBit);

// Returns an object's name, tag and resref in a string, in the form:
// [Name] (tagged [Tag] of resref [ResRef])
string GetObjectInfoAsString(object oObject);

// Returns the type of an object as a string ("creature", "item", "door", etc).
string GetObjectTypeName(int nObjectType);

// Returns the name of oItem's base item type, or "" if there is an error.
string GetBaseItemTypeName(object oItem);

// Returns oItem's armor class before any item properties are taken into
// account. Returns -1 if oItem is not armor.
//int GetBaseArmorClass(object oItem);
// Does work, no GetIP* function seems to return the magical AC bonus.
// Fix in NWN2?

// Returns oItem's spell failure % before any item properties are taken into
// account. Returns 0 if oItem is not armor.
int GetBaseSpellFailure(object oItem);

// Returns oItem's spell failure, taking items into account.
// Returns 0 if oItem is not armor.
int GetTotalSpellFailure(object oItem);

// Returns a string of the type of armor oArmor is. Possible results are:
// "padded", "leather", "studded leather", "chain shirt", "hide", "scail mail",
// "chainmail", "breastplate", "splint mail", "banded mail", "half plate",
// "full plate".
string GetArmorTypeName(object oArmor);

// Gets the greatest property associated with item property of type nPropertyType
// on item oItem. Returns 0 if oItem is not an item, or if no such item property
// is found.
int GetHighestItemPropertyParam1(object oItem, int nType);

// Gets the greatest value associated with item property of type nPropertyType
// on item oItem. Returns 0 if oItem is not an item, or if no such item property
// is found.
int GetHighestItemPropertyParam1Value(object oItem, int nType);

// Returns the SKILL_KNOWLEDGE_* constant of the skill which indicates knowlege
// of race nRace. Returns -1 on an error, or if there is no appropriate skill.
// Follows the D20 SRD.
int GetKnowlegeSkillOfRace(int nRace);

// Returns 1 if there is a PC, DM, or DM-possesssed creature in oArea.
// Returns 0 otherwise.
int GetArePCsInArea(object oArea);

// Gets the first item possessed by oCreature that has a resref sResRef.
// Returns OBJECT_INVALID if nothing is found.
object GetItemOfResRefPossessedBy(object oCreature, string sResRef);

// Returns 1 if nNum is in the window defined by nStart and nEnd. The window can
// be circular, so that nEnd wraps around and has a lower value than nStart.
int GetIsIntegerInWindow(int nNum, int nStart, int nEnd);

//! Returns the number of seconds until the time specified in the arguments.
int GetSecondsUntil(int nYear, int nMonth, int nDay, int nHour, int nMinute, int nSecond);

//! Gets a local integer from oObject, adds it to a bitwise boolean nFlags at
//! bit nBit, and deletes the original local integer.
int CombineBooleanLocalInt(int nFlags, object oObject, string sVarName, int nBit);

//! Returns the EffectMovementSpeedIncrease() (or decrease) effect needed to
//! increase oCreature's speed as if oCreature did not have any feats and class
//! altered increasing his speed. In other words, this function returns an
//! reduced movement compinsating for hard-coded movement speed feats like
//! barbarian endurance and monk speed.
//!   - fMovementChange: The desired movement speed modifier, with 1.0 being no change, 1.5 being 50% faster, and 0.5 being 50% slower.
effect EffectAdjustedMovementSpeed(object oCreature, float fMovementChange);

//! Returns the ARMOR_TYPE_* constant corresponding to the type of armor passed,
//! or ARMOR_TYPE_INVALID if oItem is not a valid armor item.
//int GetArmorType(object oItem);
// Doesn't work without GetBaseArmor class. Fix in NWN2?

//! Formats the current in-game time as H:M:S.MS.
string GetTimeAsString();

//! Formats the current in-game date as YYYY-MM-DD.
string GetDateAsString();

//! Generates a random number between MIN_INT and MAX_INT.
int GenerateRandomSeed();

//! Returns 1 if oItem is a small, large or tower shield, and 0 otherwise.
int GetIsItemShield(object oItem);

//! Returns 1 if oCreature is a PC or player-controlled object such as a
//! familiar.
//! Returns 0 if oCreature is a DM, DM-possessed creature, or anything else.
int GetIsPlayer(object oCreature);

//! Returns a string for the name of a creature with { } bracketed text removed.
string ACR_CleanCreatureNameTextForPlayers(string sRawInput);

//! Delete all local variables on oObject with sString in their name.
int DeleteAllLocalsWithString(object oOjbect, string sString);

//! Returns the spell script for nFeat, or "" if there is none.
string GetFeatSpellScript(int nFeat);

//! Broadcast message to all dms
void BroadcastToDMs(string sText);

//! Is this letter a vowel?
int IsVowel(string s);

//! Return article for noun
string GetArticle(string s);

//! Pluralize noun
string Pluralize(string s);

//! Color a block of text
string Colorize(string sText, string sColor);

object ACR_GetNearestCreatureToLocation(object oPC, int nFirstCriteriaType, int nFirstCriteriaValue,  location lLocation, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1);

//! Expanded CalcSafeLocation that should be a little more reliable
location ACR_CalcSafeLocation(object oClicker, location lTarget);

//LIST MANAGEMENT
//note about lists : List have to be like "#1#5#26#99# ..." in order to work properly. See nwnx_craft_set_constatns for details

//loops forwards entries in the given list and the current value  
int XPCraft_GetNextEntryInList(string sList, int iCurrentEntry);
//loops backwards entries in the given list and the current value   
int XPCraft_GetPreviousEntryInList(string sList, int iCurrentEntry);
//Get the fist value in the given list 
int XPCraft_GetFirstEntryInList(string sList);
//get the last value in the given list 
int XPCraft_GetLastEntryInList(string sList);
//Check if an element is in a list (returns TRUE if found, else FALSE if not).
int XPCraft_IsElementInList(string sList, int nElement);


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int RemoveAllEffectsFrom(object oObject, object oSource) {
	int nRemoved = 0;
	effect eff = GetFirstEffect(oObject);
	while(GetIsEffectValid(eff)) {
		if(oSource == GetEffectCreator(eff)) {
			RemoveEffect(oObject, eff);
			nRemoved++;
		}
		eff = GetNextEffect(oObject);
	}
	return nRemoved;
}

int GetClassCasterLevel(int nClass, object oPC) {
    int nLevels = GetLevelByClass(nClass, oPC);
    if(nClass == CLASS_TYPE_PALADIN || nClass == CLASS_TYPE_RANGER)
        {
        if(nLevels < 4)
        {
            return 0;
        }
        return nLevels / 2;
    } else {
        return GetLevelByClass(nClass, oPC);
    }
}

int GetCasterClassAbilityScore(int nClass) {
    switch(nClass) {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
            return ABILITY_CHARISMA;

        case CLASS_TYPE_WIZARD:
            return ABILITY_INTELLIGENCE;

        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_DRUID:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
            return ABILITY_WISDOM;
    }
    return 0;
}

int DestroyInventory(object oObject)
{
    int nCount = 0;
    object oItem = GetFirstItemInInventory(oObject);

    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
        nCount++;
    }
    return nCount;
}

void ACR_TransferInventory(object oSource, object oTarget, string sResRef = "")
{
    object oItem = GetFirstItemInInventory(oSource);

    // loop through inventory
    while (GetIsObjectValid(oItem))
    {
        // skip resref? handy for leaving behind unwanted tokens
        if (GetResRef(oItem) != sResRef) { AssignCommand(oSource, ActionGiveItem(oItem, oTarget)); }
        oItem = GetNextItemInInventory(oSource);
    }
}

object GetAreaFromTagAndResref(string sResRef, string sTag) {
    object oArea;
    int i = 0;
    while(TRUE) {
        oArea = GetObjectByTag(sTag, i);
        if(oArea == OBJECT_INVALID) {
            return OBJECT_INVALID;
        } else if(GetTag(oArea) == sTag) {
            return oArea;
        }
        i++;
    }
    return OBJECT_INVALID;
}

location GetLocationInDifferentArea(location lOldLocation, object oNewArea) {
    return Location(oNewArea, GetPositionFromLocation(lOldLocation), GetFacingFromLocation(lOldLocation));
}

void SetHitPoints(object oCreature, int nHp, int nDamageType) {
    int nCurrentHp = GetCurrentHitPoints(oCreature);
    int nMaxHp = GetMaxHitPoints(oCreature);
    if(nHp > nCurrentHp) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHp), oCreature);
    } else if(nHp < nCurrentHp) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nHp, nDamageType), oCreature);
    }
}

int ApplyIntegerLimit(int nInt, int nMin, int nMax) {
    if(nInt < nMin) {
        return nMin;
    } else if(nInt > nMax) {
        return nMax;
    } else {
        return nInt;
    }
}

int GetXpNeededForLevel(int nLevel) {
    return FloatToInt(1000 * (nLevel - 1) * ( IntToFloat(nLevel) / 2.0 ));
}

int GetIsArea(object oArea) {
    return (GetIsAreaNatural(oArea) != AREA_INVALID);
}

int IncrementLocalInt(object oObject, string sVarName, int nIncrement) {
    int num = GetLocalInt(oObject, sVarName);
    num += nIncrement;
    SetLocalInt(oObject, sVarName, num);
    return num;
}

float IncrementLocalFloat(object oObject, string sVarName, float fIncrement) {
    float num = GetLocalFloat(oObject, sVarName);
    num += fIncrement;
    SetLocalFloat(oObject, sVarName, num);
    return num;
}

int SetLocalBit(object oObject, string sVarName, int nBit, int nValue) {
    int nNum = GetLocalInt(oObject, sVarName);
    if(nValue) {
        nNum | (1 << nBit);
    } else {
        nNum & (0 << nBit);
    }
    SetLocalInt(oObject, sVarName, nNum);
    return nNum;
}

float atan2(float y, float x)
{
	if (fabs(y) < EPSILON)
		return 0.0;

	return 2*atan((sqrt(x*x+y*y)-x)/y);
}

float exp(float f)
{
	return pow(MATH_CONSTANT_E, f);
}

// lifted from ftp://ftp.taygeta.com/pub/c/boxmuller.c by AcadiusLost.
float ACR_RandomNormal(float fMean=0.0f, float fStd=1.0f)
{
    float x1, x2, w;

    // was already generated
    if (GetGlobalInt("ACR_RND_CACHED")) {
        SetGlobalInt("ACR_RND_CACHED",0);
        return fMean + (GetGlobalFloat("ACR_RND") * fStd);
    }

    do {
        x1 = 2.0 * ACR_RandomFloat() - 1.0;
        x2 = 2.0 * ACR_RandomFloat() - 1.0;
        w = x1 * x1 + x2 * x2;
    } while (w >= 1.0);
	
    w = sqrt((-2.0 * log(w))/w);
    SetGlobalInt("ACR_RND_CACHED",1);
    SetGlobalFloat("ACR_RND",x2 * w);

    return fMean + (x1 * w * fStd);
}

float ACR_RandomLogNormal(float fMean, float fStd)
{
	return exp(fMean + fStd * ACR_RandomNormal());
}

float ACR_RandomFloat(float fMin = 0.0, float fMax = 1.0)
{
    return ((fMax - fMin) * (IntToFloat(Random(MAX_RND_INT)) / MAX_RND_FLOAT) + fMin);
}

int GetPiecewiseInteger(int nNum, int nStartBit, int nEndBit) {
    // Bit-shift the region of intrest leftward until it is adjacent to the end of the 32-bit value.
	//  Then set the top bit (left of the range of interest) to a "0" so make sure it stays positive
	int nShift = INT_SIZE - 2 - nEndBit;
	nNum = ((nNum << nShift) & ~BIT_31);
	// Finally, bit-shift the value rightward to the start of the integer range, padding with zeroes.
	return ( nNum >>> (nShift + nStartBit));
 
}

string GetObjectInfoAsString(object oObject) {
    return GetName(oObject) + " (tagged '" + GetTag(oObject) + "' of resref '" + GetResRef(oObject) + "')";
}

string GetObjectTypeName(int nObjectType) {
    switch(nObjectType) {
        case OBJECT_TYPE_ALL:
            return "all";
        case OBJECT_TYPE_AREA_OF_EFFECT:
            return "area of effect";
        case OBJECT_TYPE_CREATURE:
            return "creature";
        case OBJECT_TYPE_DOOR:
            return "door";
        case OBJECT_TYPE_ENCOUNTER:
            return "encounter";
        case OBJECT_TYPE_ITEM:
            return "item";
        case OBJECT_TYPE_PLACEABLE:
            return "placable";
        case OBJECT_TYPE_STORE:
            return "store";
        case OBJECT_TYPE_TRIGGER:
            return "trigger";
        case OBJECT_TYPE_WAYPOINT:
            return "waypoint";
    }
    return "invalid";
}

string GetBaseItemTypeName(object oItem) {
    if(!GetIsObjectValid(oItem) || GetObjectType(oItem) != OBJECT_TYPE_ITEM) {
        return "";
    }

    switch(GetBaseItemType(oItem)) {
        case BASE_ITEM_AMULET:
            return "amulet";
        case BASE_ITEM_ARMOR:
            return "armor";
        case BASE_ITEM_ARROW:
            return "arrow";
        case BASE_ITEM_BASTARDSWORD:
            return "bastard sword";
        case BASE_ITEM_BATTLEAXE:
            return "battle axe";
        case BASE_ITEM_BELT:
            return "belt";
        case BASE_ITEM_BLANK_POTION:
            return "blank potion";
        case BASE_ITEM_BLANK_SCROLL:
            return "blank scroll";
        case BASE_ITEM_BLANK_WAND:
            return "blank wand";
        case BASE_ITEM_BOLT:
            return "bolt";
        case BASE_ITEM_BOOK:
            return "book";
        case BASE_ITEM_BOOTS:
            return "boots";
        case BASE_ITEM_BRACER:
            return "bracer";
        case BASE_ITEM_BULLET:
            return "bullet";
        case BASE_ITEM_CBLUDGWEAPON:
            return "creature bludgeoning weapon";
        case BASE_ITEM_CLUB:
            return "club";
        case BASE_ITEM_CPIERCWEAPON:
            return "creature pierce weapon";
        case BASE_ITEM_CRAFTMATERIALMED:
            return "craft material medium";
        case BASE_ITEM_CRAFTMATERIALSML:
            return "craft material small";
        case BASE_ITEM_CREATUREITEM:
            return "creature hide";
        case BASE_ITEM_CSLASHWEAPON:
            return "creature slash weapon";
        case BASE_ITEM_CSLSHPRCWEAP:
            return "creature slashing and piercing weapon";
        case BASE_ITEM_DAGGER:
            return "dagger";
        case BASE_ITEM_DART:
            return "dart";
        case BASE_ITEM_DIREMACE:
            return "dire mace";
        case BASE_ITEM_DOUBLEAXE:
            return "double axe";
        case BASE_ITEM_DWARVENWARAXE:
            return "dwarven war axe";
        case BASE_ITEM_ENCHANTED_POTION:
            return "enchanted potion";
        case BASE_ITEM_ENCHANTED_SCROLL:
            return "enchanted scroll";
        case BASE_ITEM_ENCHANTED_WAND:
            return "enchanted wand";
        case BASE_ITEM_GEM:
            return "gem";
        case BASE_ITEM_GLOVES:
            return "gloves";
        case BASE_ITEM_GOLD:
            return "gold";
        case BASE_ITEM_GREATAXE:
            return "greataxe";
        case BASE_ITEM_GREATSWORD:
            return "greatsword";
        case BASE_ITEM_GRENADE:
            return "grenade";
        case BASE_ITEM_HALBERD:
            return "halberd";
        case BASE_ITEM_HANDAXE:
            return "handaxe";
        case BASE_ITEM_HEALERSKIT:
            return "healer's kit";
        case BASE_ITEM_HEAVYCROSSBOW:
            return "heavy crossbow";
        case BASE_ITEM_HEAVYFLAIL:
            return "heavy flail";
        case BASE_ITEM_HELMET:
            return "helmet";
        case BASE_ITEM_INVALID:
            return "invalid";
        case BASE_ITEM_KAMA:
            return "kama";
        case BASE_ITEM_KATANA:
            return "katana";
        case BASE_ITEM_KEY:
            return "key";
        case BASE_ITEM_KUKRI:
            return "kukri";
        case BASE_ITEM_LARGEBOX:
            return "large box";
        case BASE_ITEM_LARGESHIELD:
            return "large shield";
        case BASE_ITEM_LIGHTCROSSBOW:
            return "light crossbow";
        case BASE_ITEM_LIGHTFLAIL:
            return "light flail";
        case BASE_ITEM_LIGHTHAMMER:
            return "light hammer";
        case BASE_ITEM_LIGHTMACE:
            return "light mace";
        case BASE_ITEM_LONGBOW:
            return "longbow";
        case BASE_ITEM_LONGSWORD:
            return "longsword";
        case BASE_ITEM_MAGICROD:
            return "magic rod";
        case BASE_ITEM_MAGICSTAFF:
            return "magic staff";
        case BASE_ITEM_MAGICWAND:
            return "magic wand";
        case BASE_ITEM_MISCLARGE:
            return "miscellaneous large";
        case BASE_ITEM_MISCMEDIUM:
            return "miscellaneous medium";
        case BASE_ITEM_MISCSMALL:
            return "miscellaneous small";
        case BASE_ITEM_MISCTALL:
            return "miscellaneous tall";
        case BASE_ITEM_MISCTHIN:
            return "miscellaneous thin";
        case BASE_ITEM_MISCWIDE:
            return "miscellaneous wide";
        case BASE_ITEM_MORNINGSTAR:
            return "morningstar";
        case BASE_ITEM_POTIONS:
            return "potions";
        case BASE_ITEM_QUARTERSTAFF:
            return "quarterstaff";
        case BASE_ITEM_RAPIER:
            return "rapier";
        case BASE_ITEM_RING:
            return "ring";
        case BASE_ITEM_SCIMITAR:
            return "scimitar";
        case BASE_ITEM_SCROLL:
            return "scroll";
        case BASE_ITEM_SCYTHE:
            return "scythe";
        case BASE_ITEM_SHORTBOW:
            return "short bow";
        case BASE_ITEM_SHORTSPEAR:
            return "short spear";
        case BASE_ITEM_SHORTSWORD:
            return "short sword";
        case BASE_ITEM_SHURIKEN:
            return "shuriken";
        case BASE_ITEM_SICKLE:
            return "sickle";
        case BASE_ITEM_SLING:
            return "sling";
        case BASE_ITEM_SMALLSHIELD:
            return "small shield";
        case BASE_ITEM_SPELLSCROLL:
            return "spell scroll";
        case BASE_ITEM_THIEVESTOOLS:
            return "thieve's tools";
        case BASE_ITEM_THROWINGAXE:
            return "throwing axe";
        case BASE_ITEM_TORCH:
            return "torch";
        case BASE_ITEM_TOWERSHIELD:
            return "tower shield";
        case BASE_ITEM_TRAPKIT:
            return "trap kit";
        //case BASE_ITEM_TRIDENT:
            //return "trident";
        case BASE_ITEM_TWOBLADEDSWORD:
            return "two-bladed sword";
        case BASE_ITEM_WARHAMMER:
            return "warhammer";
		case BASE_ITEM_WARMACE:
			return "war mace";
        case BASE_ITEM_WHIP:
            return "whip";    }
    return "";
}

/*int GetBaseArmorClass(object oItem) {
    // FIX ME !!
    // This just doesn't work. Any way to get the AC of an item property?
    if(!GetIsObjectValid(oItem) || GetBaseItemType(oItem) != BASE_ITEM_ARMOR) {
        return -1;
    }
    //SendMessageToPC(GetFirstPC(), "Highest: " + IntToString(GetHighestItemPropertyParam1Value(oItem, ITEM_PROPERTY_AC_BONUS)));
    return GetAC(oItem) - GetHighestItemPropertyParam1Value(oItem, ITEM_PROPERTY_AC_BONUS);
}*/

int GetBaseSpellFailure(object oItem) {
    if(!GetIsObjectValid(oItem) || GetBaseItemType(oItem) != BASE_ITEM_ARMOR) {
        return 0;
    }
    return StringToInt(Get2DAString("armorrulestats", "ARCANEFAILURE%", GetArmorRulesType(oItem)));
}

int GetTotalSpellFailure(object oItem) {
	int nSpellFailure = GetBaseSpellFailure(oItem);
	if(!nSpellFailure) return 0;
	
	itemproperty ip = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(ip)) {
		if(GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE) {
			int nCostValue = GetItemPropertyCostTableValue(ip);
			nSpellFailure += (nCostValue <= 9) ? (nCostValue * 5 - 50) : (nCostValue * 5 - 45);
		}
		ip = GetNextItemProperty(oItem);
	}
	
	return nSpellFailure;
}

string GetArmorTypeName(object oArmor) {
    // FIX ME !!!
    // Come NWN2, all 3.5 armor types?
    return "";
}

int GetHighestItemPropertyParam1Value(object oItem, int nType) {
    itemproperty ip = GetFirstItemProperty(oItem);
    int nMax;
    int bInitialized = 0;
    while( GetIsItemPropertyValid(ip) ) {
        if(GetItemPropertyType(ip) == nType) {
            int nValue = GetItemPropertyParam1Value(ip);

            if(nValue > nMax || !bInitialized) {
                nMax = nValue;
                bInitialized = 1;
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return nMax;
}

int GetHighestItemPropertyParam1(object oItem, int nType) {
    itemproperty ip = GetFirstItemProperty(oItem);
    int nMax = 0;
    while( GetIsItemPropertyValid(ip) ) {
        if(GetItemPropertyType(ip) == nType) {
            int nValue = GetItemPropertyParam1(ip);
            if(nValue > nMax) {
                nMax = nValue;
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return nMax;
}

int GetKnowlegeSkillOfRace(int nRace) {
    switch(nRace) {
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_MAGICAL_BEAST:
            return SKILL_KNOWLEDGE_ARCANA;

        case RACIAL_TYPE_ABERRATION:
        case RACIAL_TYPE_OOZE:
            return SKILL_KNOWLEDGE_DUNGEONEERING;

        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_FEY:
        case RACIAL_TYPE_GIANT:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_SHAPECHANGER:
        case RACIAL_TYPE_PLANT:
        case RACIAL_TYPE_VERMIN:
            return SKILL_KNOWLEDGE_NATURE;

        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_INCORPOREAL:
            return SKILL_KNOWLEDGE_RELIGION;

        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_ELEMENTAL:
            return SKILL_KNOWLEDGE_THE_PLANES;

        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
	case RACIAL_TYPE_DWARF:
	case RACIAL_TYPE_ELF:
	case RACIAL_TYPE_GNOME:
	case RACIAL_TYPE_GRAYORC:
	case RACIAL_TYPE_HALFELF:
	case RACIAL_TYPE_HALFLING:
	case RACIAL_TYPE_HALFORC:
	case RACIAL_TYPE_HUMAN:
	case RACIAL_TYPE_YUANTI:
	    return SKILL_KNOWLEDGE_LOCAL;
    }
    return -1;
}

int GetArePCsInArea(object oArea) {
    object oPC = GetFirstPC();
    while(oPC != OBJECT_INVALID) {
        if(GetArea(oPC) == oArea) {
            return 1;
        }
        oPC = GetNextPC();
    }
    return 0;
}

object GetItemOfResRefPossessedBy(object oCreature, string sResRef) {
    object oItem = GetFirstItemInInventory(oCreature);

    while(oItem != OBJECT_INVALID) {
        if(GetResRef(oItem) == sResRef) {
            return oItem;
        }
        oItem = GetNextItemInInventory(oCreature);
    }
    return OBJECT_INVALID;
}

int GetIsIntegerInWindow(int nNum, int nStart, int nEnd) {
    // SendMessageToAllDMs("Checking "+IntToString(nNum)+" to see if it is between "+IntToString(nStart)+" and "+IntToString(nEnd));
	if (nStart <= nEnd) {  // Normal case, simple window.
	    return ( (nNum >= nStart) && (nNum <= nEnd));
	} else {   // circular window case
        return ( (nNum >= nStart ) || (nNum <= nEnd) );
    }
}

int GetSecondsUntil(int nYear, int nMonth, int nDay, int nHour, int nMinute, int nSecond) {
    int nTime = GetCalendarYear() - nYear;
    nTime = nTime * 12 + GetCalendarMonth() - nMonth;
    nTime = nTime * DAYS_PER_MONTH + GetCalendarDay() - nDay;
    nTime = nTime * 24 + GetTimeHour() - nHour;
    nTime = nTime * 60 + GetTimeMinute() - nMinute;
    return nTime * 60 + GetTimeSecond() - nSecond;
}

int CombineBooleanLocalInt(int nFlags, object oObject, string sVarName, int nBit) {
    if( GetLocalInt(oObject, sVarName) ) {
        nFlags = nFlags | nBit;
    }
    DeleteLocalInt(oObject, sVarName);
    return nFlags;
}

effect EffectAdjustedMovementSpeed(object oCreature, float fMovementChange) {
    if( GetHasFeat(FEAT_BARBARIAN_ENDURANCE, oCreature) ) {
        fMovementChange -= 0.1;
    }

    if( GetHasFeat(FEAT_MONK_ENDURANCE, oCreature) ) {
        // FIX ME !!!
        // GetArmorType doesn't work, because GetBaseArmorClass() doesn't work.
        // We'll assume the monk isn't wearing armor.
        //if( GetArmorType(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature)) != ARMOR_TYPE_CLOTHING ) {
            fMovementChange -= 0.1 * (GetLevelByClass(CLASS_TYPE_MONK, oCreature) / 3);
        //}
    }

    effect eMovement;
    if(fMovementChange > 1.0) {
        int nNum = FloatToInt((fMovementChange - 1.0) * 100);
        return EffectMovementSpeedIncrease( nNum );
    }
    int nNum = FloatToInt((1.0 - fMovementChange) * 100);
    return EffectMovementSpeedDecrease( nNum );
}

/*int GetArmorType(object oItem) {
    if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) {
        return ARMOR_TYPE_INVALID;
    }
    int nAC = GetBaseArmorClass(oItem);
    if(nAC < 1) {
        return ARMOR_TYPE_CLOTHING;
    } else if(nAC < 4) {
        return ARMOR_TYPE_LIGHT;
    } else if(nAC < 6) {
        return ARMOR_TYPE_MEDIUM;
    }
    return ARMOR_TYPE_HEAVY;
}*/

string GetTimeAsString() {
    return IntToString(GetTimeHour()) + ":" + IntToString(GetTimeMinute()) + ":" + FloatToString(GetTimeSecond() + GetTimeMillisecond() / 1000.0, 6, 3);
}

string GetDateAsString() {
    return IntToString(GetCalendarYear()) + "-" + IntToString(GetCalendarMonth()) + "-" + IntToString(GetCalendarDay());
}

int GenerateRandomSeed() {
    if(d2() == 1) {
        return Random(MAX_INT);
    }
    return -1 - Random(MAX_INT);
}

int GetIsItemShield(object oItem) {
    int nItemType = GetBaseItemType(oItem);
    if( nItemType == BASE_ITEM_LARGESHIELD ||
        nItemType == BASE_ITEM_SMALLSHIELD ||
        nItemType == BASE_ITEM_TOWERSHIELD )
        return 1;

    return 0;
}

int GetIsPlayer(object oCreature) {
    return GetIsPC(oCreature) && !GetIsDM(oCreature) && !GetIsDMPossessed(oCreature);
}


string ACR_CleanCreatureNameTextForPlayers(string sRawInput) {
	// used to manually filter out the OOC info for DMs in creature names, like {CR 0.5}
	string sFront = sRawInput;
	string sEnd = "";
	int nOOCstart = FindSubString(sRawInput, "{");
	if (nOOCstart != -1) {
		sFront = GetSubString(sRawInput, 0, nOOCstart);
		int nOOCend = GetStringLength(sRawInput) - FindSubString(sRawInput, "}");
		sEnd = GetStringRight(sRawInput, nOOCend-1);
	}
	return sFront+sEnd;
}

int DeleteAllLocalIntsWithString(object oObject, string sString) {
	string sName;
	int i, count;
	
	for(i=0; TRUE; i++) {
		sName = GetVariableName(oObject, i);
		if(sName == "") return count;
		if(FindSubString(sName, sString) != -1) {
			DeleteLocalInt(oObject, sName);
			count++;
			i--;
		}
	}
	return count;
}

string GetFeatSpellScript(int nFeat) {
	int nSpellId = StringToInt(Get2DAString("feat", "SPELLID", nFeat));
	if(!nSpellId) return "";
	string sScript = Get2DAString("spells", "ImpactScript", nSpellId);
	if(sScript == "****") return "";
	return sScript;
}


void BroadcastToDMs(string sText)
{
	object o,p;

	for (ObjectToInt(o = GetFirstPC()); GetIsObjectValid(o); ObjectToInt(o = GetNextPC())) {
		if (GetIsDM(o))
			SendMessageToPC(o, sText);

		if (GetIsDMPossessed(o)) {
			p = GetControlledCharacter(o);

			if (p != OBJECT_INVALID)
				SendMessageToPC(p, sText);
		}
	}
}

int IsVowel(string s)
{
	s = GetStringUpperCase(s);
	return ((s == "A") || (s == "E") ||
		(s == "I") || (s == "O") ||
		(s == "U"));
}

string GetArticle(string s)
{
	return ((IsVowel(GetStringLeft(s,1))) ? "an" : "a");
}

string Pluralize(string s)
{
	return s + ( GetStringRight(s,1) == "s" ? "es" : "s" );
}

string Colorize(string sText, string sColor)
{
	return "<color=#"+sColor+">"+sText+"</c>";
}

object ACR_GetNearestCreatureToLocation(object oPC, int nFirstCriteriaType, int nFirstCriteriaValue,  location lLocation, int nNth=1, int nSecondCriteriaType=-1, int nSecondCriteriaValue=-1, int nThirdCriteriaType=-1,  int nThirdCriteriaValue=-1) {

	if(GetAreaFromLocation(lLocation) == OBJECT_INVALID) return OBJECT_INVALID;

	AddScriptParameterInt(nFirstCriteriaType);
	AddScriptParameterInt(nFirstCriteriaValue);
	SetLocalLocation(oPC, "ACR_GETNEARESTHOSTILE_LOC", lLocation);
	AddScriptParameterInt(nNth);
	AddScriptParameterInt(nSecondCriteriaType);
	AddScriptParameterInt(nSecondCriteriaValue);
	AddScriptParameterInt(nThirdCriteriaType);
	AddScriptParameterInt(nThirdCriteriaValue);
	
	ExecuteScriptEnhanced("acr_getnearestcreaturetolocation", oPC, TRUE);
	object oNearest = GetLocalObject(oPC, "ACR_GETNEARESTHOSTILE_OBJ");
	DeleteLocalObject(oPC, "ACR_GETNEARESTHOSTILE_OBJ");
	return oNearest;
}


//! Converts datastring to int representation
int DataStringToInt(string sString)
{
	if(sString == "1")      return 1;
	else if(sString == "2") return 2; 
	else if(sString == "3") return 3;
	else if(sString == "4") return 4;
	else if(sString == "5") return 5;
	else if(sString == "6") return 6;
	else if(sString == "7") return 7;
	else if(sString == "8") return 8;
	else if(sString == "9") return 9;
	else if(sString == "A") return 10;
	else if(sString == "B") return 11;
	else if(sString == "C") return 12;
	else if(sString == "D") return 13;
	else if(sString == "E") return 14;
	else if(sString == "F") return 15;
	else if(sString == "G") return 16;
	else if(sString == "H") return 17;
	else if(sString == "I") return 18;
	else if(sString == "J") return 19;
	else if(sString == "K") return 20;
	else if(sString == "L") return 21;
	else if(sString == "M") return 22;
	else if(sString == "N") return 23;
	else if(sString == "O") return 24;
	else if(sString == "P") return 25;
	else if(sString == "Q") return 26;
	else if(sString == "R") return 27;
	else if(sString == "S") return 28;
	else if(sString == "T") return 29;
	else if(sString == "U") return 30;
	return 1;
}

//! Turns a hex string into a floating point
float HexStringToFloat(string sString)
{
	/*
	 * Scrap implementation to just use HexStringToInt()
	 * defined in ginc_math
	 *
	int nMultiplier = 1;
	while(sString != "")
	{
		string sDigit = GetStringRight(sString, 1);
		if(GetStringLength(sString) == 1)
			sString = "";
		else
			sString = GetStringLeft(sString, GetStringLength(sString) - 1);
		if(sDigit == "F")      nResult += nMultiplier * 15;
		else if(sDigit == "E") nResult += nMultiplier * 14;
		else if(sDigit == "D") nResult += nMultiplier * 13;
		else if(sDigit == "C") nResult += nMultiplier * 12;
		else if(sDigit == "B") nResult += nMultiplier * 11;
		else if(sDigit == "A") nResult += nMultiplier * 10;
		else                   nResult += nMultiplier * StringToInt(sDigit);
		nMultiplier = nMultiplier * 16;
	}
	*/
	return IntToFloat(HexStringToInt(sString));
}

int GetSubraceAppearance(int subrace)
{
	switch (subrace) {

		case RACIAL_SUBTYPE_SHIELD_DWARF:
			return APPEARANCE_TYPE_DWARF;
		case RACIAL_SUBTYPE_GOLD_DWARF: 
			return APPEARANCE_TYPE_DWARF_GOLD;
		case RACIAL_SUBTYPE_GRAY_DWARF:
			return APPEARANCE_TYPE_DWARF_GRAY;
		case RACIAL_SUBTYPE_MOON_ELF:
			return APPEARANCE_TYPE_ELF;
		case RACIAL_SUBTYPE_SUN_ELF: 
			return APPEARANCE_TYPE_ELF_SUN;
		case RACIAL_SUBTYPE_WOOD_ELF:
			return APPEARANCE_TYPE_ELF;
		case RACIAL_SUBTYPE_DROW: 
			return APPEARANCE_TYPE_ELF_DROW;
		case RACIAL_SUBTYPE_WILD_ELF:  
			return APPEARANCE_TYPE_ELF_WILD;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			return APPEARANCE_TYPE_GNOME;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			return APPEARANCE_TYPE_GNOME_DEEP;
		case RACIAL_SUBTYPE_HUMAN:
			return APPEARANCE_TYPE_HUMAN;
		case RACIAL_SUBTYPE_HALFELF:
			return APPEARANCE_TYPE_HALF_ELF;
		case RACIAL_SUBTYPE_HALFDROW:
			return APPEARANCE_TYPE_HALF_DROW;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
			return APPEARANCE_TYPE_HALFLING;
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			return APPEARANCE_TYPE_HALFLING_STRONG;
		case RACIAL_SUBTYPE_HALFORC:
			return APPEARANCE_TYPE_HALF_ORC;
		case RACIAL_SUBTYPE_GRAYORC:
			return APPEARANCE_TYPE_ORC_GRAY;
		case RACIAL_SUBTYPE_YUANTI:
			return APPEARANCE_TYPE_YUANTI;
		case RACIAL_SUBTYPE_WATER_GENASI:
			return APPEARANCE_TYPE_GENASI_WATER;
		case RACIAL_SUBTYPE_FIRE_GENASI:
			return APPEARANCE_TYPE_GENASI_FIRE;
		case RACIAL_SUBTYPE_EARTH_GENASI:
			return APPEARANCE_TYPE_GENASI_EARTH;
		case RACIAL_SUBTYPE_AIR_GENASI:
			return APPEARANCE_TYPE_GENASI_AIR;
		case RACIAL_SUBTYPE_TIEFLING:
			return APPEARANCE_TYPE_TIEFLING;
		case RACIAL_SUBTYPE_AASIMAR:
			return APPEARANCE_TYPE_AASIMAR;
	}

	return APPEARANCE_TYPE_INVALID;
}

//! Read in the form "[(i-j,|k,)+]"
object _ParseInterval(string s, int gtype)
{
	string c;
	int val, i, j, k, group=-1, range, rval, ret, in_group=0, ignore=0;

	// parse
	while ((c = GetSubString(s,i++,1)) != "") {
	
		if (ignore) {}
		else if (!in_group) {
			// start of new group
			if (c == "[") {
				group++;
				k = 0;
				val = 0;

				in_group = 1;

				// ignore this enclosure until we reach the next
				if (group != gtype)
					ignore = 1;
			}
			continue;
		}
		else if (c == "]" || c == ",") {
			if (!range)
				rval = val;
			
			// malformed, force exit
			if (rval > val)
				break;

			for (j=rval; j<=val; (++j) + (++k))
				SetLocalArrayInt(OBJECT_SELF,"int_"+IntToString(group),k,j);

			range = 0;
			val = 0;

	
			// end of group
			if (c == "]") {
				SetLocalArrayInt(OBJECT_SELF,"int_"+IntToString(group),-1,k);

				// found, let's exit
				if (group == gtype)
					break;
			}
		}
		else if (c == "-") {
			rval = val;
			range = 1;
			val = 0;
		}
		else if (TestStringAgainstPattern("*n", c)) 
			val = val*10 + StringToInt(c);

		if (c == "]") {
			ignore = 0;
			in_group = 0;
		}
	}

	return OBJECT_SELF;
}

// cleanup
void _CleanupInterval(int max)
{
	int i,k;

	k = GetLocalArrayInt(OBJECT_SELF, "int_"+IntToString(i), -1) + 1;
	DeleteLocalArrayInts(OBJECT_SELF, "int_"+IntToString(i), k, -1);
}

//! Read in the form "[(i-j,|k,)+]"
//! then spit out to a list "#([0-9]+#)*)"
string IntervalToList(string s,int gtype=0)
{
	int i,k;
	string ret = "#";

	_ParseInterval(s, gtype);

	// generate
	k = GetLocalArrayInt(OBJECT_SELF, "int_"+IntToString(gtype), -1);

	for (i=0; i<k; ++i)
		ret += IntToString(GetLocalArrayInt(OBJECT_SELF, "int_"+IntToString(gtype), i)) + "#";

	_CleanupInterval(gtype);

	return ret;
}

//! Read in the form "[(i-j,|k,)+]"
//! then choose a random int within that interval
int UniformRandomOverInterval(string s, int gtype=0)
{
	int i, k, ret;

	_ParseInterval(s, gtype);

	// generate
	k = Random(GetLocalArrayInt(OBJECT_SELF, "int_"+IntToString(gtype), -1));
	ret = GetLocalArrayInt(OBJECT_SELF, "int_"+IntToString(gtype), k);

	_CleanupInterval(gtype);

	// default to 1, not 0
	if (ret == 0)
		ret = 1;

	return ret;
}


location ACR_CalcSafeLocation(object oClicker, location lTarget)
{
	object t_area, o;
	location t_l, c_l;
	vector t_v, c_v, t_prime_v;
	float t_face, c_face, f_sqrt = sqrt(2.0f);
	int i,j;

	c_l = GetLocation(oClicker);
	t_area = GetAreaFromLocation(lTarget);

	if (t_area == OBJECT_INVALID)
		return LOCATION_INVALID;
		
	t_v = GetPositionFromLocation(lTarget);
	t_face = GetFacingFromLocation(lTarget);
	t_prime_v = AngleToVector(t_face);

	t_prime_v.z = 0.0f;
	c_v.z = 0.0f;

	o = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_BOTH, lTarget);

	for (i = 1; i <= 3; ++i) {
		
		for (j = 0; j < 8; ++j) {
			// rotate pi/4 about z:
			t_prime_v.x = (t_prime_v.x - t_prime_v.y)/f_sqrt;
			t_prime_v.y = (t_prime_v.x + t_prime_v.y)/f_sqrt;

			t_prime_v = VectorNormalize(t_prime_v);

			// multiply by increments of 1/2
			c_v.x = t_v.x + t_prime_v.x/2 * i;
			c_v.y = t_v.y + t_prime_v.y/2 * i;

			// orientation away from door
			c_face = VectorToAngle(t_prime_v);

			t_l = Location(t_area, c_v, c_face);

			// invalid, just re-search
			if (!GetIsLocationValid(t_l))
				continue;

			if (o != OBJECT_INVALID) {
				t_l = CalcSafeLocation(o, t_l, ACR_LOCATION_SEARCH_RADIUS, FALSE, FALSE);
			}

			c_v = GetPositionFromLocation(t_l);

			// reject anything that has a large zdiff
			// e.g. we are being ported down/up to a strange location
			if (fabs(c_v.z - t_v.z) > ACR_AREA_TRANSITION_ZDIFF_MAX)
				t_l = c_l;

			// this is ok
			if (t_l != c_l)
				return t_l;
		}
	}

	return LOCATION_INVALID;
}



/*****************************************************************************/
//LIST MANAGEMENT

int XPCraft_GetNextEntryInList(string sList, int iCurrentEntry)
{
	string sCurrentEntry = "#"+ IntToString(iCurrentEntry) + "#";
	int iCurrentOffset = FindSubString(sList,sCurrentEntry);
	
	if(iCurrentOffset==-1)
	{//Current entry doesn't exist in the list
		return iCurrentEntry;
	}
	iCurrentOffset += GetStringLength(sCurrentEntry);//position after the current entry

	//looking for the following sharp
	int iFollowingSharpOffset = FindSubString(GetStringRight(sList,GetStringLength(sList)-iCurrentOffset),"#");

	
	if(iFollowingSharpOffset==-1)
	{//no following sharp, current entry is the last one -> loop by returning the first entry in the list
		return XPCraft_GetFirstEntryInList(sList);
	}
	else
	{
		return StringToInt(GetSubString(sList,iCurrentOffset,iFollowingSharpOffset-iCurrentOffset));
	}
}


int XPCraft_GetPreviousEntryInList(string sList, int iCurrentEntry)
{
	string sCurrentEntry = "#"+ IntToString(iCurrentEntry) + "#";
	int iCurrentOffset = FindSubString(sList,sCurrentEntry);
	
	if(iCurrentOffset==-1)
	{//Current entry doesn't exist in the list
		return iCurrentEntry;
	}
	
	//looking for the previous sharp
	int iPreviousSharpOffset = iCurrentOffset;
	string sChar;
	do
	{
		iPreviousSharpOffset--;
		sChar = GetSubString(sList,	iPreviousSharpOffset,1);			
	
	}while((sChar!="")&& (sChar!="#"));
	
	if(sChar=="")
	{//no previous sharp, current entry is the first one -> loop by returning the last entry in the list
		return XPCraft_GetLastEntryInList(sList);		
	}
	
	iPreviousSharpOffset++;
	return StringToInt(GetSubString(sList,iPreviousSharpOffset,iCurrentOffset-iPreviousSharpOffset));
}


int XPCraft_GetFirstEntryInList(string sList)
{
	//looking for the second sharp
	int iFollowingSharpOffset = FindSubString(GetStringRight(sList,GetStringLength(sList)-1),"#");
	return StringToInt(GetSubString(sList,1,iFollowingSharpOffset));	
}


int XPCraft_GetLastEntryInList(string sList)
{
	//parsing backwards, looking for the second-last sharp 
	int iStringLength = GetStringLength(sList)-1;
	int iPreviousSharpOffset = iStringLength;
	string sChar;
	do
	{
		iPreviousSharpOffset--;
		sChar = GetSubString(sList,	iPreviousSharpOffset,1);			
	
	}while((sChar!="")&& (sChar!="#"));
	
	if(sChar=="")
	{//no sharp found (that case should never happend if lists have a correct pattern)	
		return 0;		
	}
	
	iPreviousSharpOffset++;
	return StringToInt(GetSubString(sList,iPreviousSharpOffset,iStringLength-iPreviousSharpOffset));	
}

int XPCraft_IsElementInList(string sList, int nElement)
{
	//
	// Examine the #-delimited list, searching for a particular element within
	// it (assumed to be a list of integers delimited by # characters).
	//

	if (FindSubString(sList, "#" + IntToString(nElement) + "#", 0) < 0)
		return FALSE;
	else
		return TRUE;
}


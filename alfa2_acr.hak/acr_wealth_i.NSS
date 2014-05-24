////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_wealth_i
//    $Revision:: 556        $ current version of the file
//        $Date:: 2009-12-25#$ date the file was created or modified
//       Author : Ronan & AcadiusLost
//
//   Var Prefix : ACR_WLT
//  Dependencies: ABR Item Blueprints
//
//  Description
//  These functions handle everything related to PC wealth, mob drop wealth,
//  item pricing, etc. This file represents the connection between ALFA's wealth
//  and pricing standards and the game itself. All functions regarding item
//  pricing and PC wealth should go here, and nowhere else.
//
//  Revision History
//  2006/04/17  Ronan  Inception
//  2007/08/17  AcadiusLost  Added spawn drop functions, gaussian generator,
//                      and #included acr_tools_i for the RandomFloat() function.
//  2007/08/25  AcadiusLost  Added swipe % constant ACR_WLT_SPAWNLOOT_PERCENT,
//                      increased the loot anchor to 20.0, and the stdev to 0.5
//  2008/04/04  Cipher  Added initial loot generation functions, removed extraneous code/functions
//  2008/05/08  Cipher  Added % chance of gold drop for humanoids, removed temp limiter
//  2008/05/25  AcadiusLost  Added GetDroppable() checks to items before deduction from loot value
//  2008/05/27  AcadiusLost  Fixed exceptions for beasts/animals, removed greatclub
//  2008/08/30  AcadiusLost  Changed over to ACR_RandomFloat()
//  2008/11/17  AcadiusLost  Added exceptions to allow plot items to drop regardless.
//  2009/12/25  Danielmn   Shifted repriced gems into correct categories
//  2011/10/04  AcadiusLost  Adjustment to 35% drop chance, 1.25x net value
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_WEALTH_I
#define ACR_WEALTH_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Anchor value to generate gp amount for spawn loot.
//   -> anchor pushed to 20 from 5, to match the 75% swipe
//   -> ancher adjusted to 17.86, to match the new 65% swipe
const float ACR_WLT_SPAWNLOOT_ANCHOR = 17.86;

const float ACR_WLT_SPAWNLOOT_MEAN = 1.0;
const float ACR_WLT_SPAWNLOOT_STDEV = 0.5;

const float ACR_WLT_SPAWNLOOT_MU = -0.11157177565710487788314754515491;
const float ACR_WLT_SPAWNLOOT_SIGMA = 0.47238072707743883543358270528734;

const int ACR_WLT_SPAWNLOOT_PERCENT = 35;
const int ACR_WLT_SPAWNGOLD_PERCENT = 25;

// Local integer names for spawn blueprints, to pass drop parameters.
const string _ACR_LOOT_DISABLE = "ACR_LOOT_DISABLE";
const string _ACR_LOOT_CR_MOD = "ACR_LOOT_CR_MOD";
const string _ACR_LOOT_MULTIPLIER = "ACR_LOOT_MULTIPLIER";

// command values for the CLRScripts of ACR wealth
const int WEALTH_COMMAND_CALCULATE_WEALTH = 0;
const int WEALTH_COMMAND_CALCULATE_APPROPRIATE_DROP = 1;
const int WEALTH_COMMAND_DROP_WEALTH = 2;
const int WEALTH_COMMAND_DROP_WEALTH_TO_LIMIT = 3;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// This structure contains wealth information for a PC
struct PCWealthStruct {

	
    int wealth;
    int averageLevel;
    int highLevel;
    int lowLevel;
    int limitLevel;
    int position;
    float percentXPToNextLevel;
    float percentToNextWealthLevel;
};
////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Handle module client enter.
//!  - oPC: the PC who logged on.
void ACR_WealthOnClientEnter(object oPC);

//! Returns a gp value for a spawned creature, based on its CR, loot value, and a normal distribution.
int ACR_GetRandomDropValue(object oMob);

//! This function determines how much loot to generate
void ACR_GenerateTreasure(object oCreature, int nLootValue);

//! Returns the loot multiplier factor for the passed creature, tries first to read it from a cached variable
//! otherwise assigns a default.
int _GetLootMultiplier(object oSpawn);

//! This function generates loot drops on a specific creature
void _generateTreasure(object oCreature, int nLootValue, int nItems=0);

//! This function does a wealth report on login.
//!  - oPC: the PC to log the report for.
void ACR_WealthReportLog(object oPC);

//! This function determines what multiplier should be
//! used to modify the loot provided to oPC, based on
//! their wealth and recent interactions.
//!  - oPC: the PC whose multiplier is to be calculated
float ACR_CalculateMultiplier(object oPC);

//! This function determines how much gold value of
//! items to drop for PC's party, assuming that the
//! most-valuable items possible should be dropped
//! for the party.
//!  - oPC: the PC whose drop is to be calculated
int ACR_CalculateAppropriateDrop(object oPC);

//! This function fills a container with valuables
//! for a PC's party, assuming htat the most-valuable
//! items possible should be dropped.
//! - oPC: the PC whose party is to get the loot
//! - oContainer: the object which is to acquire the loot
void ACR_DropWealthInContainer(object oPC, object oContainer);

//! This function fills a container with valuables
//! for a PC's party, assuming that no PC in the party
//! should be given more than a specific amount of 
//! net value from the container.
//!  - oPC: the PC whose party is to get the loot
//!  - oContainer: the object which is to acquire the loot
//!  - nMaxValue: the most that any given PC should get,
//!         assuming an even split.
void ACR_DropUpToWealthInContainer(object oPC, object oContainer, int nMaxValue);

//! The NWScript wrapper for CLRScript ACR_Wealth
int _CallWealthCLRScript(int Param1, int Param2, object Param3, object Param4)

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_items_i"
#include "acr_tools_i"
#include "acr_report_i"
#include "acr_db_persist_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_WealthOnClientEnter(object oPC)
{
	AssignCommand(GetModule(), ACR_WealthReportLog(oPC));
}

int ACR_GetRandomDropValue(object oMob)
{
    int nType = GetRacialType(oMob), nCalc;
    float fRand, fCR, fCreatMulti, fBaseDrop, fMu, fSigma;

    // skip the creatures that drop and carry nothing
    if (nType == RACIAL_TYPE_ANIMAL ||
	    nType == RACIAL_TYPE_BEAST ||
        nType == RACIAL_TYPE_CONSTRUCT ||
        nType == RACIAL_TYPE_ELEMENTAL ||
        nType == RACIAL_TYPE_OOZE ||
        nType == RACIAL_TYPE_VERMIN) { return 0; }

    // Roll to see if the mob should drop loot at all, as set by ACR_WLT_SPAWNLOOT_PERCENT
    // default is 25, so 75% of the time the random loot function will skip the mob.
    if (Random(100) > ACR_WLT_SPAWNLOOT_PERCENT) { return 0; }

    fCR = GetChallengeRating(oMob);
    fCreatMulti = IntToFloat(_GetLootMultiplier(oMob));

    // if the multiplier is set at or determined to be 0, don't waste time with the math.
    if (fabs(fCreatMulti) < EPSILON) { return 0; }

    fBaseDrop = ACR_WLT_SPAWNLOOT_ANCHOR * (fCR + GetLocalFloat(oMob, _ACR_LOOT_CR_MOD));

    // to fit distribution w/ requirements, we find mu/sigma:
    // stdev = 0.5
    // mean = 1
    //
    // mu = log(mean^2/sqrt(stdev^2 + mean^2))
    // mu = -0.11157177565710487788314754515491
    //
    // sigma = sqrt(log(stdev^2/mean^2 + 1.0))
    // sigma = 0.47238072707743883543358270528734

    fRand = ACR_RandomLogNormal(ACR_WLT_SPAWNLOOT_MU, ACR_WLT_SPAWNLOOT_SIGMA);

    // record 1% and 99%
    //
    // cdf: 0.5 * (1-erf((mu-log(x0))/(sqrt(2) * sigma)))
    
    nCalc = FloatToInt(fCreatMulti * fBaseDrop * fRand);
    

    if (fRand > 2.68411)
	    WriteTimestampedLogEntry(GetName(oMob) + " ["+GetTag(oMob)+"] killed by "+GetName(GetLastKiller())+" in "+GetName(GetArea(oMob))+" ["+GetTag(GetArea(oMob))+"] dropped 1% top loot ("+IntToString(nCalc)+")");
    else if (fRand < 0.29805)
	    WriteTimestampedLogEntry(GetName(oMob) + " ["+GetTag(oMob)+"] killed by "+GetName(GetLastKiller())+" in "+GetName(GetArea(oMob))+" ["+GetTag(GetArea(oMob))+"] dropped 1% bottom loot ("+IntToString(nCalc)+")");
    

    // should subtract droppable gear from this for the final version, though perhaps better done after the
    // randomization and multiplier.  

    return nCalc;
}

void ACR_GenerateTreasure(object oCreature, int nLootValue)
{
    // G = total gear carried by creature (not armour)
    // g = individual items of gear carried by creature (not armour)
    // V = calculated value of loot drop
    // L = randomly generated loot
    // D = actual dropped loot D must never exceed V
    // Where G = V, L = 0.
    // Where G is less than V, L = V - G.
    // Where G is greater than V and g is less than V, L = V - g.
    // Where G is greater than V and g is greater than V, V = L = D. 

    // remove armor - it never drops
    SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature), FALSE);

    // remove gold - it should only drop from this script
    TakeGoldFromCreature(GetGold(oCreature), oCreature, TRUE, FALSE);

    int i, nGold, nGearValue = 0, nItemVal;
    int nRacialType = GetRacialType(oCreature);
    object oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature);

    // evaluate all other equipped gear and remove anything that exceeds nLootValue
    for (i=2; i <= 14; i++)
    {
        // ignore invalid objects
        if (GetIsObjectValid(oItem) && GetDroppableFlag(oItem))
        {
	    nItemVal = abs(GetGoldPieceValue(oItem));
			// let plot type items drop
			if (GetPlotFlag(oItem)) {
			    // no action needed, leave it there, let it drop
			}
            // destroy object if loot value has been exceeded
            else if ((nGearValue + nItemVal) >= nLootValue)
            {
                SetDroppableFlag(oItem, FALSE);
            }
            // otherwise, tally the GP total for non weapon items
            else
            {
                nGearValue += nItemVal;
            }
        }

        // retrieve the next item
        oItem = GetItemInSlot(i, oCreature);
    }
        
    oItem = GetFirstItemInInventory(oCreature);

    // evaluate inventoried gear and remove anything that exceeds nLootValue
    while(oItem != OBJECT_INVALID)
    {
	nItemVal = abs(GetGoldPieceValue(oItem));
		// If this is a plot item, let it drop/leave it along
		if (GetPlotFlag(oItem)) {
			// no action required
		}
        // destroy object if loot value has been exceeded
        else if ((nGearValue + nItemVal) >= nLootValue)
        {
            SetDroppableFlag(oItem, FALSE);
        }
        // tally the GP total for non weapon items
        else if (GetDroppableFlag(oItem))
        {
            nGearValue += nItemVal;
        }

        // retrieve the next item
        oItem = GetNextItemInInventory(oCreature);
    }

    // if the total gear value is less than the loot drop value
    // generate the highest value item possible and give the remaining difference in gold
	// drop junk 10% of the time when Loot Value is 0? !(nLootValue || Random(100) TBD
	//SendMessageToAllDMs("Creature: "+GetName(oCreature)+" has GearValue="+IntToString(nGearValue)+", lootValue="+IntToString(nLootValue));
    if (nGearValue < nLootValue)
    {
        int nDropValue = nLootValue - nGearValue;
		
        // humanoids have a percentage chance of dropping gold
        if (nRacialType == RACIAL_TYPE_HUMAN ||
            nRacialType == RACIAL_TYPE_DWARF ||
            nRacialType == RACIAL_TYPE_ELF ||
            nRacialType == RACIAL_TYPE_GNOME ||
            nRacialType == RACIAL_TYPE_GIANT ||
            nRacialType == RACIAL_TYPE_HALFELF ||
            nRacialType == RACIAL_TYPE_HALFORC ||
            nRacialType == RACIAL_TYPE_HALFLING ||
            nRacialType == RACIAL_TYPE_HUMANOID_GOBLINOID ||
            nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS ||
            nRacialType == RACIAL_TYPE_HUMANOID_ORC ||
            nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN)
        {
            // 25% chance of dropping gold up to 25% of loot value
            if ((Random(100) < ACR_WLT_SPAWNGOLD_PERCENT) && ((nGold = (Random(26) * nDropValue)/100) > 0))
            {
                GiveGoldToCreature(oCreature, nGold, FALSE);
                nDropValue -= nGold;
            }  
        }
        _generateTreasure(oCreature, nDropValue);
    }
}

int _GetLootMultiplier(object oSpawn) {
    // First, if the builder has disabled ACR loot for this creature, use 0 as the multiplier, cancelling loot.
    if (GetLocalInt(oSpawn, _ACR_LOOT_DISABLE)) { return 0; }

    int nMulti = GetLocalInt(oSpawn, _ACR_LOOT_MULTIPLIER);

    // If the builder has set a multiplier on the blueprint, use that.
    if (nMulti != 0) { return nMulti; }

    // If no multiplier is set, and it seems like a lootless-type creature, return 0. Otherwise, use 1 as the default.
    return ((GetRacialType(oSpawn) == RACIAL_TYPE_ANIMAL) ||
            (GetSubRace(oSpawn) == RACIAL_SUBTYPE_BEAST) ||
            (GetRacialType(oSpawn) == RACIAL_TYPE_VERMIN) ||
            (GetRacialType(oSpawn) == RACIAL_TYPE_INCORPOREAL)) ? 0 : 1;
}

void _generateTreasure(object oCreature, int nLootValue, int nItems=0)
{
	ACR_GenerateLoot( oCreature, nLootValue, nLootValue );
}

void ACR_WealthReportLog(object oPC)
{
	if (GetIsDM(oPC))
		return;

	int WealthLevel = GetWealthLevel(oPC);

	if (WealthLevel <= WEALTH_LEVEL_LOW)
		ACR_IncrementStatistic("PLAYER_LOW_WEALTH_LOGINS");
	else if (WealthLevel == WEALTH_LEVEL_TARGET)
		ACR_IncrementStatistic("PLAYER_NORMAL_WEALTH_LOGINS");
	else if (WealthLevel >= WEALTH_LEVEL_HIGH)
		ACR_IncrementStatistic("PLAYER_HIGH_WEALTH_LOGINS");
}

float ACR_CalculateMultiplier(object oPC)
{
  return IntToFloat(_CallWealthCLRScript(WEALTH_COMMAND_CALCULATE_WEALTH, -1, oPC, OBJECT_INVALID))/10;
}

int ACR_CalculateAppropriateDrop(object oPC)
{
  return _CallWealthCLRScript(WEALTH_COMMAND_CALCULATE_APPROPRIATE_DROP, -1, oPC, OBJECT_INVALID);
}

void ACR_DropWealthInContainer(object oPC, object oContainer)
{
  _CallWealthCLRScript(WEALTH_COMMAND_DROP_WEALTH, -1, oPC, OBJECT_INVALID);
}

void ACR_DropUpToWealthInContainer(object oPC, object oContainer, int nMaxValue)
{
  _CallWealthCLRScript(WEALTH_COMMAND_DROP_WEALTH_TO_LIMIT, nMaxValue, oPC, OBJECT_INVALID);
}

int _CallWealthCLRScript(int Param1, int Param2, object Param3, object Param4)
{
  ClearScriptParams();
  AddScriptParameterInt(Param1);
  AddScriptParameterInt(Param2);
  AddScriptParameterObject(Param3);
  AddScriptParameterObject(Param4);
  ExecuteScriptEnhanced("ACR_Wealth", OBJECT_SELF, TRUE);
}
#endif
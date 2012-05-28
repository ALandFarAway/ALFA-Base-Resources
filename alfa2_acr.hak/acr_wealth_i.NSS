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

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_tools_i"
#include "acr_report_i"
#include "acr_db_persist_i"

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
    string sResRef;

    // skip undead - they drop no loot
    if (GetRacialType(oCreature) == RACIAL_TYPE_UNDEAD) { return; }

    // try to generate highest value items first
    if (nLootValue >= 5000)
    {
        // 5000gp items
        switch (Random(4))
        {
            case 0:
                sResRef = "abr_it_gem_045";
                break;
            case 1:
                sResRef = "abr_it_gem_086";
                break;
            case 2:
                sResRef = "abr_it_gem_042";
                break;
            case 3:
                sResRef = "abr_it_gem_053";
                break;
		}

    }
    else if (nLootValue >= 1000)
    {
        // 1000gp items
        switch (Random(12))
        {
            case 0:
                sResRef = "abr_it_gem_046";
                break;
            case 1:
                sResRef = "abr_it_gem_035";
                break;
            case 2:
                sResRef = "abr_it_gem_010";
                break;
            case 3:
                sResRef = "abr_it_gem_025";
                break;
            case 4:
                sResRef = "abr_it_gem_058";
                break;
            case 5:
                sResRef = "abr_it_gem_044";
                break;
            case 6:
                sResRef = "abr_it_gem_036";
                break;
            case 7:
                sResRef = "abr_it_gem_027";
                break;
            case 8:
                sResRef = "abr_it_gem_039";
                break;
            case 9:
                sResRef = "abr_it_gem_023";
                break;
            case 10:
                sResRef = "abr_it_gem_009";
                break;
            case 11:
                sResRef = "abr_it_gem_054";
                break;
        }
    }
    else if (nLootValue >= 375)
    {
        // 375gp items
        switch (Random(4))
        {
            case 0:
                sResRef = "abr_it_wpn_longbow_mw_1";
                break;
			case 1:
                sResRef = "abr_it_gem_022";
                break;		
			case 2:
                sResRef = "abr_it_gem_055";
                break;	
			case 3:
                sResRef = "abr_it_gem_079";
                break;			
        }
    }
    else if (nLootValue >= 350)
    {
        // 350gp items
        switch (Random(3))
        {
            case 0:
                sResRef = "abr_it_wpn_greatsword_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_heavyxbow_mw_1";
                break;
			case 2:
                sResRef = "abr_it_gem_016";
                break;	
        }
    }
    else if (nLootValue >= 340)
    {
        // 340gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_wpn_katana_mw_1";
                break;
        }
    }
    else if (nLootValue >= 335)
    {
        // 335gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_wpn_bastardsword_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_lightxbow_mw_1";
                break;
        }
    }
    else if (nLootValue >= 330)
    {
        // 330gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_wpn_waraxe_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_shortbow_mw_1";
                break;
        } 
    }
    else if (nLootValue >= 320)
    {
        // 320gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_wpn_greataxe_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_rapier_mw_1";
                break;
        }
    }
    else if (nLootValue >= 318)
    {
        // 318gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_wpn_scythe_mw_1";
                break;
        } 
    }
    else if (nLootValue >= 315)
    {
        // 315gp items
        switch (Random(3))
        {
            case 0:
                sResRef = "abr_it_wpn_longsword_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_scimitar_mw_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_heavyflail_mw_1";
                break;
        }
    }
    else if (nLootValue >= 312)
    {
        // 312gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_wpn_warhammer_mw_1";
                break;
        } 
    }
    else if (nLootValue >= 310)
    {
        // 310gp items
        switch (Random(4))
        {
            case 0:
                sResRef = "abr_it_wpn_battleaxe_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_shortsword_mw_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_halberd_mw_1";
                break;
            case 3:
                sResRef = "abr_it_wpn_spear_mw_1";
                break;
        }
    }
    else if (nLootValue >= 308)
    { 
        // 308gp items
        switch (Random(3))
        {
            case 0:
                sResRef = "abr_it_wpn_kukri_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_flail_mw_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_morningstar_mw_1";
                break;
        }
    }
    else if (nLootValue >= 306)
    {
        // 306gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_wpn_handaxe_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_sickle_mw_1";
                break;
        }
    }
    else if (nLootValue >= 305)
    {
        // 305gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_wpn_lightmace_mw_1";
                break;
        }
    }
    else if (nLootValue >= 302)
    {
        // 302gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_wpn_dagger_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_kama_mw_1";
                break;
        }    
    }
    else if (nLootValue >= 301)
    {
        // 301gp items
        switch (Random(10))
        {
            case 0:
                sResRef = "abr_it_wpn_arrow_mw_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_bolt_mw_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_bullet_mw_1";
                break;
            case 3:
                sResRef = "abr_it_wpn_club_mw_1";
                break;
            case 4:
                sResRef = "abr_it_wpn_lighthammer_mw_1";
                break;
            case 5:
                sResRef = "abr_it_wpn_sling_mw_1";
                break;
            case 6:
                sResRef = "abr_it_wpn_quarterstaff_1";
                break;
            case 7:
                sResRef = "abr_it_wpn_dart_mw_1";
                break;
            case 8:
                sResRef = "abr_it_wpn_shuriken_mw_1";
                break;
            case 9:
                sResRef = "abr_it_wpn_throwingaxe_mw_1";
                break;
        }    
    }
    else if (nLootValue >= 250)
    {
        // 250gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_lt_bullseyelantern";
                break;
        } 
    }
    else if (nLootValue >= 100)
    {
        // 100gp items
        switch (Random(9))
        {
            case 0:
                sResRef = "abr_it_gem_001";
                break;
            case 1:
                sResRef = "abr_it_gem_034";
                break;
            case 2:
                sResRef = "abr_it_gem_076";
                break;
            case 3:
                sResRef = "abr_it_gem_077";
                break;
            case 4:
                sResRef = "abr_it_gem_015";
                break;
            case 5:
                sResRef = "abr_it_gem_013";
                break;
            case 6:
                sResRef = "abr_it_gem_038";
                break;
            case 7:
                sResRef = "abr_it_gem_078";
                break;
            case 8:
                sResRef = "abr_it_arm_shield4_hide_1 - 5";
                break;
        }    
    }
    else if (nLootValue >= 80)
    {
        // 80gp items
        switch (Random(1))
        {
            case 0:
                sResRef = "abr_it_gr_lock_03";
                break;
        }
    }
    else if (nLootValue >= 75)
    {
        // 75gp items
        switch (Random(2))
        {
            case 0:
                sResRef = "abr_it_arm_shield3_poor_1-3";
                break;
            case 1:
                sResRef = "abr_it_wpn_longbow_1";
                break;
        }
    }
    else if (nLootValue >= 50)
    {
        // 50gp items
        switch (Random(7))
        {
            case 0:
                sResRef = "abr_it_arm_shield2_hide_1 - 7";
                break;
            case 1:
                sResRef = "abr_it_wpn_greatsword_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_heavyxbow_1";
                break;
            case 3:
                sResRef = "abr_it_gem_003";
                break;
            case 4:
                sResRef = "abr_it_gem_050";
                break;
            case 5:
                sResRef = "abr_it_gem_011";
                break;
            case 6:
                sResRef = "abr_it_gem_072";
                break;
        }
    }
    else if (nLootValue >= 40)
    {
        // 40gp items
        switch (Random(3))
        {
            case 0:
                sResRef = "abr_it_lt_candle";
                break;
            case 1:
                sResRef = "abr_it_gr_lock_02";
                break;
            case 2:
                sResRef = "abr_it_wpn_katana_1";
                break;
        }
    }
    else if (nLootValue >= 30)
    {
        switch (Random(7))
        {
            // 37gp items
            case 0:
                sResRef = "abr_it_wpn_longbow_poor_1";
                break;
            case 1:
                sResRef = "abr_it_wpn_longbow_poor_1";
                break;
    
            // 30gp items
            case 2:
                sResRef = "abr_it_gr_chain";
                break;
            case 3:
                sResRef = "abr_it_wpn_waraxe_1";
                break;
            case 4:
                sResRef = "abr_it_wpn_shortbow_1";
                break;
    
            // 35gp items
            case 5:
                sResRef = "abr_it_wpn_bastardsword_1";
                break;
            case 6:
                sResRef = "abr_it_wpn_lightxbow_1";
                break;
        } 
    }
    else if (nLootValue >= 25)
    {
        // 25gp items
        switch (Random(4))
        {
            case 0:
                sResRef = "abr_it_arm_shield1_poor_2";
                break;
            case 1:
                sResRef = "abr_it_wpn_greatsword_poor_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_heavyxbow_poor_1";
                break;
            case 3:
                sResRef = "abr_it_gem_012";
                break;
        }
    }
    else if (nLootValue >= 15)
    {
        switch (Random(13))
        {
            // 15gp items
            case 0:
                sResRef = "abr_it_gr_manacles";
                break;
            case 1:
                sResRef = "abr_it_wpn_longsword_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_scimitar_1";
                break;
            case 3:
                sResRef = "abr_it_wpn_heavyflail_1";
                break;
            case 4:
                sResRef = "abr_it_wpn_shortbow_poor_1";
                break;
    
            // 17gp items
            case 5:
                sResRef = "abr_it_wpn_bastardsword_poor_1";
                break;
            case 6:
                sResRef = "abr_it_wpn_lightxbow_poor_1";
                break;
    
            // 18gp items
            case 7:
                sResRef = "abr_it_wpn_scythe_01";
                break;
            case 8:
                sResRef = "abr_it_wpn_scythe_1";
                break;
    
            // 20gp items
            case 9:
                sResRef = "abr_it_gr_lock_01";
                break;
            case 10:
                sResRef = "abr_it_wpn_greataxe_1";
                break;
            case 11:
                sResRef = "abr_it_wpn_rapier_1";
                break;
            case 12:
                sResRef = "abr_it_wpn_katana_poor_1";
                break;
        }
    }
    else if (nLootValue >= 10)
    {
        switch (Random(36))
        {
            // 10gp items
            case 0:
                sResRef = "abr_it_gr_mirror_01";
                break;
            case 1:
                sResRef = "abr_it_gr_ram";
                break;
            case 2:
                sResRef = "abr_it_gr_rope_02";
                break;
            case 3:
                sResRef = "abr_it_gr_tent_01";
                break;
            case 4:
                sResRef = "abr_it_wpn_battleaxe_1";
                break;
            case 5:
                sResRef = "abr_it_wpn_rapier_poor_1";
                break;
            case 6:
                sResRef = "abr_it_wpn_shortsword_1";
                break;
            case 7:
                sResRef = "abr_it_wpn_halberd_01";
                break;
            case 8:
                sResRef = "abr_it_wpn_halberd_02";
                break;
            case 9:
                sResRef = "abr_it_wpn_halberd_03";
                break;
            case 10:
                sResRef = "abr_it_wpn_halberd_1";
                break;
            case 11:
                sResRef = "abr_it_gem_084";
                break;
            case 12:
                sResRef = "abr_it_gem_075";
                break;
            case 13:
                sResRef = "abr_it_gem_085";
                break;
            case 14:
                sResRef = "abr_it_gem_062";
                break;
            case 15:
                sResRef = "abr_it_gem_005";
                break;
            case 16:
                sResRef = "abr_it_gem_007";
                break;
            case 17:
                sResRef = "abr_it_gem_083";
                break;

            case 19:
                sResRef = "abr_it_gem_074";
                break;
            case 20:
                sResRef = "abr_it_gem_063";
                break;
            case 21:
                sResRef = "abr_it_gem_049";
                break;
            case 22:
                sResRef = "abr_it_gem_014";
                break;
            case 23:
                sResRef = "abr_it_gem_047";
                break;
            case 24:
                sResRef = "abr_it_gem_041";
                break;
            case 25:
                sResRef = "abr_it_gem_017";
                break;
            case 26:
                sResRef = "abr_it_gem_018";
                break;
            case 27:
                sResRef = "abr_it_gem_020";
                break;
            case 28:
                sResRef = "abr_it_gem_064";
                break;
            case 29:
                sResRef = "abr_it_gem_021";
                break;
            case 30:
                sResRef = "abr_it_gem_065";
                break;
            case 31:
                sResRef = "abr_it_gem_026";
                break;
            case 32:
                sResRef = "abr_it_gem_028";
                break;
            case 33:
                sResRef = "abr_it_gem_031";
                break;
            case 34:
                sResRef = "abr_it_gem_037";
                break;
    
            // 12gp items
            case 35:
                sResRef = "abr_it_wpn_warhammer_1";
                break;
        }
    }
    else if (nLootValue >= 5)
    {
        // 5gp items
        switch (Random(22))
        {
            case 0:
                sResRef = "abr_it_gr_block&tackle";
                break;
            case 1:
                sResRef = "abr_it_wpn_falchion_poor_1";
                break;
            case 2:
                sResRef = "abr_it_wpn_shortsword_poor_1";
                break;
            case 3:
                sResRef = "abr_it_wpn_halberd_poor_1";
                break;
            case 4:
                sResRef = "abr_it_wpn_spear_poor_1";
                break;
            case 5:
                sResRef = "abr_it_wpn_spear_poor_1";
                break;
            case 6:
                sResRef = "abr_it_wpn_lighthammer_poor_1";
                break;
            case 7:
                sResRef = "abr_it_wpn_lightmace_1";
                break;
            case 8:
                sResRef = "abr_it_wpn_battleaxe_poor_2";
                break;
            case 9:
                sResRef = "abr_it_wpn_battleaxe_poor_1";
                break;
    
            // 6gp items
            case 10:
                sResRef = "abr_it_wpn_handaxe_1";
                break;
            case 11:
                sResRef = "abr_it_wpn_sickle_1";
                break;
    
            // 7gp items
            case 12:
                sResRef = "abr_it_lt_hoodedlantern";
                break;
            case 13:
                sResRef = "abr_it_wpn_longsword_poor_2";
                break;
            case 14:
                sResRef = "abr_it_wpn_broadsword_poor_1";
                break;
            case 15:
                sResRef = "abr_it_wpn_scimitar_poor_1";
                break;
    
            // 8gp items
            case 16:
                sResRef = "abr_it_gr_ink";
                break;
            case 17:
                sResRef = "abr_it_wpn_kukri_1";
                break;
            case 18:
                sResRef = "abr_it_wpn_flail_1";
                break;
            case 19:
                sResRef = "abr_it_wpn_morningstar_1";
                break;
    
            // 9gp items
            case 20:
                sResRef = "abr_it_arm_shield1_hide_1 - 4";
                break;
            case 21:
                sResRef = "abr_it_wpn_scythe_poor_1";
                break;
        }    
    }
    else if (nLootValue >= 1)
    {
        // 1gp items
        switch (Random(34))
        {
            case 0:
                sResRef = "abr_it_gr_backpack";
                break;
            case 1:
                sResRef = "abr_it_gr_bell";
                break;
            case 2:
                sResRef = "abr_it_gr_scrollcase";
                break;
            case 3:
                sResRef = "abr_it_gr_flint&steel";
                break;
            case 4:
                sResRef = "abr_it_gr_grapplinghook";
                break;
            case 5:
                sResRef = "abr_it_gr_rope_01";
                break;
            case 6:
                sResRef = "abr_it_gr_wax";
                break;
            case 7:
                sResRef = "abr_it_lt_torch";
                break;
            case 8:
                sResRef = "abr_it_wpn_arrow_1";
                break;
            case 9:
                sResRef = "abr_it_wpn_bolt_1";
                break;
            case 10:
                sResRef = "abr_it_wpn_bullet_1";
                break;
            case 11:
                sResRef = "abr_it_wpn_dagger_poor_2";
                break;
            case 12:
                sResRef = "abr_it_wpn_dagger_poor_1";
                break;
            case 13:
                sResRef = "abr_it_wpn_kama_poor_1";
                break;
            case 14:
                sResRef = "abr_it_wpn_club_1";
                break;
            case 15:
                sResRef = "abr_it_wpn_lighthammer_1";
                break;
            case 16:
                sResRef = "abr_it_wpn_staff_poor_1";
                break;
            case 17:
                sResRef = "abr_it_wpn_sling_1";
                break;
            case 18:
                sResRef = "abr_it_wpn_quarterstaff_1";
                break;
            case 19:
                sResRef = "abr_it_wpn_dart_1";
                break;
            case 20:
                sResRef = "abr_it_wpn_shuriken_1";
                break;
            case 21:
                sResRef = "abr_it_wpn_throwingaxe_1";
                break;
    
            // 2gp items
            case 22:
                sResRef = "abr_it_gr_chest_01";
                break;
            case 23:
                sResRef = "abr_it_gr_crowbar";
                break;
            case 24:
                sResRef = "abr_it_gr_shovel";
                break;
            case 25:
                sResRef = "abr_it_wpn_dagger_1";
                break;
            case 26:
                sResRef = "abr_it_wpn_kama_1";
                break;
            case 27:
                sResRef = "abr_it_wpn_mace_poor_1";
                break;
    
            // 3gp items
            case 28:
                sResRef = "abr_it_wpn_sickle_poor_1";
                break;
            case 29:
                sResRef = "abr_it_wpn_handaxe_poor_1";
                break;
    
            // 4gp items
            case 30:
                sResRef = "abr_it_gr_fishingnet";
                break;
            case 31:
                sResRef = "abr_it_wpn_kukri_poor_1";
                break;
            case 32:
                sResRef = "abr_it_wpn_flail_poor_1";
                break;
            case 33:
                sResRef = "abr_it_wpn_morningstar_poor_1";
                break;
        }
    }
    else
    {
        // 0gp items
        switch (Random(25))
        {
            case 0:
                sResRef = "abr_it_arm_shield0_poor_1-3";
                break;
            case 1:
                sResRef = "abr_it_gr_bedroll";
                break;
            case 2:
                sResRef = "abr_it_gr_winterblanket";
                break;
            case 3:
                sResRef = "abr_it_gr_canvas";
                break;
            case 4:
                sResRef = "abr_it_gr_chalk";
                break;
            case 5:
                sResRef = "abr_it_gr_firewood";
                break;
            case 6:
                sResRef = "abr_it_gr_fishhook";
                break;
            case 7:
                sResRef = "abr_it_gr_flask";
                break;
            case 8:
                sResRef = "abr_it_gr_hammer";
                break;
            case 9:
                sResRef = "abr_it_gr_inkpen";
                break;
            case 10:
                sResRef = "abr_it_gr_clayjug";
                break;
            case 11:
                sResRef = "abr_it_gr_oil";
                break;
            case 12:
                sResRef = "abr_it_gr_paper";
                break;
            case 13:
                sResRef = "abr_it_gr_parchment";
                break;
            case 14:
                sResRef = "abr_it_gr_piton";
                break;
            case 15:
                sResRef = "abr_it_gr_ironpot";
                break;
            case 16:
                sResRef = "abr_it_gr_beltpouch";
                break;
            case 17:
                sResRef = "abr_it_gr_rations_01";
                break;
            case 18:
                sResRef = "abr_it_gr_sack";
                break;
            case 19:
                sResRef = "abr_it_gr_needle";
                break;
            case 20:
                sResRef = "abr_it_gr_whistle";
                break;
            case 21:
                sResRef = "abr_it_gr_soap";
                break;
            case 22:
                sResRef = "abr_it_gr_tankard_01";
                break;
            case 23:
                sResRef = "abr_it_gr_tankard_02";
                break;
            case 24:
                sResRef = "abr_it_gr_whetstone";
                break;
        }
    }    
    
    // create the item on the creature
    object oItem = CreateItemOnObject(sResRef, oCreature);

    // get the gp value of the item we generated
    int nItemValue = abs(GetGoldPieceValue(oItem));

    // if we can still drop more than 1gp, call this function again
    if (nItemValue < nLootValue && nLootValue > 1) { _generateTreasure(oCreature, nLootValue - nItemValue, nItems++); }
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


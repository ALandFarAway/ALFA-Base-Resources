// ginc_2da
/*
	A central location for storing all the 2da constants and data lookup functions.

*/
// ChazM 4/27/07
// ChazM 5/9/07 - Cacheing functions
// ChazM 6/25/07 - added EXP_TABLE
// ChazM 6/28/07 - added GetIsLegalItemProp() and some additional constants.
// ChazM 7/2/07 - updated output message for GetCacheVarName()
// MDiekmann 8/3/07 - Added some immunity constant for feats
// nchapman 1/18/08 - Reorganized and added function prototypes

#include "ginc_debug"

// ----------------------------------------------------------------------------------------------
// spells 2da
// ----------------------------------------------------------------------------------------------
const string SPELLS_2DA 				= "spells";			// 2da
const string SPELLS_NAME_COL 			= "Name";			// str ref of spell name
const string SPELLS_DESC_COL 			= "SpellDesc";		// str ref of spell description
const string SPELLS_INNATE_LEVEL_COL 	= "Innate";			// Innate level of spell
const string SPELLS_BARD_LEVEL_COL 		= "Bard";			// Bard spell level
const string SPELLS_CLERIC_LEVEL_COL 	= "Cleric";			// Cleric spell level
const string SPELLS_DRUID_LEVEL_COL 	= "Druid";			// Druid spell level
const string SPELLS_PALADIN_LEVEL_COL 	= "Paladin";		// Paladin spell level
const string SPELLS_RANGER_LEVEL_COL 	= "Ranger";			// Ranger spell level
const string SPELLS_WIZ_SORC_LEVEL_COL 	= "Wiz_Sorc";		// Wizard and Sorceror spell level
const string SPELLS_WARLOCK_LEVEL_COL 	= "Warlock";		// Warlock spell level

const string SPELLS_IMMUNITY_TYPE_COL 	= "ImmunityType";
// various values for this SPELLS_IMMUNITY_TYPE_COL
const string SPELLS_2DA_IMMUNITY_MIND_AFFECTING 	= "Mind_Affecting";
const string SPELLS_2DA_IMMUNITY_DEATH 				= "Death";	
const string SPELLS_2DA_IMMUNITY_POISON 			= "Poison";	
const string SPELLS_2DA_IMMUNITY_DISEASE 			= "Disease";
const string SPELLS_2DA_IMMUNITY_FEAR 				= "Fear";
const string SPELLS_2DA_IMMUNITY_ABILITY_DECREASE	= "Ability_Drain";
// Damage types
const string SPELLS_2DA_IMMUNITY_DIVINE				= "Divine";
const string SPELLS_2DA_IMMUNITY_ACID				= "Acid";
const string SPELLS_2DA_IMMUNITY_FIRE				= "Fire";
const string SPELLS_2DA_IMMUNITY_ELECTRICITY		= "Electricity";
const string SPELLS_2DA_IMMUNITY_COLD				= "Cold";
const string SPELLS_2DA_IMMUNITY_SONIC				= "Sonic";
const string SPELLS_2DA_IMMUNITY_NEGATIVE			= "Negative";
const string SPELLS_2DA_IMMUNITY_POSITIVE			= "Positive";




// ----------------------------------------
// 2da constants
// ----------------------------------------
// skills 2da
const string SKILLS_2DA 			= "skills";			// 2da
const int SKILLS_ROW_COUNT			= 29; 				// number of rows in the skills table.
const string SKILLS_NAME_COL 		= "Name";			// str ref of skill name
const string SKILLS_DESC_COL 		= "Description";	// str ref of skill description


// feat 2da
const string FEATS_2DA 				= "feat";			// 2da
const int FEATS_ROW_COUNT			= 1859; 			// number of rows in the feats table.
const string FEATS_NAME_COL 		= "FEAT";			// str ref of feat name
const string FEATS_DESC_COL 		= "DESCRIPTION";	// str ref of feat description
const string FEATS_IMMUNITY_TYPE_COL 	= "ImmunityType";  

// various values for this FEATS_IMMUNITY_TYPE_COL
const string FEATS_2DA_IMMUNITY_KNOCKDOWN 	= "Knockdown";
const string FEATS_2DA_IMMUNITY_NON_SPIRIT 				= "Non_Spirit";	

// spells 2da (in x2_inc_craft)
//const string SPELLS_2DA 			= "spells";			// 2da
const int SPELLS_ROW_COUNT			= 1008; 			// number of rows in the spells table.
//const string SPELLS_NAME_COL 		= "Name";			// str ref of spell name
//const string SPELLS_DESC_COL 		= "SpellDesc";		// str ref of spell description
//const string SPELLS_INNATE_LEVEL_COL = "Innate";		//Innate level of spell

// classes 2da
const string CLASSES_2DA 			= "classes";		// 2da
const int CLASSES_ROW_COUNT			= 56; 				// number of rows in the classes table.
const string CLASSES_NAME_COL 		= "Name";			// str ref of class name
const string CLASSES_DESC_COL 		= "Description";	// str ref of class description

// BaseItems 2da
const string BASEITEMS_2DA 			= "baseitems";		// 2da
const string BASEITEMS_PropColumn_COL 	= "PropColumn";		// str ref of itemprops name

// ItemTypes 2da
const string ITEMTYPES_2DA 				= "itemtypes";		// 2da
const string ITEMTYPES_PropColName_COL 	= "PropColName";	// column name in itemprops.2da


// itemprops 2da
const string ITEM_PROPS_2DA 		= "itemprops";		// 2da
const int ITEM_PROPS_ROW_COUNT		= 89; 				// number of rows in the itemprops table.
const string ITEM_PROPS_NAME_COL 	= "StringRef";		// str ref of itemprops name

// races 2da
const string RACES_2DA 				= "racialtypes";	// 2da
const int RACES_ROW_COUNT			= 30; 				// number of rows in the races table.
const string RACES_NAME_COL 		= "Name";			// str ref of race name

// sub races 2da
const string SUB_RACES_2DA			= "racialsubtypes";	// 2da
const int SUB_RACES_ROW_COUNT		= 46; 				// number of rows in the sub races table.
const string SUB_RACES_NAME_COL 	= "Name";			// str ref of sub race name

//Base Item Types 2da
const string BIT_2DA				= "baseitems";		// 2da
const int BIT_ROW_COUNT				= 143; 				// number of rows in the BIT table.
const string BIT_NAME_COL 			= "Name";			// str ref of BIT name

//  EXPERIENCE LEVELS table 
const string EXP_TABLE_2DA 			= "exptable";
const string EXP_TABLE_XP_COL 		= "XP";


const int MAX_GLOBAL_VARIABLE_NAME_LENGTH = 32;
//const int DEFAULT_MAX_2DA_ROWS = 10000; - Deprecated by GetNum2DARows.

//==========================================================
// FUNCTION PROTOTYPES
//==========================================================
int GetIsLegalItemProp(int nBaseItemType, int nItemProperty);
string GetCacheVarName(string s2DA, string sColumn, string sEntry);
int GetCached2DAIndex(string s2DA, string sColumn, string sEntry);
string SetCached2DAIndex(string s2DA, string sColumn, int nRow);
string GetCached2DAEntry(string s2DA, string sColumn, int nRow);
void SetCached2DAEntry(string s2DA, string sColumn, int nRow);
void Build2DAIndexCache(string s2DA, string sIndexColumn, string sColumn1Cache="", string sColumn2Cache="", int nStartRow=0, int iEndRow = -1);
string Get2DAStringOrDefault(string s2DA, string sColumn, int nRow, string sDefault);
int Search2DA2Col(string s2DA, string sColumn1, string sColumn2, string sMatchElement1, string sMatchElement2, int iStartRow=0, int iEndRow = -1);
int Search2DA(string s2DA, string sColumn, string sMatchElement, int iStartRow=0, int iEndRow = -1);
int Get2DAInt(string s2DA, string sColumn, int nRow);

//==========================================================
// FUNCTION DEFINITONS
//==========================================================

// Is the item property allowed on Item of this base type?
int GetIsLegalItemProp(int nBaseItemType, int nItemProperty)
{
	//int nBaseItemType = GetBaseItemType(oItem);
	// base items are grouped into categories in regards to which item properties are legal
	string sPropCol = Get2DAString(BASEITEMS_2DA, BASEITEMS_PropColumn_COL, nBaseItemType);
	int nPropCol = StringToInt(sPropCol);
	
	// this table converts the item group number to the column name for the itemprops 2da
	string sPropColName = Get2DAString(ITEMTYPES_2DA, ITEMTYPES_PropColName_COL, nPropCol);
	
	// This table lists all item groups against all itemproperties.  Legal props have an entry of "1"
	string sLegalProp = Get2DAString(ITEM_PROPS_2DA, sPropColName, nItemProperty);
	int bLegalProp = StringToInt(sLegalProp);
	PrettyDebug("GetIsLegalItemProp() nBaseItemType=" + IntToString(nBaseItemType) + ", sPropColName = " + sPropColName + ", nItemProperty = " + IntToString(nItemProperty) + ") = " + sLegalProp);
	
	return (bLegalProp);
}

// when the sum of the lengths of these string exceeds the 
// MAX_GLOBAL_VARIABLE_NAME_LENGTH, collisions are possible.
// it's also possible to have collisions with specific data.
string GetCacheVarName(string s2DA, string sColumn, string sEntry)
{
	string sVarName = s2DA + "_" + sColumn + "_" + sEntry;
	int nLength = GetStringLength(sVarName);
	// ensure this is less than the max length for global vars.
	if (nLength > MAX_GLOBAL_VARIABLE_NAME_LENGTH)
	{
		PrettyDebug("GetCacheVarName() Warning: |" + sVarName + "| Var Name exceeded Max length.  Truncating.");
		sVarName = GetStringRight(sVarName, MAX_GLOBAL_VARIABLE_NAME_LENGTH);
	}
	return (sVarName);
}



// cache the row number for this 2da entry and store it as a global var.
int GetCached2DAIndex(string s2DA, string sColumn, string sEntry)
{
	string sVarName = GetCacheVarName(s2DA, sColumn, sEntry);
	int nRow = GetGlobalInt(sVarName);
	return (nRow);
}

// cache the row number for this 2da entry and store it as a global var.
// returns the looked up entry.
string SetCached2DAIndex(string s2DA, string sColumn, int nRow)
{
	string sEntry = Get2DAString(s2DA, sColumn, nRow);
	if (sEntry != "") // sEntry not allowed to be empty string
	{
		string sVarName = GetCacheVarName(s2DA, sColumn, sEntry);
		SetGlobalInt(sVarName, nRow);
	}		
	return (sEntry);
}

// cache the row number for this 2da entry and store it as a global var.
string GetCached2DAEntry(string s2DA, string sColumn, int nRow)
{
	string sVarName = GetCacheVarName(s2DA, sColumn, IntToString(nRow));
	string sCachedEntry = GetGlobalString(sVarName);
	return (sCachedEntry);
}

// Cache the specified 2da entry 
void SetCached2DAEntry(string s2DA, string sColumn, int nRow)
{
	if (sColumn == "")
		return;
		
	string sEntry = Get2DAString(s2DA, sColumn, nRow);
	string sVarName = GetCacheVarName(s2DA, sColumn, IntToString(nRow));
	SetGlobalString(sVarName, sEntry);
}



// store values into global memory for later retrieval
// will optionally cache data from other columns also.
// Note: Values for the IndexColumn must never return an empty string!
void Build2DAIndexCache(string s2DA, string sIndexColumn, string sColumn1Cache="", string sColumn2Cache="", int nStartRow=0, int nEndRow = -1)
{
	int nRow = nStartRow;
	string sEntry;
	
	if(nEndRow = -1)
		nEndRow = GetNum2DARows( s2DA );
	
	while (nRow <= nEndRow)
	{
		sEntry = SetCached2DAIndex(s2DA, sIndexColumn, nRow);
		if (sEntry == "")
			return;
			
		SetCached2DAEntry(s2DA, sColumn1Cache, nRow);
		SetCached2DAEntry(s2DA, sColumn2Cache, nRow);
		
		nRow++;
	}
}


//------------------------------------------------------------------------------
// Get a 2da String or the supplied default if string is empty
//------------------------------------------------------------------------------
string Get2DAStringOrDefault(string s2DA, string sColumn, int nRow, string sDefault)
{
    string sRet;
    sRet =Get2DAString(s2DA, sColumn, nRow);
    //if (sRet == "****" || sRet == "") 
	// "****" is translated to "" by Get2DAString()
    if (sRet == "") 
    {
        sRet = sDefault;
    }
    return sRet;

}


// returns row number of match or -1 if not found.
// searches from start row to endrow for matching values in 2 columns.  Searches the entire 2DA if iEndRow is unspecified.
// search stops if empty string is returned (may be due to file, column, or row is not found or entry is "****")
int Search2DA2Col(string s2DA, string sColumn1, string sColumn2, string sMatchElement1, string sMatchElement2, int iStartRow=0, int iEndRow = -1)
{
	int i = iStartRow;
	string sEntry1;
	string sEntry2;
	
	if( iEndRow == -1)
		iEndRow = GetNum2DARows( s2DA );
		
	while (i <= iEndRow)
	{
		sEntry1 = Get2DAString(s2DA, sColumn1, i);
		if (sEntry1 == sMatchElement1)
		{
			sEntry2 = Get2DAString(s2DA, sColumn2, i);
			if (sEntry2 == sMatchElement2)
			{
				return i;
			}				
		}
		
		if (sEntry1 == "")
			return -1;
		i++;
	}
	return -1;
}

// returns row number of match or -1 if not found.
// searches from start row to endrow
// search stops if empty string is returned (may be due to file, column, or row is not found or entry is "****"
int Search2DA(string s2DA, string sColumn, string sMatchElement, int iStartRow=0, int iEndRow=-1)
{
	int i = iStartRow;
	string sEntry;
	
	if(iEndRow == -1)
		iEndRow = GetNum2DARows( s2DA );
	
	while (i <= iEndRow)
	{
		sEntry = Get2DAString(s2DA, sColumn, i);
		//PrettyDebug("row ["+ IntToString(i) + "] sEntry = " + sEntry);
		if (sEntry == sMatchElement)
			return i;
		if (sEntry == "")
			return -1;
		i++;
	}
	return -1;
}

//Simple wrapper to save space - gets an entry in a 2DA and converts it to an int.
int Get2DAInt(string s2DA, string sColumn, int nRow)
{
	string sStringToConvert = Get2DAString(s2DA, sColumn, nRow);
	int iResult = StringToInt(sStringToConvert);
	return iResult;
}
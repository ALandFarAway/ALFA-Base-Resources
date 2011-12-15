#include "nwnx_objectattributes_include"
#include "acr_tools_i"
#include "acr_pps_i"


#define _DEBUG_ZS

const int ACR_NUM_DEFAULT_FEATURE_COLOURS	= 18;
const int ACR_FEATURE_TYPE_RANDOM		= 999;


const int ACR_APP_TYPE_HAIR_ACC			= 0x011;
const int ACR_APP_TYPE_HAIR_LO			= 0x012;
const int ACR_APP_TYPE_HAIR_HI			= 0x013;

const int ACR_APP_TYPE_HEAD_SKIN		= 0x021;
const int ACR_APP_TYPE_HEAD_EYE			= 0x022;
const int ACR_APP_TYPE_HEAD_HAIR		= 0x023;

const int ACR_APP_TYPE_BASE_SKIN		= 0x031;
const int ACR_APP_TYPE_BASE_HAIR		= 0x032;
const int ACR_APP_TYPE_BASE_EYE			= 0x033;


// This function applies a hair dye oDye to the subject oTarget, using the skill
// of oBeautician. It assumes that permission is given to oTarget, but contains
// the functionality to handle all other aspects of the effect.
void DoHairDye(object oDye, object oBeautician, object oTarget, int nRoll = FALSE);

string GetRawHairTintSet(object oCharacter);

string GetRawBaseTintSet(object oCharacter);

string GetRawSkinTintSet(object oCharacter);

string RawToTintSet0(string sRawHair);

string RawToTintSet1(string sRawHair);

string RawToTintSet2(string sRawHair);

string RawSkinToSkin(string sRawBody);

string RawSkinToEyes(string sRawBody);

string RawSkinToBodyHair(string sRawBody);

string RawTintToTint1(string sRawTint);

string RawTintToTint2(string sRawTint);

string RawTintToTint3(string sRawTint);


struct XPObjectAttributes_Color RawAttribToTint(string sRaw)
{
	struct XPObjectAttributes_Color col;

	// 8 characters, defined as:
	//
	// rrggbbaa
	//
	// convert from 0-255 -> 0-1
	
	col.r = HexStringToFloat(GetStringLeft(sRaw, 2)) / 255.0f;
	col.g = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 4), 2)) / 255.0f;
	col.b = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 6), 2)) / 255.0f;
	col.a = HexStringToFloat(GetStringRight(GetStringLeft(sRaw, 8), 2)) / 255.0f;

	return col;
}


struct XPObjectAttributes_TintSet RawAttribToTintSet(string sRaw)
{
	struct XPObjectAttributes_TintSet tints;
	string s0, s1, s2;

	s0 = RawToTintSet0(sRaw);
	s1 = RawToTintSet1(sRaw);
	s2 = RawToTintSet2(sRaw);

	tints.Tint0 = RawAttribToTint(s2);
	tints.Tint1 = RawAttribToTint(s1);
	tints.Tint2 = RawAttribToTint(s0);

	return tints;
}

struct XPObjectAttributes_TintSet GetHairTintSet(object o)
{
	return RawAttribToTintSet(GetRawHairTintSet(o));
}

struct XPObjectAttributes_TintSet GetBaseTintSet(object o)
{
	return RawAttribToTintSet(GetRawBaseTintSet(o));
}

struct XPObjectAttributes_TintSet GetSkinTintSet(object o)
{
	return RawAttribToTintSet(GetRawSkinTintSet(o));
}


void DoHairDye(object oDye, object oBeautician, object oTarget, int nRoll = FALSE)
{
	struct XPObjectAttributes_Color dye;
	struct XPObjectAttributes_TintSet tints;

//=== The dye's tag contains the dye's 'true' color. ===//
	string sDye = GetStringRight(GetTag(oDye), 6) + "00";
	
//=== This information lives inside of the character object-- we need NWNx4 to harvest it ===//
	tints = GetHairTintSet(oTarget);
	dye = RawAttribToTint(sDye);

//=== Need to convert the input (hex strings) into something we can do math on (integers) ===//

	int nHLRed    = FloatToInt(255.0f * tints.Tint0.r);
	int nHLGreen  = FloatToInt(255.0f * tints.Tint0.g);
	int nHLBlue   = FloatToInt(255.0f * tints.Tint0.b);

	int nLLRed    = FloatToInt(255.0f * tints.Tint1.r);
	int nLLGreen  = FloatToInt(255.0f * tints.Tint1.g);
	int nLLBlue   = FloatToInt(255.0f * tints.Tint1.b);

	int nAccRed   = FloatToInt(255.0f * tints.Tint2.r);
	int nAccGreen = FloatToInt(255.0f * tints.Tint2.g);
	int nAccBlue  = FloatToInt(255.0f * tints.Tint2.b);

	int nDyeRed   = FloatToInt(255.0f * dye.r);
	int nDyeGreen = FloatToInt(255.0f * dye.g);
	int nDyeBlue  = FloatToInt(255.0f * dye.b);
	
//=== Figure out what the skill roll was. ===//	
	int nSkillRoll = 10;
	if(nRoll) nSkillRoll = d20(1);
	int nSkillMod = GetSkillRank(34, oBeautician);
	int nSkillFinal = nSkillRoll + nSkillMod;
	
//=== Let the involved parties know what the dice gods say. ===//	
	string sMessage = "<color=#8699D3>"+GetName(oBeautician)+"</color><color=#203F91> : Disguise: "+IntToString(nSkillRoll)+" + "+IntToString(nSkillMod)+" = "+IntToString(nSkillFinal)+".";
	SendMessageToPC(oBeautician, sMessage);
	SendMessageToPC(oTarget, sMessage);
	
	int nFinalHLRed;
	int nFinalHLGreen;
	int nFinalHLBlue;
	int nFinalLLRed;
	int nFinalLLGreen;
	int nFinalLLBlue;
	
//=== if/ else if structure handles the values of the skill checks and calculates the finished hair tint. ===//		
	if(nSkillFinal < 5) // total failure; hair color is random.
	{
		nFinalHLRed   = d100(2)+20;
		nFinalHLGreen = d100(2)+20;
		nFinalHLBlue  = d100(2)+20;
		nFinalLLRed   = nFinalHLRed   - 20;
		nFinalLLBlue  = nFinalHLBlue  - 20;
		nFinalLLGreen = nFinalHLGreen - 20;
		if(nFinalLLRed   < 0) nFinalLLRed   = 0;
		if(nFinalLLGreen < 0) nFinalLLGreen = 0;
		if(nFinalLLBlue  < 0) nFinalLLBlue  = 0;
	}
	else if(nSkillFinal < 10) // serious failure; either ineffective or washed out.
	{
		if(d2() == 2) // calculate ineffective
		{
			nFinalHLRed   = nHLRed   - (nHLRed/10)   + (nDyeRed/10);
			nFinalHLGreen = nHLGreen - (nHLGreen/10) + (nDyeGreen/10);
			nFinalHLBlue  = nHLBlue  - (nHLBlue/10)  + (nDyeBlue/10);
			nFinalLLRed   = nLLRed   - (nLLRed/10)   + (nDyeRed/10);
			nFinalLLGreen = nLLGreen - (nLLGreen/10) + (nDyeGreen/10);
			nFinalLLBlue  = nLLBlue  - (nLLBlue/10)  + (nDyeBlue/10);
		}
		else // calculate washed out
		{
			nFinalHLRed   = nHLRed/10   + (nDyeRed * 2)   - (nDyeRed/5);
			nFinalHLGreen = nHLGreen/10 + (nDyeGreen * 2) - (nDyeGreen/5);
			nFinalHLBlue  = nHLBlue/10  + (nDyeBlue * 2)  - (nDyeBlue/5);
			nFinalLLRed   = nLLRed/10   + (nDyeRed * 2)   - (nDyeRed/5);
			nFinalLLGreen = nLLGreen/10 + (nDyeGreen * 2) - (nDyeGreen/5);
			nFinalLLBlue  = nLLBlue/10  + (nDyeBlue * 2)  - (nDyeBlue/5);
			if(nFinalHLRed   > 255) nFinalHLRed   = 255;
			if(nFinalHLGreen > 255) nFinalHLGreen = 255;
			if(nFinalHLBlue  > 255) nFinalHLBlue  = 255;
			if(nFinalLLRed   > 235) nFinalLLRed   = 235;
			if(nFinalLLGreen > 235) nFinalLLGreen = 235;
			if(nFinalLLBlue  > 235) nFinalLLBlue  = 235;
			if(nFinalHLRed   < 200) nFinalHLRed   = 200;
			if(nFinalHLGreen < 200) nFinalHLGreen = 200;
			if(nFinalHLBlue  < 200) nFinalHLBlue  = 200;
			if(nFinalLLRed   < 180) nFinalLLRed   = 180;
			if(nFinalLLGreen < 180) nFinalLLGreen = 180;
			if(nFinalLLBlue  < 180) nFinalLLBlue  = 180;
		}
	}
	else if(nSkillFinal < 15) // less-than ideal. Hair dye might have a minor effect; it might be less-washed-out
	{
		if(d2() == 2) // calculate ineffective.
		{
			nFinalHLRed   = nHLRed   - (nHLRed/4)   + (nDyeRed/4);
			nFinalHLGreen = nHLGreen - (nHLGreen/4) + (nDyeGreen/4);
			nFinalHLBlue  = nHLBlue  - (nHLBlue/4)  + (nDyeBlue/4);
			nFinalLLRed   = nLLRed   - (nLLRed/4)   + (nDyeRed/4);
			nFinalLLGreen = nLLGreen - (nLLGreen/4) + (nDyeGreen/4);
			nFinalLLBlue  = nLLBlue  - (nLLBlue/4)  + (nDyeBlue/4);
		}
		else // calculate washed out.
		{
			nFinalHLRed   = nHLRed/4   + nDyeRed   + (nDyeRed/2);
			nFinalHLGreen = nHLGreen/4 + nDyeGreen + (nDyeGreen/2);
			nFinalHLBlue  = nHLBlue/4  + nDyeBlue  + (nDyeBlue/2);
			nFinalLLRed   = nLLRed/4   + nDyeRed   + (nDyeRed/2);
			nFinalLLGreen = nLLGreen/4 + nDyeGreen + (nDyeGreen/2);
			nFinalLLBlue  = nLLBlue/4  + nDyeBlue  + (nDyeBlue/2);
			if(nFinalHLRed   > 255) nFinalHLRed   = 255;
			if(nFinalHLGreen > 255) nFinalHLGreen = 255;
			if(nFinalHLBlue  > 255) nFinalHLBlue  = 255;
			if(nFinalLLRed   > 235) nFinalLLRed   = 235;
			if(nFinalLLGreen > 235) nFinalLLGreen = 235;
			if(nFinalLLBlue  > 235) nFinalLLBlue  = 235;
			if(nFinalHLRed   < 150) nFinalHLRed   = 150;
			if(nFinalHLGreen < 150) nFinalHLGreen = 150;
			if(nFinalHLBlue  < 150) nFinalHLBlue  = 150;
			if(nFinalLLRed   < 130) nFinalLLRed   = 130;
			if(nFinalLLGreen < 130) nFinalLLGreen = 130;
			if(nFinalLLBlue  < 130) nFinalLLBlue  = 130;
		}	
	}
	else if(nSkillFinal < 20) // Success. Calculate 50/50 between dye and hair.
	{
		nFinalHLRed   = nHLRed/2   + nDyeRed/2;
		nFinalHLGreen = nHLGreen/2 + nDyeGreen/2;
		nFinalHLBlue  = nHLBlue/2  + nDyeBlue/2;
		nFinalLLRed   = nLLRed/2   + nDyeRed/2;
		nFinalLLGreen = nLLGreen/2 + nDyeGreen/2;
		nFinalLLBlue  = nLLBlue/2  + nDyeBlue/2;	
	}
	else if(nSkillFinal < 25) // Greate success. Calculate 75/25 dye/hair.
	{
		nFinalHLRed   = nHLRed/4   + nDyeRed   - nDyeRed/4;
		nFinalHLGreen = nHLGreen/4 + nDyeGreen - nDyeGreen/4;
		nFinalHLBlue  = nHLBlue/4  + nDyeBlue  - nDyeBlue/4;
		nFinalLLRed   = nLLRed/4   + nDyeRed   - nDyeRed/4;
		nFinalLLGreen = nLLGreen/4 + nDyeGreen - nDyeGreen/4;
		nFinalLLBlue  = nLLBlue/4  + nDyeBlue  - nDyeBlue/4;	
	}
	else if(nSkillFinal < 30) // Winning significantly. Calculate 90/10.
	{
		nFinalHLRed   = nHLRed/10   + nDyeRed   - nDyeRed/10;
		nFinalHLGreen = nHLGreen/10 + nDyeGreen - nDyeGreen/10;
		nFinalHLBlue  = nHLBlue/10  + nDyeBlue  - nDyeBlue/10;
		nFinalLLRed   = nLLRed/10   + nDyeRed   - nDyeRed/10;
		nFinalLLGreen = nLLGreen/10 + nDyeGreen - nDyeGreen/10;
		nFinalLLBlue  = nLLBlue/10  + nDyeBlue  - nDyeBlue/10;	
	}
	else // Jeeeeeezuhs. Let 'em have the dye already.
	{
		nFinalHLRed   = nDyeRed;
		nFinalHLGreen = nDyeGreen;
		nFinalHLBlue  = nDyeBlue;
		nFinalLLRed   = nDyeRed - 20;
		nFinalLLGreen = nDyeGreen - 20;
		nFinalLLBlue  = nDyeBlue - 20;
		if(nFinalLLRed   < 0) nFinalLLRed   = 0;
		if(nFinalLLGreen < 0) nFinalLLGreen = 0;
		if(nFinalLLBlue  < 0) nFinalLLBlue  = 0;
	}
	
//==== Need to convert our math (integers 0-255) to Skywing's math (float 0.0 - 1.0) ===//	
	float fFinalAccRed   = IntToFloat(nAccRed)   / 255.0f;	
	float fFinalAccBlue  = IntToFloat(nAccBlue)  / 255.0f;
	float fFinalAccGreen = IntToFloat(nAccGreen) / 255.0f;
	float fFinalHLRed    = IntToFloat(nFinalHLRed)    / 255.0f;	
	float fFinalHLBlue   = IntToFloat(nFinalHLBlue)   / 255.0f;
	float fFinalHLGreen  = IntToFloat(nFinalHLGreen)  / 255.0f;	
	float fFinalLLRed    = IntToFloat(nFinalLLRed)    / 255.0f;	
	float fFinalLLBlue   = IntToFloat(nFinalLLBlue)   / 255.0f;
	float fFinalLLGreen  = IntToFloat(nFinalLLGreen)  / 255.0f;

//=== We need to edit the character object to make this display, which means we return to the NWNx4 ===//	
	XPObjectAttributesSetHairTint(oTarget, 
		CreateXPObjectAttributes_TintSet(
			CreateXPObjectAttributes_Color(fFinalAccRed, fFinalAccGreen, fFinalAccBlue, 1.0f),
			CreateXPObjectAttributes_Color(fFinalLLRed,  fFinalLLGreen,  fFinalLLBlue,  1.0f),
			CreateXPObjectAttributes_Color(fFinalHLRed,  fFinalHLGreen,  fFinalHLBlue,  1.0f)));	
}

string GetRawHairTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetHairTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string GetRawBaseTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetBaseTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string GetRawSkinTintSet(object oCharacter)
{
	string sTintSet = NWNXGetString("OBJECTATTRIBUTES", 
									"GetSkinTint",
									"",
									ObjectToInt( oCharacter ));
	return sTintSet;
}

string RawToTintSet2(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 13), 8);
}

string RawToTintSet1(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 25), 8);
}

string RawToTintSet0(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 37), 8);
}


string RawairToHairAccessory(string sRawHair)
{
	return RawToTintSet2(sRawHair);
}

string RawHairToHairLowlight(string sRawHair)
{
	return RawToTintSet1(sRawHair);
}

string RawHairToHairHighlight(string sRawHair)
{
	return RawToTintSet0(sRawHair);
}


string GetNaturalHairColor(object oCharacter)
{
//=== We don't want to ping the database for an NPC; zspawn enables DMs to fiddle with hair colors much more cheaply. ===//
	if(!GetIsPC(oCharacter) || GetIsDMPossessed(oCharacter))
	{
		SendMessageToAllDMs("Warning : GetNaturalHairColor() has been called on an NPC. Aborting the script.");
		return "ERROR";
	}
	
//=== We don't want to ping the database for a DM; if vanity is super important to them, they can more-easily use a GFF editor ===//
	if(GetIsDM(oCharacter))
	{
		SendMessageToAllDMs("Warning : GetNaturalHairColor() has been called on a DM avatar. Aborting the script.");
		return "ERROR";
	}
	object oTool = GetItemPossessedBy(oCharacter, "dmfi_exe_pc");

//=== We would very much like to save this to the DMFI tool. It's faster. ===//
	string sHair = GetLocalString(oTool, "ACR_VANITY_NATHAIR");
	
//=== Dammit. Try the SQL. ===//
	if(sHair == "")
	{
		string sCID = IntToString(ACR_GetCharacterID(oCharacter));
		ACR_SQLQuery("SELECT NaturalHair FROM characters WHERE ID='"+sCID+"'");
		
//=== Fetch failed. GetData won't give us good numbers, so we update the column in the table and use current colors ===//
		if(ACR_SQLFetch() != SQL_SUCCESS)
		{
			string sCurrentHair = GetRawHairTintSet(oCharacter);
			ACR_SQLQuery("UPDATE characters SET NaturalHair='"+sCurrentHair+"' WHERE ID='"+sCID+"'");
			sHair = sCurrentHair;
			SetLocalString(oTool, "ACR_VANITY_NATHAIR", sHair);
		}
		
//=== Fetch succeeded. Harvest data and copy to the data item. ===//		
		else
		{
			sHair = ACR_SQLGetData(0);
			SetLocalString(oTool, "ACR_VANITY_NATHAIR", sHair);
		}
	}
	
	return sHair;
}


int GetRandomHairModel(int nSubrace, int nGender=0)
{
	int res = 1;

	switch (nSubrace) {

		case RACIAL_SUBTYPE_SHIELD_DWARF:
		case RACIAL_SUBTYPE_GOLD_DWARF: 
			res = UniformRandomOverInterval("[1-19,80-82,94][1-19,73,94]", nGender);
			break;
		case RACIAL_SUBTYPE_MOON_ELF:
		case RACIAL_SUBTYPE_SUN_ELF: 
		case RACIAL_SUBTYPE_WOOD_ELF:
		case RACIAL_SUBTYPE_DROW: 
			res = UniformRandomOverInterval("[1-17,61-64,66-75,80-82,94][1-17,50-52,61-64,66-78,80-82,85-90,94]", nGender);
			break;
		case RACIAL_SUBTYPE_WILD_ELF:  
			res = UniformRandomOverInterval("[1-3,75,80,81,83]");
			break;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			res = UniformRandomOverInterval("[1-17,94][1-17,50-52,73,80-82,94]", nGender);
			break;
		case RACIAL_SUBTYPE_GRAY_DWARF:
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			res = 17;
			break;
		case RACIAL_SUBTYPE_HUMAN:
		case RACIAL_SUBTYPE_HALFELF:
		case RACIAL_SUBTYPE_HALFDROW:
			res = UniformRandomOverInterval("[1-17,37,38,63,66,71-75,80-82,94][1-17,23,24,50-52,61-64,66-78,80-82,85-90,94]", nGender);
			break;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			res = UniformRandomOverInterval("[1-19,66,74,75,94][1-17,19,51-56,23,24,50-52,66,73-78,80,94]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFORC:
		case RACIAL_SUBTYPE_GRAYORC:
			res = UniformRandomOverInterval("[1-19,94]");
			break;
		case RACIAL_SUBTYPE_YUANTI:
			res = UniformRandomOverInterval("[1-17]");
			break;
		case RACIAL_SUBTYPE_WATER_GENASI:
		case RACIAL_SUBTYPE_FIRE_GENASI:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_AIR_GENASI:
			res = UniformRandomOverInterval("[1-3]");
			break;
		case RACIAL_SUBTYPE_TIEFLING:
			res = UniformRandomOverInterval("[1-18,94][1-19,73,94]", nGender);
			break;
		case RACIAL_SUBTYPE_AASIMAR:
			res = UniformRandomOverInterval("[1-17,37,38,63,66,71-75,80-82,94][1-17,23,24,50-52,61-64,67-78,80-82,85-90,94]", nGender);
			break;
	}

	return res;
}

int GetRandomHeadModel(int nSubrace, int nGender=0)
{
	int res = 1;

	switch (nSubrace) {
		case RACIAL_SUBTYPE_SHIELD_DWARF:
			res = UniformRandomOverInterval("[1-6]");
			break;
		case RACIAL_SUBTYPE_GOLD_DWARF:
		case RACIAL_SUBTYPE_GRAY_DWARF:
			res = UniformRandomOverInterval("[1-3]");
			break;
		case RACIAL_SUBTYPE_MOON_ELF:
			res = UniformRandomOverInterval("[1-7,10][1-8]", nGender);
			break;
		case RACIAL_SUBTYPE_SUN_ELF: 
			res = UniformRandomOverInterval("[1-3][1-2,4-5]", nGender);
			break;
		case RACIAL_SUBTYPE_WILD_ELF:
		case RACIAL_SUBTYPE_WOOD_ELF:
			res = UniformRandomOverInterval("[1-3]");
			break;
		case RACIAL_SUBTYPE_DROW:
			res = UniformRandomOverInterval("[1-3][1-5]", nGender);
			break;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			res = UniformRandomOverInterval("[1-8,10][1-4,7]", nGender);
			break;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			res = UniformRandomOverInterval("[1-5][1-4]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFELF:
			res = UniformRandomOverInterval("[1-6]");
			break;
		case RACIAL_SUBTYPE_HALFDROW:
			res = UniformRandomOverInterval("[1-3]");
			break;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
			res = UniformRandomOverInterval("[1-6]");
			break;
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			res = UniformRandomOverInterval("[1-7][1-5]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFORC:
			res = UniformRandomOverInterval("[1-6][1-7]", nGender);
			break;
		case RACIAL_SUBTYPE_HUMAN:
			res = UniformRandomOverInterval("[1-10,12-20,22-24,40-42][1-6,8-11,14,15,20,25,58-60,88,95]", nGender);
			break;
		case RACIAL_SUBTYPE_YUANTI:
		case RACIAL_SUBTYPE_GRAYORC:
		case RACIAL_SUBTYPE_WATER_GENASI:
		case RACIAL_SUBTYPE_FIRE_GENASI:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_AIR_GENASI:
			res = UniformRandomOverInterval("[1-3]");
			break;
		case RACIAL_SUBTYPE_AASIMAR:
		case RACIAL_SUBTYPE_TIEFLING:
			res = UniformRandomOverInterval("[1-5]");
			break;
	}

	return res;
}

// this is a superset of the random listing
string GetValidHairModels(int nSubrace, int nGender=0)
{
	string res;

	switch (nSubrace) {

		case RACIAL_SUBTYPE_SHIELD_DWARF:
		case RACIAL_SUBTYPE_GOLD_DWARF: 
			res = IntervalToList("[1-19,80-82,94][1-19,73,94]", nGender);
			break;
		case RACIAL_SUBTYPE_MOON_ELF:
		case RACIAL_SUBTYPE_SUN_ELF: 
		case RACIAL_SUBTYPE_WOOD_ELF:
		case RACIAL_SUBTYPE_DROW: 
			res = IntervalToList("[1-17,61-64,66-75,80-82,94][1-17,50-52,61-64,66-78,80-82,85-90,94]", nGender);
			break;
		case RACIAL_SUBTYPE_WILD_ELF:  
			res = IntervalToList("[1-3,75,80,81,83]");
			break;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			res = IntervalToList("[1-17,94][1-17,50-52,73,80-82,94]", nGender);
			break;
		case RACIAL_SUBTYPE_GRAY_DWARF:
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			res = IntervalToList("[17]");
			break;
		case RACIAL_SUBTYPE_HUMAN:
		case RACIAL_SUBTYPE_HALFELF:
		case RACIAL_SUBTYPE_HALFDROW:
			res = IntervalToList("[1-17,37,38,63,66,71-75,80-82,94][1-17,23,24,50-52,61-64,66-78,80-82,85-90,94]", nGender);
			break;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			res = IntervalToList("[1-19,66,74,75,94][1-17,19,51-56,23,24,50-52,66,73-78,80,94]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFORC:
		case RACIAL_SUBTYPE_GRAYORC:
			res = IntervalToList("[1-19,94]");
			break;
		case RACIAL_SUBTYPE_YUANTI:
			res = IntervalToList("[1-17]");
			break;
		case RACIAL_SUBTYPE_WATER_GENASI:
		case RACIAL_SUBTYPE_FIRE_GENASI:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_AIR_GENASI:
			res = IntervalToList("[1-3]");
			break;
		case RACIAL_SUBTYPE_TIEFLING:
			res = IntervalToList("[1-18,94][1-19,73,94]", nGender);
			break;
		case RACIAL_SUBTYPE_AASIMAR:
			res = IntervalToList("[1-17,37,38,63,66,71-75,80-82,94][1-17,23,24,50-52,61-64,67-78,80-82,85-90,94]", nGender);
			break;
	}

	return res;
}

// this is a superset of the random listing
string GetValidHeadModels(int nSubrace, int nGender=0)
{
	string res;

	switch (nSubrace) {
		case RACIAL_SUBTYPE_SHIELD_DWARF:
			res = IntervalToList("[1-6]");
			break;
		case RACIAL_SUBTYPE_GOLD_DWARF:
		case RACIAL_SUBTYPE_GRAY_DWARF:
			res = IntervalToList("[1-3]");
			break;
		case RACIAL_SUBTYPE_MOON_ELF:
			res = IntervalToList("[1-7,10][1-8]", nGender);
			break;
		case RACIAL_SUBTYPE_SUN_ELF: 
			res = IntervalToList("[1-3][1-2,4-5]", nGender);
			break;
		case RACIAL_SUBTYPE_WILD_ELF:
		case RACIAL_SUBTYPE_WOOD_ELF:
			res = IntervalToList("[1-3]");
			break;
		case RACIAL_SUBTYPE_DROW:
			res = IntervalToList("[1-3][1-5]", nGender);
			break;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			res = IntervalToList("[1-8,10][1-4,7]", nGender);
			break;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			res = IntervalToList("[1-5][1-4]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFELF:
			res = IntervalToList("[1-6]");
			break;
		case RACIAL_SUBTYPE_HALFDROW:
			res = IntervalToList("[1-3]");
			break;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
			res = IntervalToList("[1-6]");
			break;
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			res = IntervalToList("[1-7][1-5]", nGender);
			break;
		case RACIAL_SUBTYPE_HALFORC:
			res = IntervalToList("[1-6][1-7]", nGender);
			break;
		case RACIAL_SUBTYPE_HUMAN:
			res = IntervalToList("[1-10,12-20,22-24,40-42][1-6,8-11,14,15,20,25,58-60,88,95]", nGender);
			break;
		case RACIAL_SUBTYPE_YUANTI:
		case RACIAL_SUBTYPE_GRAYORC:
		case RACIAL_SUBTYPE_WATER_GENASI:
		case RACIAL_SUBTYPE_FIRE_GENASI:
		case RACIAL_SUBTYPE_EARTH_GENASI:
		case RACIAL_SUBTYPE_AIR_GENASI:
			res = IntervalToList("[1-3]");
			break;
		case RACIAL_SUBTYPE_AASIMAR:
		case RACIAL_SUBTYPE_TIEFLING:
			res = IntervalToList("[1-5]");
			break;
	}

	return res;
}

string GetRandomTint(int nSubrace, int nColumn, int nElement=ACR_FEATURE_TYPE_RANDOM)
{
	string s2DA;
	string sColumn;
	if (nElement == -1 || nElement == ACR_FEATURE_TYPE_RANDOM)
		nElement = Random(ACR_NUM_DEFAULT_FEATURE_COLOURS);
	
	switch (nSubrace) {
		case RACIAL_SUBTYPE_SHIELD_DWARF:
			s2DA = "color_shielddwarf";
			break;
		case RACIAL_SUBTYPE_GOLD_DWARF:
			s2DA = "color_golddwarf";
			break;
		case RACIAL_SUBTYPE_GRAY_DWARF:
			s2DA = "color_graydwarf";
			break;
		case RACIAL_SUBTYPE_MOON_ELF:
			s2DA = "color_moonelf";
			break;
		case RACIAL_SUBTYPE_SUN_ELF:
			s2DA = "color_sunelf";
			break;
		case RACIAL_SUBTYPE_WILD_ELF:
			s2DA = "color_wildelf";
			break;
		case RACIAL_SUBTYPE_WOOD_ELF:
			s2DA = "color_woodelf";
			break;
		case RACIAL_SUBTYPE_DROW:
			s2DA = "color_drow";
			break;
		case RACIAL_SUBTYPE_ROCK_GNOME:
			s2DA = "color_rockgnome";
			break;
		case RACIAL_SUBTYPE_SVIRFNEBLIN:
			s2DA = "color_deepgnome";
			break;
		case RACIAL_SUBTYPE_HALFELF:
			s2DA = "color_halfelf";
			break;
		case RACIAL_SUBTYPE_HALFDROW:
			s2DA = "color_halfdrow";
			break;
		case RACIAL_SUBTYPE_LIGHTFOOT_HALF:
			s2DA = "color_lightfoot";
			break;
		case RACIAL_SUBTYPE_GHOSTWISE_HALF:
			s2DA = "color_ghostwise";
			break;
		case RACIAL_SUBTYPE_STRONGHEART_HALF:
			s2DA = "color_strongheart";
			break;
		case RACIAL_SUBTYPE_HALFORC:
			s2DA = "color_halforc";
			break;
		case RACIAL_SUBTYPE_HUMAN:
			s2DA = "color_human";
			break;
		case RACIAL_SUBTYPE_AASIMAR:
			s2DA = "color_aasimar";
			break;
		case RACIAL_SUBTYPE_TIEFLING:
			s2DA = "color_tiefling";
			break;
		case RACIAL_SUBTYPE_AIR_GENASI:
			s2DA = "color_airgen";
			break;
		case RACIAL_SUBTYPE_EARTH_GENASI:
			s2DA = "color_earthgen";
			break;
		case RACIAL_SUBTYPE_FIRE_GENASI:
			s2DA = "color_firegen";
			break;
		case RACIAL_SUBTYPE_WATER_GENASI:
			s2DA = "color_watergen";
			break;
		case RACIAL_SUBTYPE_GRAYORC:
			s2DA = "color_grayorc";
			break;
		case RACIAL_SUBTYPE_YUANTI:
			s2DA = "color_yuanti";
			break;
	}
	
	switch (nColumn) {
		case 1:
			sColumn = "hair_1";
			break;
		case 2:
			sColumn = "hair_2";
			break;
		case 3:
			sColumn = "hair_acc";
			break;
		case 4:
			sColumn = "skin";
			break;
		case 5:
			sColumn = "eyes";
			break;
		case 6:
			sColumn = "body_hair";
			break;
	}
	
	return Get2DAString(s2DA, sColumn, nElement);
}


//! Randomize appearance of a playable creature
void ACR_RandomizeAppearance(object oSpawn,int nHead = ACR_FEATURE_TYPE_RANDOM,int nHair = ACR_FEATURE_TYPE_RANDOM,int nHair1 = ACR_FEATURE_TYPE_RANDOM,int nHair2 = ACR_FEATURE_TYPE_RANDOM,int nAHair = ACR_FEATURE_TYPE_RANDOM, int nBHair = ACR_FEATURE_TYPE_RANDOM,int nSkin = ACR_FEATURE_TYPE_RANDOM,int nEyes = ACR_FEATURE_TYPE_RANDOM,float fFHair=0.5,int bChangeApp=TRUE)
{
	int nHeadModel,nHairModel,nRandHair,nRace,nSubrace,nGender,nAppearance;

	nRace = GetRacialType(oSpawn);
	nSubrace = GetSubRace(oSpawn);
	nGender = GetGender(oSpawn);

	if (bChangeApp) {
		nAppearance = GetSubraceAppearance(nSubrace);

		if (nAppearance != APPEARANCE_TYPE_INVALID)
			SetCreatureAppearanceType(oSpawn, nAppearance);
	}
	
	
	if (nHead != ACR_FEATURE_TYPE_RANDOM && nHead != 0)
		nHeadModel = nHead;
	else
		nHeadModel = GetRandomHeadModel(nSubrace, nGender);	

	if (nHair != ACR_FEATURE_TYPE_RANDOM)
		nHairModel = nHair;
	else
		nHairModel = GetRandomHairModel(nSubrace, nGender);

	nRandHair = Random(ACR_NUM_DEFAULT_FEATURE_COLOURS);

	if (nHair1 == ACR_FEATURE_TYPE_RANDOM)
		nHair1 = nRandHair;

	if (nHair2 == ACR_FEATURE_TYPE_RANDOM)
		nHair2 = nRandHair;

	if (nBHair == ACR_FEATURE_TYPE_RANDOM)
		nBHair = nRandHair;

	string sHair1 = GetRandomTint(nSubrace, 1, nHair1);
	string sHair2 = GetRandomTint(nSubrace, 2, nHair2);
	string sAHair = GetRandomTint(nSubrace, 3, nAHair);
	string sSkin  = GetRandomTint(nSubrace, 4, nSkin);
	string sEyes  = GetRandomTint(nSubrace, 5, nEyes);
	string sBHair = GetRandomTint(nSubrace, 6, nBHair);

#ifdef _DEBUG_ZS
	SetLocalInt(oSpawn, "ZS_APP_TYPE", nAppearance);
	SetLocalInt(oSpawn, "ZS_MODEL_HEAD", nHeadModel);
	SetLocalInt(oSpawn, "ZS_MODEL_HAIR", nHairModel);
	SetLocalString(oSpawn, "ZS_TINT_HAIR1", sHair1);
	SetLocalString(oSpawn, "ZS_TINT_HAIR2", sHair2);
	SetLocalString(oSpawn, "ZS_TINT_AHAIR", sAHair);
	SetLocalString(oSpawn, "ZS_TINT_BHAIR", sBHair);
	SetLocalString(oSpawn, "ZS_TINT_EYES", sEyes);
	SetLocalString(oSpawn, "ZS_TINT_SKIN", sSkin);
#endif
		
	float fHair1r = HexStringToFloat(GetStringLeft(sHair1, 2)) / 255.0f;
	float fHair1g = HexStringToFloat(GetStringLeft(GetStringRight(sHair1, 4), 2)) / 255.0f;
	float fHair1b = HexStringToFloat(GetStringRight(sHair1, 2)) / 255.0f;

	float fHair2r = HexStringToFloat(GetStringLeft(sHair2, 2)) / 255.0f;
	float fHair2g = HexStringToFloat(GetStringLeft(GetStringRight(sHair2, 4), 2)) / 255.0f;
	float fHair2b = HexStringToFloat(GetStringRight(sHair2, 2)) / 255.0f;	

	float fAHairr = HexStringToFloat(GetStringLeft(sAHair, 2)) / 255.0f;
	float fAHairg = HexStringToFloat(GetStringLeft(GetStringRight(sAHair, 4), 2)) / 255.0f;
	float fAHairb = HexStringToFloat(GetStringRight(sAHair, 2)) / 255.0f;

	float fSkinr  = HexStringToFloat(GetStringLeft(sSkin, 2)) / 255.0f;
	float fSking  = HexStringToFloat(GetStringLeft(GetStringRight(sSkin, 4), 2)) / 255.0f;
	float fSkinb  = HexStringToFloat(GetStringRight(sSkin, 2)) / 255.0f;

	float fEyesr  = HexStringToFloat(GetStringLeft(sEyes, 2)) / 255.0f;
	float fEyesg  = HexStringToFloat(GetStringLeft(GetStringRight(sEyes, 4), 2)) / 255.0f;
	float fEyesb  = HexStringToFloat(GetStringRight(sEyes, 2)) / 255.0f;	

	float fBHairr = HexStringToFloat(GetStringLeft(sEyes, 2)) / 255.0f;
	float fBHairg = HexStringToFloat(GetStringLeft(GetStringRight(sEyes, 4), 2)) / 255.0f;
	float fBHairb = HexStringToFloat(GetStringRight(sEyes, 2)) / 255.0f;

	// Models
	XPObjectAttributesSetHeadVariation(oSpawn, nHeadModel);
	XPObjectAttributesSetHairVariation(oSpawn, nHairModel);

	// Facial hair
	XPObjectAttributesSetFacialHairVariation(oSpawn, (ACR_RandomFloat() >= fFHair));

	// Hair tint
	XPObjectAttributesSetHairTint(oSpawn, 
		CreateXPObjectAttributes_TintSet(
			CreateXPObjectAttributes_Color(fAHairr, fAHairg, fAHairb, 1.0f),
			CreateXPObjectAttributes_Color(fHair1r, fHair1g, fHair1b, 1.0f),
			CreateXPObjectAttributes_Color(fHair2r, fHair2g, fHair2b, 1.0f)));

	// Head tint
	XPObjectAttributesSetHeadTint(oSpawn, 
		CreateXPObjectAttributes_TintSet(
			CreateXPObjectAttributes_Color(fSkinr,  fSking,  fSkinb, 1.0f),
			CreateXPObjectAttributes_Color(fEyesr,  fEyesg,  fEyesb, 1.0f),
			CreateXPObjectAttributes_Color(fBHairr, fBHairg, fBHairb, 1.0f)));

	// Body tint
	XPObjectAttributesSetBodyTint(oSpawn,
		CreateXPObjectAttributes_TintSet(
			CreateXPObjectAttributes_Color(fSkinr,  fSking,  fSkinb, 1.0f),
			CreateXPObjectAttributes_Color(fAHairr, fAHairg, fAHairb, 1.0f),
			CreateXPObjectAttributes_Color(fEyesr,  fEyesg,  fEyesb, 1.0f)));
}

void SetNextValidHeadModel(object o, int dir=1)
{
	string lst;
	int cur;

	lst = GetLocalString(o, "ACR_APP_VALID_HEADS");
	cur = GetLocalInt(o, "ACR_APP_CUR_HEAD");

	// set initial
	if (lst == "") {
		lst = GetValidHeadModels(GetSubRace(o), GetGender(o));
		SetLocalString(o, "ACR_APP_VALID_HEADS", lst);
	}

	// set initial
	if (cur == 0)
		cur = 1;

	// dir=1 forward, else reverse
	if (dir)
		cur = XPCraft_GetNextEntryInList(lst, cur);
	else
		cur = XPCraft_GetPreviousEntryInList(lst, cur);

	XPObjectAttributesSetHeadVariation(o, cur);
}

void SetNextValidHairModel(object o, int dir=1)
{
	string lst;
	int cur;

	lst = GetLocalString(o, "ACR_APP_VALID_HAIRS");
	cur = GetLocalInt(o, "ACR_APP_CUR_HAIR");

	// set initial
	if (lst == "") {
		lst = GetValidHeadModels(GetSubRace(o), GetGender(o));
		SetLocalString(o, "ACR_APP_VALID_HAIRS", lst);
	}

	// set initial
	if (cur == 0)
		cur = 1;

	// dir=1 forward, else reverse
	if (dir)
		cur = XPCraft_GetNextEntryInList(lst, cur);
	else
		cur = XPCraft_GetPreviousEntryInList(lst, cur);

	XPObjectAttributesSetHairVariation(o, cur);
}

void ApplyTintToType(object o)
{
	struct XPObjectAttributes_TintSet tints;
	float r,g,b,a;

	switch (GetLocalInt(o, "ACR_APP_TYPE")) {
		case ACR_APP_TYPE_HAIR_ACC:
		case ACR_APP_TYPE_HAIR_LO:
		case ACR_APP_TYPE_HAIR_HI:
			tints = GetHairTintSet(o);
			break;
		case ACR_APP_TYPE_HEAD_SKIN:
		case ACR_APP_TYPE_HEAD_EYE:
		case ACR_APP_TYPE_HEAD_HAIR:
			tints = GetSkinTintSet(o);
			break;
		case ACR_APP_TYPE_BASE_SKIN:
		case ACR_APP_TYPE_BASE_HAIR:
		case ACR_APP_TYPE_BASE_EYE:
			tints = GetBaseTintSet(o);
			break;
	}

	r = GetLocalInt(o, "ACR_APP_TINT_R") / 255.0f;
	g = GetLocalInt(o, "ACR_APP_TINT_G") / 255.0f;
	b = GetLocalInt(o, "ACR_APP_TINT_B") / 255.0f;
	a = GetLocalInt(o, "ACR_APP_TINT_A") / 255.0f;


	switch (GetLocalInt(o, "ACR_APP_TYPE")) {
		case ACR_APP_TYPE_HAIR_ACC:
		case ACR_APP_TYPE_HEAD_SKIN:
		case ACR_APP_TYPE_BASE_SKIN:
			tints.Tint0 = CreateXPObjectAttributes_Color(r,g,b,a);
			break;
		case ACR_APP_TYPE_HAIR_LO:
		case ACR_APP_TYPE_HEAD_EYE:
		case ACR_APP_TYPE_BASE_HAIR:
			tints.Tint1 = CreateXPObjectAttributes_Color(r,g,b,a);
			break;
		case ACR_APP_TYPE_HAIR_HI:
		case ACR_APP_TYPE_HEAD_HAIR:
		case ACR_APP_TYPE_BASE_EYE:
			tints.Tint2 = CreateXPObjectAttributes_Color(r,g,b,a);
			break;
	}

	XPObjectAttributesSetBodyTint(o, tints);
}



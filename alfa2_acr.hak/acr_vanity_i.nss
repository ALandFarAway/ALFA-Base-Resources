#include "nwnx_objectattributes_include"
#include "acr_pps_i"

// This function applies a hair dye oDye to the subject oTarget, using the skill
// of oBeautician. It assumes that permission is given to oTarget, but contains
// the functionality to handle all other aspects of the effect.
void DoHairDye(object oDye, object oBeautician, object oTarget, int nRoll = FALSE);

string GetRawHairTintSet(object oCharacter);

string GetRawBaseTintSet(object oCharacter);

string GetRawSkinTintSet(object oCharacter);

string RawHairToHairHighlight(string sRawHair);

string RawHairToHairLowlight(string sRawHair);

string RawHairToHairAccessory(string sRawHair);

string RawSkinToSkin(string sRawBody);

string RawSkinToEyes(string sRawBody);

string RawSkinToBodyHair(string sRawBody);

string RawTintToTint1(string sRawTint);

string RawTintToTint2(string sRawTint);

string RawTintToTint3(string sRawTint);

int HexStringToInt(string sString);

void DoHairDye(object oDye, object oBeautician, object oTarget, int nRoll = FALSE)
{
//=== The dye's tag contains the dye's 'true' color. ===//
	string sDye = GetStringRight(GetTag(oDye), 6);
	
//=== This information lives inside of the character object-- we need NWNx4 to harvest it ===//
	string sHair = GetRawHairTintSet(oTarget);
	string sHairHighlight = RawHairToHairHighlight(sHair);
	string sHairLowlight  = RawHairToHairLowlight(sHair);
	string sHairAccessory = RawHairToHairAccessory(sHair);

//=== Need to convert the input (hex strings) into something we can do math on (integers) ===//
	int nHLRed    = HexStringToInt(GetStringLeft(sHairHighlight, 2));
	int nHLGreen  = HexStringToInt(GetStringLeft(GetStringRight(sHairHighlight, 4), 2));
	int nHLBlue   = HexStringToInt(GetStringRight(sHairHighlight, 2));
	int nLLRed    = HexStringToInt(GetStringLeft(sHairLowlight, 2));
	int nLLGreen  = HexStringToInt(GetStringLeft(GetStringRight(sHairLowlight, 4), 2));
	int nLLBlue   = HexStringToInt(GetStringRight(sHairLowlight, 2));	
	int nAccRed   = HexStringToInt(GetStringLeft(sHairAccessory, 2));
	int nAccGreen = HexStringToInt(GetStringLeft(GetStringRight(sHairAccessory, 4), 2));
	int nAccBlue  = HexStringToInt(GetStringRight(sHairAccessory, 2));		
	int nDyeRed   = HexStringToInt(GetStringLeft(sDye, 2));
	int nDyeGreen = HexStringToInt(GetStringLeft(GetStringRight(sDye, 4), 2));
	int nDyeBlue  = HexStringToInt(GetStringRight(sDye, 2));
	
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

string RawHairToHairAccessory(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 15), 6);
}

string RawHairToHairLowlight(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 27), 6);
}

string RawHairToHairHighlight(string sRawHair)
{
	return GetStringLeft(GetStringRight(sRawHair, GetStringLength(sRawHair) - 39), 6);
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

int HexStringToInt(string sString)
{
	int nResult = 0;
	int nMultiplier = 1;
	while(sString != "")
	{
		string sDigit = GetStringRight(sString, 1);
		if(GetStringLength(sString) == 1)
			sString = "";
		else
			sString = GetStringLeft(sString, GetStringLength(sString) - 1);
		if(sDigit == "F" || sDigit == "f")      nResult += nMultiplier * 15;
		else if(sDigit == "E" || sDigit == "e") nResult += nMultiplier * 14;
		else if(sDigit == "D" || sDigit == "d") nResult += nMultiplier * 13;
		else if(sDigit == "C" || sDigit == "c") nResult += nMultiplier * 12;
		else if(sDigit == "B" || sDigit == "b") nResult += nMultiplier * 11;
		else if(sDigit == "A" || sDigit == "a") nResult += nMultiplier * 10;
		else                   nResult += nMultiplier * StringToInt(sDigit);
		nMultiplier = nMultiplier * 16;
	}
	return nResult;	
}
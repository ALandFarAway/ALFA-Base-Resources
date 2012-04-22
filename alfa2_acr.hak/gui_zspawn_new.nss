#include "acr_db_persist_i"

string IntToDataString(int nInt);

void main(int nLevel, string sGender, string sAlignment, string sBarbarian, string sBard, string sCleric, string sDruid, string sFavoredSoul, string sFighter, string sMonk, string sPaladin, string sRanger, string sRogue, string sSorcerer, string sShaman, string sSwashbuckler, string sWarlock, string sWizard, string sWarrior, string sCommoner, string sUndead, string sName, string sDescription, string sRace, string sHair1, string sHair2, string sHair3, string sSkin, string sEyes, string sBHair, string sHead, string sHair)
{
	if(!GetIsDM(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF))	
	{
			SendMessageToPC(OBJECT_SELF, "No soup for you!");
			return;
	}
	string sTag = IntToDataString(nLevel);
	sTag = sTag + sGender;
	sTag = sTag + sAlignment;
	
	if(sBarbarian == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sBard == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sCleric == "true")		
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sDruid == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sFavoredSoul == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sFighter == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sMonk == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sPaladin == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sRanger == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sRogue == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sSorcerer == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sShaman == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sSwashbuckler == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sWarlock == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sWizard == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sWarrior == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sCommoner == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
	if(sUndead == "true")
		sTag = sTag + "1";
	else
		sTag = sTag + "0";
		
	if(GetStringLength(sRace) == 1)      sRace = "00"+sRace;
	else if(GetStringLength(sRace) == 2) sRace = "0"+sRace;
	sTag = sTag + sRace;

	if(sHair1 == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToDataString(StringToInt(sHair1)-1);
	if(sHair2 == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToDataString(StringToInt(sHair2)-1);
	if(sHair3 == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToDataString(StringToInt(sHair3)-1);
	if(sSkin == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToDataString(StringToInt(sSkin)-1);
	if(sEyes == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToDataString(StringToInt(sEyes)-1);	
	if(sBHair == "")
		sTag = sTag + "Z";
	else
		sTag = sTag + IntToString(StringToInt(sBHair)-1);
		
	if(sHead == "" || sHead == "999")
		sTag = sTag + "999";
	else
	{
		if(GetStringLength(sHead) == 1)      sHead = "00"+sHead;
		else if(GetStringLength(sHead) == 2) sHead = "0"+sHead;
		sTag = sTag + sHead;
	}
	if(sHair == "" || sHair == "999")
		sTag = sTag + "999";
	else
	{
		if(GetStringLength(sHair) == 1)      sHair = "00"+sHair;
		else if(GetStringLength(sHair) == 2) sHair = "0"+sHair;
		sTag = sTag + sHair;
	}
	
	if(GetStringLength(sTag) > 64)
		SendMessageToAllDMs("**Error: overflow of NPC data. NPC did not save correctly.**");
	
	object oData = CreateItemOnObject("acr_zspawn_data", OBJECT_SELF, 1, sTag);
	SetFirstName(oData, sName);
	SetDescription(oData, sDescription);
	ACR_IncrementStatistic("ZSPAWN_NEW");
}

string IntToDataString(int nInt)
{
	if(nInt < 10)       return IntToString(nInt);
	else if(nInt == 10) return "A";
	else if(nInt == 11) return "B";
	else if(nInt == 12) return "C";
	else if(nInt == 13) return "D";
	else if(nInt == 14) return "E";
	else if(nInt == 15) return "F";
	else if(nInt == 16) return "G";
	else if(nInt == 17) return "H";
	else if(nInt == 18) return "I";
	else if(nInt == 19) return "J";
	else if(nInt == 20) return "K";
	else if(nInt == 21) return "L";
	else if(nInt == 22) return "M";
	else if(nInt == 23) return "N";
	else if(nInt == 24) return "O";
	else if(nInt == 25) return "P";
	else if(nInt == 26) return "Q";
	else if(nInt == 27) return "R";
	else if(nInt == 28) return "S";
	else if(nInt == 29) return "T";
	else if(nInt == 30) return "U";
	return "1";
}

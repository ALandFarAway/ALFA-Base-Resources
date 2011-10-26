#include "acr_zspawn_i"


float HexStringToFloat(string sString);
int DataStringToInt(string sString);

void main()
{
	if(!GetIsDM(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF))	
	{
		SendMessageToPC(OBJECT_SELF, "No soup for you!");
		DestroyObject(GetSpellCastItem());
		return;
	}
	object oData = GetSpellCastItem();
	string sTag = GetTag(oData);
	int nLevel = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nVarGender = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nAlignment = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	
	int nBrb = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nBrd = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nClr = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nDrd = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nFvs = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nFtr = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nMnk = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nPal = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nRgr = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nRog = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nSor = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nSha = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nSws = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nWar = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nWiz = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nWrr = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nCom = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nUnd = StringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nRace = StringToInt(GetStringLeft(sTag, 3));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 3);
	int nHair1 = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nHair2 = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nHair3 = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nSkin  = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nEyes  = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nBHair = DataStringToInt(GetStringLeft(sTag, 1));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nHead  = StringToInt(GetStringLeft(sTag, 3));
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 3);
	int nHair  = StringToInt(GetStringLeft(sTag, 3));

	
	string sName = GetFirstName(oData);
	string sDesc = GetDescription(oData);
	int nClass = -1;
	int nRandom = (nBrb + nBrd + nClr + nDrd + nFvs + nFtr +nMnk + nPal + nRgr + nRog + nSor + nSha + nSws + nWar + nWiz + nWrr + nCom + nUnd);
	if(nRandom == 0)
	{
		nBrb = 1;
		nBrd = 1;
		nClr = 1;
		nDrd = 1;
		nFvs = 1;
		nFtr = 1;
		nMnk = 1;
		nPal = 1;
		nRgr = 1;
		nRog = 1;
		nSor = 1;
		nSha = 1;
		nSws = 1;
		nWar = 1;
		nWiz = 1;
		nWrr = 1;
		nCom = 1;
		nUnd = 1;
		nRandom = 18;
	}
	int nSpawns = d4(2);
	while(nSpawns > 0)
	{
		int nGender;
		if(nVarGender == 2)
		{
			if(d2() == 1)
				nGender = GENDER_MALE;
			else
				nGender = GENDER_FEMALE;
		}	
		else if(nVarGender == 1)	nGender = GENDER_MALE;
		else						nGender = GENDER_FEMALE;
		
		if(nRace == 8)
			nRace = Random(7) + 1;
			
		int nSelection = Random(nRandom) + 1;
		if(nBrb)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_BARBARIAN;	
		}
		if(nBrd)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_BARD;	
		}
		if(nClr)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_CLERIC;	
		}
		if(nDrd)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_DRUID;	
		}
		if(nFvs)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_FAVORED_SOUL;	
		}
		if(nFtr)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_FIGHTER;	
		}
		if(nMnk)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_MONK;	
		}
		if(nPal)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_PALADIN;	
		}
		if(nRgr)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_RANGER;	
		}
		if(nRog)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_ROGUE;	
		}
		if(nSor)
		{
			nSelection--;
			if(nSelection == 0)
				nClass == CLASS_TYPE_SORCERER;
		}
		if(nSha)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_SPIRIT_SHAMAN;	
		}
		if(nSws)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_SWASHBUCKLER;	
		}
		if(nWar)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_WARLOCK;	
		}
		if(nWiz)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_WIZARD;	
		}
		if(nWrr)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_HUMANOID;	
		}
		if(nCom)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_COMMONER;	
		}
		if(nUnd)
		{
			nSelection--;
			if(nSelection == 0)
				nClass = CLASS_TYPE_UNDEAD;	
		}
		
		
		if(nClass == CLASS_TYPE_BARD ||
		   nClass == CLASS_TYPE_BARBARIAN) // Barbarians and bards can't be lawful
		{
			if(nAlignment == 1 ||
			   nAlignment == 4 ||
			   nAlignment == 7)
				nAlignment++;
		}
		if(nClass == CLASS_TYPE_MONK) // Monks must be lawful
		{
			if(nAlignment == 2 ||
			   nAlignment == 5 ||
			   nAlignment == 7)
			    nAlignment--;
			else if(nAlignment == 3 ||
				    nAlignment == 6 ||
					nAlignment == 9)
				nAlignment -= 2;
		}
		if(nClass == CLASS_TYPE_PALADIN) // Paladins must be lawful good
		{
			nAlignment = 1;
		}
		if(nClass == CLASS_TYPE_WARLOCK) // Warlocks must be chaotic or evil
		{
			if(nAlignment == 1) nAlignment = 3; // LG -> CG
			if(nAlignment == 2) nAlignment = 3; // NG -> CG
			if(nAlignment == 4) nAlignment = 7; // LN -> LE
			if(nAlignment == 5) nAlignment = 6; // TN -> CN
		}
		if(nClass == CLASS_TYPE_UNDEAD) // Undead must be evil
		{
			if(nAlignment == 1 ||
			   nAlignment == 4)
			   	nAlignment = 7;
			if(nAlignment == 2 ||
			   nAlignment == 5)
			    nAlignment = 8;
			if(nAlignment == 3 ||
			   nAlignment == 6)
			   	nAlignment == 9;
		}
		if(nClass == CLASS_TYPE_DRUID) // Druids cannot have an extreme alignment
		{
			if(nAlignment == 1) nAlignment = 2; // LG -> NG
			if(nAlignment == 3) nAlignment = 2; // CG -> NG
			if(nAlignment == 7) nAlignment = 8; // LE -> NE
			if(nAlignment == 9) nAlignment = 8; // CE -> NE
		}		
		
		object oSpawn;
		int nSpawnLevel = nLevel;
		if(nRace == 11) // Bugbears have natural levels
		{	
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_HUMANOID, nGender, GetLocation(OBJECT_SELF));
			LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
			LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
			nSpawnLevel = nSpawnLevel - 2;
			float fCR = IntToFloat(nSpawnLevel);
			SetLocalFloat(oSpawn, "CR", fCR);
		}
		else if(nRace == 13 || nRace == 14) // Gnolls and lizardfolk do, too
		{	
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_HUMANOID, nGender, GetLocation(OBJECT_SELF));
			LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
			nSpawnLevel = nSpawnLevel - 1;
			float fCR = IntToFloat(nSpawnLevel);
			SetLocalFloat(oSpawn, "CR", fCR);
		}
		else if(nRace == 15) // Skeletons are level 1. Always always.
		{
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));	
			SetLocalFloat(oSpawn, "CR", 0.33);
			nSpawnLevel = 0;
		}
		else if(nRace == 16) // Zombies are level 2. Always always.
		{
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));	
			LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
			SetLocalFloat(oSpawn, "CR", 0.5);		
			nSpawnLevel = 0;
		}	
		else if(nRace == 17) // Ghouls cap at leve 3. They're ghasts otherwise.
		{
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));
			LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
			if(nSpawnLevel >= 3) LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
			float fCR = IntToFloat(nSpawnLevel-1);
			if(fCR > 2.0) fCR = 2.0;
			SetLocalFloat(oSpawn, "CR", fCR);
			nSpawnLevel = 0;
		}
		else if(nRace == 18) // Shadows run from levels 3 to 9.
		{
			oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));
			nClass = CLASS_TYPE_UNDEAD;
			if(nSpawnLevel > 9) nSpawnLevel = 9;
			if(nSpawnLevel < 3) nSpawnLevel = 3;
			float fCR = IntToFloat(nSpawnLevel);
			if(fCR > 8.0) fCR = 8.0;
			SetLocalFloat(oSpawn, "CR", fCR);
		}
		else
		{
			oSpawn = CreateCreatureOfClass(nClass, nGender, GetLocation(OBJECT_SELF));
			float fCR = IntToFloat(nSpawnLevel);
			SetLocalFloat(oSpawn, "CR", fCR);
		}
			
		nSpawnLevel--;
		while(nSpawnLevel > 0)
		{
			LevelUpHenchman(oSpawn, nClass, TRUE, GetPackageForClass(nClass));
			nSpawnLevel--;
		}
		if(sName != "") SetFirstName(oSpawn, sName);
		else            SetFirstName(oSpawn, " ");
		if(sDesc != "") SetDescription(oSpawn, sDesc);
		else            SetDescription(oSpawn, " ");
		int nHeadModel;
		int nHairModel;
		if(nHead != 999 && nHead != 0)
			nHeadModel = nHead;
		else
			nHeadModel = GetRandomHeadModel(nRace, nGender);	
		if(nHair != 999)
			nHairModel = nHair;
		else
			nHairModel = GetRandomHairModel(nRace, nGender);
		int nRandHair = Random(18);
		if(nHair1 == 999) nHair1 = nRandHair;
		if(nHair2 == 999) nHair2 = nRandHair;
		if(nBHair == 999) nBHair = nRandHair;		
		string sHair1 = GetRandomTint(nRace, 1, nHair1);
		string sHair2 = GetRandomTint(nRace, 2, nHair2);
		string sHair3 = GetRandomTint(nRace, 3, nHair3);
		string sSkin  = GetRandomTint(nRace, 4, nSkin);
		string sEyes  = GetRandomTint(nRace, 5, nEyes);
		string sBHair = GetRandomTint(nRace, 6, nBHair);
		float fHair1r = HexStringToFloat(GetStringLeft(sHair1, 2)) / 255.0f;
		float fHair1g = HexStringToFloat(GetStringLeft(GetStringRight(sHair1, 4), 2)) / 255.0f;
		float fHair1b = HexStringToFloat(GetStringRight(sHair1, 2)) / 255.0f;
		float fHair2r = HexStringToFloat(GetStringLeft(sHair2, 2)) / 255.0f;
		float fHair2g = HexStringToFloat(GetStringLeft(GetStringRight(sHair2, 4), 2)) / 255.0f;
		float fHair2b = HexStringToFloat(GetStringRight(sHair2, 2)) / 255.0f;	
		float fHair3r = HexStringToFloat(GetStringLeft(sHair3, 2)) / 255.0f;
		float fHair3g = HexStringToFloat(GetStringLeft(GetStringRight(sHair3, 4), 2)) / 255.0f;
		float fHair3b = HexStringToFloat(GetStringRight(sHair3, 2)) / 255.0f;
		float fSkinr  = HexStringToFloat(GetStringLeft(sSkin, 2)) / 255.0f;
		float fSking  = HexStringToFloat(GetStringLeft(GetStringRight(sSkin, 4), 2)) / 255.0f;
		float fSkinb  = HexStringToFloat(GetStringRight(sSkin, 2)) /255.0f;
		float fEyesr  = HexStringToFloat(GetStringLeft(sEyes, 2)) / 255.0f;
		float fEyesg  = HexStringToFloat(GetStringLeft(GetStringRight(sEyes, 4), 2)) / 255.0f;
		float fEyesb  = HexStringToFloat(GetStringRight(sEyes, 2)) / 255.0f;	
		float fBHairr = HexStringToFloat(GetStringLeft(sEyes, 2)) / 255.0f;
		float fBHairg = HexStringToFloat(GetStringLeft(GetStringRight(sEyes, 4), 2)) / 255.0f;
		float fBHairb = HexStringToFloat(GetStringRight(sEyes, 2)) / 255.0f;
		XPObjectAttributesSetHeadVariation(oSpawn, nHeadModel);
		XPObjectAttributesSetHairVariation(oSpawn, nHairModel);
		if(d2() == 1)	
			XPObjectAttributesSetFacialHairVariation(oSpawn, TRUE);
		else
			XPObjectAttributesSetFacialHairVariation(oSpawn, FALSE);
		XPObjectAttributesSetHairTint(oSpawn, 
			CreateXPObjectAttributes_TintSet(
				CreateXPObjectAttributes_Color(fHair3r, fHair3g, fHair3b, 1.0f),
				CreateXPObjectAttributes_Color(fHair1r, fHair1g, fHair1b, 1.0f),
				CreateXPObjectAttributes_Color(fHair2r, fHair2g, fHair2b, 1.0f)));
		XPObjectAttributesSetHeadTint(oSpawn, 
			CreateXPObjectAttributes_TintSet(
				CreateXPObjectAttributes_Color(fSkinr,  fSking,  fSkinb, 1.0f),
				CreateXPObjectAttributes_Color(fEyesr,  fEyesg,  fEyesb, 1.0f),
				CreateXPObjectAttributes_Color(fBHairr, fBHairg, fBHairb, 1.0f)));
			int nGear = SetRace(oSpawn, nRace);
		EquipCreature(oSpawn, nGear);
		SetAlignment(oSpawn, nAlignment);
		ForceRest(oSpawn);
		nSpawns--;
	}
}

float HexStringToFloat(string sString)
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
		if(sDigit == "F")      nResult += nMultiplier * 15;
		else if(sDigit == "E") nResult += nMultiplier * 14;
		else if(sDigit == "D") nResult += nMultiplier * 13;
		else if(sDigit == "C") nResult += nMultiplier * 12;
		else if(sDigit == "B") nResult += nMultiplier * 11;
		else if(sDigit == "A") nResult += nMultiplier * 10;
		else                   nResult += nMultiplier * StringToInt(sDigit);
		nMultiplier = nMultiplier * 16;
	}
	return IntToFloat(nResult);
}

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
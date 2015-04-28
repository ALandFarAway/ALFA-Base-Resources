#include "acr_1984_i"
#include "acr_zspawn_i"
#include "acr_resting_i"

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
	ACR_LogDMSpawn(OBJECT_SELF, "Spawned 2d4 "+IntToString(nLevel)+" HD non-hostile creatures with tag: "+sTag);
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
        if(GetStringLeft(sTag, 1) == "Z") nHair1 = -1;
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nHair2 = DataStringToInt(GetStringLeft(sTag, 1));
        if(GetStringLeft(sTag, 1) == "Z") nHair2 = -1;
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nHair3 = DataStringToInt(GetStringLeft(sTag, 1));
        if(GetStringLeft(sTag, 1) == "Z") nHair3 = -1;
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nSkin  = DataStringToInt(GetStringLeft(sTag, 1));
        if(GetStringLeft(sTag, 1) == "Z") nSkin = -1;
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nEyes  = DataStringToInt(GetStringLeft(sTag, 1));
        if(GetStringLeft(sTag, 1) == "Z") nEyes = -1;
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nBHair = DataStringToInt(GetStringLeft(sTag, 1));
        if(GetStringLeft(sTag, 1) == "Z") nBHair = -1;
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
	
		int nGear = SetRace(oSpawn, nRace);
		SetGender(oSpawn,nGender);

		
		if(nRace < 9) ACR_RandomizeAppearance(oSpawn,nHead,nHair,nHair1,nHair2,nHair3,nBHair,nSkin,nEyes);

		EquipCreature(oSpawn, nGear, oData);
		SetAlignment(oSpawn, nAlignment);
		ACR_ForceRest(oSpawn);
		ChangeToStandardFaction( oSpawn, STANDARD_FACTION_COMMONER );
		nSpawns--;
	}

	ACR_IncrementStatistic("ZSPAWN_SPAWN");
}

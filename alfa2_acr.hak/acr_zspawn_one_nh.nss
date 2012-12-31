#include "acr_db_persist_i"
#include "acr_zspawn_i"

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
	string sLevel = GetStringLeft(sTag, 1);
	int nLevel = DataStringToInt(sLevel);
	sTag = GetStringRight(sTag, GetStringLength(sTag) - 1);
	int nGender = StringToInt(GetStringLeft(sTag, 1));
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

	if(nRace == 8)
		nRace = Random(7) + 1;
	
	string sName = GetName(oData);
	string sDesc = GetDescription(oData);
	
	int nClass = -1;
	if(nRog)      nClass = CLASS_TYPE_ROGUE;
	else if(nRgr) nClass = CLASS_TYPE_RANGER;
	else if(nBrd) nClass = CLASS_TYPE_BARD;
	else if(nBrb) nClass = CLASS_TYPE_BARBARIAN;
	else if(nMnk) nClass = CLASS_TYPE_MONK;
	else if(nSws) nClass = CLASS_TYPE_SWASHBUCKLER;
	else if(nFtr) nClass = CLASS_TYPE_FIGHTER;
	else if(nPal) nClass = CLASS_TYPE_PALADIN;
	else if(nClr) nClass = CLASS_TYPE_CLERIC;
	else if(nDrd) nClass = CLASS_TYPE_DRUID;
	else if(nFvs) nClass = CLASS_TYPE_FAVORED_SOUL;
	else if(nSor) nClass = CLASS_TYPE_SORCERER;
	else if(nSha) nClass = CLASS_TYPE_SPIRIT_SHAMAN;
	else if(nWiz) nClass = CLASS_TYPE_WIZARD;
	else if(nWar) nClass = CLASS_TYPE_WARLOCK;
	else if(nUnd) nClass = CLASS_TYPE_UNDEAD;
	else if(nWrr) nClass = CLASS_TYPE_HUMANOID;
	else if(nCom) nClass = CLASS_TYPE_COMMONER;

	if(nClass == -1)
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
		int nRandom = 18;
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
		nBrb = 0;
		nBrd = 0;
		nClr = 0;
		nDrd = 0;
		nFvs = 0;
		nFtr = 0;
		nMnk = 0;
		nPal = 0;
		nRgr = 0;
		nRog = 0;
		nSor = 0;
		nSha = 0;
		nSws = 0;
		nWar = 0;
		nWiz = 0;
		nWrr = 0;
		nCom = 0;
		nUnd = 0;		
	}

	if(nGender == 2)
	{
		if(d2() == 1)
			nGender = GENDER_MALE;
		else
			nGender = GENDER_FEMALE;
	}	
	else if(nGender == 1)	nGender = GENDER_MALE;
	else					nGender = GENDER_FEMALE;

	object oSpawn;

	int nSecClass = -1;
	int nTerClass = -1;
	
	if(nRgr      && nClass != CLASS_TYPE_RANGER)        nSecClass = CLASS_TYPE_RANGER;
	else if(nBrd && nClass != CLASS_TYPE_BARD)          nSecClass = CLASS_TYPE_BARD;
	else if(nBrb && nClass != CLASS_TYPE_BARBARIAN)     nSecClass = CLASS_TYPE_BARBARIAN;
	else if(nMnk && nClass != CLASS_TYPE_MONK)          nSecClass = CLASS_TYPE_MONK;
	else if(nSws && nClass != CLASS_TYPE_SWASHBUCKLER)  nSecClass = CLASS_TYPE_SWASHBUCKLER;
	else if(nFtr && nClass != CLASS_TYPE_FIGHTER)       nSecClass = CLASS_TYPE_FIGHTER;
	else if(nPal && nClass != CLASS_TYPE_PALADIN)       nSecClass = CLASS_TYPE_PALADIN;
	else if(nClr && nClass != CLASS_TYPE_CLERIC)        nSecClass = CLASS_TYPE_CLERIC;
	else if(nDrd && nClass != CLASS_TYPE_DRUID)         nSecClass = CLASS_TYPE_DRUID;
	else if(nFvs && nClass != CLASS_TYPE_FAVORED_SOUL)  nSecClass = CLASS_TYPE_FAVORED_SOUL;
	else if(nSor && nClass != CLASS_TYPE_SORCERER)      nSecClass = CLASS_TYPE_SORCERER;
	else if(nSha && nClass != CLASS_TYPE_SPIRIT_SHAMAN) nSecClass = CLASS_TYPE_SPIRIT_SHAMAN;
	else if(nWiz && nClass != CLASS_TYPE_WIZARD)        nSecClass = CLASS_TYPE_WIZARD;
	else if(nWar && nClass != CLASS_TYPE_WARLOCK)       nSecClass = CLASS_TYPE_WARLOCK;
	else if(nUnd && nClass != CLASS_TYPE_UNDEAD)        nSecClass = CLASS_TYPE_UNDEAD;
	else if(nWrr && nClass != CLASS_TYPE_HUMANOID)      nSecClass = CLASS_TYPE_HUMANOID;
	else if(nCom && nClass != CLASS_TYPE_COMMONER)      nSecClass = CLASS_TYPE_COMMONER;
	
	if(nBrd      && nClass != CLASS_TYPE_BARD          && nSecClass != CLASS_TYPE_BARD)          nTerClass = CLASS_TYPE_BARD;
	else if(nBrb && nClass != CLASS_TYPE_BARBARIAN     && nSecClass != CLASS_TYPE_BARBARIAN)     nTerClass = CLASS_TYPE_BARBARIAN;
	else if(nMnk && nClass != CLASS_TYPE_MONK          && nSecClass != CLASS_TYPE_MONK)          nTerClass = CLASS_TYPE_MONK;
	else if(nSws && nClass != CLASS_TYPE_SWASHBUCKLER  && nSecClass != CLASS_TYPE_SWASHBUCKLER)  nTerClass = CLASS_TYPE_SWASHBUCKLER;
	else if(nFtr && nClass != CLASS_TYPE_FIGHTER       && nSecClass != CLASS_TYPE_FIGHTER)       nTerClass = CLASS_TYPE_FIGHTER;
	else if(nPal && nClass != CLASS_TYPE_PALADIN       && nSecClass != CLASS_TYPE_PALADIN)       nTerClass = CLASS_TYPE_PALADIN;
	else if(nClr && nClass != CLASS_TYPE_CLERIC        && nSecClass != CLASS_TYPE_CLERIC)        nTerClass = CLASS_TYPE_CLERIC;
	else if(nDrd && nClass != CLASS_TYPE_DRUID         && nSecClass != CLASS_TYPE_DRUID)         nTerClass = CLASS_TYPE_DRUID;
	else if(nFvs && nClass != CLASS_TYPE_FAVORED_SOUL  && nSecClass != CLASS_TYPE_FAVORED_SOUL)  nTerClass = CLASS_TYPE_FAVORED_SOUL;
	else if(nSor && nClass != CLASS_TYPE_SORCERER      && nSecClass != CLASS_TYPE_SORCERER)      nTerClass = CLASS_TYPE_SORCERER;
	else if(nSha && nClass != CLASS_TYPE_SPIRIT_SHAMAN && nSecClass != CLASS_TYPE_SPIRIT_SHAMAN) nTerClass = CLASS_TYPE_SPIRIT_SHAMAN;
	else if(nWiz && nClass != CLASS_TYPE_WIZARD        && nSecClass != CLASS_TYPE_WIZARD)        nTerClass = CLASS_TYPE_WIZARD;
	else if(nWar && nClass != CLASS_TYPE_WARLOCK       && nSecClass != CLASS_TYPE_WARLOCK)       nTerClass = CLASS_TYPE_WARLOCK;
	else if(nUnd && nClass != CLASS_TYPE_UNDEAD        && nSecClass != CLASS_TYPE_UNDEAD)        nTerClass = CLASS_TYPE_UNDEAD;
	else if(nWrr && nClass != CLASS_TYPE_HUMANOID      && nSecClass != CLASS_TYPE_HUMANOID)      nTerClass = CLASS_TYPE_HUMANOID;
	else if(nCom && nClass != CLASS_TYPE_COMMONER      && nSecClass != CLASS_TYPE_COMMONER)      nTerClass = CLASS_TYPE_COMMONER;

	if(nClass == CLASS_TYPE_BARD ||
	   nSecClass == CLASS_TYPE_BARD ||
	   nTerClass == CLASS_TYPE_BARD ||
	   nClass == CLASS_TYPE_BARBARIAN ||
	   nSecClass == CLASS_TYPE_BARBARIAN ||
	   nTerClass == CLASS_TYPE_BARBARIAN) // Barbarians and bards can't be lawful
	{
		if(nAlignment == 1 ||
		   nAlignment == 4 ||
		   nAlignment == 7)
			nAlignment++;
	}
	if(nClass == CLASS_TYPE_MONK ||
	   nSecClass == CLASS_TYPE_MONK ||
	   nTerClass == CLASS_TYPE_MONK) // Monks must be lawful
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
	if(nClass == CLASS_TYPE_PALADIN ||
	   nSecClass == CLASS_TYPE_PALADIN ||
	   nTerClass == CLASS_TYPE_PALADIN) // Paladins must be lawful good
	{
		nAlignment = 1;
	}
	if(nClass == CLASS_TYPE_WARLOCK ||
	   nSecClass == CLASS_TYPE_WARLOCK ||
	   nTerClass == CLASS_TYPE_WARLOCK) // Warlocks must be chaotic or evil
	{
		if(nAlignment == 1) nAlignment = 3; // LG -> CG
		if(nAlignment == 2) nAlignment = 3; // NG -> CG
		if(nAlignment == 4) nAlignment = 7; // LN -> LE
		if(nAlignment == 5) nAlignment = 6; // TN -> CN
	}
	if(nClass == CLASS_TYPE_UNDEAD ||
	   nSecClass == CLASS_TYPE_UNDEAD ||
	   nTerClass == CLASS_TYPE_UNDEAD) // Undead must be evil
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
	if(nClass == CLASS_TYPE_DRUID ||
	   nSecClass == CLASS_TYPE_DRUID ||
	   nTerClass == CLASS_TYPE_DRUID) // Druids cannot have an extreme alignment
	{
		if(nAlignment == 1) nAlignment = 2; // LG -> NG
		if(nAlignment == 3) nAlignment = 2; // CG -> NG
		if(nAlignment == 7) nAlignment = 8; // LE -> NE
		if(nAlignment == 9) nAlignment = 8; // CE -> NE
	}
	
	
	if(nRace == 11) // Bugbears have natural levels
	{	
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_HUMANOID, nGender, GetLocation(OBJECT_SELF));
		LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
		LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
		if(nTerClass >= 0) nTerClass = -1; // Unfortunate for bugbears, they lose a class slot for this
		nLevel = nLevel - 2;
		float fCR = IntToFloat(nLevel);
		SetLocalFloat(oSpawn, "CR", fCR);
	}
	else if(nRace == 13 || nRace == 14) // Gnolls and lizardfolk do, too
	{	
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_HUMANOID, nGender, GetLocation(OBJECT_SELF));
		LevelUpHenchman(oSpawn, CLASS_TYPE_HUMANOID, TRUE, GetPackageForClass(CLASS_TYPE_HUMANOID));
		if(nTerClass >= 0) nTerClass = -1; // Unfortunate for gnolls and lizardfolk, they lose a class slot for this
		nLevel = nLevel - 1;
		float fCR = IntToFloat(nLevel);
		SetLocalFloat(oSpawn, "CR", fCR);
	}
	else if(nRace == 15) // Skeletons are level 1. Always always.
	{
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));	
		SetLocalFloat(oSpawn, "CR", 0.33);
		nLevel = 0;
	}
	else if(nRace == 16) // Zombies are level 2. Always always.
	{
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));	
		LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
		SetLocalFloat(oSpawn, "CR", 0.5);		
		nLevel = 0;
	}	
	else if(nRace == 17) // Ghouls cap at leve 3. They're ghasts otherwise.
	{
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));
		LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
		if(nLevel >= 3) LevelUpHenchman(oSpawn, CLASS_TYPE_UNDEAD, TRUE, GetPackageForClass(CLASS_TYPE_UNDEAD));
		float fCR = IntToFloat(nLevel-1);
		if(fCR > 2.0) fCR = 2.0;
		SetLocalFloat(oSpawn, "CR", fCR);
		nLevel = 0;
	}
	else if(nRace == 18) // Shadows run from levels 3 to 9.
	{
		oSpawn = CreateCreatureOfClass(CLASS_TYPE_UNDEAD, nGender, GetLocation(OBJECT_SELF));
		nClass = CLASS_TYPE_UNDEAD;
		nSecClass = -1;
		nTerClass = -1;
		if(nLevel > 9) nLevel = 9;
		if(nLevel < 3) nLevel = 3;
		float fCR = IntToFloat(nLevel);
		if(fCR > 8.0) fCR = 8.0;
		SetLocalFloat(oSpawn, "CR", fCR);
	}
	else
	{
		oSpawn = CreateCreatureOfClass(nClass, nGender, GetLocation(OBJECT_SELF));
		float fCR = IntToFloat(nLevel);
		SetLocalFloat(oSpawn, "CR", fCR);
	}		
		
	nLevel--;	
//=== For single-classed NPCs ===//	
	if(nSecClass == -1)
	{
		while(nLevel > 0)
		{
			LevelUpHenchman(oSpawn, nClass, TRUE, GetPackageForClass(nClass));
			nLevel--;
		}
	}
	else if(nTerClass == -1)
	{
		while(nLevel > 0)
		{
			int nPriLevel = GetLevelByClass(nClass, oSpawn);
			int nSecLevel = GetLevelByClass(nSecClass, oSpawn);	
			if(nSecLevel < nPriLevel) {
				LevelUpHenchman(oSpawn, nSecClass, TRUE, GetPackageForClass(nSecClass));}
			else {
				LevelUpHenchman(oSpawn, nClass, TRUE, GetPackageForClass(nClass));}
			nLevel--;
		}
	}
	else
	{
		while(nLevel > 0)
		{
			int nPriLevel = GetLevelByClass(nClass, oSpawn);
			int nSecLevel = GetLevelByClass(nSecClass, oSpawn);	
			int nTerLevel = GetLevelByClass(nTerClass, oSpawn);
			if(nTerLevel < nSecLevel) {
				LevelUpHenchman(oSpawn, nTerClass, TRUE, GetPackageForClass(nTerClass));}
			else if(nSecLevel < nPriLevel) {
				LevelUpHenchman(oSpawn, nSecClass, TRUE, GetPackageForClass(nSecClass));}
			else {
				LevelUpHenchman(oSpawn, nClass, TRUE, GetPackageForClass(nClass));}
			nLevel--;
		}	
	}
	
	if(sName != "") SetFirstName(oSpawn, sName);
	else            SetFirstName(oSpawn, " ");
	if(sDesc != "") SetDescription(oSpawn, sDesc);
	else            SetDescription(oSpawn, " ");

	int nGear = SetRace(oSpawn, nRace);
	SetGender(oSpawn,nGender);
	

	ACR_RandomizeAppearance(oSpawn,nHead,nHair,nHair1,nHair2,nHair3,nBHair,nSkin,nEyes);

	EquipCreature(oSpawn, nGear, oData);
	SetAlignment(oSpawn, nAlignment);
	ForceRest(oSpawn);
	ChangeToStandardFaction( oSpawn, STANDARD_FACTION_COMMONER );
	ACR_IncrementStatistic("ZSPAWN_SPAWN");
}

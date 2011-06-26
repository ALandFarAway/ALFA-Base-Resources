#include "dmfi_inc_lang"

object _GetDMFITool(object oPC) 
{

	object oTool = OBJECT_INVALID;
  	if (GetIsPossessedFamiliar(oPC))
		oTool = GetLocalObject(GetMaster(oPC), "DMFITool");
	else
		oTool = GetLocalObject(oPC, "DMFITool");

	return oTool;
}

void main()
{
	SendMessageToPC(OBJECT_SELF, "Opening language selection GUI");
	DisplayGuiScreen(OBJECT_SELF, "acr_lang", FALSE, "acr_langsel.xml");
	if(GetIsDM(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF))
	{
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ANIMAL, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ASSASSIN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ABYSSAL, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ALZHEDO, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_AQUAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_AURAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ALGARONDAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_CANT, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_CELESTIAL, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_CHESSENTAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_CHONDATHAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_CHULTAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DWARF, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DROW, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DROWSIGN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DRUIDIC, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DRACONIC, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DAMARAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DAMBRATHAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_DURPARI, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ELVEN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_GNOME, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_GOBLIN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_GIANT, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_GNOLL, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_HALFLING, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_IGNAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_HALARDRIM, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_HALRUAAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ILLUSKAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_IMASKAR, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_INFERNAL, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_LEETSPEAK, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_LANTANESE, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_LOROSS, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_MIDANI, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_MULHORANDI, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_NETHERESE, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_RASHEMI, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_SERUSAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_SHAARAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_SHOU, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_SYLVAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_TERRAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_TREANT, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_TASHALAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_TUIGAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_TURMIC, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ORC, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_NEXALAN, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_YUANTI, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_UNDERCOMMON, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_ULUIK, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_UNTHERIC, FALSE);
		SetGUIObjectHidden(OBJECT_SELF, "acr_lang", LNG_VAASAN, FALSE);
	}
//===== Must be a player; only allow known languages =====//
	else
	{
		object oTool = _GetDMFITool(OBJECT_SELF);
		int n;
		int nMax = GetLocalInt(oTool, "LanguageMAX");
		string sTest;
		for (n=0; n<nMax; n++)
		{
			sTest = GetLocalString(oTool, "Language" + IntToString(n));
			SetGUIObjectHidden(OBJECT_SELF, "acr_lang", sTest, FALSE);
		}
	}
}
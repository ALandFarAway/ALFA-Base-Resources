
#include "dmfi_inc_tool"
#include "dmfi_inc_english"

#include "acr_i"
#include "acr_language_i"

// can i understand this?

int StartingConditional(string sLang)
{
    object oPC = GetPCSpeaker();
	object oTool = DMFI_GetTool(oPC);
	
	int n;
	int nMax = GetLocalInt(oTool, "LanguageMAX");
	string sTest;
	// All languages stored in lower case strings.
	sLang = GetStringLowerCase(sLang);
	for (n=0; n<nMax; n++)
	{
		sTest = GetLocalString(oTool, "Language" + IntToString(n));
		if (sTest==sLang) return TRUE;
	}
	return FALSE;
}


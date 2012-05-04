#include "acr_db_persist_i"

void main(string sLangPick)
{
	CloseGUIScreen(OBJECT_SELF, "acr_lang");
	SendMessageToPC(OBJECT_SELF, "You will now attempt to speak "+sLangPick+" by default.");
	SetLocalString(OBJECT_SELF, "DefaultLanguage", sLangPick);
	ACR_IncrementStatistic("SET_DEFAULT_LANGUAGE");
}

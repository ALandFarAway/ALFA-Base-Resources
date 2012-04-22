#include "acr_db_persist_i"

void main()
{
	CloseGUIScreen(OBJECT_SELF, "zspawn_b");
	if(GetIsDM(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF))
	{
		DisplayGuiScreen(OBJECT_SELF, "zspawn", FALSE, "zspawn.xml");
		ACR_IncrementStatistic("ZSPAWN_OPEN");
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "No soup for you!");
	}
}

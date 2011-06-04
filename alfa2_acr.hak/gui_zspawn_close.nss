void main()
{
	CloseGUIScreen(OBJECT_SELF, "zspawn");
	if(GetIsDM(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF))
		DisplayGuiScreen(OBJECT_SELF, "zspawn_b", FALSE, "zspawn_b.xml");
	else
		SendMessageToPC(OBJECT_SELF, "No soup for you!");
}
//Starter for the board...
const string MSGBOARD_XML = "msgboard.xml";
const string SCREEN_MSGBOARD = "SCREEN_MSGBRD"; 

void main()
{
	object oPC = GetLastUsedBy();
	
    DisplayGuiScreen(oPC,SCREEN_MSGBOARD, FALSE, MSGBOARD_XML);
							
	if (!GetIsDM(oPC))
		SetGUIObjectDisabled(oPC,SCREEN_MSGBOARD,"MSGB_DELTOPIC",TRUE);
	else
		SetGUIObjectDisabled(oPC,SCREEN_MSGBOARD,"MSGB_DELTOPIC",FALSE);	
}
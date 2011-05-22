//ga_roster_gui_screen
/*
	Pulls up the character selection GUI screen fot the PC Speaker
	DisplyGuiScreen( oPlayer, sScreenName, bModal)
*/
// ChazM 12/13/05
	
void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());		
	DisplayGuiScreen( oPC, "SCRIPT_SCREEN_PARTYSELECT", TRUE );
}
	
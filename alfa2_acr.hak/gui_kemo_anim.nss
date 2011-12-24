void main(int iSwitch)
{
	object oPC = OBJECT_SELF;
	switch (iSwitch)
	{
		case 1: //Sitting
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SittingGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","StandingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","CrouchingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","KneelingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SupineGrid",1);
			} break;
		case 2: //Standing
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SittingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","StandingGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","CrouchingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","KneelingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SupineGrid",1);
			} break;
		case 3: //Crouching
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SittingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","StandingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","CrouchingGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","KneelingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SupineGrid",1);
			} break;
		case 4: //Kneeling
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SittingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","StandingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","CrouchingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","KneelingGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SupineGrid",1);
			} break;
		case 5: //Supine
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SittingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","StandingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","CrouchingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","KneelingGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SupineGrid",0);
			} break;
		case 6: //Prone
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ProneGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AllFoursGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SuspendGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MasturbateGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MiscGrid",1);
			} break;
		case 7: //All Fours
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ProneGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AllFoursGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SuspendGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MasturbateGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MiscGrid",1);
			} break;
		case 8: //Suspension
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ProneGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AllFoursGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SuspendGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MasturbateGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MiscGrid",1);
			} break;
		case 9: //Masturbation
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ProneGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AllFoursGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SuspendGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MasturbateGrid",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MiscGrid",1);
			} break;
		case 10: //Miscellaneous
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ProneGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AllFoursGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","SuspendGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MasturbateGrid",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","MiscGrid",0);
			} break;
		case 15: //dock
			{
				CloseGUIScreen(oPC,"KEMO_ANIM");
				DisplayGuiScreen(oPC,"KEMO_ANIM_MIN",FALSE,"kemo_anim_min.xml");
			} break;
		case 16: //sheet 1
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AnimButtonGrid1",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AnimButtonGrid2",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
			} break;
		case 17: //sheet 2
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AnimButtonGrid2",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","AnimButtonGrid1",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
			} break;
		case 18: //tools
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",0);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",1);
			}
		case 19: //restore
			{
				CloseGUIScreen(oPC,"KEMO_ANIM_MIN");
				DisplayGuiScreen(oPC,"KEMO_ANIM",FALSE,"kemo_anim.xml");
			} break;
		case 20: //help
			{
				SetGUIObjectHidden(oPC,"KEMO_ANIM","ToolPane",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet1Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","Sheet2Grids",1);
				SetGUIObjectHidden(oPC,"KEMO_ANIM","HelpPane",0);
			}
	}
}
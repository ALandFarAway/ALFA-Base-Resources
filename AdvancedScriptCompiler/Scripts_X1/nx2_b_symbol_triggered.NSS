// nx2_b_symbol_triggered
/*
	Description:
	
*/
// Name_Date

void main()
{
	object oTrap			= OBJECT_SELF;
	object oTemp			= GetFirstInPersistentObject(oTrap);
	object oCreator			= GetTrapCreator(oTrap);
	string sTriggered 		= GetLocalString(oTrap, "OnTriggered");
	int bShouldNotTrigger	= FALSE;
	string sType			= GetLocalString(oTrap, "Symbol_Type");
	object oAOE				= GetObjectByTag("symbol_of_" + sType);
	
	while(GetIsObjectValid(oTemp))
	{
		if(GetIsEnemy(oTemp, oCreator))
		{
			bShouldNotTrigger = TRUE;
		}
		oTemp = GetNextInPersistentObject(oTrap);
	}
	
	if(!bShouldNotTrigger)
	{
		ExecuteScript(sTriggered, oAOE);
	}
}
//Causes the PC to sit in the selected chair with a pose based on race and chair type. -KEMO
// called as the chair's OnUse script
// 9/28/08 - added GetIsDMPossessed option to resolve problem for DMs, fix suggested by Viconius

void main() 
{
	location lChair = GetLocation(OBJECT_SELF);
	object oPC = GetLastUsedBy();
	object oDM = OBJECT_INVALID;

	if(GetIsDMPossessed(oPC))
		oDM = GetOwnedCharacter(oPC);

	string sChairType = GetTag(OBJECT_SELF);
	string sAnim;
	string sTag = GetTag(OBJECT_SELF);
	int iRace = GetRacialType(oPC);
	int iSubrace = GetSubRace(oPC);
	
	switch (iRace)
	{
		case RACIAL_TYPE_HUMAN: sAnim = sChairType + "hum"; break;
		case RACIAL_TYPE_HALFLING: sAnim = sChairType + "hin"; break;
		case RACIAL_TYPE_ELF: sAnim = sChairType + "elf"; break;
		case RACIAL_TYPE_HALFELF: sAnim = sChairType + "helf"; break;
		case RACIAL_TYPE_DWARF: sAnim = sChairType + "dwf"; break;
		case RACIAL_TYPE_HALFORC: sAnim = sChairType + "horc"; break;
		case RACIAL_TYPE_GNOME: sAnim = sChairType + "gnm"; break;
		//SoZ races
		case 31: sAnim = sChairType + "hum"; break; //Yuan-Ti
		case 32: sAnim = sChairType + "horc"; break; //Gray Orc
	}
	
	switch (iSubrace)
	{
		case RACIAL_SUBTYPE_WILD_ELF: sAnim = sChairType + "wild"; break;
		case RACIAL_SUBTYPE_DROW: sAnim = sChairType + "drow"; break;
		case RACIAL_SUBTYPE_TIEFLING: sAnim = sChairType + "hum"; break;
		case RACIAL_SUBTYPE_AASIMAR: sAnim = sChairType + "hum"; break;
		case RACIAL_SUBTYPE_AIR_GENASI: sAnim = sChairType + "hum"; break;
		case RACIAL_SUBTYPE_EARTH_GENASI: sAnim = sChairType + "hum"; break;
		case RACIAL_SUBTYPE_FIRE_GENASI: sAnim = sChairType + "hum"; break;
		case RACIAL_SUBTYPE_WATER_GENASI: sAnim = sChairType + "hum"; break;
	}
		
	AssignCommand(oPC,ClearAllActions());
	AssignCommand(oPC,ActionMoveToLocation(lChair));

//Start a conversation to set up the sitting pose
	SetLocalString(oPC,"SittingPose",sAnim);
	SetLocalObject(oPC,"SittingChair",OBJECT_SELF);
	// SetOrientOnDialog(oPC,FALSE);
	SetCommandable(0,oPC);

	if (GetRacialType(oPC) == RACIAL_TYPE_GNOME || 
		GetRacialType(oPC) == RACIAL_TYPE_HALFORC || 
		GetRacialType(oPC) == 32 || 
		GetRacialType(oPC) == RACIAL_TYPE_DWARF)
		{
			if(GetIsObjectValid(oDM)) 
				DisplayGuiScreen(oDM,"KEMO_CHAIRS_ALT",FALSE,"kemo_chairs_alt.xml");
			else
				DisplayGuiScreen(oPC,"KEMO_CHAIRS_ALT",FALSE,"kemo_chairs_alt.xml");
		}
	else
	{
		if(GetIsObjectValid(oDM)) 
			DisplayGuiScreen(oDM,"KEMO_CHAIRS",FALSE,"kemo_chairs.xml");
		else
			DisplayGuiScreen(oPC,"KEMO_CHAIRS",FALSE,"kemo_chairs.xml");
		SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Benches",1);
		if (FindSubString(sTag,"bench") > 0 ||
			FindSubString(sTag,"booth") > 0 ||
			FindSubString(sTag,"sofa") > 0)
			{
				SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Benches",0);
				SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Reverse",1);
				SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Turn",1);
			}
	}
	if (FindSubString(sTag,"chair_1") > 0 ||
		FindSubString(sTag,"chair_2") > 0 ||
		FindSubString(sTag,"chair_4") > 0 ||
		FindSubString(sTag,"chair_5") > 0 ||
		FindSubString(sTag,"chair_8") > 0 ||
		FindSubString(sTag,"chair_9") > 0)
			SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Reverse",1);
	if (GetLocalInt(OBJECT_SELF,"Portable"))
		SetGUIObjectHidden(oPC,"KEMO_CHAIRS","Portable",0);
	
/*	if (GetIsDMPossessed(oPC)==TRUE) BeginConversation("kemo_sitting_conv",oPC);
	else
	{	
		AssignCommand(oPC,
			DelayCommand(1.0,
				ActionStartConversation(oPC,"kemo_sitting_conv",TRUE, FALSE, TRUE, TRUE)));
	} */
}

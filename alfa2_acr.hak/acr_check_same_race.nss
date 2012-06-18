// same race as npc?
int StartingConditional()
{
    object oPC = GetPCSpeaker();
	
	if (GetRacialType(oPC) == GetRacialType(OBJECT_SELF))
		return TRUE;
	
	return FALSE;
}


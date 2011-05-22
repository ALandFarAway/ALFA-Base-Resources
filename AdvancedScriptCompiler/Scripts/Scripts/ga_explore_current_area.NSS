// ga_explore_current_area
/*
	Reveals the entire map of the current area

*/
// ChazM 4/2/07

void main(int bWholeParty)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oThisArea = GetArea(oPC);

	if (bWholeParty)
	{
	    oPC = GetFirstFactionMember(oPC, TRUE);
	    while (oPC != OBJECT_INVALID)
	    {
	        ExploreAreaForPlayer(oThisArea, oPC);
	        oPC = GetNextFactionMember(oPC, TRUE);
	    }
	}
	else
		ExploreAreaForPlayer(oThisArea, oPC);
			
}

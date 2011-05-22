// ga_force_rest(int bAllPartyMembers))
/*
	Do a force rest on PC Speaker
	
		int bAllPartyMembers - 1 = force rest every one in party 
	
*/
// ChazM 7/11/07

void main(int bAllPartyMembers)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
    if ( bAllPartyMembers == 0 )
		ForceRest(oPC);
    else
    {
        object oTarget = GetFirstFactionMember(oPC, FALSE);
        while(GetIsObjectValid(oTarget))
        {
            ForceRest(oTarget);
            oTarget = GetNextFactionMember(oPC, FALSE);
        }
    }

	
}
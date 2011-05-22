// ga_take_gold
/*
    This takes gold from a player
        nGold    	= The amount of gold to take
        bAllPartyMembers     = If set to 1 it takes gold from all PCs in party (MP only)
*/
// FAB 4/28/05
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers

void main(int nGold, int bAllPartyMembers)
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

    if ( bAllPartyMembers == 0 )
    {
        TakeGoldFromCreature( nGold,oPC );
    }
    else    
    {// For multiple players
        oTarg = GetFirstFactionMember(oPC);
        while ( GetIsObjectValid(oTarg) )
        {
            TakeGoldFromCreature( nGold,oTarg );
            oTarg = GetNextFactionMember(oPC);
        }
    }

}
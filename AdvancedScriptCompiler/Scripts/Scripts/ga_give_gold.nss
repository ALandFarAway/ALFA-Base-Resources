// ga_give_gold
/*
    This gives the player some gold
        nGP     = The amount of gold coins given to the PC
        bAllPartyMembers = If set to 1 it gives gold to all the PCs in the party (MP only)
*/
// FAB 9/30
// MDiekmann 4/9/07 using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers


void main(int nGP, int bAllPartyMembers)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    if ( bAllPartyMembers == 0 ) 
    	GiveGoldToCreature( oPC,nGP );
    else
    {
        object oTarg = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oTarg))
        {
            GiveGoldToCreature( oTarg,nGP );
            oTarg = GetNextFactionMember(oPC);
        }
    }

}
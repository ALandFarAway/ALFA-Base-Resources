// ga_give_xp
/*
    This gives the player some experience
        nXP     = The amount of experience given to the PC
        bAllPartyMembers = If set to 1 it gives XP to all the PCs in the party (MP only)
*/
// FAB 9/30
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers

void main(int nXP, int bAllPartyMembers)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	string sError = "ERROR: Improperly configured quest reward. Report this to a builder.";
	SendMessageToPC( oPC, "<C=red>" + sError + "</C>" );
	WriteTimestampedLogEntry( sError );
}
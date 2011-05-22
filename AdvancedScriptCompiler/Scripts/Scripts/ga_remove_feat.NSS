// ga_remove_feat
/*
    This removes a feat from a creature, player or players.
	 sTarg		= The creature to remove the feat from. If blank, remove from PC
	 nFeat		= The number of the feat. See nwscript.nss for a list of feats.
	 bAllPartyMembers 	= If set to 1 it removes the feat from all the PCs in the party (MP only).
*/
// TDE 3/4/06
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers

void main(string sTarg, int nFeat, int bAllPartyMembers)
{
	object oPC = GetPCSpeaker();
	object oTarg;
	
	if ( sTarg == "" ) 
	{
    	if ( !bAllPartyMembers ) 
			FeatRemove(oPC, nFeat);

		else
		{
			oTarg = GetFirstFactionMember(oPC);

	        while(GetIsObjectValid(oTarg))
	        {
	            FeatRemove(oTarg, nFeat);
	            oTarg = GetNextFactionMember(oPC);
	        }
		}
	}
	else 
	{
		oTarg = GetObjectByTag(sTarg);
		FeatRemove(oTarg, nFeat);
	}
}
// ga_give_feat
/*
    This gives a feat to a creature, player or players.
	 sTarg		= The creature to give the feat to. If blank, assign to PC
	 nFeat		= The number of the feat. See nwscript.nss for a list of feats.
	 bCheckReq	= Check if the creature meets the feat's prerequisites before adding.
	 bAllPartyMembers 	= If set to 1 it gives the feat to all the PCs in the party (MP only).
*/
// TDE 3/4/06
// EPF 7/21/06 -- using GetTarget instead of GetObjectByTag()
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed bAllPCs to bAllPartyMembers

#include "ginc_param_const"

void main(string sTarg, int nFeat, int bCheckReq, int bAllPartyMembers)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oTarg;

	if ( sTarg == "" ) 
	{
    	if ( !bAllPartyMembers ) 
			FeatAdd(oPC, nFeat, bCheckReq);

		else
		{
			oTarg = GetFirstFactionMember(oPC);

	        while(GetIsObjectValid(oTarg))
	        {
	            FeatAdd(oTarg, nFeat, bCheckReq);
	            oTarg = GetNextFactionMember(oPC);
	        }
		}
	}
	else 
	{
		oTarg = GetTarget(sTarg);
		FeatAdd(oTarg, nFeat, bCheckReq);
	}
}
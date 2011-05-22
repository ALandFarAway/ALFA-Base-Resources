// gc_has_feat
/*
    This checks if the creature or player has a given feat
	 sTarg		= The creature to check for the feat. If blank, check the PC Speaker
	 nFeat		= The number of the feat. See nwscript.nss for a list of feats.
	 bIgnoreUses= Only check if the player has the feat itself, not uses left of the feat
*/
// TDE 3/7/06
// EPF 5/21/07 -- using GetTarget() now instead of GetObjectByTag().

#include "ginc_misc"
#include "ginc_debug"
	
int StartingConditional(string sTarg, int nFeat, int bIgnoreUses)
{
	object oTarg;
	if ( sTarg == "" ) 
	{
		oTarg = GetPCSpeaker();
		if(!GetIsObjectValid(oTarg))
		{
			oTarg = GetFactionLeader(GetFirstPC());
		}
	}
	

	else 
	{
		oTarg = GetTarget(sTarg);
	}
	
	if(!GetIsObjectValid(oTarg))
	{
		PrettyDebug("gc_has_feat: unable to find target " + sTarg);
		oTarg = OBJECT_SELF;
	}

	if ( GetHasFeat(nFeat, oTarg, bIgnoreUses) )
	{
		return TRUE;
	}

	return FALSE;
}


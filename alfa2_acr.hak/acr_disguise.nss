#include "acr_vanity_i"

void CheckHairDye(location lPrimaryLoc, object oTarget, object oDisguiseKit, int bRoll)
{
	if(GetDistanceBetweenLocations(lPrimaryLoc, GetLocation(oTarget)) > 1.0f)
	{
		SendMessageToPC(OBJECT_SELF, "Your victim moved! I mean, that person is too wiggly to work on. Get them to hold still.");
		SendMessageToPC(oTarget, "You goy away! I mean, if you'd like to have your hair dyed, you're going to have to hold still.");
		return;
	}
	
	if(GetNaturalHairColor(oTarget) == "")
	{
		SendMessageToPC(OBJECT_SELF, "Error: Unable to calculate natural hair color. Aborting.");
		return;
	}
	DoHairDye(oDisguiseKit, OBJECT_SELF, oTarget, bRoll);
	DelayCommand(0.1f, DestroyObject(oDisguiseKit));
	return;
}

void main()
{
	int nSpellID = GetSpellId();
	
	int bRoll = FALSE;
	
	if(nSpellID == 3025) bRoll = TRUE;
	
	object oDisguiseKit = GetSpellCastItem();
	
	if(!GetIsObjectValid(oDisguiseKit))
	{
		SendMessageToPC(OBJECT_SELF, "You can't disguise anything without the proper supplies!");
		return;
	}
	
	string sType = GetStringLeft(GetTag(oDisguiseKit), 3);
	
	if(sType == "dye")
	{
		object oTarget = GetSpellTargetObject();
		if(!GetIsPC(oTarget))
		{
			SendMessageToPC(OBJECT_SELF, "Contact a DM if you wish to perform your craft on NPCs.");
			return;
		}
		SendMessageToPC(oTarget, GetName(OBJECT_SELF)+" is attempting to dye your hair! You have 12 seconds to move if you don't want this to happen.");
		location lPrimaryLoc = GetLocation(oTarget);
		DelayCommand(12.0f, CheckHairDye(lPrimaryLoc, oTarget, oDisguiseKit, bRoll));
	}
	else
	{
		SendMessageToPC(OBJECT_SELF, "Disguise kit type not recognized.");
		return;
	}
}
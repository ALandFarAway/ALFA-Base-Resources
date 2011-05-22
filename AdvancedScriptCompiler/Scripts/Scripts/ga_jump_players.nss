// ga_jump_players(string sDestTag, int bWholeParty, int bOnlyThisArea)
/*
   Jumps the PC party to a waypoint or object.

   Parameters:
     string sDestTag   = Tag of waypoint or object to jump to.
     int bWholeParty   = DOES NOTHING IN CAMPAIGN.  If =0 then jump the PC only, else jump the PC's party.
     int bOnlyThisArea = DOES NOTHING
*/
	
// ChazM 3/11/05
// BMA-OEI 1/11/06 removed default params 
// EPF 2/6/06 -- fixed the loop in JumpParty to deal with multiple parties
// ChazM 3/3/06 - replaced JumpParty() w/ JumpPartyToArea() script command.  Modified to always jump whole party in campaign.
// ChazM 7/13/07 - Dominated removed from party if campaign flag set.

#include "ginc_debug"
#include "ginc_transition"

// Jump oPC's whole party.
//  oPartyMember - member of the party to jump
//  oDestination - the destination (typically a waypoint object)
//  bOnlyThisArea - Jump only members of the party in the same area as oPartyMember? Default is true
void JumpParty(object oPartyMember, object oDestination, int bOnlyThisArea)
{
	object oThisArea = GetArea(oPartyMember);
	
	object oJumper = GetFirstFactionMember(oPartyMember, FALSE);

	if(GetIsPC(oJumper))
	{
		oJumper = GetNextFactionMember(oPartyMember, FALSE);
	}


    while (GetIsObjectValid(oJumper) == TRUE)
    {
		if (!bOnlyThisArea || (GetArea(oJumper) == oThisArea))
		{
			AssignCommand(oJumper, JumpToObject(oDestination));
		}
        oJumper = GetNextFactionMember(oPartyMember, FALSE);
    }

	oJumper = GetFirstFactionMember(oPartyMember, TRUE);


    while (GetIsObjectValid(oJumper) == TRUE)
    {
		if (!bOnlyThisArea || (GetArea(oJumper) == oThisArea))
		{
			AssignCommand(oJumper, JumpToObject(oDestination));
		}
        oJumper = GetNextFactionMember(oPartyMember, TRUE);
    }
}

void main(string sDestTag, int bWholeParty, int bOnlyThisArea)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	if ( GetGlobalInt(CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION) == TRUE )
	{
		int nRemoved = RemoveDominatedFromPCParty(oPC);
	}
	
    object oDestination = GetObjectByTag(sDestTag);

	if (bWholeParty == 0 && GetGlobalInt(VAR_GLOBAL_GATHER_PARTY)==0)
	{
		AssignCommand(oPC, JumpToObject(oDestination));
	}
	else
	{
		// BMA-OEI 6/14/06
		SinglePartyTransition( oPC, oDestination );
		//JumpPartyToArea(oPC, oDestination);
		//JumpParty(oPC, oDestination, bOnlyThisArea);
	}
}
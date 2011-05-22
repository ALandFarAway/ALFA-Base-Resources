// gui_force_comp
//
// A companion is forced into the party, and the party gui is brought up.
// This is a callback script called from ka_hotspot_click_force.  The function DisplayForceCompanionMessage() defines
// the companion who gets forced into the party, setting it as a global variable.
	
// EPF 1/10/06
// BMA-OEI 8/31/06: Delay to DisplayGuiScreen, Use OBJECT_SELF as PC
// BMA-OEI 9/17/06: If there's room, force companion into party
// BMA-OEI 9/17/06: No longer displays Party Select ( Trigger already prompts Party Select )
// BMA-OEI 10/20/06: " " Unless opened in area other than Crossroad Keep
	
#include "ginc_companion"
#include "ginc_gui"

void main()
{
	object oPC = OBJECT_SELF;
	if ( GetIsPC(oPC) == FALSE ) return;

	object oFM;
	string sCompanion = GetGlobalString("00_sLastForcedCompanion");

	// BMA-OEI 9/17/06: If there's room, force companion into party
	int nPartyLimit = GetRosterNPCPartyLimit();
	int nNPCsInParty = GetNumRosterMembersInParty( oPC );
	
	// Party Limit hit, remove selectable companions
	if ( nNPCsInParty >= nPartyLimit )
	{
		RemoveRosterMembersFromParty( oPC, TRUE, FALSE );
		nNPCsInParty = GetNumRosterMembersInParty( oPC );
	}

	// Free slots available, add required companion
	if ( nNPCsInParty < nPartyLimit )
	{
		AddRosterMemberToParty( sCompanion, oPC );
		SetIsRosterMemberSelectable( sCompanion, FALSE );	
	}

/*
	AddRosterMemberToParty(sCompanion,oPC);
	SetIsRosterMemberSelectable(sCompanion,FALSE);
	
	oFM = GetFirstFactionMember(oPC,FALSE);
	while(GetIsObjectValid(oFM))
	{
		if(GetIsRosterMember(oFM) && GetIsRosterMemberSelectable(GetRosterNameFromObject(oFM)))
		{
			RemoveRosterMemberFromParty(GetRosterNameFromObject(oFM),oPC);
		}
		oFM = GetNextFactionMember(oFM,FALSE);
	}
*/

	// BMA-OEI 10/20/06: Unless opened in area other than Crossroad Keep
	// BMA-OEI 9/17/06: No longer displays Party Select ( Trigger already prompts screen )
	// BMA-OEI 8/31/06: Delay for GUI to update w/ spawned companion
	if ( GetTag( GetArea( oPC ) ) != "3070_sh_farm" )
	{
		DelayCommand( 0.5f, ShowPartySelect( oPC, TRUE, "", FALSE ) );
	}	
}
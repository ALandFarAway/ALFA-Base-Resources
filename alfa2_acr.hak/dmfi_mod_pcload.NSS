////////////////////////////////////////////////////////////////////////////////
// dmfi_mod_pcload - DM Friendly Initiative - On PC Loaded Script : Module Event
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/6/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script is only included so that I can create an up to date erf for the 
// Listener package - it is purposefully excluded from the dmfi.erf

#include "dmfi_inc_initial"

void main()
{
	object oEntry = GetEnteringObject();
	//SetLocalInt(GetEnteringObject(), DMFI_DM_STATE,1);  //QA Testing purposes only.
	if (!GetIsDM(oEntry)) {
		// don't poll the PC for languages yet if they aren't adapted to the custom skills
	    //if (GetSkillRank(0, oEntry, TRUE) != 1) { return; }
	}
	DMFI_ClientEnter(oEntry);
}
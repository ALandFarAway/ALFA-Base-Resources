////////////////////////////////////////////////////////////////////////////////
// dmfi_mod_pcload - DM Friendly Initiative - On PC Loaded Script : Module Event
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/6/6
//               AcadiusLost  8/23/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script is for use with the ALFA ACR rebuild process, which staggers language
//  initialization until after reallocating skill points into custom skills.

#include "dmfi_inc_initial"

void main()
{
	object oEntry = OBJECT_SELF;
	//SetLocalInt(GetEnteringObject(), DMFI_DM_STATE,1);  //QA Testing purposes only.
	if (!GetIsDM(oEntry)) {
		// don't poll the PC for languages yet if they aren't adapted to the custom skills
	    //if (GetSkillRank(0, oEntry, TRUE) != 1) { return; }
	}
	DMFI_ClientEnter(oEntry);
}
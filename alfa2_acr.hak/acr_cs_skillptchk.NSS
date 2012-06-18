// 2009/07/07  AcadiusLost: Altered to force spending all starting skillpoints
// 2009/07/15  AcadiusLost: Reinstated 2 point rollover
// 2009/07/26  AcadiusLost: added able learner conditional function

int StartingConditional(int nSkill, int nValue) {
	// dual-use function, if this is Able Learner, make sure they had the full runthrough
	object oPC = GetPCSpeaker();
	if (nSkill == -1) {
		if (GetHasFeat(1774, oPC)) {
			if (GetLocalInt(oPC, "ACR_REBUILD_CONFIRM")) {
				return TRUE;
			} else {
				return FALSE;
			}
		} else {
			return TRUE;
		}
	} else {
		// 1.23 final gives SetRemainingSkillPoints()
	    if (GetLocalInt(oPC, "ACR_SKILL_POINTS") < 3) {
	        return TRUE;
        } else {
            return FALSE;
	    }
	}
}
#include "acr_db_persist_i"
#include "acr_skills_i"
#include "acr_resting_i"
#include "acr_language_i"
#include "acr_xp_i"
#include "dmfi_inc_initial"

// 2008/08/12  AcadiusLost - added able learner exception, 1.13 compatibility
// 2009/07/07  AcadiusLost - update to new skill functions for NWN2 patch 1.23
// 2009/07/21  AcadiusLost - added modes and hooks for rebuild functions
// 2009/07/26  AcadiusLost - edits to accomodate Able Learners
// 2009/08/13  AcadiusLost - edits fix Able Learner exploit, better handle rebuild reattempt
// 2009/08/23  AcadiusLost - Fix for language non-initialization do to other players logging in.
// 2009/09/27  AcadiusLost - Fixes for bards rolled up under the 1.23 haks. (Perform skill initialization)
// 2010/10/17  AcadiusLost - Fixes in accomodation for bards coming in with ranks in custom Perform subskills.
// 2011/12/04  AcadiusLost - #include acr_resting_i

void main (string sAction, int nSkill) {

    object oPC = GetPCSpeaker();
	int nBaseRank = GetSkillRank(nSkill, oPC, TRUE);
	int nRemainingPoints = GetLocalInt(oPC, "ACR_SKILL_POINTS");
	int nMod = GetLocalInt(oPC, "ACR_SKILL_"+IntToString(nSkill));
	string sSkillName = Get2DAString("skills", "Label", nSkill);
	int bClassSkill = _IsClassSkill(nSkill, oPC);
	int nAssignedValue = nBaseRank + nMod;
	int nMaxRank = 4;
	int nCost = 1;
	if (!bClassSkill) {
	    nMaxRank = 2;
		nCost = 2;
	}
	// Able Learner exception
	if (GetHasFeat(1774, oPC)) {  nCost =1; }
	
	int nCount = 1;
    
	if (sAction == "Check") {
	    // Display the assigned rank in the skill
		SendMessageToPC(oPC, sSkillName+" ranks: "+IntToString(nAssignedValue)+", points remaining: "+IntToString(nRemainingPoints));

	
    } else if (sAction == "Initialize") {
        // initialization request- cache skill ranks, add up available points.
		// with 1.23, we don't need LETO for this, so quite a bit changes here.
		
		//  don't have a good way to query unused skill points presently.
		//SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", "%bob = '"+ACR_SQLEncodeSpecialChars(ACR_GetBicPath(oPC))+"'; print /LvlStatList/[0]/SkillPoints;");
		//string sReply = GetLocalString(GetModule(), "NWNX!LETO!SCRIPT");
		//SetLocalString(GetModule(), "NWNX!LETO!SCRIPT", " close %bob;");
		int nSkillPointsRemaining = GetSkillPointsRemaining(oPC);
		SendMessageToPC(oPC, "Remaining skillpoints from character creation: "+IntToString(nSkillPointsRemaining));
		
		while (nCount <= 29) {
		    // iterate through the base skillset, add up ranks. Cache these on the PC.
			nBaseRank = GetSkillRank(nCount, oPC, TRUE);
			if (nBaseRank > 0) {
			    // only check for skill conversion if the PC actually has ranks in the skill.
			    if (ACR_GetIsSkillRemoved(nCount)) {
				    // skill has been deleted by ALFA- determine if it is a class skill, then assign points.
					//  -> NOTE: since these are skills assigned at 1st level, we ignore Able Learner here.
					if (_IsClassSkill(nCount, oPC)) {
					    nCost = 1;
					} else { nCost = 2;}
					nRemainingPoints = nRemainingPoints + (nBaseRank * nCost);
					SetLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount), (0 - nBaseRank));
					SendMessageToPC(oPC, IntToString(nCount)+": will be dropped all "+IntToString(nBaseRank)+" points.");
			    } 
			}
		    nCount = nCount + 1;
		}

		SetLocalInt(oPC, "ACR_SKILL_POINTS", nRemainingPoints + nSkillPointsRemaining);
		// Check for the problematic ALERTNESS feat, if present, sub it for another.
		if (GetHasFeat(FEAT_ALERTNESS, oPC)) {
			// first, try to replace with SF:Spot
			FeatRemove(oPC, FEAT_ALERTNESS);
			if (!GetHasFeat(FEAT_SKILL_FOCUS_SPOT, oPC)) {
				FeatAdd(oPC, FEAT_SKILL_FOCUS_SPOT, FALSE, TRUE, TRUE);
				WriteTimestampedLogEntry("ACR Rebuild for PC: "+GetName(oPC)+", Alertness removed, replaced with SF: Spot.");
				ACR_SetPersistentString(oPC, "ACR_REBUILD_ALERTNESS", "SF: Spot");
			} else if (!GetHasFeat(FEAT_SKILL_FOCUS_LISTEN, oPC)) {
				FeatAdd(oPC, FEAT_SKILL_FOCUS_LISTEN, FALSE, TRUE, TRUE);
				WriteTimestampedLogEntry("ACR Rebuild for PC: "+GetName(oPC)+", Alertness removed, replaced with SF: Listen.");
				ACR_SetPersistentString(oPC, "ACR_REBUILD_ALERTNESS", "SF: Listen");
			} else {
				WriteTimestampedLogEntry("ACR Rebuild Error for PC: "+GetName(oPC)+", Alertness removed but was unable to replace it with another appropriate feat.");
				ACR_SetPersistentString(oPC, "ACR_REBUILD_ALERTNESS", "none");
			}
		}
		// finally, give them a free subdual feat.
		FeatAdd(oPC, 3501, FALSE, TRUE, TRUE);
		//
	} else if (sAction == "List") {
	    // Print a list of all the PC's skill ranks as currently assigned
		SendMessageToPC(oPC, "___Skill_Ranks____");
		while (nCount <= ACR_SKILLS_NUMBER) {
		    nBaseRank = GetSkillRank(nCount, oPC, TRUE);
			nMod = GetLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount));
			if ((nCount == 7) || (nCount == 11)) {
			    // hidden skills, skip printing.
			} else if ((nBaseRank + nMod) > 0 ) {
			    SendMessageToPC(oPC, Get2DAString("skills", "Label", nCount)+": "+IntToString(nBaseRank+nMod));
			}
		nCount = nCount + 1;
	    }
		SendMessageToPC(oPC, "-------------------");
		
		
    } else if (sAction == "Add") {
        // Add rank of skill nSkill
		// NOTE: for Able Learner, nCost=1 from above.
		if (nRemainingPoints >= nCost) {
		    if (nAssignedValue < nMaxRank) {
			    SetLocalInt(oPC, "ACR_SKILL_"+IntToString(nSkill), nMod+1);
				SetLocalInt(oPC, "ACR_SKILL_POINTS", nRemainingPoints - nCost);
				SendMessageToPC(oPC, sSkillName+" raised to "+IntToString(nAssignedValue+1));
			} else {
			    SendMessageToPC(oPC, "You are at the maximum for your level already.");
			}
		} else {
		    SendMessageToPC(oPC, "You do not have enough points remaining to add a rank in this skill.");
		}		    
		
		
    } else if (sAction == "Drop") {
        // Subtract rank of skill nSkill
		// NOTE: Able Learner has nCost=1 set above.
	    if (nAssignedValue > 0) {
			SetLocalInt(oPC, "ACR_SKILL_"+IntToString(nSkill), nMod-1);
		    SetLocalInt(oPC, "ACR_SKILL_POINTS", nRemainingPoints + nCost);
			SendMessageToPC(oPC, sSkillName+" dropped to "+IntToString(nAssignedValue-1));
		} else {
			SendMessageToPC(oPC, "You do not have any ranks left in this skill.");
		} 
		
		
    } else if (sAction == "Clear All") {
        // Clear all skill ranks, convert to unallocated skillpoints.
		while (nCount <= ACR_SKILLS_NUMBER) {
		    // iterate through the entire skillset, add up ranks. Cache these on the PC.
			nBaseRank = GetSkillRank(nCount, oPC, TRUE);
			nAssignedValue = nBaseRank + GetLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount));
			if (nAssignedValue > 0) {
			    // only check for skill conversion if the PC actually has ranks in the skill.
				// NOTE: For Able Learner and 1st level skill ranks, no change is needed due to buggy OE implementation
				if (_IsClassSkill(nCount, oPC)) {
					    nCost = 1;
					} else if (GetLocalInt(oPC, "ACR_REBUILD_CONFIRM") == TRUE) {
						// Able Learner coming through on 2nd or later "Clear All" attempt.
						nCost = 1;
					} else { nCost = 2;}
				nRemainingPoints = nRemainingPoints + (nAssignedValue * nCost);
				SendMessageToPC(oPC, "Dropping "+IntToString(nCount)+" by "+IntToString(nAssignedValue));
				// add up points from the conversion, set skill modifier for LETO to negative.
				SetLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount), (0 - nBaseRank));
			}
			nCount = nCount + 1;
		}
		SetLocalInt(oPC, "ACR_SKILL_POINTS", nRemainingPoints);	
		// Able learners only get one of these at 2 points / crossclass rank.
		if (GetHasFeat(1774, oPC, TRUE)) { 
			SetLocalInt(oPC, "ACR_REBUILD_CONFIRM", TRUE);
		}
	} else if (sAction == "Confirm") {
		// just set a local to allow Able Learners to lock in their skill ranks.
		SetLocalInt(oPC, "ACR_REBUILD_CONFIRM", TRUE);
		
    } else if (sAction == "Write") { 
	    // write all skill rank changes to the vault.  Build the LETO string.
		//  this doesn't require LETO using NWN2 1.23, so we don't have to wait till logout
	    int nChangeRank = 0;
		int nFinalRank = 0;
		int nMaxPerform = 0;
		//string sLetoString = "%bob = '"+ACR_SQLEncodeSpecialChars(ACR_GetBicPath(oPC))+"';";
		// mark bic as LETO'd by adding one rank of skill[0] (animal empathy)
		//sLetoString = sLetoString + " /SkillList/[0]/Rank = 1;";
		while (nCount <= ACR_SKILLS_NUMBER) {
		    nChangeRank = GetLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount));		
			if (nCount == 7) {
			    // special handling for lore, set = Knowledge: Arcana
				nFinalRank = GetSkillRank(40, oPC, TRUE) + GetLocalInt(oPC, "ACR_SKILL_40");
				//sLetoString = sLetoString + " /SkillList/[7]/Rank = "+IntToString(nFinalRank)+";";
				SetBaseSkillRank(oPC, SKILL_LORE, nFinalRank, FALSE);
			} else if (nCount == 11) {
			    // special handling for perform, skip for now
			} else if (nChangeRank != 0) {
			    // this skill will need to be altered on the bic.
				nFinalRank = GetSkillRank(nCount, oPC, TRUE) + nChangeRank;
				//sLetoString = sLetoString + " /SkillList/["+IntToString(nCount)+"]/Rank = "+IntToString(nFinalRank)+";";
				//sLetoString = sLetoString + " /LvlStatList/[0]/SkillList/["+IntToString(nCount)+"]/Rank = "+IntToString(nFinalRank)+";";
				SetBaseSkillRank(oPC, nCount, nFinalRank, FALSE);
			} else {
			    // skill rank doesn't need to be changed, but should be checked anyway for Perform handling
				nFinalRank = GetSkillRank(nCount, oPC, TRUE);
			}
			// check for highest Perform skill regardless of whether the subskill rank needs changing.
			if ((nCount >= 45) && (nCount <= 49)) {
				// peform subskills - cache the highest
				if (nFinalRank > nMaxPerform) { nMaxPerform = nFinalRank; }
			} else if ((nCount >= 60) && (nCount <= 63)) {
				// peform subskills part 2- cache the highest
				if (nFinalRank > nMaxPerform) { nMaxPerform = nFinalRank; }
			}	
			DeleteLocalInt(oPC, "ACR_SKILL_"+IntToString(nCount));
		    nCount = nCount + 1;
		}
		int nPerform = GetSkillRank(11, oPC, TRUE);		
		if (nMaxPerform > 0) {
		    // then we need to adjust the hidden Perform skill
			//sLetoString = sLetoString + " /SkillList/[11]/Rank = "+IntToString(nMaxPerform)+";";
			SetBaseSkillRank(oPC, SKILL_PERFORM, nMaxPerform, FALSE);
		}	
		// leftover points for next level need to be stored on the bic too.
		SetSkillPointsRemaining(oPC, nRemainingPoints);
		//sLetoString = sLetoString + " /LvlStatList/[0]/SkillPoints = "+IntToString(nRemainingPoints)+";";
		

		// next, if the PC has been de-leveled for a rebuild, return their XP for later
		if (GetSkillRank(0, oPC, TRUE) == 1) {
			_ReturnXPforRebuild(oPC);
			// initialize DMFI to get starting languages sorted.
			ExecuteScript("dmfi_mod_pcload", GetModule());
			AssignCommand(oPC, ActionSpeakString("((ACR Skills Adaption Rebuild: Please repeat leveling in your prior classes.))"));
			
		} else {
			//add 2 ranks of Animal Empathy to mark the .bic as fully converted to Custom Skills.
			SetBaseSkillRank(oPC, 0, 2, TRUE);
			// remove the Adaption FX
			_StripAdaptionEffects(oPC);
			AssignCommand(oPC, ActionSpeakString("((ACR Skills Adaption Rebuild: Completed Successfully.))"));
			WriteTimestampedLogEntry("ACR Skills adaption complete for PC: "+GetName(oPC)+".");
			// start RPXP and initialize DMFI
			ExecuteScript("dmfi_delayed_pcload", oPC);
			ACR_XPOnClientLoaded(oPC);
			ACR_RestOnClientEnter(oPC);
		}
		// DMFI_ClientEnter(oPC);
		// clear out any preassigned languages so they may be reassigned.
		//_WipeLanguages(oPC);
		
		DeleteLocalInt(oPC, "ACR_SKILL_POINTS");
		DeleteLocalInt(oPC, "ACR_REBUILD_CONFIRM");
		//sLetoString = sLetoString + " %bob = '>'; close %bob;";	 
        //SetLocalInt(oPC, "ACR_LETO_FULL", TRUE);
		//SetLocalString(oPC, "ACR_LETO_STRING", sLetoString);
		//BootPC(oPC);
	} else if (sAction == "Preexecute") {
		// check to see if this is a preexisting PC who actually needs rebuilding
		if (GetXP(oPC) > 1) {
			// Wipe any residual cached data from unsuccessful prior rebuilds.
			_RebuildCleanup(oPC);
			// PC needs to be dropped down 1 or more levels, with pertinant information cached.
			ACR_SkillsPrepareAdaption(oPC);
			
			object oTool = GetItemPossessedBy(oPC, "dmfi_exe_tool");
			//SendMessageToPC(oPC, "recovered pointer to "+GetName(oTool));
			SetPlotFlag(oTool, FALSE);
			DestroyObject(oTool, 0.0);
		} else {
			// Newly created PC, still apply the FX
			_ApplyAdaptionEffects(oPC);
		}
	}

}
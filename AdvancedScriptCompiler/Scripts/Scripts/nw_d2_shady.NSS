//::///////////////////////////////////////////////
//:: Check Check Abilities
//:: NW_D2_Shady
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks to see if the character has the Open Lock,
    Pick Pocket, Set Trap or Disable Trap skills
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 18, 2001
//:://////////////////////////////////////////////

int StartingConditional()
{
	int l_iResult, nOpen, nPick, nTrap, nDisable;


    nDisable = GetSkillRank(SKILL_DISABLE_TRAP, GetPCSpeaker());
    nOpen = GetSkillRank(SKILL_OPEN_LOCK, GetPCSpeaker());
    nPick = GetSkillRank(SKILL_SLEIGHT_OF_HAND, GetPCSpeaker());
    nTrap = GetSkillRank(SKILL_SET_TRAP, GetPCSpeaker());
    
    if(nDisable > 0 || nOpen > 0 || nPick > 0 || nTrap > 0)
    {
        l_iResult = TRUE;
    }

	return l_iResult;
}


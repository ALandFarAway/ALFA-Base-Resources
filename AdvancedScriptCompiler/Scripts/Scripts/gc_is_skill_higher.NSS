// gc_is_skill_higher
/*
	Checks the speaker's skills.  If Skill A is greater than or equal to than Skill B, returns TRUE.  Otherwise
	returns false.
	
	if bStrictlyGreaterThan = 1, then we will only return 1 in the case where Skill A is greater than Skill B,
	and not when they are equal.

		skill ints
		0	APPRAISE
		1	BLUFF
		2	CONCENTRATION
		3	CRAFT ALCHEMY
		4	CRAFT ARMOR
		5	CRAFT WEAPON
		6	DIPLOMACY
		7	DISABLE DEVICE
		8	DISCIPLINE
		9	HEAL
		10	HIDE
		11	INTIMIDATE
		12	LISTEN
		13	LORE
		14	MOVE SILENTLY
		15	OPEN LOCK
		16	PARRY
		17	PERFORM
		18	RIDE
		19	SEARCH
		20	CRAFT TRAP
		21	SLEIGHT OF HAND
		22	SPELL CRAFT
		23	SPOT
		24	SURVIVAL
		25	TAUNT
		26	TUMBLE
		27	USE MAGIC DEVICE
*/	
// EPF 11/14/05

#include "ginc_param_const"

int StartingConditional(int nSkillA, int nSkillB, int bStrictlyGreaterThan)
{
	object oPC = GetPCSpeaker();
	int nSkillValA = GetSkillConstant(nSkillA);
	int nSkillValB = GetSkillConstant(nSkillB);
	
	
	if (!bStrictlyGreaterThan && GetSkillRank(nSkillValA, oPC) >= GetSkillRank(nSkillValB, oPC))
	{
		return TRUE;
	}
	else if (bStrictlyGreaterThan && GetSkillRank(nSkillValA, oPC) > GetSkillRank(nSkillValB, oPC))
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}
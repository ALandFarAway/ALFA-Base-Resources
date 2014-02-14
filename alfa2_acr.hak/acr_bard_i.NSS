//: ==============================
//: ACR_BARD_I
//: ==============================
//: This library contains common functions
//: used by bards.
//: 2014/02/14-- introduce GetPerformRanks

#include "acr_i"

// Get the highest number of ranks of a skill that
// can be used for the purposes of bardsong by this
// PC.
int GetPerformRanks(object oPC);

int GetPerformRanks(object oPC)
{
    int perform = GetSkillRank(SKILL_PERFORM_ACT, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_COMEDY, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_COMEDY, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_DANCE, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_DANCE, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_KEYBOARD, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_KEYBOARD, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_ORATORY, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_ORATORY, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_PERCUSSION, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_PERCUSSION, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_STRING_INSTRUMENTS, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_STRING_INSTRUMENTS, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_SING, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_SING, oPC, TRUE);
    if(perform < GetSkillRank(SKILL_PERFORM_WIND_INSTRUMENTS, oPC, TRUE))
        perform = GetSkillRank(SKILL_PERFORM_WIND_INSTRUMENTS, oPC, TRUE);
    return perform;
}
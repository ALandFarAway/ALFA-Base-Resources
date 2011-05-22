// check to see if the henchman has a spell memorized

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_RESIST_ENERGY, OBJECT_SELF);	// JLR - OEI 07/11/05 -- Name Changed
    return iResult;
}

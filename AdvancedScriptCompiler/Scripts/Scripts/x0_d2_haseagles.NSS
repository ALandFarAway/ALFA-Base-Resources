// check to see if the henchman has a spell memorized
// ChazM-OEI 7/21/07 Spell constant changed

int StartingConditional()
{
    int iResult;

    iResult = GetHasSpell(SPELL_EAGLES_SPLENDOR, OBJECT_SELF);
    return iResult;
}
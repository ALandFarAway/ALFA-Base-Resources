// gc_rand_1of
/*
    Used to randomly pick a dialog response.
    Use paramaters 2 through X for each entry after the first, decementing by 1 for each branch going down.
    Example:  3 entries would have the following conditionals:
    gc_rand_1of(3)
    gc_rand_1of(2)
    The final entry doesn't need a check since it is a certainty.

*/
// ChazM 3/10/05

int StartingConditional(int iMax)
{
    int iResult;

    iResult = Random(iMax) == 1;
    return iResult;
}


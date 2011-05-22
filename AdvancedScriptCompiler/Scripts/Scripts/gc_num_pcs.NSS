// gc_num_pcs (string sCheck)
/* 
	This script checks number of PCs in the current game.

	Parameters:
		string sCheck	=	The operation to compare to the number of PCs(NumPC).
							Default is "=", but you can also specify "<", ">", or "!"
							e.g. sCheck of "<3" returns TRUE if NumPC is less than 3,
							sCheck of "2" or "=2" returns TRUE if NumPC is equal to 2,
							and sCheck of "!1" returns TRUE if NumPC is not equal to 1.
*/
// BMA-OEI 11/29/05

#include "ginc_var_ops"
#include "ginc_debug"

int StartingConditional(string sCheck)
{
	object oPC = GetFirstPC();

	// get number of PCs
	int nNumPCs = 0;
	while (GetIsObjectValid(oPC) == TRUE)
	{
		nNumPCs = nNumPCs + 1;
		oPC = GetNextPC();
	}

	return ( CompareInts(nNumPCs, sCheck) );
}

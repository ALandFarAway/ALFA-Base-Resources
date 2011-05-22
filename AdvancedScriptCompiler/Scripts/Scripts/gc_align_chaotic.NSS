// gc_align_chaotic.nss
/*
   Check if player's alignment is Chaotic
*/
// BMA-OEI 7/25/05
// ChazM 4/9/07 - updated

#include "ginc_alignment"
	
int StartingConditional()
{
	object oPC = GetPCSpeaker();
	return (GetIsChaotic(oPC));
/*	
	int nAlignment = GetLawChaosValue(oPC); // 100(lawful) - 0(chaotic)
	
	if (nAlignment <= ALIGN_VALUE_CHAOTIC)
	{ 
		return TRUE;
	}
	else
	{
		return FALSE;
	}
*/	
}
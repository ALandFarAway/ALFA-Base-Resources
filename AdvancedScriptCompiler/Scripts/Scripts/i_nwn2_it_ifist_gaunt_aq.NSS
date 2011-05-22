// i_nwn2_it_ifist_gaunt_aq
/*
   On Acquire for Ironfist Gauntlets to prevent multiple gauntlet creation.
*/
// 8/30/06

void main()
{
    // * This code runs when the item is acquired
    object oPC      = GetModuleItemAcquiredBy();
    object oItem    = GetModuleItemAcquired();
    int iStackSize  = GetModuleItemAcquiredStackSize();
    object oFrom    = GetModuleItemAcquiredFrom();
	
	if (GetGlobalInt("FoundIronfistGaunt") == 0)
	{
		SetGlobalInt("FoundIronfistGaunt", 1);		
	}
}
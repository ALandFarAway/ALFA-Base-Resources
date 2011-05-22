// i_dirgebook_ac
//
// Dirge of Ancient Illefarn feat is granted by a book found in 2400.
	
// EPF 2/27/06
	
void main()
{
	object oItem = GetItemActivated();	
	object oGuy = GetItemActivator();
	
	FeatAdd(oGuy, FEAT_BARDSONG_DIRGE_OF_ANCIENT_ILLEFARN, TRUE);
}
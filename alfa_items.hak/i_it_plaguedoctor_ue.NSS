// i_it_plaguedoctor_ue
/*
   UnEquip script for the plague doctor mask tagged "it_plaguedoctor"
   
   This script will remove the special effect used to simulate the transparent googles.
 */
// Thierry Petitjean (4760)
// December 2016


void main()
{
    object oPC = GetPCItemLastEquippedBy();
    object oItem = GetPCItemLastEquipped();
	// name of the special effect (without the .sef extension)
	string sGlass = GetLocalString(oItem, "SEF");
	RemoveSEFFromObject(oPC, sGlass);
}
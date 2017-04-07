// i_it_plaguedoctor_eq
/*
   OnEquip script for the plague doctor mask tagged "it_plaguedoctor"
   
   The mask's googles will be displayed by the use of a special effect:
    - sfx_verres.sef for normal glass
    - sfx_verres_rouges.sef for red-tainted glass
    - sfx_verres_verts for green-tainted glass
	- sfx_verres_bleus for blue-tainted glass
	The special effect to use will need to be given as a variable attached to the mask (thus allowing to have four different glasses for any mask). 
   
   The reason for this is that transparency doesn't work for creatures (and masks are parts of the creature, from the engine viewpoint).
 */
// Thierry Petitjean (4760)
// December 2016


void main()
{
    object oPC = GetPCItemLastEquippedBy();
    object oItem = GetPCItemLastEquipped();
	// name of the special effect (without the .sef extension)
	string sGlass = GetLocalString(oItem, "SEF");
	effect eGlassSFX = EffectNWN2SpecialEffectFile(sGlass, oPC);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGlassSFX, oPC);
}
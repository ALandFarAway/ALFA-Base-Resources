//gr_input_test

#include "ginc_crafting"	

void main()
{
	object oPC = OBJECT_SELF;
	object oItem = GetFirstItemInInventory(oPC);

	SpeakString("about to rename item: " + GetName(oItem));
	SetEnchantedItemName(oPC, oItem);
	
	// DisplayInputBox( OBJECT_SELF, 0, "Test Message", "gui_input_ok", "", 1,
	// "SCREEN_STRINGINPUT_MESSAGEBOX", 0, "OKAY", 0, "CANCEL", "DefaultSTR", "VariableSTring" );
}
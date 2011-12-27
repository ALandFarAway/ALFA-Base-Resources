////////////////////////////////////////////////////////////////////////////////
// Wand System
// Original Scripter:  Caos81      Design: Caos81
//------------------------------------------------------------------------------
// Last Modified By:   Caos81           28/01/2009
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

#include "wand_inc_misc"
#include "wand_inc"
#include "wand_inc_conf"

void main () {

	object oPc = OBJECT_SELF;
	
	if (!IsDm(oPc))
		return;
	
	if (STORE_SETTINGS)
		DeleteCampaignVariable("WAND_SETTINGS", "ORIENTATION", oPc);
		
	if (DMFI) {
		CloseGUIScreen(oPc, WAND_GUI_DMFI_H);
		DisplayGuiScreen(oPc, WAND_GUI_DMFI_V, FALSE, WAND_GUI_DMFI_V);
	}	
	else {
		CloseGUIScreen(oPc, WAND_GUI_H);
		DisplayGuiScreen(oPc, WAND_GUI_V, FALSE, WAND_GUI_V);
	}		
}
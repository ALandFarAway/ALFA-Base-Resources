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
		SetCampaignInt("WAND_SETTINGS", "ORIENTATION", TRUE, oPc);
	
	if (DMFI) {
		CloseGUIScreen(oPc, WAND_GUI_DMFI_V);
		DisplayGuiScreen(oPc, WAND_GUI_DMFI_H, FALSE, WAND_GUI_DMFI_H);		
	}	
	else {
		CloseGUIScreen(oPc, WAND_GUI_V);
		DisplayGuiScreen(oPc, WAND_GUI_H, FALSE, WAND_GUI_H);
	}		
}
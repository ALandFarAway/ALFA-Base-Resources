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
	
	if (DMFI) {
		CloseGUIScreen(oPc, "dmfidmui.xml");
		if (STORE_SETTINGS
			&& GetCampaignInt("WAND_SETTINGS", "ORIENTATION", oPc))
			DisplayGuiScreen(oPc, WAND_GUI_DMFI_H, FALSE, WAND_GUI_DMFI_H);
		else
			DisplayGuiScreen(oPc, WAND_GUI_DMFI_V, FALSE, WAND_GUI_DMFI_V);	
	}	
	else {
		if (STORE_SETTINGS
			&& GetCampaignInt("WAND_SETTINGS", "ORIENTATION", oPc))
			DisplayGuiScreen(oPc, WAND_GUI_H, FALSE, WAND_GUI_H);
		else
			DisplayGuiScreen(oPc, WAND_GUI_V, FALSE, WAND_GUI_V);	
	}		
}
// gui_name_enchanted_item
/*
	rename weapon user has just enchanted w/ the input string.
*/
// ChazM 5/24/06
// ChazM 5/31/06 Update to reflect where Item object is now stored
// ChazM 9/29/06 Just comments

#include "ginc_crafting"


void main( string sName )
{
	//PrettyDebug("gui_name_enchanted_item called!");
	// Item object is stored on the character which opened the GUI panel.
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oItem = GetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
	//PrettyDebug("gui_name_enchanted_item: oObj=" + GetName(oObj) + "| oItem=" + GetName(oItem)+ "| sName=" + sName);
	
	if ((sName != "") && (GetIsObjectValid(oItem)))
	{
		//PrettyDebug("setting new name!");
		SetFirstName(oItem, sName);
	}
//	else {PrettyDebug("NOT setting new name - either name is empty string or item object is invalid.");	}
	
	DeleteLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT);
}
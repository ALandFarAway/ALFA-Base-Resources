// 1sc_search_chest_low
/*
	Description:
	Goes on open of a container and fills it with random loot the first 
	time it is opened, the quality of the loot id defined by the values
	put into FillContainer() and scaled towards the first opener to
	determine in what level area the chest is placed in.
	
	If there is a container with the tag '1sc_unfound_loot' in the module
	then the loot will be hidden in that object;
	If so each opener must make a search check against the DC of each item
	hidden in the chest, in oder to reveal that item.
	Otherwise all generated loot will be available instantly, and the
	opening object will be inform that the script failed to hide the items.
*/
// System_Crush
// 23-7-07
#include "1sc_searchable"
#include "1sc_searchable_treasure"

void main()
	{
	
	if (!GetLocalInt(OBJECT_SELF,"searched")) {
		// This is the Low version of the loot script, it generates
		FillContainer(TREASURE_TYPE_LOW,TREASURE_TYPE_LOW,TREASURE_TYPE_LOW,TREASURE_TYPE_MED);
	}
	
	// Do a search check and show it to the openingobject
	int iCheck = d20(1);
	int iSkill = GetSkillRank(SKILL_SEARCH, GetLastOpenedBy(), FALSE);
	int iTotalDC = iCheck + iSkill;
	//SendMessageToPC(GetLastOpenedBy(), ("Searching container " + IntToString(iCheck) + 
	//									" + " + IntToString(iSkill) + 
	//									" = " +  IntToString(iTotalDC)));
	// Fill the chest with items that can be found with the 
	// DC that has been rolled							
	SearchChest(iTotalDC);
	SetLocalInt(OBJECT_SELF,"searched",1);

	}
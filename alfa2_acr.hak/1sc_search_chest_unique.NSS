// 1sc_search_chest_Unique
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
	// This is the Store version of the random loot script

	FillContainer(TREASURE_TYPE_HIGH,TREASURE_TYPE_UNIQUE,TREASURE_TYPE_UNIQUE,TREASURE_TYPE_MED);
	
	int iCheck = d20(1);
	int iSkill = GetSkillRank(SKILL_SEARCH, GetLastOpenedBy(), FALSE);
	//This function is now only for stores, which don't need to hide things for sale
	//So I've put a 100 bonus on the search check, so that nothing gets hidden
	int iTotalDC = iCheck + iSkill + 100;
	
	// Fill the store with items that can be found with the 
	// DC that has been rolled							
	SearchChest(iTotalDC);
	}
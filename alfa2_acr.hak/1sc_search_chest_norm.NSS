#include "1sc_searchable"
#include "1sc_searchable_treasure"

void main()
{
	// This is the normal version of the loot script, it generates
	// 37.5% Chance for items of Low quality
	// 50% chance of items of Low quality
	// 12.5% chance of items of High quality
	PL_UseChest(TREASURE_TYPE_LOW,TREASURE_TYPE_MED,TREASURE_TYPE_MED,TREASURE_TYPE_HIGH);
}

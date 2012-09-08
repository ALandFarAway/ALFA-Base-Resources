#include "1sc_searchable"
#include "1sc_searchable_treasure"

void main()
{
	// This is the High version of the loot script, it generates
	// 37.5% Chance for items of High quality
	// 25% chance of items of Unique quality
	// 25% chance of items of Normal quality
	// 12.5% chance of items of Low quality
	PL_UseChest(TREASURE_TYPE_HIGH,TREASURE_TYPE_UNIQUE,TREASURE_TYPE_MED,TREASURE_TYPE_LOW);
}

#include "1sc_searchable"
#include "1sc_searchable_treasure"

void main()
{
	// This is the Low version of the loot script, it generates
	// 12.5% chance of medium quality
	// 87.5% chance of low quality
	PL_UseChest(TREASURE_TYPE_LOW,TREASURE_TYPE_LOW,TREASURE_TYPE_LOW,TREASURE_TYPE_MED);
}

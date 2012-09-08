// 1sc_searchable
/*

	Description:
	This is the function base for the searchable chests
	It contains.
	* int getNumItemsInContainer(object oContainer)
	* int getNumItemsInContainer(object oContainer)
	* int getItemSize(object oItem)
	* void FillContainer(int iChance37, int iChance25one, int iChance25two, int iChance12)
	* void SearchChest(int SearchDC)
	
	The first 3 are useable in other scripts for whatever 
	anyone might need them for.
	FillContainer and SearchChest func1sc_unfound_loottion only on the calling object
	because of the function GetLastOpener() only being usable from the
	container.
	
	Usage:
	Add the following scripts to any container(including shops) and it 
	Will fill up with random loot scaled towards the first opener.
	
	If there is a container with the tag '' in the module
	then the loot will be hidden in that object;
	When loot is hidden each opener must make a search check against the
	DC to find the item in order to reveal it in the chest.
	When damaging a chest with items hidden in it the amount of damage
	dealth counts as the searchcheck to destroy the item.
	
	Put the scripts on the container this way
	Into the 'On Open' event:	 1sc_search_chest_<ANY>
	Into the 'On Damaged' event: 1sc_search_dmgd_<ANY>
	Into the 'On Death' event: 	 1sc_search_destroyed
	
	the <ANY> is ofcource replaced by med, high, low or unique
	depending on what kind of loot you wnat to be in the chest.
	
	Adaptability:
	THe main adaptable function is changing how hard or easy
	it is to find items in searchable containters.
	Change:
	int LEAST_ITEMS_FINDABLE = 8;
	Into any value more than 0 to change this.
	High values will make it easy to find many items
	Low values will reduce the amount of loot found.
	
	Also you can make your own 'On Open' and 'On Damaged' script
	changing the values in FillContainer(<1>,<2>,<3>,<4>) to have
	a higher or lower chance for specific types of loot that the basic ones I provided
	<1> has 37.5% chance per item in the container
	<2> has a 25% chance per item in the container
	<3> also has 25% chance per item in the container
	<4> has 12.5% chance per item in the container
	
	Thes can be filled with constants for loot types from x0_i0_treasure
	TREASURE_TYPE_MONSTER
	TREASURE_TYPE_LOW
	TREASURE_TYPE_MED
	TREASURE_TYPE_HIGH
	TREASURE_TYPE_UNIQUE
			

*/
// System_Crush
// 5-8-07

//  Revision History
//    2009-12-28  Wynna: Adapted to existing ALFA stores to provide random loot in stores
//
#include "1sc_searchable_treasure"



int ITEM_SIZE_HUGE = 0;
int ITEM_SIZE_LARGE = 1;
int ITEM_SIZE_BIG = 2;
int ITEM_SIZE_NORM = 3;
int ITEM_SIZE_SMALL = 4;
int ITEM_SIZE_TINY = 5;

int LEAST_ITEMS_FINDABLE = 2;


/*
	counts the number of objects in the inventory of oContainer
*/
int getNumItemsInContainer(object oContainer)
	{
	if ((GetIsObjectValid(oContainer) == FALSE) || (GetHasInventory(oContainer) == FALSE))
		{
		SpeakString("ERROR with 1sc_search_chest: Can't count items in targets inventory");
		// this my be because the target does not exist or because the target is not a
		// container or shop or creature with a valid inventory
		return 0 ;
		}
	int iToReturn = 0;
	object oCurrentItem = GetFirstItemInInventory(oContainer);
	if(GetIsObjectValid(oCurrentItem))
		{
		iToReturn = 1;
		oCurrentItem = GetNextItemInInventory(oContainer);
		}
	while(GetIsObjectValid(oCurrentItem))
		{
		iToReturn = iToReturn + 1;
		oCurrentItem = GetNextItemInInventory(oContainer);
		}
		return iToReturn;
	}

/*
	Returns an int for the size
	of oItem.
	Representing the ease with
	which oItem can be hidden.
	(this seperates thin items
	to be easyer hidden, so not
	all values may be equivalant
	to the actual parameter of
	size on the item)
*/
int getItemSize(object oItem)
	{
	switch (GetBaseItemType(oItem))
		{
		// ITEM_SIZE_HUGE = 0;
		case BASE_ITEM_DIREMACE:
		case BASE_ITEM_FALCHION:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_GREATCLUB:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_HEAVYFLAIL:
		case BASE_ITEM_SCYTHE:
		case BASE_ITEM_TOWERSHIELD:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_WARMACE:
			{
			return 0;
			break;
			}
		// ITEM_SIZE_LARGE = 1;
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_FLAIL:
		case BASE_ITEM_HEAVYCROSSBOW:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_LONGBOW:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_MACE:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SPEAR:
			{
			return 1;
			break;
			}
		// ITEM_SIZE_BIG = 2;
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_LIGHTCROSSBOW:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_MANDOLIN:
		case BASE_ITEM_MISCTALL:
		case BASE_ITEM_MISCWIDE:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SHORTBOW:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_THROWINGAXE:
			{
			return 2;
			break;
			}
		// ITEM_SIZE_NORM = 3;
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_CLOAK:
		case BASE_ITEM_CLUB:
		case BASE_ITEM_DRUM:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_TORCH:
		case BASE_ITEM_TRAPKIT:
			{
			return 3;
			break;
			}
		// ITEM_SIZE_SMALL = 4;
		case BASE_ITEM_AMULET:
		case BASE_ITEM_ARROW:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOLT:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_BLANK_SCROLL:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_WAND:
		case BASE_ITEM_ENCHANTED_SCROLL:
		case BASE_ITEM_SCROLL:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_THIEVESTOOLS:
			{
			return 4;
			break;
			}
		// ITEM_SIZE_TINY = 5;
		case BASE_ITEM_BULLET:
		case BASE_ITEM_DART:
		case BASE_ITEM_GEM:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_RING:
		case BASE_ITEM_SHURIKEN:
		case BASE_ITEM_SLING:
			{
			return 5;
			break;
			}
		}
		// else
		return 1;
	}

/*
	generate a number of random items in the calling container.
	this will not always result in <LEAST_ITEMS_FINDABLE> items,
	at times there may be 1 or 2 items too many; because they are
	generated in batches of 1-3.
	but it will always be at least <LEAST_ITEMS_FINDABLE>
	May generate up to 2 items over,
	and can generate gold.
	
	Note: Something in the FillContainer functions duplicates each generated item. Can't find it.
	      I adjust for it after by only recording uniquely named items as findable, and destroying
		  duplicates at the end of the FillContainer function
*/	
void FillContainer(int iChance37, int iChance25one, int iChance25two, int iChance12)
	{object oArea = GetArea(OBJECT_SELF);
	 object oPC = GetLastOpenedBy();
	// Will wait between 1/2 and 25 hrs before allowing random population of store, then refill
	// at new random interval between 1/4 and 25 hours, as long as server stays up 
	if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_STORE)
		{SetLocalString(oArea, "Store" + GetTag(OBJECT_SELF), GetTag(OBJECT_SELF));
		 string sStoreTag = GetLocalString(oArea, "Store" + GetTag(OBJECT_SELF));
		 if(GetLocalInt(oArea, sStoreTag + "iDelay") == 1)
		 	{return;
			}
		 SetLocalObject(oArea, "Store" + sStoreTag, OBJECT_SELF);
		 object oStore = GetLocalObject(oArea, "Store" + sStoreTag);
		 int iPop = Random(43200) + 900;
		 int iPopMin = iPop/60;
		 int iPopHr = abs(iPopMin/60);
		 int iSecLeft = iPop - (iPopHr * 3600);
		 int iMinLeft = iSecLeft/60;
		 if(GetLocalInt(oArea, sStoreTag + "iDelay") == 0)
		 	{SetLocalInt(oArea, sStoreTag + "iDelay", 1);
		 	 //AssignCommand(oArea, SendMessageToAllDMs(sStoreTag + " can populate bonus items no sooner than " + IntToString(iPopHr) + " hr and " + IntToString(iMinLeft) + " min from now")); 
			 AssignCommand(oArea, DelayCommand(IntToFloat(iPop), SetLocalInt(oArea, sStoreTag + "iDelay", 2)));
			 //AssignCommand(oArea, DelayCommand(IntToFloat(iPop), SendMessageToAllDMs(sStoreTag + " able to randomly populate bonus items."))); 
			 return;
			 }
		 if(GetLocalInt(oArea, sStoreTag + "iDelay") == 2)
		 	{SetLocalInt(oArea, sStoreTag + "iDelay", 1);
		 	 AssignCommand(oArea, DelayCommand(IntToFloat(iPop), SetLocalInt(oArea, sStoreTag + "iDelay", 2)));
			 //AssignCommand(oArea, DelayCommand(IntToFloat(iPop), SendMessageToAllDMs(sStoreTag + " ripe to randomly populate bonus items."))); 
			 //AssignCommand(oArea, SendMessageToAllDMs(sStoreTag + " will repopulate no sooner than " + IntToString(iPopHr) + " hr and " + IntToString(iMinLeft) + " min from now")); 
			 }
		 }
		
		 else if(GetObjectType(OBJECT_SELF) != OBJECT_TYPE_STORE)
		 	{if(GetLocalInt(OBJECT_SELF, "Filled") != 1)
				{SetLocalInt(OBJECT_SELF, "Filled", 1);
				}
			 else
			 	{return;
				}
			}
			
					 
	//Retain current inventory
	
	object oInventoryPlot = GetFirstItemInInventory(OBJECT_SELF);
	while (oInventoryPlot != OBJECT_INVALID)
		{SetPlotFlag(oInventoryPlot, TRUE);
		 oInventoryPlot = GetNextItemInInventory(OBJECT_SELF);
		}
		
	
	// generate an amount of random treasure from the appropriate treasure chest
	// First will check for master Low/Med/High/Unique(Store) chest in area, then default to master chests in Admin area
	int iInc = 1;
 	while (iInc <= LEAST_ITEMS_FINDABLE)
		{switch  (Random(8))
			{case 0:
				CTG_CreateTreasure(iChance37, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
				
			 case 1:
			 	CTG_CreateTreasure(iChance25one, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
			
			case 2:
			 	CTG_CreateTreasure(iChance25two, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
		
			case 3:
			 	CTG_CreateTreasure(iChance12, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
				
			case 4:
				CTG_CreateTreasure(iChance37, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
				
			 case 5:
				CTG_CreateTreasure(iChance37, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
				
			 case 6:
			 	CTG_CreateTreasure(iChance25one, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				
			case 7:
			 	CTG_CreateTreasure(iChance25two, GetLastOpenedBy(), OBJECT_SELF);
		 		CTG_SetIsTreasureGenerated(OBJECT_SELF, FALSE);
				break;
		
			default:
			break;		
			}
	
	
		iInc++;
		}
 	
		
	object oLootStorage = GetObjectByTag("1sc_unfound_loot");
	// if there is no place to temporarily put the items
	// don't put them anywhere.
	if ((GetIsObjectValid(oLootStorage) == FALSE) || (GetHasInventory(oLootStorage) == FALSE))
		{
		return;
		}
	
	int iCurrentItem;
	object oCurrentItem = GetFirstItemInInventory(OBJECT_SELF);
	object oPreviousItem;
	   while(GetIsObjectValid(oCurrentItem))
		{// if it's a plot item don't worry about it
		if (GetPlotFlag(oCurrentItem) == FALSE)
			{ 			
	
	//Function to filter out inappropriate items from shared master chests, providing only appropriate items as per store/container type
	//StoreTypes: 
	//0 == Nothing filtered out. 
	//1 == Melee Weapons
	//2 == Ranged Weapons and ammo
	//3 == All Weapons
	//4 == Metal Armor & Metal Weapons
	//5 == All Armor
	//6 == All Armor & All Weapons
	//7 == Leathers & Hides
	//8 == Jewelry & Gems & Treasures of Precious Materials
	//9 == Alchemists (Potions & Liquid Grenades)
	//10 == Scrolls & Books
	//11 == Wands/Staves/Rods/Wondrous Items
	//12 == All magic
	//13 == Gear
	//14 == Clothing
	//15 == Tavern & Gear
	//16 == Bardic (Books, Scrolls, Minor Potions, Instruments)
	//17 == Dwarven Weapons & Armor
	//18 == General Stores: Basic items of all kinds
	//19 == Leathers, Hides & Clothing
	//20 == Fence (Minor treasures and magics)
	//99 == Nothing added of any kind, ever, from any chest
	
				
	int iAppropriate;
	switch (GetLocalInt(OBJECT_SELF, "ACR_STORE_TYPE"))
				//0 == default. No variable. Nothing filtered out.
				{case 0:
					iAppropriate = 1;
					break;
					
				//1 == Melee Weapons
		         case 1:
		            switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_DIREMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FALCHION:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATCLUB:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HALBERD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCYTHE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BASTARDSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DWARVENWARAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KATANA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MORNINGSTAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_QUARTERSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCIMITAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPEAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RAPIER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KAMA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KUKRI:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SICKLE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHURIKEN:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					break;
					
				//2 == Ranged Weapons and ammo
		        case 2:
				  switch (GetBaseItemType(oCurrentItem))
					
					   {case BASE_ITEM_HEAVYCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SLING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARROW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BULLET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DART:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOLT:
						iAppropriate = 1;
						break;
						default:
						break;
						}
							
		        break;
		        //3 == All Weapons
				case 3:
		             switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DIREMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FALCHION:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATCLUB:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HALBERD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCYTHE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BASTARDSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DWARVENWARAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KATANA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MORNINGSTAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_QUARTERSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCIMITAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPEAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RAPIER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KAMA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KUKRI:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SICKLE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHURIKEN:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SLING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARROW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BULLET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DART:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOLT:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					break;
						
				
				//4 == Metal Armor & Metal Weapons
				case 4:
		             switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_DIREMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FALCHION:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HALBERD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCYTHE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BASTARDSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DWARVENWARAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KATANA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MORNINGSTAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCIMITAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RAPIER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KAMA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KUKRI:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SICKLE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHURIKEN:
						iAppropriate = 1;
						break;
						case BASE_ITEM_TOWERSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARMOR:
						switch (GetArmorRank(oCurrentItem))
							{case 2:
							iAppropriate = 1;
							break;
							case 3:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						switch (FindSubString(GetName(oCurrentItem), "Chain"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_HELMET:
						switch (FindSubString(GetName(oCurrentItem), "Helm"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_SMALLSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LARGESHIELD:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					break;
						
					//5 == All Armor
					case 5:
		             switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_TOWERSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARMOR:
						switch (GetArmorRank(oCurrentItem))
						   {case 1:
							iAppropriate = 1;
							break;
							case 2:
							iAppropriate = 1;
							break;
							case 3:
							iAppropriate = 1;
							break;
							default:
							break;
							}
						break;
						case BASE_ITEM_HELMET:
						switch (FindSubString(GetName(oCurrentItem), "Helm"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_SMALLSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LARGESHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BELT:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GLOVES:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOOTS:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BRACER:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					break;
					
				//6 == All Armor & All Weapons
				case 6:
		            if(GetGoldPieceValue(oCurrentItem) < 2000)
					 {switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DIREMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FALCHION:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATCLUB:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HALBERD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCYTHE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BASTARDSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DWARVENWARAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KATANA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MORNINGSTAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_QUARTERSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCIMITAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPEAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RAPIER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KAMA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KUKRI:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SICKLE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHURIKEN:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SLING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARROW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BULLET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DART:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOLT:
						iAppropriate = 1;
						break;
						case BASE_ITEM_TOWERSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARMOR:
						switch (GetArmorRank(oCurrentItem))
						   {case 1:
							iAppropriate = 1;
							break;
							case 2:
							iAppropriate = 1;
							break;
							case 3:
							iAppropriate = 1;
							break;
							default:
							break;
							}
						break;
						case BASE_ITEM_HELMET:
						switch (FindSubString(GetName(oCurrentItem), "Helm"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_SMALLSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LARGESHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BELT:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GLOVES:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOOTS:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BRACER:
						iAppropriate = 1;
						break;
						default:
						break;
						}	
					}	
					break;
					
					//7 == Leathers & Hides
					case 7:
					switch (GetBaseItemType(oCurrentItem))
						
					   {	case BASE_ITEM_BELT:
							iAppropriate = 1;
							break;
							case BASE_ITEM_GLOVES:
							iAppropriate = 1;
							break;
							case BASE_ITEM_BOOTS:
							iAppropriate = 1;
							break;
							case BASE_ITEM_BRACER:
							iAppropriate = 1;
							break;
							default:
							break;
							}	
						
					switch (FindSubString(GetName(oCurrentItem), "eather"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
							iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
							iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
							iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
						}
					
						switch (FindSubString(GetName(oCurrentItem), "hide"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
							iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
							iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
							iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
						}
						
						switch (FindSubString(GetName(oCurrentItem), "Skin"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
							iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
							iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
							iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
						}
				break;
					
					
					
				//8 == Jewelry & Gems & Mundane Precious Material Items
				case 8:
		            switch (GetBaseItemType(oCurrentItem))
					
					{	case BASE_ITEM_AMULET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GEM:
						iAppropriate = 1;
						break;
						default:
						break;
						}		
					
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_tr_"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					switch (FindSubString(GetName(oCurrentItem), "Pearl of Power"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					break;
					
				//9 == Alchemists (Potions & Liquid Grenades)
				case 9:
		           switch (FindSubString(GetTag(oCurrentItem), "abr_it_mpotion"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					switch (GetBaseItemType(oCurrentItem))
					
						{case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}
								
					break;
					
				//10 == Scrolls & Books
				case 10:
		              switch (GetBaseItemType(oCurrentItem))
					
						{case BASE_ITEM_SPELLSCROLL:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}
					switch (FindSubString(GetTag(oCurrentItem), "book"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}	
				break;
					
					//11 == Wands/Staves/Rods/Wondrous Items
				case 11:
		             switch (GetBaseItemType(oCurrentItem))
					
					{	case BASE_ITEM_MAGICROD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICWAND:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BLANK_WAND:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MISCTHIN:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_ms_"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					break;
					
				//12 == All magic
				case 12:
		             if(GetGoldPieceValue(oCurrentItem) < 2000)
					 { switch (GetBaseItemType(oCurrentItem))
					
					{	case BASE_ITEM_MAGICROD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICWAND:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BLANK_WAND:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPELLSCROLL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_AMULET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}
						
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_mpotion"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_ms_"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					}		
					break;
					
				//13 == Gear
				case 13:
		             switch (FindSubString(GetTag(oCurrentItem), "abr_it_gr_"))
					{ 
						case 0:
						iAppropriate = 1;
						break;
						
						case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}
									
					break;
					
				//14 == Clothing
				case 14:
		             switch (FindSubString(GetName(oCurrentItem), "obes"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						
					 switch (FindSubString(GetName(oCurrentItem), "arb"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					 switch (FindSubString(GetName(oCurrentItem), "loth"))
					{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					switch (FindSubString(GetName(oCurrentItem), "Hat"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Turban"))
					{ 	case 0:
						iAppropriate = 1;
						break;
						
						case 6:
						iAppropriate = 1;
						break;
						default:
						break;
						}
										
					switch (FindSubString(GetName(oCurrentItem), "Cap"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetTag(oCurrentItem), "Tunic"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Cloak"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Outfit"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Vest"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					break;
				//15 == Tavern
				case 15:
		             switch (GetBaseItemType(oCurrentItem))
					{	case BASE_ITEM_BLANK_POTION:
						iAppropriate = 1;
						break;
						
						case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}
						
					 switch (FindSubString(GetTag(oCurrentItem), "abr_it_gr_"))
					{ 	case 0:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}		
					 switch (FindSubString(GetTag(oCurrentItem), "food"))
					{ 	case 6:
						iAppropriate = 1;
						break;
						
						case 9:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}		
							
					break;
					
				//16 == Bardic
				case 16:
		             switch (GetBaseItemType(oCurrentItem))
						{case BASE_ITEM_DRUM:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLUTE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MANDOLIN:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPELLSCROLL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}		
						
					switch (FindSubString(GetName(oCurrentItem), "Potion"))
							{case 0:
							iAppropriate = 1;
							break;
							default:
							break;
							}
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_gr_"))
						{case 0:
						iAppropriate = 1;
						break;
						
						default:
						break;
						}	
					break;
					
			//17 == Dwarven Armor & Weapons
				case 17:
		             switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_HEAVYCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SLING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BULLET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DART:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOLT:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DIREMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FALCHION:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GREATSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HALBERD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HEAVYFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCYTHE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BASTARDSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DWARVENWARAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_FLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KATANA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MORNINGSTAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SCIMITAR:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTFLAIL:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RAPIER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KAMA:
						iAppropriate = 1;
						break;
						case BASE_ITEM_KUKRI:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SICKLE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHURIKEN:
						iAppropriate = 1;
						break;
						case BASE_ITEM_TOWERSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARMOR:
						switch (GetArmorRank(oCurrentItem))
							{case 2:
							iAppropriate = 1;
							break;
							case 3:
							iAppropriate = 1;
							break;
							default:
							break;
							}
						switch (FindSubString(GetName(oCurrentItem), "Chain"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_HELMET:
						switch (FindSubString(GetName(oCurrentItem), "Helm"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_SMALLSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LARGESHIELD:
						iAppropriate = 1;
						break;
						default:
						break;
						}
						
					break;
						
		//18 == Frontier Stores: Basic items of all kinds
				case 18:
		        	switch (FindSubString(GetName(oCurrentItem), "Potion"))
							{case 0:
							switch(FindSubString(GetName(oCurrentItem), "Potion of Cure Light"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion of Cure Moderate"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, A"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, B"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, Ca"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, Ea"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, F"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
							switch(FindSubString(GetName(oCurrentItem), "Potion, Ow"))
									{case 0:
									iAppropriate = 1;
									break;
									
									default:
									break;
									}
									
						break;
									 
						default:
						break;
						}
					
				   switch (GetBaseItemType(oCurrentItem))
						
					   {case BASE_ITEM_GRENADE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTCROSSBOW:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SLING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BULLET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BOLT:
						iAppropriate = 1;
						break;
						case BASE_ITEM_WARHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_BATTLEAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LONGSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_HANDAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTHAMMER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LIGHTMACE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SHORTSWORD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_THROWINGAXE:
						iAppropriate = 1;
						break;
						case BASE_ITEM_DAGGER:
						iAppropriate = 1;
						break;
						case BASE_ITEM_ARMOR:
							switch (GetArmorRank(oCurrentItem))
								{case 2:
								iAppropriate = 1;
								break;
								case 1:
								iAppropriate = 1;
								break;
								default:
								break;
								}
						break;
						case BASE_ITEM_HELMET:
						switch (FindSubString(GetName(oCurrentItem), "Helm"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						break;
						case BASE_ITEM_SMALLSHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_LARGESHIELD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPELLSCROLL:
							switch(FindSubString(GetTag(oCurrentItem), "abr_scroll_0"))
								   {case 0:
									iAppropriate = 1;
									break;
										
									default:
									break;
									}
							switch(FindSubString(GetTag(oCurrentItem), "abr_scroll_1"))
								   {case 0:
									iAppropriate = 1;
									break;
										
									default:
									break;
									}
					   break;
					   
					   default:
					   break;
					   }
					   
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_gr_"))
								{case 0:
								iAppropriate = 1;
								break;
								
								default:
								break;
								}	
					break;
													
		//19 == Leathers & Hides & Clothing
					case 19:
						switch (FindSubString(GetName(oCurrentItem), "obes"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
						
					 switch (FindSubString(GetName(oCurrentItem), "arb"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					 switch (FindSubString(GetName(oCurrentItem), "loth"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					switch (FindSubString(GetName(oCurrentItem), "Hat"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Turban"))
							{ 
							case 0:
							iAppropriate = 1;
							break;
							
							case 6:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Cap"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetTag(oCurrentItem), "Tunic"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Cloak"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Outfit"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
										
					switch (FindSubString(GetName(oCurrentItem), "Vest"))
							{case 0:
							iAppropriate = 1;
							break;
							
							case 1:
							iAppropriate = 1;
							break;
							
							case 2:
							iAppropriate = 1;
							break;
							
							case 3:
							iAppropriate = 1;
							break;
							
							case 4:
							iAppropriate = 1;
							break;
							
							case 5:
						    iAppropriate = 1;
							break;
								
							case 6:
							iAppropriate = 1;
							break;
								
							case 7:
							iAppropriate = 1;
							break;
							
							case 8:
							iAppropriate = 1;
							break;
							
							case 9:
							iAppropriate = 1;
							break;
							
							case 10:
							iAppropriate = 1;
							break;
							
							case 11:
							iAppropriate = 1;
							break;
							
							case 12:
							iAppropriate = 1;
							break;
							
							case 13:
							iAppropriate = 1;
							break;
							
							case 14:
							iAppropriate = 1;
							break;
							
							case 15:
						    iAppropriate = 1;
							break;
								
							case 16:
							iAppropriate = 1;
							break;
								
							case 17:
							iAppropriate = 1;
							break;
							
							case 18:
							iAppropriate = 1;
							break;
							
							case 19:
							iAppropriate = 1;
							break;
							
							case 20:
							iAppropriate = 1;
							break;
							
							case 21:
							iAppropriate = 1;
							break;
							
							case 22:
						    iAppropriate = 1;
							break;
							
							case 23:
							iAppropriate = 1;
							break;
							
							case 24:
							iAppropriate = 1;
							break;
							
							case 25:
							iAppropriate = 1;
							break;
								
							case 26:
							iAppropriate = 1;
							break;
								
							case 27:
							iAppropriate = 1;
							break;
							
							case 28:
							iAppropriate = 1;
							break;
							
							case 29:
							iAppropriate = 1;
							break;
							
							case 30:
							iAppropriate = 1;
							break;
							
							case 31:
							iAppropriate = 1;
							break;
							
							case 32:
							iAppropriate = 1;
							break;
							
							case 33:
							iAppropriate = 1;
							break;
							
							case 34:
							iAppropriate = 1;
							break;
							
							case 35:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
							
					switch (GetBaseItemType(oCurrentItem))
						
					   {	case BASE_ITEM_BELT:
							iAppropriate = 1;
							break;
							case BASE_ITEM_GLOVES:
							iAppropriate = 1;
							break;
							case BASE_ITEM_BOOTS:
							iAppropriate = 1;
							break;
							case BASE_ITEM_BRACER:
							iAppropriate = 1;
							break;
							default:
							break;
							}	
				break;
			
		//20 == Fence (Minor treasures & Magics)		
				
			case 20:
				
			switch (GetBaseItemType(oCurrentItem))
					
					{	case BASE_ITEM_AMULET:
						iAppropriate = 1;
						break;
						case BASE_ITEM_RING:
						iAppropriate = 1;
						break;
						case BASE_ITEM_GEM:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICROD:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICWAND:
						iAppropriate = 1;
						break;
						case BASE_ITEM_MAGICSTAFF:
						iAppropriate = 1;
						break;
						case BASE_ITEM_SPELLSCROLL:
						iAppropriate = 1;
						break;
						
						
						default:
						break;
						}		
					
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_mpotion"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
					
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_tr_"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
							
					switch (FindSubString(GetTag(oCurrentItem), "abr_it_ms_"))
							{ 
				     		case 0:
							iAppropriate = 1;
							break;
							
							default:
							break;
							}
				
			break;
		//99 == Nothing ever added
					case 99:
					iAppropriate = 0;
					break;
					
					
		default:
		break;
		}			
			
			object oCopiedItem;
			int iItemStack;
			int iAllowed;
			oCopiedItem = CopyItem(oCurrentItem, oLootStorage, TRUE);
			iItemStack = GetItemStackSize(oCurrentItem);
			// if the base item type is appropriate to the store and it's not a duplicate 
			// set it as a local findable object
		   if((iAppropriate == 1) && (GetName(oCurrentItem) != (GetName(oPreviousItem))))
				   {if((GetLocalInt(OBJECT_SELF, "Size") != 1) || (getItemSize(oCurrentItem) > 2))
					   {if((GetBaseItemType(oCurrentItem) == BASE_ITEM_ARROW) ||(GetBaseItemType(oCurrentItem) == BASE_ITEM_BOLT)||(GetBaseItemType(oCurrentItem) == BASE_ITEM_BULLET))
							{SetItemStackSize(oCurrentItem, (Random(19) + 1));
							 iItemStack = GetItemStackSize(oCurrentItem);
							 SetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentItem)), iItemStack);
							}
						if((FindSubString(GetName(oCurrentItem), "Potion") != -1) || (GetBaseItemType(oCurrentItem) == BASE_ITEM_POTIONS) || (GetBaseItemType(oCurrentItem) == BASE_ITEM_ENCHANTED_POTION) || (GetBaseItemType(oCurrentItem) == BASE_ITEM_SPELLSCROLL)|| (GetBaseItemType(oCurrentItem) == BASE_ITEM_BLANK_POTION)|| (GetBaseItemType(oCurrentItem) == BASE_ITEM_GRENADE))
							{SetItemStackSize(oCurrentItem, 1);
							 SetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentItem)), 1);
							}
						if(GetBaseItemType(oCurrentItem) == BASE_ITEM_GOLD)
							{SetItemStackSize(oCurrentItem, (Random(100)));
							 iItemStack = GetItemStackSize(oCurrentItem);
							 SetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentItem)), iItemStack);
							}
						if(GetBaseItemType(oCurrentItem) == BASE_ITEM_GEM)
							{SetItemStackSize(oCurrentItem, (Random(5) + 1));
							 iItemStack = GetItemStackSize(oCurrentItem);
							 SetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentItem)), iItemStack);
							}
						else
							{
							 SetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentItem)), 1);
							}
						// calculate how well the item is hidden & cache both DC and object 
						int iHideAttempt = (d8(1)); // 0-7 for how well the item was hidden
						int iItemSize = getItemSize(oCopiedItem); // 0-5 how easy it is to hide that item
						int iSearchDC = iHideAttempt * iItemSize; // 0-35 for the DC of the search check			
						SetLocalInt(OBJECT_SELF, ("item_dc" + IntToString(iCurrentItem)), iSearchDC);
						SetLocalObject(OBJECT_SELF, "findable_item" + IntToString(iCurrentItem), oCopiedItem);
						if((GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE) && (getItemSize(oCurrentItem) < 3) && (GetLocalInt(OBJECT_SELF, "Size") != 1))
							{SetLocalInt(OBJECT_SELF, "Size", 1);
							}
						iAppropriate = 0;
						iCurrentItem = iCurrentItem + 1;
						}
					else if(GetLocalInt(OBJECT_SELF, "Size") == 1)
						{SetLocalString(OBJECT_SELF, GetName(oCurrentItem), GetName(oCurrentItem));
						 DelayCommand(10.0, SetLocalString(OBJECT_SELF, GetName(oCurrentItem), GetName(oCurrentItem)));
						}
					}
			if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_STORE)
				{DestroyObject(oCurrentItem);
				}
			//Fix for non-populating stackables in containers. Gold is a default content for otherwise empty containers, so don't destroy it, either.
			if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
				{if((GetBaseItemType(oCurrentItem) != BASE_ITEM_GOLD) && (GetBaseItemType(oCurrentItem) != BASE_ITEM_GEM)&& (GetBaseItemType(oCurrentItem) != BASE_ITEM_SPELLSCROLL) && (FindSubString(GetName(oCurrentItem), "Potion") == -1)&& (GetBaseItemType(oCurrentItem) != BASE_ITEM_BLANK_POTION))
					{DestroyObject(oCurrentItem);
					}
				}
			}
		oPreviousItem = oCurrentItem;
		oCurrentItem = GetNextItemInInventory(OBJECT_SELF);
		}	
			
	SetLocalInt(OBJECT_SELF, "findable_items", iCurrentItem);
	
	//Reset all inventory to non Plot
	object oInventoryFinal = GetFirstItemInInventory(OBJECT_SELF);
	object oPrevious;
	while (oInventoryFinal != OBJECT_INVALID)
		{SetPlotFlag(oInventoryFinal, FALSE);
		 oPrevious = oInventoryFinal;
		 oInventoryFinal = GetNextItemInInventory(OBJECT_SELF);
		}
	
}	
	
	
void SearchChest(int SearchDC)
	{
	// compare the given SearchDC against the DC required to find 
	// each item in the container.
	int iCurrentSearchFor;
	int iFindableItems = 1 + GetLocalInt(OBJECT_SELF, "findable_items");
	object oFoundItem;
	object oShownItem;
	int iStackSize;
	while(iCurrentSearchFor < iFindableItems)
		{int iCurrentItemDC = GetLocalInt(OBJECT_SELF, ("item_dc" + IntToString(iCurrentSearchFor)));
		if(iCurrentItemDC <= SearchDC )
			{
			oFoundItem = GetLocalObject(OBJECT_SELF, ("findable_item" + IntToString(iCurrentSearchFor)));
			oShownItem = CopyItem(oFoundItem,OBJECT_SELF,TRUE);
			iStackSize = GetLocalInt(OBJECT_SELF, ("item_stack" + IntToString(iCurrentSearchFor)));
			if(iStackSize > 1) 
				{SetItemStackSize(oShownItem, iStackSize);}
			else
				{SetItemStackSize(oShownItem, 1);}
			if((GetObjectType(OBJECT_SELF) == OBJECT_TYPE_STORE) && (GetName(oShownItem) != "") && (GetLocalString(OBJECT_SELF, GetName(oShownItem)) != GetName(oShownItem)))
				{SetLocalString(OBJECT_SELF, GetName(oShownItem), GetName(oShownItem));
				 DelayCommand(10.0, SetLocalString(OBJECT_SELF, GetName(oShownItem), ""));
				 //SendMessageToAllDMs(GetName(GetLastOpenedBy()) + " populates "  + GetTag(OBJECT_SELF) + " with " + IntToString(GetItemStackSize(oShownItem)) + " " + GetName(oShownItem) + "/" + GetTag(oShownItem));
				}
			
			DestroyObject(oFoundItem);
			if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE)
				{
				SetLocalInt(OBJECT_SELF, ("item_dc" + IntToString(iCurrentSearchFor)), 999);
				} 
			}
		iCurrentSearchFor = iCurrentSearchFor + 1;
		}
	 
	 if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE) 
		 {object oPhatLewt = GetFirstItemInInventory(OBJECT_SELF);
		  while(oPhatLewt != OBJECT_INVALID)
		 	{if((FindSubString(GetName(oPhatLewt), "Potion") != -1)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_POTIONS) || (GetBaseItemType(oPhatLewt) == BASE_ITEM_ENCHANTED_POTION)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_SPELLSCROLL)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_BLANK_POTION)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_GRENADE))
					{SetItemStackSize(oPhatLewt, 1);
					 }
			 if((GetBaseItemType(oPhatLewt) == BASE_ITEM_ARROW) || (GetBaseItemType(oPhatLewt) == BASE_ITEM_BOLT)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_BULLET)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_DART)|| (GetBaseItemType(oPhatLewt) == BASE_ITEM_SHURIKEN))
					{SetItemStackSize(oPhatLewt, Random(20) + 1);
					 }
			 SendMessageToAllDMs(GetName(GetLastOpenedBy()) + " opens "  + GetTag(OBJECT_SELF) + " with " + IntToString(GetItemStackSize(oPhatLewt)) + " " + GetName(oPhatLewt) + "/" + GetTag(oPhatLewt));
			 oPhatLewt = GetNextItemInInventory(OBJECT_SELF);
			}	
		}
	}


void PL_UseChest(int t0, int t1, int t2, int t3)
{
	object oPC = GetLastOpenedBy(), self = OBJECT_SELF;
	string sTag = "SC_CHECK_" + ObjectToString(oPC);	

	if (GetLocalInt(self, sTag))
		return;

	if (!GetLocalInt(self,"searched")) {
	
		FillContainer(t0, t1, t2, t3);
	}
	// Do a search check and show it to the openingobject
	int iCheck = d20(1);
	int iSkill = GetSkillRank(SKILL_SEARCH, oPC, FALSE);
	int iTotalDC = iCheck + iSkill;

	//SendMessageToPC(oPC, ("Searching container " + IntToString(iCheck) + 
	//							" + " + IntToString(iSkill) + 
	//							" = " +  IntToString(iTotalDC)));
	
	// Fill the chest with items that can be found with the 
	// DC that has been rolled							
	SearchChest(iTotalDC);
	SetLocalInt(self,"searched",1);
	SetLocalInt(self, sTag, 1);
}

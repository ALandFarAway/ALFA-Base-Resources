// gp_treasure_op_de
/*
    Spawns in general purpose treasure and gold based on variables:

	TreasureClass - one of three values.  Default is low
		const int X2_DTS_CLASS_NONE    = -1;      //Treasure Class None (generate nothing)
		const int X2_DTS_CLASS_LOW     = 0;       //Treasure Class Low
		const int X2_DTS_CLASS_MEDIUM  = 1;       //Treasure Clas Medium
		const int X2_DTS_CLASS_HIGH    = 2;       //Treasure Class High

	TreasureType - add desired types together.  For example, gold + disposable = 5
		Defualt is 5 (gold + disp)
		Note that you cannot add the same type more than once (i.e. no gold+gold).
		const int X2_DTS_TYPE_DISP 	= 1;
		const int X2_DTS_TYPE_AMMO	= 2;
		const int X2_DTS_TYPE_GOLD	= 4;       	// actually gold and gems
		(not allowed) const int X2_DTS_TYPE_ITEM	= 8;        // char specific Item (ignores treasure class)
		const int X2_DTS_TYPE_MAGIC	= 16;       // random magic items
		const int X2_DTS_TYPE_MUNDANE = 32;     // random mundane items

	This script should be placed in the container's OnOpen and OnDeath events.
	If bashed, disposeable will be dropped and broken item generated.
	If no treasures are generated, 1d20 gold will be created.
*/
// ChazM 5/26/06
// ChazM 7/31/06 Added broken items when bashing
// ChazM 8/7/06 Generate smidgen of gold if nothing else was generated.  Set broken item to proper resref.
// ChazM 8/30/06 Fixed broken item res ref.
// ChazM 9/5/06 Disallowed treasure type X2_DTS_TYPE_ITEM
// ChazM 5/31/07 - added support for X2_DTS_CLASS_NONE

#include "x2_inc_treasure"
#include "nw_o2_coninclude"
#include "x2_inc_compon"
#include "ginc_debug"

const string BROKEN_ITEM_RES_REF 	= "n2_it_brokenitem"; 	// the catch-all broken item
const string GOLD_ITEM_RES_REF 		= "nw_it_gold001"; 		// gold!

// local ints stored on the chest
const string VAR_TREASURE_CLASS 	= "TreasureClass";
const string VAR_TREASURE_TYPE 		= "TreasureType";


void main()
{
    // craft_drop_placeable();

    if (GetLocalInt(OBJECT_SELF,"NW_DO_ONCE") != 0)
    {
       return;
    }
    object oOpener = GetLastOpener();
	int iTreasureClass 	= GetLocalInt(OBJECT_SELF, VAR_TREASURE_CLASS);
	int iTreasureType 	= GetLocalInt(OBJECT_SELF, VAR_TREASURE_TYPE);
	
	if (iTreasureClass != X2_DTS_CLASS_NONE)
	{
		if (iTreasureType == 0)
			iTreasureType = X2_DTS_TYPE_DISP | X2_DTS_TYPE_GOLD;
		
		// if bashed, replace disposable w/ broken item		
		//PrettyDebug("GetLastKiller() = " + GetName(GetLastKiller()));
		
		// remove Tresure Type "Item" - these don't scale and are to dangerous for balance reasons
		// to have in the standard treasure generation
		if (iTreasureType & X2_DTS_TYPE_ITEM)
		{
			PrettyError("This container, " + GetTag(OBJECT_SELF) + ", is attempting to use X2_DTS_TYPE_ITEM which is not allowed.  Please report as an error. (This info also output to log)");
			iTreasureType = iTreasureType & (~X2_DTS_TYPE_ITEM);
		}
		if (GetIsObjectValid(GetLastKiller()))
		{
			//PrettyDebug("creating broken item and removing disposeable");
			iTreasureType = iTreasureType & (~X2_DTS_TYPE_DISP);
			CreateItemOnObject(BROKEN_ITEM_RES_REF, OBJECT_SELF, 1);
		}
			
		int iNumGenerated = DTSGenerateTreasureOnContainer (OBJECT_SELF, oOpener, iTreasureClass, iTreasureType);
		//PrettyDebug("iNumGenerated = " + IntToString(iNumGenerated));
		// everything must have something...	
		// if we didn't generate anything then add a smidgen of gold
		if (iNumGenerated == 0)
		{
			CreateItemOnObject(GOLD_ITEM_RES_REF, OBJECT_SELF, d20(1));
		}	
	}		
    SetLocalInt(OBJECT_SELF,"NW_DO_ONCE",1);
    ShoutDisturbed();
}
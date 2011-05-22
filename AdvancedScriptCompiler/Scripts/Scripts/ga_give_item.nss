// ga_give_item( string sTemplate, int nQuantity, int bAllPCs )
/*
	Creates item on PC(s)
	
	Parameters:
		string sTemplate = Item blueprint ResRef
		int    nQuantity = Stack size for item (default: 1)
		int    bAllPartyMembers	 = If = 1 create item on all player characters in party (MP)
*/
// FAB 9/30
// ChazM 10/19/05 - check if item is stackable and if not then give the quantity 1 at a time.
// EPF 7/27/06 -- complete rewrite to address a bug and a number of stylistic pet peeves.  Also
// 			      using a new method of tracking whether an item is stackable that Dan suggested.
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed bAllPCs to bAllPartyMembers

#include "ginc_debug"

void CreateItemsOnObject( string sTemplate, object oTarget=OBJECT_SELF, int nItems=1 );

void main( string sTemplate, int nQuantity, int bAllPartyMembers )
{
    object oPC = GetPCSpeaker();
	object oTarg;
	
	if ( GetIsObjectValid(oPC) == FALSE ) 
	{
		oPC = OBJECT_SELF;
	}

	// default stack size
	if ( nQuantity < 1 )
	{
		nQuantity = 1;
	}

	if ( bAllPartyMembers == FALSE )
	{
		CreateItemsOnObject( sTemplate, oPC, nQuantity );
	}
	else
	{
		oTarg = GetFirstFactionMember(oPC);
		while ( GetIsObjectValid(oTarg) == TRUE )
		{
			CreateItemsOnObject( sTemplate, oTarg, nQuantity );
			oTarg = GetNextFactionMember(oPC);
		}
	}
}

void CreateItemsOnObject( string sTemplate, object oTarget=OBJECT_SELF, int nItems=1 )
{
	
	int i = 1;
	while ( i <= nItems )
	{
		CreateItemOnObject( sTemplate, oTarget, 1 );
		i++;
	}
}
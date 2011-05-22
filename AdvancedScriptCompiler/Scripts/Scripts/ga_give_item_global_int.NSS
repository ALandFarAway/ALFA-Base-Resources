// ga_give_item_global_int
/*
    This gives the player a number of items.  The number is defined by a global int
        sItemRR     = This is the string name of the item's ResRef
		sGlobalNum	= The string of the global integer that contains the number of items to give
        bAllPartyMembers     = If set to 1 it gives the item to all PCs in the party (MP only)
*/
// TDE 7/19/06
// MDiekmann 4/9/07 -- using GetFirst and NextFactionMember() instead of GetFirst and NextPC(), changed nAllPCs to bAllPartyMembers
	
//Returns TRUE if oItem is stackable
int GetIsStackableItem(string sItemRR)
{
	//Must have a chest tagged checkchest
	//object oCopy = CopyItem(oItem, GetObjectByTag("checkchest"));
	object oCheck = GetObjectByTag("checkchest");
	if (!GetIsObjectValid(oCheck))
		oCheck = OBJECT_SELF;
	object oCopy = CreateItemOnObject(sItemRR, oCheck, 2);
	
	//Set the stacksize to two
	//SetItemStackSize(oCopy, 2);
	
	//Check if it really is two - otherwise, not stackable!
	int bStack=GetItemStackSize(oCopy)==2;
	
	//Destroy the test copy
	DestroyObject(oCopy);
	
	//Return bStack which is TRUE if item is stackable
	return bStack;
}

void CreateItemsOnObject(string sItemTemplate, object oTarget, int nNumToCreate)
{
	int i;
	
	if(nNumToCreate > 1)
	{
		if (GetIsStackableItem(sItemTemplate))
		{
			CreateItemOnObject(sItemTemplate, oTarget, nNumToCreate);
		}
		else
			for (i=1; i<=nNumToCreate; i++)
			{
				CreateItemOnObject(sItemTemplate, oTarget);
			}
	}
}

void main(string sItemRR, string sGlobalNum, int bAllPartyMembers)
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	// Check the global integer for the number of items to give
	int nQuantity = GetGlobalInt(sGlobalNum);
	
    if ( nQuantity == 0 ) 
		nQuantity = 1;
		
	if ( bAllPartyMembers == 0 ) 
		CreateItemsOnObject(sItemRR, oPC, nQuantity );
    else
    {
        object oTarg = GetFirstFactionMember(oPC);
        while(GetIsObjectValid(oTarg))
        {
            CreateItemsOnObject( sItemRR,oTarg,nQuantity );
            oTarg = GetNextFactionMember(oPC);
        }
    }

}
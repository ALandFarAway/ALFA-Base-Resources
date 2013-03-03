////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : gui_creatorspawn
//      Version : 1.0
//         Date : 2012-03-02
//       Author : Zelknolf
//
//  Local Variable Prefix = ACR_CREATOR
//
//  Description
//  This script houses the object creation portion of the new creator, receiving
//  the data from the targeting reticle.
//
////////////////////////////////////////////////////////////////////////////////


void main( object TargetObject, float posX, float posY, float posZ, string ResRef, int TargetRegion, int ObjectType) 
{
	if(GetIsObjectValid(TargetObject) &&
	   GetHasInventory(TargetObject) &&
	   ObjectType == OBJECT_TYPE_ITEM)
	{
		CreateItemOnObject(ResRef, TargetObject);
		return;
	}

	location lTarget = Location(GetArea(OBJECT_SELF), Vector(posX, posY, posZ), GetFacing(OBJECT_SELF));
	CreateObject(ObjectType, ResRef, lTarget, FALSE, "");
}


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
#include "acr_traps_i"

const int CUSTOM_OBJECT_TYPE_TRAP = 99;

void main( object TargetObject, float posX, float posY, float posZ, string ResRef, int TargetRegion, int ObjectType) 
{
	if (!GetIsDM(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF, "This functionality is only available to DMs.");
		return;
	}

	if(GetIsObjectValid(TargetObject) &&
	   GetHasInventory(TargetObject) &&
	   ObjectType == OBJECT_TYPE_ITEM)
	{
		CreateItemOnObject(ResRef, TargetObject);
		return;
	}

	location lTarget = Location(GetArea(OBJECT_SELF), Vector(posX, posY, posZ), GetFacing(OBJECT_SELF));
	if(ObjectType != CUSTOM_OBJECT_TYPE_TRAP)
	{
		CreateObject(ObjectType, ResRef, lTarget, FALSE, "");
		return;
	}
	else
	{
		_PassToCSharp(TRAP_EVENT_CREATE_GENERIC, posX, posY, posZ, GetArea(OBJECT_SELF), -1, -1, -1.0f, -1, -1, -1, -1, -1, 1, OBJECT_INVALID, ALIGNMENT_ALL, RACIAL_TYPE_ALL, 1, -1, -1, ResRef);
		return;
	}
}


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

	object oTargetBuilder = GetControlledCharacter(OBJECT_SELF);
	location lTarget = Location(GetArea(oTargetBuilder), Vector(posX, posY, posZ), GetFacing(oTargetBuilder));
	if(ObjectType != CUSTOM_OBJECT_TYPE_TRAP)
	{
		CreateObject(ObjectType, ResRef, lTarget, FALSE, "");
	}
	else
	{
		_PassToCSharp(TRAP_EVENT_CREATE_GENERIC, posX, posY, posZ, GetArea(OBJECT_SELF), -1, -1, -1.0f, -1, -1, -1, -1, -1, 1, OBJECT_INVALID, ALIGNMENT_ALL, RACIAL_TYPE_ALL, 1, -1, -1, ResRef);
	}
	
	if(TargetRegion == 0)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_SINGLE", 0, "target_single.xml", 0);
	}
	else if(TargetRegion == 6)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE3", 0, "target_circle3.xml", 0);
	}
	else if(TargetRegion == 7)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE6", 0, "target_circle6.xml", 0);
	}
	else if(TargetRegion == 8)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE9", 0, "target_circle9.xml", 0);
	}
	else if(TargetRegion == 2)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE12", 0, "target_circle12.xml", 0);
	}
	else if(TargetRegion == 9)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE15", 0, "target_circle15.xml", 0);
	}
	else if(TargetRegion == 10)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE18", 0, "target_circle18.xml", 0);
	}
	else if(TargetRegion == 18)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE24", 0, "target_circle24.xml", 0);
	}
	else if(TargetRegion == 17)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE30", 0, "target_circle30.xml", 0);
	}
	else if(TargetRegion == 19)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_CIRCLE36", 0, "target_circle36.xml", 0);
	}
	else if(TargetRegion == 11)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_WALL1", 0, "target_wall1.xml", 0);
	}
	else if(TargetRegion == 1)
	{
		DisplayGuiScreen(OBJECT_SELF, "TARGET_WALL2", 0, "target_wall2.xml", 0);
	}
}


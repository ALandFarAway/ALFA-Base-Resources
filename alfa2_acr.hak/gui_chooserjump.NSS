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
#include "acr_1984_i"

const int CUSTOM_OBJECT_TYPE_TRAP = 99;

void main( object TargetObject, float posX, float posY, float posZ, string objectId, int TargetRegion, int ObjectType) 
{
	if (!GetIsDM(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF, "This functionality is only available to DMs.");
		return;
	}

	location lTarget = Location(GetArea(OBJECT_SELF), Vector(posX, posY, posZ), GetFacing(OBJECT_SELF));
	
	object oTarget = IntToObject(StringToInt(objectId));
	
	AssignCommand(oTarget, JumpToLocation(lTarget));
}


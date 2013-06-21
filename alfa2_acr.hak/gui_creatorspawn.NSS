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
		object oItem = CreateItemOnObject(ResRef, TargetObject);
		if(GetBaseItemType(oItem) == BASE_ITEM_ARROW ||
			GetBaseItemType(oItem) == BASE_ITEM_BOLT ||
			GetBaseItemType(oItem) == BASE_ITEM_BULLET ||
			GetBaseItemType(oItem) == BASE_ITEM_DART ||
			GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN ||
			GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE)
		{
			object oItem = CreateItemOnObject(ResRef, TargetObject, 49);
		}
		ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned item "+GetName(oItem)+" ("+GetResRef(oItem)+") worth "+IntToString(GetGoldPieceValue(oItem))+" gold into the inventory of "+GetName(TargetObject));
		if(GetIsObjectValid(GetPlayerCurrentTarget(OBJECT_SELF)) ||
		   GetIsObjectValid(GetPlayerCurrentTarget(GetControlledCharacter(OBJECT_SELF))) || 
		   GetIsObjectValid(GetPlayerCurrentTarget(GetOwnedCharacter(OBJECT_SELF))))
		{
			// Don't cycle another targeting UI if we have something selected
			return;
		}
	}
	else
	{
		object oTargetBuilder = GetControlledCharacter(OBJECT_SELF);
		location lTarget = Location(GetArea(oTargetBuilder), Vector(posX, posY, posZ), GetFacing(oTargetBuilder));
		if(ObjectType != CUSTOM_OBJECT_TYPE_TRAP)
		{
			object oSpawn = CreateObject(ObjectType, ResRef, lTarget, FALSE, "");
			if(ObjectType == OBJECT_TYPE_CREATURE)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned creature "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") of CR "+FloatToString(GetChallengeRating(oSpawn))+" at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
			else if(ObjectType == OBJECT_TYPE_ITEM)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned item "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") of value "+IntToString(GetGoldPieceValue(oSpawn))+" at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
			else if(ObjectType == OBJECT_TYPE_PLACEABLE)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned placeable "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
			else if(ObjectType == OBJECT_TYPE_WAYPOINT)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned waypoint "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
			else if(ObjectType == OBJECT_TYPE_PLACED_EFFECT)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned effect "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
			else if(ObjectType == OBJECT_TYPE_LIGHT)
			{
				ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned light "+GetName(oSpawn)+" ("+GetResRef(oSpawn)+") at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
			}
		}
		else
		{
			_PassToCSharp(TRAP_EVENT_CREATE_GENERIC, posX, posY, posZ, GetArea(oTargetBuilder), -1, -1, -1.0f, -1, -1, -1, -1, -1, 1, OBJECT_INVALID, ALIGNMENT_ALL, RACIAL_TYPE_ALL, 1, -1, -1, ResRef);
			ACR_LogDMSpawn(OBJECT_SELF, "DM has spawned trap "+ResRef+" at ("+FloatToString(posX)+","+FloatToString(posY)+","+FloatToString(posZ)+")");
		}
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


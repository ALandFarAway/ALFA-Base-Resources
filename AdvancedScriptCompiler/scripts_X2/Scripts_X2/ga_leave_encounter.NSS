//ga_leave_encounter
//this script fires when the player leaves an encounter.
//If this is being fired after a successful encounter, nVictory should be 1.
//If the party is fleeing, it should be 0.
#include "ginc_overland"
#include "ginc_group"

void main(int bVictory)
{
	object oPC = GetPCSpeaker();
	
	int nEnemy = 1;
	int nItem = 1;
	int nPlaceable = 1;
	int nAoE = 1;
	
	object oGroundItem	= GetNearestObject(OBJECT_TYPE_ITEM, oPC, nItem);
	object oCreature	= GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPC, nEnemy);
	object oPlaceable	= GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, nPlaceable);
	object oAoE			= GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oPC);
	
	/*	Destroy any hostile creatures which are still alive.	*/
	while(GetIsObjectValid(oCreature))			
	{
		if(!GetFactionEqual(oCreature, oPC))	//Don't delete members of the Player Faction, because that will make the player sad.
		{
			PrettyDebug("Removing remaining creatures.");
			object oItem = GetFirstItemInInventory(oCreature);
			while(GetIsObjectValid(oItem))
			{
				PrettyDebug("Removing Item from Creature");
				DestroyObject(oItem, 0.2f);
				oItem = GetNextItemInInventory(oCreature);
			}
			DestroyObject(oCreature, 0.5f);
		}
		nEnemy++;
		oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPC, nEnemy);
	}

	/*	Destroy all items which are lying on the ground.	*/	
	while (GetIsObjectValid(oGroundItem))
	{
		PrettyDebug("Removing trash.");
		DestroyObject(oGroundItem, 0.5f);
		nItem++;
		oGroundItem = GetNearestObject(OBJECT_TYPE_ITEM, oPC, nItem);
	}
	
	/*	Destroy any Placeables containing items	*/
	while (GetIsObjectValid(oPlaceable))
	{
		if(GetHasInventory(oPlaceable))
		{
			object oItem = GetFirstItemInInventory(oPlaceable);
			while(GetIsObjectValid(oItem))
			{
				PrettyDebug("Removing Item from Placeable Container");
				DestroyObject(oItem, 0.2f);
				oItem = GetNextItemInInventory(oPlaceable);
			}
			
			PrettyDebug("Removing placeable with inventory.");
			DestroyObject(oPlaceable, 0.5f);
		}
		
		nPlaceable++;
		oPlaceable = GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, nPlaceable);
	}
	
	while(GetIsObjectValid(oAoE))
	{
		object oAoECreator = GetAreaOfEffectCreator(oAoE);
		if( GetFactionEqual(oAoECreator, oPC) == FALSE || GetAreaOfEffectDuration(oAoE) != DURATION_TYPE_PERMANENT )
		{
			PrettyDebug("Removing AoE.");
			DestroyObject(oAoE, 0.5f);
		}
		nAoE++;
		oAoE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oPC, nAoE);
	}	
	ResetGroup(ENC_GROUP_NAME_1);
	ResetGroup(ENC_GROUP_NAME_2);
	ResetGroup(ENC_GROUP_NAME_3);
	ResetGroup(ENC_GROUP_NAME_4);
	ResetGroup(ENC_GROUP_NAME_5);
	
	if(GetLocalInt(GetArea(OBJECT_SELF), "bMated"))
	{
		ResetGroup("COMBATANT_2" + ENC_GROUP_NAME_1);
		ResetGroup("COMBATANT_2" + ENC_GROUP_NAME_2);
		ResetGroup("COMBATANT_2" + ENC_GROUP_NAME_3);
		ResetGroup("COMBATANT_2" + ENC_GROUP_NAME_4);
		ResetGroup("COMBATANT_2" + ENC_GROUP_NAME_5);
	}
	
	if(bVictory)												//This section, which awards Bonus XP, is only run for victory.
	{
		object oArea = GetArea(OBJECT_SELF);
		int nEncounterEL = GetLocalInt(oArea, "nEncounterEL");
		if( nEncounterEL > 0)
		{
			int nPartyCR = GetPartyChallengeRating();
			PrettyDebug("EL:" + IntToString(nEncounterEL) + ", Party CR:" + IntToString(nPartyCR));
			int nXP = GetEncounterXP(nPartyCR, nEncounterEL);
			PrettyDebug("nXP:" + IntToString(nXP));
			AwardEncounterXP(nXP);
			SetLocalInt(GetArea(OBJECT_SELF), "nEncounterEL", 0);
		}
	}
	
	else
	{
		ModifyGlobalInt("00_nYellowDragonCount", 1);
		if(GetGlobalInt("00_nYellowDragonCount") >= 50)
		{
			object oMember	= GetFirstFactionMember(oPC, FALSE);
	
			while (GetIsObjectValid(oMember))
			{
				FeatAdd(oMember, FEAT_EPITHET_YELLOW_DRAGON, FALSE);
				oMember		= GetNextFactionMember(oPC, FALSE);
			}
		}
	}
	if(GetIsPC(oPC))
	{
		PrettyDebug("Restoring Overland Map position.");
		RestorePlayerMapLocation(oPC);
	}
	
}
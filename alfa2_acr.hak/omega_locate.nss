//  System Name : ALFA Core Rules
//     Filename : i_acr_dmexamine_ac
//    $Revision::             $ current version of the file
//        $Date::             $ date the file was created or modified
//       Author : AcadiusLost

//  Dependencies: None
//  Description
//  This script handles listing PCs on the server, with relevant information.
//
//  Revision History
//  2008/11/03  AcadiusLost  Inception
////////////////////////////////////////////////////////////////////////////////

#include "dmfi_inc_inc_com"
#include "acr_tools_i"

void main()
{
object oDM = OBJECT_SELF;

object oPC = GetFirstPC(TRUE);
while (oPC != OBJECT_INVALID)
	{string sArea = GetName(GetArea(oPC));
	 object oWaypoint = GetNearestObject(OBJECT_TYPE_WAYPOINT, oPC, 1);
	 string sWaypoint = GetName(oWaypoint);
	 string sHP = IntToString(GetMaxHitPoints(oPC));
	 string sHealth = IntToString(GetCurrentHitPoints(oPC));
	 string sGold = IntToString(GetGold(oPC));
	 int nWealthWorn = DMFI_GetNetWorth(oPC);
	 int nWealthCarried;
	 object oItem = GetFirstItemInInventory(oPC);
	 while(oItem != OBJECT_INVALID)
	 	{nWealthCarried = GetLocalInt(oDM, "CarriedWealth");
		 int nItemValue = GetGoldPieceValue(oItem);
		 SetLocalInt(oDM, "CarriedWealth", nWealthCarried + nItemValue);
		 oItem = GetNextItemInInventory(oPC);
		}
	 nWealthCarried = GetLocalInt(oDM, "CarriedWealth");
	 SetLocalInt(oDM, "CarriedWealth", 0);
	 string sWealth = IntToString(nWealthWorn + nWealthCarried);
	 int nRace = GetRacialType(oPC);
	 string sRace = RacialTypeName(nRace);
		
	 int nSubRace = GetSubRace(oPC);
	 string sSubRace = SubRaceName(nSubRace);
	 
	 int nClass1 = GetClassByPosition(1, oPC);
	 int nClass2 = GetClassByPosition(2, oPC);
	 int nClass3 = GetClassByPosition(3, oPC);
	 string sLevel1 = IntToString(GetLevelByPosition(1, oPC));
	 string sLevel2 = IntToString(GetLevelByPosition(2, oPC));
	 string sLevel3 = IntToString(GetLevelByPosition(3, oPC));
	 string sClassName1;
	 string sClassName2;
	 string sClassName3;
	 
	 if(nClass1 == 0) 
	 	{sClassName1 = "Barbarian";}
	 else if(nClass1 == 1)
	 	{sClassName1 = "Bard";}
	 else if(nClass1 == 2)
	 	{sClassName1 = "Cleric";}
	 else if(nClass1 == 3)
	 	{sClassName1 = "Druid";}
	 else if(nClass1 == 4)
	 	{sClassName1 = "Fighter";}
	 else if(nClass1 == 5)
	 	{sClassName1 = "Monk";}
	 else if(nClass1 == 6)
	 	{sClassName1 = "Paladin";}
	 else if(nClass1 == 7)
	 	{sClassName1 = "Ranger";}
	 else if(nClass1 == 8)
	 	{sClassName1 = "Rogue";}
	 else if(nClass1 == 9)
	 	{sClassName1 = "Sorcerer";}
	 else if(nClass1 == 55)
	 	{sClassName1 = "Spirit Shaman";}
	 else if(nClass1 == 59)
	 	{sClassName1 = "Swashbuckler";}
	 else if(nClass1 == 39)
	 	{sClassName1 = "Warlock";}
	 else if(nClass1 == 10)
	 	{sClassName1 = "Wizard";}
	 else
	 	{sClassName1 = "PrC";}
	 
	if((nClass2 == 0) && (GetClassByPosition(2, oPC) != CLASS_TYPE_INVALID))
	 	{sClassName2 = "Barbarian";}
	 else if(nClass2 == 1)
	 	{sClassName2 = "Bard";}
	 else if(nClass2 == 2)
	 	{sClassName2 = "Cleric";}
	 else if(nClass2 == 3)
	 	{sClassName2 = "Druid";}
	 else if(nClass2 == 4)
	 	{sClassName2 = "Fighter";}
	 else if(nClass2 == 5)
	 	{sClassName2 = "Monk";}
	 else if(nClass2 == 6)
	 	{sClassName2 = "Paladin";}
	 else if(nClass2 == 7)
	 	{sClassName2 = "Ranger";}
	 else if(nClass2 == 8)
	 	{sClassName2 = "Rogue";}
	 else if(nClass2 == 9)
	 	{sClassName2 = "Sorcerer";}
	 else if(nClass2 == 55)
	 	{sClassName2 = "Spirit Shaman";}
	 else if(nClass2 == 59)
	 	{sClassName2 = "Swashbuckler";}
	 else if(nClass2 == 39)
	 	{sClassName2 = "Warlock";}
	 else if(nClass2 == 10)
	 	{sClassName2 = "Wizard";}
	 else
	 	{sClassName2 = "PrC";}
	 
	 if((nClass3 == 0) && (GetClassByPosition(3, oPC) != CLASS_TYPE_INVALID))
	 	{sClassName3 = "Barbarian";}
	 else if(nClass3 == 1)
	 	{sClassName3 = "Bard";}
	 else if(nClass3 == 2)
	 	{sClassName3 = "Cleric";}
	 else if(nClass3 == 3)
	 	{sClassName3 = "Druid";}
	 else if(nClass3 == 4)
	 	{sClassName3 = "Fighter";}
	 else if(nClass3 == 5)
	 	{sClassName3 = "Monk";}
	 else if(nClass3 == 6)
	 	{sClassName3 = "Paladin";}
	 else if(nClass3 == 7)
	 	{sClassName3 = "Ranger";}
	 else if(nClass3 == 8)
	 	{sClassName3 = "Rogue";}
	 else if(nClass3 == 9)
	 	{sClassName3 = "Sorcerer";}
	 else if(nClass3 == 55)
	 	{sClassName3 = "Spirit Shaman";}
	 else if(nClass3 == 59)
	 	{sClassName3 = "Swashbuckler";}
	 else if(nClass3 == 39)
	 	{sClassName3 = "Warlock";}
	 else if(nClass3 == 10)
	 	{sClassName3 = "Wizard";}
	 else
	 	{sClassName3 = "PrC";}
		
	
	string sClass1 = sClassName1 + " " + sLevel1;
	string sClass2;
	if(GetClassByPosition(2, oPC) != CLASS_TYPE_INVALID)
	  {sClass2 = "/" + sClassName2 + " " + sLevel2;
	  }
	string sClass3;
	if(GetClassByPosition(3, oPC) != CLASS_TYPE_INVALID)
	  {sClass2 = "/" + sClassName3 + " " + sLevel3;
	  }
	
	string sClasses = sClass1 + sClass2 + sClass3;	
	if(sRace == sSubRace)
		{sSubRace = "";
		}
		
	 SendMessageToPC(oDM, GetName(oPC) + "(" + sHealth + "/" + sHP + "hp; " + sSubRace + " " + sRace + " " + sClasses +"; " + sGold + "gp; " + sWealth + "nw): " + sArea + "/" + sWaypoint);
	 SendMessageToPC(oDM, "----------------------");
	 oPC = GetNextPC(TRUE);
	}




}		

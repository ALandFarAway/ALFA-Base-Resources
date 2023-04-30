/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_scryinggr.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Scrying. 
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{		
	if (!ACR_PrecastEvent())
    {
        return;
    }

	SignalEvent( GetSpellTargetObject(), EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
	//Define Scryer and Scrying Object
	 object oScryer = OBJECT_SELF;
	 object oArea = GetArea(oScryer);
	 object oTarget = GetSpellTargetObject();
	 location lTarget = GetSpellTargetLocation();
	 int nCasterType = GetLastSpellCastClass();
	 SetLocalInt(oScryer, "nSpellCasterType", nCasterType);
	 float fDistancePlc = 0.0;
	 object oScryPlc = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, GetLocation(oScryer), FALSE, OBJECT_TYPE_PLACEABLE);
	 	while(oScryPlc != OBJECT_INVALID) {
	 	   if(FindSubString(GetTag(oScryPlc), "_SCRY") != -1){
			    string sPlcTag = GetTag(oScryPlc);
				SetLocalObject(oArea, "oScryPlc", oScryPlc);
			    fDistancePlc = GetDistanceBetween(oScryer, oScryPlc);
				}
		  oScryPlc = GetNextObjectInShape(SHAPE_SPHERE, 5.0, GetLocation(oScryer), FALSE, OBJECT_TYPE_PLACEABLE);
	   	}
		
	oScryPlc = GetLocalObject(oArea, "oScryPlc");
	object oScry = GetLocalObject(oArea, "oScryPlc");
	SetLocalObject(oArea, "oScry", oScry);
	int nObjectTypePlc = GetObjectType(oScryPlc);
	SetLocalObject(oArea, "oScryPlc", OBJECT_INVALID);
			   
	float fDistanceTrg = 0.0;		
	object oScryTrg = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_TRIGGER);
	if((nCasterType == CLASS_TYPE_DRUID) || (nCasterType == 255)) {
		location lTarget = GetLocation(oScryer);
		while(oScryTrg != OBJECT_INVALID) {
			string sTriggerTagTrg = GetTag(oScryTrg);
			if(FindSubString(sTriggerTagTrg, "_SCRY_") != -1) {
				 SetLocalObject(oArea, "oScryTrg", oScryTrg);
				 fDistanceTrg = GetDistanceBetween(oScryer, oScryTrg);
				 if(((fDistanceTrg > 0.0) && (fDistanceTrg < fDistancePlc)) ||(oScryPlc == OBJECT_INVALID))
				 	{oScry = oScryTrg;
					 SetLocalObject(oArea, "oScry", oScryTrg);
				 	}
				}
			oScryTrg = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_TRIGGER);
			}
		 
		 }
	
	oScry = GetLocalObject(oArea, "oScry");
		 
	int nObjectTypeTrg = GetObjectType(oScryTrg);
	int nObjectType = GetObjectType(oScry);
			
	 //Usage, range, and class restrictions
	 if(GetLocalInt(oScry, "nScryActive") == 1) {
	 	SendMessageToPC(oScryer, GetName(oScry) + " is already being used in a Scry spell.");
		}
		
	 if(oScry == OBJECT_INVALID) {
		SendMessageToPC(oScryer, "You must be near enough to touch a scrying object for your spell to activate it.");
		}
		
	 if((nCasterType == CLASS_TYPE_WIZARD) && (GetResRef(oScry) != "abr_pl_so_mirror") && (GetResRef(oScry) != "tsm_plc_scry_mirror")) {
	 	SendMessageToPC(oScryer, "There is no scrying mirror within range.");
		}
	 else if((nCasterType == CLASS_TYPE_BARD) && (GetResRef(oScry) != "abr_pl_so_mirror") && (GetResRef(oScry) != "tsm_plc_scry_mirror")) {
	 	SendMessageToPC(oScryer, "There is no scrying mirror within range.");
		}
	 else if((nCasterType == CLASS_TYPE_CLERIC) && (GetResRef(oScry) != "abr_pl_so_holyfont")) {
	 	SendMessageToPC(oScryer, "There is no holy font suitable for scrying within range.");
		}
	 else if((nCasterType == CLASS_TYPE_DRUID) && (GetResRef(oScry) != "abr_pl_so_pool") && (GetResRef(oScry) != "abr_trg_so_water")) {
	 	SendMessageToPC(oScryer, "There is no natural pool of water suitable for scrying within range.");
		}
	 else {//Get Scrying Object's location and calculate Scryer's spell DC and spell duration
			string sScryName = GetName(oScry);
			location lHere = GetLocation(oScry);
			int nScryerLevel = GetCasterLevel(oScryer);
	 	 	int nSpellLevel = GetSpellLevel(GetSpellId());
			float fScryTimer = nScryerLevel * 60.0;
			if(GetSpellId() == 3057) {
				fScryTimer = nScryerLevel * 60.0 * 60.0;
			}
			int nAbilityMod = GetAbilityModifier(ABILITY_INTELLIGENCE);
			if(GetLastSpellCastClass()== CLASS_TYPE_BARD || CLASS_TYPE_SORCERER || CLASS_TYPE_PALADIN) {
				nAbilityMod = GetAbilityModifier(ABILITY_CHARISMA);
				}
			if(GetLastSpellCastClass()== CLASS_TYPE_CLERIC || CLASS_TYPE_DRUID || CLASS_TYPE_RANGER) {
				nAbilityMod = GetAbilityModifier(ABILITY_WISDOM);
				}
				
			int nDC = 10 + nSpellLevel + nAbilityMod;
						
			//Create undetectable OOC Scrying Speaker at location of Scrying Object to receive scrying information about future scrying target
			object oScrySpeak = GetLocalObject(oScry, "oScrySpeak");
			if(oScrySpeak == OBJECT_INVALID) {
				oScrySpeak = CreateObject(OBJECT_TYPE_CREATURE, "abr_cr_scry_speak", lHere);
            	SetLocalObject(oScry, "oScrySpeak", oScrySpeak);
				}
				
			//Set all objects on each other
			SetLocalObject(oScrySpeak, "oScry", oScry);
			SetLocalObject(oScrySpeak, "oScryer", oScryer);
			SetLocalObject(oScry, "oScryer", oScryer);
			SetLocalObject(oScryer, "oScrySpeak", oScrySpeak);
			SetLocalObject(oScryer, "oScry", oScry);
			
			//Set all other variables on ScryListen
			SetLocalInt(oScrySpeak, "nScryDC", nDC);
			SetLocalInt(oScrySpeak, "nCasterLevel", nScryerLevel);
			SetLocalFloat(oScrySpeak, "fScryTimer", fScryTimer);
			SetFirstName(oScrySpeak, sScryName);
			
			SetLocalObject(oArea, "oScry", OBJECT_INVALID);
	
			//Over to ScrySpeaker's onspawn: acf_scry_npc_onspawn
		}
		
	// Post-cast event.
	ACR_PostcastEvent();
	}				
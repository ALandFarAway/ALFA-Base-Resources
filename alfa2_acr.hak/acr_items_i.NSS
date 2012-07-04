////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_items_i
//      Version : 0.20
//         Date : 2010-09-19
//       Author : Ronan & AcadiusLost
//
//  Local Variable Prefix = ACR_ITEM
//
//  Description
//  These scripts handle everything involved in controlling and retrieving data
//  from in-game type.
//  Revision History
//  2007/12/16  AcadiusLost:  Inception
//  2007/12/17  AcadiusLost: Added OnActivate hook. added i_tag_ac handling.
//	2008/09/21  AcadiusLost: Added special handling for OOC items on acquire.
//  2009/01/14  AcadiusLost: Added native support for TKL performer
//  2009/02/01  AcadiusLost: Added special OnAcquire handling for bought items. 
//					optimized OnAcquire() code to reduce login lag.
//  2009/02/09  AcadiusLost:  Added test for Returns LocalInt on the buying PC 
//  2009/08/15  AcadiusLost:  Added controls to prevent item dropping on the travelmap
//  2010/03/13  AcadiusLost:  Merged in code for activatable dynamic weapon VFX, added failsafe for NLD properties
//  2010/09/13  AcadiusLost:  Added hook for ACR Quests to Item Unacquire event, handling for activatable VFX items (earrings)
//  2010/09/19  AcadiusLost:  Added handling for Gender Restriction to OnEquip
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_death_i"
#include "acr_quest_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! The spellbook, first aid and holysymbol blueprint resrefs
const string ACR_MOD_SPELLBOOK_RESREF = "abr_it_spellbook";
const string ACR_MOD_HOLYSYMBOL_RESREF = "abr_it_holysymbol";
const string ACR_MOD_HEALKIT_RESREF = "abr_it_firstaid";

//! The spellbook, first aid and holysymbol blueprint tags
const string ACR_MOD_SPELLBOOK_TAG = "abr_it_spellbook";
const string ACR_MOD_HOLYSYMBOL_TAG = "abr_it_holysymbol";
const string ACR_MODHEALKIT_TAG = "abr_it_firstaid";

//! Constant integers for activatable VFX
const int ACR_VFX_POS_BACKPACK = 1992;       // backpack position
const int ACR_VFX_POS_LEFTHIP = 1993;        // longsword, bastard sword, shortsword at left hip
const int ACR_VFX_POS_BOW = 1994;            // Longbow/shortbow, across body diagonal
const int ACR_VFX_POS_SHIELDBACK = 1995;     // Shield variants, on back
const int ACR_VFX_POS_LEFTSHOULDER = 1996;   // longsword, bastard sword, shortsword, greatsword, falchion on back, left shoulder
const int ACR_VFX_POS_BACKLUTE = 1997;       // lute/mandolin position across back, diagonal
const int ACR_VFX_POS_QUIVER = 1998;         // VFX quiver position
const int ACR_VFX_POS_BACKAXE = 1999;		 // Dwarven waraxe or greataxe, center back upright

const int ACR_VFX_POS_EARRINGS = 2000;	     // for activatable earring VFX
const int ACR_VFX_POS_EAR_LEFT = 2001;
const int ACR_VFX_POS_EAR_RIGHT = 2002;

//! Constant strings for VFX variables
const string ACR_VFX_NAME = "ACR_VFX_NAME";
const string ACR_VFX_POS = "ACR_VFX_POS";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Handles equipping of items.
void ACR_ItemOnEquip(object oItem, object oPC);

//! Handles un-equipping of items.
void ACR_ItemOnUnEquip(object oItem, object oPC);

//! Handles acquiring of items.
void ACR_ItemOnAcquire(object oItem, object oAcquiredBy, object oAcquiredFrom);

//! Handles unacquiring of items.
void ACR_ItemOnUnAcquire(object oItem, object oPC);

//! Handles activation of items.
void ACR_ItemOnActivate(object oItem, object oPC, object oTarget, location lAimedAt);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void ACR_ItemOnEquip(object oItem, object oPC) {

    int nItemType = GetBaseItemType(oItem);
	object oCurrentWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int nCurrentWeaponType = GetBaseItemType(oCurrentWeapon);
	int bAssociateVFX = FALSE;
	string sTest = "";
	effect eTest = GetFirstEffect(oPC);
	if (GetItemHasItemProperty(oItem, 125)) {
		// Gender Restriction: Female 
		if (GetGender(oPC) != GENDER_FEMALE) {
			// grab the last unequipped item (should be what was swapped for this
			//  BEFORE ordering the invalid item to be unequipped
			//  working on the assumption that most equipping attempts are swaps into
			//  previously occupied slots, so the last unequipped should be what was last there.
			//  odds of a non-swapped previously unequipped object fitting in the right slot seem acceptable low for now
			//   -> for later, could implement a time window (0.5f?) for this, and not bother if > time
		    object oPreviouslyEquipped = GetLocalObject(oPC, "ACR_LAST_UNEQUIPPED");
			int nSlot = 255;
			// if the invalid item is in the right hand, try re-equipping whatever it was in the right hand, etc
			if (oItem == oCurrentWeapon) {
			    nSlot = INVENTORY_SLOT_RIGHTHAND;
			} else if (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND)) {
				nSlot = INVENTORY_SLOT_LEFTHAND;
			} else if (nItemType == BASE_ITEM_ARMOR) {
				nSlot = INVENTORY_SLOT_CHEST;
			} else if (nItemType == BASE_ITEM_AMULET) {
			    nSlot = INVENTORY_SLOT_NECK;
			} else if (nItemType == BASE_ITEM_BELT) {
			    nSlot = INVENTORY_SLOT_BELT;
			} else if (nItemType == BASE_ITEM_BOOTS) {
			    nSlot = INVENTORY_SLOT_BOOTS;
			} else if (nItemType == BASE_ITEM_BRACER) {
			    nSlot = INVENTORY_SLOT_ARMS;
			} else if (nItemType == BASE_ITEM_CLOAK) {
			    nSlot = INVENTORY_SLOT_CLOAK;
			} else if (nItemType == BASE_ITEM_GLOVES) {
			    nSlot = INVENTORY_SLOT_ARMS;
			} else if (nItemType == BASE_ITEM_HELMET) {
			    nSlot = INVENTORY_SLOT_HEAD;
			} else if (oItem == GetItemInSlot(INVENTORY_SLOT_LEFTRING)) {
				nSlot = INVENTORY_SLOT_LEFTRING;
			} else if (oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTRING)) {
				nSlot = INVENTORY_SLOT_RIGHTRING;
			}
			AssignCommand(oPC, ActionUnequipItem(oItem));			
			SendMessageToPC(oPC, "You cannot equip this item due to your gender.");
			SendMessageToPC(oPC, "Re-equipping "+GetName(oPreviouslyEquipped));
			AssignCommand(oPC, ActionEquipItem(oPreviouslyEquipped, nSlot));
		}
	}
	int nVFXnum = GetLocalInt(oItem, "WeapVFXnum");
	if (nVFXnum != 0) {
		// Item is associated with a VFX; remove it
 		while (GetIsEffectValid(eTest))  {
	   		if (GetEffectSpellId(eTest) == nVFXnum) {
	   			RemoveEffect(oPC, eTest);
		  		break;
			}
	    	eTest = GetNextEffect(oPC);	  
		}
	}
	if ((nCurrentWeaponType == BASE_ITEM_BASTARDSWORD) || (nItemType == BASE_ITEM_BASTARDSWORD))  {
	    // special handling for equipped bastard swords, equipped already or being equipped.
		// first, manage any pending VFX associated
		sTest = GetLocalString(oPC, "LongSwordBelt");
		if (sTest != "") {
			// Belted sword VFX active, drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_LEFTHIP) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_LEFTHIP);
			SendMessageToPC(oPC, "Left hip sword VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "LongSwordBelt");
		 } else {
		 	sTest = GetLocalString(oPC, "LongSwordBack");
			if (sTest != "") {
				// Backsword VFX active, drop and associate
				while (GetIsEffectValid(eTest))  {
	   				if (GetEffectSpellId(eTest) == ACR_VFX_POS_LEFTSHOULDER) {
	   					RemoveEffect(oPC, eTest);
		  				break;
					}
	    			eTest = GetNextEffect(oPC);	  
				}
				SetLocalString(oItem, "WeapVFX", sTest);
				SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_LEFTSHOULDER);
				SendMessageToPC(oPC, "Back-sheathed sword VFX bound to item: "+GetName(oItem));
				DeleteLocalString(oPC, "LongSwordBack");
			}
		}
		// Next, move on to the one/two-hand logic.
	    if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC)) {
		    // PC has a bastard sword equipped, but does not have exotic prof.
		    object oFreeHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	        if (oCurrentWeapon == oItem) {
			    // make sure the off hand is cleared if bastardsword is equipped
			    if (oFreeHand != OBJECT_INVALID) { AssignCommand(oPC, ActionUnequipItem(oFreeHand)); }
			} else if (oFreeHand == oItem) {
			    if (nItemType == BASE_ITEM_BASTARDSWORD) {
			        // trying to equip bastardsword in offhand, switch to RH
					AssignCommand(oPC, ActionUnequipItem(oItem));
					AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
				} else {
			        // Equipped non-BS item in free hand, unequip bastardsword
				    AssignCommand(oPC, ActionUnequipItem(oCurrentWeapon));
				}
			}
		}
	} else if (nItemType == BASE_ITEM_MANDOLIN) { 
	    // activate the TKL performer package
		ExecuteScript("tkl_performer_lute", oPC);
		// Also handle VFX
		sTest = GetLocalString(oPC, "Lute");
		if (sTest == "fx_at_backmandolin01") {
			//Lute VFX active, equipping lute, drop VFX			   
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) ==  ACR_VFX_POS_BACKLUTE) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum",  ACR_VFX_POS_BACKLUTE);
			SendMessageToPC(oPC, "Lute VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "Lute");
		}
	} else if (nItemType == BASE_ITEM_DRUM) { 
	    // activate the TKL performer package
		ExecuteScript("tkl_performer_drum", oPC);
	} else if (nItemType == BASE_ITEM_FLUTE) { 
	    // activate the TKL performer package
		ExecuteScript("tkl_performer_flute", oPC);
	} else if (nItemType == BASE_ITEM_BATTLEAXE) {
		// allow DwarAxe or GreatAxe VFX, DwarAxe primary
		sTest = GetLocalString(oPC, "DwarAxe");
		if (sTest != "") {
			// Dwarven Axe VFX active; drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_BACKAXE) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_BACKAXE);
			SendMessageToPC(oPC, "Back-slung axe VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "DwarAxe");
		} else {
			sTest = GetLocalString(oPC, "GreatAxe");
			if (sTest != "") {
				// Greataxe VFX active, drop and associate
				while (GetIsEffectValid(eTest))  {
	   				if (GetEffectSpellId(eTest) == ACR_VFX_POS_BACKAXE) {
	   					RemoveEffect(oPC, eTest);
		  				break;
					}
	    			eTest = GetNextEffect(oPC);	  
				}
				SetLocalString(oItem, "WeapVFX", sTest);
				SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_BACKAXE);
				SendMessageToPC(oPC, "Large back-slung axe VFX bound to item: "+GetName(oItem));
				DeleteLocalString(oPC, "GreatAxe");
			}
		}
			
	} else if (nItemType == BASE_ITEM_DWARVENWARAXE) {
		sTest = GetLocalString(oPC, "DwarAxe");
		if (sTest != "") {
			// Dwarven Axe VFX active; drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_BACKAXE) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_BACKAXE);
			SendMessageToPC(oPC, "Back-slung axe VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "DwarAxe");
		}
	} else if (nItemType == BASE_ITEM_GREATAXE) {
		sTest = GetLocalString(oPC, "GreatAxe");
		if (sTest != "") {
			// Greataxe VFX active, drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_BACKAXE) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_BACKAXE);
			SendMessageToPC(oPC, "Large back-slung axe VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "GreatAxe");
		}	
	} else if ((nItemType == BASE_ITEM_TOWERSHIELD) || (nItemType == BASE_ITEM_SMALLSHIELD) || (nItemType == BASE_ITEM_LARGESHIELD)) {
		//special case: shields
		sTest = GetLocalString(oPC, "Shield");
		if (sTest != "") {
			// Shield VFX active, drop and associate
			while (GetIsEffectValid(eTest)) {
				if (GetEffectSpellId(eTest) == ACR_VFX_POS_SHIELDBACK) {
					RemoveEffect(oPC, eTest);
					break;
				}
				eTest = GetNextEffect(oPC);
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_SHIELDBACK);
			SendMessageToPC(oPC, "Back-slung shield VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "Shield");
		}
	} else if ((nItemType == BASE_ITEM_LONGBOW) || (nItemType == BASE_ITEM_SHORTBOW)) {
		sTest = GetLocalString(oPC, "LongBow");
		if (sTest != "") {
			// Bow VFX active, drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_BOW) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_BOW);
			SendMessageToPC(oPC, "Back-slung bow VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "LongBow");
		}
	} else if ((nItemType == BASE_ITEM_GREATSWORD) || (nItemType == BASE_ITEM_FALCHION)) {
		// large swords take the Greatsword VFX for now
		sTest = GetLocalString(oPC, "GreatSword");
		if (sTest != "") {
			// Greatswors VFX active, drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_LEFTSHOULDER) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_LEFTSHOULDER);
			SendMessageToPC(oPC, "Back-sheathed large sword VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "GreatSword");
		}
	} else if ((nItemType == BASE_ITEM_LONGSWORD) || (nItemType == BASE_ITEM_SHORTSWORD) || (nItemType == BASE_ITEM_RAPIER) || (nItemType == BASE_ITEM_SCIMITAR) || (nItemType == BASE_ITEM_KATANA)) {
		// small/medium swords can use either back or hip VFX, hip primary
		sTest = GetLocalString(oPC, "LongSwordBelt");
		if (sTest != "") {
			// Belted sword VFX active, drop and associate
			while (GetIsEffectValid(eTest))  {
	   			if (GetEffectSpellId(eTest) == ACR_VFX_POS_LEFTHIP) {
	   				RemoveEffect(oPC, eTest);
		  			break;
				}
	    		eTest = GetNextEffect(oPC);	  
			}
			SetLocalString(oItem, "WeapVFX", sTest);
			SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_LEFTHIP);
			SendMessageToPC(oPC, "Left hip sword VFX bound to item: "+GetName(oItem));
			DeleteLocalString(oPC, "LongSwordBelt");
		 } else {
		 	sTest = GetLocalString(oPC, "LongSwordBack");
			if (sTest != "") {
				// Backsword VFX active, drop and associate
				while (GetIsEffectValid(eTest))  {
	   				if (GetEffectSpellId(eTest) == ACR_VFX_POS_LEFTSHOULDER) {
	   					RemoveEffect(oPC, eTest);
		  				break;
					}
	    			eTest = GetNextEffect(oPC);	  
				}
				SetLocalString(oItem, "WeapVFX", sTest);
				SetLocalInt(oItem, "WeapVFXnum", ACR_VFX_POS_LEFTSHOULDER);
				SendMessageToPC(oPC, "Back-sheathed sword VFX bound to item: "+GetName(oItem));
				DeleteLocalString(oPC, "LongSwordBack");
			}
		}
	}

	// Handle items for equip/remove darkvision
	if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION))
		ACR_AddTemporaryDarkvision(oPC, oItem);

	// allow tag-based onEquip scripts
	string sAcquireScript = "i_"+GetTag(oItem)+"_oe";
	ExecuteScript(sAcquireScript, OBJECT_SELF); 
}


void ACR_ItemOnUnEquip(object oItem, object oPC) {

	int nItemType = GetBaseItemType(oItem);
	SetLocalObject(oPC, "ACR_LAST_UNEQUIPPED", oItem);
	// SendMessageToPC(oPC, "Pointer to "+GetName(oItem)+" banked.");
	if ((nItemType == BASE_ITEM_MANDOLIN) || (nItemType == BASE_ITEM_DRUM) || (nItemType == BASE_ITEM_FLUTE)) { 
		ExecuteScript("tkl_performer_ue", oPC);
	}
	// Run any VFX operations needed
	string sVFX = GetLocalString(oItem, "WeapVFX");
	int nVFXNum = GetLocalInt(oItem, "WeapVFXnum");
	effect eTest = GetFirstEffect(oPC); 
	
	if (nVFXNum !=0) {
		effect eVFX = SupernaturalEffect(SetEffectSpellId(EffectNWN2SpecialEffectFile(sVFX), nVFXNum));

		while (GetIsEffectValid(eTest))  {
	   		if (GetEffectSpellId(eTest) == nVFXNum) {
	   			RemoveEffect(oPC, eTest);
		  		break;
			}
	    	eTest = GetNextEffect(oPC);
		}	  
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oPC);
	}

	// Handle items for equip/remove darkvision
	if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION))
		ACR_RemoveTemporaryDarkvision(oPC, oItem);


	// allow tag-based onEquip scripts
	string sAcquireScript = "i_"+GetTag(oItem)+"_oue";
	ExecuteScript(sAcquireScript, OBJECT_SELF);

}



void ACR_ItemOnAcquire(object oItem, object oAcquiredBy, object oAcquiredFrom) {

	// check for known OOC items without local variable flags
	string sTag = GetTag(oItem);
	if (sTag == "dmfi_exe_tool") { SetLocalInt(oItem, "ACR_ITM_OOC", TRUE); 
	} else if (sTag == ACR_MODHEALKIT_TAG) { SetLocalInt(oItem, "ACR_ITM_OOC", TRUE); 
	} else if (sTag == "acr_subdual") { SetLocalInt(oItem, "ACR_ITM_OOC", TRUE); 
	} else if (sTag == "abr_it_ooc_mindoverbody") { SetLocalInt(oItem, "ACR_ITM_OOC", TRUE);
	} else if (GetStringLeft(sTag, 11) == "abr_it_ooc_") { SetLocalInt(oItem, "ACR_ITM_OOC", TRUE);
	}
	
	// The rest of these operations aren't really necessary on the pre-client enter firing of this event.
	//  Should help clear up login lag.
	if (!GetIsObjectValid(GetArea(oAcquiredBy))) { return; }
	
	// if the player is dead but has inventory, return items to their corpse
    // dead players should not have any inventory
    if (ACR_GetIsPlayerDead(oAcquiredBy)) { AssignCommand(oAcquiredBy, ActionGiveItem(oItem, ACR_GetCorpseFromPlayer(oAcquiredBy))); }

    // update bodies that have been picked up
    ACR_CorpseOnAcquire(oItem, oAcquiredBy, oAcquiredFrom);
	
	// check to see if this item is being acquired from a store. 	
	if (GetObjectType(oAcquiredFrom) == OBJECT_TYPE_STORE) {
		// if so, try to work out the cost and set info for Returns.
		object oStore = GetLocalObject(oAcquiredBy, "ACR_STORE");
		if (oStore == OBJECT_INVALID) {
			// no pointer, go with best guess.
			oStore = GetNearestObject(OBJECT_TYPE_STORE, oAcquiredBy);
			//SendMessageToPC(oAcquiredBy, "Item "+GetName(oItem)+" acquired from store without pointer; guessing "+GetResRef(oStore));
		} else {
			//SendMessageToPC(oAcquiredBy, "Item "+GetName(oItem)+" acquired from store with ResRef: "+GetResRef(oStore));
		}
		int nCurrentGold = GetGold(oAcquiredBy);
		int nItemCost = GetLocalInt(oAcquiredBy, "ACR_GOLD") - nCurrentGold;
		//SendMessageToPC(oAcquiredBy, "Estimated cost of item is "+IntToString(nItemCost)+", based on cache of "+IntToString(GetLocalInt(oAcquiredBy, "ACR_GOLD"))+" minus current gold; "+IntToString(nCurrentGold));
		if (GetLocalInt(oAcquiredBy, "ACR_RETURNS")) {
			// only set return data and value if the PC is inside a returns trigger
			SetLocalString(oItem, "ACR_RETURNS_MERCHANT", GetResRef(oStore));
			SetLocalInt(oItem, "ACR_RETURNS_VALUE", nItemCost);
			//SendMessageToPC(oAcquiredBy, "Returns value cached.");
		}
		SetLocalInt(oAcquiredBy, "ACR_GOLD", nCurrentGold);
		//SendMessageToPC(oAcquiredBy, "Cached gold updated to "+IntToString(nCurrentGold));
	}	
	// allow tag-based acquire scripts
	string sAcquireScript = "i_"+GetTag(oItem)+"_oa";
	ExecuteScript(sAcquireScript, OBJECT_SELF);
	

}

void ACR_ItemOnUnAcquire(object oItem, object oPC) {

	// process quests first, so you don't get travel map quest iteration
    ACR_QuestItemOnUnAcquire(oPC, oItem);
	
	//First, make sure you're not in a travel map
	if(GetLocalInt(GetArea(oPC), "ACR_IS_TRAVEL_AREA") == TRUE) {
		// if so, skip special handling, force reacquire
		AssignCommand(oPC, ActionPickUpItem(oItem));
		return;
	}

    // create a corpse where a body is discarded
    ACR_CorpseOnUnacquire(oItem, oPC);	
	// clear VFX locals stored on the item
	effect eTest = GetFirstEffect(oPC); 	
	int nVFXnum = GetLocalInt(oItem, "WeapVFXnum");
	if (nVFXnum != 0) {
		while (GetIsEffectValid(eTest))  {
	   		if (GetEffectSpellId(eTest) == nVFXnum) {
	   			RemoveEffect(oPC, eTest);
		  		break;
			}
	    eTest = GetNextEffect(oPC);	  
		}
	DeleteLocalInt(oItem, "WeapVFXnum");
	DeleteLocalString(oItem, "WeapVFX");
	}
	//SendMessageToPC(oPC, "UnAquire event firing: Cached gold was "+IntToString(GetLocalInt(oPC, "ACR_GOLD"))+", current gold is "+IntToString(GetGold(oPC)));
	// add a hook to catch leftover subdual properties and clear them
	object oWeapon = oItem; 
	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while(GetIsItemPropertyValid(iProp))
     {
       if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ONHITCASTSPELL
         || GetItemPropertyType(iProp) == ITEM_PROPERTY_NO_DAMAGE
         || GetItemPropertyType(iProp) == ITEM_PROPERTY_DECREASED_DAMAGE) {
         	DelayCommand(0.5,AssignCommand(oPC,RemoveItemProperty(oWeapon,iProp)));
			WriteTimestampedLogEntry("Nonlethal damage property detected on UnAcquired item with resref: "+GetResRef(oWeapon)+" dropped or sold by "+GetName(oPC)+" in area "+GetName(GetArea(oPC))+".");
		}
      iProp = GetNextItemProperty(oWeapon);
     }
     SetLocalInt(oWeapon,ACR_NLD_WOFFHAND,FALSE);
     SetLocalInt(oWeapon,ACR_NLD_W2HANDED,FALSE);
     SetLocalInt(oWeapon,ACR_NLD_SA_DICE,0);
     int nDamPenalty = GetLocalInt(oWeapon, ACR_NLD_DAMAGE_PENALTY);
     if(nDamPenalty >= 1 && nDamPenalty < 255) {
       AssignCommand(oPC,AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamagePenalty(nDamPenalty),oWeapon));
	   WriteTimestampedLogEntry("Preexisting reduced damage property RE-ADDED to UnAcquired item with resref: "+GetResRef(oWeapon)+" dropped or sold by "+GetName(oPC)+" in area "+GetName(GetArea(oPC))+".");
	}
	// allow tag-based unacquire scripts
	string sUnAcquireScript = "i_"+GetTag(oItem)+"_oua";
	ExecuteScript(sUnAcquireScript, OBJECT_SELF);
	
}

void ACR_ItemOnActivate(object oItem, object oPC, object oTarget, location lAimedAt) {

	string sItemTag = GetTag(oItem);
	string sActivatableVFX = GetLocalString(oItem, ACR_VFX_NAME);
	int nActivatableVFXpos = GetLocalInt(oItem, ACR_VFX_POS);
	effect eTest = GetFirstEffect(oPC);
	object oVFXItem = OBJECT_INVALID;
	int bVFX = FALSE;
	// Execute the item script according to the item's tag
	if (sItemTag == ACR_MOD_SPELLBOOK_TAG) {
    	ACR_StudyForSpells(oPC);
	} else if (sItemTag == ACR_MOD_HOLYSYMBOL_TAG) {
    	ACR_PrayForSpells(oPC);
	} else if (sActivatableVFX != "") {
		// item has a VFX associated as Unique Power, toggle it
		while (GetIsEffectValid(eTest))  {
	   		if (GetEffectSpellId(eTest) == nActivatableVFXpos) {
			    // already has an effect in this position, so turn it off
				oVFXItem = GetLocalObject(oPC, "ACR_VFX_"+IntToString(nActivatableVFXpos));
				if (GetIsObjectValid(oVFXItem)) {
					SendMessageToPC(oPC, "You remove the "+ ACR_CleanCreatureNameTextForPlayers(GetName(oVFXItem)));
					DeleteLocalInt(oItem, "WeapVFXNum");
					DeleteLocalString(oItem, "WeapVFX");
					DeleteLocalObject(oPC, "ACR_VFX_"+IntToString(nActivatableVFXpos));
				} else {
					SendMessageToPC(oPC, "You remove an existing item.");
				}
	   			RemoveEffect(oPC, eTest);
				bVFX = TRUE;
		  		break;
			}
	    eTest = GetNextEffect(oPC);	  
		}
		if (!bVFX) {
			// nothing in the VFX "slot", so activate
			effect eVFX = SupernaturalEffect(SetEffectSpellId(EffectNWN2SpecialEffectFile(sActivatableVFX), nActivatableVFXpos));
			SendMessageToPC(oPC, "You put on the "+ACR_CleanCreatureNameTextForPlayers(GetName(oItem)));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oPC);
			// cache info on the current effect so that it will wipe OnUnacquire
			SetLocalObject(oPC, "ACR_VFX_"+IntToString(nActivatableVFXpos), oItem);
			SetLocalInt(oItem, "WeapVFXnum", nActivatableVFXpos);
			SetLocalString(oItem, "WeapVFX", sActivatableVFX);
		}
	} else {
	    // maintain tag=scripname call for compatibility
    	ExecuteScript(sItemTag, oItem);
	}
	// NWN2-style activate scripts (preferred)
	string sActivateScript = "i_"+sItemTag+"_ac";
	ExecuteScript(sActivateScript, OBJECT_SELF);
}

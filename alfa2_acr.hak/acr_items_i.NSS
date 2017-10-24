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
//    2008/09/21  AcadiusLost: Added special handling for OOC items on acquire.
//  2009/01/14  AcadiusLost: Added native support for TKL performer
//  2009/02/01  AcadiusLost: Added special OnAcquire handling for bought items. 
//                    optimized OnAcquire() code to reduce login lag.
//  2009/02/09  AcadiusLost:  Added test for Returns LocalInt on the buying PC 
//  2009/08/15  AcadiusLost:  Added controls to prevent item dropping on the travelmap
//  2010/03/13  AcadiusLost:  Merged in code for activatable dynamic weapon VFX, added failsafe for NLD properties
//  2010/09/13  AcadiusLost:  Added hook for ACR Quests to Item Unacquire event, handling for activatable VFX items (earrings)
//  2010/09/19  AcadiusLost:  Added handling for Gender Restriction to OnEquip
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_ITEMS_I
#define ACR_ITEMS_I

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

int ACR_IP_ACP_OFFSET = 7 + IP_MISC_OFFSET;

//! Constant strings for VFX variables
const string ACR_VFX_NAME = "ACR_VFX_NAME";
const string ACR_VFX_POS = "ACR_VFX_POS";

const int ACR_ITEMS_CSHARP_ADJUSTPRICE = 0;
const int ACR_ITEMS_CSHARP_CALCULATE_PRICE = 1;
const int ACR_ITEMS_CSHARP_GENERATE_LOOT = 2;
const int ACR_ITEMS_CSHARP_GENERATE_AMULET = 3;
const int ACR_ITEMS_CSHARP_GENERATE_ARMOR = 4;
const int ACR_ITEMS_CSHARP_GENERATE_BELT = 5;
const int ACR_ITEMS_CSHARP_GENERATE_BOOTS = 6;
const int ACR_ITEMS_CSHARP_GENERATE_CLOAK = 7;
const int ACR_ITEMS_CSHARP_GENERATE_GLOVES = 8;
const int ACR_ITEMS_CSHARP_GENERATE_HELMET = 9;
const int ACR_ITEMS_CSHARP_GENERATE_RING = 10;
const int ACR_ITEMS_CSHARP_GENERATE_ROD = 11;
const int ACR_ITEMS_CSHARP_GENERATE_STAFF = 12;
const int ACR_ITEMS_CSHARP_GENERATE_WAND = 13;
const int ACR_ITEMS_CSHARP_GENERATE_SCROLLS = 14;
const int ACR_ITEMS_CSHARP_GENERATE_POTIONS = 15;


const int ACR_ITEMS_CSHARP_IPRP_CASTER_LEVEL = 400;
const int ACR_ITEMS_CSHARP_IPRP_SPELL_LEVEL = 401;
const int ACR_ITEMS_CSHARP_SPELL_LEVEL = 402;

//! Variable prefixes for spellcraft checks.
const string ACR_SCC_VAR_BASE = "ACR_SCC_";
const string ACR_SCC_VAR_POTION = "POTN_";
const string ACR_SCC_VAR_SCROLL = "SCRL_";

//! DCs for spellcraft checks.
const int ACR_SSC_DC_POTION = 25;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//
// Public
//

//! An invalid item property.
itemproperty ItemPropertyInvalid();

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

//! Checks all items in the inventory for an active item property.
int ACR_HasActiveItemProperty( object oPC, int nItemProperty, int bFullCheck = FALSE );

//! Creates random ACR-priced loot in a container.
//! oContainer -- the object which is to be filled with the generated loot.
//! nTotalValue -- the total value of items to be generated
//! nMaxSingleItem -- the maximum value of any item to be generated
//! nGenerationType -- what item type, if any, should be given priority in the 
//!   generation, using ACR_ITEMS_CSHARP_GENERATE_* constants.
void ACR_GenerateLoot( object oContainer, int nTotalValue, int nMaxSingleItem, int nGenerationType = ACR_ITEMS_CSHARP_GENERATE_LOOT );

//! Corrects the price of a given item, according to ALFA pricing standards
void ACR_CorrectPrice( object oItem );

//! Determines what the maximum value of appropriate item drops
//! are for a given level
//! nLevel -- the level to be checked
int GetMaxItemValue(int nLevel);

//! Returns TRUE if oItem is a potion.
int ACR_GetIsPotion( object oItem );

//! Returns TRUE if oItem is a scroll.
int ACR_GetIsScroll( object oItem );

//! Returns TRUE if oItem is a magical scroll.
int ACR_GetIsMagicScroll( object oItem ); 

//! Attempt to determine information about a target, using spellcraft.
//!  - oPC : Player character attempting to find information.
//!  - oTarget : The target to find information of.
void ACR_AttemptSpellcraftExamine( object oPC, object oTarget );

//! Gets the caster level that a spell cast property of nPropertySubType
//! would be cast at.
int ACR_GetSpellCastPropertyCasterLevel( int nPropertySubType );

//! Gets the spell level that a spell cast property of nPropertySubType
//! would be cast at.
int ACR_GetSpellCastPropertySpellLevel( int nPropertySubType );

//! Returns the first item property of the type specified.
//!  - oItem : The item to fetch a property from.
//!  - nEffect : The type of effect to return.
itemproperty ACR_GetFirstItemPropertyOfType( object oItem, int nType );

//! Returns a DAMAGE_TYPE_* variable, from a weapon.
//!  - oItem : The item to fetch a property from.
//!  - nEffect : The type of effect to return.
int ACR_GetWeaponDamageType( object oItem );

//! Returns TRUE or FALSE to indicate whether or
//! not a weapon gains benefit from weapon finesse.
int ACR_GetIsWeaponFinessable( object oItem );

// Private
//

//! Apply ACP effect for armor (double swim)
void _RecalcACP(object oPC);

//! Apply ACP effect for armor
void _ApplyACPSwim(object oItem, object oPC);

//! Remove ACP effect for armor
void _RemoveACPSwim(object oItem, object oPC);

//! Concatenates the variable name for spellcraft checks.
string GetSCCVar( string sType, int nCID );

//! Clear out all garbage variables related to spellcraft checks.
void ClearSCCVar( object oItem, string sType );

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_death_i"
#include "acr_quest_i"
#include "acr_tools_i"
#include "acr_combat_actions_i"
#include "acr_pchide_i"
#include "acr_vfx_i"
#include "acr_skills_i"
#include "acr_time_i"
#include "acr_spells_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

itemproperty ItemPropertyInvalid() {
	itemproperty ipInvalid;
	return ipInvalid;
}

void _RecalcACP(object oPC)
{
	object oChest, oShield, oHide;
	int t0, t1, penalty;

	oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	t0 = ACR_GetArmorRulesType(oChest);
	t1 = ACR_GetArmorRulesType(oShield);

	penalty = - (ACR_GetArmorCheckPenalty(t0) + ACR_GetArmorCheckPenalty(t1));

	// TODO: Calculate swimming penalty, apply it to creature or PC Hide.
}

void _ApplyACPSwim(object oItem, object oPC)
{
	_RecalcACP(oPC);
}

void _RemoveACPSwim(object oItem, object oPC)
{
	_RecalcACP(oPC);
}


string GetSCCVar( string sType, int nCID ) {
	return ( ACR_SCC_VAR_BASE + sType + IntToString( nCID ) );
}


void ClearSCCVar( object oItem, string sType ) {
	int i = 0;
	string sSubString = ACR_SCC_VAR_BASE + sType;
	for ( i = 0; i < GetVariableCount( oItem ); i++ ) {
		string sName = SafeGetVariableName( oItem, i );
		if ( FindSubString( sName, sSubString ) == 0 ) {
			DeleteLocalInt( oItem, sName );
			i--;
		}
	}
}


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
    if ((nCurrentWeaponType == BASE_ITEM_BASTARDSWORD) || (nItemType == BASE_ITEM_BASTARDSWORD))  {
        // special handling for equipped bastard swords, equipped already or being equipped.
        // Next, move on to the one/two-hand logic.
        if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC_BASTARD_SWORD, oPC)) {
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
    } else if((nCurrentWeaponType == BASE_ITEM_DWARVENWARAXE) || (nItemType == BASE_ITEM_DWARVENWARAXE))  {
      // once more, but this time with dwarven waraxes
              if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC_WARAXE, oPC) &&
                  !GetHasFeat(FEAT_WEAPON_PROFICIENCY_DWARF, oPC)) {
            object oFreeHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            if (oCurrentWeapon == oItem) {
                // make sure the off hand is cleared if bastardsword is equipped
                if (oFreeHand != OBJECT_INVALID) { AssignCommand(oPC, ActionUnequipItem(oFreeHand)); }
            } else if (oFreeHand == oItem) {
                if (nItemType == BASE_ITEM_DWARVENWARAXE) {
                    // trying to equip bastardsword in offhand, switch to RH
                    AssignCommand(oPC, ActionUnequipItem(oItem));
                    AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND));
                } else {
                    // Equipped non-BS item in free hand, unequip bastardsword
                    AssignCommand(oPC, ActionUnequipItem(oCurrentWeapon));
                }
            }
        }
    } else if (nItemType == BASE_ITEM_SHURIKEN) {
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMaxRangeStrengthMod(10), oItem, 24.0f * 60.0f * 60.0f);
    } else if (nItemType == BASE_ITEM_MANDOLIN) { 
        // activate the TKL performer package
        ExecuteScript("tkl_performer_lute", oPC);
    } else if (nItemType == BASE_ITEM_DRUM) { 
        // activate the TKL performer package
        ExecuteScript("tkl_performer_drum", oPC);
    } else if (nItemType == BASE_ITEM_FLUTE) { 
        // activate the TKL performer package
        ExecuteScript("tkl_performer_flute", oPC);
    }
	
	// Handle personal VFX hooks.
	ACR_PersonalVFXItemOnEquip( oPC, oItem );

    // Make sure that we're handling combat actions properly on equip.
    CombatActionsOnEquip(oPC, oItem);

    // Handle items for equip/remove darkvision
    if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION))
        ACR_AddTemporaryDarkvision(oPC, oItem);

    if (nItemType == BASE_ITEM_ARMOR || nItemType == BASE_ITEM_SMALLSHIELD || nItemType == BASE_ITEM_LARGESHIELD || nItemType == BASE_ITEM_TOWERSHIELD)
	    _ApplyACPSwim(oItem, oPC);

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
    } else if(nItemType == BASE_ITEM_SHURIKEN) {
        itemproperty ipProp = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ipProp)) {
            if(GetItemPropertyType(ipProp) == ITEM_PROPERTY_MIGHTY) {
                // As ALFA bans mighty as a property except on bows and crossbows,
                // it's safe to assume that a mighty item property on a shuriken
                // came from our on equip scripts.
                RemoveItemProperty(oItem, ipProp);
            }
            ipProp = GetNextItemProperty(oItem);
        }
    }

    if (nItemType == BASE_ITEM_ARMOR || nItemType == BASE_ITEM_SMALLSHIELD || nItemType == BASE_ITEM_LARGESHIELD || nItemType == BASE_ITEM_TOWERSHIELD)
    	_RemoveACPSwim(oItem, oPC);

    // Handle items for equip/remove darkvision
    if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION))
        ACR_RemoveTemporaryDarkvision(oPC, oItem);

	
	// Handle personal VFX hooks.
	ACR_PersonalVFXItemOnUnEquip( oPC, oItem );

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
    
    // Handle VFX unaquire event.
    ACR_PersonalVFXItemOnUnAcquire(oItem, oPC);

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

int ACR_HasActiveItemProperty( object oPC, int nItemProperty, int bFullCheck = FALSE ) {
	int i = 0;
	
	// Check equipped items.
	for ( i = 0; i < NUM_INVENTORY_SLOTS; i++ ) {
		// Some equipment slots don't count.
		if ( i == INVENTORY_SLOT_ARROWS ) continue;
		if ( i == INVENTORY_SLOT_BOLTS ) continue;
		if ( i == INVENTORY_SLOT_BULLETS ) continue;
	
		object oEquipment = GetItemInSlot( i, oPC );
		if ( GetIsObjectValid( oEquipment ) && GetItemHasItemProperty( oEquipment, nItemProperty ) ) {
			return TRUE;
		}
	}
	
	// Check constant effect items.
	if ( bFullCheck == TRUE ) {
		object oEquipment = GetFirstItemInInventory( oPC );
		while ( GetIsObjectValid( oEquipment ) ) {
			if ( GetItemPropActivation( oEquipment ) > 0 && GetItemHasItemProperty( oEquipment, nItemProperty ) ) {
				return TRUE;
			}
			oEquipment = GetNextItemInInventory( oPC );
		}
	}
	
	return FALSE;
}

void ACR_GenerateLoot( object oContainer, int nTotalValue, int nMaxSingleItem, int nGenerationType = ACR_ITEMS_CSHARP_GENERATE_LOOT )
{
	ClearScriptParams();
	AddScriptParameterObject(OBJECT_INVALID);
	AddScriptParameterInt(nGenerationType);
	AddScriptParameterInt(nTotalValue);
	AddScriptParameterInt(nMaxSingleItem);
	ExecuteScriptEnhanced("ACR_Items", oContainer, TRUE);
}

void ACR_CorrectPrice( object oItem )
{
	ClearScriptParams();
	AddScriptParameterObject(oItem);
	AddScriptParameterInt(1);
	AddScriptParameterInt(-1);
	AddScriptParameterInt(-1);
	ExecuteScriptEnhanced("ACR_Items", GetItemPossessor(oItem), TRUE);
}

int GetMaxItemValue(int nLevel)
{
	if(nLevel == 1)  return 300;
	if(nLevel == 2)  return 300;
	if(nLevel == 3)  return 875;
	if(nLevel == 4)  return 1750;
	if(nLevel == 5)  return 2925;
	if(nLevel == 6)  return 4225;
	if(nLevel == 7)  return 6175;
	if(nLevel == 8)  return 8775;
	if(nLevel == 9)  return 11700;
	if(nLevel == 10) return 15925;
	if(nLevel == 11) return 21450;
	if(nLevel == 12) return 28600;
	if(nLevel == 13) return 35750;
	if(nLevel == 14) return 48750;
	if(nLevel == 15) return 65000;
	if(nLevel == 16) return 84500;
	if(nLevel == 17) return 110500;
	if(nLevel == 18) return 143000;
	if(nLevel == 19) return 188500;
	if(nLevel == 20) return 250000;
	return -1;
}


int ACR_GetIsPotion( object oItem ) {
	if ( GetBaseItemType( oItem ) == BASE_ITEM_POTIONS ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_POTIONS_USABLE_ON_OTHERS ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_BLANK_POTION ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_ENCHANTED_POTION ) return TRUE;
	return FALSE;
}


int ACR_GetIsScroll( object oItem ) {
	if ( GetBaseItemType( oItem ) == BASE_ITEM_SCROLL ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_BLANK_SCROLL ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_ENCHANTED_SCROLL ) return TRUE;
	if ( GetBaseItemType( oItem ) == BASE_ITEM_SPELLSCROLL ) return TRUE;
	return FALSE;
}


int ACR_GetIsMagicScroll( object oItem ) {
	// Limit to certain base item types.
	if ( !ACR_GetIsScroll( oItem ) ) return FALSE;

	// Must be able to cast a spell to be considered magical.
	if ( !GetItemHasItemProperty( oItem, ITEM_PROPERTY_CAST_SPELL ) ) return FALSE;

	// If nothing is wrong so far, return success.
	return TRUE;
}


void ACR_AttemptSpellcraftExamine( object oPC, object oTarget ) {
	// We don't need to identify identified items.
	if ( GetIdentified( oTarget ) ) {
		return;
	}
	
	// We also can only identify items with this.
	if ( GetObjectType( oTarget ) != OBJECT_TYPE_ITEM ) {
		return;
	}

	// Make sure that our PC is an actual PC.
	int nCharID = ACR_GetCharacterID( oPC );
	if ( nCharID == 0 ) {
		SendMessageToPC( oPC, "ERROR: Only actual PCs may use spellcraft to identify items." );
		return;
	}
	
	// Spellcraft is a trained only skill.
	if ( GetSkillRank( SKILL_SPELLCRAFT, oPC, TRUE ) == 0 ) {
		SendMessageToPC( oPC, "Your grasp of Spellcraft leaves you unsure of the nature of this item." );
		return;
	}
	
	// A DC 25 spellcraft check identifies potions. No retry.
	if ( ACR_GetIsPotion( oTarget ) ) {
		string sPotionVar = GetSCCVar( ACR_SCC_VAR_POTION, nCharID );
		if ( GetLocalInt( oTarget, sPotionVar ) == 0 ) {
			if ( ACR_SkillCheck( SKILL_SPELLCRAFT, oPC, ACR_SSC_DC_POTION, TRUE, TRUE ) ) {
				SendMessageToPC( oPC, "You have successfully identified this potion." );
				SetIdentified( oTarget, TRUE );
				ClearSCCVar( oTarget, ACR_SCC_VAR_POTION );
			} else {
				SendMessageToPC( oPC, "You have failed to identify this potion." );
				SetLocalInt( oTarget, sPotionVar, 1 );
			}
		}
		return;
	}
	
	// A DC 20 + Spell Level spellcraft check identifies a magic scroll.
	if ( ACR_GetIsScroll( oTarget ) ) {
		// Read magic lets us auto-succeed at this.
		if ( GetHasSpellEffect( SPELL_READ_MAGIC, oPC ) ) {
			SendMessageToPC( oPC, "Your divination reveals the nature of this scroll." );
			SetIdentified( oTarget, TRUE );
			ClearSCCVar( oTarget, ACR_SCC_VAR_SCROLL );
			return;
		}
		
		// A check is allowed once every 24 hours.
		string sScrollVar = GetSCCVar( ACR_SCC_VAR_SCROLL, nCharID );
		if ( GetLocalInt( oTarget, sScrollVar ) == 0 || GetLocalInt( oTarget, sScrollVar ) + 24 <= ACR_GetTimeStampInHours()  ) {
			// DC = 20 + Spell Level
			int nDC = 20 + ACR_GetSpellCastPropertySpellLevel( GetItemPropertySubType( ACR_GetFirstItemPropertyOfType( oTarget, ITEM_PROPERTY_CAST_SPELL ) ) );
			if ( ACR_SkillCheck( SKILL_SPELLCRAFT, oPC, nDC, TRUE, TRUE ) ) {
				// On success, report happiness and clear up related variables.
				SendMessageToPC( oPC, "You have successfully identified this scroll." );
				SetIdentified( oTarget, TRUE );
				ClearSCCVar( oTarget, ACR_SCC_VAR_SCROLL );
			} else {
				SendMessageToPC( oPC, "You have failed to identify this scroll. You may not try for another day." );
				SetLocalInt( oTarget, sScrollVar, ACR_GetTimeStampInHours() );
			}
		} else {
			SendMessageToPC( oPC, "You must wait another " + IntToString( GetLocalInt( oTarget, sScrollVar ) + 24 - ACR_GetTimeStampInHours() ) + " hours to attempt a spellcraft check." );
		}
		return;
	}
}

int ACR_GetSpellCastPropertyCasterLevel( int nPropertySubType )
{
    ClearScriptParams();
    AddScriptParameterObject(OBJECT_INVALID);
    AddScriptParameterInt(ACR_ITEMS_CSHARP_IPRP_CASTER_LEVEL);
    AddScriptParameterInt(nPropertySubType);
    return ExecuteScriptEnhanced("ACR_Items", OBJECT_SELF, TRUE);
}

int ACR_GetSpellCastPropertySpellLevel( int nPropertySubType )
{
    ClearScriptParams();
    AddScriptParameterObject(OBJECT_INVALID);
    AddScriptParameterInt(ACR_ITEMS_CSHARP_IPRP_SPELL_LEVEL);
    AddScriptParameterInt(nPropertySubType);
    return ExecuteScriptEnhanced("ACR_Items", OBJECT_SELF, TRUE);
}

itemproperty ACR_GetFirstItemPropertyOfType( object oItem, int nType ) {
	itemproperty ipProp = GetFirstItemProperty( oItem );
	while ( GetIsItemPropertyValid( ipProp ) ) {
		if ( GetItemPropertyType( ipProp ) == nType ) {
			return ipProp;
		}
		ipProp = GetNextItemProperty( oItem );
	}
	return ItemPropertyInvalid();
}

int ACR_GetWeaponDamageType( object oItem ) {
	switch ( GetWeaponType( oItem ) ) {
		case WEAPON_TYPE_BLUDGEONING: return DAMAGE_TYPE_BLUDGEONING; break;
		case WEAPON_TYPE_PIERCING: return DAMAGE_TYPE_PIERCING; break;
	}
	return DAMAGE_TYPE_SLASHING;
}

int ACR_GetIsWeaponFinessable(object oItem) {
  switch(GetBaseItemType(oItem))
  {
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_WHIP:
        return TRUE;
  }
  return FALSE;
}

#endif

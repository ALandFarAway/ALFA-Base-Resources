////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_tradescroll_i
//    $Revision:: 1        $ current version of the file
//        $Date:: 2009-01-14#$ date the file was created or modified
//       Author : AcadiusLost
//
//    Var Prefix: ACR_TRADESCROLL
//  Dependencies: x2_inc_craft, spellhook, tradescroll blueprint, spellbook blueprint
//
//  Description
//  This file contains the code necessary to support tradescroll generation
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_TRADESCROLL_I
#define ACR_TRADESCROLL_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "x2_inc_switches"
#include "x2_inc_craft"

#include "acr_items_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//!these are the item tags and resref of your spellbook and tradescroll items
//! TRADE_SCROLL_COST is per spell level
const int ACR_TRADESCROLL_COST = 25;

//! resref for tradescrolls
const string ACR_TRADESCROLL_RESREF = "acr_it_tradescroll";

//! tag for an item you mark as a trade scroll in the toolset
const string ACR_TRADESCROLL_TAG = "acr_it_tradescroll";

//! Local variable that holds the tradescroll's spell ID.
const string ACR_TRADESCROLL_VAR = "ACR_TRADESCROLL_SPELL";


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

void ACR_CreateTradeScroll( object oPC, int nSpellId );

//! *** PRIVATE FUNCTIONS ***

//! this function activates the Trade Scroll system
//!  Make sure you check for a true return value and end the spellhook
int _DoTradeScrollSpellHook();

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_CreateTradeScroll( object oPC, int nSpellId ) {
	// Valid spell ID?
	if ( nSpellId < 0 ) {
		SendMessageToPC( oPC, "Invalid spell ID: " + IntToString( nSpellId ) );
		return;
	}
	
	// Find spell data.
	int nMasterSpell = StringToInt( Get2DAString( "spells", "Master", nSpellId ) );
	string sSpellName = GetStringByStrRef( StringToInt( Get2DAString( "spells", "Name", nSpellId ) ) );
	int nSpellLevel = StringToInt( Get2DAString( "spells", "Wiz_Sorc", nSpellId ) );
	int nCost = ACR_TRADESCROLL_COST * nSpellLevel;
	
	// Check requirements.
	if ( !GetIsDM( oPC ) ) {
		// Do you know the spell?
		if ( !GetSpellKnown( oPC, nSpellId ) ) {
			SendMessageToPC( oPC, "You cannot create tradescrolls of spells you do not know." );
			return;
		}
		
		// Do we have enough gold?
		if ( GetGold( oPC ) < nCost ) {
			SendMessageToPC( oPC, "You must have at least " + IntToString( nCost ) + " gold to create this tradescroll." );
			return;
		}
	}
	
	// Determine which spell to create.
	int nSpellToCreate = nSpellId;
	if ( !GetIsDM( oPC ) && nMasterSpell > 0 ) nSpellToCreate = nSpellId;
	
	// Remove resources.
	if ( !GetIsDM( oPC ) ) {
		TakeGoldFromCreature( nCost, oPC, TRUE, TRUE );
	}
	
	// Create the tradescroll.
	object oScroll = CreateItemOnObject( ACR_TRADESCROLL_RESREF, oPC );
	SetLocalInt( oScroll, ACR_TRADESCROLL_VAR, nSpellToCreate );
}


void ACR_LearnTradescroll( object oPC, object oTradescroll ) {
	int nSpellId = GetLocalInt( oTradescroll, ACR_TRADESCROLL_VAR );
	
	// Valid tradescroll?
	if ( nSpellId == 0 ) {
		SendMessageToPC( oPC, "Invalidly configured tradescroll." );
		DestroyObject( oTradescroll );
		return;
	}
	
	// Do we already know the spell?
	if ( GetSpellKnown( oPC, nSpellId ) ) {
		SendMessageToPC( oPC, "You already know this spell." );
		return;
	}
	
	// Has wizard levels?
	int nWizardPosition = -1;
	int i = 0;
	for ( i = 0; i < 4; i++ ) if ( GetClassByPosition( i, oPC ) == CLASS_TYPE_WIZARD ) nWizardPosition = i;
	if ( nWizardPosition == -1 ) {
		SendMessageToPC( oPC, "Only wizards may use tradescrolls." );
		return;
	}
	
	// Learn the spell.
	SetSpellKnown( oPC, nWizardPosition, nSpellId, TRUE, FALSE );
	DestroyObject( oTradescroll );
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////


int _DoTradeScrollSpellHook()
{
    int nCost = 0;
    int nReturn = FALSE;
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    object oItem = GetSpellCastItem();
    //if an ability booster spell is cast, then trigger our version of the spell
	
    if (GetResRef(oItem) == ACR_TRADESCROLL_RESREF || (FindSubString(GetTag(oItem), ACR_TRADESCROLL_TAG) != -1)) {
        SendMessageToPC(OBJECT_SELF, "You cannot cast spells through trade scrolls as they are not imbued with magic.");
        SetModuleOverrideSpellScriptFinished();
        return TRUE;
    }

    if (GetResRef(oTarget) == ACR_MOD_SPELLBOOK_RESREF)
    {
        ACR_CreateTradeScroll( OBJECT_SELF, nSpell );
        SetModuleOverrideSpellScriptFinished();
        nReturn = TRUE;
    }
    return nReturn;
}

#endif
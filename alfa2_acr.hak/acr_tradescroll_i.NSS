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

#ifndef ACR_TSCROLL_I
#define ACR_TSCROLL_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//!these are the item tags and resref of your spellbook and tradescroll items
//! TRADE_SCROLL_COST is per spell level
const int ACR_TRADESCROLL_COST = 25;

//! Index of the tradescroll item property.
const int ACR_TRADESCROLL_IPRP_SPELL = 1474;

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
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_switches"
#include "x2_inc_craft"

#include "acr_i"
#include "acr_items_i"
#include "acr_tools_i"

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
	
	// Determine which spell to create.
	int nMasterSpell = StringToInt( Get2DAString( "spells", "Master", nSpellId ) );
	int nSpellToCreate = nSpellId;
	if ( !GetIsDM( oPC ) && nMasterSpell > 0 ) nSpellToCreate = nMasterSpell;
	
	// Find spell data.
	string sSpellName = GetStringByStrRef( StringToInt( Get2DAString( "spells", "Name", nSpellToCreate ) ) );
	string sSpellLevel = Get2DAString( "spells", "Wiz_Sorc", nSpellToCreate );
	int nSpellLevel = StringToInt( sSpellLevel );
	int nCost = ACR_TRADESCROLL_COST * nSpellLevel;
	
	// Must be a wizard spell.
	if ( nSpellLevel == 0 && sSpellLevel != "0" ) {
		SendMessageToPC( oPC, "Only wizard spells can be made into tradescrolls." );
		return;
	}
	
	// Check requirements.
	if ( !GetIsDM( oPC ) ) {
		// Has wizard levels?
		int nWizardPosition = GetClassPosition( oPC, CLASS_TYPE_WIZARD );
		if ( nWizardPosition == -1 ) {
			SendMessageToPC( oPC, "Only wizards may use tradescrolls." );
			return;
		}
		
		// Do you know the spell?
		if ( !GetSpellKnown( oPC, nSpellToCreate ) ) {
			SendMessageToPC( oPC, "You cannot create tradescrolls of spells you do not know." );
			return;
		}
		
		// Do we have enough gold?
		if ( GetGold( oPC ) < nCost ) {
			SendMessageToPC( oPC, "You must have at least " + IntToString( nCost ) + " gold to create this tradescroll." );
			return;
		}
	}
	
	// Don't let tradescrolls be made of ID 0.
	if ( nSpellToCreate == 0 ) {
		SendMessageToPC( oPC, "An error has occurred. Please report this bug." );
		return;
	}
	
	// Create the tradescroll.
	object oScroll = CreateItemOnObject( ACR_TRADESCROLL_RESREF, oPC, 1, "", FALSE );
	if ( !GetIsObjectValid( oScroll ) ) {
		SendMessageToPC( oPC, "<C=red>Could not create tradescroll. Please report this bug on the forums.</C>" );
		return;
	}
	
	// Remove resources.
	if ( !GetIsDM( oPC ) ) {
		AssignCommand( oPC, ClearAllActions() );
		AssignCommand( oPC, TakeGoldFromCreature( nCost, oPC, TRUE, FALSE ) );
	}
	
	// Set name, description, item property, and local variable.
	SetFirstName( oScroll, "Tradescroll: " + sSpellName );
	SetLastName( oScroll, "" );
	SetDescription( oScroll, "This scroll represents the work done and resources used to copy a spell from one wizard's spellbook to another. This scroll holds the knowledge of " + sSpellName + "." );
	itemproperty ipTradescrollProp = ItemPropertyCastSpell( ACR_TRADESCROLL_IPRP_SPELL, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );
	AddItemProperty( DURATION_TYPE_PERMANENT, ipTradescrollProp, oScroll );
	SetLocalInt( oScroll, ACR_TRADESCROLL_VAR, nSpellToCreate );
	
	// Log event, send feedback to PC.
	string sMessage = "Created a tradescroll of " + sSpellName + " for " + IntToString( nCost ) + "gp in supplies.";
	SendMessageToPC( oPC, sMessage );
	ACR_IncrementStatistic( "TSCROLL_CREATE" );
	ACR_LogEvent( oPC, ACR_LOG_TSCROLL_CREATE, sMessage );
}


void ACR_LearnTradescroll( object oPC, object oTradescroll ) {
	int nSpellId = GetLocalInt( oTradescroll, ACR_TRADESCROLL_VAR );
	
	// Valid tradescroll?
	if ( nSpellId == 0 ) {
		SendMessageToPC( oPC, "Invalidly configured tradescroll." );
		DestroyObject( oTradescroll );
		return;
	}
	
	// Has wizard levels?
	int nWizardPosition = GetClassPosition( oPC, CLASS_TYPE_WIZARD );
	if ( nWizardPosition == -1 ) {
		SendMessageToPC( oPC, "Only wizards may use tradescrolls." );
		return;
	}
	
	// Do we already know the spell?
	if ( GetSpellKnown( oPC, nSpellId ) ) {
		SendMessageToPC( oPC, "You already know this spell." );
		return;
	}
	
	// Learn the spell.
	SetSpellKnown( oPC, nWizardPosition - 1, nSpellId, TRUE, FALSE );
	DestroyObject( oTradescroll );
	
	// Log event, send feedback to PC.
	string sSpellName = GetStringByStrRef( StringToInt( Get2DAString( "spells", "Name", nSpellId ) ) );
	string sMessage = "You have scribed " + sSpellName + " to your spellbook.";
	SendMessageToPC( oPC, sMessage );
	ACR_IncrementStatistic( "TSCROLL_LEARN" );
	ACR_LogEvent( oPC, ACR_LOG_TSCROLL_LEARNED, ACR_SQLEncodeSpecialChars( sMessage ) + " Spell ID " + IntToString( nSpellId ) );
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////


int _DoTradeScrollSpellHook()
{
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

    if (GetResRef(oTarget) == ACR_MOD_SPELLBOOK_RESREF && GetIdentified(oTarget))
    {
        ACR_CreateTradeScroll( OBJECT_SELF, nSpell );
        SetModuleOverrideSpellScriptFinished();
        nReturn = TRUE;
    }

    return nReturn;
}

#endif
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
//  Revision History
//  2009/01/14 AcadiusLost Inception
////////////////////////////////////////////////////////////////////////////////

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
const string ACR_TRADESCROLL_RESREF="acr_it_tradescroll";

//! tag for an item you mark as a trade scroll in the toolset
const string ACR_TRADESCROLL_TAG="acr_it_tradescroll";


////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

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
        if ((GetLastSpellCastClass() == CLASS_TYPE_WIZARD) || GetIsDM(OBJECT_SELF))
        {
            int nPropID = IPGetIPConstCastSpellFromSpellID(nSpell);
            if (nPropID == -1)
            {
                SendMessageToPC(OBJECT_SELF, "For some reason you can't copy this spell. Possibly a bug! Ask!");
            }
            else
            {
				string sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpell)));
				int nSpellLevel = StringToInt(Get2DAString("spells", "Wiz_Sorc", nSpell));
            	nCost =  nSpellLevel * ACR_TRADESCROLL_COST;
				// cantrips should cost half of a 1st level spell.
				if (nCost == 0) { nCost = 12; }
                if (GetGold() >= nCost || GetIsDM(OBJECT_SELF))
                {
                    object oScroll = CreateItemOnObject(ACR_TRADESCROLL_RESREF, OBJECT_SELF);
                    IPRemoveAllItemProperties(oScroll, DURATION_TYPE_PERMANENT);
                    itemproperty iProp = ItemPropertyCastSpell(nPropID, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
                    AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oScroll);
                    SendMessageToPC(OBJECT_SELF, "You have created a trading copy.");
					SetFirstName(oScroll, "Tradescroll, "+sSpellName);
					SetDescription(oScroll, "This is a nonmagical trade copy of the spell "+sSpellName+".  It does not hold the energy necessary to actually cast the spell, but may be used to copy into a spellbook.  Tradescrolls cost 25 gp per spell level to transcribe, with cantrips costing 12gp.");
                    TakeGoldFromCreature(nCost, OBJECT_SELF, TRUE);
                }
                else SendMessageToPC(OBJECT_SELF, "You don't have enough gold to make a copy of this spell.");
            }
        }
        else
        {
                SendMessageToPC(OBJECT_SELF, "Only wizard spells may be copied into tradescrolls.");
        }
        SetModuleOverrideSpellScriptFinished();
        nReturn = TRUE;
    }
    return nReturn;
}
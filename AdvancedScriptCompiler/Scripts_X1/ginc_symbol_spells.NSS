// ginc_symbol_spells
/*

	Include file for use in Symbol of ______ spells.
	
*/
// MDiekmann 9/5/07

#include "ginc_debug"
#include "ginc_event_handlers"

// -------------------------------------------------------
// Constants
// -------------------------------------------------------

const string SYMBOL_OF_DEATH 		= "death";
const string SYMBOL_OF_FEAR 		= "fear";
const string SYMBOL_OF_PAIN 		= "pain";
const string SYMBOL_OF_PERSUASION 	= "persuasion";
const string SYMBOL_OF_SLEEP	 	= "sleep";
const string SYMBOL_OF_STUNNING 	= "stunning";
const string SYMBOL_OF_WEAKNESS 	= "weakness";

// Magic trap description
const int nTRAP_DESCRIPTION			= 210911;

// goes through a count until it finds a unique number for this symbol
int GetSymbolUniqueID(string sSymbolType)
{
	int nID = 0;
	string sSymbol = "symbol_of_" + sSymbolType + IntToString(nID);
	object oSymbol = GetObjectByTag(sSymbol);
	
	while(GetIsObjectValid(oSymbol))
	{
		nID++;
		sSymbol = "symbol_of_" + sSymbolType + IntToString(nID);
		oSymbol = GetObjectByTag(sSymbol);
	}
	return nID;
}

// returns the constant of the trap as defined in traps.2da

int GetTrapConstant(string sSymbolType)
{
	int nTrapConstant = 0;
	
	// Symbol of death
	if(sSymbolType == SYMBOL_OF_DEATH)
		nTrapConstant = 58;
	// Symbol of fear
	else if(sSymbolType == SYMBOL_OF_FEAR)
		nTrapConstant = 59;
	// Symbol of pain
	else if(sSymbolType == SYMBOL_OF_PAIN)
		nTrapConstant = 60;
	// Symbol of persuasion
	else if(sSymbolType == SYMBOL_OF_PERSUASION)
		nTrapConstant = 61;
	// Symbol of sleep
	else if(sSymbolType == SYMBOL_OF_SLEEP)
		nTrapConstant = 62;	
	// Symbol of stunning
	else if(sSymbolType == SYMBOL_OF_STUNNING)
		nTrapConstant = 63;
	// Symbol of weakness
	else if(sSymbolType == SYMBOL_OF_WEAKNESS)
		nTrapConstant = 64;
	//invalid symbol
	else
		PrettyError("Invalid Symbol Type :" + sSymbolType);
	
	return nTrapConstant;
}

// does the leg work of setting up symbol
void SetUpSymbol(string sSymbolType)
{
	// Get spell location
    location lTarget	= GetSpellTargetLocation();
    object oCaster 		= OBJECT_SELF;
	// Spell duration
	float fDuration		= TurnsToSeconds(GetCasterLevel(oCaster));
	// Symbol unique ID
	int nID 			= GetSymbolUniqueID(sSymbolType);
	string sID			= IntToString(nID);
	string sTriggered	= "nx2_s0_symbol_of_" + sSymbolType + "a";
	string sDescription = GetStringByStrRef(nTRAP_DESCRIPTION);
	// Trap constant
	int nTrapConstant	= GetTrapConstant(sSymbolType);
	// Effect with appropriate onEnter script, name it appropriately
	effect eAOE 		= EffectAreaOfEffect(65, sTriggered, "", "", "symbol_of_" + sSymbolType + sID);
	object oTrap;

	// Apply AOE to location and create trap
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
	// different trap and aoe faction based on faction
	if(GetStandardFactionReputation(STANDARD_FACTION_HOSTILE) >= 51)
	{
		oTrap = CreateTrapAtLocation(nTrapConstant, lTarget, 2.25f, "", STANDARD_FACTION_HOSTILE);
	}
	else if(GetStandardFactionReputation(STANDARD_FACTION_HOSTILE) <= 50)
	{
		oTrap = CreateTrapAtLocation(nTrapConstant, lTarget, 2.25f, "", STANDARD_FACTION_DEFENDER);
	}
	
	// Setup trap variables and event handlers
	SetLocalString(oTrap, "Symbol_Type", sSymbolType + sID);
	SetLocalString(oTrap, "OnTriggered", sTriggered);
	SetTrapOneShot(oTrap, FALSE);
	SetTrapRecoverable(oTrap, FALSE);
	SetEventHandler(oTrap, SCRIPT_TRIGGER_ON_HEARTBEAT, "nx2_b_symbol_hb");
	SetEventHandler(oTrap, SCRIPT_TRIGGER_ON_DISARMED, "nx2_b_symbol_disarm");
	SetEventHandler(oTrap, SCRIPT_TRIGGER_ON_TRAPTRIGGERED, "nx2_b_symbol_triggered");
	SetDescription(oTrap, sDescription);
	
	// Special case symbols 
	if (sSymbolType == SYMBOL_OF_DEATH)
	{
		object oAOE = GetObjectByTag("symbol_of_death" + sID);
		SetLocalInt(oAOE, "Local_Damage", 150);
	}
}
////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_creature_i
//    $Revision:: 533        $ current version of the file
//        $Date:: 2009-12-25#$ date the file was created or modified
//       Author : Cipher & AcadiusLost
//
//    Var Prefix: ACR_CRE
//  Dependencies: None
//
//  Description
//  This script handles events executed on all creatures, either PCs or NPCs.
//
//  http://www.alandfaraway.org/docs/Technical/ACR2Creatures
//
//  Revision History
//  2006/11/01  Cipher  Added calls to VFX functions
//  2007/01/24  Cipher  Added link to ALFA Wiki placeables article
//  2007/03/20  Cipher  Added new includes and corrected filename
//  2007/03/20  Cipher  Added ACR_ReportSpawnDeath() call and corrected function names
//  2007/04/28  AcadiusLost Added calls to normal AI functions
//  2007/07/01  AcadiusLost included acr_xp_i, altered ACR_creatureondeath for rewards
//  2007/07/15  AcadiusLost scavenged useful code from default spawn and death scripts,
//                  also removed default treasure drops
//  2007/08/17  AcadiusLost added OnSpawn gold for random loot drops.
//  2007/08/20  Cipher  Added auto creature identification, cleaned up code
//  2007/09/02  Cipher  Added quest system bounty hook
//  2007/09/16  AcadiusLost amended events include
//  2007/09/21  Cipher  Modified quest function name
//  2007/04/17  AcadiusLost - commented out VFX calls and PC heartbeat/perception test
//  2008/04/04  Cipher  Added loot drop code hooks OnDeath
//  2009/12/25  AcadiusLost - added NoAI workaround hooks, linked identification to knowledge skills
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "x0_i0_anims"

#include "acr_events_i"
#include "acr_xp_i"
#include "acr_nonlethal_i"
#include "acr_spawn_i"
#include "acr_vfx_i"
#include "acr_wealth_i"
#include "acr_quest_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string _CRE_NO_AI = "ACR_CRE_NO_AI";
const string ACR_CRE_ISUNDEAD = "ACR_CRE_ISUNDEAD";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Puts oCreature in modes that let it run.
void _startRunning(object oCreature = OBJECT_SELF);

// The ACR's Creature event handler.
void ACR_CreatureOnSpawnIn();

// The ACR's Creature event handler.
void ACR_CreatureOnSpellCastAt();

// The ACR's Creature event handler.
void ACR_CreatureOnPhysicallyAttacked();

// The ACR's Creature event handler.
void ACR_CreatureOnDamaged();

// The ACR's Creature event handler.
void ACR_CreatureOnDeath();

// The ACR's Creature event handler.
void ACR_CreatureOnBlocked();

// The ACR's Creature event handler.
void ACR_CreatureOnEndCombatRound();

// The ACR's Creature event handler.
void ACR_CreatureOnConversation();

// The ACR's Creature event handler.
void ACR_CreatureOnInventoryDisturbed();

// The ACR's Creature event handler.
void ACR_CreatureOnHeartBeat();

// The ACR's Creature event handler.
void ACR_CreatureOnRested();

// The ACR's Creature event handler.
void ACR_CreatureOnPerception();

// The ACR's Creature event handler.
void ACR_CreatureOnUserDefined();

//! This function performs a creature identification check by oPC on oTarget
void ACR_CreatureIdentify(object oPC, object oTarget);

//! Checks if the creature is an undead type, even if it is not racially categorized as undead.
int ACR_GetIsUndead( object oTarget );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void _startRunning(object oCreature = OBJECT_SELF) {
	if(!GetHasFeat(FEAT_KEEN_SENSE, oCreature, TRUE))
		SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
	
	SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
}

void ACR_CreatureOnSpawnIn()
{
    // apply any effects on the creature
    ACR_VFXOnSpawn(OBJECT_SELF);
	
	// Process item spawn in:
	object oItem = GetFirstItemInInventory();
	while(oItem != OBJECT_INVALID) {
		SetIdentified(oItem, TRUE);
		oItem = GetNextItemInInventory();
	}
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_ARMS), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_ARROWS), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_BELT), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_BOLTS), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_BOOTS), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_BULLETS), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CARMOUR), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CHEST), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CLOAK), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_HEAD), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_LEFTHAND), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_LEFTRING), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_NECK), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND), TRUE);
	SetIdentified(GetItemInSlot(INVENTORY_SLOT_RIGHTRING), TRUE);
	
    
    // Scavenged code from nw_c2_default9.nss 
    // ---------- Begin scavenged code --------------------
    
    // Enable immobile ambient animations by setting a variable
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
    }
    // Enable mobile ambient animations by setting a variable
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
    }
    // ***** DEFAULT GENERIC BEHAVIOR ***** //
    // * Goes through and sets up which shouts the NPC will listen to.
    SetListeningPatterns();

    // * Walk among a set of waypoints if they exist.
    // * 1. Find waypoints with the tag "WP_" + NPC TAG + "_##" and walk
    // *    among them in order.
    // * 2. If the tag of the Way Point is "POST_" + NPC TAG, stay there
    // *    and return to it after combat.
    //
    // * If "NW_FLAG_DAY_NIGHT_POSTING" is set, you can also
    // * create waypoints with the tags "WN_" + NPC Tag + "_##"
    // * and those will be walked at night. (The standard waypoints
    // * will be walked during the day.)
    // * The night "posting" waypoint tag is simply "NIGHT_" + NPC tag.
    WalkWayPoints(FALSE, "spawn");

    // ---------- end scavenged code --------------------
}

void ACR_CreatureOnSpellCastAt()
{
    object oCaster = GetLastSpellCaster();
	
	if(GetLastSpellHarmful()) {
		// I've probably been spotted. Get out of modes that keep me from running.
		_startRunning();
	}

    // apply any effects on the creature
    //ACR_VFXOnSpellCastAt(oCaster, OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_defaultb", OBJECT_SELF);  
	}  
}

void ACR_CreatureOnPhysicallyAttacked()
{
    object oAttacker = GetLastAttacker();
	
	// I've probably been spotted. Get out of modes that keep me from running.
	_startRunning();
    
    // apply any effects on the creature
    //ACR_VFXOnAttack(oAttacker, OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) { 
   		// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default5", OBJECT_SELF);
	}
}

void ACR_CreatureOnDamaged()
{
    object oDamager = GetLastDamager();

    //DoNonlethalOnDamaged();
	
	// I've probably been spotted. Get out of modes that keep me from running.
	_startRunning();
    
    // apply any effects on the creature
    //ACR_VFXOnDamage(oDamager, OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default6", OBJECT_SELF);
	}    
}

void ACR_CreatureOnDeath()
{
    object oKiller = GetLastKiller();

    // report the death to the spawn system
    ACR_ReportSpawnDeath(OBJECT_SELF);

    // apply any effects on the creature
    //ACR_VFXOnDeath(oKiller, OBJECT_SELF);

    // Call the ALFA XP award functions to handle XP award
    ACR_AwardCombatXP(oKiller, OBJECT_SELF);

    // generate loot drops for mob kills
    if (! GetIsPC(OBJECT_SELF)) { ACR_GenerateTreasure(OBJECT_SELF, ACR_GetRandomDropValue(OBJECT_SELF)); }
    
    // Code scavenged from nw_c2_default7, to handle AI
    //  ----start borrowed code -----------------
    
    // Call to allies to let them know we're dead
    SpeakString("NW_I_AM_DEAD", TALKVOLUME_SILENT_TALK);
    
    //Shout Attack my target, only works with the On Spawn In setup
    SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);

    // ----end borrowed code --------------------

    // process bounties
    ACR_QuestCreatureOnDeath(oKiller);
}

void ACR_CreatureOnBlocked()
{
	if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_defaulte", OBJECT_SELF);
	}
}

void ACR_CreatureOnEndCombatRound()
{
	if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default3", OBJECT_SELF);
	}
}

void ACR_CreatureOnConversation()
{
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default4", OBJECT_SELF);
	}
}

void ACR_CreatureOnInventoryDisturbed()
{
    object oDisturber = GetLastDisturbed();

    // apply any effects on the creature
    ACR_VFXOnDisturb(oDisturber, OBJECT_SELF);

    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {	    
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default8", OBJECT_SELF);
	}
}

void ACR_CreatureOnHeartBeat()
{
    // if this is a pc, check if they perceive any creatures
    // AcadiusLost - deleted for now
    /*
    if (GetIsPC(OBJECT_SELF))
    {
        // ignore DMs
        if (GetIsDM(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF)) { return; }
        
        // do the math - calculate an coordinate offset based on orientation angle

        vector vPosition = GetPositionFromLocation(GetLocation(OBJECT_SELF));
        float fX, fY, fLength = RADIUS_SIZE_VAST, fRatio = fLength/90.0, fFacing = GetFacing(OBJECT_SELF);
        int nNumIncrements = FloatToInt(fFacing) % 90;
        
        // handle angle rollovers
        if (fFacing == 360.0) { fFacing = 0.0; }
        
        // compute the target x and y coordinates based on the orientation quadrant
        if (fFacing < 90.0 && fFacing >= 0.0)
        {
            fX = vPosition.x + fLength - (nNumIncrements * fRatio); fY = vPosition.y + (nNumIncrements * fRatio);
        }
        else if (fFacing < 180.0 && fFacing >= 90.0)
        {
            fX = vPosition.x - (nNumIncrements * fRatio); fY = vPosition.y + fLength - (nNumIncrements * fRatio);
        }
        else if (fFacing < 270.0 && fFacing >= 180.0)
        {
            fX = vPosition.x - fLength + (nNumIncrements * fRatio); fY = vPosition.y - (nNumIncrements * fRatio);
        }
        else if (fFacing < 360.0 && fFacing >= 270.0)
        {
            fX = vPosition.x + (nNumIncrements * fRatio); fY = vPosition.y - fLength + (nNumIncrements * fRatio);
        }

        // generate the location marking the endpoint of the cone
        location lLocation = Location(GetArea(OBJECT_SELF), Vector(fX, fY, vPosition.z), fFacing);
        
        // find objects within their viewing range
        object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fLength, lLocation, TRUE);

        // loop through the matching creature objects and check if the pc identifies any he sees
        while(GetIsObjectValid(oTarget))
        {
            if (GetObjectSeen(oTarget)) { ACR_CreatureIdentify(OBJECT_SELF, oTarget); }
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fLength, lLocation, TRUE);
        }
    }
    else
    {
        // apply any effects on the creature
        ACR_VFXOnHeartBeat(OBJECT_SELF);
    */
	if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
        // still call the Obsidian script for AI for now.
        ExecuteScript("nw_c2_default1", OBJECT_SELF);
	}
    //}
}

void ACR_CreatureOnRested()
{
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_defaulta", OBJECT_SELF);
	}
}

void ACR_CreatureOnPerception()
{
    object oPerceived = GetLastPerceived();

    // apply any effects on the creature
    //ACR_VFXOnPerception(oPerceived, OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {    
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_default2", OBJECT_SELF);
	}
}

void ACR_CreatureOnUserDefined()
{
    if (GetLocalInt(OBJECT_SELF, _CRE_NO_AI) == FALSE) {
    	// still call the Obsidian script for AI for now.
    	ExecuteScript("nw_c2_defaultd", OBJECT_SELF);
	}
}

void ACR_CreatureIdentify(object oPC, object oTarget)
{
	// first, determine which Knowledge skill applies.
	int i,p,end,start,nKnowSkill = GetKnowlegeSkillOfRace(GetRacialType(oTarget));
	string sName,sTmp;


	// Prevent re-rolls
	if (GetLocalInt(oTarget, "IDEN_" + ObjectToString(oPC))) {
		SendMessageToPC(oPC, "You cannot make out anything further.");
		return;
	}

	SetLocalInt(oTarget, "IDEN_" + ObjectToString(oPC), 1);


	if (nKnowSkill == -1) {
		WriteTimestampedLogEntry("Unaccounted RacialType Error identifying "+GetName(oTarget)+" with ResRef: "+GetResRef(oTarget)+" by PC: "+GetName(oPC)+" in area: "+GetName(GetArea(oTarget))); 
		nKnowSkill = SKILL_LORE;
	}
	// do a knowledge check - exit on failure
	if (!ACR_SkillCheck(nKnowSkill, oPC, 10 + GetHitDice(oTarget), TRUE)) {
		// alert the player - should we also save the attempt (db) to prevent retries?
		SendMessageToPC(oPC, "You fail to notice anything remarkable about this creature.");
		return;
	}
	
	sName = SubRaceName(GetSubRace(oTarget));

#if 0
	AddScriptParameterObject(oTarget);
	AddScriptParameterString("FirstName");
	ExecuteScriptEnhanced("ACR_ReadRawString", OBJECT_SELF);
	sName = GetLocalString(oTarget, "RawText");

	end = GetStringLength(sName);

	// Handle hidden text
	if ((p = FindSubString(sName, "[")) != -1) {
		start = p+1;

		if ((p = FindSubString(sName, "]")) != -1)
			end = p-1;

		sTmp = GetStringUpperCase(GetSubString(sName, start, end-start));

		// Clean name-candidate
		sName = GetSubString(sName, start, end-start);

		// Proper cr declaration
		if (TestStringAgainstPattern("**CR(*w|*n)**",sTmp)) {
		
			// imprecise, best 'guess' for cr formats
			if      ((p = FindSubString(sTmp, ", CR")) != -1) {}
			else if ((p = FindSubString(sTmp, "- CR")) != -1) {}
			else if ((p = FindSubString(sTmp, ": CR")) != -1) {}
			else if  ((p = FindSubString(sTmp, ":CR")) != -1) {}
			else if  ((p = FindSubString(sTmp, "-CR")) != -1) {}
			else if  ((p = FindSubString(sTmp, ",CR")) != -1) {}
			else if  ((p = FindSubString(sTmp, " CR")) != -1) {}
			// Panic, this is ONLY a cr no name
			else {
				sName = GetName(oTarget);
				p = GetStringLength(sName);
			}
			end = p;
		}
		
		// compose the name to report to the player
		sName = GetSubString(sName, 0, end);   
		SetFirstName(oTarget, sName);
		SetLastName(oTarget, "");
	}
#endif

	// report the filtered creature name
	SendMessageToPC(oPC, "You recognize it as "+GetArticle(sName)+" <color=Magenta><i>"+sName+"</i></color>!");
}

int ACR_GetIsUndead( object oTarget ) {
	if ( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD ) return TRUE;
	if ( GetLevelByClass( CLASS_TYPE_UNDEAD, oTarget ) > 0 ) return TRUE;
	if ( GetLocalInt( oTarget, ACR_CRE_ISUNDEAD ) == TRUE ) return TRUE;
	return FALSE;
}
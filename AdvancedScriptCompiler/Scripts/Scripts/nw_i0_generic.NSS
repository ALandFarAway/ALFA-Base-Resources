// nw_i0_generic
/*
//::///////////////////////////////////////////////
//:: Generic Scripting Include v1.0
//:: NW_I0_GENERIC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

  December 7 2002, Naomi Novik
  Many functions removed to separate libraries:

        x0_i0_behavior
            behavior constants
            SetBehaviorState
            GetBehaviorState
		
        x0_i0_anims
            PlayMobileAmbientAnimations_NonAvian
            PlayMobileAmbientAnimations_Avian
                (with PlayMobileAmbientAnimations changed to
                just a call to one of these two)
            PlayImmobileAmbientAnimations
		|
        x0_i0_walkway
            WalkWayPoints
            RunNextCircuit
            RunCircuit
            CheckWayPoints
            GetIsPostOrWalking
		|
        x0_i0_spawncond
            OnSpawn condition constants
            SetSpawnInCondition
            GetSpawnInCondition
            SetSpawnInLocals
            SetListeningPatterns
		|
		x0_i0_combat
			Combat Conditions and Special abilities			
		|
        x0_i0_talent
           ALL the talent functions
		|
        nwn2_inc_talent
			Warlock and other new talents - mostly an addendum to x0_i0_talent
		|		   
        x0_inc_generic
            Pretty much everything else
		|
        x0_i0_equip
            Equipping functions
		|			
        x0_i0_enemy
			Finding/Identifying Enemies	
		|
        x0_i0_match
            Matching functions
						
        x0_i0_assoc
            associate constants (NW_ASC_...)
            GetPercentageHPLoss (only used in GetAssociateHealMaster)
            SetAssociateState
            GetAssociateState
            ResetHenchmenState
            AssociateCheck
            GetAssociateHealMaster
            GetFollowDistance
            SetAssociateStartLocation
            GetAssociateStartLocation

        x0_i0_debug
            MyPrintString
            DebugPrintTalentId
            newdebug
			

    ***********************************************'
    CHANGE SUMMARY


    February 6 2003: Commented out the Henchman RespondToShout because now using
                     the newer bkRespondToShout function in x0_i0_henchman


    September 18 2002: DetermineCombatRound broken into smaller functions
              19     : Removed randomness from Talent system. You can't
                       have smart AI and random behavior. Only healing
                       has the possiblity of being random.

                       I may want to add the possibility of getting a
                       random talent only in the Talent filter if
                       something fails (*)


    ********************************************
    WARNING THIS SCRIPT IS CHANGED AT YOUR PERIL
    ********************************************

    This is the master generic script and currently
    handles all combat and some plot behavior
    within NWN. If this script is tampered
    with there is a chance of introducing game
    breaking bugs.  But other than that enjoy.
*/
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//	6/22/05 ChazM - changed commoners to always attempt to flee in chooseTactics()
//	7/29/05	EPF (OEI) - Short circuited combat if creature is attacking a party member who's in a conversation
//	3/10/06 BMA-OEI - modified GetIsInCutscene() to check only the PC party
//	6/6/06 EPF - Incorporated new Warlock spellcasting AI, made additions for Warlock invisibility AI.
//	6/6/06 ChazM - Incorporated prestige classes
//	6/20/06 ChazM - Fixed Barbarian Rage.
//	6/21/06 ChazM - Fixed Frenzy of Frenzied Berserker.  Fix to DetermineClassToUse()
//	9/07/06 DBR - To prevent knockdown overuse we moved it to a talent in chooseTactics()
//	9/12/06 DBR - Removed MoveToPoint as a case where combat rounds are turned off. __IsInCombatRound()
//	9/13/06 DBR - Moved random chance of knockdown from TalentKnockdown() in x0_i0_talent to chooseTactics().
//	9/19/06 ChazM - Removed excess commented code.
//	9/22/06 DBR - Prevented BashDoorCheck() from letting a creature run standard tactics if oIntruder was a door.
//				- Also invalidated target if the creature was trying to attack a trigger or non-usable object (since they can't)
//  ChazM 1/16/07 - moved nwn2_inc_talent into the AI include chain below x0_i0_talent
//	ChazM 1/17/07 - moved InvisibleTrue() to x0_inc_generic
//	ChazM 1/18/07 - Added EvenFlw functions, re-org of chooseTactics()
//	ChazM 1/29/07 - modified CheckNonOffensiveMagic()
//	ChazM 2/16/07 - removed call to ResetModes() from chooseTactics(); commented out PrintMode(), ClearAIVariables, ResetModes() and EVENFLW_AI_MODE
//	ChazM 4/27/07 - removed a few hundred lines of commented code, structural enhancements.
// ChazM 5/31/07 -  added AssignDCR()
// MDiekmann 6/27/07 - Modified DetermineActionFromTactics, to not make animal companions go into defensive casting mode.
// MDiekmann 7/3/07 - Modified DetermineActionFromTactics, to not make anyone go into defensive casting mode who isn't capable.
// MDiekmann 7/17/07 - Fixes for determing whether or not companions go into defensive casting mode

//#include "x0_i0_assoc" - included in x0_inc_generic
//#include "x0_inc_generic" - included in x0_i0_talent
//#include "x0_i0_talent" - included in x0_i0_combat

//#include "x0_i0_combat"    - include in x0_i0_anims

//#include "x0_i0_walkway"   - include in x0_i0_anims
#include "x0_i0_behavior"
#include "x0_i0_anims"
//#include "nwn2_inc_talent" - include in x0_i0_talent

//==============================================================
// CONSTANTS
//==============================================================
const string VAR_NW_GENERIC_LAST_ATTACK_TARGET 	= "NW_GENERIC_LAST_ATTACK_TARGET";
const string VAR_X2_NW_I0_GENERIC_INTRUDER		= "X2_NW_I0_GENERIC_INTRUDER";
const string VAR_X2_SPECIAL_COMBAT_AI_SCRIPT 	= "X2_SPECIAL_COMBAT_AI_SCRIPT";
const string VAR_X2_SPECIAL_COMBAT_AI_SCRIPT_OK	= "X2_SPECIAL_COMBAT_AI_SCRIPT_OK";
const string VAR_X2_L_MUTEXCOMBATROUND 			= "X2_L_MUTEXCOMBATROUND";


//const string EVENFLW_AI_MODE 			= "EVENFLW_AI_MODE";
//const string EVENFLW_AI_LAST_STATE 		= "EVENFLW_AI_LAST_STATE";
const string EVENFLW_NOT_SILENCE_SCARED = "EVENFLW_NOT_SILENCE_SCARED";
const string EVENFLW_SILENCE 			= "EVENFLW_SILENCE";

//==============================================================
// Flee and move constants
//==============================================================

const int NW_GENERIC_FLEE_EXIT_FLEE = 0;
const int NW_GENERIC_FLEE_EXIT_RETURN = 1;
const int NW_GENERIC_FLEE_TELEPORT_FLEE = 2;
const int NW_GENERIC_FLEE_TELEPORT_RETURN = 3;

//==============================================================
// Shout constants
//==============================================================

// NOT USED
const int NW_GENERIC_SHOUT_I_WAS_ATTACKED = 1;

//IN OnDeath Script
const int NW_GENERIC_SHOUT_I_AM_DEAD = 12;

//IN TalentMeleeAttacked
const int NW_GENERIC_SHOUT_BACK_UP_NEEDED = 13;

const int NW_GENERIC_SHOUT_BLOCKER = 2;

//==============================================================
// chooseTactics constants
//==============================================================

const int      chooseTactics_MEMORY_OFFENSE_MELEE    = 0;
const int      chooseTactics_MEMORY_DEFENSE_OTHERS   = 1;
const int      chooseTactics_MEMORY_DEFENSE_SELF     = 2;
const int      chooseTactics_MEMORY_OFFENSE_SPELL    = 3;


// MISCELLANEOUS CONSTANTS

// This is the determine combat round script.
// Used to decouple DCR from other scripts so that it can be updated independently.
const string SCRIPT_DCR	= "gr_dcr";

//==============================================================
// STRUCTURES
//==============================================================

// instance Prefix for rTactics is tac
// ex:
// struct rTactics tacAI
struct rTactics
{
	// amount of each to use in decison making
    int nOffense;
    int nCompassion;
    int nMagic;
    int nMagicOld;
	int nStealth;
	
	int bScaredOfSilence;	
	int bTacticChosen;
};

//==============================================================
// FUNCTION PROTOTYPES
//==============================================================

// * New Functions September - 2002


// * The class-specific tactics have been broken out from DetermineCombatRound
// * for readability. This function determines the actual tactics each class
// * will use.
int chooseTactics(object oIntruder);

// Adds all three of the class levels together.  Used before
// GetHitDice became available
int GetCharacterLevel(object oTarget);

//If using ambient sleep this will remove the effect
void RemoveAmbientSleep();

//Searches for the nearest locked object to the master
object GetLockedObject(object oMaster);

//==============================================================
// DetermineCombatRound subfunctions
//==============================================================

//     Used in DetermineCombatRound to keep a
//     henchmen bashing doors.
int BashDoorCheck(object oIntruder = OBJECT_INVALID);

//     Determines which of a NPCs three classes to
//     use in DetermineCombatRound
int DetermineClassToUse();


//==============================================================
// Core AI Functions
//==============================================================

//    This function is the master function for the
//    generic include and is called from the main
//    script.  This function is used in lieu of
//    any actual scripting.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
void DetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10);

//::///////////////////////////////////////////////
//:: Respond To Shouts
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//     Allows the listener to react in a manner
//     consistant with the given shout but only to one
//     combat shout per round
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//NOTE ABOUT COMMONERS
//     Commoners are universal cowards.  If you attack anyone
//     they will flee for 4 seconds away from the attacker.
//     However to make the commoners into a mob, make a single
//     commoner at least 10th level of the same faction.
//     If that higher level commoner is attacked or killed then
//     the commoners will attack the attacker.  They will disperse again
//     after some of them are killed.  Should NOT make multi-class
//     creatures using commoners.
//
//NOTE ABOUT BLOCKERS
//     It should be noted that the Generic Script for On Dialogue
//     attempts to get a local set on the shouter by itself.
//     This object represents the LastOpenedBy object.  It is this
//     object that becomes the oIntruder within this function.
//
//NOTE ABOUT INTRUDERS
//     The intruder object is for cases where a placable needs to
//     pass a LastOpenedBy Object or a AttackMyAttacker
//     needs to make his attacker the enemy of everyone.
void RespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID);


//******** PLOT FUNCTIONS

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
void SetNPCWarningStatus(int nStatus = TRUE);

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
int GetNPCWarningStatus();

// * Presently Does not work with the current implementation
// * of encounter triggers!
//
//     This function works in tandem with an encounter
//     to spawn in guards to fight for the attacked
//     NPC.  MAKE SURE THE ENCOUNTER TAG IS SET TO:
//
//              "ENC_" + NPC TAG
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
void SetSummonHelpIfAttacked();

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
// This function is used only because ActionDoCommand can
// only accept void functions.
void CreateSignPostNPC(string sTag, location lLocal);

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
void ActivateFleeToExit();

//     The target object flees to the specified
//     way point and then destroys itself, to be
//     respawned at a later point.  For unkillable
//     sign post characters who are not meant to fight
//     back.
int GetFleeToExit();

//     Checks that an item was unlocked.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 19, 2001
void CheckIsUnlocked(object oLastObject);

// This function is now just a wrapper around the functions
// PlayMobileAmbientAnimations_Nonavian() and
// PlayMobileAmbientAnimations_Avian(), in x0_i0_anims
void PlayMobileAmbientAnimations();

//     Determines the special behavior used by the NPC.
//     Generally all NPCs who you want to behave differently
//     than the defualt behavior.
//     For these behaviors, passing in a valid object will
//     cause the creature to become hostile the the attacker.
void DetermineSpecialBehavior(object oIntruder = OBJECT_INVALID);

// * Am I in a invisible or stealth state or sanctuary?
//int InvisibleTrue(object oSelf = OBJECT_SELF);

//:://///////////////////////////////////////////////////////////////////////////////
//:: GetIsInCutscene()
//:: Determines whether the target is a member of the PC's faction and if any member
//:: is involved in a conversation -- this is a condition for short circuiting 
//:: DetermineCombatRound() so that hostile creatures can't attack conversing PCs or
//:: their party.
//::
//:: EPF, OEI 7/29/05
//:: DBR, OEI 5/30/06 - changed check to MP flagged cutscenes.
//:://///////////////////////////////////////////////////////////////////////////////
int GetIsInCutscene(object oTarget);

//ChooseTacticsForDoor(oDoorIntruder)
//	This function is for choosing what tactics to use when fighting a door.
//	oDoorIntruder is the door to fight, and the function is run on the combating creature.
//	Returns 1 on a succesful choice of tactic (which should always occur) and 0 when no tactics were chosen.
//  Originally from BashDoorCheck(), taken out.
int ChooseTacticsForDoor(object oDoorIntruder = OBJECT_INVALID);


//void PrintMode(object party, int mode, object boss);
//void ClearAIVariables(int all=FALSE);
//void ResetModes();
int CheckForInvis(object oIntruder);
int CheckNonOffensiveMagic(object oIntruder, int nOffense, int nCompassion, int nMagic, int iCastingMode);
int GetScaledCastingMagic(int iCastingMode, int nMagic, int def, int random=FALSE);
void InitializeSeed(int iCastingMode, object oIntruder);

// New Functions used by chooseTactics()
int GetHPPercentage(object oTarget=OBJECT_SELF);
int GetCastingMode(int iMyHPPercentage);
struct rTactics CreateTactics(int nOffense=0, int nCompassion=0, int nMagic=0, int nMagicOld=0, int nStealth=0, int bScaredOfSilence=0, int bTacticChosen=0);
int TryClassTactic(object oIntruder, int nClass, int bNoFeats);
struct rTactics CalculateTacticsByClass (struct rTactics tacAI, object oIntruder, int nClass, int iCastingMode);
struct rTactics CalculateTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced);
int DetermineActionFromTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced, int bNoFeats);


//==============================================================
// FUNCTION DEFINITIONS
//==============================================================

// Put on queue of creature to do a DCR.
// Using this allows the DCR call to be decoupled from the script, allowing it to take
// advantage of DCR enhancements without needing to be recompiled.
void AssignDCR(object oCreature)
{
	AssignCommand(oCreature, ExecuteScript(SCRIPT_DCR, oCreature));
}

//::///////////////////////////////////////////////
//:: AdjustBehaviorVariable
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

// Overriding "behavior" variables.
// If a variable has been stored on the creature it overrides the above
// class defaults

int AdjustBehaviorVariable(int nVar, string sVarName)
{
    int nPlace =GetLocalInt(OBJECT_SELF, sVarName);
    if (nPlace > 0)
    {
        return nPlace;
    }
    //return nVar; // * return the original value
    return 0;
}

//    A more intelligent invisibility solution,
//    along the lines of the one used in
//    the various end-user AIs.
//:: Created By:  Brent
//:: Created On:  June 14, 2003
// EPF 6/5/06 -- Added Warlock options for invisibility.

int InvisibleBecome(object oSelf = OBJECT_SELF, int isInvis=FALSE)
{
	if(GetLocalInt(oSelf, "X2_L_STOPCASTING") == 10) {
		if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf))
        	SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
		return FALSE;
	}
	
	int hasDarkness		=  GetHasSpellEffect(SPELL_DARKNESS, oSelf) 
						|| GetHasSpellEffect(SPELL_I_DARKNESS, oSelf) 
						|| GetHasSpellEffect(SPELL_SHADOW_CONJURATION_DARKNESS, oSelf);
						
	int iWarlockDarkness = GetHasSpell(SPELL_I_DARKNESS, oSelf) && !hasDarkness;
    int iDarkness 		= GetHasSpell(SPELL_DARKNESS, oSelf) && !hasDarkness;
	
	if (GetHasSpell(SPELL_GREATER_INVISIBILITY, oSelf) 
		|| GetHasSpell(SPELL_INVISIBILITY, oSelf) 
		|| GetHasSpell(724, oSelf) 
		|| GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf) 
		|| iDarkness 
		|| iWarlockDarkness 
		|| GetHasSpell(SPELL_SANCTUARY, oSelf) 
		|| GetHasSpell(SPELL_ETHEREALNESS, oSelf) 
		|| GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf) == TRUE 
		|| GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf) 
		|| GetHasSpell(SPELL_I_WALK_UNSEEN, oSelf))
    {
        if(isInvis<=0) // close or not invisible
        {
            object oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_TRUE_SEEING);
            if(!GetIsObjectValid(oSeeMe))
            {
			    int nDiff = GetCombatDifficulty(oSelf, TRUE);
                if (nDiff > -1)
                {
					if (GetHasSpell(SPELL_ETHEREALNESS, oSelf)) {
                        ClearActions(1001);
						ActionCastSpellAtObject(SPELL_ETHEREALNESS, oSelf);
                        return TRUE;
					} else if(GetHasSpell(724, oSelf)) { // ethereal jaunt
                        ClearActions(1001);
						ActionCastSpellAtObject(724, oSelf);
                        return TRUE;
					}
					
					if(!isInvis) 
					{ // don't do if close
	                	oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_SEE_INVISIBILITY);
						if(!GetIsObjectValid(oSeeMe)) 
						{
							ClearActions(1001);
							if(GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf)) {
								ActionCastSpellAtObject(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf, METAMAGIC_NONE, TRUE);
								return TRUE;
							} else if(GetHasSpell(SPELL_GREATER_INVISIBILITY, oSelf)) {
								ActionCastSpellAtObject(SPELL_GREATER_INVISIBILITY, oSelf);
								return TRUE;
							} else if(GetHasSpell(SPELL_I_WALK_UNSEEN, oSelf)) {
								ActionCastSpellAtObject(SPELL_I_WALK_UNSEEN, oSelf, METAMAGIC_NONE, TRUE);
								return TRUE;
							} else if (GetHasSpell(SPELL_INVISIBILITY, oSelf)) {
								ActionCastSpellAtObject(SPELL_INVISIBILITY, oSelf);
								return TRUE;
							} else if (GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf)) {
								ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, oSelf);
								return TRUE;
							}
						}
					}
					
					if (iWarlockDarkness) {
						ClearActions(1001);
						ActionCastSpellAtObject(SPELL_I_DARKNESS, oSelf, METAMAGIC_NONE, TRUE);
                        return TRUE;
					} else if (iDarkness==TRUE) {
						ClearActions(1001);
                        ActionCastSpellAtObject(SPELL_DARKNESS, oSelf);
                        return TRUE;
                    } else if (GetHasSpell(SPELL_SANCTUARY, oSelf)) {
						ClearActions(1001);
                        ActionCastSpellAtObject(SPELL_SANCTUARY, oSelf);
                        return TRUE;
                    } else if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf)) {
                        SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
                    }
                }
            }
        }
    }
 	return FALSE;
}


// * Returns true if a wizard, warlock, or sorcerer and wearing armor
int GetShouldNotCastSpellsBecauseofArmor(object oTarget, int nClass)
{

    if (GetArcaneSpellFailure(oTarget) > 15 &&
	    (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_WARLOCK || nClass == CLASS_TYPE_BARD))
    {
        return TRUE;
    }
    return FALSE;
}



//    Tests to see if already running a determine
//    combatround this round.
//:: Created By:   Brent
//:: Created On:   July 11 2003
int __InCombatRound()
{

    // * if just in attackaction, turn combat round off
    // * if simply fighting it is okay to turn the combat round off
    // * and try again because it doesn't hurt an attackaction
    // * to be reiniated whereas it does break a spell
    int nCurrentAction =  GetCurrentAction(OBJECT_SELF);
    if (nCurrentAction == ACTION_ATTACKOBJECT || nCurrentAction == ACTION_INVALID)// || nCurrentAction == ACTION_MOVETOPOINT)
    {
        return FALSE;
    }
    if (GetLocalInt(OBJECT_SELF, VAR_X2_L_MUTEXCOMBATROUND) == TRUE)
    {
        //SpeakString("DEBUG:: In Combat Round, busy.");
        return TRUE;
    }
    return FALSE;
}

//    Will set the exclusion variable on whether
//    in combat or not.
//    This is to prevent multiple firings
//    of determinecombatround in one round
//:: Created By: Brent
//:: Created On: July 11 2003
void __TurnCombatRoundOn(int bBool)
{
    if (bBool == TRUE)
    {
        SetLocalInt(OBJECT_SELF, VAR_X2_L_MUTEXCOMBATROUND, TRUE);
    }
    else
    {
        // * delay it turning off like an action
        ActionDoCommand(SetLocalInt(OBJECT_SELF, VAR_X2_L_MUTEXCOMBATROUND, FALSE));
    }
}

//:://///////////////////////////////////////////////////////////////////////////////
//:: GetIsInCutscene()
//:: Determines whether the target is a member of the PC's faction and if any member
//:: is involved in a conversation -- this is a condition for short circuiting 
//:: DetermineCombatRound() so that hostile creatures can't attack conversing PCs or
//:: their party.
//::
//:: EPF, OEI 7/29/05
//:: DBR, OEI 5/30/06 - changed check to MP flagged cutscenes.
//:://///////////////////////////////////////////////////////////////////////////////
int GetIsInCutscene(object oTarget)
{
	// BMA-OEI 3/10/06
	object oPC = GetFirstPC();
		
	// If oTarget is not in the PC faction
	if (GetFactionEqual(oTarget, oPC) == FALSE)
	{
		return (FALSE);
	}

	// For each member in PC faction
	object oMem = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMem) == TRUE)
	{
		// If any member is in conversation
		if (IsInMultiplayerConversation(oMem) == TRUE)
		{
			return (TRUE);
		}
		
		oMem = GetNextFactionMember(oPC, FALSE);
	}

	return (FALSE);
}

//    This function is the master function for the
//    generic include and is called from the main
//    script.  This function is used in lieu of
//    any actual scripting.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
void DetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10)
{
	//MyPrintString("************** DETERMINE COMBAT ROUND START *************");
    //MyPrintString("**************  " + GetTag(OBJECT_SELF) + "  ************");

    // Abort out of here, if petrified
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF) == TRUE)
    {
        return;
    }

    // Fix for ActionRandomWalk blocking the action queue under certain circumstances
    if (GetCurrentAction() == ACTION_RANDOMWALK)
    {
        ClearAllActions();
    }

    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(OBJECT_SELF, VAR_X2_SPECIAL_COMBAT_AI_SCRIPT);
    if (sSpecialAI != "")
    {
        SetLocalObject(OBJECT_SELF, VAR_X2_NW_I0_GENERIC_INTRUDER, oIntruder);
        ExecuteScript(sSpecialAI, OBJECT_SELF);
        if (GetLocalInt(OBJECT_SELF, VAR_X2_SPECIAL_COMBAT_AI_SCRIPT_OK))
        {
            DeleteLocalInt(OBJECT_SELF, VAR_X2_SPECIAL_COMBAT_AI_SCRIPT_OK);
            return;
        }
    }


    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: EVALUATIONS
    // ----------------------------------------------------------------------------------------
    if(GetAssociateState(NW_ASC_IS_BUSY))
    {
        return;
    }

    if(BashDoorCheck(oIntruder)) {return;}

	if (GetObjectType(oIntruder)==OBJECT_TYPE_TRIGGER) //Don't try to attack trigger. You will be unable to.
		oIntruder = OBJECT_INVALID;
	if ((GetObjectType(oIntruder)==OBJECT_TYPE_PLACEABLE) && (!GetUseableFlag(oIntruder))) //Don't try to attack non-usable placeables. You will be unable to.
		oIntruder = OBJECT_INVALID;
	
    // ----------------------------------------------------------------------------------------
    // BK: stop fighting if something bizarre that shouldn't happen, happens
    // ----------------------------------------------------------------------------------------
    if (bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE)
        return;

    // ** Store How Difficult the combat is for this round
    int nDiff = GetCombatDifficulty();
    SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);

    // MyPrintString("COMBAT: " + IntToString(nDiff));

    // ----------------------------------------------------------------------------------------
    // If no special target has been passed into the function
    // then choose an appropriate target
    // ----------------------------------------------------------------------------------------
	if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = bkAcquireTarget();

	// ----------------------------------------------------------------------------------------
	// 7/29/05 -- EPF, OEI
	// Due to the many, many plot-related cutscenes, we have decided to prevent anyone in the 
	// PC faction from being attacked while they are in conversation.  Eventually, this should
	// probably include a check to see if the conversation itself is a plot cutscene, but for
	// now that flag is NYI.  Effectively, this is just a "pause" on combat until the
	// conversation ends.  Then the PC party is fair game.
	// 5/30/06 -- DBR, OEI
	// Flag is IN! GetIsInCutscene() now only checks for multiplayer flagged cutscenes.
	// ----------------------------------------------------------------------------------------
	if(GetIsInCutscene(oIntruder))
	{
		PrintString("DetermineCombatRound(): In cutscene.  Aborting function.");
		ClearAllActions(TRUE);
		ActionWait(3.f);
		ActionDoCommand(DetermineCombatRound());
		return;
	}
	
    // If for some reason my target is dead, then leave
    // the poor guy alone. Jeez. What kind of monster am I?
    if (GetIsDead(oIntruder) == TRUE)
    {
        return;
    }

    // ----------------------------------------------------------------------------------------
    //   JULY 11 2003
    //   If in combat round already (variable set) do not enter it again.
    //   This is meant to prevent multiple calls to DetermineCombatRound
    //   from happening during the *same* round.
	//
    //   This variable is turned on at the start of this function call.
    //   It is turned off at each "return" point for this function
    // ----------------------------------------------------------------------------------------
    if (__InCombatRound() == TRUE)
    {
        return;
    }

    __TurnCombatRoundOn(TRUE);

    // ----------------------------------------------------------------------------------------
    // DetermineCombatRound: ACTIONS
    // ----------------------------------------------------------------------------------------
    if(GetIsObjectValid(oIntruder))
    {

        if(TalentPersistentAbilities()) // * Will put up things like Auras quickly
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // If a succesful tactic has been chosen then exit this function directly
        if (chooseTactics(oIntruder) == 99)
        {
            __TurnCombatRoundOn(FALSE);
            return;
        }

        // This check is to make sure that people do not drop out of
        // combat before they are supposed to.
        object oNearEnemy = GetNearestSeenEnemy();
        DetermineCombatRound(oNearEnemy);

        return;
    }
     __TurnCombatRoundOn(FALSE);

    // ----------------------------------------------------------------------------------------
    // This is a call to the function which determines which
    // way point to go back to.
    // ----------------------------------------------------------------------------------------
    ClearActions(CLEAR_NW_I0_GENERIC_658);
    SetLocalObject(OBJECT_SELF, VAR_NW_GENERIC_LAST_ATTACK_TARGET, OBJECT_INVALID);
    WalkWayPoints();
}

//    Allows the listener to react in a manner
//    consistant with the given shout but only to one
//    combat shout per round
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001

//NOTE ABOUT COMMONERS
//    Commoners are universal cowards.  If you attack anyone they will flee for 4 seconds away from the attacker.
//    However to make the commoners into a mob, make a single commoner at least 10th level of the same faction.
//    If that higher level commoner is attacked or killed then the commoners will attack the attacker.  They will disperse again
//    after some of them are killed.  Should NOT make multi-class creatures using commoners.
//
//NOTE ABOUT BLOCKERS
//    It should be noted that the Generic Script for On Dialogue attempts to get a local set on the shouter by itself.
//    This object represents the LastOpenedBy object.  It is this object that becomes the oIntruder within this function.

//NOTE ABOUT INTRUDERS
//
//    The intruder object is for cases where a placable needs to pass a LastOpenedBy Object or a AttackMyAttacker
//    needs to make his attacker the enemy of everyone.

void RespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID)
{

    // Pausanias: Do not respond to shouts if you've surrendered.
    int iSurrendered = GetLocalInt(OBJECT_SELF,"Generic_Surrender");
    if (iSurrendered) return;

    switch (nShoutIndex)
    {
        case 1://NW_GENERIC_SHOUT_I_WAS_ATTACKED:
            {
                object oTarget = oIntruder;
                if(!GetIsObjectValid(oTarget))
                {
                    oTarget = GetLastHostileActor(oShouter);
                }
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
					// if I am not a commoner, and not trying to attack something, and the shouter is a friend and the intruder is not a friend
					// then wake up and attack focus on the last person to be hostile to the shouter. 
                    if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                    {
                        if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                        {
                            if(GetIsObjectValid(oTarget))
                            {
                                if(!GetIsFriend(oTarget) && GetIsFriend(oShouter))
                                {
                                    RemoveAmbientSleep();
                                    //DetermineCombatRound(oTarget);
                                    DetermineCombatRound(GetLastHostileActor(oShouter));
                                }
                            }
                        }
                    }
					// If I'm a commoner, and the shouter is a high level commoner, attack like mob!
                    else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    else // I'm a commoner - Determine combat round should result in me fleeing.
                    {
                        DetermineCombatRound(oIntruder);
                    }
                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;

        case 2://NW_GENERIC_SHOUT_MOB_ATTACK:
            {
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {

                    //Is friendly check to make sure that only like minded commoners attack.
                    if(GetIsFriend(oShouter))
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    //if(TalentMeleeAttack()) {return;}
                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;

        case 3://NW_GENERIC_SHOUT_I_AM_DEAD:
            {
                if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
                {
                    //Use I was attacked script above
                    if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                    {
                        if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                        {
                            if(GetIsObjectValid(GetLastHostileActor(oShouter)))
                            {
                                if(!GetIsFriend(GetLastHostileActor(oShouter)) && GetIsFriend(oShouter))
                                {
                                    DetermineCombatRound(GetLastHostileActor(oShouter));
                                }
                            }
                        }
                    }
                    else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                    {
                        WrapperActionAttack(GetLastHostileActor(oShouter));
                    }
                    else
                    {
                        DetermineCombatRound();
                    }

                }
                else
                {
                    DetermineSpecialBehavior();
                }
            }
        break;
        //For this shout to work the object must shout the following
        //string sHelp = "NW_BLOCKER_BLK_" + GetTag(OBJECT_SELF);
        case 4: //BLOCKER OBJECT HAS BEEN DISTURBED
            {
                if(!GetLevelByClass(CLASS_TYPE_COMMONER))
                {
                    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                    {
                        if(GetIsObjectValid(oIntruder))
                        {
                            SetIsTemporaryEnemy(oIntruder);
                            DetermineCombatRound(oIntruder);
                        }
                    }
                }
                else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                {
                    WrapperActionAttack(oIntruder);
                }
                else
                {
                    DetermineCombatRound();
                }
            }
        break;

        case 5: //ATTACK MY TARGET
            {
                AdjustReputation(oIntruder, OBJECT_SELF, -100);
                if(GetIsFriend(oShouter))
                {
                    SetIsTemporaryEnemy(oIntruder);
                    ClearActions(CLEAR_NW_I0_GENERIC_834);
                    DetermineCombatRound(oIntruder);
                }
            }
        break;

        case 6: //CALL_TO_ARMS
            {
                //This was once commented out.
                DetermineCombatRound();
            }
        break;
    }
}

//:: Set and Get NPC Warning Status
//    This function sets a local int on OBJECT_SELF
//    which will be checked in the On Attack, On
//    Damaged and On Disturbed scripts to check if
//    the offending party was a PC and was friendly.
//    The Get will return the status of the local.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
void SetNPCWarningStatus(int nStatus = TRUE)
{
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_WARNING_STATUS", nStatus);
}

// NPCs who have warning status set to TRUE will allow
// one 'free' attack by PCs from a non-hostile faction.
int GetNPCWarningStatus()
{
    return GetLocalInt(OBJECT_SELF, "NW_GENERIC_WARNING_STATUS");
}

//    This function works in tandem with an encounter
//    to spawn in guards to fight for the attacked
//    NPC.  MAKE SURE THE ENCOUNTER TAG IS SET TO:
//             "ENC_" + NPC TAG
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001

//Presently Does not work with the current implementation of encounter trigger
void SetSummonHelpIfAttacked()
{
    string sEncounter = "ENC_" + GetTag(OBJECT_SELF);
    object oTrigger = GetObjectByTag(sEncounter);

    if(GetIsObjectValid(oTrigger))
    {
        SetEncounterActive(TRUE, oTrigger);
    }
}

//==============================================================
// ESCAPE FUNCTIONS
//==============================================================

//:: Set, Get Activate,Flee to Exit
//    The target object flees to the specified
//    way point and then destroys itself, to be
//    respawned at a later point.  For unkillable
//    sign post characters who are not meant to fight back.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001

//This function is used only because ActionDoCommand can only accept void functions
void CreateSignPostNPC(string sTag, location lLocal)
{
    CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocal);
}

void ActivateFleeToExit()
{
     //minor optimizations - only grab these variables when actually needed
     //can make for larger code, but it's faster
     //object oExitWay = GetWaypointByTag("EXIT_" + GetTag(OBJECT_SELF));
     //location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
     //string sTag = GetTag(OBJECT_SELF);

     //I suppose having this as a variable made it easier to change at one point....
     //but it never changes, and is only used twice, so we don't need it
     //float fDelay =  6.0;

     int nPlot = GetLocalInt(OBJECT_SELF, "NW_GENERIC_MASTER");

     if(nPlot & NW_FLAG_TELEPORT_RETURN || nPlot & NW_FLAG_TELEPORT_LEAVE)
     {
        //effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        if(nPlot & NW_FLAG_TELEPORT_RETURN)
        {
            location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
            string sTag = GetTag(OBJECT_SELF);
            DelayCommand(6.0, ActionDoCommand(CreateSignPostNPC(sTag, lLocal)));
        }
        ActionDoCommand(DestroyObject(OBJECT_SELF, 0.75));
     }
     else
     {
        if(nPlot & NW_FLAG_ESCAPE_LEAVE)
        {
            object oExitWay = GetWaypointByTag("EXIT_" + GetTag(OBJECT_SELF));
            ActionMoveToObject(oExitWay, TRUE);
            ActionDoCommand(DestroyObject(OBJECT_SELF, 1.0));
        }
        else if(nPlot & NW_FLAG_ESCAPE_RETURN)
        {
            string sTag = GetTag(OBJECT_SELF);
            object oExitWay = GetWaypointByTag("EXIT_" + sTag);
            ActionMoveToObject(oExitWay, TRUE);
            location lLocal = GetLocalLocation(OBJECT_SELF, "NW_GENERIC_START_POINT");
            DelayCommand(6.0, ActionDoCommand(CreateSignPostNPC(sTag, lLocal)));
            ActionDoCommand(DestroyObject(OBJECT_SELF, 1.0));
        }
     }
}

int GetFleeToExit()
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_GENERIC_MASTER");
    if(nPlot & NW_FLAG_ESCAPE_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_ESCAPE_LEAVE)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_TELEPORT_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & NW_FLAG_TELEPORT_LEAVE)
    {
       return TRUE;
    }
    return FALSE;
}



//==============================================================
// PRIVATE FUNCTIONS
//==============================================================

//This is experimental and has not been looked at closely.
void ExitAOESpellArea(object oAOEObject)
{
    ClearActions(CLEAR_NW_I0_GENERIC_ExitAOESpellArea);
    ActionMoveAwayFromObject(oAOEObject, TRUE, 5.0);
    AssignCommand(OBJECT_SELF, DetermineCombatRound());
}


//    Returns the combined class levels of the target.
int GetCharacterLevel(object oTarget)
{
    return GetHitDice(oTarget);
}

//    Checks if the NPC has sleep on them because
//    of ambient animations. Sleeping creatures
//    must make a DC 15 listen check.
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002
void RemoveAmbientSleep()
{
    if(GetHasEffect(EFFECT_TYPE_SLEEP))
    {
        effect eSleep = GetFirstEffect(OBJECT_SELF);
        while(GetIsEffectValid(eSleep))
        {
            if(GetEffectCreator(eSleep) == OBJECT_SELF)
            {
                int nRoll = d20();
                nRoll += GetSkillRank(SKILL_LISTEN);
                nRoll += GetAbilityModifier(ABILITY_WISDOM);
                if(nRoll > 15)
                {
                    RemoveEffect(OBJECT_SELF, eSleep);
                }
            }
            eSleep = GetNextEffect(OBJECT_SELF);
        }
    }
}


//    Finds the closest locked object to the object
//    passed in up to a maximum of 10 objects.
//:: Created By: Preston Watamaniuk
//:: Created On: March 15, 2002
object GetLockedObject(object oMaster)
{
    int nCnt = 1;
    int bValid = TRUE;
    object oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    while (GetIsObjectValid(oLastObject) && bValid == TRUE)
    {
        //COMMENT THIS BACK IN WHEN DOOR ACTION WORKS ON PLACABLE.

        //object oItem = GetFirstItemInInventory(oLastObject);
        if(GetLocked(oLastObject))
        {
            return oLastObject;
        }
        nCnt++;
        if(nCnt == 10)
        {
            bValid = FALSE;
        }
        oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    }
    return OBJECT_INVALID;
}


//    Checks that an item was unlocked.
void CheckIsUnlocked(object oLastObject)
{
    if(GetLocked(oLastObject))
    {
        ActionDoCommand(VoiceCuss());
    }
    else
    {
        ActionDoCommand(VoiceCanDo());
    }
}


//:: Play Mobile Ambient Animations
//:: This function is now just a wrapper around
//:: code from x0_i0_anims.
void PlayMobileAmbientAnimations()
{
    if(!GetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS_AVIAN)) {
        // not a bird
        PlayMobileAmbientAnimations_NonAvian();
    } else {
        // a bird
        PlayMobileAmbientAnimations_Avian();
    }
}

//    Determines the special behavior used by the NPC.
//    Generally all NPCs who you want to behave differently
//    than the defualt behavior.
//    For these behaviors, passing in a valid object will
//    cause the creature to become hostile the the attacker.
//
//    MODIFIED February 7 2003:
//    - Rearranged logic order a little so that the creatures
//    will actually randomwalk when not fighting
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14, 2001
void DetermineSpecialBehavior(object oIntruder = OBJECT_INVALID)
{
    object oTarget = GetNearestSeenEnemy();
    if(GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE))
    {
        int bAttack = FALSE;
        if(!GetIsObjectValid(oIntruder))
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 8.0)
                {
                    if(!GetIsFriend(oTarget))
                    {
                        if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                        {
                            SetIsTemporaryEnemy(oTarget, OBJECT_SELF, FALSE, 20.0);
                            bAttack = TRUE;
                            DetermineCombatRound(oTarget);
                        }
                    }
                }
            }
        }
        else if(!IsInConversation(OBJECT_SELF))
        {
            bAttack = TRUE;
            DetermineCombatRound(oIntruder);
        }

        // * if not attacking, the wander
        if (bAttack == FALSE)
        {
            ClearActions(CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior1);
            ActionRandomWalk();
            return;
        }
    }
    else if(GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
    {
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()) &&
           !GetIsObjectValid(GetAttackTarget()))
        {
            if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 6.0)
            {
                if(!GetIsFriend(oTarget))
                {
                    if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                    {
                        TalentFlee(oTarget);
                    }
                }
            }
        }
        else if(!IsInConversation(OBJECT_SELF))
        {
            ClearActions(CLEAR_NW_I0_GENERIC_DetermineSpecialBehavior2);
            ActionRandomWalk();
            return;
        }
    }
}

//	This function is for choosing what tactics to use when fighting a door.
//	oDoorIntruder is the door to fight, and the function is run on the combating creature.
//	Returns 1 on a succesful choice of tactic (which should always occur) and 0 when no tactics were chosen.
//  Originally from BashDoorCheck(), taken out.
int ChooseTacticsForDoor(object oDoorIntruder = OBJECT_INVALID)
{
	if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK))
	{
		ActionUseFeat(FEAT_IMPROVED_POWER_ATTACK, oDoorIntruder);
		return 1;
	}
	else if(GetHasFeat(FEAT_POWER_ATTACK))
	{
		ActionUseFeat(FEAT_POWER_ATTACK, oDoorIntruder);
		return 1;
	}
	else
	{
		//WrapperActionAttack(oDoorIntruder);
		ActionAttack(oDoorIntruder);
		return 1;
	}
	return 0;	//unreachable, technically
}


//    Used in DetermineCombatRound to keep a
//    henchmen bashing doors.
//	
//	Also used to limit the tactics used when fighting a door.
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
int BashDoorCheck(object oIntruder = OBJECT_INVALID)
{
   int bDoor = FALSE;
    //This code is here to make sure that henchmen keep bashing doors and placables.
    object oDoor = GetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");

	if (GetIsObjectValid(oDoor))	//run tests to see if we should bash this door that we received from a shout
	{
		if (!(!GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
    	       	|| (!GetIsObjectValid(oIntruder) && !GetIsObjectValid(GetCurrentMaster()))))
		  	oDoor = OBJECT_INVALID; //That last check was to prevent a henchmen or creatures form attacking a door if they are in combat (and have bigger concerns)
		else if (GetIsTrapped(oDoor) ) oDoor = OBJECT_INVALID; //Don't attack a trapped door.
   		else if (!GetLocked(oDoor)) oDoor = OBJECT_INVALID;	//Don't attack a Locked door.
	}
	//From the original BashDoorCheck(), this handles the door that we were shouted to attack.							
    if(GetIsObjectValid(oDoor))
    {
        int nDoorMax = GetMaxHitPoints(oDoor);
        int nDoorNow = GetCurrentHitPoints(oDoor);
        int nCnt = GetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP");//this variable appears to be a misnomer, and is used to keep track of how many times we have tried to bash this door.
		if(nDoorMax == nDoorNow)
        {
            nCnt++;
            SetLocalInt(OBJECT_SELF,"NW_GENERIC_DOOR_TO_BASH_HP", nCnt);
        }
        if(nCnt <= 0)
        {
            bDoor = ChooseTacticsForDoor(oDoor);
        }
        if(bDoor == FALSE)
        {
            VoiceCuss();
            DeleteLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH");
            DeleteLocalInt(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH_HP");
        }
		return bDoor;
    }
	else	//We either were not shouted to attack a door, or we decided that the shouted door is not good to attack.
	{		//Now we check oIntruder to see if the object we were going to attack anyway is a door.
		if (GetObjectType(oIntruder)==OBJECT_TYPE_DOOR)
		{
			return ChooseTacticsForDoor(oIntruder);
		}			
	}
	return FALSE;    //did nothing
}


//    Determines which of a NPCs three classes to
//    use in DetermineCombatRound
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
// Creatures can now have 4 classes
int DetermineClassToUse()
{
    int nClass;
    int nTotal = GetHitDice(OBJECT_SELF);

    int nClass1 = GetClassByPosition(1);
    int nClass2 = GetClassByPosition(2);
    int nClass3 = GetClassByPosition(3);

    int nState1 = GetLevelByClass(nClass1) * 100 / nTotal;
    int nState2 = nState1 + GetLevelByClass(nClass2) * 100 / nTotal;
    int nState3 = nState2 + GetLevelByClass(nClass3) * 100 / nTotal;

    int nUseClass = d100();
    //PrettyDebug("Hit Dice=" + IntToString(nTotal) + " D100 Roll=" + IntToString(nUseClass));
    //PrettyDebug("nClass1=" + IntToString(nClass1) + " nClass2=" + IntToString(nClass2)+ " nClass3=" + IntToString(nClass3));
    //PrettyDebug("nState1=" + IntToString(nState1) + " nState2=" + IntToString(nState2)+ " nState3=" + IntToString(nState3));

    if(nUseClass <= nState1)
    {
        nClass = nClass1;
    }
    //else if(nUseClass > nState1 && nUseClass <= nState2)
    else if(nUseClass <= nState2)
    {
        nClass = nClass2;
    }
    else if(nUseClass <= nState3)
    {
        nClass = nClass3;
    }
	else
    {
        nClass = GetClassByPosition(4);
    }
    //PrettyDebug(GetName(OBJECT_SELF) + " Return Class = " + IntToString(nClass));

    return nClass;
}

//=======================================================
// EvenFlw functions
//=======================================================


int CheckForInvis(object oIntruder)
{
	if(InvisibleTrue(oIntruder)==TRUE) return TRUE;
	object target=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	int total=0;
	while(GetIsObjectValid(target) && total<5) {
		if(GetIsEnemy(target) && InvisibleTrue(target)==TRUE)
			return TRUE;
		total++;
		target=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
	return FALSE;
}


int CheckNonOffensiveMagic(object oIntruder, int nOffense, int nCompassion, int nMagic, int iCastingMode)
{
    if (nCompassion > 50) {
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_DEFENSE_OTHERS);
        if(TalentHeal() == TRUE) return 99;
		if(TalentResurrect()) return 99;
        if(TalentCureCondition() == TRUE) return 99;
    }
    if (nOffense<= 50 && nMagic > 50) {
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_DEFENSE_SELF);
        int nCaster = GetLevelByClass(CLASS_TYPE_WIZARD, oIntruder) +
            GetLevelByClass(CLASS_TYPE_SORCERER, oIntruder) +
            GetLevelByClass(CLASS_TYPE_BARD, oIntruder)+
			GetLevelByClass(CLASS_TYPE_CLERIC, oIntruder) +
            GetLevelByClass(CLASS_TYPE_DRUID, oIntruder);
		if(iCastingMode==2) nCaster+=5;
        if (iCastingMode<2 || nCaster > GetHitDice(OBJECT_SELF)/2)
        {
			nCaster=1;
            if (TalentSelfProtectionMantleOrGlobe())
                return 99;
        } else nCaster=0;
        int seed=d4();
        if(seed!=1 && nCompassion<51 || seed>2) {
            if(TalentAdvancedBuff2(OBJECT_SELF, oIntruder, nCaster, iCastingMode) == TRUE) return 99;
        } else {
            if(TalentOthers(nCompassion, oIntruder, nCaster, iCastingMode)) return 99;
        }
        if(TalentSummonAllies() == TRUE) return 99;
        if(!(GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE)&0x1) && TalentBuffSelf() == TRUE) return 99; // potions
        if(CheckForInvis(oIntruder) && TalentSeeInvisible() == TRUE) return 99;
    }
	return 0;
}

int GetScaledCastingMagic(int iCastingMode, int nMagic, int def, int random=FALSE)
{
	switch(iCastingMode) {
		case 1: nMagic=55;
		break;
		case 2: nMagic=45-GetHitDice(OBJECT_SELF)/3;
		break;
		case 3: if(random) nMagic=Random(nMagic)+1;
				else nMagic=40-GetHitDice(OBJECT_SELF)/2;
		break;
		default: if(random) nMagic=Random(def)+1;
				else nMagic=def;
	}
	return nMagic;
}


void InitializeSeed(int iCastingMode, object oIntruder)
{
	int diff=20;
	if(iCastingMode>1)
		diff=GetHitDice(oIntruder);
	if(iCastingMode==2)
		diff+=5;
	if(diff>20) diff=20;
	if(d2()==1) {
		if(diff>GetHitDice(OBJECT_SELF))
			diff=GetHitDice(OBJECT_SELF)+1;
		diff-=d4()+1;
		if(diff<4) diff=4;
	}
	SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", diff);
}


// *** sub function of chooseTactics()

int GetMelee() {
	object weapon=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	if(!GetIsObjectValid(weapon) || MatchMeleeWeapon(weapon)) return TRUE;
	return FALSE;
}

// returns percentage of hitpoints remaining
int GetHPPercentage(object oTarget=OBJECT_SELF)
{
	return ((GetCurrentHitPoints(oTarget)*100)/GetMaxHitPoints(oTarget));
}


int GetCastingMode(int iMyHPPercentage)
{
	int iCastingMode = 0;
	
	if(iMyHPPercentage < 50) 
		iCastingMode=0;
	else if(GetAssociateState(NW_ASC_OVERKIll_CASTING)) 
		iCastingMode=1;
	else if(GetAssociateState(NW_ASC_POWER_CASTING)) 
		iCastingMode=2;
	else if(GetAssociateState(NW_ASC_SCALED_CASTING)) 
		iCastingMode=3;
		
	return (iCastingMode);
}



struct rTactics CreateTactics(int nOffense=0, int nCompassion=0, int nMagic=0, int nMagicOld=0, int nStealth=0, int bScaredOfSilence=0, int bTacticChosen=0)
{
	struct rTactics tacAI;
	
    tacAI.nOffense			= nOffense;
    tacAI.nCompassion		= nCompassion;
    tacAI.nMagic			= nMagic;
    tacAI.nMagicOld			= nMagicOld;
	tacAI.nStealth			= nStealth;
								   
	tacAI.bScaredOfSilence	= bScaredOfSilence;	
	tacAI.bTacticChosen		= bTacticChosen;
	
	return (tacAI);
}


// Check if we can already determine from the class what to do.
int TryClassTactic(object oIntruder, int nClass, int bNoFeats)
{
	int bTacticChosen = FALSE;
	
    switch (nClass)
    {
        case CLASS_TYPE_COMMONER:
        	bTacticChosen = TalentFlee(oIntruder);
			break;
			
		//------------------------------------------			
		
        case CLASS_TYPE_DRAGONDISCIPLE:
		    if (!bNoFeats 
				&& GetHasFeat(FEAT_DRAGON_DIS_BREATH) 
				&& d4()==1)
    		{
        		ClearActions(2000);
        		ActionCastSpellAtObject(690, GetNearestEnemy(), METAMAGIC_ANY, TRUE);
        		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRAGON_DIS_BREATH);
        		bTacticChosen = TRUE;
    		}
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_BARD:
		    if (!bNoFeats 
				&& TalentBardSong() == TRUE)
			{
				bTacticChosen = TRUE;
			}
			break;
			
			
		//------------------------------------------			
			
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_ARCANE_ARCHER:
			if (!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED) 
				&& GetHasFeat(FEAT_RAPID_SHOT))
			{				
				SetActionMode(OBJECT_SELF, ACTION_MODE_RAPID_SHOT, TRUE);
				bTacticChosen = FALSE; // still need to choose a tactic
			}
			break;
	
		//------------------------------------------			
			
        case CLASS_TYPE_BARBARIAN:
			if (!bNoFeats 
				&& !GetHasFeatEffect(FEAT_BARBARIAN_RAGE) 
				&& GetHasFeat(FEAT_BARBARIAN_RAGE)) 
			{
				ClearAllActions();
				ActionUseFeat(FEAT_BARBARIAN_RAGE, OBJECT_SELF);
				ActionAttack(oIntruder);
        		bTacticChosen = TRUE;
			}
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_FRENZIEDBERSERKER:
			if (!bNoFeats 
				&& !GetHasFeatEffect(FEAT_FRENZY_1) 
				&& GetHasFeat(FEAT_FRENZY_1)) 
			{
				ClearAllActions();
				ActionUseFeat(FEAT_FRENZY_1, OBJECT_SELF);
				ActionAttack(oIntruder);
        		bTacticChosen = TRUE;
			}
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_MONK:
			SetActionMode(OBJECT_SELF, ACTION_MODE_FLURRY_OF_BLOWS, TRUE);
			bTacticChosen = FALSE; // still need to choose a tactic
			break;

		//------------------------------------------			
			
        default:
            break;
    }

	return (bTacticChosen);
}
	
struct rTactics CalculateTacticsByClass (struct rTactics tacAI, object oIntruder, int nClass, int iCastingMode)
{	
    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
								   
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen; // this function should not choose a tactic.

	
	// Classes determine the "base" levels for the tactic types.  
	// Thus the values are generally overridden, not modified	
    switch (nClass)
    {
        case CLASS_TYPE_COMMONER:
			nOffense 				= 0; 
			nCompassion 			= 0; 
			nMagic 					= 0;  
			break;
		//------------------------------------------			
			
        case CLASS_TYPE_PALEMASTER:
		case CLASS_TYPE_ARCANETRICKSTER:
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SORCERER:
			bScaredOfSilence		= TRUE;
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 100);
			if(iCastingMode ==1 ) 
				nMagic				= 100;
            nCompassion 			= 42; 
			break;
		//------------------------------------------			
		
        case CLASS_TYPE_DRAGONDISCIPLE:
		case CLASS_TYPE_BARD:
			bScaredOfSilence		= TRUE;
			// continue
			
        case CLASS_TYPE_HARPER:
		case CLASS_TYPE_ELDRITCH_KNIGHT:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 43);
            nCompassion 			= 43; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_CLERIC:
			if (GetHitDice(oIntruder) > GetHitDice(OBJECT_SELF)) 
				nStealth			= 70;
			bScaredOfSilence		= TRUE;
			// continue

		case CLASS_TYPE_WARPRIEST:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 44);
			nCompassion				= 45; 
			break;

		//------------------------------------------			
						
        case CLASS_TYPE_DRUID:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 55);
			bScaredOfSilence		= TRUE;
            nCompassion 			= 45; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
			nCompassion				= 43;
			// continue
			
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_BLACKGUARD:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 50, 50, TRUE);
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_BARBARIAN:
		case CLASS_TYPE_FRENZIEDBERSERKER:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
            nOffense 				= 50; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_ROGUE:
		case CLASS_TYPE_SHADOWTHIEFOFAMN:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_ASSASSIN:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
			nStealth				= 100; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_FIGHTER:
		case CLASS_NWNINE_WARDER:
		case CLASS_TYPE_DUELIST:
			nMagic 					= GetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_UNDEAD:
            nCompassion 			= 40; 
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_OUTSIDER:
            nMagic 					= 40; 
			nCompassion				= 0;
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
            {
                nCompassion 		= 41;
            }
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_CONSTRUCT:
        case CLASS_TYPE_ELEMENTAL:
            nCompassion 			= 0;
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_DRAGON:
            nCompassion 			= 20; 
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_WARLOCK:
			bScaredOfSilence		= TRUE;
			nCompassion 			= 0; 
			nMagic 					= 80; 
			break;
			
		//------------------------------------------			
			
        default:
            break;
    }
	return (CreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, bTacticChosen));
}



struct rTactics CalculateTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced)
{
    int nPreviousMemory 	= GetLocalInt(OBJECT_SELF, "NW_L_MEMORY");

    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
								   
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen;
	
	// tend toward stealthy if wounded
	if (GetHPPercentage()<50)
		nStealth += 10;	

	// Racial adjustments
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD 
		&& nCompassion > 40 
		&& GetHPPercentage() < 75)
	{		
        nCompassion = 0;
	}
	
	// random adjustments			
    nOffense 	= Random(10) + nOffense;
    nMagic 		= Random(10) + nMagic;
    nCompassion = Random(10) + nCompassion;
	
	// Bahavior variable adjustments
    nMagic 		= nMagic + AdjustBehaviorVariable(nMagic, "X2_L_BEH_MAGIC");	
    nOffense 	= nOffense + AdjustBehaviorVariable(nOffense, "X2_L_BEH_OFFENSE");
    nCompassion = nCompassion + AdjustBehaviorVariable(nCompassion, "X2_L_BEH_COMPASSION");
	
	// feat adjustments
    if (GetIsObjectValid(oIntruder) && !GetHasFeat(FEAT_COMBAT_CASTING))
    {
        if (fDistanceToIntruder <= 5.f) 
		{
            nOffense = nOffense + 20;
            nMagic = nMagic - 20;
        }
    }
	
	// casting mode adjustments
    if (iCastingMode!=2 && fDistanceToIntruder > 2.5f)
        nMagic = nMagic + 15;
		
	// Intruder stats adjustments		
    nMagic = nMagic + GetHitDice(oIntruder);
	
	// previous choices adjustments	
    if ((nPreviousMemory == chooseTactics_MEMORY_DEFENSE_OTHERS)
        || (nPreviousMemory == chooseTactics_MEMORY_DEFENSE_SELF))
    {
        nOffense = nOffense + Random(40);
    }
	
	// remember magic score at this point.
	nMagicOld = nMagic;
	
	// adjustments if incapable of casting
    if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE) 
		|| GetShouldNotCastSpellsBecauseofArmor(OBJECT_SELF, nClass)
        || GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 10 
		|| GetHasFeatEffect(FEAT_FRENZY_1) 
		|| GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION) 
		|| GetHasSpellEffect(SPELL_TRUE_STRIKE))
    {
		nCompassion = 0;
        nMagic = 0;
    }
	
	// polymorphed adjustments for casting
	// AFW-OEI 07/12/2007: Don't unpolymorph if you're polymorph locked
	if (GetHasEffect(EFFECT_TYPE_POLYMORPH)	&& !GetPolymorphLocked(OBJECT_SELF)
		&& (!GetHasFeat(FEAT_NATURAL_SPELL, OBJECT_SELF, TRUE) || !GetHasEffect(EFFECT_TYPE_WILDSHAPE))) 
	{
		int unpoly = GetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY);
		if(!unpoly) 
		{
			SetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY, 1);
			DelayCommand(RoundsToSeconds(5), SetLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY, 2));
		}
		if(unpoly==2 && d6()==1) 
		{
			effect eff = GetFirstEffect(OBJECT_SELF);
			while (GetIsEffectValid(eff)) 
			{
				if(GetEffectType(eff)==EFFECT_TYPE_POLYMORPH) 
				{
					RemoveEffect(OBJECT_SELF, eff);
					break;
				}
				eff=GetNextEffect(OBJECT_SELF);
			}
		} 
		else 
			nMagic=0;
	} 
	else 
		DeleteLocalInt(OBJECT_SELF, EVENFLW_AI_UNPOLY);
	
	
	// silence
	if(isSilenced) 
	{
		if (GetLocalInt(OBJECT_SELF, EVENFLW_NOT_SILENCE_SCARED) 
			|| GetLocalInt(OBJECT_SELF, EVENFLW_SILENCE))
				bScaredOfSilence = FALSE;
	} 
	else 
	{
		DeleteLocalInt(OBJECT_SELF, EVENFLW_NOT_SILENCE_SCARED);
		DeleteLocalInt(OBJECT_SELF, EVENFLW_SILENCE);
	}
	
	
    int isInvis = InvisibleTrue(OBJECT_SELF);
    if (!GetObjectSeen(OBJECT_SELF, oIntruder) 
		&& isInvis == TRUE 
		&& nMagic > 0 
		&& !isSilenced)
    {
        if (nStealth==100 || GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == TRUE)
        {
          nOffense = 100; // * if in stealth attempt sneak attacks
        } 
		else if(d4()!=1) 
		{
            nOffense = 7;
            if (nMagic < 51)
			{ 
				nMagic += 10;
			}	
			nCompassion += d10();
			if (GetHPPercentage() < 80)
            	if(TalentHealingSelf(TRUE) == TRUE)
				{
					bTacticChosen = TRUE;
				}					
        }
    } 
	else
	{ 
		if ((nStealth==100 || (!isSilenced && (nStealth>=Random(100)))) 
			&& InvisibleBecome(OBJECT_SELF, isInvis) == TRUE) 
		{
			bTacticChosen = TRUE;
		}			
	}
	
	return (CreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, bTacticChosen));
}


int DetermineActionFromTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced, int bNoFeats)
{
    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
								   
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen;
	
	int iNumMeleeAttackers	=GetNumberOfMeleeAttackers();

		
    if (nOffense <= 5 
		|| isSilenced 
			&& nMagic>50 
			&& bScaredOfSilence 
			&& GetIsObjectValid(GetLocalObject(OBJECT_SELF, EVENFLW_SILENCE)))
    {
		if (bScaredOfSilence) 
		{
			ActionMoveAwayFromObject(GetLocalObject(OBJECT_SELF, EVENFLW_SILENCE), TRUE, 7.0f);
			DelayCommand(3.0f, DetermineCombatRound(oIntruder));
			return 99;
        } 
		else
		{
			if (TalentFlee(oIntruder) == TRUE) 
				return 99;
		}				
    }
	
	if(oIntruder==OBJECT_SELF) 
		nOffense = 0;
		
	SetLocalInt(OBJECT_SELF, EVENFLW_NUM_MELEE, iNumMeleeAttackers);
	
	if(!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED)) 
	{
		if ((fDistanceToIntruder < 5.0 || iNumMeleeAttackers) && (nMagic>50 || nCompassion>50) && (GetLastGenericSpellCast() != 0))
			SetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST, TRUE);
	}
	
	InitializeSeed(iCastingMode, oIntruder);
	
	if(CheckNonOffensiveMagic(oIntruder, nOffense, nCompassion, nMagic, iCastingMode)) return 99;
	
	if(oIntruder==OBJECT_SELF) return 1;
	
    if (nMagic > 50)
    {
        SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_OFFENSE_SPELL);
        if (!bNoFeats && TalentUseTurning(oIntruder) == TRUE) return 99;
		if(TalentDebuff(oIntruder)) return 99;
		if(nClass == CLASS_TYPE_WARLOCK) if(TalentWarlockSpellAttack(oIntruder)) return 99;
		
		if(GetLocalInt(OBJECT_SELF, EVENFLW_AI_CLOSE)) 
		{
        	if(TalentMeleeAttacked(oIntruder, iNumMeleeAttackers) == TRUE) return 99;
        	if(TalentRangedEnemies(oIntruder) == TRUE) return 99;
		} 
		else 
		{
        	if(TalentRangedEnemies(oIntruder) == TRUE) return 99;
			if(!GetLocalInt(OBJECT_SELF, N2_COMBAT_MODE_USE_DISABLED) && (GetLastGenericSpellCast() != 0))
				SetActionMode(OBJECT_SELF, ACTION_MODE_DEFENSIVE_CAST, TRUE);
			if(TalentMeleeAttacked(oIntruder, 1) == TRUE) return 99;
		}
    }
	
	if (nOffense>50 
		&& nMagic>50 
		&& d2()!=1) 
	{
		if(CheckNonOffensiveMagic(oIntruder, 10, 0, nMagic, iCastingMode)) return 99;
	}
	
	if(nMagic>50) 
	{
		int lastditch=TalentLastDitch();
		if(lastditch==TRUE) return 99;
		if(!lastditch) 
		{
			if(GetLevelByClass(CLASS_TYPE_WARLOCK) && TalentWarlockSpellAttack(oIntruder)) return 99;
			if(TalentCantrip(oIntruder)) return 99;
		}
	}
	
	if(nMagic==0 && nMagicOld>50) 
	{
		if(!(GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE) & TALENT_EXCLUDE_ITEM) 
			&& TalentBuffSelf() == TRUE) 
		{			
			return 99;
		}			
	}
	
	if(nMagic>50) 
		SetLocalInt(OBJECT_SELF, EVENFLW_NOT_SILENCE_SCARED, 1);
		
    SetLocalInt(OBJECT_SELF, "NW_L_MEMORY", chooseTactics_MEMORY_OFFENSE_MELEE);
	
	if (!bNoFeats			
		&& Random(12) == 0	// we only want to do this occasionally
		&& GetMelee() 		
		&& TalentKnockdown(oIntruder)==TRUE )
	{
		ActionAttack(oIntruder);
		return 99;
	}
			
    if (TryKiDamage(oIntruder) == TRUE) return 99;
    if (TalentSneakAttack() == TRUE) return 99;
    if (TalentDragonCombat(oIntruder)) {return 99;}
    if (TalentMeleeAttack(oIntruder) == TRUE) return 99;

	return 1;	
}


int chooseTactics(object oIntruder)
{
	if(TalentHealingSelf() == TRUE) return 99;
    if (SpecialTactics(oIntruder)) return 99;
	
	int iExcludeFlag 	= GetLocalInt(OBJECT_SELF, N2_TALENT_EXCLUDE);
	int bNoFeats 		= iExcludeFlag & TALENT_EXCLUDE_ABILITY;
    int nClass 			= DetermineClassToUse();
		
	float fDistanceToIntruder = GetDistanceToObject(oIntruder);
	int iCastingMode	= GetCastingMode(GetHPPercentage());
	int isSilenced		= GetHasEffect(EFFECT_TYPE_SILENCE);
	
	// tactics vars - base values
    int nOffense 		= 40;
    int nCompassion		= 25;
    int nMagic 			= 55;
    int nMagicOld		= 0;
	int nStealth		= 30;
	int bScaredOfSilence= FALSE;
	struct rTactics tacAI = CreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, FALSE);

		
	// Stuff chosen here will short circuit all the tactics calculations 	
	if (TryClassTactic(oIntruder, nClass, bNoFeats) == TRUE)
		return 99;

	if(GetCreatureSize(oIntruder) > 4) 
		fDistanceToIntruder -= 10.5f;

	tacAI = CalculateTacticsByClass(tacAI, oIntruder, nClass, iCastingMode);
	if (tacAI.bTacticChosen == TRUE) return 99;

	tacAI = CalculateTactics(tacAI, oIntruder, fDistanceToIntruder, nClass, iCastingMode, isSilenced);
	if (tacAI.bTacticChosen == TRUE) return 99;

	return (DetermineActionFromTactics(tacAI, oIntruder, fDistanceToIntruder, nClass, iCastingMode, isSilenced, bNoFeats));

} // * END of choosetactics

/* void main() {} /* */
 
 
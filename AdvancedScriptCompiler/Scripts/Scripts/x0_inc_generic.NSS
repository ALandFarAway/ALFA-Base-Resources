//::///////////////////////////////////////////////
//:: x0_inc_generic
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    new functions breaking down some of the 'big'
    functions in nw_i0_generic for readability.



    MODIFICATION FEBRUARY 6 2003: MAJOR!!!
    Put the clarallactions that preceeded almost every talent call
    inside of TalentFilter


    - Dec 18 2002: Only henchmen will now make evaluations
           based upon difficulty of the combat.

* Many of these functions are incorporating
* Pausanias' changes, a big thanks goes out to him.


SECTION 1:

*/
// ChazM 7/26/06 - Modified ChooseNewTarget() to avoid familiars.
// ChazM 8/29/06 - Modified ChooseNewTarget() so that DefendMaserMode will prevent creature from aquiring 
// 				targets (except for hated enemies) that are too far away from the master.
// DBR 8/30/06 - Modified ChooseNewTarget() to continue iterating after a failed distance check.
// ChazM 9/5/06 - Modified bkAcquireTarget() so no weapon switching also applies to companions.
// ChazM 9/6/06 - Modified bkTalentFilter() to account for feat type; added TalentSpellFilter(), structure rValidTalent
// DBR 9/11/06 - Added SpellFilterHasImmunity(), to prevent casters from casting Fear and Mind spells on those that
//				 are immune (part of this is handled by bkTalentFiler)
// DBR 9/14/06 - Ignored SpellFilterHasImmunity() check if target of spell is self (for buffs).
// ChazM 9/19/06 rename bkTalentFilter() as TalentFilter()
// ChazM 9/19/06 moved GetCreatureTalentBestStd(), GetCreatureTalentRandomStd(), GetCreatureTalent() from x0_i0_talent;
//				modified TalentSpellFilter()
// BMA-OEI 10/12/06 - Added N2_COMBAT_MODE_USE_DISABLED
// DBR 10/25/06 - When choosing a new target, 'defending' companions should not choose someone who is in combat.
// DBR 11/06/06 - TalentSpellFilter() - Don't cast 'keen edge' or 'weapon of impact' on inappropriate weapons.
// ChazM 1/18/07 - EvenFlw AI functions added, InvisibleTrue() moved here from NW_IO_Generic, bkAcquireTarget() replaced.
// ChazM 1/30/07 - Split out IsTargetImmuneToSpell() MatchHumanoidRacialType() (moved to x0_i0_match) from EvenTalentCheck().  No longer use spells2.2da
// ChazM 4/27/07 - redirect TalentFilter() to EvenTalentFilter(); various structural enhancements
// ChazM 4/27/07 - Moved constants to ginc_2da
// ChazM 5/25/07 - Modified ValidTarget() for easier Script Debugging
// ChazM 5/30/07 - removed plot check from ValidTarget()
// ChazM 6/7/07 - Modified IsSpellEffectiveAgainstTarget() to reduce "knowingness" of creatures not in a PC party.
// ChazM 6/8/07 - Moved remaining condition constants to x0_i0_talent
// ChazM 6/11/07 - Modified IsTargetImmuneToSpell() - non-party members will no longer "know" most target immunities.
// MDiekmann 6/19/07 - Added fix to EvenTalentSpellFilter that caused AI to not do anything when trying to cast spell on not visible player.
// MDiekmann 7/13/07 - Modified IsSpellEffectiveAgainstTarget() so that companions now know when not to cast a spell against a troll.
// ChazM 7/17/07 - remove space from " ginc_event_handlers" include.
// ChazM 7/23/07 - Modified bkAcquireTarget() - Don't attack last target if he is no longer seen (such as teleporting away).
// MDiekmann 8/3/07 - Added a feat filter which will check to see if a target is not immune to the feat and that the target does not already have the feat effect on it
// ChazM 8/3/07 - Moved Feat Immunity Type check to EvenTalentCheck() (called by TryTalent); futher combined spell/feat immunity
// MDiekmann 9/7/07 - Added a check for when a silence spell is cast to make sure it is an ok time to use that spell
#include "x0_i0_debug"
// #include "x0_i0_match" -- included in x0_i0_enemy
// #include "x0_i0_enemy" -- included in x0_i0_equip
// #include "x0_i0_assoc" -- included in x0_i0_equip
#include "x0_i0_equip"
#include "ginc_2da"
#include "ginc_event_handlers"

// void main(){}


/**********************************************************************
 * CONSTANTS & Structures
 **********************************************************************/
const string VAR_X2_SPELL_RANDOM 			= "X2_SPELL_RANDOM";
const string VAR_NW_L_BEHAVIOUR1 			= "NW_L_BEHAVIOUR1";
const string VAR_NW_L_COMBATDIFF 			= "NW_L_COMBATDIFF";

 

// IF this is true there is no CR consideration for using powers
const int NO_SMART = FALSE;

const float DEFEND_MASTER_MAX_TARGET_DISTANCE = 22.0f;

// prefix notation is "r" for structure definition, "o" for instance of structure.
struct rValidTalent
{
     talent tTalent;	// Talent in question 
     // int bUseAtLocation;	// set to true to signal talent to be used at location instead of on object
     object oTarget;	// tareget of the talent
     int bValid;		// FALSE indicates should be treated as TALENT_INVALID (if it existed)
};

const string N2_TALENT_EXCLUDE = "N2_TALENT_EXCLUDE";	// bit flag containing talents to exclude
// The available bit constants from NWSCRIPT:
// int TALENT_EXCLUDE_ITEM 	= 1;
// int TALENT_EXCLUDE_ABILITY 	= 2;
// int TALENT_EXCLUDE_SPELL 	= 4;

// Disable changing Combat Modes in Combat AI 
const string N2_COMBAT_MODE_USE_DISABLED = "N2_COMBAT_MODE_USE_DISABLED";

const string EVENFLW_AI_CONFUSED 		= "EVENFLW_AI_CONFUSED";



//======================================================================= 
// FUNCTION PROTOTYPES
//======================================================================= 
// wrapper for GetCreatureTalentRandom() using flag specified on the creature.
talent GetCreatureTalentRandomStd(int nCategory, object oCreature=OBJECT_SELF);

// wrapper for GetCreatureTalentBest() using flag specified on the creature.
talent GetCreatureTalentBestStd(int nCategory, int nCRMax, object oCreature=OBJECT_SELF);

// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF);


// Set up our hated class
void bkSetupBehavior(int nBehaviour);

// Return the combat difficulty.
// This is only used for henchmen and its only function currently
// is to keep henchmen from casting spells in an easy fight.
// This determines the difficulty by counting the number of allies
// and enemies and their respective CRs, then converting the value
// into a "spell CR" rating.
// A value of 20 means use whatever you have, a negative value
// means a very easy fight.
int GetCombatDifficulty(object oRelativeTo=OBJECT_SELF, int bEnable=FALSE);

// * Am I in a invisible or stealth state or sanctuary?
int InvisibleTrue(object oSelf = OBJECT_SELF);

// Determine our target for the next combat round.
// Normally, this will be the same target as the last round.
// The only time this changes is if the target is gone/killed
// or they are in dying mode.
object bkAcquireTarget();

// Choose a new nearby target. Target must be an enemy, perceived,
// and not in dying mode. If possible, we first target members of
// a class we "hate" -- this is generally random, to keep everyone
// from attacking the same target.
object ChooseNewTarget();

//    Determines the Spell CR to be used in the
//    given situation
//
//    BK: changed this. It returns the the max CR for
//    this particular scenario.
//
//    NOTE: Will apply to all creatures though it may
//    be necessary to limit it just for associates.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
int GetCRMax();

//    Returns true if something that shouldn't
//    have happened, happens. Will abort this combat
//    round.
int bkEvaluationSanityCheck(object oIntruder, float fFollow);

// DBR 9/11/06
//Checks to see if target creature might be immune to a certain spells
// This is not a clear-cut "does creature have immunity"? check, there are 
// some spells we do not want to check for so immunity can be seen in-game (and player can feel cool).
//int SpellFilterHasImmunity(object oTarget, int nSpellID);

struct rValidTalent TalentSpellFilter(talent tUse, object oTarget);

//    This function is the last minute filter to prevent
//    any inappropriate effects from being applied
//    to inapproprite creatures.
//
//    Returns TRUE if the talent was valid, FALSE otherwise.
//
//    If an invalid talent is attempted, we instead perform
//    a standard melee attack to avoid AI stopping.
//
// Based on Pausanias's Final Talent Filter.
// Parameters
// bJustTest = If this is true the function only does a test
//  the action stack is NOT modified at all
int TalentFilter(talent tUse, object oTarget, int bJustTest=FALSE);

//Sets a local variable for the last spell used
void SetLastGenericSpellCast(int nSpell);

//Returns a SPELL_ constant for the last spell used
int GetLastGenericSpellCast();

//Compares the current spell with the last one cast
int CompareLastSpellCast(int nSpell);

//Does a check to determine if the NPC has an attempted
//spell or attack target
int GetIsFighting(object oFighting);


talent SilenceCheck(talent tUse);
talent EvenGetCreatureTalent(int nCategory, int nCRMax, int bRandom, int CheckSilence=FALSE);
int ValidTarget(object oTarget);
int InvisibleTrue(object oSelf=OBJECT_SELF);
int WrongAlign(object oTarget);
int IsSpellEffectiveAgainstTarget(int iId, object oTarget);
int IsTargetImmuneToSpell(int iSpellId, object oTarget);
int EvenTalentCheck(talent tUse, object oTarget);
int EvenTalentSpellFilter(talent tUse, object oTarget);
int EvenTalentFilter(talent tUse, object oTarget, int bJustTest=FALSE);
int GetSpellImmunityType (int nSpellId);

//modifications to make sure feats make sense to use
int IsTargetImmuneToFeat(int nFeatId, object oTarget);
int TalentFeatFilter(talent tUse, object oTarget); 
int GetFeatImmunityType (int nFeatId);

//======================================================================= 
// FUNCTION DEFINITIONS
//======================================================================= 

 // wrapper for GetCreatureTalentRandom() using flag specified on the creature.
talent GetCreatureTalentRandomStd(int nCategory, object oCreature=OBJECT_SELF)
{
	return (GetCreatureTalentRandom(nCategory, oCreature, GetLocalInt(oCreature, N2_TALENT_EXCLUDE)));
}
// wrapper for GetCreatureTalentBest() using flag specified on the creature.
talent GetCreatureTalentBestStd(int nCategory, int nCRMax, object oCreature=OBJECT_SELF)
{
	return (GetCreatureTalentBest(nCategory, nCRMax, oCreature, GetLocalInt(oCreature, N2_TALENT_EXCLUDE)));
}

// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCreature is the creature checking to see if it has the talent
talent GetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCreature = OBJECT_SELF)
{
    // * bRandom can be overridden by the variable X2_SPELL_RANDOM = 1
    if (bRandom == FALSE)
    {
        bRandom = GetLocalInt(OBJECT_SELF, VAR_X2_SPELL_RANDOM);
    }

    if (bRandom == FALSE)
    {
        return GetCreatureTalentBestStd(nCategory, nCRMax, oCreature);
    }
    else
    // * randomize it
    {
        return GetCreatureTalentRandomStd(nCategory, oCreature);
    }
}

// Behavior1 = Hated Class
void bkSetupBehavior(int nBehaviour)
{
    int nHatedClass = Random(10);
    nHatedClass = nHatedClass + 1;     // for purposes of using 0 as a
                                       // unitialized value.
                                       // will decrement in bkAcquireTarget
    SetLocalInt(OBJECT_SELF, VAR_NW_L_BEHAVIOUR1, nHatedClass);
}

// Return the combat difficulty.
// This is only used for henchmen and its only function currently
// is to keep henchmen from casting spells in an easy fight.
// This determines the difficulty by counting the number of allies
// and enemies and their respective CRs, then converting the value
// into a "spell CR" rating.
// A value of 20 means use whatever you have, a negative value
// means a very easy fight.
// * Only does something if Enable is turned on, since I originally turned this function off
int GetCombatDifficulty(object oRelativeTo=OBJECT_SELF, int bEnable=FALSE)
{
    // DECEMBER 2002
    // * if I am not a henchman then DO NOT use combat difficulty
    // * simply use whatever I have available

    // FEBRUARY 2003
    // * Testing indicated that people were just too confused
    // * when they saw their henchmen not casting spells
    // * so this functionality has been cut entirely.

    // if (GetHenchman(GetMaster()) != oRelativeTo)
    if (bEnable == FALSE)
        return 20;

    // * Count Enemies
    struct sSituation sitCurr = CountEnemiesAndAllies(20.0, oRelativeTo);
    int nNumEnemies = sitCurr.ENEMY_NUM;
    int nNumAllies = sitCurr.ALLY_NUM;
    int nAllyCR = sitCurr.ALLY_CR;
    int nEnemyCR = sitCurr.ENEMY_CR;

    // * If for some reason no enemies then return low number
    if (nNumEnemies == 0) return -3;
    if (nNumAllies == 0) nNumAllies = 1;

    // * Average CR of enemies vs. Average CR of the players
    // * The + 5.0 is for flash. It would be boring if equally matched
    // * opponents never cast spells at each other.
    int nDiff = (nEnemyCR/nNumEnemies) - (nAllyCR/nNumAllies) + 3;

    // * if my side is outnumbered, then add difficulty to it
    if (nNumEnemies > (nNumAllies + 1))
        nDiff += 10;

    if (nDiff <= 1)
        return -2;

    // We now convert this number into the "spell CR" --
    // spell CR is as follows:
    // spell innate level * 2 - 1
    // eg, cantrip: innate level 0: spell CR -1
    // level 1 spell: innate level 1: spell CR 1
    // level 4 spell: innate level 4: spell CR 7
    // etc
    nDiff = (nDiff * 2) - 1;

    // * If I am at less than 50% hit-points add +10 -->
    // * it means that things are going badly for me
    // * and I need an edge
    if (GetCurrentHitPoints() <= GetMaxHitPoints()/2)
        nDiff = nDiff + 10;

    // * if not a low number then just return the difficulty
    // * converted into 'spell rounding'
    return nDiff;
}

object bkAcquireTarget() 
{
    object oLastTarget = GetAttackTarget();
	// The last target must be valid and also seen 
	// (if target teleports away to unseen location, this should prevent chase.)
    if(ValidTarget(oLastTarget) && GetObjectSeen(oLastTarget))
    {
        return oLastTarget;
    } else {
        oLastTarget = ChooseNewTarget();
    }
    if(ValidTarget(oLastTarget))
    {
    	bkEquipAppropriateWeapons(oLastTarget);
        return oLastTarget;
	}
	
	// not a valid target, search for a new target.
	oLastTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetLocation(OBJECT_SELF), TRUE);
	while(GetIsObjectValid(oLastTarget)) {
		if(ValidTarget(oLastTarget)) {
			if(GetObjectSeen(oLastTarget) || InvisibleTrue(oLastTarget)!=TRUE) {// || GetObjectHeard(oLastTarget)) {
				break;
			}
		}
		oLastTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetLocation(OBJECT_SELF), TRUE);
	}
    bkEquipAppropriateWeapons(oLastTarget);
    return oLastTarget;
}


/*
// This function returns the target for this combat round.
// Normally, this will be the same target as the last round.
// The only time this changes is if the target is gone/killed
// or they are in dying mode.
object bkAcquireTarget()
{
    object oLastTarget = GetAttackTarget();

    // * for now no 'target switching' other
    // * than what occurs in the OnDamaged and OnPerceived events
    // * (I may roll their functionality into this function
    if (GetIsObjectValid(oLastTarget) == TRUE
        && !GetAssociateState(NW_ASC_MODE_DYING, oLastTarget))
    {
        return oLastTarget;
    } else {
        oLastTarget = ChooseNewTarget();
    }

    // * If no valid target it means no enemies are nearby, resume normal behavior
    if (! GetIsObjectValid(oLastTarget)) {
        // * henchmen should only equip weapons based on what you tell them
        if (GetIsObjectValid(GetCurrentMaster(OBJECT_SELF)) == FALSE) {
            // * if no ranged weapon this function should
            // * automatically be melee weapon
            ActionEquipMostDamagingRanged();
        }
    }

    // valid or not, return it
    return oLastTarget;
}
*/


// Choose a new nearby target. Target must be an enemy, perceived,
// and not in dying mode. If possible, we first target members of
// a class we hate.
object ChooseNewTarget()
{
    int nHatedClass = GetLocalInt(OBJECT_SELF, VAR_NW_L_BEHAVIOUR1) - 1;

    // * if the object has no hated class, then assign it
    // * a random one.
    // * NOTE: Classes are off-by-one
    if (nHatedClass == -1)
    {
        bkSetupBehavior(1);
        nHatedClass = GetLocalInt(OBJECT_SELF, VAR_NW_L_BEHAVIOUR1) - 1;
    }

    //MyPrintString("I hate " + IntToString(nHatedClass));

    // * First try to attack the class you hate the most
    object oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, 1,
                                              CREATURE_TYPE_CLASS,
                                              nHatedClass);

    if (GetIsObjectValid(oTarget) && !GetAssociateState(NW_ASC_MODE_DYING, oTarget))
	{
		//if in Defend master, skip this step because of the over-ruling behaviors of defend master
		if (!(GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))) 
			// familiars of hated type don't qualify
			if (GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
	        	return oTarget;
	}
    // If we didn't find one with the criteria, look
    // for a nearby one
    // * Keep looking until we find a perceived target that
    // * isn't in dying mode
    oTarget = GetNearestPerceivedEnemy();
    int nNth = 1, nSaveNth;
	object oSaveTarget;
    while (GetIsObjectValid(oTarget)
           && GetAssociateState(NW_ASC_MODE_DYING, oTarget))
    {
        nNth++;
        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
    }
	
	// if target is a familiar, keep looking
	if (GetIsObjectValid(oTarget) && GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR)
	{
		oSaveTarget = oTarget;
		nSaveNth = nNth;
        nNth++;
		oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
	    while ((GetIsObjectValid(oTarget)
	           && GetAssociateState(NW_ASC_MODE_DYING, oTarget))
			   || (GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR))
	    {
	        nNth++;
	        oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
	    }
	
		// if couldn't find a non-familiar to attack, then attack the familiar.
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = oSaveTarget;
			nNth = nSaveNth;
		}
	}

	//Warning - GetAssociateState is doing double duty here, making sure OBJECT_SELF is an associate and also making sure it is set to stand ground.
	//	This function is run for all creatures, not just associates.
	if (GetAssociateState(NW_ASC_MODE_DEFEND_MASTER)) // have associates w/ Defend Master stay in sight of Master		
	{
		object oMaster = GetCurrentMaster();
	    while (GetIsObjectValid(oTarget) && 
			((!GetIsInCombat(oTarget)) || GetAssociateState(NW_ASC_MODE_DYING, oTarget) || ((GetDistanceBetween(oMaster, oTarget) >= DEFEND_MASTER_MAX_TARGET_DISTANCE))))
	    {
       		nNth++;
       		oTarget = GetNearestPerceivedEnemy(OBJECT_SELF, nNth);
    	}
	}	
	
    return oTarget;
}


//:: Get CR Max for Talents
//
//    Determines the Spell CR to be used in the
//    given situation
//
//    BK: changed this. It returns the the max CR for
//    this particular scenario.
//
//    NOTE: Will apply to all creatures though it may
//    be necessary to limit it just for associates.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001

int GetCRMax()
{
    //int nCR;

    // * retrieves the combat difficulty that has been stored
    // * from being set in DetermineCombatRound
    //int nDiff =  GetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF");

    if  (NO_SMART == TRUE)
        return 20;
   else
       return GetLocalInt(OBJECT_SELF, VAR_NW_L_COMBATDIFF); // the max CR of any talent that is going to be used
}



//    Returns true if something that shouldn't
//    have happened, happens. Will abort this combat round.

int bkEvaluationSanityCheck(object oIntruder, float fFollow)
{
    // Pausanias: sanity check for various effects
    if (GetHasEffect(EFFECT_TYPE_PARALYZE) ||
        GetHasEffect(EFFECT_TYPE_STUNNED) ||
        GetHasEffect(EFFECT_TYPE_FRIGHTENED) ||
        GetHasEffect(EFFECT_TYPE_SLEEP) ||
        GetHasEffect(EFFECT_TYPE_DAZED))
        return TRUE;

    // * no point in seeing if intruder has same master if no valid intruder
    if (!GetIsObjectValid(oIntruder))
        return FALSE;

    // Pausanias sanity check: do not attack target
    // if you share the same master.
    object oMaster = GetMaster();
    int iHaveMaster = GetIsObjectValid(oMaster);
    if (iHaveMaster && GetMaster(oIntruder) == oMaster)
        return TRUE;

    return FALSE; //* COntinue on with DetermineCombatRound
}


/*
// ChazM 10/6/06 - split out from TalentFilter.  Refrained from calling it cmTalentSpellFilter() ;)
// Run a talent of type spell through a filter to make sure it's sensible.
// return a struct that specifies our final choice of talent and if it's valid
struct rValidTalent TalentSpellFilter(talent tUse, object oTarget)
{
    talent tFinal = tUse;
	object oFinalTarget = oTarget;
	
    int iId = GetIdFromTalent(tUse);
    int iAmDone = FALSE;
    int nNotValid = FALSE;

    int nTargetRacialType = GetRacialType(oTarget);

	// Check for undead!
	
    if (nTargetRacialType == RACIAL_TYPE_UNDEAD)
    {
		//SpawnScriptDebugger();
		
        // DO NOT USE SILLY HARM ON THEM; substitute a heal spell if possible
        if (MatchInflictTouchAttack(iId) || MatchMindAffectingSpells(iId))
        {
			
            talent tTemp =
                GetCreatureTalentBestStd(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH,20);
            if (GetIsTalentValid(tTemp)
                && GetIdFromTalent(tTemp) == SPELL_HEAL
                && GetChallengeRating(oTarget) > 8.0)
            {
                tFinal = tTemp;
                iAmDone = TRUE;
            }  else
            {
                nNotValid = TRUE;
            }
        }

    }

    // *
    // * Don't use drown against nonliving opponents
    if (iId == SPELL_DROWN && !iAmDone)
    {
        if (MatchNonliving(nTargetRacialType) == TRUE)
        {
           nNotValid = TRUE;
           iAmDone = TRUE;
           DecrementRemainingSpellUses(OBJECT_SELF, SPELL_DROWN);
        }

    }
	
	//Straight up immunity check, skipped on self-buff spells
	if (OBJECT_SELF!=oTarget) //ignore immunity for buffs
		//if (SpellFilterHasImmunity(oTarget, iId) && !iAmDone)
		if (IsTargetImmuneToSpell(iId, oTarget) && !iAmDone)		
		{
			nNotValid = TRUE;
			iAmDone= TRUE;	
		}
	
	//Don't cast 'keen edge' on bludgeoning weapons 
	if (!iAmDone && (iId == SPELL_KEEN_EDGE))
	{
		int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
		if ((nWeaponType == WEAPON_TYPE_BLUDGEONING)||(nWeaponType == WEAPON_TYPE_NONE))
		{
	        DecrementRemainingSpellUses(OBJECT_SELF, iId); //these should be removed when we can iterate through talents
			nNotValid=TRUE;
			iAmDone=TRUE;
		}
	}
	
	//Don't cast 'weapon of impact' on anything but bludgeoning weapons
	if (!iAmDone && (iId == SPELL_WEAPON_OF_IMPACT))
	{
		int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
		if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
		{
	        DecrementRemainingSpellUses(OBJECT_SELF, iId);//these should be removed when we can iterate through talents
			nNotValid=TRUE;
			iAmDone=TRUE;
		}
	}
		
		
    // * August 2003
    // * If casting certain spells that should not harm creatures
    // * who are immune to losing levels, try another
    if (!iAmDone && iId == SPELL_ENERGY_DRAIN && GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL))
    {
        nNotValid = TRUE;
        DecrementRemainingSpellUses(OBJECT_SELF, iId);
        iAmDone = TRUE;
    }

// JLR - OEI 07/11/05 -- Removed
    // * Negative damage does nothing to undead or constructs. Don't use it.
    if (!iAmDone && (iId == SPELL_NEGATIVE_ENERGY_BURST || iId == SPELL_NEGATIVE_ENERGY_RAY) && nTargetRacialType == RACIAL_TYPE_CONSTRUCT)
    {
        nNotValid = TRUE;
        DecrementRemainingSpellUses(OBJECT_SELF, iId);
        iAmDone = TRUE;
    }

    // Check if the sleep spell is being used appropriately.
    if (iId == SPELL_SLEEP && !iAmDone)
    {
        if (GetHitDice(oTarget) > 4)
        {
            nNotValid = TRUE;
            iAmDone = TRUE;
            DecrementRemainingSpellUses(OBJECT_SELF, SPELL_SLEEP);
        }

        // * elves and half-elves are immune to sleep
        switch (nTargetRacialType)
        {
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_HALFELF:
          nNotValid = TRUE;
          iAmDone = TRUE;
          DecrementRemainingSpellUses(OBJECT_SELF, SPELL_SLEEP);
          break;
        }

    }

    // * Check: (Dec 19 2002) Don't waste Power Word Kill
    // on Targets with more than 100hp
    if (iId == SPELL_POWER_WORD_KILL && !iAmDone)
    {
        if (GetCurrentHitPoints(oTarget) > 100)
        {
            nNotValid = TRUE;
            iAmDone = TRUE;
            // * remove the spell, so the caster doesn't get stuck
            // * trying to use it.
            DecrementRemainingSpellUses(OBJECT_SELF, iId);

            // * Since planning on doing a harmful ranged, try another one
            talent tUse = GetCreatureTalentBestStd(TALENT_CATEGORY_HARMFUL_RANGED, 20);
            if(GetIsTalentValid(tUse))
            {
                nNotValid = FALSE;
            }
            else
            {
             DecrementRemainingSpellUses(OBJECT_SELF, SPELL_POWER_WORD_KILL);
            }
        }
    }

    // Check if person spells are being used appropriately.

    if (MatchPersonSpells(iId) && !iAmDone)
        switch (nTargetRacialType)
        {
            case RACIAL_TYPE_ELF:
            case RACIAL_TYPE_HALFELF:
            case RACIAL_TYPE_DWARF:
            case RACIAL_TYPE_HUMAN:
            case RACIAL_TYPE_HALFLING:
            case RACIAL_TYPE_HALFORC:
            case RACIAL_TYPE_GNOME: iAmDone = TRUE; DecrementRemainingSpellUses(OBJECT_SELF, iId); break;

            default: nNotValid = TRUE; break;
        }

    // Do a final check for mind affecting spells.
    if (MatchMindAffectingSpells(iId) && !iAmDone)
	{
        if (GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS))
        {
            nNotValid = TRUE;
            DecrementRemainingSpellUses(OBJECT_SELF, iId);
		}
	}
	
    // *
    // * STAY STILL!!  (return condition)
    // * September 5 2003
    // *
    // * In certain cases (i.e., the spell Meteor Swarm) the caster should not move
    // * towards his target if the target is within range. In this caster the caster should just
    // * cast the spell centered around himself
    if (iId == SPELL_METEOR_SWARM || iId == SPELL_FIRE_STORM || iId == SPELL_STORM_OF_VENGEANCE)
    {
        if (GetDistanceToObject(oTarget) <= 10.5)
        {
            //ActionUseTalentAtLocation(tFinal, GetLocation(OBJECT_SELF));
            //return TRUE;
        }
        else
        {
            ActionMoveToObject(oTarget, TRUE, 9.0);
            //ActionUseTalentAtLocation(tFinal, GetLocation(OBJECT_SELF));
            //return TRUE;
        }
		oFinalTarget = OBJECT_SELF; // change target to self.
    }
	
	struct rValidTalent oRet;
	
	oRet.tTalent = tFinal;
	oRet.bValid = !nNotValid;
	oRet.oTarget = oFinalTarget;
	return (oRet);
}
*/

//    This function is the last minute filter to prevent
//    any inappropriate effects from being applied
//    to inapproprite creatures.
//
//    Returns TRUE if the talent was valid, FALSE otherwise.
//
//    If an invalid talent is attempted, we instead perform
//    a standard melee attack to avoid AI stopping.
//
// MODIFIED JULY 11 2003 (BK):
//      - If I cannot use this particular ability
//        then in *most* cases I will delete the spell
//        from my list so I do not try to use it again.
//        This will help to prevent the "wizard just attacking"
//        when the spell they most want to use is ineffective.
// Based on Pausanias's Final Talent Filter.
/*
int TalentFilter(talent tUse, object oTarget, int bJustTest=FALSE)
{
	int iType = GetTypeFromTalent(tUse);
    int bValid = TRUE;

	if (bJustTest == FALSE)
		ClearActions(CLEAR_X0_INC_GENERIC_TalentFilter);

	bkEquipAppropriateWeapons(oTarget, GetAssociateState(NW_ASC_USE_RANGED_WEAPON));

    
	switch (iType)
	{
		case TALENT_TYPE_SPELL:
		{
			struct rValidTalent oTalent = TalentSpellFilter(tUse, oTarget);
			tUse = oTalent.tTalent;
			bValid = oTalent.bValid;
			oTarget = oTalent.oTarget;
			break;
		}	
		case TALENT_TYPE_FEAT:
	        //MyPrintString("Using feat: " + IntToString(iId));
	        if (VerifyCombatMeleeTalent(tUse, oTarget)
	            && VerifyDisarm(tUse, oTarget))
	        {
	            //MyPrintString("combat melee & disarm OK");
	            bValid = FALSE;
	        }
			break;
			
		case TALENT_TYPE_SKILL:
			break;
	}


    // * BK: My talent was not appropriate to use
    // *     will attack this round instead
    if (!bValid)
    {
        //MyPrintString("Invalid talent, id: " + IntToString(iId)
        //              + ", type: " + IntToString(GetTypeFromTalent(tUse)));

        if (bJustTest == FALSE)
          WrapperActionAttack(oTarget);
    }
    else
    {
        if (bJustTest == FALSE)
		{
			//if (bUseLocation)
            //	ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
			//else				
        		ActionUseTalentOnObject(tUse, oTarget);
		}
    }

    return (bValid);
}
*/

// reroute to EvenTalentFilter()
int TalentFilter(talent tUse, object oTarget, int bJustTest=FALSE)
{
	return(EvenTalentFilter(tUse, oTarget, bJustTest));
}


//  Gets the local int off of the character
//  determining what the Last Spell Cast was.
//
//  Sets the local int on of the character
//  storing what the Last Spell Cast was.
//
//  Compares whether the local is the same as the
//  currently selected spell.
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002

int GetLastGenericSpellCast()
{
    return GetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL");
}

void SetLastGenericSpellCast(int nSpell)
{
    SetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL", nSpell);
    // February 2003. Needed to add a way for this to reset itself, so that
    // spell might indeed be atempted later.
    DelayCommand(8.0,SetLocalInt(OBJECT_SELF, "NW_GENERIC_LAST_SPELL", -1));
}

int CompareLastSpellCast(int nSpell)
{
    int nLastSpell = GetLastGenericSpellCast();
    if(nSpell == nLastSpell)
    {
        return TRUE;
        SetLastGenericSpellCast(-1);
    }
    return FALSE;
}


//  Checks if the passed object has an Attempted
//  Attack or Spell Target
//  Created By: Preston Watamaniuk
//  Created On: March 13, 2002
int GetIsFighting(object oFighting)
{
    object oAttack = GetAttemptedAttackTarget();
    object oSpellTarget = GetAttemptedSpellTarget();

    if(GetIsObjectValid(oAttack) || GetIsObjectValid(oSpellTarget))
    {
        return TRUE;
    }
    return FALSE;
}

//-----------------------------------
//- EvenFlw new/modified functions
//-----------------------------------

talent SilenceCheck(talent tUse) 
{
	if(GetIsTalentValid(tUse) && GetTypeFromTalent(tUse)==TALENT_TYPE_SPELL) {
		talent alt;
		if(GetHasEffect(EFFECT_TYPE_SILENCE)) {
			return alt;
		}
	}
	return tUse;
}

talent EvenGetCreatureTalent(int nCategory, int nCRMax, int bRandom, int CheckSilence=FALSE) 
{
	talent tUse;
	if(!bRandom) {
		tUse=GetCreatureTalentBestStd(nCategory, nCRMax);
		if(CheckSilence)
			return SilenceCheck(tUse);
		return tUse;
	}
	tUse=GetCreatureTalentRandomStd(nCategory);
	int CR=0, count=0, castingmode=0, play=4;
	if(GetAssociateState(NW_ASC_POWER_CASTING)) castingmode=2;
	else if(GetAssociateState(NW_ASC_SCALED_CASTING)) castingmode=3;
	while(!CR && count<6 && GetIsTalentValid(tUse)) {
		if(GetTypeFromTalent(tUse)!=TALENT_TYPE_SPELL) {
			return tUse;
		}
		CR=GetSpellLevel(GetIdFromTalent(tUse))*2;
		if(CR<nCRMax-play) CR=0;
		if(castingmode && CR>nCRMax+play) CR=0;
		count++;
		play+=d2();
		if(!CR) tUse=GetCreatureTalentRandomStd(nCategory);
	}
	if(CR) {
		if(CheckSilence)
			return SilenceCheck(tUse);
		return tUse;
	}
	tUse=GetCreatureTalent(nCategory, nCRMax, bRandom);
	if(CheckSilence)
		return SilenceCheck(tUse);
	return tUse;
}

// not currently used
/*
int CheckConfused() 
{
	if(!GetIsOwnedByPlayer(OBJECT_SELF) && !GetIsRosterMember(OBJECT_SELF)) {
		SetLocalInt(OBJECT_SELF, EVENFLW_AI_CONFUSED, 1);
		return TRUE;
	}
    effect eff=GetFirstEffect(OBJECT_SELF);
	while(GetIsEffectValid(eff)) {
		if(GetEffectType(eff)==EFFECT_TYPE_CONFUSED
		|| GetEffectType(eff)==EFFECT_TYPE_CHARMED
		|| GetEffectType(eff)==EFFECT_TYPE_DOMINATED) {
			SetLocalInt(OBJECT_SELF, EVENFLW_AI_CONFUSED, 1);
			return TRUE;
		}
		eff=GetNextEffect(OBJECT_SELF);	
	}
	DeleteLocalInt(OBJECT_SELF, EVENFLW_AI_CONFUSED);
	return FALSE;
}

int ValidTarget(object oTarget) 
{
	if (GetIsObjectValid(oTarget) 
		&& oTarget!=OBJECT_SELF 
		&& GetIsEnemy(oTarget) 
		&& (!GetFactionEqual(OBJECT_SELF, oTarget) || GetLocalInt(OBJECT_SELF, EVENFLW_AI_CONFUSED)) 
		&& !GetAssociateState(NW_ASC_MODE_DYING, oTarget) 
		&& !GetPlotFlag(oTarget) 
		&& GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
		return TRUE;
	return FALSE;
}
*/

// Using a long list of "if's" because it's much easer to work with in the script debugger.
int ValidTarget(object oTarget) 
{
	if (GetIsObjectValid(oTarget)) 
		if (oTarget!=OBJECT_SELF)
			if (GetIsEnemy(oTarget))
				if (!GetFactionEqual(OBJECT_SELF, oTarget) || GetLocalInt(OBJECT_SELF, EVENFLW_AI_CONFUSED)) 
					if (!GetAssociateState(NW_ASC_MODE_DYING, oTarget))
						//if (GetPlotFlag(oTarget) == FALSE)
							if (GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
								return TRUE;
								
	return FALSE;
}


// Returns TRUE if oSelf is hidden either
// magically or via stealth
int InvisibleTrue(object oSelf=OBJECT_SELF)
{
	object oTarget;
	if(GetHasEffect(EFFECT_TYPE_SANCTUARY, oSelf) || GetHasEffect(EFFECT_TYPE_ETHEREAL, oSelf))
		return TRUE;
    if(GetLocalInt(oSelf, EVENFLW_AI_CLOSE)) return -1;
    if(GetActionMode(oSelf, ACTION_MODE_STEALTH)==TRUE)
        return TRUE;
    if(GetHasEffect(EFFECT_TYPE_INVISIBILITY, oSelf) || GetHasEffect(EFFECT_TYPE_GREATERINVISIBILITY, oSelf)
            || GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oSelf))
    {
		return TRUE;
    }
	if(GetHasSpellEffect(SPELL_DARKNESS, oSelf)) return 2;
    return FALSE;
}


int WrongAlign(object oTarget) 
{
    int align=GetAlignmentGoodEvil(OBJECT_SELF);
    int ethos=GetAlignmentLawChaos(OBJECT_SELF);
    if(align==ALIGNMENT_GOOD && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_GOOD ||
        align==ALIGNMENT_EVIL && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL ||
        align==ALIGNMENT_NEUTRAL && ethos==ALIGNMENT_LAWFUL && GetAlignmentLawChaos(oTarget)==ALIGNMENT_LAWFUL ||
        align==ALIGNMENT_NEUTRAL && ethos==ALIGNMENT_CHAOTIC && GetAlignmentLawChaos(oTarget)==ALIGNMENT_CHAOTIC ||
        ethos==ALIGNMENT_NEUTRAL && align==ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_NEUTRAL)
      return TRUE;
    return FALSE;
}

// Determine whether or not we think the spell to be cast will be effective.
int IsSpellEffectiveAgainstTarget(int iId, object oTarget)
{
	int iRet = TRUE;	
    int nTargetRacialType = GetRacialType(oTarget);

	// everyone knows these
	if ((iId==SPELL_DOMINATE_ANIMAL || iId==SPELL_HOLD_ANIMAL) && nTargetRacialType!=RACIAL_TYPE_ANIMAL  
		|| iId==SPELL_CRUMBLE && nTargetRacialType!=RACIAL_TYPE_CONSTRUCT 
		|| iId==SPELL_CONTROL_UNDEAD && (GetHitDice(oTarget) >  GetCasterLevel(OBJECT_SELF)*2 || nTargetRacialType != RACIAL_TYPE_UNDEAD) 
		|| iId==SPELL_UNDEATH_TO_DEATH && (GetHitDice(oTarget)>8 || nTargetRacialType != RACIAL_TYPE_UNDEAD) 
		|| (iId == SPELL_DROWN || iId==SPELL_FLESH_TO_STONE) && MatchNonliving(nTargetRacialType) == TRUE 
		|| iId == SPELL_SLEEP && (GetHitDice(oTarget) > 4 || nTargetRacialType==RACIAL_TYPE_ELF || nTargetRacialType==RACIAL_TYPE_HALFELF) 
		)		
	{
		iRet = FALSE;	
	}
	
	// only special people will identify these immunities - people like party members!
	if (GetIsPC(GetFactionLeader(OBJECT_SELF)))
	{ 
		if (( (iId==SPELL_HAMMER_OF_THE_GODS && d4()==1 || iId==SPELL_WORD_OF_FAITH) && WrongAlign(oTarget)) // can't tell alignment by looking
			|| (iId==SPELL_WORD_OF_FAITH && GetHitDice(oTarget)>GetLevelByClass(CLASS_TYPE_CLERIC)) 
			|| iId == SPELL_ENERGY_DRAIN && GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL) 
			|| iId == SPELL_POWER_WORD_KILL && GetCurrentHitPoints(oTarget) > 100 
			|| (iId == SPELL_ENTANGLE || iId==SPELL_WEB) && (GetIsImmune(oTarget, IMMUNITY_TYPE_ENTANGLE) || GetLevelByClass(CLASS_TYPE_DRUID, oTarget)>1) // immunity won't be so obvious at fir
			|| (iId==SPELL_GREASE || iId==SPELL_SPIKE_GROWTH) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget)>1
			)
		{
			iRet = FALSE;	
		}
		
		//if we have a troll that is very low on health
		if(GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED) == "gb_troll_dmg" && GetCurrentHitPoints(oTarget) <= 10)
		{
			// if the spell immunity type is flame or acid, cast it
			if( GetSpellImmunityType(iId) == -2 || GetSpellImmunityType(iId) == -3)
			{
				iRet = TRUE;
			}	
			// otherwise don't waste the spell
			else
			{
				iRet = FALSE;
			}
		}
	}		
	return (iRet);
}


// GetSpellImmunityType() returns one of these values:
// int IMMUNITY_TYPE_NONE              = 0;
// int IMMUNITY_TYPE_MIND_SPELLS       = 1;
// int IMMUNITY_TYPE_POISON            = 2;
// int IMMUNITY_TYPE_DISEASE           = 3;
// int IMMUNITY_TYPE_FEAR              = 4;
// int IMMUNITY_TYPE_TRAP              = 5;
// int IMMUNITY_TYPE_PARALYSIS         = 6;
// int IMMUNITY_TYPE_BLINDNESS         = 7;
// int IMMUNITY_TYPE_DEAFNESS          = 8;
// int IMMUNITY_TYPE_SLOW              = 9;
// int IMMUNITY_TYPE_ENTANGLE          = 10;
// int IMMUNITY_TYPE_SILENCE           = 11;
// int IMMUNITY_TYPE_STUN              = 12;
// int IMMUNITY_TYPE_SLEEP             = 13;
// int IMMUNITY_TYPE_CHARM             = 14;
// int IMMUNITY_TYPE_DOMINATE          = 15;
// int IMMUNITY_TYPE_CONFUSED          = 16;
// int IMMUNITY_TYPE_CURSED            = 17;
// int IMMUNITY_TYPE_DAZED             = 18;
// int IMMUNITY_TYPE_ABILITY_DECREASE  = 19;
// int IMMUNITY_TYPE_ATTACK_DECREASE   = 20;
// int IMMUNITY_TYPE_DAMAGE_DECREASE   = 21;
// int IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE = 22;
// int IMMUNITY_TYPE_AC_DECREASE       = 23;
// int IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE = 24;
// int IMMUNITY_TYPE_SAVING_THROW_DECREASE = 25;
// int IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE = 26;
// int IMMUNITY_TYPE_SKILL_DECREASE    = 27;
// int IMMUNITY_TYPE_KNOCKDOWN         = 28;
// int IMMUNITY_TYPE_NEGATIVE_LEVEL    = 29;
// int IMMUNITY_TYPE_SNEAK_ATTACK      = 30;
// int IMMUNITY_TYPE_CRITICAL_HIT      = 31;
// int IMMUNITY_TYPE_DEATH             = 32;
// new "made up" immunity types that don't exist in NWSCRIPT but are used in spells.2da.
int FAKE_IMMUNITY_TYPE_DIVINE			= -1; 
int FAKE_IMMUNITY_TYPE_ACID				= -2; 
int FAKE_IMMUNITY_TYPE_FIRE				= -3; 
int FAKE_IMMUNITY_TYPE_ELECTRICITY		= -4; 
int FAKE_IMMUNITY_TYPE_COLD				= -5; 
int FAKE_IMMUNITY_TYPE_SONIC			= -6; 
int FAKE_IMMUNITY_TYPE_NEGATIVE			= -7; // Spell Immunity that apply solely to "NegativeImmune" Races.
int FAKE_IMMUNITY_TYPE_POSITIVE			= -8; 
int FAKE_IMMUNITY_TYPE_NON_SPIRIT		= -9; 

int ConvertImmunityStringToType (string sImmunityType)
{
	int nRet = 0;
	if (sImmunityType == "")										nRet = IMMUNITY_TYPE_NONE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_MIND_AFFECTING)	nRet = IMMUNITY_TYPE_MIND_SPELLS;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_DEATH)			nRet = IMMUNITY_TYPE_DEATH;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_POISON)			nRet = IMMUNITY_TYPE_POISON;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_DISEASE)			nRet = IMMUNITY_TYPE_DISEASE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_FEAR)				nRet = IMMUNITY_TYPE_FEAR;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_ABILITY_DECREASE)	nRet = IMMUNITY_TYPE_ABILITY_DECREASE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_DIVINE)			nRet = FAKE_IMMUNITY_TYPE_DIVINE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_ACID)				nRet = FAKE_IMMUNITY_TYPE_ACID;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_FIRE)				nRet = FAKE_IMMUNITY_TYPE_FIRE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_ELECTRICITY)		nRet = FAKE_IMMUNITY_TYPE_ELECTRICITY;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_COLD)				nRet = FAKE_IMMUNITY_TYPE_COLD;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_SONIC)			nRet = FAKE_IMMUNITY_TYPE_SONIC;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_NEGATIVE)			nRet = FAKE_IMMUNITY_TYPE_NEGATIVE;
	else if (sImmunityType == SPELLS_2DA_IMMUNITY_POSITIVE)			nRet = FAKE_IMMUNITY_TYPE_POSITIVE;
	else if (sImmunityType == FEATS_2DA_IMMUNITY_NON_SPIRIT)		nRet = FAKE_IMMUNITY_TYPE_NON_SPIRIT;
	else if (sImmunityType == FEATS_2DA_IMMUNITY_KNOCKDOWN)			nRet = IMMUNITY_TYPE_KNOCKDOWN;
	
	return (nRet);                                                   
}		


int IsNegativeImmuneRace(object oTarget)
{
	int iRet = FALSE;
    int nRacialType = GetRacialType(oTarget);
	if (nRacialType == RACIAL_TYPE_UNDEAD 
		|| nRacialType==RACIAL_TYPE_CONSTRUCT 
		|| GetSubRace(oTarget)==RACIAL_SUBTYPE_CONSTRUCT)
		iRet = TRUE;
	return (iRet);
}		  

int IsNegativeImmune(int nImmunityType)
{
	int nRet = FALSE;
	if (nImmunityType == IMMUNITY_TYPE_MIND_SPELLS
		|| nImmunityType == IMMUNITY_TYPE_DEATH
		|| nImmunityType == IMMUNITY_TYPE_POISON
		|| nImmunityType == IMMUNITY_TYPE_DISEASE
		|| nImmunityType == IMMUNITY_TYPE_FEAR 			
		|| nImmunityType == FAKE_IMMUNITY_TYPE_NEGATIVE
		|| nImmunityType == IMMUNITY_TYPE_ABILITY_DECREASE)
		nRet = TRUE;		
	return (nRet);
}

int IsElementalRace(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);
	return (nRacialType==RACIAL_TYPE_ELEMENTAL);
}

int IsElementalImmune(int nImmunityType)
{
	int nRet = FALSE;
	if (nImmunityType == IMMUNITY_TYPE_MIND_SPELLS
		|| nImmunityType == IMMUNITY_TYPE_POISON
		|| nImmunityType == IMMUNITY_TYPE_DISEASE)
		nRet = TRUE;		
	return (nRet);
}


int HasRacialImmunity(object oTarget, int nImmunityType)
{
	int nRet = FALSE;
	if (IsNegativeImmuneRace(oTarget) && IsNegativeImmune(nImmunityType))
	{
		nRet = TRUE;
	}
	else if (IsElementalRace(oTarget) && IsElementalImmune(nImmunityType))
	{
		nRet = TRUE;
	}
	
	return (nRet);	
}

int IsTargetImmune(int nImmunityType, object oTarget)
{
	object oSelf = OBJECT_SELF;

	if (nImmunityType == IMMUNITY_TYPE_NONE)
		return (FALSE);

	// is target a race that should have special immunities (even though they may not actually be applied)
	if (HasRacialImmunity(oTarget, nImmunityType))	
	{
		return(TRUE);
	}	
	
	// if the immunity type is Non_Spirit we want to make sure we don't have a non spirit
	if(nImmunityType == FAKE_IMMUNITY_TYPE_NON_SPIRIT && !GetIsSpirit(oTarget))
	{
		return(TRUE);
	}
	
	// *** PARTY MEMBERS ONLY PAST HERE ***
	// only party members will figure out additional kinds of immunities beyond this point.
	int bPartyMember = GetIsRosterMember(oSelf) || GetIsOwnedByPlayer(oSelf);
	if (!bPartyMember)
	{
		return(FALSE);
	}		
	
	// does target have an immunity?
	// Note: this won't check the "fake" immunities types (negative values)
	if ((nImmunityType>0) && GetIsImmune(oTarget, nImmunityType, oSelf))
	{
		return(TRUE);
	} 

	// special exceptions 
	if (nImmunityType == IMMUNITY_TYPE_FEAR)
	{
		// note: spells + death immunity checked in IsTargetImmuneToSpell()
		//if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oSelf)
	    //	|| (nSpellId==SPELL_WEIRD || nSpellId==SPELL_PHANTASMAL_KILLER) 
		//		&& GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, oSelf) ) 	
		
		// mind spell immunity also gives fear immunity
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oSelf))
		{
			return(TRUE);
		}				
	}

	return (FALSE);
}

// Immunity Type in the spells 2da is given by string.            
int GetSpellImmunityType (int nSpellId)
{
	string sImmunityType = Get2DAString(SPELLS_2DA, SPELLS_IMMUNITY_TYPE_COL, nSpellId);
	int nImmunityType = ConvertImmunityStringToType(sImmunityType);
	
	return (nImmunityType);
}		

int IsTargetImmuneToSpell(int nSpellId, object oTarget)
{
	object oSelf = OBJECT_SELF;

	int nImmunityType = GetSpellImmunityType(nSpellId);
	int bRet = IsTargetImmune(nImmunityType, oTarget);
	
	// special exceptions 
	if (nImmunityType == IMMUNITY_TYPE_FEAR)
	{
		// 2 spells check death immunity even though fear is the immunity type.
	    if ((nSpellId==SPELL_WEIRD || nSpellId==SPELL_PHANTASMAL_KILLER) 
			&& GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, oSelf) ) 	
		{
			return(TRUE);
		}				
	}

	
	return (bRet);
}	

// for use on enemies, because some(dragons, dryads,others) have no caster classes, but have spells as special abilities
int HasHarmfulSpell(object oTarget)
{
	int bHarmfulSpell = FALSE;
	
	if(	GetIsTalentValid(GetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, oTarget))
		|| GetIsTalentValid(GetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_RANGED , oTarget))
		|| GetIsTalentValid(GetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_TOUCH, oTarget))
		|| GetIsTalentValid(GetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, oTarget))
	  )
				bHarmfulSpell = TRUE;
		
	return bHarmfulSpell;
}

// for allies, because they all have valid classes with spells
int HasCasterLevels(object oTarget)
{
	int bCaster = FALSE;
	if(	GetLevelByClass(CLASS_TYPE_BARD, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_CLERIC, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_RANGER, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_WARLOCK, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) > 1
	  )
				bCaster = TRUE;
		
	return bCaster;
}

int IsSafeToUseSilence(object oTarget)
{
	location lTarget 	= GetLocation(oTarget);
	int nTotalEnemies;
	int nEnemyCasters;
	int nAllyCasters;
	float fPercentCasters;
	int bSafeToUse = TRUE;
	
	// go through all objects in a shape sized similar to silence aoe
	object oTemp		= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	while(GetIsObjectValid(oTemp))
	{
		// never ok to silence yourself
		if(OBJECT_SELF == oTemp)
			return FALSE;
		// never ok to silence a pc
		if(GetIsPC(oTemp))
			return FALSE;
		// if an enemy
		if(GetIsEnemy(oTarget))
		{	
			// increase enemy count
			nTotalEnemies++;
			// if they have harmful spells
			if(HasHarmfulSpell(oTemp))
				// increse count of enemy caster
				nEnemyCasters++;
		}
		// if an ally
		else 
		{
			// check to see if they have any levels in the main spell casting classes
			if(HasCasterLevels(oTemp))
				// if true then increase ally caster count
				nAllyCasters++;
		}
		oTemp = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	}
	PrettyDebug("Total Enemies: " + IntToString(nTotalEnemies));
	PrettyDebug("Total Enemy Casters: " + IntToString(nEnemyCasters));
	PrettyDebug("Total Ally Casters: " + IntToString(nAllyCasters));
	// calculate percentage of enemy casters to total enemies
	fPercentCasters = IntToFloat(nEnemyCasters) / IntToFloat(nTotalEnemies);
	PrettyDebug("Percentage of Enemy Casters: " + FloatToString(fPercentCasters));
	// if you have more ally casters than enemy casters in the area do not cast spell
	if (nAllyCasters > nEnemyCasters)
		bSafeToUse = FALSE;
	// if there are any allies casters in the area and a small percentage of enemies are caster, do not cast spell
	if ((nAllyCasters > 0) && (fPercentCasters <= 0.25))
		bSafeToUse = FALSE;
	// if there are no casters in the areas don't cast the spell
	if (nEnemyCasters == 0)
		bSafeToUse = FALSE;
	// otherwise it is ok
	return bSafeToUse;
}

//int TalentFeatCheck(talent tUse, object oTarget)
int TalentFeatFilter(talent tUse, object oTarget)
{
	int iId = GetIdFromTalent(tUse);
	if(GetHasFeatEffect(iId, oTarget))
	{
		return FALSE;
	}
	else if(IsTargetImmuneToFeat(iId, oTarget))
	{
		return FALSE;
	}
	return TRUE;
} 

int EvenTalentCheck(talent tUse, object oTarget)
{
    if(!GetIsTalentValid(tUse)) 
		return FALSE;
		
    int iId = GetIdFromTalent(tUse);
    int nTalentType=GetTypeFromTalent(tUse);

    //if(nTalentType == TALENT_TYPE_FEAT) 
	//{
	//	return (TalentFeatCheck(tUse, oTarget));
	//}
	
    if(nTalentType == TALENT_TYPE_SPELL) 
	{
		if(GetIsEnemy(oTarget)) 
		{
			if(GetSpellLevel(iId)==0) 
				return FALSE;
			int level=0;
			int spellcraft;
			if(GetGameDifficulty()>=GAME_DIFFICULTY_DIFFICULT) 
				spellcraft=40;
			else 
				spellcraft=GetSkillRank(SKILL_SPELLCRAFT)+d20();
				
			if(GetGameDifficulty()==GAME_DIFFICULTY_CORE_RULES) 
				spellcraft+=5;
				
			if(spellcraft>=11 && iId==SPELL_MAGIC_MISSILE && GetHasSpellEffect(SPELL_SHIELD, oTarget)) 
				return FALSE;
			else if(spellcraft>=16 && GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget)) 
				level=4;
			else if(spellcraft>=14 && GetHasSpellEffect(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oTarget)) 
				level=3;
			else if(spellcraft>=16 && GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget)) 
				level=2;
			else if(spellcraft>=12 && GetHasSpellEffect(SPELL_GHOSTLY_VISAGE, oTarget)) 
				level=1;
			if(level) 
			{
				if(GetSpellLevel(iId)<=level)
			 		return FALSE;
			}
			int nTargetRacialType = GetRacialType(oTarget);
			
			if(iId==SPELL_CONTROL_UNDEAD || iId==SPELL_UNDEATH_TO_DEATH) 
			{
				if(nTargetRacialType != RACIAL_TYPE_UNDEAD)
			 		return FALSE;
			} 
			else 
			{
				int chance		= GetHitDice(OBJECT_SELF)+d20();
				int negimmune 	= nTargetRacialType==RACIAL_TYPE_UNDEAD ||
								  nTargetRacialType==RACIAL_TYPE_CONSTRUCT || 
								  GetSubRace(oTarget)==RACIAL_SUBTYPE_CONSTRUCT;
								
				int iselem		= nTargetRacialType==RACIAL_TYPE_ELEMENTAL;
				if(negimmune || iselem) 
					chance=20;
				if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES) 
					chance+=5;
				if(GetIsEnemy(oTarget, OBJECT_SELF) && chance>15) 
				{
					if (IsTargetImmuneToSpell(iId, oTarget))
						return FALSE;
				}
			}
			if (!IsSpellEffectiveAgainstTarget( iId, oTarget))
				return FALSE;
			
			if (MatchPersonSpells(iId) && !MatchHumanoidRacialType(nTargetRacialType))
				return FALSE;
			
			if (iId>=SPELL_BIGBYS_FORCEFUL_HAND && iId<=SPELL_BIGBYS_CRUSHING_HAND)
				if (GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTarget))
					return FALSE;
		}// end if(GetIsEnemy(oTarget))
		
		if ((iId == SPELL_KEEN_EDGE)) 
		{
			int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
			if ((nWeaponType == WEAPON_TYPE_BLUDGEONING)||(nWeaponType == WEAPON_TYPE_NONE))
			{
				return FALSE;
			}
		}
		
		if ((iId == SPELL_WEAPON_OF_IMPACT)) 
		{
			int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
			if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
			{
				return FALSE;
			}
		}
		
		if(iId==SPELL_FLAME_WEAPON) 
		{
			if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget)) ||
				GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget)))
				return FALSE;
		}	
		if(iId==SPELL_SILENCE)
		{
        	if(!IsSafeToUseSilence(oTarget)) 
			{
           		return FALSE;
        	}
		}
		
    } // end if(nTalentType == TALENT_TYPE_SPELL) 
	
    return TRUE;
}

int EvenTalentSpellFilter(talent tUse, object oTarget) 
{
    int iId = GetIdFromTalent(tUse);
	if (iId == SPELL_FIRE_STORM || iId == SPELL_STORM_OF_VENGEANCE) {
        if(GetDistanceToObject(oTarget) > 10.0)
        	ActionMoveToObject(oTarget, TRUE, 9.0);
    }
	else if(iId == SPELL_GREATER_FIREBURST) {
        if(GetDistanceToObject(oTarget) > 9.0)
        	ActionMoveToObject(oTarget, TRUE, 8.0);	
	}
	else if(iId == SPELL_FIREBURST) {
        if(GetDistanceToObject(oTarget) > 4.0)
        	ActionMoveToObject(oTarget, TRUE, 3.5);
	}
    else if(iId==SPELLABILITY_GAZE_PETRIFY)
	{
        if(GetDistanceToObject(oTarget)>10.0) 
		{
            ActionMoveToObject(oTarget, TRUE, 9.0);
        }
	}
		
	//if we cannot see that we are casting at
	if(!GetObjectSeen(oTarget))
	{	
		// get the category of spell
		string sSpellCategory = Get2DAString(SPELLS_2DA, "Category", iId);
		int iCategory = StringToInt(sSpellCategory);
		//if harmful don't cast move towards target
		if(	iCategory == TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT || 
			iCategory == TALENT_CATEGORY_HARMFUL_RANGED || 
			iCategory == TALENT_CATEGORY_HARMFUL_TOUCH  ||
			iCategory == TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT ||
			iCategory == TALENT_CATEGORY_HARMFUL_MELEE)
			{
				ActionMoveToObject(oTarget, TRUE, 4.0f);
			}
		// otherwise beneficial to us now so cast on self then hunt down target
		else 
		{
			object oDamager = GetLastHostileActor();
			ActionUseTalentOnObject(tUse, oTarget);
			ActionMoveToObject(oDamager, TRUE, 4.0f);
		}
		
	}
	//otherwise do what you have to
	else
	{
		ActionUseTalentOnObject(tUse, oTarget);
	}
	return TRUE;
}

int EvenTalentFilter(talent tUse, object oTarget, int bJustTest=FALSE)
{
	if(IsInConversation(oTarget)) 
		return FALSE;
	if(!GetIsTalentValid(tUse)) 
		return FALSE;
	if(bJustTest) 
		return EvenTalentCheck(tUse, oTarget);
		
	int iType=GetTypeFromTalent(tUse);
	ClearActions(CLEAR_X0_INC_GENERIC_TalentFilter);
	bkEquipAppropriateWeapons(oTarget, GetAssociateState(NW_ASC_USE_RANGED_WEAPON));
	switch (iType)
	{
		case TALENT_TYPE_SPELL:
		{
			return EvenTalentSpellFilter(tUse, oTarget);
		}
			
		case TALENT_TYPE_FEAT:
	        if (!VerifyCombatMeleeTalent(tUse, oTarget) || !VerifyDisarm(tUse, oTarget))
	        {
	            WrapperActionAttack(oTarget);
				return FALSE;
	        }
			else
			{	
				int bFeatOkToUse = TalentFeatFilter(tUse, oTarget);
				if(!bFeatOkToUse)
				{
					WrapperActionAttack(oTarget);
					return bFeatOkToUse;
				}
			}
			
			break;
			
		case TALENT_TYPE_SKILL:
			break;
	}
    ActionUseTalentOnObject(tUse, oTarget);
    return TRUE;
}

int GetFeatImmunityType (int nFeatId)
{
	string sImmunityType = Get2DAString(FEATS_2DA, FEATS_IMMUNITY_TYPE_COL, nFeatId);
	int nImmunityType = ConvertImmunityStringToType(sImmunityType);
	
	return (nImmunityType);
}

int IsTargetImmuneToFeat(int nFeatId, object oTarget)
{
	int nImmunityType = GetFeatImmunityType(nFeatId);
	int bRet = IsTargetImmune(nImmunityType, oTarget);
	return (bRet);
}



/* void main() {} /* */
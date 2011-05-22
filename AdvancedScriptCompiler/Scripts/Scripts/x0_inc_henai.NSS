//::///////////////////////////////////////////////
//:: x0_inc_HENAI
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a wrapper overtop of the 'generic AI'
    system with custom behavior for Henchmen.

    BENEFIT:
    - easier to isolate henchmen behavior
    - easier to debug COMBAT-AI because the
    advanced Henchmen behaviour won't be in those scripts

    CONS:
    - code duplicate. The two 'combat round' functions
    will share a lot of code because the old-AI still has
    to allow any legacy henchmen to work.


    NEW RADIALS/COMMANDS:
  - Open Inventory    "inventory"
  - Open Everything
  - Remove Traps [even nonthiefs will walk to detected traps]
  - NEVER FIGHT mode (or ALWAYS RETREAT) ; SetLocal; Implementation Code inside of DetermineCombatRound  DONE


    -=-=-=-=-=-=-
    MODIFICATIONS
    -=-=-=-=-=-=-

    // * BK Feb 6 2003
    // * Put a check in so that when a henchmen who cannot disarm a trap
    // * sees a trap they do not repeat their voiceover forever

*/
// Brian Fox 1/9/06 - Added PrettyDebug calls in bkRespondToHenchmenShout for testing...
// ChazM 1/16/06	modified bkRespondToHenchmenShout() for use with companions;
//					changed all references to GetMaster() to GetCurrentMaster()
// ChazM 5/17/06 modified GetCurrentMaster()
// ChazM 6/16/06 GetCurrentMaster() now return party leader for player owned characters.
// ChazM 6/27/06 modified GetCurrentMaster()
// BMA-OEI 7/08/06 -- Cleaned up HenchmenCombatRound(), modified bkRespondToHenchmenShout()
// ChazM 6/27/06 modified bkAttemptToDisarmTrap()
// BMA-OEI 7/17/06 -- Added GetIsDamagerABetterTarget(), modified HenchmenCombatRound() to ignore STAND_GROUND, select target
// BMA-OEI 7/18/06 -- HenchmenCombatRound: Clear Follow action before DCR
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// ChazM 8/29/06 Moved GetCurrentMaster() to X0_I0_ASSOC.  That file is included by the following chain of includes:
// 				x0_i0_henchman -> nw_i0_generic -> x0_i0_anims -> x0_i0_walkway -> x0_i0_spawncond ->
//				x0_i0_combat -> x0_i0_talent -> x0_inc_generic -> x0_i0_equip -> x0_i0_assoc
// ChazM 8/30/06 Modified HenchmenCombatRound() - tweaks; bkRespondToHenchmenShout() - modified automatic shouts
// ChazM 8/31/06 Modified bkAttemptToDisarmTrap() - no longer turn off commandability.
// BMA-OEI 9/13/06 -- Override oIntruder in HenchmenCombatRound(), clear played queued preferred target in bkRespondToHenchmenShout()
// BMA-OEI 9/20/06 -- bkRespondToHenchmenShout(): Added BK_VOICE_RESPOND_DELAY constant for VoiceChat
// BMA-OEI 10/16/06 -- bkRespondToHenchmenShout(): Added BK_FOLLOW_BUSY_DELAY constant for ASSOCIATE_COMMAND_FOLLOWMASTER
// ChazM 10/20/06 Familiars will no long respond to AttackNearest or GuardMe shouts.
// ChazM 10/20/06 Familiars will no long respond to MASTERUNDERATTACK, MASTERATTACKEDOTHER, or MASTERGOINGTOBEATTACKED shouts.
// BMA-OEI 10/20/06 -- HenchmenCombatRound(): Defend master against non-associates only
// DBR 11/03/06 --AttemptToDisarmTrap() - return FALSE if character cannot path to trap instead of assuming they don't have the skill.
// ChazM 2/27/07 - modified HenchmenCombatRound() - handle calls w/ intruder in same faction and intruder not an enemy.

// void main(){}

// #include "nw_i0_generic"  //...and through this also x0_inc_generic

#include "x0_i0_henchman"
#include "ginc_debug"
#include "ginc_companion"

// ****************************
// CONSTANTS
// ****************************

// ~ Behavior Constants
const int BK_HEALINMELEE = 10;
const int BK_CURRENT_AI_MODE = 20; // Can only be in one AI mode at a time
const int BK_AI_MODE_FOLLOW = 9; // default mode, moving after the player
const int BK_AI_MODE_RUN_AWAY = 19; // something is causing AI to retreat
const int BK_NEVERFIGHT = 30;

// ~ Delay Constants
const float BK_VOICE_RESPOND_DELAY = 2.0f; // VoiceChat delay for bkRespondToHenchmenShout()
const float BK_FOLLOW_BUSY_DELAY = 12.0f; // NW_ASC_IS_BUSY duration for ASSOCIATE_COMMAND_FOLLOWMASTER (increased from 5.0f)

// ~ Distance Constants
const float BK_HEALTHRESHOLD = 5.0f;
const float BK_FOLLOW_THRESHOLD= 15.0f;

// difficulty difference at which familiar will flee
//int BK_FAMILIAR_COWARD = 7;


/**********************************************************************
 * FUNCTION PROTOTYPES
 **********************************************************************/

 
// * Sets up special additional listening patterns
// * for associates.
void bkSetListeningPatterns();

// * Henchman/associate combat round wrapper
// * passing in OBJECT_INVALID is okay
// * Does special stuff for henchmen and familiars, then
// * falls back to default generic combat code.
void HenchmenCombatRound( object oIntruder=OBJECT_INVALID );

// * Attempt to disarm given trap
// * (called from RespondToShout and heartbeat)
int bkAttemptToDisarmTrap(object oTrap, int bWasShout = FALSE);

// * Attempt to open a given locked object.
int bkAttemptToOpenLock(object oLocked);

// * Manually pick the nearest locked object
int bkManualPickNearestLock();

// * Handles responses to henchmen commands, including both radial
// * menu and voice commands.
void bkRespondToHenchmenShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, int nBanInventory=FALSE);

// * Attempt to heal self then master
int bkCombatAttemptHeal();

// * Attempts to follow master if outside range
int bkCombatFollowMaster();

// * set behavior used by AI
void bkSetBehavior(int nBehavior, int nValue);

// * get behavior used by AI
int bkGetBehavior(int nBehavior);

// ****LINEOFSIGHT*****

// * TRUE if the target door is in line of sight.
int bkGetIsDoorInLineOfSight(object oTarget);

// Get the cosine of the angle between two objects.
float bkGetCosAngleBetween(object Loc1, object Loc2);

// TRUE if target in the line of sight of the seer.
int bkGetIsInLineOfSight(object oTarget, object oSeer=OBJECT_SELF);
// * called from state scripts (nw_g0_charm) to signal
// * to other party members to help me out
void SendForHelp();

// Determine whether to switch to new attacker
int GetIsDamagerABetterTarget( object oDamager, object oCurrentTarget );

/**********************************************************************
 * FUNCTION DEFINITIONS
 **********************************************************************/

 
// * called from state scripts (nw_g0_charm) to signal
// * to other party members to help me out
void SendForHelp()
{
    // Apr. 1/04 (not an April Fool's joke, sorry)
    // Make sure we are in a PC's party. NPC's won't use the event fired...
    if(!GetIsPC(GetFactionLeader(OBJECT_SELF)))
    {
        // Stop
        return;
    }

    // *
    // * September 2003
    // * Was this a disabling type spell
    // * Signal an event so that my party members
    // * can check to see if they can remove it for me
    // *
    object oParty = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while (GetIsObjectValid(oParty) == TRUE)
    {

        SignalEvent(oParty, EventUserDefined(46500));
        oParty = GetNextFactionMember(OBJECT_SELF, FALSE);
    }

}

// * Sets up any special listening patterns in addition to the default
// * associate ones that are used
void bkSetListeningPatterns()
{

    SetListening(OBJECT_SELF, TRUE);
    SetListenPattern(OBJECT_SELF, "inventory",101);
    SetListenPattern(OBJECT_SELF, "pick",102);
    SetListenPattern(OBJECT_SELF, "trap", 103);
}


// * Special combat round precursor for associates and companions
// associates and companions have lots of extra reasons why they might not want to fight
// such as having player queued actions we don't want to interrupte or not attaking anyone in the
// same party, etc...
void HenchmenCombatRound( object oIntruder )
{
	//DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
	if (GetAssociateState(NW_ASC_MODE_PUPPET)==TRUE)	
		return;
	
	//DBR 9/12/06 - If there are player-queued action on me, return.
	if (GetHasPlayerQueuedAction(OBJECT_SELF))
		return;
        

	if (GetIsObjectValid(oIntruder) == TRUE)
    {
        // If we're in the same party then we should all be friends.
        // Make sure rep is good, and continue doing whatever you were doing.
        if (GetFactionEqual(oIntruder, OBJECT_SELF) == TRUE )
        {
            //PrettyDebug("Damager was in my faction - aborting");
            ClearPersonalReputation( oIntruder, OBJECT_SELF );
            return;
        }
        
        // if this is not an enemy then continue doing whatever you were doing.
        // If the non-enemy damager is my current target, clear it - this can happen if he surrenders.
        if (GetIsEnemy(oIntruder) == FALSE)
        {
        	// * If someone has surrendered, then don't attack them.
            // * feb 25 2003
            if (GetAttackTarget(OBJECT_SELF) == oIntruder)
                ClearActions(999, TRUE);
            //ActionAttack(OBJECT_INVALID); // Effect???
            return;
        }
    }
	
	if ( ( GetAssociateState(NW_ASC_IS_BUSY) == TRUE ) ||
		 //( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == TRUE ) ||
		 ( GetAssociateState(NW_ASC_MODE_DYING) == TRUE ) )
	{
		return;
	}

    // ****************************************
    // SETUP AND SANITY CHECKS (Quick Returns)
    // ****************************************

    // * BK: stop fighting if something bizarre that shouldn't happen, happens
    if ( bkEvaluationSanityCheck(oIntruder, GetFollowDistance()) == TRUE )
	{
		return;
	}	
	
    // June 2/04: Fix for when henchmen is told to use stealth until next fight
	if ( GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE") == 2 )
	{
		SetLocalInt( OBJECT_SELF, "X2_HENCH_STEALTH_MODE", 0 );
	}
	
	if ( BashDoorCheck(oIntruder) == TRUE )
	{
		return;
	}
	
    // * Store how difficult the combat is for this round	
	int nDiff = GetCombatDifficulty();
	SetLocalInt( OBJECT_SELF, "NW_L_COMBATDIFF", nDiff );
	
	object oMaster = GetCurrentMaster();
	int bHasMaster = GetIsObjectValid( oMaster );

	// BMA-OEI 9/13/06: Player Queued Target override
	object oPreferredTarget = GetPlayerQueuedTarget( OBJECT_SELF );
	if ( ( GetIsObjectValid( oPreferredTarget ) == TRUE ) && 
		 ( GetIsDead( oPreferredTarget ) == FALSE ) &&
		 ( GetArea( oPreferredTarget ) == GetArea( OBJECT_SELF ) ) )
	{
		oIntruder = oPreferredTarget;
	}
	else
	{
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
		
		if ( bHasMaster == TRUE )
		{
	        // *******************************************
	        // Healing
	        // *******************************************
	        // The FIRST PRIORITY: self-preservation
	        // The SECOND PRIORITY: heal master;
			if ( bkCombatAttemptHeal() == TRUE )
			{
				return;
			}
			
	        // NEXT priority: follow or return to master for up to three rounds.
			if ( bkCombatFollowMaster() == TRUE )
			{
				return;
			}
			
	        //5. This check is to see if the master is being attacked and in need of help
	        // * Guard Mode -- only attack if master attacking
	        // * or being attacked.
			if ( GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				object oMasterIntruder = GetLastHostileActor( oMaster );
				
				if ( GetIsObjectValid(oMasterIntruder) == FALSE )
				{
					// MODIFIED Major change. Defend is now Defend only if I attack
					// February 11 2003
					oMasterIntruder = GetAttackTarget( oMaster );
				}
	
				if ( GetIsObjectValid(oMasterIntruder) == TRUE )
				{
					// BMA-OEI 10/20/06: Defend master against non-associates only
					if ( ( GetMaster(OBJECT_SELF) != oMasterIntruder ) &&
						 ( GetMaster(oMasterIntruder) != OBJECT_SELF ) )
					{
						SetLocalInt( OBJECT_SELF, "X0_BATTLEJOINEDMASTER", TRUE );
						oIntruder = oMasterIntruder;
					}
				}
			}
		}
	}
	
	// BMA-OEI 7/17/06 -- Find a suitable target
	// DBR 8/29/06 - commenting out, this is handled in DetermineCombatRound().
	/*if ( GetIsObjectValid(oIntruder) == FALSE )
	{
		oIntruder = GetAttackTarget( OBJECT_SELF );
		
		if ( GetIsObjectValid(oIntruder) == FALSE )
		{
			oIntruder = GetAttemptedSpellTarget();
			
			if ( ( GetIsObjectValid(oIntruder) == FALSE ) || ( GetIsEnemy(oIntruder) == FALSE ) )
			{
				oIntruder = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN );
			}
		}
	}*/

	//DBR 8/29/06 - also handled in DetermineCombatRound() - and this variable is never read anywhere! Only set.
	/*if ( GetIsObjectValid(oIntruder) == FALSE )
	{
		SetLocalInt( OBJECT_SELF, "X0_BATTLEJOINEDMASTER", FALSE );
		return;
	}*/
	
	if ( GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN )
	{
		// 5% chance per round of laughing at the relative challenge of the encounter
		if ( ( nDiff <= 1 ) && ( d20() == 20 ) )
		{
			VoiceLaugh( TRUE );
		}
	}
/*	
	// BMA-OEI 7/18/06 -- Stop following if you've made it this far
	if ( GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW )
	{
		ClearAllActions();
	}
*/	
    // Fall through to generic combat
	DetermineCombatRound( oIntruder );
}


// Manually pick the nearest locked object
int bkManualPickNearestLock()
{
    object oLastObject = GetLockedObject(GetCurrentMaster());

    //MyPrintString("Attempting to unlock: " + GetTag(oLastObject));
    return bkAttemptToOpenLock(oLastObject);
}

// * attempts to disarm last trap (called from RespondToShout and heartbeat
int bkAttemptToDisarmTrap(object oTrap, int bWasShout = FALSE)
{
    //MyPrintString("Attempting to disarm: " + GetTag(oTrap));

    // * May 2003: Don't try to disarm a trap with no trap
    if (GetIsTrapped(oTrap) == FALSE)
    {
        return FALSE;
    }

    // * June 2003. If in 'do not disarm trap' mode, then do not disarm traps
    if(!GetAssociateState(NW_ASC_DISARM_TRAPS))
    {
        return FALSE;
    }


    int bValid = GetIsObjectValid(oTrap);
    int bISawTrap = GetTrapDetectedBy(oTrap, OBJECT_SELF);
    int bCloseEnough = GetDistanceToObject(oTrap) <= 15.0;
    int bInLineOfSight = bkGetIsInLineOfSight(oTrap);


    if(bValid == FALSE || bISawTrap == FALSE || bCloseEnough == FALSE || bInLineOfSight == FALSE)
    {
        //MyPrintString("Failed basic disarm check");
        if (bWasShout == TRUE)
            VoiceCannotDo();
        return FALSE;
    }

    //object oTrapSaved = GetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP");
    SetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP", oTrap);
    // We can tell we can't do it
        string sID = ObjectToString(oTrap);
    int nSkill = GetSkillRank(SKILL_DISABLE_TRAP);
    int nTrapDC = GetTrapDisarmDC(oTrap);
    if ( nSkill > 0 && (nSkill  + 20) >= nTrapDC && GetTrapDisarmable(oTrap)) {
        ClearActions(CLEAR_X0_INC_HENAI_AttemptToDisarmTrap);
        if (ActionUseSkill(SKILL_DISABLE_TRAP, oTrap))
		{
			// ChazM 8/31/06 - Don't turn off commandability - players should always be able to control companions.
			// Also, this can get stuck if the trap is unreachable.
        	//ActionDoCommand(SetCommandable(TRUE));
        	ActionDoCommand(VoiceTaskComplete());
        	//SetCommandable(FALSE);
        	return TRUE;
		}
		else
		{
			// action can't be put on queue - probably can't path
       		return FALSE;
		}
    } 
	
	if (GetHasSpell(SPELL_FIND_TRAPS) && GetTrapDisarmable(oTrap) && GetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK") ==0)
    {
       // SpeakString("casting");
        ClearActions(CLEAR_X0_INC_HENAI_AttemptToDisarmTrap);
        ActionCastSpellAtObject(SPELL_FIND_TRAPS, oTrap);
        SetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK", 10);
        return TRUE;
    }
	
    // MODIFIED February 7 2003. Merged the 'attack object' inside of the bshout
    // this is not really something you want the henchmen just to go and do
    // spontaneously
    if (bWasShout)
    {
        ClearActions(CLEAR_X0_INC_HENAI_BKATTEMPTTODISARMTRAP_ThrowSelfOnTrap);

        //SpeakStringByStrRef(40551); // * Out of game indicator that this trap can never be disarmed by henchman.
        if  (GetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID) != 10)
        {
            string sSpeak = GetStringByStrRef(40551);
            SendMessageToPC(GetCurrentMaster(), sSpeak);
            SetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID, 10);
        }
        if (GetObjectType(oTrap) != OBJECT_TYPE_TRIGGER)
        {
            // * because Henchmen are not allowed to switch weapons without the player's
            // * say this needs to be removed
            // it's an object we can destroy ranged
            // ActionEquipMostDamagingRanged(oTrap);
            ActionAttack(oTrap);
            SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oTrap);
            return TRUE;
        }

        // Throw ourselves on it nobly! :-)
       	ActionMoveToLocation(GetLocation(oTrap));
        SetFacingPoint(GetPositionFromLocation(GetLocation(oTrap)));
        ActionRandomWalk();
        return TRUE;
    }
	
    if (nSkill > 0)
    {

        // * BK Feb 6 2003
        // * Put a check in so that when a henchmen who cannot disarm a trap
        // * sees a trap they do not repeat their voiceover forever
        if  (GetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID) != 10)
        {
            VoiceCannotDo();
            SetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID, 10);
           string sSpeak = GetStringByStrRef(40551);
           SendMessageToPC(GetCurrentMaster(), sSpeak);
        }

        return FALSE;
    }

    return FALSE;
}
//* attempts to cast knock to open the door
int AttemptKnockSpell(object oLocked)
{
    // If that didn't work, let's try using a knock spell
    if (GetHasSpell(SPELL_KNOCK)
        && (GetIsDoorActionPossible(oLocked,
                                    DOOR_ACTION_KNOCK)
            || GetIsPlaceableObjectActionPossible(oLocked,
                                                  PLACEABLE_ACTION_KNOCK)))
    {
        if (bkGetIsDoorInLineOfSight(oLocked) == FALSE)
        {
            // For whatever reason, GetObjectSeen doesn't return seen doors.
            //if (GetObjectSeen(oLocked))
            if (LineOfSightObject(OBJECT_SELF, oLocked) == TRUE)
            {
                ClearActions(CLEAR_X0_INC_HENAI_AttemptToOpenLock2);
                VoiceCanDo();
                ActionWait(1.0);
                ActionCastSpellAtObject(SPELL_KNOCK, oLocked);
                ActionWait(1.0);
                return TRUE;
            }
        }

    }
    return FALSE;
}

// * Attempt to open a given locked object.
int bkAttemptToOpenLock(object oLocked)
{

    // * September 2003
    // * if door is set to not be something
    // * henchmen should bash open  (like mind flayer beds)
    // * then ignore it.
    if (GetLocalInt(oLocked, "X2_L_BASH_FALSE") == 1)
    {
        return FALSE;
    }
    int bNeedKey = FALSE;
    int bInLineOfSight = TRUE;

    if (GetLockKeyRequired(oLocked) == TRUE)
    {
        bNeedKey = TRUE ;
    }

    // * October 17 2003 - BK - Decided that line of sight for doors is not relevant
    // * was causing too many errors.
    //if (bkGetIsInLineOfSight(oLocked) == FALSE)
    //{
    //    bInLineOfSight = TRUE;
   // }
    if ( !GetIsObjectValid(oLocked)
         || bNeedKey == TRUE
         || bInLineOfSight == FALSE )
         //|| GetObjectSeen(oLocked) == FALSE) This check doesn't work.
         {
        // Can't open this, so skip the checks
        //MyPrintString("Failed basic check");
        VoiceCannotDo();
        return FALSE;
    }

    // We might be able to open this

    int bCanDo = FALSE;

    // First, let's see if we notice that it's trapped
    if (GetIsTrapped(oLocked) && GetTrapDetectedBy(oLocked, OBJECT_SELF))
    {
        // Ick! Try and disarm the trap first
        //MyPrintString("Trap on it to disarm");
        if (! bkAttemptToDisarmTrap(oLocked))
        {
            // * Feb 11 2003. Attempt to cast knock because its
            // * always safe to cast it, even on a trapped object
            if (AttemptKnockSpell(oLocked) == TRUE)
            {
                return TRUE;
            }
            //VoicePicklock();
            VoiceNo();
            return FALSE;
        }
    }

    // Now, let's try and pick the lock first
    int nSkill = GetSkillRank(SKILL_OPEN_LOCK);
    if (nSkill > 0) {
        nSkill += GetAbilityModifier(ABILITY_DEXTERITY);
        nSkill += 20;
    }

    if (nSkill > GetLockUnlockDC(oLocked)
        &&
        (GetIsDoorActionPossible(oLocked,
                                 DOOR_ACTION_UNLOCK)
         || GetIsPlaceableObjectActionPossible(oLocked,
                                               PLACEABLE_ACTION_UNLOCK))) {
        ClearActions(CLEAR_X0_INC_HENAI_AttemptToOpenLock1);
        VoiceCanDo();
        ActionWait(1.0);
        ActionUseSkill(SKILL_OPEN_LOCK,oLocked);
        ActionWait(1.0);
        bCanDo = TRUE;
    }

    if (!bCanDo)
        bCanDo = AttemptKnockSpell(oLocked);


    if (!bCanDo
        //&& GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16 Removed since you now have control over their bashing via dialog
        && !GetPlotFlag(oLocked)
        && (GetIsDoorActionPossible(oLocked,
                                    DOOR_ACTION_BASH)
            || GetIsPlaceableObjectActionPossible(oLocked,
                                                  PLACEABLE_ACTION_BASH))) {
        ClearActions(CLEAR_X0_INC_HENAI_AttemptToOpenLock3);
        VoiceCanDo();
        ActionWait(1.0);

        // MODIFIED February 2003
        // Since the player has direct control over weapon, automatic equipping is frustrating.
        // removed.
        //        ActionEquipMostDamagingMelee(oLocked);
        ActionAttack(oLocked);
        SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oLocked);
        bCanDo = TRUE;
    }

    if (!bCanDo && !GetPlotFlag(oLocked) && GetHasSpell(SPELL_MAGIC_MISSILE))
    {
        ClearActions(CLEAR_X0_INC_HENAI_AttemptToOpenLock3);
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE,oLocked);
        return TRUE;
    }

    // If we did it, let the player know
    if(!bCanDo) {
        VoiceCannotDo();
    } else {
        ActionDoCommand(VoiceTaskComplete());
        return TRUE;
    }

    return FALSE;
}


// Handles responses to henchmen commands, including both radial
// menu and voice commands.
void bkRespondToHenchmenShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, int nBanInventory=FALSE)
{

    // * if petrified, jump out
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, OBJECT_SELF) == TRUE)
    {
        return;
    }

    // * MODIFIED February 19 2003
    // * Do not respond to shouts if in dying mode
    if (GetIsHenchmanDying() == TRUE)
        return;

    // Do not respond to shouts if you've surrendered.
/*    int iSurrendered = GetLocalInt(OBJECT_SELF,"Generic_Surrender");
    if (iSurrendered)
        return;*/
    if(GetLocalInt(OBJECT_SELF,"Generic_Surrender")) return;

    object oLastObject;
    object oTrap;
    object oMaster = GetCurrentMaster();

    object oTarget;

    //ASSOCIATE SHOUT RESPONSES
    switch(nShoutIndex)
    {

    // * toggle search mode for henchmen
    case ASSOCIATE_COMMAND_TOGGLESEARCH:
    {
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_TOGGLESEARCH command." );
        if (GetActionMode(OBJECT_SELF, ACTION_MODE_DETECT) == TRUE)
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
        }
        else
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
        }
        break;
    }
    // * toggle stealth mode for henchmen
    case ASSOCIATE_COMMAND_TOGGLESTEALTH:
    {
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_TOGGLESTEALTH command." );
        //SpeakString(" toggle stealth");
        if (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == TRUE)
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
        }
        else
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
        break;
    }
    // * June 2003: Stop spellcasting
    case ASSOCIATE_COMMAND_TOGGLECASTING:
    {
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_TOGGLECASTING command." );
        if (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 10)
        {
           // SpeakString("Was in no casting mode. Switching to cast mode");
            SetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING", 0);
            VoiceCanDo();
        }
        else
        if (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") == 0)
        {
         //   SpeakString("Was in casting mode. Switching to NO cast mode");
            SetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING", 10);
            VoiceCanDo();
        }
      break;
    }
    case ASSOCIATE_COMMAND_INVENTORY:
        // feb 18. You are now allowed to access inventory during combat.
         if (nBanInventory == TRUE)
        {
            SpeakStringByStrRef(9066);
        }
        else
        {
            // * cannot modify disabled equipment
            if (GetLocalInt(OBJECT_SELF, "X2_JUST_A_DISABLEEQUIP") == FALSE)
            {
                OpenInventory(OBJECT_SELF, oShouter);
            }
            else
            {
                // * feedback as to why
                SendMessageToPCByStrRef(oMaster, 100895);
            }

        }

        break;

    case ASSOCIATE_COMMAND_PICKLOCK:
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_PICKLOCK command." );
        bkManualPickNearestLock();
        break;

    case ASSOCIATE_COMMAND_DISARMTRAP: // Disarm trap
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_DISARMTRAP command." );
        bkAttemptToDisarmTrap(GetNearestTrapToObject(oMaster), TRUE);
        break;

    case ASSOCIATE_COMMAND_ATTACKNEAREST:
		// Familiars are not combat oriented and won't respond to Attack Nearest shouts.
		if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
			break;
	
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_ATTACKNEAREST command." );
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
        ResetHenchmenState();
        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
        SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
        DetermineCombatRound();

        // * bonus feature. If master is attacking a door or container, issues VWE Attack Nearest
        // * will make henchman join in on the fun
        oTarget = GetAttackTarget(oMaster);
        if (GetIsObjectValid(oTarget) == TRUE)
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE || GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
            {
                ActionAttack(oTarget);
            }
        }
        break;

    case ASSOCIATE_COMMAND_FOLLOWMASTER:
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_FOLLOWMASTER command." );
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
        ResetHenchmenState();
        SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
        DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCanDo());

        //UseStealthMode();
        //UseDetectMode();
        ActionForceFollowObject(oMaster, GetFollowDistance());
        SetAssociateState(NW_ASC_IS_BUSY);
        DelayCommand(BK_FOLLOW_BUSY_DELAY, SetAssociateState(NW_ASC_IS_BUSY, FALSE));
        break;

    case ASSOCIATE_COMMAND_GUARDMASTER:
    {
		// Familiars are not combat oriented and won't respond to Guard Me shouts.
		if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
			break;
	
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_GUARDMASTER command." );
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
        ResetHenchmenState();
        //DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCannotDo());

        //Companions will only attack the Masters Last Attacker
        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER);
        SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE);
        object oLastAttackerOfMaster = GetLastHostileActor(oMaster);
        // * for some reason this is too often invalid. still the routine
        // * works corrrectly
        SetLocalInt(OBJECT_SELF, "X0_BATTLEJOINEDMASTER", TRUE);
        //HenchmenCombatRound(oLastAttackerOfMaster);
        HenchmenCombatRound(); // HenchmenCombatRound() should pick a more appropriate target.
        break;
    }
    case ASSOCIATE_COMMAND_HEALMASTER:
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_HEALMASTER command." );
        //Ignore current healing settings and heal me now

		// BMA-OEI 9/13/06: Clear player queued preferred target
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
        ResetHenchmenState();
        //SetCommandable(TRUE);
        if(TalentCureCondition())
        {
            DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCanDo());
            return;
        }

        if(TalentHeal(TRUE, oMaster))
        {
            DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCanDo());
            return;
        }

        DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCannotDo());
        break;

    case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK:
        //Check local for re-try locked doors
        if((!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
           && GetAssociateState(NW_ASC_RETRY_OPEN_LOCKS) && (!GetAssociateState(NW_ASC_MODE_PUPPET)))	//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
           {
            oLastObject = GetLockedObject(oMaster);
            bkAttemptToOpenLock(oLastObject);
        }
        break;


    case ASSOCIATE_COMMAND_STANDGROUND:
		//PrettyDebug( GetName(OBJECT_SELF) + " has received an ASSOCIATE_COMMAND_STANDGROUND command." );
        //No longer follow the master or guard him
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SetPlayerQueuedTarget( OBJECT_SELF, OBJECT_INVALID );
        SetAssociateState(NW_ASC_MODE_STAND_GROUND);
        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE);
        DelayCommand(BK_VOICE_RESPOND_DELAY, VoiceCanDo());
        ActionAttack(OBJECT_INVALID);
        ClearActions(CLEAR_X0_INC_HENAI_RespondToShout1);
        break;



        // ***********************************
        // * AUTOMATIC SHOUTS - not player
        // *   initiated
        // ***********************************
    case ASSOCIATE_COMMAND_MASTERSAWTRAP:
		//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
		if (GetAssociateState(NW_ASC_MODE_PUPPET))
			break;
			
        if(!GetIsInCombat())
        {
            if (!GetAssociateState(NW_ASC_MODE_STAND_GROUND))	

            {
                oTrap = GetLastTrapDetected(oMaster);
                bkAttemptToDisarmTrap(oTrap);
            }
        }
        break;

    case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
			break;
			
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (GetAssociateState(NW_ASC_MODE_PUPPET))
			break;
	
        // * July 15, 2003: Make this only happen if not
        // * in combat, otherwise the henchman will
        // * ping pong between targets
		
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( GetIsInCombat(OBJECT_SELF) == FALSE )
		{
			if ( GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				HenchmenCombatRound();
			}
			else if ( ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) &&
					  ( GetNumActions(OBJECT_SELF) == 0 ) )
			{
				HenchmenCombatRound();
			}
		}
        break;

    case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
			break;	
	
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (GetAssociateState(NW_ASC_MODE_PUPPET))
			break;
	
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( (GetIsInCombat(OBJECT_SELF) == FALSE)  && (GetCurrentAction() != ACTION_CASTSPELL))
		{
			if ( GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) == TRUE )
			{ 
				//ClearActions(CLEAR_X0_INC_HENAI_RespondToShout2);
				HenchmenCombatRound( GetAttackTarget(oMaster) );
			}
			else if ( ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) &&
					  ( GetNumActions(OBJECT_SELF) == 0 ) )
			{
				HenchmenCombatRound( GetAttackTarget(oMaster) );
			}
		}		
        break;

    case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_FAMILIAR)
			break;	
	
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (GetAssociateState(NW_ASC_MODE_PUPPET))
			break;
	
        if(!GetAssociateState(NW_ASC_MODE_STAND_GROUND))
        {
            if(!GetIsInCombat(OBJECT_SELF) && (GetCurrentAction() != ACTION_CASTSPELL))
            {   // SpeakString("here 753");
                object oAttacker = GetGoingToBeAttackedBy(GetMaster());
                // April 2003: If my master can see the enemy, then I can too.
                // Potential Side effect : Henchmen may run
                // to stupid places, trying to get an enemy
                if(GetIsObjectValid(oAttacker) && GetObjectSeen(oAttacker, GetMaster()))
                {
                   // SpeakString("Defending Master");
                    //ClearActions(CLEAR_X0_INC_HENAI_RespondToShout3);
                    //ActionMoveToObject(oAttacker, TRUE, 7.0);
                    HenchmenCombatRound(oAttacker);

                }
            }
        }

	/*	       
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( GetIsInCombat(OBJECT_SELF) == FALSE )
		{
			if ( GetAssociateState(NW_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				HenchmenCombatRound( GetGoingToBeAttackedBy(oMaster) );
			}
			else if ( ( GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE ) &&
					  ( GetNumActions(OBJECT_SELF) == 0 ) )
			{
				HenchmenCombatRound( GetGoingToBeAttackedBy(oMaster) );
			}
		}
	*/		
        break;

    case ASSOCIATE_COMMAND_LEAVEPARTY:
        {
            string sTag = GetTag(GetArea(oMaster));
            // * henchman cannot be kicked out in the reaper realm
            // * Followers can never be kicked out
            if (sTag == "GatesofCania" || GetIsFollower(OBJECT_SELF) == TRUE)
                return;

            if(GetIsObjectValid(oMaster))
            {
                ClearActions(CLEAR_X0_INC_HENAI_RespondToShout4);
                if(GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN)
                {
                    FireHenchman(oMaster, OBJECT_SELF);
                }
            }
            break;
        }
    }

}

//::///////////////////////////////////////////////
//:: bkCombatAttemptHeal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Attempt to heal self and then master
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int bkCombatAttemptHeal()
{
    // * if master is disabled then attempt to free master
    object oMaster = GetCurrentMaster();


    // *turn into a match function...
    if (MatchDoIHaveAMindAffectingSpellOnMe(oMaster)) {
        //int nSpellToUse = -1;

        if (GetHasSpell(SPELL_DISPEL_MAGIC, OBJECT_SELF) ) {
            ClearActions(CLEAR_X0_INC_HENAI_CombatAttemptHeal1);
            ActionCastSpellAtLocation(SPELL_DISPEL_MAGIC, GetLocation(oMaster));
            return TRUE;
        }
    }

    int iHealMelee = TRUE;
    if (bkGetBehavior(BK_HEALINMELEE) == FALSE)
        iHealMelee = FALSE;


    object oNearestEnemy = GetNearestSeenEnemy();

    float fDistance = 0.0;
    if (GetIsObjectValid(oNearestEnemy)) {
        fDistance = GetDistanceToObject(oNearestEnemy);
    }

    int iHP = GetPercentageHPLoss(OBJECT_SELF);

    // if less than 10% hitpoints then pretend that I am allowed
    // to heal in melee. Things are getting desperate
    if (iHP < 10)
     iHealMelee = TRUE;

    int iAmFamiliar = (GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oMaster) == OBJECT_SELF);

    // * must be out of Melee range or ALLOWED to heal in melee
    if (fDistance > BK_HEALTHRESHOLD || iHealMelee) {
        int iAmHenchman = GetAssociateType(OBJECT_SELF) == ASSOCIATE_TYPE_HENCHMAN;
        int iAmCompanion = (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oMaster) == OBJECT_SELF);
        int iAmSummoned = (GetAssociate(ASSOCIATE_TYPE_SUMMONED,oMaster) == OBJECT_SELF);

        // Condition for immediate self-healing
        // Hit-point at less than 50% and random chance
        if (iHP < 50) {
            // verbalize
            if (iAmHenchman || iAmFamiliar) {
                // * when hit points less than 10% will whine about
                // * being near death
                if (iHP < 10 && Random(5) == 0)
                    VoiceNearDeath();
            }

            // attempt healing
            if (d100() > iHP-20) {
                ClearActions(CLEAR_X0_INC_HENAI_CombatAttemptHeal2);
                if (TalentHealingSelf()) return TRUE;
                if (iAmHenchman || iAmFamiliar)
                    if (Random(100) > 80) VoiceHealMe();
            }
        }

        // ********************************
        // Heal master if needed.
        // ********************************

        if (GetAssociateHealMaster()) {
            if (TalentHeal())
                return TRUE;
            else
                return FALSE;
        }
    }

    // * No healing done, continue with combat round
    return FALSE;
}

//::///////////////////////////////////////////////
//:: bkGetBehavior
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Set/get functions for CONTROL PANEL behavior
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int bkGetBehavior(int nBehavior)
{
    return GetLocalInt(OBJECT_SELF, "NW_L_BEHAVIOR" + IntToString(nBehavior));
}

void bkSetBehavior(int nBehavior, int nValue)
{
    SetLocalInt(OBJECT_SELF, "NW_L_BEHAVIOR"+IntToString(nBehavior), nValue);
}

//::///////////////////////////////////////////////
//:: bkCombatFollowMaster
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Forces the henchman to follow the player.
    Will even do this in the middle of combat if the
    distance it too great
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int bkCombatFollowMaster()
{
    object oMaster = GetCurrentMaster();
    int iAmHenchman = (GetHenchman(oMaster) == OBJECT_SELF);
    int iAmFamiliar = (GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oMaster) == OBJECT_SELF);

    if(bkGetBehavior(BK_CURRENT_AI_MODE) != BK_AI_MODE_RUN_AWAY)
    {
        // * double follow threshold if in combat (May 2003)
        float fFollowThreshold = BK_FOLLOW_THRESHOLD;
        if (GetIsInCombat(OBJECT_SELF) == TRUE)
        {
            fFollowThreshold = BK_FOLLOW_THRESHOLD * 2.0;
        }
        if(GetDistanceToObject(oMaster) > fFollowThreshold)
        {
            if(GetCurrentAction(oMaster) != ACTION_FOLLOW)
            {
                ClearActions(CLEAR_X0_INC_HENAI_CombatFollowMaster1);
                //MyPrintString("*****EXIT on follow master.*******");
                ActionForceFollowObject(oMaster, GetFollowDistance());
	        	SetAssociateState(NW_ASC_IS_BUSY);
        		DelayCommand(5.0, SetAssociateState(NW_ASC_IS_BUSY, FALSE));
                return TRUE;
            }
        }
		else
		{
			if ( GetCurrentAction(OBJECT_SELF) == ACTION_FOLLOW )
			{
				ClearAllActions();
			}
		}
    }


//       4. If in 'NEVER FIGHT' mode will not fight but should TELL the player
//      that they are in NEVER FIGHT mode
    if (bkGetBehavior(BK_NEVERFIGHT) == TRUE)
    {

    	ClearActions(CLEAR_X0_INC_HENAI_CombatFollowMaster2);
//    ActionWait(6.0);
//    ActionDoCommand(DelayCommand(5.9, SetCommandable(TRUE)));
//    SetCommandable(FALSE);
        if (d10() > 7)
        {
            if (iAmHenchman || iAmFamiliar)
                VoiceLookHere();
        }
    	return TRUE;
    }


    return FALSE;
}


//Pausanias: Is Object in the line of sight of the seer
int bkGetIsInLineOfSight(object oTarget,object oSeer=OBJECT_SELF)
{
    // * if really close, line of sight
    // * is irrelevant
    // * if this check is removed it gets very annoying
    // * because the player can block line of sight
    if (GetDistanceBetween(oTarget, oSeer) < 6.0)
    {
        return TRUE;
    }

    return LineOfSightObject(oSeer, oTarget);

}

// Get the cosine of the angle between the two objects
float bkGetCosAngleBetween(object Loc1, object Loc2)
{
    vector v1 = GetPositionFromLocation(GetLocation(Loc1));
    vector v2 = GetPositionFromLocation(GetLocation(Loc2));
    vector v3 = GetPositionFromLocation(GetLocation(OBJECT_SELF));

    v1.x -= v3.x; v1.y -= v3.y; v1.z -= v3.z;
    v2.x -= v3.x; v2.y -= v3.y; v2.z -= v3.z;

    float dotproduct = v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;

    return dotproduct/(VectorMagnitude(v1)*VectorMagnitude(v2));

}

//Pausanias: Is there a closed door in the line of sight.
// * is door in line of sight
int bkGetIsDoorInLineOfSight(object oTarget)
{
    float fMeDoorDist;

    object oView = GetFirstObjectInShape(SHAPE_SPHERE, 40.0,
                                         GetLocation(OBJECT_SELF),
                                         TRUE,OBJECT_TYPE_DOOR);

    float fMeTrapDist = GetDistanceBetween(oTarget,OBJECT_SELF);

    while (GetIsObjectValid(oView)) {
        fMeDoorDist = GetDistanceBetween(oView,OBJECT_SELF);
        //SpeakString("Trap3 : "+FloatToString(fMeTrapDist)+" "+FloatToString(fMeDoorDist));
        if (fMeDoorDist < fMeTrapDist && !GetIsTrapped(oView))
            if (GetIsDoorActionPossible(oView,DOOR_ACTION_OPEN) ||
                GetIsDoorActionPossible(oView,DOOR_ACTION_UNLOCK)) {
                float fAngle = bkGetCosAngleBetween(oView,oTarget);
                //SpeakString("Angle: "+FloatToString(fAngle));
                if (fAngle > 0.5) {
                    // if (d10() > 7)
                    // SpeakString("There's something fishy near that door...");
                    return TRUE;
                }
            }

        oView = GetNextObjectInShape(SHAPE_SPHERE,40.0,
                                     GetLocation(OBJECT_SELF),
                                     TRUE, OBJECT_TYPE_DOOR);
    }

    //SpeakString("No matches found");
    return FALSE;
}


// Determine whether to switch to new attacker
int GetIsDamagerABetterTarget( object oDamager, object oCurrentTarget )
{
	if ( GetIsObjectValid(oDamager) == TRUE )
	{
		if ( GetIsObjectValid(oCurrentTarget) == FALSE )
		{
			// I don't have a current target!
			return ( TRUE );
		}
		else
		{
			// Damager is of a higher level than my current target
			// or I was just dealt massive damage
			if ( ( GetHitDice(oDamager) > GetHitDice(oCurrentTarget) ) ||
				 ( GetTotalDamageDealt() > (GetMaxHitPoints()/4) ) )
			{
				return ( TRUE );
			}
		}
	}

	return ( FALSE );
}

/* void main() {} /* */
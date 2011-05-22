// gb_comp_heart
/*
	companion heartbeat
*/
// ChazM 12/5/05
// BMA-OEI 2/6/06 cleaned up comments, preserve action queue
// BMA-OEI 2/8/06 removed debug
// BMA-OEI 2/23/06 added 0.5f minimal follow distance
// ChazM 2/23/06 added commented PrettyDebugs.
// BMA-OEI 2/28/06 increase min follow distance = 2.0f	
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// ChazM 8/18/06 added debug calls.
// ChazM 1/18/07 - Script re-org - includes EvenFlw modifications
// ChazM 1/29/07 - Don't force follow if in Puppet Mode - no longer needed w/ new multi-select.
// ChazM 2/26/07 - No longer call StoreLastMelee()/StoreLastRanged()
// ChazM 4/27/07 - removed EVENFLW_AI_LAST_STATE - no longer used.
// ChazM 6/8/07 - Added NonCombatCureEffects()
// MDiekmann 6/14/07 - Added support for custom heart beat script
// MDiekmann 6/22/07 - Modified CompanionActionsWhenNotInCombat() so that capable companions will summon a familiar or animal companion.
// MDiekmann 8/10/07 - Fix for casting cure spells when spellcasting is set to off

#include "X0_INC_HENAI"
#include "X2_INC_SUMMSCALE"
#include "X2_INC_SPELLHOOK"
//#include "ginc_companion"
#include "ginc_debug"
//#include "ginc_death"

const float MIN_FOLLOW_DISTANCE = 2.0f;


// ---------------------------------
// Prototypes
// ---------------------------------

void DoDebug(string sMessage);
void HandleEpicSummons();
void FollowMaster(object oMaster);
void CompanionActionsWhenNotInCombat();
int  NonCombatCureEffects();

// ---------------------------------
// Functions
// ---------------------------------

void DoDebug(string sMessage)
{
	return;
	string sMyName = GetName(OBJECT_SELF);
	PrettyDebug("gb_comp_heart: " + sMyName + " - " + sMessage);
}



void HandleEpicSummons()
{
    // GZ: Fallback for timing issue sometimes preventing epic summoned creatures from leveling up to their master's level.
    // There is a timing issue with the GetMaster() function not returning the fof a creature
    // immediately after spawn. Some code which might appear to make no sense has been added
    // to the nw_ch_ac1 and x2_inc_summon files to work around this
    // This code is only run at the first hearbeat
    int nLevel = SSMGetSummonFailedLevelUp(OBJECT_SELF); // x2_inc_summscale.nss
    if (nLevel != 0)
    {
        int nRet;
        if (nLevel == -1) // special shadowlord treatment
        {
          SSMScaleEpicShadowLord(OBJECT_SELF);
        }
        else if  (nLevel == -2)
        {
          SSMScaleEpicFiendishServant(OBJECT_SELF);
        }
        else
        {
            nRet = SSMLevelUpCreature(OBJECT_SELF, nLevel, CLASS_TYPE_INVALID);
            if (nRet == FALSE)
            {
                WriteTimestampedLogEntry("WARNING - nw_ch_ac1:: could not level up " + GetTag(OBJECT_SELF) + "!");
            }
        }

        // regardless if the actual levelup worked, we give up here, because we do not
        // want to run through this script more than once.
        SSMSetSummonLevelUpOK(OBJECT_SELF);
    }
}



// have follower force follow at his normal following distance.
void FollowMaster(object oMaster)
{
	float fFollowDistance = GetFollowDistance();
	if (fFollowDistance < MIN_FOLLOW_DISTANCE)
	{
		fFollowDistance = MIN_FOLLOW_DISTANCE;	// AFFO() doesn't do anything if fd < 0.5				
	}				
	
	if(GetDistanceToObject(oMaster) > fFollowDistance)
	{
		//DoDebug("Throwing an ActionForceFollow");
		ActionForceFollowObject(oMaster, fFollowDistance);
	}
}


// What to do when not in combat...
void CompanionActionsWhenNotInCombat()
{
	object oMaster 		= GetCurrentMaster(OBJECT_SELF);
	int bHasMaster 		= GetIsObjectValid(oMaster);
	int bPuppetMode 	= GetAssociateState(NW_ASC_MODE_PUPPET);
	
	// If you don't have a master, then don't do this stuff
	if (!bHasMaster)
		return;
	
    // Check to see if should re-enter stealth mode
	int nStealth = GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE"); // x2_inc_henai.nss
	if ((nStealth == 1) 
	  	|| (nStealth == 2) 
		//|| (nStealth == 3) && bHasMaster && GetActionMode(oMaster, ACTION_MODE_STEALTH)
		)
	{
		if (GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == FALSE)
		{
			SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
		}
	}
	
/*	
	if (nStealth==0 
		&& bHasMaster 
		&& GetLocalInt(oMaster, "X2_HENCH_STEALTH_MODE")==2 
		&& !GetActionMode(oMaster, ACTION_MODE_STEALTH))
		if(GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH))
			SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, FALSE);
*/

	if (bPuppetMode)
		return;
	
	//25% chance that..
	if (d4() == 1)
	{
		// if we're not excluding the ability to use feats and abilities
		if(GetLocalIntState(OBJECT_SELF, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY) == FALSE)
		{
			//and if we have the summon familiar feat
			if(GetHasFeat(FEAT_SUMMON_FAMILIAR, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_FAMILIAR, OBJECT_SELF))
			{
				object oAssociate = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
				// with no current familiar stat
				if(!GetIsObjectValid(oAssociate))
				{
					// summon my familiar and decrement use
					SummonFamiliar();
					DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
				}
			}
			// or if we have the animal companion feat
			else if(GetHasFeat(FEAT_ANIMAL_COMPANION, OBJECT_SELF) || GetHasSpell(SPELLABILITY_SUMMON_ANIMAL_COMPANION, OBJECT_SELF))
			{
				object oAssociate = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);
				// and no current companion
				if(!GetIsObjectValid(oAssociate))
				{
					//summon companion and decrement us
					SummonAnimalCompanion();
					DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
				}
			}
			
		}
	}
	
	// Should I jump back into combat?
	if (bHasMaster 
		&& !GetAssociateState(NW_ASC_MODE_STAND_GROUND) 
		// && !bPuppetMode 
		&& GetIsInCombat(oMaster)) 
	{
		ActionMoveToObject(oMaster, TRUE, 4.0f);
		DelayCommand(3.0f, HenchmenCombatRound(OBJECT_INVALID));
	}
	
	// what's up with my equipment?
	//SetLocalInt(OBJECT_SELF, EVENFLW_AI_LAST_STATE, GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER"));
    // * checks to see if a ranged weapon was being used
    // * if so, it equips it back    
	//StoreLastMelee();
	//StoreLastRanged();
	
	if (!GetIsResting() 
		&& bHasMaster) 
	{  
		DeleteLocalInt(OBJECT_SELF, EVENFLW_AI_CLOSE);
		object oRight = GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND"); // x0_i0_equip.nss
       	if (GetIsObjectValid(oRight) 
			&& oRight!=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND))
       	{
           	bkEquipAppropriateWeapons(OBJECT_INVALID);
       	}
	}

	// check if we need curing from effects
	if (NonCombatCureEffects())
		return;
		
	// Seek out and disable undisabled traps
	//if (!bPuppetMode 	//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
	//	&& !GetIsInCombat(oMaster))		// in ginc_companions.nss
		
	if (!GetIsInCombat(oMaster))		// in ginc_companions.nss
	{		
   		object oTrap = GetNearestTrapToObject();
		bkAttemptToDisarmTrap(oTrap);				// in x0_inc_henai.nss
	}
		
	// search, follow master.
	if (bHasMaster
		//&& !bPuppetMode
		&& GetNumActions( OBJECT_SELF ) == 0
		&& GetAssociateState(NW_ASC_MODE_STAND_GROUND) == FALSE)
	{
		if (GetAssociateState(NW_ASC_AGGRESSIVE_SEARCH) == TRUE)
		{
			//DoDebug("Throwing a Search action");
			ActionUseSkill(SKILL_SEARCH, OBJECT_SELF);	
		}
		FollowMaster(oMaster);
	}
}

/*
void HBInfo()
{
	string sMyName = GetName(OBJECT_SELF);
	PrettyDebug("gb_comp_heart: " + sMyName + "'s heartbeat");
	PrettyDebug("GetFollowDistance: " + FloatToString(GetFollowDistance()));
	PrettyDebug("GetLocalInt('NW_ASSOCIATE_MASTER'): " + IntToString(GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER")));
}
*/
int  NonCombatCureEffects()
{
	int nRet;
	// occasionally make sure the party is okay.
	if (d4() == 1 && (GetLocalInt(OBJECT_SELF, "X2_L_STOPCASTING") != 10))
	{
		nRet = TalentCureCondition();		
	}
	else
	{	// frequently check if there is a potion we can use.	
    	int nSum = GetCurrentNegativeConditions(OBJECT_SELF);
		nRet = TalentCureConditionSelf(nSum);
	}		
	return nRet;
}	
void main()
{
	//option for a custom hb script (ease of AI hookup)
	string sHBScript=GetLocalString(OBJECT_SELF,"hb_script");
	if (sHBScript!="")
		ExecuteScript(sHBScript,OBJECT_SELF);
		
	int bDying 		= (GetIsDead(OBJECT_SELF) || GetIsHenchmanDying(OBJECT_SELF));
    int bBusy 		= GetAssociateState(NW_ASC_IS_BUSY);
	int bInCombat 	= GetIsInCombat();
	
    // If we're dying or busy, we return
    // (without sending the user-defined event)
	// file: nw_i0_generic, x0_i0_henchmen, assoc, x0_i0_states, henai
	if ((bDying == TRUE) || (bBusy == TRUE))
		return;

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck(); // x2_inc_spellhook.nss
	
    if (bInCombat == FALSE)
    {
		CompanionActionsWhenNotInCombat();
    }

	HandleEpicSummons();

	// * if I am dominated, ask for some help
	if ((GetHasEffect(EFFECT_TYPE_DOMINATED, OBJECT_SELF) == TRUE) 
		&& (GetIsEncounterCreature(OBJECT_SELF) == FALSE))
	{
	    SendForHelp(); // x0_inc_henai.nss
	}

	if (GetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT))
	{
	    SignalEvent(OBJECT_SELF, EventUserDefined(1001));
	}
}
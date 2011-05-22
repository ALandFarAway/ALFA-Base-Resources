//:://////////////////////////////////////////////////
//:: X0_I0_EQUIP
/*
  Library that handles equipping weapons functions.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/21/2003
//::////////////////////////////////////////////////// 
// ChazM 5/17/06 - modified bkEquipAppropriateWeapons() and bkEquipRanged() to exit if roster member
// ChazM 5/18/06 - commented Debugs
// ChazM 5/24/06 modified bkEquipAppropriateWeapons() and bkEquipRanged() to exit if owned by player
// ChazM 1/26/07 - EvenFlw AI functions added - includes numerous modified functions
// ChazM 2/15/07 - modified bkEquipAppropriateWeapons(), bkEquipMelee(), bkEquipRanged() - weapon switching checks
// ChazM 2/26/07 - reverted back to previous versions for equipping

// void main(){}

//#include "x0_i0_assoc" -- included in x0_i0_enemy
// #include "x0_i0_match" -- included in x0_i0_enemy
#include "x0_i0_enemy"
#include "ginc_debug"
#include "x2_inc_switches"

//=====================================================================
// CONSTANTS
//=====================================================================
const string EVENFLW_NUM_MELEE 			= "EVENFLW_NUM_MELEE";  // Number of Melee attackers.


//=====================================================================
// FUNCTION PROTOTYPES
//=====================================================================


// * checks to see if oUser has ambidexteriy and two weapon fighting
int WiseToDualWield(object oUser);

// Equip the weapon appropriate to enemy and position.
// This is now just a wrapper around bkEquipAppropriateWeapons.
void EquipAppropriateWeapons(object oTarget);

// * returns true if out of ammo of currently equipped weapons
int IsOutOfAmmo(int bIAmAHenc);
// Equip melee weapon(s) and a shield.
void bkEquipMelee(object oTarget = OBJECT_INVALID, int nClearActions=TRUE);
void bkEquipRanged(object oTarget=OBJECT_INVALID, int bIAmAHenc = FALSE, int bForceEquip = FALSE);
// EVENFLW version
//void bkEquipRanged(object oTarget=OBJECT_INVALID, int bIAmAHenc = FALSE, int bForceEquip = FALSE, int bClearAllActions=FALSE);

// Equip the appropriate weapons to face the target.
void bkEquipAppropriateWeapons(object oTarget, int nPrefersRanged=FALSE, int nClearActions=TRUE);

// * this is just a wrapper around ActionAttack
// * to make sure the creature equips weapons
void WrapperActionAttack(object oTarget);



void StoreLastMelee(object self=OBJECT_SELF);
void ClearIfEmptyHanded(object self=OBJECT_SELF);
int GetLastMelee(int Clear=FALSE);
int GetLastRanged(int Clear=FALSE);


//=====================================================================
// FUNCTION DEFINITIONS
//=====================================================================

//    Makes the user get his best weapons.  If the
//    user is a Henchmen then he checks the player
//    preference.
//:: Created By: Preston Watamaniuk
//:: Created On: April 2, 2002
void EquipAppropriateWeapons(object oTarget)
{
    bkEquipAppropriateWeapons(oTarget,
                              GetAssociateState(NW_ASC_USE_RANGED_WEAPON));
}

/*
// EVENFLW version
// * stores the last Ranged weapons used for when the
// * henchmen switches from Ranged to melee in XP1
void StoreLastRanged(object self=OBJECT_SELF)
{
	object master=OBJECT_SELF;
	if(self==master) master=GetCurrentMaster(OBJECT_SELF);
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, self);
	object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, self);
    if (GetIsObjectValid(oItem1) && !MatchMeleeWeapon(oItem1) && (oItem1!=GetLocalObject(self, "X0_L_RIGHTHAND") || oItem2!=GetLocalObject(self, "X0_L_LEFTHAND"))) {
        SetLocalObject(self, "X0_L_RIGHTHAND", oItem1);
		string weapon=GetName(oItem1);
		if(GetIsObjectValid(oItem2)) {
			SetLocalObject(self, "X0_L_LEFTHAND", oItem2);
			weapon+=" and "+GetName(oItem2);
		} else SetLocalObject(self, "X0_L_LEFTHAND", OBJECT_INVALID);
		weapon+=".";
		if(GetIsPC(master)) SendMessageToPC(master, GetName(self)+" now has a ranged preference of "+weapon);
	}
}
*/

// stores the last Ranged weapons used for when the
// henchmen switches from Ranged to melee in XP1
void StoreLastRanged()
{
    if (GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND") == OBJECT_INVALID )
    {
        object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (GetIsObjectValid(oItem1) && GetWeaponRanged(oItem1))
            SetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND", oItem1);
    }
}


int GetIsOkToEquipByAI()
{
	// Roster Companions and characters owned by players will not try to switch weapons on their own
	if (GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF))
    {
	    if (GetGlobalInt(CAMPAIGN_SWITCH_COMPANION_WEAPON_SWAP_ENABLED) == FALSE)
		    return FALSE;
            
        // weapon swapping tied into item use behavior.           
		if (GetGlobalInt(CAMPAIGN_SWITCH_COMPANION_WEAPON_SWAP_ON_USE_ITEM_ONLY)
			&& GetLocalInt(OBJECT_SELF, "N2_TALENT_EXCLUDE") & 0x1  )  
			return FALSE;
    }
    return TRUE;
}

/*
// EVENFLW version
void bkEquipAppropriateWeapons(object oEnemy, int nPrefersRanged=FALSE, int nClearActions=TRUE)
{
    if (!GetIsOkToEquipByAI())
        return;
        
    // if companion or player owned char is to use weapon swapping, we treat them as a hench from this point.
    int bIAmAHench = GetIsObjectValid(GetMaster()) || GetIsOwnedByPlayer(OBJECT_SELF) || GetIsRosterMember(OBJECT_SELF);
	if (bIAmAHench) 
	{
	}
			
	//if (bIAmAHench 
	//	&& !GetIsOwnedByPlayer(GetCurrentMaster(OBJECT_SELF)) 
	//	&& !GetModuleSwitchValue(EVENFLW_ALLOW_GRAPHICAL_BUG")
	//	) 
	//	return;
		
    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int bIsWieldingRanged=GetIsObjectValid(oRightHand) && !MatchMeleeWeapon(oRightHand);
	int outofammo=FALSE;
	if(bIsWieldingRanged) outofammo=IsOutOfAmmo(bIAmAHench);
    if (!GetIsObjectValid(oEnemy)) {
		if(!bIsWieldingRanged) {
			if(bIAmAHench == TRUE && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
            	StoreLastMelee();
        	bkEquipRanged(OBJECT_INVALID, bIAmAHench, FALSE, nClearActions);
		}
        return;
    }
    float fDistance = 1.0;
	if(!GetLocalInt(OBJECT_SELF, EVENFLW_AI_CLOSE)) {
		fDistance=GetDistanceBetween(OBJECT_SELF, oEnemy);
		if(GetCreatureSize(oEnemy)>4) {
			fDistance-=10.5f;
		}
	}
    int bPointBlankShotMatters = FALSE;
    if (GetHasFeat(FEAT_POINT_BLANK_SHOT) == TRUE)
    {
        bPointBlankShotMatters = TRUE;
    }
    if (GetGameDifficulty()== GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty()== GAME_DIFFICULTY_DIFFICULT)
    {
        bPointBlankShotMatters = FALSE;
    }
    if ((fDistance <= 2.3f) && bPointBlankShotMatters == FALSE || outofammo)
    {
		if(outofammo && (GetIsOwnedByPlayer(OBJECT_SELF) || GetIsRosterMember(OBJECT_SELF))) {
			FloatingTextStringOnCreature(GetName(OBJECT_SELF)+" is out of ammo!", OBJECT_SELF);
		}
        if(bIAmAHench == TRUE && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
            StoreLastRanged();
        bkEquipMelee(oEnemy, nClearActions);
    }
    else
    {
        if (!bIsWieldingRanged)
        {
			if(bIAmAHench == TRUE && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
                StoreLastMelee();
            bkEquipRanged(oEnemy, bIAmAHench, FALSE, nClearActions);
        }
    }
}
*/

//    Makes the user get his best weapons.  If the
//    user is a Henchmen then he checks the player
//    preference.
//:: Created By: Preston Watamaniuk
//:: Created On: April 2, 2002

//:: BK: Incorporated Pausanias' changes
//:: and moved to x0_inc_generic
//:: left EquipAppropriateWeapons in nw_i0_generic as a wrapper
//:: function passing in whether this creature
//:: prefers RANGED or MELEE attacks
void bkEquipAppropriateWeapons(object oTarget, int nPrefersRanged=FALSE, int nClearActions=TRUE)
{
	// Roster Companions and characters owned by players will not try to switch weapons on their own
	//PrettyDebug(GetName(OBJECT_SELF) + "bkEquipAppropriateWeapons" );
	if (GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF))
		return;
	
	
    // * Associates never try to switch weapons on their own
    // * but original campaign henchmen have to be able to do this.
    int bIAmAHench = GetIsObjectValid(GetMaster());
 //   if (bIAmAHench == TRUE
 //       && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0) return;

     int bEmptyHanded = FALSE;

//    SpawnScriptDebugger();
    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int bIsWieldingRanged = FALSE;
    object oEnemy = GetNearestPerceivedEnemy();

    // * determine if I am wielding a ranged weapon
    bIsWieldingRanged = GetWeaponRanged(oRightHand) && (IsOutOfAmmo(bIAmAHench) == FALSE);

    if (GetIsObjectValid(oRightHand) == FALSE)
    {
        bEmptyHanded = TRUE;
    }


    // * anytime there is no enemy around, try  a ranged weapon
    if (GetIsObjectValid(oEnemy) == FALSE) {
        if (nClearActions)
            ClearActions(CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons1);


        // MODIFIED Feb 11 2003
        // henchmen should not equip ranged weapons here because its outside
        // of the weapon preference code (OC)
        if (bIAmAHench == FALSE)
        {
            bkEquipRanged(OBJECT_INVALID, bIAmAHench);
            return;
        }
    }

    float fDistance = GetDistanceBetween(OBJECT_SELF, oEnemy);

    // * Equip the appropriate weapon for the distance of the enemy.
    // * If enemy is too close AND I do not have The Point Blank feat

    // * Point blank is only useful in Normal or less however (Oct 1 2003 BK)
    int bPointBlankShotMatters = FALSE;
    if (GetHasFeat(FEAT_POINT_BLANK_SHOT) == TRUE)
    {
        bPointBlankShotMatters = TRUE;
    }
    if (GetGameDifficulty()== GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty()== GAME_DIFFICULTY_DIFFICULT)
    {
        bPointBlankShotMatters = FALSE;
    }

    if ((fDistance < MELEE_DISTANCE) && bPointBlankShotMatters == FALSE)
    {
        // If I'm using a ranged weapon, and I'm in close range,
        // AND I haven't already switched to melee, do so now.
        if (bIsWieldingRanged || bEmptyHanded)
        {
            // xp1 henchmen store ranged weapon so I can switch back to it later
            if (bIAmAHench == TRUE && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
                StoreLastRanged();
            //SpawnScriptDebugger();
            bkEquipMelee(oTarget, nClearActions);
        }
    }
    else
    {
        // If I'm not at close range, AND I was told to use a ranged
        // weapon, BUT I switched to melee, switch back to missile.
        if ( ! bIsWieldingRanged && nPrefersRanged)
        {
            if (nClearActions)
                ClearActions(CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons2);
            bkEquipRanged(oTarget, bIAmAHench);
        }
        // * If I am at Ranged distance and I am equipped with a ranged weapon
        // * I might as well stay at range and continue shooting.
        if (bIsWieldingRanged == TRUE)
        {
            return;
        }
        else
        {
            // xp1 henchmen store ranged weapon so I can switch back to it later
            if (bIAmAHench == TRUE && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
                StoreLastRanged();
            bkEquipMelee(oTarget, nClearActions);
        }
    }
}

/*
// EVENFLW version
void bkEquipRanged(object oTarget=OBJECT_INVALID, int bIAmAHench = FALSE, int bForceEquip = FALSE, int bClearAllActions=FALSE)
{	
    if (!GetIsOkToEquipByAI())
        return;

	// if(GetIsOwnedByPlayer(OBJECT_SELF)) return;
    if (bIAmAHench = TRUE 
        && GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") ==  10 
        && !GetAssociateState(NW_ASC_USE_RANGED_WEAPON)) 
    { 
        return;
    }
    
	if(GetLastRanged(bClearAllActions)) 
        return;
        
	if (bIAmAHench 
        || GetIsRosterMember(OBJECT_SELF) 
        || GetIsOwnedByPlayer(OBJECT_SELF)) 
    {
		bkEquipMelee(oTarget, bClearAllActions);
		return;
	}
    
	if(bClearAllActions)
		ClearActions(CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons1);
        
    ActionEquipMostDamagingRanged(oTarget);
}
*/

// * New function February 28 2003. Need a wrapper for ranged
// * so I have quick access to exiting from it for OC henchmen
// * equipping
void bkEquipRanged(object oTarget=OBJECT_INVALID, int bIAmAHenc = FALSE, int bForceEquip = FALSE)
{  // SpawnScriptDebugger();
	// Roster Companions will not try to switch weapons on their own
	//PrettyDebug(GetName(OBJECT_SELF) + "bkEquipRanged" );
	if (GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF))
		return;
	
	
    int bOldHench = FALSE;

    // * old OC henchmen have different equipping rules.
    if (GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") ==  10)
    {
        bOldHench = TRUE;
    }

    // * If I am an XP1 henchmen and I have not been explicitly
    // * told to re-equip a ranged weapon
    // * than don't EVER equip ranged weapons (i.e., if I never
    // * started out with one in my hand then I shouldn't start
    // * using one unless I have no other weapons.
    if (bForceEquip == FALSE && bOldHench == FALSE && bIAmAHenc == TRUE)
    {
        return;
    }

    // * if I am a henchmen and been told to use only melee, I should obey
    if (bIAmAHenc = TRUE && bOldHench == TRUE && GetAssociateState(NW_ASC_USE_RANGED_WEAPON) == FALSE) { return;}
    //SpawnScriptDebugger();

    ActionEquipMostDamagingRanged(oTarget);
}

// * returns true if out of ammo of currently equipped weapons
int IsOutOfAmmo(int bIAmAHenc)
{
    if (1 || bIAmAHenc == FALSE)
    {
		object oWeapon 	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        int nWeaponType = GetBaseItemType(oWeapon);
        object oAmmo 	= OBJECT_INVALID;
		
		// Get what's in item slot based on ranged weapon in our right hand.
        if (nWeaponType == BASE_ITEM_LONGBOW || nWeaponType == BASE_ITEM_SHORTBOW)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
        }
        else
        if (nWeaponType == BASE_ITEM_LIGHTCROSSBOW || nWeaponType == BASE_ITEM_HEAVYCROSSBOW)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
        }
        else
        if (nWeaponType == BASE_ITEM_SLING)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);
        } 
		else 
			return FALSE;

		// Unlimited ammo causes a problem...							
		itemproperty eff=GetFirstItemProperty(oWeapon);
		while(GetIsItemPropertyValid(eff)) 
		{
			if(GetItemPropertyType(eff) == ITEM_PROPERTY_UNLIMITED_AMMUNITION) 
				return FALSE;
			eff = GetNextItemProperty(oWeapon);
		}
		
        if (GetIsObjectValid(oAmmo) == FALSE)
        {
            //PrintString("***out of ammo!!!***");
            return TRUE;
        }
    }
	return FALSE;
}

// not used in new version of bkEquipMelee()
// * checks to see if oUser has ambidexteriy and two weapon fighting
int WiseToDualWield(object oUser)
{

// JLR - OEI 06/03/05 NWN2 3.5 -- Ambidexterity was merged into Two-Weapon Fighting
    if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oUser))
    {
        return TRUE;
    }
    return FALSE;
}

//::///////////////////////////////////////////////
//:: GetIsWeaponLarge
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if this is a large weapon.
    initial purpose: to prevent people from
    swapping between shields and their
    preferred weapon (XP1 Henchmen were doing)

    For now just going with the 12 pound rule


    Ended up not being used...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: May 2, 2003
//:://////////////////////////////////////////////

int GetIsWeaponLarge(object oItem)
{
    if (GetWeight(oItem) > 12)
    {
        return TRUE;
    }
    return FALSE;
}

/*

// EVENFLW version
void bkEquipMelee(object oTarget = OBJECT_INVALID, int nClearActions=TRUE)
{
    if (!GetIsOkToEquipByAI())
        return;
        
    if(GetAssociateState(NW_ASC_USE_RANGED_WEAPON))
        return;

    //if(GetAssociateState(NW_ASC_USE_RANGED_WEAPON) || GetIsOwnedByPlayer(OBJECT_SELF)) return;
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if(GetIsObjectValid(oRight) && MatchMeleeWeapon(oRight))
    {
        return;
    }
	if (GetLastMelee(nClearActions)) 
		return;

	// Roster Membe and auto pref enabled and no right hand object
	if (GetIsRosterMember(OBJECT_SELF) 
		&& !GetGlobalInt(CAMPAIGN_SWITCH_COMPANION_WEAPON_SWAP_AUTO_PFEF_DISABLED)
		&& !GetIsObjectValid(GetLocalObject(OBJECT_SELF, "X0_LM_RIGHTHAND"))) 
		return;
		
	if(GetLevelByClass(CLASS_TYPE_MONK)) {
		if(GetIsObjectValid(oRight)) {
			if(GetBaseItemType(oRight)!=BASE_ITEM_KAMA &&
			   GetBaseItemType(oRight)!=BASE_ITEM_QUARTERSTAFF) {
		        if (nClearActions == TRUE )
            		ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee2);
				ActionUnequipItem(oRight);
				ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND));
				return;
			}
		}
		return;
	}
    if (nClearActions == TRUE)
        ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee1);
	ActionEquipMostDamagingMelee(oTarget);
	oRight=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	if(!GetIsObjectValid(oRight)) return;
	if(!MatchMeleeWeapon(oRight) && IsOutOfAmmo(0)) {
		ActionUnequipItem(oRight);
		return;
	}
	object oLeft=GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
	if(GetIsObjectValid(oLeft) || !GetHasFeat(FEAT_MONKEY_GRIP) && MatchDoubleHandedWeapon(oRight)) return;
    object oShield=OBJECT_INVALID;
    object oItem = GetFirstItemInInventory();
    int iHaveShield = FALSE;
    int nSingle = 0;
    while(GetIsObjectValid(oItem) && (!nSingle || !iHaveShield))
    {
        if(!nSingle && MatchSingleHandedWeapon(oItem) || GetHasFeat(FEAT_MONKEY_GRIP) && MatchDoubleHandedWeapon(oItem))
        {
            nSingle++;
            oLeft = oItem;
        } else if(!iHaveShield && MatchShield(oItem)) {
            iHaveShield = TRUE;
            oShield = oItem;
        }
        oItem=GetNextItemInInventory();
	}
	if(!GetHasFeat(FEAT_SHIELD_PROFICIENCY)) {
		iHaveShield=FALSE;
		oShield=OBJECT_INVALID;
	}
	if(!GetHasFeat(FEAT_TWO_WEAPON_FIGHTING) && !GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING)) {
		nSingle=FALSE;
		oLeft=OBJECT_INVALID;
	}
	int success=FALSE;
	if(nSingle) {
        ActionEquipItem(oLeft,INVENTORY_SLOT_LEFTHAND);
		ActionEquipItem(oLeft,INVENTORY_SLOT_LEFTHAND);
		ActionEquipItem(oLeft,INVENTORY_SLOT_LEFTHAND);
		if(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)==oLeft)
			success=TRUE;

	}
	if(!success && iHaveShield) {
	   	ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
		ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
		ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
	}
}
*/

// Equip melee weapon AND check for shield.
//    nClearActions: If this is False, it won't ever clear actions
//                   The henchmen requipping rules require this (BKNOV2002)
void bkEquipMelee(object oTarget = OBJECT_INVALID, int nClearActions=TRUE)
{
    // * BK Feb 2003: If I am an associate and have been ordered to use ranged
    // * weapons never try to equip my shield
    if (GetAssociateState(NW_ASC_USE_RANGED_WEAPON) == TRUE) { return;}
    //SpawnScriptDebugger();

    int bOldHench = FALSE;
    if (GetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY") ==  10)
    {
        bOldHench = TRUE;
    }

    object oLeftHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND); // What I have in my left hand current
    // * May 2003: If already holding a weapon and I am an XP1 henchmen
    // * do not try to equip another weapon melee weapon.
    // * XP1 henchmen should only switch weapons if going from ranged to melee.
    if (GetIsObjectValid(GetMaster()) && !bOldHench
        // * valid weapon in hand that is NOT a ranged weapon
        && (GetIsObjectValid(oLeftHand) == TRUE && GetWeaponRanged(oLeftHand) == FALSE) )
    {
        return;
    }

    object oShield=OBJECT_INVALID;
    object oLeft=OBJECT_INVALID;
    object oRight=OBJECT_INVALID;

    // Are we already dual-wielding? Don't do anything.
    if (MatchSingleHandedWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) &&
        MatchSingleHandedWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)))
        return;

    // Check for the presence of a shield and the number of
    // single-handed weapons.
    object oSelf = OBJECT_SELF;
    object oItem = GetFirstItemInInventory(oSelf);

    int iHaveShield = FALSE;
    int nSingle = 0;

    while (GetIsObjectValid(oItem))
    {
        if (MatchSingleHandedWeapon(oItem))
        {
            nSingle++;
            if (nSingle == 1)
                oLeft = oItem;
            else if (nSingle == 2)
                oRight = oItem;
            else {
                // see if the one we just found is better?
            }
        } else if (MatchShield(oItem)) {
            iHaveShield = TRUE;
            oShield = oItem;
        }
        oItem = GetNextItemInInventory(oSelf);
   }

   int bAlreadyClearedActions = FALSE;

   // SpawnScriptDebugger();
    // * May 2003 -- Only equip if found a singlehanded weapon that I will equip
    if (GetIsObjectValid(oLeft) && iHaveShield && GetHasFeat(FEAT_SHIELD_PROFICIENCY,oSelf) && (MatchShield(oLeftHand) == FALSE)  )
    {
        if (nClearActions == TRUE)
        {
            ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee1);
        }
        // HACK HACK HACK
        //   Need to do this three times to get the shield to actually equip in certain circumstances
        // HACK HACK HACK 
      //  SpeakString("*******************************************SHIELD");

        // * March 2003 : redundant code, but didn't want to break existing behavior
        if (GetIsObjectValid(oRight) == TRUE || GetIsObjectValid(oLeft))
        {
           // SpeakString("equip melee");
            //ActionEquipMostDamagingMelee(oTarget);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
        }
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        return;
    }
    else if (nSingle >= 2 && WiseToDualWield(OBJECT_SELF))
    {
        // SpeakString("dual-wielding");
        if (nClearActions == TRUE )
            ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee2);
        ActionEquipItem(oRight,INVENTORY_SLOT_RIGHTHAND);
        ActionEquipItem(oLeft,INVENTORY_SLOT_LEFTHAND);
        return;
    }


    // * don't switch to bare hands
    if (GetIsObjectValid(oRight) == TRUE || GetIsObjectValid(oLeft))
    {

        if (nClearActions == TRUE && bAlreadyClearedActions == FALSE)
            ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee3);
        // * It would be better to use ActionEquipMostDamaging here, but it is inconsistent
        if (GetIsObjectValid(oRight) == TRUE)
            ActionEquipItem(oRight,INVENTORY_SLOT_RIGHTHAND);
        else
        if (GetIsObjectValid(oLeft) == TRUE)
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);

        return;
    }

    // Fallback: If I'm still here, try ActionEquipMostDamagingMelee
    ActionEquipMostDamagingMelee(oTarget);

    // * if not melee weapon found then try ranged
    // * April 2003 removed this beccause henchmen sometimes fall down into this
   // bkEquipRanged(oTarget);
}


// * this is just a wrapper around ActionAttack
// * to make sure the creature equips weapons
void WrapperActionAttack(object oTarget)
{

    //AssignCommand(oTarget, SpeakString("eek. They want to kill ME!"));
    // * last minute check to make sure weapons are being used (BKNOV2002)

//    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) == FALSE || GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)) == FALSE) {
        // SpeakString("trying to equip");
   //    SpawnScriptDebugger();
        // Feb 28: Always try to equip weapons at this point
        bkEquipAppropriateWeapons(oTarget,
                                  GetAssociateState(NW_ASC_USE_RANGED_WEAPON));

    ActionAttack(oTarget);
}


//===========================================================================
// Evenflw Functions
//===========================================================================

/*
void StoreLastMelee(object self=OBJECT_SELF)
{
	object master=OBJECT_SELF;
	if(self==master) master=GetCurrentMaster(OBJECT_SELF);
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, self);
	object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, self);
    if ((GetIsObjectValid(oItem1) && MatchMeleeWeapon(oItem1) ||
	!GetIsObjectValid(oItem1) && GetIsObjectValid(oItem2)) &&
	(oItem1!=GetLocalObject(self, "X0_LM_RIGHTHAND") || oItem2!=GetLocalObject(self, "X0_LM_LEFTHAND"))) {
        SetLocalObject(self, "X0_LM_RIGHTHAND", oItem1);
		string weapon="hand and ";
		if(GetIsObjectValid(oItem1))
			weapon=GetName(oItem1)+" and ";
		if(GetIsObjectValid(oItem2)) {
			SetLocalObject(self, "X0_LM_LEFTHAND", oItem2);
			weapon+=GetName(oItem2)+".";	
		} else {
			weapon+="hand.";
			SetLocalObject(self, "X0_LM_LEFTHAND", OBJECT_INVALID);
		}
		if(GetIsPC(master)) SendMessageToPC(master, GetName(self)+" now has a melee preference of "+weapon);
	}
}

void ClearIfEmptyHanded(object self=OBJECT_SELF)
{
	object master=OBJECT_SELF;
	if(self==master) master=GetCurrentMaster(OBJECT_SELF);
	if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, self)) &&
	!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, self))
	&& !GetHasEffect(EFFECT_TYPE_POLYMORPH, self)) {
		if(GetIsPC(master)) SendMessageToPC(master, GetName(self)+" no longer has any weapon preferences.");
		DeleteLocalInt(self, EVENFLW_NUM_MELEE);
		SetLocalObject(self, "X0_L_RIGHTHAND", OBJECT_INVALID);
		SetLocalObject(self, "X0_L_LEFTHAND", OBJECT_INVALID);
		SetLocalObject(self, "X0_LM_RIGHTHAND", OBJECT_INVALID);
		SetLocalObject(self, "X0_LM_LEFTHAND", OBJECT_INVALID);
	}
}

int GetLastMelee(int Clear=FALSE)
{
	object oItem1=GetLocalObject(OBJECT_SELF, "X0_LM_RIGHTHAND");
	object oItem2=GetLocalObject(OBJECT_SELF, "X0_LM_LEFTHAND");
	if(GetIsObjectValid(oItem1) && GetItemPossessor(oItem1)==OBJECT_SELF ||
	GetIsObjectValid(oItem2) && GetItemPossessor(oItem2)==OBJECT_SELF) {
        if(Clear == TRUE)
            ClearActions(CLEAR_X0_I0_EQUIP_EquipMelee1);
		ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
		ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND));
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		if(GetIsObjectValid(oItem2) && GetItemPossessor(oItem2)==OBJECT_SELF) {
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
		}
		return TRUE;	
	}
	return FALSE;
}

int GetLastRanged(int Clear=FALSE) 
{
	object oItem1=GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND");
	object oItem2=GetLocalObject(OBJECT_SELF, "X0_L_LEFTHAND");
	if(GetIsObjectValid(oItem1) && GetItemPossessor(oItem1)==OBJECT_SELF) {
		itemproperty eff=GetFirstItemProperty(oItem1);
		while(GetIsItemPropertyValid(eff)) {
			if(GetItemPropertyType(eff)==ITEM_PROPERTY_UNLIMITED_AMMUNITION) {
				object master=GetCurrentMaster(OBJECT_SELF);
				if(GetIsObjectValid(master) && GetIsPC(master)) SendMessageToPC(master, GetName(OBJECT_SELF)+" cannot switch to his/her infinite ammo ranged weapon (game would crash).");
				return FALSE;
			}
			eff=GetNextItemProperty(oItem1);
		}
        if(Clear == TRUE)
            ClearActions(CLEAR_X0_I0_EQUIP_EquipAppropriateWeapons1);
		ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
		ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND));
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		ActionEquipItem(oItem1, INVENTORY_SLOT_RIGHTHAND);
		if(GetIsObjectValid(oItem2) && GetItemPossessor(oItem2)==OBJECT_SELF) {
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
			ActionEquipItem(oItem2, INVENTORY_SLOT_LEFTHAND);
		}
		return TRUE;	
	}
	return FALSE;
}
*/

/* void main() {} /* */
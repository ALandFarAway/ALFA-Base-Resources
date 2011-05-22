// gui_cntx_hench_action
/*
	Behavior script for the character sheet behavior sub-panel
*/

#include "gui_bhvr_inc"

#include "ginc_companion"

#include "hench_i0_assoc"
#include "hench_i0_target"
#include "hench_i0_equip"


const int HENCH_CNTX_MENU_PC     = 1;
const int HENCH_CNTX_MENU_SELF   = 2;
const int HENCH_CNTX_MENU_ALL    = 3;


void StartUpCommands(object oSelf, object oTarget, int nType)
{
    SetPlayerQueuedTarget(oSelf, OBJECT_INVALID);
	HenchResetHenchmenState();
    SetLocalInt(oSelf, henchHealCountStr, 1);
    SetLocalObject(oSelf, henchHealSpellTarget, oTarget);
    SetLocalInt(oSelf, henchHealTypeStr, nType);
    SetLocalInt(oSelf, henchHealStateStr, HENCH_CNTX_MENU_BUFF_LONG);
    ExecuteScript("hench_o0_heal", oSelf);
}
            

void HenchStartUpCommand(int nType, int nTarget, object oCaster)
{
    object oTarget;
        
	if (nTarget == HENCH_CNTX_MENU_ALL)
	{
		oTarget = OBJECT_INVALID;
	}
	else if (nTarget == HENCH_CNTX_MENU_SELF)
	{
		oTarget = oCaster;
	}
	else
	{
		oTarget = GetControlledCharacter(OBJECT_SELF);
	}        
//    Jug_Debug("set type" + IntToString(nType) + " target " + IntToString(nTarget) + " caster " + GetName(oCaster) + " target " + GetName(oTarget));
    AssignCommand(oCaster, StartUpCommands(oCaster, oTarget, nType));   
}


// start up command on all non PCs in party
void HenchStartUpCommandAll(int nType, int nTarget)
{
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
 		if (!(GetIsPC(oPartyMember) && GetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF)))
		{
			HenchStartUpCommand(nType, nTarget, oPartyMember);
		}
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

void HenchDoScout(object oSpeaker)
{
    object oClosest =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                        oSpeaker, 1);
    if (GetIsObjectValid(oClosest) && GetDistanceBetween(oClosest, oSpeaker) <= henchMaxScoutDistance)
    {
        SetLocalInt(OBJECT_SELF, sHenchScoutingFlag, TRUE);
        SetLocalObject(OBJECT_SELF, sHenchScoutTarget, oClosest);
        ClearAllActions();
        if (CheckStealth())
        {
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
        ActionMoveToObject(oClosest, FALSE, 1.0);
    }
    else
    {
		//	indicate failure?
		SendMessageToPC(oSpeaker, sHenchSafeEnough);
        DeleteLocalInt(OBJECT_SELF, sHenchScoutingFlag);
    }
}

// reset follow on entire party
void HenchResetFollow()
{
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		HenchSetDefaultLeader(oPartyMember);
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

// follow no one on entire party
void HenchResetFollowAll()
{
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		if (GetAssociateType(oPartyMember) == ASSOCIATE_TYPE_NONE)
		{
			HenchSetNoLeader(oPartyMember);
		}
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}

// reset guard on entire party
void HenchResetGuard()
{
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(OBJECT_SELF, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		HenchSetDefaultDefendee(oPartyMember);
        oPartyMember = GetNextFactionMember(OBJECT_SELF, FALSE);
    }
}


// auto set follow order
void HenchSetAutoSetFollow(object oLeader, int columns)
{
	// sort party members by BAB
	DeleteLocalObject(oLeader, henchAllyStr);
    object oPartyMember = GetFirstFactionMember(oLeader, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		if ((oPartyMember != oLeader) && (GetAssociateType(oPartyMember) == ASSOCIATE_TYPE_NONE))
		{
			int memberBAB = GetBaseAttackBonus(oPartyMember);
			int memberAC = GetAC(oPartyMember);
			object oPrevTestObject = oLeader;
			object oTestObject = GetLocalObject(oLeader, henchAllyStr);		  
	  		while (GetIsObjectValid(oTestObject))
			{
				int testBAB = GetBaseAttackBonus(oTestObject);				
				if (testBAB < memberBAB)
				{
					break;			
				}
				if ((testBAB == memberBAB) && (GetAC(oTestObject) < memberAC))
				{
					break;
				}					
				oPrevTestObject = oTestObject;
				oTestObject = GetLocalObject(oTestObject, henchAllyStr);
			}				
			SetLocalObject(oPrevTestObject, henchAllyStr, oPartyMember);
			SetLocalObject(oPartyMember, henchAllyStr, oTestObject);
		}
        oPartyMember = GetNextFactionMember(oLeader, FALSE);
    }
	
	HenchSetNoLeader(oLeader);
	int columnNumber;
	for (columnNumber = 0; columnNumber < columns; columnNumber++)
	{	
		object oCurLeader = oLeader;
		int curMemberCount;
	
		oPartyMember = GetLocalObject(oLeader, henchAllyStr);
		while (GetIsObjectValid(oPartyMember))
		{
//			Jug_Debug("checking " + GetName(oPartyMember));
			if ((curMemberCount % columns) == columnNumber)
			{
//				Jug_Debug(GetName(oPartyMember) + " set leader to " + GetName(oCurLeader));
				SetAssociateState(NW_ASC_DISTANCE_2_METERS, TRUE, oPartyMember);
				SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE, oPartyMember);
				SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE, oPartyMember);
				HenchSetLeader(oPartyMember, oCurLeader);
				oCurLeader = oPartyMember;			
			}			
			curMemberCount ++;			
			oPartyMember = GetLocalObject(oPartyMember, henchAllyStr);
		}	
	}
}


void ResetWeaponPreference(object oTarget, int iWeaponType)
{
	string weaponPrefString = GetTag(oTarget) + HENCH_AI_STORED_PREF_WEAPON;
	object oTest;
	switch (iWeaponType)
	{
		case HENCH_AI_STORED_MELEE_FLAG:
			DeleteLocalInt(oTarget, weaponPrefString);			
		case HENCH_AI_STORED_RANGED_FLAG:
			oTest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
			break;
		case HENCH_AI_STORED_SHIELD_FLAG:
		case HENCH_AI_STORED_OFF_HAND_FLAG:
			oTest = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
			break;
	}
	if (GetIsObjectValid(oTest))
	{
		if (GetLocalInt(oTest, weaponPrefString) == iWeaponType)
		{
//			Jug_Debug("deleting weapon pref for " + GetName(oTest));
			DeleteLocalInt(oTest, weaponPrefString);
		}
	}
	oTest = GetFirstItemInInventory(oTarget);
	while (GetIsObjectValid(oTest))
	{
		if (GetLocalInt(oTest, weaponPrefString) == iWeaponType)
		{
//			Jug_Debug("deleting weapon pref for " + GetName(oTest));
			DeleteLocalInt(oTest, weaponPrefString);
		}
		oTest = GetNextItemInInventory(oTarget);	
	}
}


void HenchSetAIWeapons(object oTarget, object oWeapon, int iWeaponType)
{
	if (iWeaponType == HENCH_AI_STORED_MELEE_FLAG)
	{
		if (oWeapon == oTarget)
		{
			if (!GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oTarget) ||
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget)) ||	
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget)) ||	
				!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget)))
			{
				SpeakString(GetName(oWeapon) + sHenchNotAMeleeWeapon);
				return;			
			}	
		}
		else if ((GetWeaponType(oWeapon) == WEAPON_TYPE_NONE) || GetWeaponRanged(oWeapon))
		{
			SpeakString(GetName(oWeapon) + sHenchNotAMeleeWeapon);
			return;
		}		
		SetLocalObject(oTarget, HENCH_AI_STORED_MELEE, oWeapon);	
	}
	else if (iWeaponType == HENCH_AI_STORED_RANGED_FLAG)
	{
		if (!GetWeaponRanged(oWeapon))
		{
			SpeakString(GetName(oWeapon) + sHenchNotARangedWeapon);
			return;
		}		
		SetLocalObject(oTarget, HENCH_AI_STORED_RANGED, oWeapon);		
	}
	else if (iWeaponType == HENCH_AI_STORED_SHIELD_FLAG)
	{
		int nItemType = GetBaseItemType(oWeapon);
		if ((nItemType != BASE_ITEM_TOWERSHIELD) && (nItemType != BASE_ITEM_LARGESHIELD) &&
			(nItemType != BASE_ITEM_SMALLSHIELD) && (nItemType != BASE_ITEM_TORCH))
		{
			SpeakString(GetName(oWeapon) + sHenchNotAShield);
			return;
		}		
		SetLocalObject(oTarget, HENCH_AI_STORED_SHIELD, oWeapon);
	}
	else if (iWeaponType == HENCH_AI_STORED_OFF_HAND_FLAG)
	{
		if ((GetWeaponType(oWeapon) == WEAPON_TYPE_NONE) || GetWeaponRanged(oWeapon))
		{
			SpeakString(GetName(oWeapon) + sHenchNotAMeleeWeapon);
			return;
		}		
		SetLocalObject(oTarget, HENCH_AI_STORED_OFF_HAND, oWeapon);	
	}	
	else
	{
		// error calling, return
//		Jug_Debug("error calling HenchSetAIWeapons"); 
	}
	
	ResetWeaponPreference(oTarget, iWeaponType);
	string weaponPrefString = GetTag(oTarget) + HENCH_AI_STORED_PREF_WEAPON;
	SetLocalInt(oWeapon, weaponPrefString, iWeaponType);
	SetLocalInt(oTarget, HENCH_AI_STORED_PREF_WEAPON, GetLocalInt(oTarget, HENCH_AI_STORED_PREF_WEAPON) | iWeaponType);
}


void main(int nType, int nKind, int nTarget)
{
//	 Jug_Debug("gui_cntx_hench_action master " + GetName(GetMaster()) + 
//       " last speaker " + GetName(GetLastSpeaker()) + " self " + GetName(OBJECT_SELF) + " controlled " + GetName(GetControlledCharacter(OBJECT_SELF)));        
//  	 Jug_Debug("gui_cntx_hench_action type " + IntToString(nType) + " kind " +
//        IntToString(nKind) + " target " + IntToString(nTarget));

	object oSpeaker = GetControlledCharacter(OBJECT_SELF);

	switch (nType)
	{
	case HENCH_CNTX_MENU_PC_ATTACK_NEAREST:
//		Jug_Debug(GetName(oSpeaker) + " attack nearest");
        SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE, oSpeaker);
        SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE, oSpeaker);
		DeleteLocalInt(oSpeaker, sHenchDontAttackFlag);
		break;
	case HENCH_CNTX_MENU_PC_FOLLOW_MASTER:
//		Jug_Debug(GetName(oSpeaker) + " follow");	
		SetLocalInt(oSpeaker, sHenchDontAttackFlag, TRUE);
		DeleteLocalInt(oSpeaker, sHenchScoutingFlag);
		SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE, oSpeaker);
		break;
	case HENCH_CNTX_MENU_PC_GUARD_MASTER:
//		Jug_Debug(GetName(oSpeaker) + " guard");
		DeleteLocalInt(oSpeaker, sHenchDontAttackFlag);
		//Companions will only attack the Masters Last Attacker
		SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE, oSpeaker);
		SetAssociateState(NW_ASC_MODE_STAND_GROUND, FALSE, oSpeaker);
		break;
	case HENCH_CNTX_MENU_PC_STAND_GROUND:
//		Jug_Debug(GetName(oSpeaker) + " stand ground");
		SetAssociateState(NW_ASC_MODE_STAND_GROUND, TRUE, oSpeaker);
		SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE, oSpeaker);
		break;
	case HENCH_CNTX_MENU_SCOUT:
//		Jug_Debug(GetName(oSpeaker) + " scout");
		if (GetAssociateType(GetPlayerCurrentTarget(oSpeaker)) != ASSOCIATE_TYPE_NONE)
		{
        	AssignCommand(GetPlayerCurrentTarget(oSpeaker), HenchDoScout(oSpeaker));
		}
		else
		{
			SendMessageToPC(oSpeaker, sHenchNoScoutCompanions);
		}
		break;
	case HENCH_CNTX_MENU_FOLLOW_TARGET:
		HenchSetLeader(oSpeaker, GetPlayerCurrentTarget(oSpeaker));
		break;	
	case HENCH_CNTX_MENU_FOLLOW_ME:
		HenchSetLeader(GetPlayerCurrentTarget(oSpeaker), oSpeaker);
		break;			
	case HENCH_CNTX_MENU_FOLLOW_NO_ONE:
		HenchSetNoLeader(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_FOLLOW_RESET:
		HenchSetDefaultLeader(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_FOLLOW_RESET_ALL:
		HenchResetFollowAll();
		break;
	case HENCH_CNTX_MENU_GUARD_TARGET:
		HenchSetDefendee(oSpeaker, GetPlayerCurrentTarget(oSpeaker));
		break;	
	case HENCH_CNTX_MENU_GUARD_ME:
		HenchSetDefendee(GetPlayerCurrentTarget(oSpeaker), oSpeaker);
		break;			
	case HENCH_CNTX_MENU_GUARD_RESET:
		HenchSetDefaultDefendee(nKind ? oSpeaker : GetPlayerCurrentTarget(oSpeaker));
		break;
	case HENCH_CNTX_MENU_GUARD_RESET_ALL:
		HenchResetGuard();
		break;
	case HENCH_CNTX_MENU_FOLLOW_SINGLE:
		 HenchSetAutoSetFollow(oSpeaker, 1);
		break;
	case HENCH_CNTX_MENU_FOLLOW_DOUBLE:
		HenchSetAutoSetFollow(oSpeaker, 2);
		break;
	case HENCH_CNTX_MENU_FOLLOW_NO_ONE_ALL:
		HenchResetFollowAll();	
		break;
	case HENCH_CNTX_MENU_SET_WEAPON:
		{
			object oTargetObject;
			if (nKind != -1)
			{
				oTargetObject = IntToObject(nKind);
			}
			else
			{
				oTargetObject = oSpeaker;
			}
			HenchSetAIWeapons(oSpeaker, oTargetObject, nTarget);
			ChangeEquippedWeapons(oSpeaker);
		}
		break;
	case HENCH_CNTX_MENU_RESET_WEAPON:
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_MELEE_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_RANGED_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_SHIELD_FLAG);
		ResetWeaponPreference(oSpeaker, HENCH_AI_STORED_OFF_HAND_FLAG);
		DeleteLocalInt(oSpeaker, HENCH_AI_STORED_PREF_WEAPON);		
		ChangeEquippedWeapons(oSpeaker);
		break;
		
	
// TODO	case 300:	
	
//		SetScriptHidden(GetPlayerCurrentTarget(oSpeaker), TRUE, FALSE);
// TODO test this	SetIsCompanionPossessionBlocked( object oCreature, int bBlocked );
	
/*	case HENCH_SAVE_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			nResult = GetGlobalInt(HenchGlobalOptionsStr);
			SetCampaignInt(HENCH_CAMPAIGN_DB, HenchGlobalOptionsStr, nResult);
			// party settings
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));
    		nResult = GetLocalInt(oPlayerCharacter, henchPartySettings);
			SetCampaignInt(HENCH_CAMPAIGN_DB, henchPartySettings, nResult);
		}
		break;
	case HENCH_LOAD_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, HenchGlobalOptionsStr);
			nResult |= HENCH_OPTION_SET_ONCE;
    		SetGlobalInt(HenchGlobalOptionsStr, nResult);
			// party settings
			nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, henchPartySettings);			
			nResult |= HENCH_OPTION_SET_ONCE;
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));			
    		SetLocalInt(oPlayerCharacter, henchPartySettings, nResult);
		}
		break;
	case HENCH_RESET_GLOBAL_SETTINGS:
		{
			int nResult;
			// global settings
			SetCampaignInt(HENCH_CAMPAIGN_DB, HenchGlobalOptionsStr, 0);
			nResult = HENCH_OPTION_SET_ONCE;
    		SetGlobalInt(HenchGlobalOptionsStr, nResult);
			// party settings
			SetCampaignInt(HENCH_CAMPAIGN_DB, henchPartySettings, 0);			
			nResult = HENCH_OPTION_SET_ONCE;
    		object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oSpeaker));			
    		SetLocalInt(oPlayerCharacter, henchPartySettings, nResult);
		}
		break;*/
	default:
		if (nType < 100)	// check for accidental out of range calls
		{
			if (nKind)
			{
				HenchStartUpCommandAll(nType, nTarget);
			}
		    else
		    {
		        HenchStartUpCommand(nType, nTarget, GetPlayerCurrentTarget(oSpeaker));
			}
		}	
	}
}
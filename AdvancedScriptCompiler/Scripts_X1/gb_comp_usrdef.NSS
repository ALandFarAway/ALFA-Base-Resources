// gb_comp_userdef
/*
    companion On User Defined 
*/   
// ChazM 12/5/05
// ChazM 12/7/05 added DoBrawl(), restructured main(), added comments
// ChazM 5/18/05 reference to master now uses GetCurrentMaster() - returns master for associate or companion
// BMA-OEI 7/14/06 Added EVENT_ROSTER_SPAWN_IN handler: ForceRest OnSpawnIn (Removed to prevent healing on Load Game)
// DBR - 08/03/06 added support for NW_ASC_MODE_PUPPET
// DBR - 08/11/06 Removed Khelgar brawling animation scripts
// BMA-OEI 09/12/06 -- Added EVENT_PLAYER_CONTROL_CHANGED handler
// BMA-OEI 09/20/06 -- CheckForDisabledPartyMembers(): Disable spell casting while Polymorphed
// BMA-OEI 10/08/06 -- Added HandleRosterSpawnIn(): Campaign check to set Plot Flag FALSE

//:://////////////////////////////////////////////////
//:: X0_CH_HEN_USRDEF
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////

#include "X0_INC_HENAI"
#include "ginc_companion"
#include "hench_i0_hensho"
#include "ginc_overland"

// -----------------------------------------------------------------
// Prototypes
// -----------------------------------------------------------------

// Try to cast nSpell on oMaster. returns 1 on success, 0 on failure.
int CheckSpell(int nSpell, object oMaster);

// Try to cast a restorative spell if the master has a spell effect
// that prevents him from talking to the henchmen and asking for help (hold, fear, confusion etc')
// The henchmen would also try to help other disabled henchmen.
// The henchmen would try to cast dispel-magic spells to remove disabling spells from the player
// unless the player told him not to do it (since it might dispel other helpful buffing spells).
void CheckForDisabledPartyMembers();


// Try to cast nSpell on oMaster. returns 1 on success, 0 on failure.
int CheckSpell(int nSpell, object oMaster);

// Try to cast a restorative spell if the master has a spell effect
// that prevents him from talking to the henchmen and asking for help (hold, fear, confusion etc')
// The henchmen would also try to help other disabled henchmen.
// The henchmen would try to cast dispel-magic spells to remove disabling spells from the player
// unless the player told him not to do it (since it might dispel other helpful buffing spells).
void CheckForDisabledPartyMembers();

// Event handler for EVENT_ROSTER_SPAWN_IN
// If Campaign Flag is set and OBJECT_SELF is spawned into the PC Party,
// Set Plot Flag FALSE ( Invulnerability safety for saving/loading before CombatCutsceneCleanUp )
void HandleRosterSpawnIn();


// -----------------------------------------------------------------
// Functions
// -----------------------------------------------------------------
/*
int ACTION_MODE_DETECT                  = 0;
int ACTION_MODE_STEALTH                 = 1;
int ACTION_MODE_PARRY                   = 2;
int ACTION_MODE_POWER_ATTACK            = 3;
int ACTION_MODE_IMPROVED_POWER_ATTACK   = 4;
int ACTION_MODE_COUNTERSPELL            = 5;
int ACTION_MODE_FLURRY_OF_BLOWS         = 6;
int ACTION_MODE_RAPID_SHOT              = 7;
int ACTION_MODE_COMBAT_EXPERTISE               = 8;
int ACTION_MODE_IMPROVED_COMBAT_EXPERTISE      = 9;
int ACTION_MODE_DEFENSIVE_CAST          = 10;
int ACTION_MODE_DIRTY_FIGHTING          = 11;
*/
void main()
{
    int nEvent = GetUserDefinedEventNumber();
    string sUDScript=GetLocalString(OBJECT_SELF,"ud_script");
    if (sUDScript != "")
    {
        ExecuteScript(sUDScript, OBJECT_SELF);
    }

    switch (nEvent)
    {
// ----------------------------------------------------
// Alter w/ care.  These affect everyone.
// ----------------------------------------------------
// To toggle on/off individually for a creature, use:
// SetSpawnInCondition(int nCondition, int bValid = TRUE)
//
//
//      case EVENT_HEARTBEAT:   // 1001 - NW_FLAG_HEARTBEAT_EVENT
//          break;
//
//      case EVENT_PERCEIVE:    // 1002 - NW_FLAG_PERCIEVE_EVENT
//          break;
//
//      case EVENT_END_COMBAT_ROUND:    // 1003 - NW_FLAG_END_COMBAT_ROUND_EVENT
//          break;
//
//      case EVENT_DIALOGUE:    // 1004 - NW_FLAG_ON_DIALOGUE_EVENT
//          break;
//
//      case EVENT_ATTACKED:    // 1005 - NW_FLAG_ATTACK_EVENT
//          break;
//
//      case EVENT_DAMAGED:     // 1006 - NW_FLAG_DAMAGED_EVENT
//          break;
//
//      case EVENT_DISTURBED:   // 1008 - NW_FLAG_DISTURBED_EVENT
//          break;
//
//      case EVENT_SPELL_CAST_AT:   // 1011 - NW_FLAG_SPELL_CAST_AT_EVENT
//          break;

// ----------------------------------------------------
// Events specific to campaign companions.
// ----------------------------------------------------

// General      2000 - 2099
// AMMON        2100 - 2199
// BISHOP       2200 - 2299
// CASAVIR      2300 - 2399
// CONSTRUCT    2400 - 2499
// ELANEE       2500 - 2599
// GROBNAR      2600 - 2699
// KHELGAR      2700 - 2799
// NEESHKA      2800 - 2899
// QARA         2900 - 2999
// SAND         3000 - 3099
// SHANDRA      3100 - 3199
// ZHJAEVE      3200 - 3299

// ----------------------------------------------------
// Alter w/ care.  These affect everyone.
// ----------------------------------------------------


        case EVENT_ROSTER_SPAWN_IN: // 2051: Roster Member SpawnIn Event ( via Script, GUI, Load Game )
        {
            HandleRosterSpawnIn();
            break;
        }

        case EVENT_PLAYER_CONTROL_CHANGED: // 2052
		case EVENT_TRANSFER_PARTY_LEADER:
        {
			if(GetIsOverlandMap(GetArea(OBJECT_SELF)))
			{
				PrettyDebug("gb_comp_userdef firing for" + GetName(OBJECT_SELF));
				object oOldActor = GetLocalObject(GetModule(), "oPartyLeader");
				if(GetIsPC(OBJECT_SELF) && oOldActor != OBJECT_SELF)
				{
					if(GetCommandable(OBJECT_SELF) && !GetIsDead(OBJECT_SELF) &&
				  	  (GetIsRosterMember(OBJECT_SELF) || GetIsOwnedByPlayer(OBJECT_SELF)) ) 
					{
						SetPartyActor(OBJECT_SELF);
					}
				
					else
						SetPartyActor(oOldActor, OBJECT_SELF);
				}
			}
			
  			if (GetAssociateState(NW_ASC_MODE_PUPPET)==TRUE)    //NLC 7/02/08. I am a puppet. I put nothing on the ActionQueue myself.
            	break;

//			Jug_Debug(GetName(OBJECT_SELF) + " handle player control change");
            HenchHandlePlayerControlChanged(OBJECT_SELF);
            HenchResetCombatRound();
            ClearEnemyLocation();
            DeleteLocalInt(OBJECT_SELF, henchHealCountStr);
            break;
        }

        case 20000: // 20000 + ACTION_MODE_DETECT
        {
            if (GetAssociateState(NW_ASC_MODE_PUPPET)==TRUE)    //DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
                break;

            if (!GetIsFighting(OBJECT_SELF))
            {
                int bDetect = GetActionMode(GetMaster(), ACTION_MODE_DETECT);
                RelayModeToAssociates(ACTION_MODE_DETECT, bDetect);
            }
            break;
        }

        case 20001: // 20000 + ACTION_MODE_STEALTH
        {
            if (GetAssociateState(NW_ASC_MODE_PUPPET)==TRUE)    //DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
                break;

            if (!GetIsFighting(OBJECT_SELF) && !GetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE))
            {
                int bStealth = GetActionMode(GetMaster(), ACTION_MODE_STEALTH);
                RelayModeToAssociates(ACTION_MODE_STEALTH, bStealth);
            }
            break;
        }


        // * This event is triggered whenever an NPC or PC in the party
        // * is disabled (or potentially disabled).
        // * This is a migration of a useful heartbeat routine Yaron made
        // * into a less AI extensive route
/*  This is done a different way, not needed
        case 46500:
        {
            CheckForDisabledPartyMembers();
            break;
        } */
    }
}


int CheckSpell(int nSpell, object oMaster)
{
    if(GetHasSpell(nSpell))
    {
        ClearAllActions();
        ActionCastSpellAtObject(nSpell, oMaster);
        return 1;
    }
    return 0;
}

// Check whether the creature has disabling effects that are magical and therefor and can removed by
// dispel magic spells.
int HasDisablingMagicalEffect(object oCreature)
{
    effect eEff = GetFirstEffect(oCreature);
    while(GetIsEffectValid(eEff))
    {
        if(GetEffectType(eEff) == EFFECT_TYPE_CONFUSED ||
           GetEffectType(eEff) == EFFECT_TYPE_PARALYZE ||
           GetEffectType(eEff) == EFFECT_TYPE_FRIGHTENED ||
           GetEffectType(eEff) == EFFECT_TYPE_DOMINATED ||
           GetEffectType(eEff) == EFFECT_TYPE_DAZED ||
           GetEffectType(eEff) == EFFECT_TYPE_STUNNED)
        {
            if(GetEffectSubType(eEff) == SUBTYPE_MAGICAL)
                return TRUE; // can be dispelled
            else
                return FALSE;
        }
        eEff = GetNextEffect(oCreature);
    }
    return FALSE;
}

// Checks a single creature for disabling effects, trying to remove them if possible.
void CheckCreature(object oCreature)
{
    // First, trying to cast specific-purpose spells and then trying more general spells.
    if(GetHasEffect(EFFECT_TYPE_FRIGHTENED, oCreature))
        if(CheckSpell(SPELL_REMOVE_FEAR, oCreature)) return;
    if(GetHasEffect(EFFECT_TYPE_PARALYZE, oCreature))
        if(CheckSpell(SPELL_REMOVE_PARALYSIS, oCreature)) return;

    if(GetHasEffect(EFFECT_TYPE_CONFUSED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_FRIGHTENED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_PARALYZE, oCreature) ||
       GetHasEffect(EFFECT_TYPE_DOMINATED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_DAZED, oCreature) ||
       GetHasEffect(EFFECT_TYPE_STUNNED, oCreature))
    {
        if(CheckSpell(SPELL_GREATER_RESTORATION, oCreature)) return;
        if(CheckSpell(SPELL_RESTORATION, oCreature)) return;
        if(HasDisablingMagicalEffect(oCreature) &&
            GetLocalInt(OBJECT_SELF, "X2_HENCH_DO_NOT_DISPEL") == 0)
        {
            if(CheckSpell(SPELL_GREATER_DISPELLING, oCreature)) return;
            if(CheckSpell(SPELL_DISPEL_MAGIC, oCreature)) return;
            if(CheckSpell(SPELL_LESSER_DISPEL, oCreature)) return;
        }

    }
}

void CheckForDisabledPartyMembers()
{
    // BMA-OEI 9/20/06: Disable spell casting while Polymorphed
    if ( GetHasEffect( EFFECT_TYPE_POLYMORPH ) == TRUE )
    {
        return;
    }

    object oMaster = GetCurrentMaster(); //GetPCLeader(OBJECT_SELF);
    if(oMaster != OBJECT_INVALID)
        CheckCreature(oMaster);
    int i = 1;
    object oHench = GetHenchman(oMaster, i);
    while(oHench != OBJECT_INVALID)
    {
        CheckCreature(oHench);
        i++;
        oHench = GetHenchman(oMaster, i);
    }
}

// Event handler for EVENT_ROSTER_SPAWN_IN
// If Campaign Flag is set and OBJECT_SELF is spawned into the PC Party,
// Set Plot Flag FALSE ( Invulnerability safety for saving/loading before CombatCutsceneCleanUp )
void HandleRosterSpawnIn()
{
    // Campaign flag set OnModuleLoad
    if ( GetGlobalInt( CAMPAIGN_SWITCH_UNPLOT_ON_ROSTER_SPAWN ) == TRUE )
    {
        // If OBJECT_SELF is in FirstPC's Party
        if ( GetIsObjectInParty( OBJECT_SELF ) == TRUE )
        {
            SetPlotFlag( OBJECT_SELF, FALSE );
        }
    }
}
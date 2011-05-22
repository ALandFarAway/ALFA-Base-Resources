// gui_bhvr_inc
/*
	include file for the GUI Behavior related scripts:
	gui_bhvr_follownear
	gui_bhvr_followmed
	gui_bhvr_followfar
	gui_bhvr_def_master_on
	gui_bhvr_def_master_off
	gui_bhvr_retry_locks_on
	gui_bhvr_retry_locks_off
	gui_bhvr_stealth_none
	gui_bhvr_stealth_perm
	gui_bhvr_stealth_temp
	gui_bhvr_disarm_on
	gui_bhvr_disarm_off
	gui_bhvr_dispel_on
	gui_bhvr_dispel_off
	gui_bhvr_casting_overkill
	gui_bhvr_casting_power
	gui_bhvr_casting_scaled
	gui_bhvr_casting_off
	gui_bhvr_item_use_on
	gui_bhvr_item_use_off
	gui_bhvr_feat_use_on
	gui_bhvr_feat_use_off
	gui_bhvr_combat_mode_use_on
	gui_bhvr_combat_mod_use_off
		
	gui_bhvr_a_follownear
	gui_bhvr_a_followmed
	gui_bhvr_a_followfar
	gui_bhvr_a_def_master_on
	gui_bhvr_a_def_master_off
	gui_bhvr_a_retry_locks_on
	gui_bhvr_a_retry_locks_off
	gui_bhvr_a_stealth_none
	gui_bhvr_a_stealth_perm
	gui_bhvr_a_stealth_temp
	gui_bhvr_a_disarm_on
	gui_bhvr_a_disarm_off
	gui_bhvr_a_dispel_on
	gui_bhvr_a_dispel_off
	gui_bhvr_a_casting_overkill
	gui_bhvr_a_casting_power
	gui_bhvr_a_casting_scaled
	gui_bhvr_a_casting_off	
	gui_bhvr_a_item_use_on
	gui_bhvr_a_item_use_off
	gui_bhvr_a_feat_use_on
	gui_bhvr_a_feat_use_off
	gui_bhvr_a_combat_mode_use_on
	gui_bhvr_a_combat_mod_use_off

*/
// ChazM 4/26/06
// ChazM 5/25/06 - script now runs on player owned character - functions modified to reference currently controlled character
// ChazM 5/26/06 - removed debugs
// ChazM 7/26/06 - Added casting_overkill, casting_power, casting_scaled, removed casting_on
// ChazM 8/4/06 - Added support for full party controls (all buttons)
// ChazM 8/7/06 - Added support for item use
// ChazM 8/8/06 - Added support for ability/feat use
// ChazM 8/9/06 - Added support for puppet mode
// BMA-OEI 10/12/06 - Added support for combat mode use (N2_COMBAT_MODE_USE_DISABLED)
// ChazM 11/9/06 - Examined Creature update
// ChazM 2/12/07 - updated GuiBehaviorInit() with influence display
// ChazM 7/19/07 - Added AIMode support
// ChazM 7/23/07 - AIMode update

//void main(){}
#include "x0_i0_assoc"
#include "ginc_debug"
#include "x0_i0_talent"
#include "ginc_math"

//=====================================
// Constants
//=====================================

const string GUI_SCREEN_PLAYERMENU				= "SCREEN_PLAYERMENU";
const string GUI_PLAYERMENU_AI_OFF_BUTTON		= "AI_OFF_BUTTON";
const string GUI_PLAYERMENU_AI_ON_BUTTON		= "AI_ON_BUTTON";
const string GUI_PLAYERMENU_AI_MIXED_BUTTON		= "AI_MIXED_BUTTON";


const string SCREEN_CHARACTER 					= "SCREEN_CHARACTER";
const string SCREEN_CREATUREEXAMINE				= "SCREEN_CREATUREEXAMINE";
const string BEHAVIORDESC_TEXT 					= "BEHAVIORDESC_TEXT";

const string BEHAVIOR_FOLLOWDIST_NEAR 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR";
const string BEHAVIOR_FOLLOWDIST_MED 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED";
const string BEHAVIOR_FOLLOWDIST_FAR 			= "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR";

const string BEHAVIOR_DEF_MASTER_ON 			= "BEHAVIOR_DEF_MASTER_STATE_BUTTON_ON";
const string BEHAVIOR_DEF_MASTER_OFF 			= "BEHAVIOR_DEF_MASTER_STATE_BUTTON_OFF";

const string BEHAVIOR_RETRY_LOCKS_ON			= "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_ON";
const string BEHAVIOR_RETRY_LOCKS_OFF			= "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_OFF";

const string BEHAVIOR_STEALTH_MODE_NONE			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_NONE"; // 0
const string BEHAVIOR_STEALTH_MODE_PERM			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_PERM"; // 1
const string BEHAVIOR_STEALTH_MODE_TEMP			= "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_TEMP"; // 2

const string BEHAVIOR_DISARM_TRAPS_ON			= "BEHAVIOR_DISARM_STATE_BUTTON_ON";
const string BEHAVIOR_DISARM_TRAPS_OFF			= "BEHAVIOR_DISARM_STATE_BUTTON_OFF";

const string BEHAVIOR_DISPEL_ON					= "BEHAVIOR_DISPEL_STATE_BUTTON_ON";
const string BEHAVIOR_DISPEL_OFF				= "BEHAVIOR_DISPEL_STATE_BUTTON_OFF";

//const string BEHAVIOR_CASTING_ON				= "BEHAVIOR_CASTING_STATE_BUTTON_ON";
const string BEHAVIOR_CASTING_OFF				= "BEHAVIOR_CASTING_STATE_BUTTON_OFF";
const string BEHAVIOR_CASTING_OVERKILL			= "BEHAVIOR_CASTING_STATE_BUTTON_OVERKILL";
const string BEHAVIOR_CASTING_POWER				= "BEHAVIOR_CASTING_STATE_BUTTON_POWER";
const string BEHAVIOR_CASTING_SCALED			= "BEHAVIOR_CASTING_STATE_BUTTON_SCALED";

const string BEHAVIOR_ITEM_USE_ON				= "BEHAVIOR_ITEM_USE_STATE_BUTTON_ON";
const string BEHAVIOR_ITEM_USE_OFF				= "BEHAVIOR_ITEM_USE_STATE_BUTTON_OFF";
const string BEHAVIOR_FEAT_USE_ON				= "BEHAVIOR_FEAT_USE_STATE_BUTTON_ON";
const string BEHAVIOR_FEAT_USE_OFF				= "BEHAVIOR_FEAT_USE_STATE_BUTTON_OFF";

const string BEHAVIOR_PUPPET_ON					= "BEHAVIOR_PUPPET_STATE_BUTTON_ON";
const string BEHAVIOR_PUPPET_OFF				= "BEHAVIOR_PUPPET_STATE_BUTTON_OFF";

const string BEHAVIOR_COMBAT_MODE_USE_ON		= "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_ON";
const string BEHAVIOR_COMBAT_MODE_USE_OFF		= "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_OFF";


// these str refs double as identifiers for SetBehavior function, so do not set as -1, or make multiple values equal.

const int STR_REF_BEHAVIOR_FOLLOWDIST_NEAR          = 179925;
const int STR_REF_BEHAVIOR_FOLLOWDIST_MED           = 179926;
const int STR_REF_BEHAVIOR_FOLLOWDIST_FAR           = 179927;
const int STR_REF_BEHAVIOR_DEF_MASTER_ON            = 179928;
const int STR_REF_BEHAVIOR_DEF_MASTER_OFF           = 179929;
const int STR_REF_BEHAVIOR_RETRY_LOCKS_ON           = 179930;
const int STR_REF_BEHAVIOR_RETRY_LOCKS_OFF          = 179931;
const int STR_REF_BEHAVIOR_STEALTH_MODE_NONE        = 179932; 
const int STR_REF_BEHAVIOR_STEALTH_MODE_PERM        = 179933;
const int STR_REF_BEHAVIOR_STEALTH_MODE_TEMP        = 179934;
const int STR_REF_BEHAVIOR_DISARM_TRAPS_ON          = 179936;
const int STR_REF_BEHAVIOR_DISARM_TRAPS_OFF         = 179937;
const int STR_REF_BEHAVIOR_DISPEL_ON                = 179938;
const int STR_REF_BEHAVIOR_DISPEL_OFF               = 179939;
//const int STR_REF_BEHAVIOR_CASTING_ON               = 179940;
const int STR_REF_BEHAVIOR_CASTING_OFF              = 179941;
const int STR_REF_BEHAVIOR_CASTING_OVERKILL         = 182915;
const int STR_REF_BEHAVIOR_CASTING_POWER            = 182914;
const int STR_REF_BEHAVIOR_CASTING_SCALED           = 182913;
const int STR_REF_BEHAVIOR_ITEM_USE_ON            	= 183071;
const int STR_REF_BEHAVIOR_ITEM_USE_OFF          	= 183070;
const int STR_REF_BEHAVIOR_FEAT_USE_ON            	= 183216;
const int STR_REF_BEHAVIOR_FEAT_USE_OFF          	= 183215;
const int STR_REF_BEHAVIOR_PUPPET_ON            	= 183222;
const int STR_REF_BEHAVIOR_PUPPET_OFF          		= 183223;
const int STR_REF_BEHAVIOR_COMBAT_MODE_USE_ON		= 184645;
const int STR_REF_BEHAVIOR_COMBAT_MODE_USE_OFF		= 184646;


//=====================================
// Prototypes
//=====================================
void SetBehavior(int iStrRef, int iExamined);
void SetBehaviorAll(int iStrRef);	// doesn't support examined character sheets!
void SetBehaviorOnObject(object oSelf, int iStrRef);
void GuiBehaviorUpdate (int iExamined);
void GuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen);


//=====================================
// Functions
//=====================================

// Set Behavior on all companions in the party and on this player's controlled character.
void SetBehaviorAll(int iStrRef)
{
	object oPC = OBJECT_SELF;
	//PrettyMessage("OBJECT_SELF = " + GetName(OBJECT_SELF));
	// object oOwnedChar = GetOwnedCharacter(oPC); // OBJECT_SELF is the owned char, and this function will return ""
	int i = 1;
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		//PrettyMessage("SetBehaviorAll: Party char # " + IntToString(i) + " = " + GetName(oPartyMember));
		i++;
 		if (GetIsRosterMember(oPartyMember) || (oPartyMember == oPC))
		{
			SetBehaviorOnObject(oPartyMember, iStrRef);
		}
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
	
	//SetBehavior(iStrRef);
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject = oPlayerObject;
	string sScreen = SCREEN_CHARACTER;
	
	SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, iStrRef, "" );
	GuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}

// Set Behavior on currently controlled character
void SetBehavior(int iStrRef, int iExamined)
{
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	string sScreen;
	
	if (iExamined == 0) // looking at our own character sheet
	{
		oTargetObject = oPlayerObject;
		sScreen = SCREEN_CHARACTER;
	}
	else 	// looking at an examined character sheet
	{
		oTargetObject = GetPlayerCreatureExamineTarget(oPlayerObject);
		sScreen = SCREEN_CREATUREEXAMINE;
	}
	
	SetBehaviorOnObject(oTargetObject, iStrRef);
	SetGUIObjectText(oPlayerObject, sScreen, BEHAVIORDESC_TEXT, iStrRef, "" );
	GuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}


// Set Behavior on object oSelf
// oSelf - object to be acted upon
// iStrRef - str ref of the description
void SetBehaviorOnObject(object oSelf, int iStrRef)
{
	//object oSelf = GetControlledCharacter(OBJECT_SELF);
	
	//PrettyMessage("SetBehaviorOnObject: " + GetName(oSelf) + " iStrRef=" + IntToString(iStrRef) );

	switch (iStrRef)
	{
		case STR_REF_BEHAVIOR_FOLLOWDIST_NEAR:
		case STR_REF_BEHAVIOR_FOLLOWDIST_MED:
		case STR_REF_BEHAVIOR_FOLLOWDIST_FAR:
		    SetAssociateState( NW_ASC_DISTANCE_2_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_NEAR), oSelf ); 
		    SetAssociateState( NW_ASC_DISTANCE_4_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_MED), oSelf );
		    SetAssociateState( NW_ASC_DISTANCE_6_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_FAR), oSelf );
			break;
	
		case STR_REF_BEHAVIOR_DEF_MASTER_ON:
			SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_DEF_MASTER_OFF:
			SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, FALSE, oSelf);
			break;

		case STR_REF_BEHAVIOR_RETRY_LOCKS_ON:
			SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, TRUE, oSelf);
			break;
			
		case STR_REF_BEHAVIOR_RETRY_LOCKS_OFF:	
			SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, FALSE, oSelf);
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_NONE:
			//ClearAllActions();
		    SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 0);
    		SetActionMode(oSelf, ACTION_MODE_STEALTH, FALSE);
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_PERM:
			ClearAllActions();
		    SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 1);
		    DelayCommand(1.0, SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE));
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_TEMP:
			ClearAllActions();
		    SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 2);
		    DelayCommand(1.0, SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE));
			break;
	
		case STR_REF_BEHAVIOR_DISARM_TRAPS_ON:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_DISARM_TRAPS_ON");
	    	SetAssociateState(NW_ASC_DISARM_TRAPS, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_DISARM_TRAPS_OFF:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_DISARM_TRAPS_OFF");
	    	SetAssociateState(NW_ASC_DISARM_TRAPS, FALSE, oSelf);
			break;
	
	
		case STR_REF_BEHAVIOR_DISPEL_ON:
	    	SetLocalInt(oSelf, "X2_HENCH_DO_NOT_DISPEL", FALSE);
			break;

		case STR_REF_BEHAVIOR_DISPEL_OFF:
	    	SetLocalInt(oSelf, "X2_HENCH_DO_NOT_DISPEL", TRUE);
			break;
	
		case STR_REF_BEHAVIOR_CASTING_OFF:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_CASTING_OFF");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 10);  // casting off is 10 for this
			break;

		case STR_REF_BEHAVIOR_CASTING_OVERKILL:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_CASTING_OVERKILL");

			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0);
	    	SetAssociateState(NW_ASC_OVERKIll_CASTING, TRUE, oSelf);
	    	SetAssociateState(NW_ASC_POWER_CASTING, FALSE, oSelf);
	    	SetAssociateState(NW_ASC_SCALED_CASTING, FALSE, oSelf);
			break;

		case STR_REF_BEHAVIOR_CASTING_POWER:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_CASTING_POWER");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0); // casting on is 0 for this
	    	SetAssociateState(NW_ASC_OVERKIll_CASTING, FALSE, oSelf);
	    	SetAssociateState(NW_ASC_POWER_CASTING, TRUE, oSelf);
	    	SetAssociateState(NW_ASC_SCALED_CASTING, FALSE, oSelf);			
			break;

		case STR_REF_BEHAVIOR_CASTING_SCALED: 
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_CASTING_SCALED");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0);
	    	SetAssociateState(NW_ASC_OVERKIll_CASTING, FALSE, oSelf);
	    	SetAssociateState(NW_ASC_POWER_CASTING, FALSE, oSelf);
	    	SetAssociateState(NW_ASC_SCALED_CASTING, TRUE, oSelf);			
			break;
			
		// to use items we set item exclusion to false			
		case STR_REF_BEHAVIOR_ITEM_USE_ON:
			SetLocalIntState(oSelf, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ITEM, FALSE);
			break;
			
		// to not use items we set item exclusion to true			
		case STR_REF_BEHAVIOR_ITEM_USE_OFF:
			SetLocalIntState(oSelf, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ITEM, TRUE);
			break;

		// to use abilities (feats, skills, and special abilities) we set ability exclusion to false			
		case STR_REF_BEHAVIOR_FEAT_USE_ON:
			SetLocalIntState(oSelf, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY, FALSE);
			break;
			
		// to not use abilities we set ability exclusion to true			
		case STR_REF_BEHAVIOR_FEAT_USE_OFF:
			SetLocalIntState(oSelf, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY, TRUE);
			break;

		case STR_REF_BEHAVIOR_PUPPET_ON:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_PUPPET_ON");
			
			if(GetCurrentAction() == ACTION_FOLLOW || GetCurrentAction() == ACTION_WAIT)
				ClearAllActions();
	    	
			SetAssociateState(NW_ASC_MODE_PUPPET, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_PUPPET_OFF:
			//PrettyMessage("SetBehavior: STR_REF_BEHAVIOR_PUPPET_OFF");
	    	SetAssociateState(NW_ASC_MODE_PUPPET, FALSE, oSelf);
			break;
		
		case STR_REF_BEHAVIOR_COMBAT_MODE_USE_ON:
			SetLocalInt(oSelf, N2_COMBAT_MODE_USE_DISABLED, FALSE);
			break;
		
		case STR_REF_BEHAVIOR_COMBAT_MODE_USE_OFF:
			SetLocalInt(oSelf, N2_COMBAT_MODE_USE_DISABLED, TRUE);
			break;

		default:	
			PrettyError( "gui_bhvr_inc: Behavior " + IntToString( iStrRef ) + " definition does not exist." );
			break;														
	}		
}

// 0 = off
// 1 = on
int GetObjectPuppetMode(object oTargetObject)
{
	// Puppet Mode
	int iState = GetAssociateState(NW_ASC_MODE_PUPPET, oTargetObject);
	//PrettyMessage("GuiBehaviorInit(): iState for " + GetName(oSelf) + " (Puppet Mode)=" + IntToString(iState));
	//SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_ON, (iState) );
	//SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_OFF, (!iState));
	return (iState);
}


// 0 = ALL Puppet Mode off
// 1 = All Puppet Mode on
// 2 = Some on, Some off
int GetObjectPuppetModeAll()
{
	int nRet;
	object oPC = OBJECT_SELF;
	//PrettyMessage("OBJECT_SELF = " + GetName(OBJECT_SELF));
	// object oOwnedChar = GetOwnedCharacter(oPC); // OBJECT_SELF is the owned char, and this function will return ""
	int i = 0;
	//PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
	int nPuppetMode = 0;
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		//PrettyMessage("SetBehaviorAll: Party char # " + IntToString(i) + " = " + GetName(oPartyMember));
 		if (GetIsRosterMember(oPartyMember) || (oPartyMember == oPC))
		{
			i++;
			if (GetObjectPuppetMode(oPartyMember)!=FALSE)
				nPuppetMode++;
		}
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
	PrettyDebug("Total party members:" + IntToString(i));
	PrettyDebug("Num party members in puppet mode:" + IntToString(nPuppetMode));
	if (nPuppetMode == i)
		nRet = 1;
	else if (nPuppetMode == 0)		
		nRet = 0;
	else
		nRet = 2;
		
	return (nRet);				
}


// this func called by gui_bhvr_update
void GuiBehaviorUpdate (int iExamined)
{
	//object oSelf;
	string sScreen;
	object oPlayerObject = GetControlledCharacter(OBJECT_SELF);
	object oTargetObject;
	
	if (iExamined == 0) // looking at our own character sheet
	{
		oTargetObject = oPlayerObject;
		sScreen = SCREEN_CHARACTER;
	}
	else 	// looking at an examined character sheet
	{
		oTargetObject = GetPlayerCreatureExamineTarget(oPlayerObject);
		sScreen = SCREEN_CREATUREEXAMINE;
	}
	GuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}


// set up the AI MODE GUI with info
// oPlayerObject - the player object who's looking at the GUI
// sScreen - The GUI screen being looked at.
void GuiAIModeInit(object oPlayerObject)
{
	int nAllPuppetMode = GetObjectPuppetModeAll();
	
	// this only allows changing of main image and not hover
	//SetGUITexture(oPC, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
	PrettyDebug("nAllPuppetMode = " + IntToString(nAllPuppetMode));
	SetGUIObjectHidden(oPlayerObject, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_AI_OFF_BUTTON, nAllPuppetMode!=1);
	SetGUIObjectHidden(oPlayerObject, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_AI_ON_BUTTON, nAllPuppetMode!=0);
	SetGUIObjectHidden(oPlayerObject, GUI_SCREEN_PLAYERMENU, GUI_PLAYERMENU_AI_MIXED_BUTTON, nAllPuppetMode!=2);

}

// set up the Behavior Panel GUI with all the info for the selectable states
// oPlayerObject - the player object who's looking at the GUI
// oTargetObject - the object who's information is being displayed in the GUI
// sScreen - The GUI screen being looked at.
void GuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen)
{
	GuiAIModeInit(oPlayerObject);

	int iState;
	//object oSelf = GetControlledCharacter(OBJECT_SELF);

	//PrettyMessage("gui_bhvr_update: oSelf=" + GetName(oTargetObject) + " sScreen=" + sScreen);
	
	int	bHideInfluenceDisplay = TRUE;
	
    // influence vars are set in the NX1 campaign scripts - DoInfluenceEffects()
    // in kinc_companions.  This will otherwise be false.
    // DoInfluenceEffects() is called in kb_comp_roster_spawn as well as when a "SetInfluence" function is called
	if (GetLocalInt(oTargetObject, "GUI_DisplayInfluence") == TRUE)
	{
		bHideInfluenceDisplay = FALSE;
		int nVarIndex = 1;
        
        // ExecuteScript("gui_store_influence", oTargetObject); // this sets up the next 2 vars.
        int iInfluence = GetLocalInt(oTargetObject, "influence");
        int iInfluenceBandStrRef = GetLocalInt(oTargetObject, "influence_band");
        string sInfluenceBand = GetStringByStrRef(iInfluenceBandStrRef);
        string sVarValue = IntToString(iInfluence) + " - " + sInfluenceBand;
		SetLocalGUIVariable(oPlayerObject, sScreen, nVarIndex, sVarValue);
	}	
	
    string sUIObjectName = "INFLUENCE_CONTAINER";
	//PrettyDebug("Hiding! sScreen=" + sScreen + " : " +
    //            "sUIObjectName = " + sUIObjectName + " : " +
    //            "bHideInfluenceDisplay = " + IntToString(bHideInfluenceDisplay));
                
    //RWT-OEI 02/23/06
    //This function will set a GUI object as hidden or visible on a GUI panel on
    //the client.
    //The panel must be located within the [ScriptGUI] section of the ingamegui.ini
    //in order to let this script function have any effect on it.
    //Also, the panel must be in memory. Which means the panel should probably not have
    //any idle expiration times set in the <UIScene> tag that would cause the panel to
    //unload
    // void SetGUIObjectHidden( object oPlayer, string sScreenName, string sUIObjectName, int bHidden );
    SetGUIObjectHidden(oPlayerObject, sScreen, sUIObjectName, bHideInfluenceDisplay);
		
	// *** Follow Distance
    if ( GetAssociateState( NW_ASC_DISTANCE_2_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_NEAR, TRUE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_MED, FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_FAR, FALSE );
    }
    else if ( GetAssociateState( NW_ASC_DISTANCE_4_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_NEAR, FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_MED, TRUE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_FAR, FALSE );
    }
    else  if ( GetAssociateState( NW_ASC_DISTANCE_6_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_NEAR, FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_MED, FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, BEHAVIOR_FOLLOWDIST_FAR, TRUE );
    }
	//iState = 
	//SetGUIObjectDisabled( oSelf, sScreen, BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR, (iState==NW_ASC_DISTANCE_2_METERS) );
	//SetGUIObjectDisabled( oSelf, sScreen, BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED, (iState==NW_ASC_DISTANCE_4_METERS) );
	//SetGUIObjectDisabled( oSelf, sScreen, BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR, (iState==NW_ASC_DISTANCE_6_METERS) );
	
	// defend master mode
	iState = GetAssociateState(NW_ASC_MODE_DEFEND_MASTER, oTargetObject);
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DEF_MASTER_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DEF_MASTER_OFF, (!iState));

	// retry open locks mode					
	iState = GetAssociateState(NW_ASC_RETRY_OPEN_LOCKS, oTargetObject);
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_RETRY_LOCKS_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_RETRY_LOCKS_OFF, (!iState));
	
	// stealthy mode
	iState = GetLocalInt(oTargetObject, "X2_HENCH_STEALTH_MODE");
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_STEALTH_MODE_NONE, (iState==0) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_STEALTH_MODE_PERM, (iState==1));
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_STEALTH_MODE_TEMP, (iState==2));

	// Disarm traps
	iState = GetAssociateState(NW_ASC_DISARM_TRAPS, oTargetObject);
	//PrettyMessage("GuiBehaviorInit(): iState =" + IntToString(iState));
	
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DISARM_TRAPS_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DISARM_TRAPS_OFF, (!iState));

	// Displel mode
	iState = (GetLocalInt(oTargetObject, "X2_HENCH_DO_NOT_DISPEL") == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DISPEL_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_DISPEL_OFF, (!iState));

	// Casting mode 
	iState = (GetLocalInt(oTargetObject, "X2_L_STOPCASTING") == 0);
	//SetGUIObjectDisabled(oSelf, sScreen, BEHAVIOR_CASTING_ON, (iState) );
	//SetGUIObjectDisabled(oSelf, sScreen, BEHAVIOR_CASTING_OFF, (!iState));
	//PrettyMessage("GuiBehaviorInit(): iState =" + IntToString(iState));
	
	if (iState == FALSE)
	{
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_OVERKILL, FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_POWER, FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_SCALED, FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_OFF, TRUE);
	}
	else
	{
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_OVERKILL, GetAssociateState( NW_ASC_OVERKIll_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_POWER, GetAssociateState( NW_ASC_POWER_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_SCALED, GetAssociateState( NW_ASC_SCALED_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_CASTING_OFF, FALSE);
	}

	// Use Items
	//iState = (GetLocalInt(oSelf, N2_TALENT_EXCLUDE) == 0); // 1st bit is item usage
	iState = (GetLocalIntState(oTargetObject, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ITEM) == FALSE);
	//PrettyMessage("GuiBehaviorInit(): iState =" + IntToString(iState));
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_ITEM_USE_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_ITEM_USE_OFF, (!iState));

	// Use Items
	iState = (GetLocalIntState(oTargetObject, N2_TALENT_EXCLUDE, TALENT_EXCLUDE_ABILITY) == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_FEAT_USE_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_FEAT_USE_OFF, (!iState));

	// Puppet Mode
	iState = GetAssociateState(NW_ASC_MODE_PUPPET, oTargetObject);
	//PrettyMessage("GuiBehaviorInit(): iState for " + GetName(oSelf) + " (Puppet Mode)=" + IntToString(iState));
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_OFF, (!iState));
	
	// Use Combat Mode
	iState = (GetLocalInt(oTargetObject, N2_COMBAT_MODE_USE_DISABLED) == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_COMBAT_MODE_USE_ON, (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_COMBAT_MODE_USE_OFF, (!iState));	
}
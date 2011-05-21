////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//    File Name : acr_vfx_i
//    $Revision:: 506         $
//        $Date:: 2008-04-13 #$
//       Author : Cipher
//
//    Var Prefix: ACR_VFX
//  Dependencies: Blueprints with the relevant events.
//
//  Description
//  This is a general purpose effects application intended for builders who are
//  looking to enhance the mood of their settings with dynamic visual and physical
//  effects. This is best applied to placeables, but need not be limited to them.
//  Triggers and creatures also make good candidates for such effects.
//
//  Configuration instructions are provided in the ALFA Wiki (under Technical)
//  in the relevant blueprint creation articles.
//
//  Revision History
//  2006/01/03  Cipher  Inception
//  2006/01/10  Cipher  Added trace and pulse custom effects help
//  2006/10/10  Cipher  Revised header template and code to ALFA standards
//  2007/01/20  Cipher  Added OnEnter(), OnExit(), and OnClick() event handlers
//  2007/01/20  Cipher  Fixed typo in OnUsed() event constant
//  2007/10/11  AcadiusLost - commented out VFX_DUR_BLACKOUT for MotB compatibility
//  2007/10/16  AcadiusLost - deleted a number of VFX for MotB compatibility
//  2008/04/13  AcadiusLost - commented out OnPerception and OnHeartbeat VFX applications for performance.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "x0_i0_spawncond"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// temp defines
const int DAMAGE_TYPE_BASE_WEAPON = 8;

//! These are the relevant local variable suffixes
const string EFFECT_VISUAL = "_EFFECT_VISUAL";
const string EFFECT_PHYSICAL = "_EFFECT_PHYSICAL";
const string EFFECT_DAMAGE = "_EFFECT_DAMAGE";

//! These are the placeable light shafts
const string SHAFT_RED_TAG = "abr_pl_solred";
const string SHAFT_BLUE_TAG = "abr_pl_solblue";
const string SHAFT_CYAN_TAG = "abr_pl_solcyan";
const string SHAFT_WHITE_TAG = "abr_pl_solwhite";
const string SHAFT_GREEN_TAG = "abr_pl_solgreen";
const string SHAFT_ORANGE_TAG = "abr_pl_solorange";
const string SHAFT_YELLOW_TAG = "abr_pl_solyellow";
const string SHAFT_PURPLE_TAG = "abr_pl_solpurple";

//! These are the supported events
//! If you add/remove events, please update the Wiki accordingly
const string ON_OPEN_EVENT = "ACR_VFX_ON_OPEN";
const string ON_CLOSE_EVENT = "ACR_VFX_ON_CLOSE";
const string ON_ENTER_EVENT = "ACR_VFX_ON_ENTER";
const string ON_EXIT_EVENT = "ACR_VFX_ON_EXIT";
const string ON_LOCK_EVENT = "ACR_VFX_ON_LOCK";
const string ON_UNLOCK_EVENT = "ACR_VFX_ON_UNLOCK";
const string ON_USED_EVENT = "ACR_VFX_ON_USED";
const string ON_ATTACK_EVENT = "ACR_VFX_ON_ATTACKED";
const string ON_DAMAGED_EVENT = "ACR_VFX_ON_DAMAGED";
const string ON_SPELLCAST_EVENT = "ACR_VFX_ON_SPELLCAST";
const string ON_SPAWN_EVENT = "ACR_VFX_ON_SPAWN";
const string ON_DEATH_EVENT = "ACR_VFX_ON_DEATH";
const string ON_DISTURBED_EVENT = "ACR_VFX_ON_DISTURBED";
const string ON_HEARTBEAT_EVENT = "ACR_VFX_ON_HEARTBEAT";
const string ON_DISARM_EVENT = "ACR_VFX_ON_DISARM";
const string ON_PERCEPTION_EVENT = "ACR_VFX_ON_PERCEPTION";
const string ON_CLICK_EVENT = "ACR_VFX_ON_CLICK";

/*//////////////////////////////////////////////////////////////////////////////
// consider future support for the following events
const string ON_BLOCKED_EVENT = "ON_BLOCKED";
const string ON_COMBATRNDEND_EVENT = "ON_COMBAT_ROUND_END";
const string ON_CONVERSATION_EVENT = "ON_CONVERSATION";
const string ON_RESTED_EVENT = "ON_RESTED";

const string ON_AREATRANSITIONCLICK_EVENT = "ON_AREA_TRANSITION_CLICK";
const string ON_OPENFAIL_EVENT = "ON_FAIL_TO_OPEN";

const string ON_EXHAUSTED_EVENT = "ON_EXHAUSTED";

const string ON_ITEM_ACQUIRE_EVENT = "ON_ACQUIRE_ITEM";
const string ON_ITEM_UNACQUIRE_EVENT = "ON_UNACQUIRE_ITEM";
const string ON_ITEM_ACTIVATE_EVENT = "ON_ACTIVATE_ITEM";
const string ON_CLIENT_ENTER_EVENT = "ON_CLIENT_ENTER";
const string ON_CLIENT_LEAVE_EVENT = "ON_CLIENT_LEAVE";
const string ON_CUTSCENE_ABORT_EVENT = "ON_CUTSCENE_ABORT";
const string ON_PLAYER_DEATH_EVENT = "ON_PLAYER_DEATH";
const string ON_PLAYER_DYING_EVENT = "ON_PLAYER_DYING";
const string ON_PLAYER_ITEM_EQUIP_EVENT = "ON_PLAYER_EQUIP_ITEM";
const string ON_PLAYER_ITEM_UNEQUIP_EVENT = "ON_PLAYER_UNEQUIP_ITEM";
const string ON_PLAYER_LEVELUP_EVENT = "ON_PLAYER_LEVELUP";
const string ON_PLAYER_RESPAWN_EVENT = "ON_PLAYER_RESPAWN";
const string ON_PLAYER_REST_EVENT = "ON_PLAYER_REST";
//////////////////////////////////////////////////////////////////////////////*/

//! VFX Event Flags
const int VFX_FLAG_ON_OPEN       = 0x00000001;
const int VFX_FLAG_ON_CLOSE      = 0x00000002;
const int VFX_FLAG_ON_LOCK       = 0x00000004;
const int VFX_FLAG_ON_UNLOCK     = 0x00000008;
const int VFX_FLAG_ON_USED       = 0x00000010;
const int VFX_FLAG_ON_ATTACK     = 0x00000020;
const int VFX_FLAG_ON_DAMAGED    = 0x00000040;
const int VFX_FLAG_ON_SPELLCAST  = 0x00000080;
const int VFX_FLAG_ON_SPAWN      = 0x00000100;
const int VFX_FLAG_ON_DEATH      = 0x00000200;
const int VFX_FLAG_ON_DISTURBED  = 0x00000400;
const int VFX_FLAG_ON_HEARTBEAT  = 0x00000800;
const int VFX_FLAG_ON_DISARM     = 0x00001000;
const int VFX_FLAG_ON_PERCEPTION = 0x00002000;
const int VFX_FLAG_ON_ENTER      = 0x00004000;
const int VFX_FLAG_ON_EXIT       = 0x00008000;
const int VFX_FLAG_ON_CLICK      = 0x00010000;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// *** PUBLIC FUNCTIONS ***

//! OnAttack event handler function
//!  - oAttacker: the creature which tiggered the event
//!  - oAttacked: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnAttack(object oAttacker, object oAttacked);

//! OnClose event handler function
//!  - oCloser: the creature which tiggered the event
//!  - oClosed: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnClose(object oCloser, object oClosed);

//! OnExit event handler function
//!  - oExiter: the creature which tiggered the event
//!  - oExited: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnExit(object oExiter, object oExited);

//! OnDamage event handler function
//!  - oDamager: the creature which tiggered the event
//!  - oDamaged: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnDamage(object oDamager, object oDamaged);

//! OnDeath event handler function
//!  - oKiller: the creature which tiggered the event
//!  - oKilled: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnDeath(object oKiller, object oKilled);

//! OnDisarm event handler function
//!  - oDisarmer: the creature which tiggered the event
//!  - oDisarmed: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnDisarm(object oDisarmer, object oDisarmed);

//! OnDisturb event handler function
//!  - oDisturber: the creature which tiggered the event
//!  - oDisturbed: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnDisturb(object oDisturber, object oDisturbed);

//! OnLock event handler function
//!  - oLocker: the creature which tiggered the event
//!  - oLocked: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnLock(object oLocker, object oLocked);

//! OnUnLocked event handler function
//!  - oUnlocker: the creature which tiggered the event
//!  - oUnlocked: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnUnLock(object oUnlocker, object oUnlocked);

//! OnOpen event handler function
//!  - oOpener: the creature which tiggered the event
//!  - oOpened: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnOpen(object oOpener, object oOpened);

//! OnEnter event handler function
//!  - oEnterer: the creature which tiggered the event
//!  - oEntered: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnEnter(object oEnterer, object oEntered);

//! OnUsed event handler function
//!  - oActivater: the creature which tiggered the event
//!  - oActivated: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnUsed(object oActivater, object oActivated);

//! OnClick event handler function
//!  - oClicker: the creature which tiggered the event
//!  - oClicked: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnClick(object oClicker, object oClicked);

//! OnSpellCastAt event handler function
//!  - oCaster: the creature which tiggered the event
//!  - oTarget: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnSpellCastAt(object oCaster, object oTarget);

//! OnPerception event handler function
//!  - oPerceived: the creature which tiggered the event
//!  - oPerceiver: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnPerception(object oPerceived, object oPerceiver);

//! OnHeartBeat event handler function
//!  - oObject: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnHeartBeat(object oObject);

//! OnSpawn event handler function
//!  - oObject: the object on which the event occurred
//!  - Returns: nothing
void ACR_VFXOnSpawn(object oObject);

// *** PRIVATE FUNCTIONS ***

// Return the integer equivalent for the effect requested
//!  - sEffect: the visual effect string (constant) to convert
//!  - Returns: the visual effect ID
int _getVFXConstant(string sEffect);

// Return the integer equivalent for the saving throw requested
//!  - oCreature: the creature attempting the save
//!  - sType: the saving throw string (constant) to convert
//!  - nDC: the difficulty class of the save
//!  - Returns: the saving throw ID
int _getSavingThrow(object oCreature, string sType, int nDC);

// Return the template name for the desired light shaft
//!  - sVisualEffect: the type of light shaft to retrieve
//!  - Returns: the resref of the light shaft placeable
string _getLightShaft(string sVisualEffect);

// Apply the desired visual effect to oTarget
//!  - sVisualEffect: the builder configured visual effect string
//!  - oTarget: the creature to whom the effect will be applied
//!  - bMissEffect: TRUE or FALSE whether a "miss" animation on the target is desired
//!  - Returns: nothing
void _applyVisualEffect(string sVisualEffect, object oTarget, int bMissEffect);

// Apply the desired physical effect to oTarget
//!  - sPhysicalEffect: the builder configured physical effect string
//!  - oTarget: the creature to whom the effect will be applied
//!  - nAmount: any quantity to apply to the effect as required
//!  - Returns: nothing
void _applyPhysicalEffect(string sPhysicalEffect, object oTarget, int nAmount);

// Apply the damage to oTarget if they fail to save and return the save status
//!  - sDamageEffect: the builder configured damage effect string
//!  - sPhysicalEffect: the builder configured physical effect string
//!  - oTarget: the creature to whom the effect will be applied
//!  - Returns: the save status of oTarget
//!    0: the saving throw failed
//!    1: the saving throw succeeded
//!    2: the target was immune
int _applyDamage(string sDamageEffect, string sPhysicalEffect, object oTarget);

// These are internal recursive functions for specific visual effects
void _vFXTrace(vector vCurrent, vector vDiff, int nTimesLeft, int nColor, float fDelay, int nNode);
void _vFXPulse(vector vCurrent, vector vDiff, int nTimesLeft, int nVFX, float fDelay);

// This function returns a vector from a string using the coordinate format x,y,z
vector _createVectorFromString(string sVectorString);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_VFXOnAttack(object oAttacker, object oAttacked)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oAttacked, ON_ATTACK_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oAttacked, ON_ATTACK_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oAttacked, ON_ATTACK_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oAttacker, _applyDamage(sDamageEffect, sPhysicalEffect, oAttacker));
}

void ACR_VFXOnClose(object oCloser, object oClosed)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oClosed, ON_CLOSE_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oClosed, ON_CLOSE_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oClosed, ON_CLOSE_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oCloser, _applyDamage(sDamageEffect, sPhysicalEffect, oCloser));
}

void ACR_VFXOnExit(object oExiter, object oExited)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oExited, ON_EXIT_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oExited, ON_EXIT_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oExited, ON_EXIT_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oExiter, _applyDamage(sDamageEffect, sPhysicalEffect, oExiter));
}

void ACR_VFXOnDamage(object oDamager, object oDamaged)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oDamaged, ON_DAMAGED_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oDamaged, ON_DAMAGED_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oDamaged, ON_DAMAGED_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oDamager, _applyDamage(sDamageEffect, sPhysicalEffect, oDamager));
}

void ACR_VFXOnDeath(object oKiller, object oKilled)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oKilled, ON_DEATH_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oKilled, ON_DEATH_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oKilled, ON_DEATH_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oKiller, _applyDamage(sDamageEffect, sPhysicalEffect, oKiller));
}

void ACR_VFXOnDisarm(object oDisarmer, object oDisarmed)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oDisarmed, ON_DISARM_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oDisarmed, ON_DISARM_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oDisarmed, ON_DISARM_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oDisarmer, _applyDamage(sDamageEffect, sPhysicalEffect, oDisarmer));
}

void ACR_VFXOnDisturb(object oDisturber, object oDisturbed)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oDisturbed, ON_DISTURBED_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oDisturbed, ON_DISTURBED_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oDisturbed, ON_DISTURBED_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oDisturber, _applyDamage(sDamageEffect, sPhysicalEffect, oDisturber));
}

void ACR_VFXOnLock(object oLocker, object oLocked)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oLocked, ON_LOCK_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oLocked, ON_LOCK_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oLocked, ON_LOCK_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oLocker, _applyDamage(sDamageEffect, sPhysicalEffect, oLocker));
}

void ACR_VFXOnUnLock(object oUnlocker, object oUnlocked)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oUnlocked, ON_UNLOCK_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oUnlocked, ON_UNLOCK_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oUnlocked, ON_UNLOCK_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oUnlocker, _applyDamage(sDamageEffect, sPhysicalEffect, oUnlocker));
}

void ACR_VFXOnOpen(object oOpener, object oOpened)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oOpened, ON_OPEN_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oOpened, ON_OPEN_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oOpened, ON_OPEN_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oOpener, _applyDamage(sDamageEffect, sPhysicalEffect, oOpener));
}

void ACR_VFXOnEnter(object oEnterer, object oEntered)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oEntered, ON_ENTER_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oEntered, ON_ENTER_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oEntered, ON_ENTER_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oEnterer, _applyDamage(sDamageEffect, sPhysicalEffect, oEnterer));
}

void ACR_VFXOnUsed(object oActivater, object oActivated)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oActivated, ON_USED_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oActivated, ON_USED_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oActivated, ON_USED_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oActivater, _applyDamage(sDamageEffect, sPhysicalEffect, oActivater));
}

void ACR_VFXOnClick(object oClicker, object oClicked)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oClicked, ON_CLICK_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oClicked, ON_CLICK_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oClicked, ON_CLICK_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oClicker, _applyDamage(sDamageEffect, sPhysicalEffect, oClicker));
}

void ACR_VFXOnSpellCastAt(object oCaster, object oTarget)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oTarget, ON_SPELLCAST_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oTarget, ON_SPELLCAST_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oTarget, ON_SPELLCAST_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oCaster, _applyDamage(sDamageEffect, sPhysicalEffect, oCaster));
}

void ACR_VFXOnPerception(object oPerceived, object oPerceiver)
{
    // Load the effect strings
    //string sVisualEffect = GetLocalString(oPerceiver, ON_PERCEPTION_EVENT + EFFECT_VISUAL);
    //string sPhysicalEffect = GetLocalString(oPerceiver, ON_PERCEPTION_EVENT + EFFECT_PHYSICAL);
    //string sDamageEffect = GetLocalString(oPerceiver, ON_PERCEPTION_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    //_applyVisualEffect(sVisualEffect, oPerceived, _applyDamage(sDamageEffect, sPhysicalEffect, oPerceived));
}

void ACR_VFXOnHeartBeat(object oObject)
{
    // Load the effect strings
    //string sVisualEffect = GetLocalString(oObject, ON_HEARTBEAT_EVENT + EFFECT_VISUAL);
    //string sPhysicalEffect = GetLocalString(oObject, ON_HEARTBEAT_EVENT + EFFECT_PHYSICAL);
    //string sDamageEffect = GetLocalString(oObject, ON_HEARTBEAT_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    //_applyVisualEffect(sVisualEffect, oObject, _applyDamage(sDamageEffect, sPhysicalEffect, oObject));
}

void ACR_VFXOnSpawn(object oObject)
{
    // Load the effect strings
    string sVisualEffect = GetLocalString(oObject, ON_SPAWN_EVENT + EFFECT_VISUAL);
    string sPhysicalEffect = GetLocalString(oObject, ON_SPAWN_EVENT + EFFECT_PHYSICAL);
    string sDamageEffect = GetLocalString(oObject, ON_SPAWN_EVENT + EFFECT_DAMAGE);

    // Apply the effects
    _applyVisualEffect(sVisualEffect, oObject, _applyDamage(sDamageEffect, sPhysicalEffect, oObject));
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int _getVFXConstant(string sEffect)
{
    // Return the desired VFX constant
    // Organize by effect type for optimal search efficiency
    if (FindSubString(sEffect, "_BEAM_") == 3)
    {
        if (sEffect == "VFX_BEAM_BLACK") { return VFX_BEAM_BLACK; }
        if (sEffect == "VFX_BEAM_CHAIN") { return VFX_BEAM_CHAIN; }
        if (sEffect == "VFX_BEAM_COLD") { return VFX_BEAM_COLD; }
        if (sEffect == "VFX_BEAM_EVIL") { return VFX_BEAM_EVIL; }
        if (sEffect == "VFX_BEAM_FIRE") { return VFX_BEAM_FIRE; }
        if (sEffect == "VFX_BEAM_FIRE_LASH") { return VFX_BEAM_FIRE_LASH; }
        if (sEffect == "VFX_BEAM_FIRE_W") { return VFX_BEAM_FIRE_W; }
        if (sEffect == "VFX_BEAM_FIRE_W_SILENT") { return VFX_BEAM_FIRE_W_SILENT; }
        if (sEffect == "VFX_BEAM_HOLY") {  return VFX_BEAM_HOLY; }
        if (sEffect == "VFX_BEAM_LIGHTNING") { return VFX_BEAM_LIGHTNING; }
        if (sEffect == "VFX_BEAM_MIND") { return VFX_BEAM_MIND; }
        if (sEffect == "VFX_BEAM_ODD" ) { return VFX_BEAM_ODD; }
        if (sEffect == "VFX_BEAM_SILENT_COLD") { return VFX_BEAM_SILENT_COLD; }
        if (sEffect == "VFX_BEAM_SILENT_EVIL") { return VFX_BEAM_SILENT_EVIL; }
        if (sEffect == "VFX_BEAM_SILENT_FIRE") { return VFX_BEAM_SILENT_FIRE; }
        if (sEffect == "VFX_BEAM_SILENT_HOLY") { return VFX_BEAM_SILENT_HOLY; }
        if (sEffect == "VFX_BEAM_SILENT_LIGHTNING") { return VFX_BEAM_SILENT_LIGHTNING; }
        if (sEffect == "VFX_BEAM_SILENT_MIND") { return VFX_BEAM_SILENT_MIND; }
        if (sEffect == "VFX_BEAM_SILENT_ODD") { return VFX_BEAM_SILENT_ODD; }
    }

    if (FindSubString(sEffect, "_COM_") == 3)
    {
        if (sEffect == "VFX_COM_BLOOD_CRT_GREEN") { return VFX_COM_BLOOD_CRT_GREEN; }
        if (sEffect == "VFX_COM_BLOOD_CRT_RED") { return VFX_COM_BLOOD_CRT_RED; }
        if (sEffect == "VFX_COM_BLOOD_CRT_WIMP") { return VFX_COM_BLOOD_CRT_WIMP; }
        if (sEffect == "VFX_COM_BLOOD_CRT_YELLOW") { return VFX_COM_BLOOD_CRT_YELLOW; }
        if (sEffect == "VFX_COM_BLOOD_LRG_GREEN") { return VFX_COM_BLOOD_LRG_GREEN; }
        if (sEffect == "VFX_COM_BLOOD_LRG_RED") { return VFX_COM_BLOOD_LRG_RED; }
        if (sEffect == "VFX_COM_BLOOD_LRG_WIMP") { return VFX_COM_BLOOD_LRG_WIMP; }
        if (sEffect == "VFX_COM_BLOOD_LRG_YELLOW") { return VFX_COM_BLOOD_LRG_YELLOW; }
        if (sEffect == "VFX_COM_BLOOD_REG_GREEN") { return VFX_COM_BLOOD_REG_GREEN; }
        if (sEffect == "VFX_COM_BLOOD_REG_RED") { return VFX_COM_BLOOD_REG_RED; }
        if (sEffect == "VFX_COM_BLOOD_REG_WIMP") { return VFX_COM_BLOOD_REG_WIMP; }
        if (sEffect == "VFX_COM_BLOOD_REG_YELLOW") { return VFX_COM_BLOOD_REG_YELLOW; }
        if (sEffect == "VFX_COM_BLOOD_SPARK_LARGE") { return VFX_COM_BLOOD_SPARK_LARGE; }
        if (sEffect == "VFX_COM_BLOOD_SPARK_MEDIUM") { return VFX_COM_BLOOD_SPARK_MEDIUM; }
        if (sEffect == "VFX_COM_BLOOD_SPARK_SMALL") { return VFX_COM_BLOOD_SPARK_SMALL; }
        if (sEffect == "VFX_COM_CHUNK_BONE_MEDIUM") { return VFX_COM_CHUNK_BONE_MEDIUM; }
        if (sEffect == "VFX_COM_CHUNK_GREEN_MEDIUM") { return VFX_COM_CHUNK_GREEN_MEDIUM; }
        if (sEffect == "VFX_COM_CHUNK_GREEN_SMALL") { return VFX_COM_CHUNK_GREEN_SMALL; }
        if (sEffect == "VFX_COM_CHUNK_RED_BALLISTA") { return VFX_COM_CHUNK_RED_BALLISTA; }
        if (sEffect == "VFX_COM_CHUNK_RED_LARGE") { return VFX_COM_CHUNK_RED_LARGE; }
        if (sEffect == "VFX_COM_CHUNK_RED_MEDIUM") { return VFX_COM_CHUNK_RED_MEDIUM; }
        if (sEffect == "VFX_COM_CHUNK_RED_SMALL") { return VFX_COM_CHUNK_RED_SMALL; }
        if (sEffect == "VFX_COM_CHUNK_STONE_MEDIUM") { return VFX_COM_CHUNK_STONE_MEDIUM; }
        if (sEffect == "VFX_COM_CHUNK_STONE_SMALL") { return VFX_COM_CHUNK_STONE_SMALL; }
        if (sEffect == "VFX_COM_CHUNK_YELLOW_MEDIUM") { return VFX_COM_CHUNK_YELLOW_MEDIUM; }
        if (sEffect == "VFX_COM_CHUNK_YELLOW_SMALL") { return VFX_COM_CHUNK_YELLOW_SMALL; }
        if (sEffect == "VFX_COM_HIT_ACID") { return VFX_COM_HIT_ACID; }
        if (sEffect == "VFX_COM_HIT_DIVINE") { return VFX_COM_HIT_DIVINE; }
        if (sEffect == "VFX_COM_HIT_ELECTRICAL") { return VFX_COM_HIT_ELECTRICAL; }
        if (sEffect == "VFX_COM_HIT_FIRE") { return VFX_COM_HIT_FIRE; }
        if (sEffect == "VFX_COM_HIT_FROST") { return VFX_COM_HIT_FROST; }
        if (sEffect == "VFX_COM_HIT_NEGATIVE") { return VFX_COM_HIT_NEGATIVE; }
        if (sEffect == "VFX_COM_HIT_SONIC") { return VFX_COM_HIT_SONIC; }
        if (sEffect == "VFX_COM_SPARKS_PARRY") { return VFX_COM_SPARKS_PARRY; }
        if (sEffect == "VFX_COM_SPECIAL_BLUE_RED") { return VFX_COM_SPECIAL_BLUE_RED; }
        if (sEffect == "VFX_COM_SPECIAL_PINK_ORANGE") { return VFX_COM_SPECIAL_PINK_ORANGE; }
        if (sEffect == "VFX_COM_SPECIAL_RED_ORANGE") { return VFX_COM_SPECIAL_RED_ORANGE; }
        if (sEffect == "VFX_COM_SPECIAL_RED_WHITE") { return VFX_COM_SPECIAL_RED_WHITE; }
        if (sEffect == "VFX_COM_SPECIAL_WHITE_BLUE") { return VFX_COM_SPECIAL_WHITE_BLUE; }
        if (sEffect == "VFX_COM_SPECIAL_WHITE_ORANGE") { return VFX_COM_SPECIAL_WHITE_ORANGE; }
        if (sEffect == "VFX_COM_UNLOAD_MODEL") { return VFX_COM_UNLOAD_MODEL; }
    }

    if (FindSubString(sEffect, "_DUR_") == 3)
    {
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
        if (sEffect == "VFX_DUR_ANTI_LIGHT_10") { return VFX_DUR_ANTI_LIGHT_10; }
        if (sEffect == "VFX_DUR_AURA_COLD") { return VFX_DUR_AURA_COLD; }
        if (sEffect == "VFX_DUR_AURA_DISEASE") { return VFX_DUR_AURA_DISEASE; }
        if (sEffect == "VFX_DUR_AURA_DRAGON_FEAR") { return VFX_DUR_AURA_DRAGON_FEAR; }
        if (sEffect == "VFX_DUR_AURA_FIRE") { return VFX_DUR_AURA_FIRE; }
        if (sEffect == "VFX_DUR_AURA_ODD") { return VFX_DUR_AURA_ODD; }
        if (sEffect == "VFX_DUR_AURA_POISON") { return VFX_DUR_AURA_POISON; }
        if (sEffect == "VFX_DUR_AURA_SILENCE") { return VFX_DUR_AURA_SILENCE; }
        if (sEffect == "VFX_DUR_BARD_SONG") { return VFX_DUR_BARD_SONG; }
        if (sEffect == "VFX_DUR_BIGBYS_CLENCHED_FIST") { return VFX_DUR_BIGBYS_CLENCHED_FIST; }
        if (sEffect == "VFX_DUR_BIGBYS_CRUSHING_HAND") { return VFX_DUR_BIGBYS_CRUSHING_HAND; }
        if (sEffect == "VFX_DUR_BIGBYS_GRASPING_HAND") { return VFX_DUR_BIGBYS_GRASPING_HAND; }		
        if (sEffect == "VFX_DUR_BIGBYS_INTERPOSING_HAND") { return VFX_DUR_BIGBYS_INTERPOSING_HAND; }
        if (sEffect == "VFX_DUR_BLIND") { return VFX_DUR_BLIND; }
        if (sEffect == "VFX_DUR_BLINDVISION") { return VFX_DUR_BLINDVISION; }
        if (sEffect == "VFX_DUR_BLUR") { return VFX_DUR_BLUR; }
        if (sEffect == "VFX_DUR_CALTROPS") { return VFX_DUR_CALTROPS; }
        if (sEffect == "VFX_DUR_CESSATE_NEGATIVE") { return VFX_DUR_CESSATE_NEGATIVE; }
        if (sEffect == "VFX_DUR_CESSATE_NEUTRAL") { return VFX_DUR_CESSATE_NEUTRAL; }
        if (sEffect == "VFX_DUR_CESSATE_POSITIVE") { return VFX_DUR_CESSATE_POSITIVE; }
        if (sEffect == "VFX_DUR_CUTSCENE_INVISIBILITY") { return VFX_DUR_CUTSCENE_INVISIBILITY; }
        if (sEffect == "VFX_DUR_DARKNESS") { return VFX_DUR_DARKNESS; }
        if (sEffect == "VFX_DUR_DARKVISION") { return VFX_DUR_DARKVISION; }
        if (sEffect == "VFX_DUR_DEATH_ARMOR") { return VFX_DUR_DEATH_ARMOR; }
        if (sEffect == "VFX_DUR_ELEMENTAL_SHIELD") { return VFX_DUR_ELEMENTAL_SHIELD; }
        if (sEffect == "VFX_DUR_ENTANGLE") { return VFX_DUR_ENTANGLE; }
        if (sEffect == "VFX_DUR_ETHEREAL_VISAGE") { return VFX_DUR_ETHEREAL_VISAGE; }
        if (sEffect == "VFX_DUR_FLAG_BLUE") { return VFX_DUR_FLAG_BLUE; }
        if (sEffect == "VFX_DUR_FLAG_GOLD") { return VFX_DUR_FLAG_GOLD; }
        //if (sEffect == "VFX_DUR_FLAG_GOLD_FIXED") { return VFX_DUR_FLAG_GOLD_FIXED; }
        if (sEffect == "VFX_DUR_FLAG_PURPLE") { return VFX_DUR_FLAG_PURPLE; }
        //if (sEffect == "VFX_DUR_FLAG_PURPLE_FIXED") { return VFX_DUR_FLAG_PURPLE_FIXED; }
        if (sEffect == "VFX_DUR_FLAG_RED") { return VFX_DUR_FLAG_RED; }
        if (sEffect == "VFX_DUR_FLIES") { return VFX_DUR_FLIES; }
        if (sEffect == "VFX_DUR_FREEDOM_OF_MOVEMENT") { return VFX_DUR_FREEDOM_OF_MOVEMENT; }
        if (sEffect == "VFX_DUR_FREEZE_ANIMATION") { return VFX_DUR_FREEZE_ANIMATION; }
        if (sEffect == "VFX_DUR_GHOST_SMOKE") { return VFX_DUR_GHOST_SMOKE; }
        if (sEffect == "VFX_DUR_GHOST_SMOKE_2") { return VFX_DUR_GHOST_SMOKE_2; }
        if (sEffect == "VFX_DUR_GHOST_TRANSPARENT") { return VFX_DUR_GHOST_TRANSPARENT; }
        if (sEffect == "VFX_DUR_GHOSTLY_PULSE") { return VFX_DUR_GHOSTLY_PULSE; }
        if (sEffect == "VFX_DUR_GHOSTLY_VISAGE") { return VFX_DUR_GHOSTLY_VISAGE; }
        if (sEffect == "VFX_DUR_GHOSTLY_VISAGE_NO_SOUND") { return VFX_DUR_GHOSTLY_VISAGE_NO_SOUND; }
        if (sEffect == "VFX_DUR_GLOBE_INVULNERABILITY") { return VFX_DUR_GLOBE_INVULNERABILITY; }
        if (sEffect == "VFX_DUR_GLOBE_MINOR") { return VFX_DUR_GLOBE_MINOR; }
        if (sEffect == "VFX_DUR_GLOW_BLUE") { return VFX_DUR_GLOW_BLUE; }
        if (sEffect == "VFX_DUR_GLOW_BROWN") { return VFX_DUR_GLOW_BROWN; }
        if (sEffect == "VFX_DUR_GLOW_GREEN") { return VFX_DUR_GLOW_GREEN; }
        if (sEffect == "VFX_DUR_GLOW_GREY") { return VFX_DUR_GLOW_GREY; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_BLUE") { return VFX_DUR_GLOW_LIGHT_BLUE; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_BROWN") { return VFX_DUR_GLOW_LIGHT_BROWN; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_GREEN") { return VFX_DUR_GLOW_LIGHT_GREEN; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_ORANGE") { return VFX_DUR_GLOW_LIGHT_ORANGE; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_PURPLE") { return VFX_DUR_GLOW_LIGHT_PURPLE; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_RED") { return VFX_DUR_GLOW_LIGHT_RED; }
        if (sEffect == "VFX_DUR_GLOW_LIGHT_YELLOW") { return VFX_DUR_GLOW_LIGHT_YELLOW; }
        if (sEffect == "VFX_DUR_GLOW_ORANGE") { return VFX_DUR_GLOW_ORANGE; }
        if (sEffect == "VFX_DUR_GLOW_PURPLE") { return VFX_DUR_GLOW_PURPLE; }
        if (sEffect == "VFX_DUR_GLOW_RED") { return VFX_DUR_GLOW_RED; }
        if (sEffect == "VFX_DUR_GLOW_WHITE") { return VFX_DUR_GLOW_WHITE; }
        if (sEffect == "VFX_DUR_GLOW_YELLOW") { return VFX_DUR_GLOW_YELLOW; }
        if (sEffect == "VFX_DUR_GLYPH_OF_WARDING") { return VFX_DUR_GLYPH_OF_WARDING; }
        if (sEffect == "VFX_DUR_ICESKIN") { return VFX_DUR_ICESKIN; }
        if (sEffect == "VFX_DUR_INFERNO") { return VFX_DUR_INFERNO; }
        if (sEffect == "VFX_DUR_INFERNO_CHEST") { return VFX_DUR_INFERNO_CHEST; }
        if (sEffect == "VFX_DUR_INFERNO_NO_SOUND") { return VFX_DUR_INFERNO_NO_SOUND; }
        if (sEffect == "VFX_DUR_INVISIBILITY") { return VFX_DUR_INVISIBILITY; }
        if (sEffect == "VFX_DUR_IOUNSTONE") { return VFX_DUR_IOUNSTONE; }
        if (sEffect == "VFX_DUR_IOUNSTONE_BLUE") { return VFX_DUR_IOUNSTONE_BLUE; }
        if (sEffect == "VFX_DUR_IOUNSTONE_GREEN") { return VFX_DUR_IOUNSTONE_GREEN; }
        if (sEffect == "VFX_DUR_IOUNSTONE_RED") { return VFX_DUR_IOUNSTONE_RED; }
        if (sEffect == "VFX_DUR_IOUNSTONE_YELLOW") { return VFX_DUR_IOUNSTONE_YELLOW; }
        if (sEffect == "VFX_DUR_LIGHT") { return VFX_DUR_LIGHT; }
        if (sEffect == "VFX_DUR_LIGHT_BLUE_10") { return VFX_DUR_LIGHT_BLUE_10; }
        if (sEffect == "VFX_DUR_LIGHT_BLUE_15") { return VFX_DUR_LIGHT_BLUE_15; }
        if (sEffect == "VFX_DUR_LIGHT_BLUE_20") { return VFX_DUR_LIGHT_BLUE_20; }
        if (sEffect == "VFX_DUR_LIGHT_BLUE_5") { return VFX_DUR_LIGHT_BLUE_5; }
        if (sEffect == "VFX_DUR_LIGHT_GREY_10") { return VFX_DUR_LIGHT_GREY_10; }
        if (sEffect == "VFX_DUR_LIGHT_GREY_15") { return VFX_DUR_LIGHT_GREY_15; }
        if (sEffect == "VFX_DUR_LIGHT_GREY_20") { return VFX_DUR_LIGHT_GREY_20; }
        if (sEffect == "VFX_DUR_LIGHT_GREY_5") { return VFX_DUR_LIGHT_GREY_5; }
        if (sEffect == "VFX_DUR_LIGHT_ORANGE_10") { return VFX_DUR_LIGHT_ORANGE_10; }
        if (sEffect == "VFX_DUR_LIGHT_ORANGE_15") { return VFX_DUR_LIGHT_ORANGE_15; }
        if (sEffect == "VFX_DUR_LIGHT_ORANGE_20") { return VFX_DUR_LIGHT_ORANGE_20; }
        if (sEffect == "VFX_DUR_LIGHT_ORANGE_5") { return VFX_DUR_LIGHT_ORANGE_5; }
        if (sEffect == "VFX_DUR_LIGHT_PURPLE_10") { return VFX_DUR_LIGHT_PURPLE_10; }
        if (sEffect == "VFX_DUR_LIGHT_PURPLE_15") { return VFX_DUR_LIGHT_PURPLE_15; }
        if (sEffect == "VFX_DUR_LIGHT_PURPLE_20") { return VFX_DUR_LIGHT_PURPLE_20; }
        if (sEffect == "VFX_DUR_LIGHT_PURPLE_5") { return VFX_DUR_LIGHT_PURPLE_5; }
        if (sEffect == "VFX_DUR_LIGHT_RED_10") { return VFX_DUR_LIGHT_RED_10; }
        if (sEffect == "VFX_DUR_LIGHT_RED_15") { return VFX_DUR_LIGHT_RED_15; }
        if (sEffect == "VFX_DUR_LIGHT_RED_20") { return VFX_DUR_LIGHT_RED_20; }
        if (sEffect == "VFX_DUR_LIGHT_RED_5") { return VFX_DUR_LIGHT_RED_5; }
        if (sEffect == "VFX_DUR_LIGHT_WHITE_10") { return VFX_DUR_LIGHT_WHITE_10; }
        if (sEffect == "VFX_DUR_LIGHT_WHITE_15") { return VFX_DUR_LIGHT_WHITE_15; }
        if (sEffect == "VFX_DUR_LIGHT_WHITE_20") { return VFX_DUR_LIGHT_WHITE_20; }
        if (sEffect == "VFX_DUR_LIGHT_WHITE_5") { return VFX_DUR_LIGHT_WHITE_5; }
        if (sEffect == "VFX_DUR_LIGHT_YELLOW_10") { return VFX_DUR_LIGHT_YELLOW_10; }
        if (sEffect == "VFX_DUR_LIGHT_YELLOW_15") { return VFX_DUR_LIGHT_YELLOW_15; }
        if (sEffect == "VFX_DUR_LIGHT_YELLOW_20") { return VFX_DUR_LIGHT_YELLOW_20; }
        if (sEffect == "VFX_DUR_LIGHT_YELLOW_5") { return VFX_DUR_LIGHT_YELLOW_5; }
        if (sEffect == "VFX_DUR_LOWLIGHTVISION") { return VFX_DUR_LOWLIGHTVISION; }
        if (sEffect == "VFX_DUR_MAGIC_RESISTANCE") { return VFX_DUR_MAGIC_RESISTANCE; }
        if (sEffect == "VFX_DUR_MAGICAL_SIGHT") { return VFX_DUR_MAGICAL_SIGHT; }
        if (sEffect == "VFX_DUR_MIND_AFFECTING_DISABLED") { return VFX_DUR_MIND_AFFECTING_DISABLED; }
        if (sEffect == "VFX_DUR_MIND_AFFECTING_DOMINATED") { return VFX_DUR_MIND_AFFECTING_DOMINATED; }
        if (sEffect == "VFX_DUR_MIND_AFFECTING_FEAR") { return VFX_DUR_MIND_AFFECTING_FEAR; }
        if (sEffect == "VFX_DUR_MIND_AFFECTING_NEGATIVE") { return VFX_DUR_MIND_AFFECTING_NEGATIVE; }
        if (sEffect == "VFX_DUR_MIND_AFFECTING_POSITIVE") { return VFX_DUR_MIND_AFFECTING_POSITIVE; }
        if (sEffect == "VFX_DUR_MIRV_ACID") { return VFX_DUR_MIRV_ACID; }
        if (sEffect == "VFX_DUR_PARALYZE_HOLD") { return VFX_DUR_PARALYZE_HOLD; }
        if (sEffect == "VFX_DUR_PARALYZED") { return VFX_DUR_PARALYZED; }
        if (sEffect == "VFX_DUR_PETRIFY") { return VFX_DUR_PETRIFY; }
        if (sEffect == "VFX_DUR_PIXIEDUST") { return VFX_DUR_PIXIEDUST; }
        if (sEffect == "VFX_DUR_PROT_BARKSKIN") { return VFX_DUR_PROT_BARKSKIN; }
        if (sEffect == "VFX_DUR_PROT_EPIC_ARMOR") { return VFX_DUR_PROT_EPIC_ARMOR; }
        if (sEffect == "VFX_DUR_PROT_EPIC_ARMOR_2") { return VFX_DUR_PROT_EPIC_ARMOR_2; }
        if (sEffect == "VFX_DUR_PROT_GREATER_STONESKIN") { return VFX_DUR_PROT_GREATER_STONESKIN; }
        if (sEffect == "VFX_DUR_PROT_PREMONITION") { return VFX_DUR_PROT_PREMONITION; }
        if (sEffect == "VFX_DUR_PROT_SHADOW_ARMOR") { return VFX_DUR_PROT_SHADOW_ARMOR; }
        if (sEffect == "VFX_DUR_PROT_STONESKIN") { return VFX_DUR_PROT_STONESKIN; }
        if (sEffect == "VFX_DUR_PROTECTION_ELEMENTS") { return VFX_DUR_PROTECTION_ELEMENTS; }
        if (sEffect == "VFX_DUR_PROTECTION_EVIL_MAJOR") { return VFX_DUR_PROTECTION_EVIL_MAJOR; }
        if (sEffect == "VFX_DUR_PROTECTION_EVIL_MINOR") { return VFX_DUR_PROTECTION_EVIL_MINOR; }
        if (sEffect == "VFX_DUR_PROTECTION_GOOD_MAJOR") { return VFX_DUR_PROTECTION_GOOD_MAJOR; }
        if (sEffect == "VFX_DUR_PROTECTION_GOOD_MINOR") { return VFX_DUR_PROTECTION_GOOD_MINOR; }
        if (sEffect == "VFX_DUR_SANCTUARY") { return VFX_DUR_SANCTUARY; }
        if (sEffect == "VFX_DUR_SMOKE") { return VFX_DUR_SMOKE; }
        if (sEffect == "VFX_DUR_SPELLTURNING") { return VFX_DUR_SPELLTURNING; }
        if (sEffect == "VFX_DUR_STONEHOLD") { return VFX_DUR_STONEHOLD; }
        if (sEffect == "VFX_DUR_TENTACLE") { return VFX_DUR_TENTACLE; }
        if (sEffect == "VFX_DUR_ULTRAVISION") { return VFX_DUR_ULTRAVISION; }
        if (sEffect == "VFX_DUR_WEB") { return VFX_DUR_WEB; }
        if (sEffect == "VFX_DUR_WEB_MASS") { return VFX_DUR_WEB_MASS; }
    }

    if (FindSubString(sEffect, "_FNF_") == 3)
    {
        if (sEffect == "VFX_FNF_DECK") { return VFX_FNF_DECK; }
        if (sEffect == "VFX_FNF_DEMON_HAND") { return VFX_FNF_DEMON_HAND; }
        if (sEffect == "VFX_FNF_DISPEL") { return VFX_FNF_DISPEL; }
        if (sEffect == "VFX_FNF_DISPEL_DISJUNCTION") { return VFX_FNF_DISPEL_DISJUNCTION; }
        if (sEffect == "VFX_FNF_DISPEL_GREATER") { return VFX_FNF_DISPEL_GREATER; }
        if (sEffect == "VFX_FNF_ELECTRIC_EXPLOSION") { return VFX_FNF_ELECTRIC_EXPLOSION; }
        if (sEffect == "VFX_FNF_FIREBALL") { return VFX_FNF_FIREBALL; }
        if (sEffect == "VFX_FNF_FIRESTORM") { return VFX_FNF_FIRESTORM; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_ACID") { return VFX_FNF_GAS_EXPLOSION_ACID; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_EVIL") { return VFX_FNF_GAS_EXPLOSION_EVIL; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_FIRE") { return VFX_FNF_GAS_EXPLOSION_FIRE; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_GREASE") { return VFX_FNF_GAS_EXPLOSION_GREASE; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_MIND") { return VFX_FNF_GAS_EXPLOSION_MIND; }
        if (sEffect == "VFX_FNF_GAS_EXPLOSION_NATURE") { return VFX_FNF_GAS_EXPLOSION_NATURE; }
        if (sEffect == "VFX_FNF_GREATER_RUIN") { return VFX_FNF_GREATER_RUIN; }
        if (sEffect == "VFX_FNF_HORRID_WILTING") { return VFX_FNF_HORRID_WILTING; }
        if (sEffect == "VFX_FNF_HOWL_MIND") { return VFX_FNF_HOWL_MIND; }
        if (sEffect == "VFX_FNF_HOWL_ODD") { return VFX_FNF_HOWL_ODD; }
        if (sEffect == "VFX_FNF_HOWL_WAR_CRY") { return VFX_FNF_HOWL_WAR_CRY; }
        if (sEffect == "VFX_FNF_HOWL_WAR_CRY_FEMALE") { return VFX_FNF_HOWL_WAR_CRY_FEMALE; }
        if (sEffect == "VFX_FNF_ICESTORM") { return VFX_FNF_ICESTORM; }
        if (sEffect == "VFX_FNF_IMPLOSION") { return VFX_FNF_IMPLOSION; }
        if (sEffect == "VFX_FNF_LOS_EVIL_10") { return VFX_FNF_LOS_EVIL_10; }
        if (sEffect == "VFX_FNF_LOS_EVIL_20") { return VFX_FNF_LOS_EVIL_20; }
        if (sEffect == "VFX_FNF_LOS_EVIL_30") { return VFX_FNF_LOS_EVIL_30; }
        if (sEffect == "VFX_FNF_LOS_HOLY_10") { return VFX_FNF_LOS_HOLY_10; }
        if (sEffect == "VFX_FNF_LOS_HOLY_20") { return VFX_FNF_LOS_HOLY_20; }
        if (sEffect == "VFX_FNF_LOS_HOLY_30") { return VFX_FNF_LOS_HOLY_30; }
        if (sEffect == "VFX_FNF_LOS_NORMAL_10") { return VFX_FNF_LOS_NORMAL_10; }
        if (sEffect == "VFX_FNF_LOS_NORMAL_20") { return VFX_FNF_LOS_NORMAL_20; }
        if (sEffect == "VFX_FNF_LOS_NORMAL_30") { return VFX_FNF_LOS_NORMAL_30; }
        if (sEffect == "VFX_FNF_MASS_HEAL") { return VFX_FNF_MASS_HEAL; }
        if (sEffect == "VFX_FNF_MASS_MIND_AFFECTING") { return VFX_FNF_MASS_MIND_AFFECTING; }
        if (sEffect == "VFX_FNF_METEOR_SWARM") { return VFX_FNF_METEOR_SWARM; }
        if (sEffect == "VFX_FNF_MYSTICAL_EXPLOSION") { return VFX_FNF_MYSTICAL_EXPLOSION; }
        if (sEffect == "VFX_FNF_NATURES_BALANCE") { return VFX_FNF_NATURES_BALANCE; }
		
        if (sEffect == "VFX_FNF_PWSTUN") { return VFX_FNF_PWSTUN; }
        if (sEffect == "VFX_FNF_SCREEN_BUMP") { return VFX_FNF_SCREEN_BUMP; }
        if (sEffect == "VFX_FNF_SCREEN_SHAKE") { return VFX_FNF_SCREEN_SHAKE; }
        if (sEffect == "VFX_FNF_SMOKE_PUFF") { return VFX_FNF_SMOKE_PUFF; }
        if (sEffect == "VFX_FNF_SOUND_BURST") { return VFX_FNF_SOUND_BURST; }
        if (sEffect == "VFX_FNF_SOUND_BURST_SILENT") { return VFX_FNF_SOUND_BURST_SILENT; }
        if (sEffect == "VFX_FNF_STORM") { return VFX_FNF_STORM; }
        if (sEffect == "VFX_FNF_STRIKE_HOLY") { return VFX_FNF_STRIKE_HOLY; }
        if (sEffect == "VFX_FNF_SUMMON_CELESTIAL") { return VFX_FNF_SUMMON_CELESTIAL; }
        if (sEffect == "VFX_FNF_SUMMON_EPIC_UNDEAD") { return VFX_FNF_SUMMON_EPIC_UNDEAD; }
        if (sEffect == "VFX_FNF_SUMMON_GATE") { return VFX_FNF_SUMMON_GATE; }
        if (sEffect == "VFX_FNF_SUMMON_MONSTER_1") { return VFX_FNF_SUMMON_MONSTER_1; }
        if (sEffect == "VFX_FNF_SUMMON_MONSTER_2") { return VFX_FNF_SUMMON_MONSTER_2; }
        if (sEffect == "VFX_FNF_SUMMON_MONSTER_3") { return VFX_FNF_SUMMON_MONSTER_3; }
        if (sEffect == "VFX_FNF_SUMMON_UNDEAD") { return VFX_FNF_SUMMON_UNDEAD; }
        if (sEffect == "VFX_FNF_SUMMONDRAGON") { return VFX_FNF_SUMMONDRAGON; }
        if (sEffect == "VFX_FNF_SUNBEAM") { return VFX_FNF_SUNBEAM; }
        if (sEffect == "VFX_FNF_SWINGING_BLADE") { return VFX_FNF_SWINGING_BLADE; }
        if (sEffect == "VFX_FNF_TIME_STOP") { return VFX_FNF_TIME_STOP; }
        if (sEffect == "VFX_FNF_UNDEAD_DRAGON") { return VFX_FNF_UNDEAD_DRAGON; }
       
        if (sEffect == "VFX_FNF_WEIRD") { return VFX_FNF_WEIRD; }
        if (sEffect == "VFX_FNF_WORD") { return VFX_FNF_WORD; }
    }

    if (FindSubString(sEffect, "_IMP_") == 3)
    {
        if (sEffect == "VFX_IMP_AC_BONUS") { return VFX_IMP_AC_BONUS; }
        if (sEffect == "VFX_IMP_ACID_L") { return VFX_IMP_ACID_L; }
        if (sEffect == "VFX_IMP_ACID_S") { return VFX_IMP_ACID_S; }
        if (sEffect == "VFX_IMP_AURA_FEAR") { return VFX_IMP_AURA_FEAR; }
        if (sEffect == "VFX_IMP_AURA_HOLY") { return VFX_IMP_AURA_HOLY; }
        if (sEffect == "VFX_IMP_AURA_NEGATIVE_ENERGY") { return VFX_IMP_AURA_NEGATIVE_ENERGY; }
        if (sEffect == "VFX_IMP_AURA_UNEARTHLY") { return VFX_IMP_AURA_UNEARTHLY; }
        if (sEffect == "VFX_IMP_BIGBYS_FORCEFUL_HAND") { return VFX_IMP_BIGBYS_FORCEFUL_HAND; }
        if (sEffect == "VFX_IMP_BLIND_DEAF_M") { return VFX_IMP_BLIND_DEAF_M; }
        if (sEffect == "VFX_IMP_BREACH") { return VFX_IMP_BREACH; }
        if (sEffect == "VFX_IMP_CHARM") { return VFX_IMP_CHARM; }
        if (sEffect == "VFX_IMP_CONFUSION_S") { return VFX_IMP_CONFUSION_S; }
        if (sEffect == "VFX_IMP_DAZED_S") { return VFX_IMP_DAZED_S; }
        if (sEffect == "VFX_IMP_DEATH") { return VFX_IMP_DEATH; }
        if (sEffect == "VFX_IMP_DEATH_L") { return VFX_IMP_DEATH_L; }
        if (sEffect == "VFX_IMP_DEATH_WARD") { return VFX_IMP_DEATH_WARD; }
        if (sEffect == "VFX_IMP_DESTRUCTION") { return VFX_IMP_DESTRUCTION; }
        if (sEffect == "VFX_IMP_DISEASE_S") { return VFX_IMP_DISEASE_S; }
        if (sEffect == "VFX_IMP_DISPEL") { return VFX_IMP_DISPEL; }
        if (sEffect == "VFX_IMP_DISPEL_DISJUNCTION") { return VFX_IMP_DISPEL_DISJUNCTION; }
        if (sEffect == "VFX_IMP_DIVINE_STRIKE_FIRE") { return VFX_IMP_DIVINE_STRIKE_FIRE; }
        if (sEffect == "VFX_IMP_DIVINE_STRIKE_HOLY") { return VFX_IMP_DIVINE_STRIKE_HOLY; }
        if (sEffect == "VFX_IMP_DOMINATE_S") { return VFX_IMP_DOMINATE_S; }
        if (sEffect == "VFX_IMP_DOOM") { return VFX_IMP_DOOM; }
        if (sEffect == "VFX_IMP_DUST_EXPLOSION") { return VFX_IMP_DUST_EXPLOSION; }
        if (sEffect == "VFX_IMP_ELEMENTAL_PROTECTION") { return VFX_IMP_ELEMENTAL_PROTECTION; }
        if (sEffect == "VFX_IMP_EVIL_HELP") { return VFX_IMP_EVIL_HELP; }
        if (sEffect == "VFX_IMP_FEAR_S") { return VFX_IMP_FEAR_S; }
        if (sEffect == "VFX_IMP_FLAME_M") { return VFX_IMP_FLAME_M; }
        if (sEffect == "VFX_IMP_FLAME_S") { return VFX_IMP_FLAME_S; }
        if (sEffect == "VFX_IMP_FORTITUDE_SAVING_THROW_USE") { return VFX_IMP_FORTITUDE_SAVING_THROW_USE; }
        if (sEffect == "VFX_IMP_FROST_L") { return VFX_IMP_FROST_L; }
        if (sEffect == "VFX_IMP_FROST_S") { return VFX_IMP_FROST_S; }
        if (sEffect == "VFX_IMP_GLOBE_USE") { return VFX_IMP_GLOBE_USE; }
        if (sEffect == "VFX_IMP_GOOD_HELP") { return VFX_IMP_GOOD_HELP; }
        if (sEffect == "VFX_IMP_GREASE") { return VFX_IMP_GREASE; }
        if (sEffect == "VFX_IMP_HARM") { return VFX_IMP_HARM; }
        if (sEffect == "VFX_IMP_HASTE") { return VFX_IMP_HASTE; }
        if (sEffect == "VFX_IMP_HEAD_ACID") { return VFX_IMP_HEAD_ACID; }
        if (sEffect == "VFX_IMP_HEAD_COLD") { return VFX_IMP_HEAD_COLD; }
        if (sEffect == "VFX_IMP_HEAD_ELECTRICITY") { return VFX_IMP_HEAD_ELECTRICITY; }
        if (sEffect == "VFX_IMP_HEAD_EVIL") { return VFX_IMP_HEAD_EVIL; }
        if (sEffect == "VFX_IMP_HEAD_FIRE") { return VFX_IMP_HEAD_FIRE; }
        if (sEffect == "VFX_IMP_HEAD_HEAL") { return VFX_IMP_HEAD_HEAL; }
        if (sEffect == "VFX_IMP_HEAD_HOLY") { return VFX_IMP_HEAD_HOLY; }
        if (sEffect == "VFX_IMP_HEAD_MIND") { return VFX_IMP_HEAD_MIND; }
        if (sEffect == "VFX_IMP_HEAD_NATURE") { return VFX_IMP_HEAD_NATURE; }
        if (sEffect == "VFX_IMP_HEAD_ODD") { return VFX_IMP_HEAD_ODD; }
        if (sEffect == "VFX_IMP_HEAD_SONIC") { return VFX_IMP_HEAD_SONIC; }
        if (sEffect == "VFX_IMP_HEALING_G") { return VFX_IMP_HEALING_G; }
        if (sEffect == "VFX_IMP_HEALING_L") { return VFX_IMP_HEALING_L; }
        if (sEffect == "VFX_IMP_HEALING_M") { return VFX_IMP_HEALING_M; }
        if (sEffect == "VFX_IMP_HEALING_S") { return VFX_IMP_HEALING_S; }
        if (sEffect == "VFX_IMP_HEALING_X") { return VFX_IMP_HEALING_X; }
        if (sEffect == "VFX_IMP_HOLY_AID") { return VFX_IMP_HOLY_AID; }
        if (sEffect == "VFX_IMP_IMPROVE_ABILITY_SCORE") { return VFX_IMP_IMPROVE_ABILITY_SCORE; }
        if (sEffect == "VFX_IMP_KNOCK") { return VFX_IMP_KNOCK; }
        if (sEffect == "VFX_IMP_LIGHTNING_M") { return VFX_IMP_LIGHTNING_M; }
        if (sEffect == "VFX_IMP_LIGHTNING_S") { return VFX_IMP_LIGHTNING_S; }
        if (sEffect == "VFX_IMP_MAGBLUE") { return VFX_IMP_MAGBLUE; }
        if (sEffect == "VFX_IMP_MAGIC_PROTECTION") { return VFX_IMP_MAGIC_PROTECTION; }
        if (sEffect == "VFX_IMP_MAGIC_RESISTANCE_USE") { return VFX_IMP_MAGIC_RESISTANCE_USE; }
        if (sEffect == "VFX_IMP_MAGICAL_VISION") { return VFX_IMP_MAGICAL_VISION; }
        if (sEffect == "VFX_IMP_MIRV") { return VFX_IMP_MIRV; }
        if (sEffect == "VFX_IMP_MIRV_ELECTRIC") { return VFX_IMP_MIRV_ELECTRIC; }
        if (sEffect == "VFX_IMP_MIRV_FLAME") { return VFX_IMP_MIRV_FLAME; }
        if (sEffect == "VFX_IMP_NEGATIVE_ENERGY") { return VFX_IMP_NEGATIVE_ENERGY; }
        if (sEffect == "VFX_IMP_POISON_L") { return VFX_IMP_POISON_L; }
        if (sEffect == "VFX_IMP_POISON_S") { return VFX_IMP_POISON_S; }
        if (sEffect == "VFX_IMP_POLYMORPH") { return VFX_IMP_POLYMORPH; }
        if (sEffect == "VFX_IMP_PULSE_COLD") { return VFX_IMP_PULSE_COLD; }
        if (sEffect == "VFX_IMP_PULSE_FIRE") { return VFX_IMP_PULSE_FIRE; }
        if (sEffect == "VFX_IMP_PULSE_HOLY") { return VFX_IMP_PULSE_HOLY; }
        if (sEffect == "VFX_IMP_PULSE_HOLY_SILENT") { return VFX_IMP_PULSE_HOLY_SILENT; }
        if (sEffect == "VFX_IMP_PULSE_NATURE") { return VFX_IMP_PULSE_NATURE; }
        if (sEffect == "VFX_IMP_PULSE_NEGATIVE") { return VFX_IMP_PULSE_NEGATIVE; }
        if (sEffect == "VFX_IMP_PULSE_WATER") { return VFX_IMP_PULSE_WATER; }
        if (sEffect == "VFX_IMP_PULSE_WIND") { return VFX_IMP_PULSE_WIND; }
        if (sEffect == "VFX_IMP_RAISE_DEAD") { return VFX_IMP_RAISE_DEAD; }
        if (sEffect == "VFX_IMP_REDUCE_ABILITY_SCORE") { return VFX_IMP_REDUCE_ABILITY_SCORE; }
        if (sEffect == "VFX_IMP_REFLEX_SAVE_THROW_USE") { return VFX_IMP_REFLEX_SAVE_THROW_USE; }
        if (sEffect == "VFX_IMP_REMOVE_CONDITION") { return VFX_IMP_REMOVE_CONDITION; }
        if (sEffect == "VFX_IMP_RESTORATION") { return VFX_IMP_RESTORATION; }
        if (sEffect == "VFX_IMP_RESTORATION_GREATER") { return VFX_IMP_RESTORATION_GREATER; }
        if (sEffect == "VFX_IMP_RESTORATION_LESSER") { return VFX_IMP_RESTORATION_LESSER; }
        if (sEffect == "VFX_IMP_SILENCE") { return VFX_IMP_SILENCE; }
        if (sEffect == "VFX_IMP_SLEEP") { return VFX_IMP_SLEEP; }
        if (sEffect == "VFX_IMP_SLOW") { return VFX_IMP_SLOW; }
        if (sEffect == "VFX_IMP_SONIC") { return VFX_IMP_SONIC; }
        if (sEffect == "VFX_IMP_SPELL_MANTLE_USE") { return VFX_IMP_SPELL_MANTLE_USE; }
        if (sEffect == "VFX_IMP_SPIKE_TRAP") { return VFX_IMP_SPIKE_TRAP; }
        if (sEffect == "VFX_IMP_STUN") { return VFX_IMP_STUN; }
        if (sEffect == "VFX_IMP_SUNSTRIKE") { return VFX_IMP_SUNSTRIKE; }
        if (sEffect == "VFX_IMP_SUPER_HEROISM") { return VFX_IMP_SUPER_HEROISM; }
        if (sEffect == "VFX_IMP_TORNADO") { return VFX_IMP_TORNADO; }
        if (sEffect == "VFX_IMP_UNSUMMON") { return VFX_IMP_UNSUMMON; }
        if (sEffect == "VFX_IMP_WALLSPIKE") { return VFX_IMP_WALLSPIKE; }
        if (sEffect == "VFX_IMP_WILL_SAVING_THROW_USE") { return VFX_IMP_WILL_SAVING_THROW_USE; }
    }

    return VFX_NONE;
}

int _getSavingThrow(object oCreature, string sType, int nDC)
{
    if (sType == "FORTITUDE") { return FortitudeSave(oCreature, nDC); }
    if (sType == "REFLEX") { return ReflexSave(oCreature, nDC); }
    if (sType == "WILL") { return WillSave(oCreature, nDC); }

    return FALSE;
}

string _getLightShaft(string sVisualEffect)
{
    if (sVisualEffect == "VFX_SHAFT_RED") { return SHAFT_RED_TAG; }
    if (sVisualEffect == "VFX_SHAFT_BLUE") { return SHAFT_BLUE_TAG; }
    if (sVisualEffect == "VFX_SHAFT_CYAN") { return SHAFT_CYAN_TAG; }
    if (sVisualEffect == "VFX_SHAFT_WHITE") { return SHAFT_WHITE_TAG; }
    if (sVisualEffect == "VFX_SHAFT_GREEN") { return SHAFT_GREEN_TAG; }
    if (sVisualEffect == "VFX_SHAFT_ORANGE") { return SHAFT_ORANGE_TAG; }
    if (sVisualEffect == "VFX_SHAFT_YELLOW") { return SHAFT_YELLOW_TAG; }
    if (sVisualEffect == "VFX_SHAFT_PURPLE") { return SHAFT_PURPLE_TAG; }

    return "";
}

void _applyVisualEffect(string sVisualEffect, object oTarget, int bMissEffect)
{
    // Exit if a visual effect has not been provided
    if (sVisualEffect == "") { return; }

    int nBegin=0, nLen=GetStringLength(sVisualEffect), nEnd=FindSubString(sVisualEffect, "/");

    // Make sure the effects information is formatted properly
    if (nEnd > 0)
    {
        // Get the desired effect constant
        string sEffect = GetSubString(sVisualEffect, nBegin, nEnd);

        // Get the desired effect duration
        float fDuration = StringToFloat(GetSubString(sVisualEffect, nEnd + 1, nLen - nEnd));

        // Create the visual effect and apply it to the object
        if (FindSubString(sEffect, "_SHAFT_") > 0)
        {
            string sLightShaft = _getLightShaft(sEffect);

            // Exit if the light shaft has been created already
            if (GetResRef(GetNearestObject(OBJECT_TYPE_PLACEABLE)) == sLightShaft) { return; }

            // Create the light shaft at the target location
            object oLightShaft = CreateObject(OBJECT_TYPE_PLACEABLE, sLightShaft, GetLocation(OBJECT_SELF), TRUE);

            // Destroy the placeable if an expiration is specified
            if (fDuration > 0.0) { DestroyObject(oLightShaft, fDuration); }
        }
        // Tracing effects (requires beams)
        else if (FindSubString(sEffect, "_TRACE_") > 0)
        {
            // Get the vectors
            vector vInitial = _createVectorFromString(GetLocalString(OBJECT_SELF, "EFFECT_TRACE_INITIAL"));
            vector vFinal = _createVectorFromString(GetLocalString(OBJECT_SELF, "EFFECT_TRACE_FINAL"));

            // Determine the vector distance
            vector vDelta = vFinal - vInitial;

            // Determine the scalar distance
            float fDistance = sqrt(vDelta.x * vDelta.x + vDelta.y * vDelta.y + vDelta.z * vDelta.z);

            // Exit if there is no distance to travel
            if (fDistance == 0.0) { return; }

            // Determine the number of 0.1 increments needed to move the total distance
            int nCount = FloatToInt(fDistance/0.1);

            // Determine the trace rate
            float fRate = fDuration/nCount;

            // Determine the movement increments
            vDelta.x = vDelta.x/nCount;
            vDelta.y = vDelta.y/nCount;
            vDelta.z = vDelta.z/nCount;

            // Determine the beam constant
            int nBeam = _getVFXConstant(GetSubString(sEffect, 0, 3) + GetSubString(sEffect, 9, GetStringLength(sEffect) - 9));

            // Fire away!
            _vFXTrace(vInitial, vDelta, nCount, nBeam, fRate, BODY_NODE_CHEST);
        }
        // Pulsing effects
        else if (FindSubString(sEffect, "_PULSE_") > 0)
        {
            // Get the vectors
            vector vInitial = _createVectorFromString(GetLocalString(OBJECT_SELF, "EFFECT_PULSE_INITIAL"));
            vector vFinal = _createVectorFromString(GetLocalString(OBJECT_SELF, "EFFECT_PULSE_FINAL"));

            // If no initial vector is provided, set an initial vector position
            if (vInitial == Vector(0.0,0.0,0.0)) { vInitial = GetPositionFromLocation(GetLocation(OBJECT_SELF)); }

            // Determine the vector distance
            vector vDelta = vFinal - vInitial;

            // Determine the scalar distance
            float fDistance = sqrt(vDelta.x * vDelta.x + vDelta.y * vDelta.y + vDelta.z * vDelta.z);

            // If no final vector is provided, pulsing should be stationary
            if (vFinal == Vector(0.0,0.0,0.0)) { fDistance = 0.0; }

            // If the pulse is stationary, only duration matters
            if (fDistance == 0.0) { fDistance = fDuration; }

            // Determine the trace rate
            float fRate = fDuration/fDistance;

            // Determine the visual effect constant
            int nVFX = _getVFXConstant(GetSubString(sEffect, 0, 3) + GetSubString(sEffect, 9, GetStringLength(sEffect) - 9));

            // Fire away! (1 effect per ft of distance)
            _vFXPulse(vInitial, vDelta, FloatToInt(fDistance), nVFX, fRate);
        }
        // This should always follow the custom effects
        else if (FindSubString(sEffect, "_BEAM_") > 0)
        {
            effect eVisualEffect = EffectBeam(_getVFXConstant(sEffect), OBJECT_SELF, BODY_NODE_CHEST, bMissEffect);

            // Remove any existing effects if the player triggers multiple times
            if (GetHasEffect(GetEffectType(eVisualEffect), oTarget)) { RemoveEffect(oTarget, eVisualEffect); }

            // Apply the effect as either permanent or having a duration
            if (fDuration > 0.0)
            {
                // Temporary effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisualEffect, oTarget, fDuration);
            }
            else
            {
                // Permanent effect
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisualEffect, oTarget);
            }
        }
        // Otherwise, just a standard visual effect
        else
        {
            effect eVisualEffect = EffectVisualEffect(_getVFXConstant(sEffect), bMissEffect);

            // Exit if the effect already exists
            if (GetHasEffect(GetEffectType(eVisualEffect), oTarget)) { return; }

            // Apply the effect as either permanent or having a duration
            if (fDuration > 0.0)
            {
                // Temporary effect
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVisualEffect, GetLocation(oTarget), fDuration);
            }
            else
            {
                // Permanent/Instantaneous effect
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisualEffect, GetLocation(oTarget));
            }
        }
    }
}

void _applyPhysicalEffect(string sPhysicalEffect, object oTarget, int nAmount)
{
    // Exit if a physical effect has not been provided or creature saved
    if (sPhysicalEffect == "") { return; }

    int nBegin=0, nLen=GetStringLength(sPhysicalEffect), nEnd=FindSubString(sPhysicalEffect, "/");

    // Make sure the effects information is formatted properly
    if (nEnd > 0)
    {
        // Get the desired effect constant
        string sEffect = GetSubString(sPhysicalEffect, nBegin, nEnd);

        // Get the desired effect duration
        float fDuration = StringToFloat(GetSubString(sPhysicalEffect, nEnd + 1, nLen - nEnd));

        // Determine which physical effect to apply
        effect ePhysicalEffect; int nDurationType;

        // Create the physical effect
        if ((nEnd=FindSubString(sEffect, "ABILITY_DECREASE_")) == 0)
        {
            string sAttribute = GetSubString(sEffect, 17, GetStringLength(sEffect) - 16);

            // Determine which attribute to apply the modifier to
            if (sAttribute == "STR")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_STRENGTH, nAmount);
            }
            else if (sAttribute == "DEX")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_DEXTERITY, nAmount);
            }
            else if (sAttribute == "CON")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_CONSTITUTION, nAmount);
            }
            else if (sAttribute == "INT")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nAmount);
            }
            else if (sAttribute == "WIS")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_WISDOM, nAmount);
            }
            else if (sAttribute == "CHA")
            {
                ePhysicalEffect = EffectAbilityDecrease(ABILITY_CHARISMA, nAmount);
            }
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "ABILITY_INCREASE_")) == 0)
        {
            string sAttribute = GetSubString(sEffect, 17, GetStringLength(sEffect) - 16);

            // Determine which attribute to apply the modifier to
            if (sAttribute == "STR")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_STRENGTH, nAmount);
            }
            else if (sAttribute == "DEX")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_DEXTERITY, nAmount);
            }
            else if (sAttribute == "CON")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION, nAmount);
            }
            else if (sAttribute == "INT")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, nAmount);
            }
            else if (sAttribute == "WIS")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_WISDOM, nAmount);
            }
            else if (sAttribute == "CHA")
            {
                ePhysicalEffect = EffectAbilityIncrease(ABILITY_CHARISMA, nAmount);
            }
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "AC_DECREASE")
        {
            ePhysicalEffect = EffectACDecrease(nAmount, AC_NATURAL_BONUS);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "AC_INCREASE")
        {
            ePhysicalEffect = EffectACIncrease(nAmount, AC_NATURAL_BONUS);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "AB_DECREASE")
        {
            ePhysicalEffect = EffectAttackDecrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "AB_INCREASE")
        {
            ePhysicalEffect = EffectAttackIncrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "ABSORB_SPELL_LEVEL")
        {
            ePhysicalEffect = EffectSpellLevelAbsorption(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "AOE")
        {
            EffectAreaOfEffect(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "BLINDNESS")
        {
            ePhysicalEffect = EffectBlindness();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "CAGE")
        {
            object oCage = CreateObject(OBJECT_TYPE_PLACEABLE, "acr_pl_mi_cage", GetLocation(oTarget), TRUE);
            if (fDuration > 0.0) { DestroyObject(oCage, fDuration); }
        }
        else if (sEffect == "CHARM")
        {
            ePhysicalEffect = EffectCharmed();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "CONFUSED")
        {
            ePhysicalEffect = EffectConfused();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
            SendMessageToPC(oTarget, "You suddenly feel confused...");
        }
        else if (sEffect == "CONCEALMENT")
        {
            ePhysicalEffect = EffectConcealment(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "CURSED_")) == 0)
        {
            string sAttribute = GetSubString(sEffect, 7, GetStringLength(sEffect) - 6);

            // Determine which attribute to apply the curse to
            if (sAttribute == "STR")
            {
                ePhysicalEffect = EffectCurse(nAmount, 0, 0, 0, 0, 0);
            }
            else if (sAttribute == "DEX")
            {
                ePhysicalEffect = EffectCurse(0, nAmount, 0, 0, 0, 0);
            }
            else if (sAttribute == "CON")
            {
                ePhysicalEffect = EffectCurse(0, 0, nAmount, 0, 0, 0);
            }
            else if (sAttribute == "INT")
            {
                ePhysicalEffect = EffectCurse(0, 0, 0, nAmount, 0, 0);
            }
            else if (sAttribute == "WIS")
            {
                ePhysicalEffect = EffectCurse(0, 0, 0, 0, nAmount, 0);
            }
            else if (sAttribute == "CHA")
            {
                ePhysicalEffect = EffectCurse(0, 0, 0, 0, 0, nAmount);
            }
            else // (sAttribute == "ALL")
            {
                ePhysicalEffect = EffectCurse(nAmount, nAmount, nAmount, nAmount, nAmount, nAmount);
            }
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DAMAGE")
        {
            ePhysicalEffect = EffectDamage(nAmount);
            nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "DAMAGE_DECREASE")
        {
            ePhysicalEffect = EffectDamageDecrease(nAmount, DAMAGE_TYPE_BASE_WEAPON);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DAMAGE_INCREASE")
        {
            ePhysicalEffect = EffectDamageIncrease(nAmount, DAMAGE_TYPE_BASE_WEAPON);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DAMAGE_RESISTANCE")
        {
            ePhysicalEffect = EffectDamageResistance(DAMAGE_TYPE_BASE_WEAPON, nAmount, FloatToInt(fDuration));
            nDurationType = DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DAMAGE_SHIELD")
        {
            ePhysicalEffect = EffectDamageShield(nAmount, 0, DAMAGE_TYPE_BASE_WEAPON);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DARKNESS")
        {
            ePhysicalEffect = EffectDarkness();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DAZED")
        {
            ePhysicalEffect = EffectDazed();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DEAF")
        {
            ePhysicalEffect = EffectDeaf();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DEATH")
        {
            ePhysicalEffect = EffectDeath(nAmount);
            nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "DISAPPEAR")
        {
            ePhysicalEffect = EffectDisappearAppear(GetLocation(oTarget));
            nDurationType = DURATION_TYPE_TEMPORARY;
        }
        else if (sEffect == "DISEASE")
        {
            ePhysicalEffect = EffectDisease(nAmount);
            nDurationType = DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "DISPEL_MAGIC_ALL")
        {
            //ePhysicalEffect = EffectDispelMagicAll(nAmount);
            //nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "DISPEL_MAGIC_BEST")
        {
            //ePhysicalEffect = EffectDispelMagicBest(nAmount);
            //nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "DOMINATED")
        {
            ePhysicalEffect = EffectDominated(); // Only makes sense when used against two creatures
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "ENTANGLE")
        {
            ePhysicalEffect = EffectEntangle();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "ETHEREAL")
        {
            ePhysicalEffect = EffectEthereal();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "FRIGHTENED")
        {
            ePhysicalEffect = EffectFrightened();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "HASTE")
        {
            ePhysicalEffect = EffectHaste();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "HEAL")
        {
            ePhysicalEffect = EffectHeal(nAmount);
            nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "IMMUNITY")
        {
            ePhysicalEffect = EffectImmunity(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "INVISIBILITY_NORMAL")
        {
            ePhysicalEffect = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "INVISIBILITY_IMPROVED")
        {
            ePhysicalEffect = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "INVISIBILITY_DARKNESS")
        {
            ePhysicalEffect = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "KNOCKDOWN")
        {
            ePhysicalEffect = EffectKnockdown();
            nDurationType = DURATION_TYPE_TEMPORARY; // Permanent knockdown makes no sense

            // The animation for this effect requires at least 3 seconds
            if (fDuration < 3.0) { fDuration = 3.0; }

            // Apply damage as well since this is really a "contact" effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nAmount), oTarget);
        }
        else if (sEffect == "MODIFY_ATTACKS")
        {
            ePhysicalEffect = EffectModifyAttacks(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPEED_DECREASE")
        {
            ePhysicalEffect = EffectMovementSpeedDecrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPEED_INCREASE")
        {
            ePhysicalEffect = EffectMovementSpeedIncrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "NEGATIVE_LEVEL")
        {
            ePhysicalEffect = EffectNegativeLevel(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "PARALYZE")
        {
            ePhysicalEffect = EffectParalyze();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "PETRIFY")
        {
            ePhysicalEffect = EffectPetrify();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "POISON")
        {
            ePhysicalEffect = EffectPoison(nAmount);
            nDurationType = DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "POLYMORPH")
        {
            ePhysicalEffect = EffectPolymorph(nAmount, TRUE);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "REGENERATE")
        {
            ePhysicalEffect = EffectRegenerate(nAmount, 6.0);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "RESSURECTION")
        {
            ePhysicalEffect = EffectResurrection();
            nDurationType = DURATION_TYPE_INSTANT;
        }
        else if (sEffect == "SANCTUARY")
        {
            ePhysicalEffect = EffectSanctuary(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SEE_INVISIBLE")
        {
            ePhysicalEffect = EffectSeeInvisible();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SILENCE")
        {
            ePhysicalEffect = EffectSilence();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SLEEP")
        {
            ePhysicalEffect = EffectSleep();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SLOW")
        {
            ePhysicalEffect = EffectSlow();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPELL_FAILURE")
        {
            ePhysicalEffect = EffectSpellFailure(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPELL_IMMUNITY")
        {
            ePhysicalEffect = EffectSpellImmunity(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPELL_RESISTANCE_DECREASE")
        {
            ePhysicalEffect = EffectSpellResistanceDecrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "SPELL_RESISTANCE_INCREASE")
        {
            ePhysicalEffect = EffectSpellResistanceIncrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "ST_DECREASE_")) == 0)
        {
            string sSavingThrow = GetSubString(sEffect, 12, GetStringLength(sEffect) - 11);

            // determine which type of saving throw to apply the effect to
            if (sSavingThrow == "FORTITUDE")
            {
                ePhysicalEffect = EffectSavingThrowDecrease(SAVING_THROW_FORT, nAmount);
            }
            else if (sSavingThrow == "REFLEX")
            {
                ePhysicalEffect = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nAmount);
            }
            else if (sSavingThrow == "WILL")
            {
                ePhysicalEffect = EffectSavingThrowDecrease(SAVING_THROW_WILL, nAmount);
            }
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "ST_INCREASE_")) == 0)
        {
            string sSavingThrow = GetSubString(sEffect, 12, GetStringLength(sEffect) - 11);

            // determine which type of saving throw to apply the effect to
            if (sSavingThrow == "FORTITUDE")
            {
                ePhysicalEffect = EffectSavingThrowIncrease(SAVING_THROW_FORT, nAmount);
            }
            else if (sSavingThrow == "REFLEX")
            {
                ePhysicalEffect = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nAmount);
            }
            else if (sSavingThrow == "WILL")
            {
                ePhysicalEffect = EffectSavingThrowIncrease(SAVING_THROW_WILL, nAmount);
            }
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "STUNNED")
        {
            ePhysicalEffect = EffectStunned();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "SUMMON_")) == 0)
        {
            string sCreatureTemplate = GetSubString(sEffect, 7, GetStringLength(sEffect) - 6);

            ePhysicalEffect = EffectSummonCreature(sCreatureTemplate, nAmount, 1.0, TRUE);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if ((nEnd=FindSubString(sEffect, "SWARM_")) == 0)
        {
            string sCreatureTemplate = GetSubString(sEffect, 6, GetStringLength(sEffect) - 5);

            ePhysicalEffect = EffectSwarm(TRUE, sCreatureTemplate);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TEMP_HITPOINTS")
        {
            ePhysicalEffect = EffectTemporaryHitpoints(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TURN_RESISTANCE_DECREASE")
        {
            ePhysicalEffect = EffectTurnResistanceDecrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TURN_RESISTANCE_INCREASE")
        {
            ePhysicalEffect = EffectTurnResistanceIncrease(nAmount);
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TIME_STOP")
        {
            ePhysicalEffect = EffectTimeStop();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TRUE_SEEING")
        {
            ePhysicalEffect = EffectTrueSeeing();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "TURNED")
        {
            ePhysicalEffect = EffectTurned();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
        else if (sEffect == "ULTRAVISION")
        {
            ePhysicalEffect = EffectUltravision();
            nDurationType = (fDuration > 0.0) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT;
        }
/*
        else if (sEffect == "DamageImmunity")
        {
            EffectDamageImmunityDecrease();
        }
        else if (sEffect == "DamageImmunity")
        {
            EffectDamageImmunityIncrease();
        }
        else if (sEffect == "DamageImmunity")
        {
            EffectDamageReduction();
        }
        else if (sEffect == "SKILL_DECREASE")
        {
            EffectSkillDecrease();
        }
        else if (sEffect == "SKILL_INCREASE")
        {
            EffectSkillIncrease();
        }
*/

        // Apply the effect
        ApplyEffectToObject(nDurationType, ePhysicalEffect, oTarget, fDuration);
    }
}

int _applyDamage(string sDamageEffect, string sPhysicalEffect, object oTarget)
{
    int nDamage=0, nBegin=0, nLen=GetStringLength(sDamageEffect), nEnd=FindSubString(sDamageEffect, "/");

    // Make sure the damage information is formatted properly, if it exists
    if (nEnd > 0)
    {
        // Get the damage
        nDamage = StringToInt(GetSubString(sDamageEffect, nBegin, nEnd));

        nBegin = nEnd + 1;
        sDamageEffect = GetSubString(sDamageEffect, nBegin, nLen - nEnd);
        nBegin = 0; nEnd = FindSubString(sDamageEffect, "/"); nLen = GetStringLength(sDamageEffect);

        // Get the save type
        string sType = GetSubString(sDamageEffect, nBegin, nEnd);

        // Get the desired effect duration
        int nDC = StringToInt(GetSubString(sDamageEffect, nEnd + 1, nLen - nEnd));

        // Target made the save
        if (_getSavingThrow(oTarget, sType, nDC) > 0) { return TRUE; }
    }
    // Target failed the save or didn't get one

    // Apply the listed physical effect
    _applyPhysicalEffect(sPhysicalEffect, oTarget, nDamage);

    return FALSE;
}

void _vFXTrace(vector vCurrent, vector vDelta, int nCount, int nBeam, float fDelay, int nNode)
{
    // Move the current position vector and decrement the recursion counter
    vCurrent += vDelta; nCount--;

    location lCurrent = Location(GetArea(OBJECT_SELF), vCurrent, GetFacing(OBJECT_SELF));
    object oTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj", lCurrent);
    effect eBeam = EffectBeam(nBeam, OBJECT_SELF, nNode);

    // Schedule the next effect
    if (nCount > 0) { DelayCommand(fDelay, _vFXTrace(vCurrent, vDelta, nCount, nBeam, fDelay, nNode)); }

    // The engine has a rendering threshold we can't go below
    if (fDelay < 0.5) { fDelay = 0.5; }

    // Apply the beam effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, fDelay);

    // Destroy the target object after it's been used (and rendered)
    DestroyObject(oTarget, fDelay);
}

void _vFXPulse(vector vCurrent, vector vDelta, int nCount, int nVFX, float fDelay)
{
    // Move the current position vector and decrement the recursion counter
    vCurrent += vDelta; nCount--;

    location lCurrent = Location(GetArea(OBJECT_SELF), vCurrent, GetFacing(OBJECT_SELF));
    effect eVFX = EffectVisualEffect(nVFX);

    // Schedule the next effect
    if (nCount > 0) { DelayCommand(fDelay, _vFXPulse(vCurrent, vDelta, nCount, nVFX, fDelay)); }

    // Apply the visual effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVFX, lCurrent, fDelay);
}

vector _createVectorFromString(string sVectorString)
{
    int nBegin=0, nEnd, nLen=GetStringLength(sVectorString); vector vVector;

    // String argument must use the coordinate format x,y,z
    nEnd = FindSubString(sVectorString, ",");
    vVector.x = StringToFloat(GetSubString(sVectorString, nBegin, nEnd - nBegin));

    nBegin = nEnd + 1;
    nEnd += FindSubString(GetSubString(sVectorString, nBegin, nLen - nEnd), ",") + 1;
    vVector.y = StringToFloat(GetSubString(sVectorString, nBegin, nEnd - nBegin));

    nBegin = nEnd + 1;
    vVector.z = StringToFloat(GetSubString(sVectorString, nBegin, nLen - nEnd));

    return vVector;
}
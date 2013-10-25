////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_scry_i
//    $Revision:: 153         $ current version of the file
//        $Date:: 2006-10-09 #$ date the file was created or modified
//       Author : ç i p h é r
//
//    Var Prefix: ACR_SCRY
//  Dependencies: Scrying Mirror, Holy Water Font, Natural Pool of Water
//
//  Description
//  This is the include file shared by Scrying and Greater Scrying spells.
//
//  Revision History
//  2005/12/10  ç i p h é r  Inception
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_SCRY_I
#define ACR_SCRY_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// temporary item property - THIS NEEDS TO BE DEFINED GLOBALLY
int ITEM_PROPERTY_NON_DETECTION = 85;

// scrying object(s) tag - all objects that are valid scrying targets should use this
const string ACR_SCRY_OBJECT = "ACR_SCRY_OBJECT";

// scrying target types
const int ACR_SCRY_CREATURE = 0;
const int ACR_SCRY_LOCATION = 1;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// *** PUBLIC FUNCTIONS ***

//! End the scrying spell function
//!  - oCaster: the player who's currently casting scrying
//!  - Returns: nothing
//! Call this function from the OnCutSceneAbort event handler and OnPlayerAttacked
void ACR_ScryEnd(object oCaster);

//! Start the scrying spell function
//!  - oCaster: player casting scrying
//!  - fMultiplier: number of minutes/level the spell will last
//!  - Returns: nothing
//! Call this function from the spell script
void ACR_ScryBegin(object oCaster, float fMultiplier=1.0);

//! Track the number of non-detection items a player has
//!  - oItem: item the player acquired
//!  - oCreature: creature acquiring the item
//!  - Returns: nothing
//! Call this from the module OnItemAcquired event
void ACR_ManageNonDetectionOnAcquire(object oItem, object oCreature);

//! Track the number of non-detection items a player drops
//!  - oItem: item the player dropped
//!  - oCreature: creature dropping the item
//!  - Returns: nothing
//! Call this from the module OnItemUnAcquired event
void ACR_ManageNonDetectionOnUnAcquire(object oItem, object oCreature);

//! Track the PCs and NPCs this player perceives
//!  - oPerceived: creature the player perceived
//!  - oCreature: creature perceiving the PC/NPC
//!  - Returns: nothing
//! Call this from the player OnPerception event
void ACR_ManageKnowledgeOnPerception(object oPerceived, object oCreature);

//! Track the player's desired saved locations
//!  - oLocation: location the player wants to save
//!  - oCreature: creature saving the location
//!  - Returns: nothing
//! Call this from the saving stone OnUse event
void ACR_ManageKnowledgeOnLocationSave(location lLocation, object oCreature);

//! Determine if a creature is non-detectable
//!  - oCreature: creature to examine
//!  - Returns: TRUE if oCreature is non-detectable, FALSE otherwise
int ACR_GetIsNonDetectable(object oCreature);

//! Determine if a creature is attempting to scry
//!  - oCreature: creature to examine
//!  - Returns: TRUE if oCreature is scrying, FALSE otherwise
int ACR_GetIsScrying(object oCreature);

//! Determine if a creature is scrying on a specific target
//!  - oCreature: creature to examine
//!  - oTarget: object to examine
//!  - Returns: TRUE if oCreature is scrying on oTarget, FALSE otherwise
int ACR_GetIsScryingTarget(object oCreature, object oTarget);

//! Determine if an object is a recognized scrying device
//!  - oObject: object to examine
//!  - Returns: TRUE if oObject is a recognized scrying device, FALSE otherwise
int ACR_GetIsScryingDevice(object oObject);

// *** PRIVATE FUNCTIONS ***

//! Rotate the players camera
//!  - oCaster: player who's camera to rotate
//!  - Returns: nothing
void _rotateCamera(object oCaster);

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "nw_i0_spells"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_ScryBegin(object oCaster, float fMultiplier=1.0)
{
    // Flag the scrying condition and record the scrying location
    SetLocalInt(oCaster, "ACR_SCRY_SCRYING", 1);
    SetLocalLocation(oCaster, "ACR_SCRY_LOCATION", GetLocation(oCaster));

    // Compute the duration in seconds per level
    float fDuration = GetCasterLevel(oCaster) * fMultiplier * 60.0;

    // Fade out the PC
    ActionDoCommand(FadeToBlack(oCaster, FADE_SPEED_FAST));

    ActionWait(1.0);

    // Disable then re-enable cutscene mode to avoid any possibility of stacking
    ActionDoCommand(SetCutsceneMode(oCaster, FALSE));
    ActionDoCommand(SetCutsceneMode(oCaster, TRUE));

    // Make the PC completely invisible
    effect eVFX   = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    effect eGhost = EffectCutsceneGhost();
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oCaster));
    ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oCaster));

    // Adjust the camera perspective
    //ActionDoCommand(SetCameraFacing(abs(FloatToInt(GetFacing(oTarget)) - 180) * 1.0));
    ActionDoCommand(SetCameraFacing(abs(FloatToInt(GetFacing(oCaster)) - 180) * 1.0));
    ActionDoCommand(SetCameraMode(oCaster, CAMERA_MODE_TOP_DOWN));

    // Get the possible targets
    object oTarget = GetLocalObject(oCaster, "ACR_SCRY_TARGET");
    location lTarget = GetLocalLocation(oCaster, "ACR_SCRY_TARGET");

    // Check if a valid creature target exists
    if (GetIsObjectValid(oTarget))
    {
        // Jump to the target
        ActionDoCommand(JumpToLocation(GetLocation(oTarget)));

        // Fade in the PC
        ActionDoCommand(FadeFromBlack(oCaster, FADE_SPEED_FAST));

        // Follow the target UNTIL the spell expires - THIS MUST BE DONE LAST!
        ActionForceFollowObject(oTarget, 0.5);
    }
    // Otherwise assume a location target
    else
    {
        // Jump to the location
        ActionDoCommand(JumpToLocation(lTarget));

        // Fade in the PC
        ActionDoCommand(FadeFromBlack(oCaster, FADE_SPEED_FAST));
    }

    // Fade out when the spell expires
    DelayCommand(fDuration, ACR_ScryEnd(oCaster));

    // Schedule the camera motion
    DelayCommand(2.0, _rotateCamera(oCaster));
}

void ACR_ScryEnd(object oCaster)
{
    if (GetLocalInt(oCaster, "ACR_SCRY_SCRYING"))
    {
        DeleteLocalInt(oCaster, "ACR_SCRY_SCRYING");

        // Stop whatever it is we're doing
        ClearAllActions();

        // Fade out the PC
        ActionDoCommand(FadeToBlack(oCaster, FADE_SPEED_FAST));

        // Return to the original scrying location
        location oLocation = GetLocalLocation(oCaster, "ACR_SCRY_LOCATION");
        ActionDoCommand(JumpToLocation(oLocation));

        ActionWait(1.0);

        // Make sure the effects are removed
        ActionDoCommand(RemoveSpecificEffect(EFFECT_TYPE_VISUALEFFECT, oCaster));
        ActionDoCommand(RemoveSpecificEffect(EFFECT_TYPE_CUTSCENEGHOST, oCaster));

        // Fade in the PC
        ActionDoCommand(FadeFromBlack(oCaster, FADE_SPEED_FAST));

        // Disable cutscene mode last so the action queue can't be interrupted
        ActionDoCommand(SetCutsceneMode(oCaster, FALSE));

        DeleteLocalLocation(oCaster, "ACR_SCRY_LOCATION");
    }
}

void ACR_ManageNonDetectionOnAcquire(object oItem, object oCreature)
{
    itemproperty ipItem = GetFirstItemProperty(oItem);

    // loop through all the properties on the item
    while (GetIsItemPropertyValid(ipItem))
    {
        // check if NON DETECTION is a property on the item
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_NON_DETECTION))
        {
            // increment the non detection counter. (>= 1 means non detectable)
            SetLocalInt(oCreature, "ACR_SCRY_NON_DETECTABLE", GetLocalInt(oCreature, "ACR_SCRY_NON_DETECTABLE") + 1);
        }
        ipItem = GetNextItemProperty(oItem);
    }
}

void ACR_ManageNonDetectionOnUnAcquire(object oItem, object oCreature)
{
    itemproperty ipItem = GetFirstItemProperty(oItem);

    // loop through all the properties on the item
    while (GetIsItemPropertyValid(ipItem))
    {
        // check if NON DETECTION is a property on the item
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_NON_DETECTION))
        {
            // decrement the non detection counter. (0 means detectable)
            SetLocalInt(oCreature, "ACR_SCRY_NON_DETECTABLE", GetLocalInt(oCreature, "ACR_SCRY_NON_DETECTABLE") - 1);
        }
        ipItem = GetNextItemProperty(oItem);
    }
}

void ACR_ManageKnowledgeOnPerception(object oPerceived, object oCreature)
{
    // player tracking code here - needs to be persistent
    SetLocalString(oCreature, GetName(oPerceived), GetPCPublicCDKey(oPerceived));
}

void ACR_ManageKnowledgeOnLocationSave(location lLocation, object oCreature)
{
    // location tracking code here - needs to be persistent
    vector vLocation = GetPositionFromLocation(lLocation);
    SetLocalLocation(oCreature, GetName(GetAreaFromLocation(lLocation)) + FloatToString(vLocation.x, 0, 1) + FloatToString(vLocation.y, 0, 1) + FloatToString(vLocation.z, 0, 1), lLocation);
}

int ACR_GetIsNonDetectable(object oCreature)
{
    return GetLocalInt(oCreature, "ACR_SCRY_NON_DETECTABLE");
}

int ACR_GetIsScrying(object oCreature)
{
    return GetLocalInt(oCreature, "ACR_SCRY_SCRYING");
}

int ACR_GetIsScryingTarget(object oCreature, object oTarget)
{
    // return true if the creature is scrying and observing the target object
    return (ACR_GetIsScrying(oCreature) && (GetLocalObject(oCreature, "ACR_SCRY_TARGET") == oTarget))
        ? TRUE
        : FALSE;
}

int ACR_GetIsScryingDevice(object oObject)
{
    return (GetTag(oObject) == ACR_SCRY_OBJECT) ? TRUE : FALSE;
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void _rotateCamera(object oCaster)
{
    // Check if the player is scrying
    if (GetLocalInt(oCaster, "ACR_SCRY_SCRYING"))
    {
        // Compute the new camera angle
        float fDirection = GetLocalFloat(oCaster, "ACR_SCRY_ANGLE") + 165.0;
        fDirection = IntToFloat(FloatToInt(fDirection) % 360);

        // Set the new camera angle
        SetCameraFacing(fDirection, -1.0, -1.0, CAMERA_TRANSITION_TYPE_MEDIUM);

        // Store the new camera angle
        SetLocalFloat(oCaster, "ACR_SCRY_ANGLE", fDirection);

        // Schedule the next adjustment
        DelayCommand(4.0, _rotateCamera(oCaster));
    }
    // Otherwise, stop the camera rotation
    else
    {
        // Clear the camera angle information
        DeleteLocalFloat(oCaster, "ACR_SCRY_ANGLE");
    }
}

#endif
////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_trigger_i.nss
//    $Revision:: 495        $ current version of the file
//        $Date:: 2008-03-17#$ date the file was created or modified
//       Author : Cipher
//
//    Var Prefix: ACR_TRG
//  Dependencies: None
//
//  Description
//  This script handles the various ways of interacting with triggers. It
//  handles all of their events, as well as other ways ALFA may have of
//  interacting with triggers.
//
//  http://www.alandfaraway.org/docs/Technical/ACR2Triggers
//
//  Revision History
//  2007/01/20  Cipher  Inception
//  2007/01/24  Cipher  Added link to ALFA Wiki triggers article
//  2007/04/03  AcadiusLost  Added hooks for Seamless AT and Resting systems
//  2007/06/07  Cipher  Abstracted SeamlessAT tag for maintainability, misc cleanup
//  2007/09/02  Cipher  Added persistent quest hook
//  2008/03/08  AcadiusLost Added support for OE standard ATs using acf scripts
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_TRIGGER_I
#define ACR_TRIGGER_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! *** PUBLIC FUNCTIONS ***

//! The event handler for entering a trigger.
void ACR_TriggerOnEnter();

//! The event handler for exiting a trigger.
void ACR_TriggerOnExit();

//! The event handler for a trigger heartbeat.
void ACR_TriggerOnHeartbeat();

//! The event handler for a trigger being clicked on.
void ACR_TriggerOnClick();

//! The event handler for a trigger being disarmed.
void ACR_TriggerOnDisarm();

//! The event handler for a trigger trap being triggered.
void ACR_TriggerOnTrapTriggered();

//! The event handler for a trigger user defined event.
void ACR_TriggerOnUserDefined();

//! *** PRIVATE FUNCTIONS ***

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_vfx_i"
#include "acr_resting_i"
#include "acr_seamlessat_i"
#include "acr_quest_i"
#include "acr_area_i"
#include "acr_skills_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

void ACR_TriggerOnEnter() {
    object oEnterer = GetEnteringObject();

	// Seamless AT hook	
    if (GetTag(OBJECT_SELF) == ACR_SAT_SEAMLESSAT_TAG) { ACR_SeamlessATEnter(oEnterer);}

    // Resting system hook
	ACR_RestTriggerEnter(oEnterer);

    // Quest system hook
    ACR_QuestTriggerEnter(oEnterer);
	
	// Skill system hook
	ACR_SkillsOnTriggerEnter(oEnterer);
    
    // apply any effects on the trigger
    ACR_VFXOnEnter(oEnterer, OBJECT_SELF);
}

void ACR_TriggerOnExit() {
    object oExiter = GetExitingObject();

    // Seamless AT hook
	if (GetTag(OBJECT_SELF) == ACR_SAT_SEAMLESSAT_TAG) { ACR_SeamlessATExit(oExiter);}
    
	// Resting system hook
	ACR_RestTriggerExit(oExiter);
	
	// Skill system hook
	ACR_SkillsOnTriggerExit(oEnterer);
    
    // apply any effects on the trigger
    ACR_VFXOnExit(oExiter, OBJECT_SELF);
}

void ACR_TriggerOnHeartbeat() {

    // apply any effects on the trigger
    ACR_VFXOnHeartBeat(OBJECT_SELF);
}

void ACR_TriggerOnDisarm() {
    object oDisarmer = GetLastDisarmed();

    // apply any effects on the trigger
    ACR_VFXOnDisarm(oDisarmer, OBJECT_SELF);
}

void ACR_TriggerOnClick() {
    object oClicker = GetClickingObject();
    
	if (GetTransitionTarget(OBJECT_SELF) != OBJECT_INVALID) {
		// if the trigger has an AT destination, treat it as an AT.
	    ACR_OnAreaTransitionClick();
	}
    // apply any effects on the trigger
    ACR_VFXOnClick(oClicker, OBJECT_SELF);
}

void ACR_TriggerOnTrapTriggered() {
    //object oTriggered = GetLastTriggered();
}

void ACR_TriggerOnUserDefined() {
}

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

#endif
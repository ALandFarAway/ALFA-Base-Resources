////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_conversions_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-01-07#$ date the file was created or modified
//       Author : Basilica
//
//    Var Prefix: ACR_VERSION
//  Dependencies: NWNX
//
//  Description
//  This file contains the version number string for the ACR.
//
//  Revision History
//  2012/01/07  Basilica    - Created.
//  2012/04/16  Basilica    - Return build date.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_CONVERSION_I
#define ACR_CONVERSION_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_CONVERSION_MAXIMUM = "ACR_CONVERSION_MAXIMUM";

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Tries to convert oPC from sVersion to the current ACR version.
// Returns TRUE on success.
int TryUpdateCharacterToNewestVersion( object oPC, string sCurrentVersion );

// Swap a feat, if the PC has the feat already.
void _SwapFeat( object oPC, int OldFeat, int NewFeat );

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_i"
#include "acr_version_i"
#include "acr_tools_i"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int TryUpdateCharacterToNewestVersion( object oPC, string sCurrentVersion )
{
    string sTargetVersion = GetLocalString(GetModule(), ACR_CONVERSION_MAXIMUM);
    if(sTargetVersion == "")
        sTargetVersion = ACR_VERSION;

    float fCurrentVersion = StringToFloat(sCurrentVersion);
    float fTargetVersion = StringToFloat(sTargetVersion);
    int bChanged = FALSE;

    if(sCurrentVersion == "" && fTargetVersion > 1.865) // v1.86 -> v1.87
    {
        // Replace Combat Expertise with the ACR version.
        _SwapFeat( oPC, FEAT_COMBAT_EXPERTISE, FEAT_ACR_COMBAT_EXPERTISE );
        _SwapFeat( oPC, FEAT_IMPROVED_COMBAT_EXPERTISE, FEAT_ACR_IMPROVED_COMBAT_EXPERTISE );
        
        // Before ACR 1.87, the new skill focus feats pointed to the wrong TLK entries.
        // These swaps give the player the skill focus they thought they picked.
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_CRFT_BOW, FEAT_SKILL_FOCUS_CRFT_WPN );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_CRFT_ARM, FEAT_SKILL_FOCUS_CRFT_BOW );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_CRFT_ALCH, FEAT_SKILL_FOCUS_CRFT_ARM );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_WIND, FEAT_SKILL_FOCUS_CRFT_ALCH );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_STRG, FEAT_SKILL_FOCUS_PERF_WIND );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_SING, FEAT_SKILL_FOCUS_PERF_STRG );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_PERC, FEAT_SKILL_FOCUS_PERF_SING );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_ORAT, FEAT_SKILL_FOCUS_PERF_PERC );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_KEYB, FEAT_SKILL_FOCUS_PERF_ORAT );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_DANC, FEAT_SKILL_FOCUS_PERF_KEYB );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_COMD, FEAT_SKILL_FOCUS_PERF_DANC );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_PERF_ACT, FEAT_SKILL_FOCUS_PERF_COMD );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_RELG, FEAT_SKILL_FOCUS_PERF_ACT );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_PLAN, FEAT_SKILL_FOCUS_KNOW_RELG );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_NOBL, FEAT_SKILL_FOCUS_KNOW_PLAN );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_NATR, FEAT_SKILL_FOCUS_KNOW_NOBL );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_LOC, FEAT_SKILL_FOCUS_KNOW_NATR );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_HIST, FEAT_SKILL_FOCUS_KNOW_LOC );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_GEO, FEAT_SKILL_FOCUS_KNOW_HIST );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_ENG, FEAT_SKILL_FOCUS_KNOW_GEO );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_DUNG, FEAT_SKILL_FOCUS_KNOW_ENG );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_KNOW_ARC, FEAT_SKILL_FOCUS_KNOW_DUNG );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_USE_ROPE, FEAT_SKILL_FOCUS_KNOW_ARC );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_SWIM, FEAT_SKILL_FOCUS_USE_ROPE );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_SPK_LANG, FEAT_SKILL_FOCUS_SWIM );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_SENS_MOTV, FEAT_SKILL_FOCUS_SPK_LANG );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_RIDE_ACR, FEAT_SKILL_FOCUS_SENS_MOTV );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_JUMP, FEAT_SKILL_FOCUS_RIDE_ACR );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_HAND_ANIM, FEAT_SKILL_FOCUS_JUMP );
        _SwapFeat( oPC, FEAT_SKILL_FOCUS_GATH_INFO, FEAT_SKILL_FOCUS_HAND_ANIM );
        
        // Give wizards their new cantrips.
        if ( GetLevelByClass( CLASS_TYPE_WIZARD, oPC ) >= 1 ) {
            int i, nPosition = -1;
            for ( i = 1; i <= 4; i++ ) {
                if ( GetClassByPosition( i, oPC ) == CLASS_TYPE_WIZARD ) {
                    nPosition = i;
                    break;
                }
            }
            if ( nPosition != -1 ) {
                nPosition--; // GetClassByPosition is 1-4, SetSpellKnown is 0-3.
                SetSpellKnown( oPC, nPosition, 3066, TRUE, FALSE ); // Arcane Mark
                SetSpellKnown( oPC, nPosition, 3060, TRUE, FALSE ); // Dancing Lights
                SetSpellKnown( oPC, nPosition, 3059, TRUE, FALSE ); // Detect Poison
                SetSpellKnown( oPC, nPosition, 3061, TRUE, FALSE ); // Ghost Sound
                SetSpellKnown( oPC, nPosition, 3062, TRUE, FALSE ); // Mage Hand
                SetSpellKnown( oPC, nPosition, 3063, TRUE, FALSE ); // Mending
                SetSpellKnown( oPC, nPosition, 3064, TRUE, FALSE ); // Message
                SetSpellKnown( oPC, nPosition, 3065, TRUE, FALSE ); // Open/Close
                SetSpellKnown( oPC, nPosition, 3067, TRUE, FALSE ); // Prestidigitation
                SetSpellKnown( oPC, nPosition, 3003, TRUE, FALSE ); // Read Magic
            }
        }
        
        bChanged = TRUE;
    }
	if ((sCurrentVersion == "" || fCurrentVersion < 1.915) && fTargetVersion >= 1.915) { // X -> 1.92
		// Replace Acid Fog with its new index, making SPELL_INVALID a thing.
		int nPosWizard = GetClassPosition( oPC, CLASS_TYPE_WIZARD );
		if ( nPosWizard != -1 && GetSpellKnown( oPC, SPELL_ACID_FOG ) ) {
			SetSpellKnown( oPC, nPosWizard, SPELL_ACID_FOG, FALSE, FALSE );
			SetSpellKnown( oPC, nPosWizard, SPELL_ACID_FOG_ACR, TRUE, FALSE );
		}
		int nPosSorc = GetClassPosition( oPC, CLASS_TYPE_SORCERER );
		if ( nPosSorc != -1 && GetSpellKnown ( oPC, SPELL_ACID_FOG) ) {
			SetSpellKnown( oPC, nPosSorc, SPELL_ACID_FOG, FALSE, FALSE);
			SetSpellKnown( oPC, nPosSorc, SPELL_ACID_FOG_ACR, TRUE, FALSE );
		}
		
		// We no longer support lore.
		SetBaseSkillRank( oPC, SKILL_LORE, 0, FALSE );
		
		// Druids have some new feats.
		if ( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) >= 1 ) {
			FeatAdd( oPC, FEAT_WILD_EMPATHY, FALSE, TRUE, FALSE );
		}
		if ( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) >= 13 ) {
			FeatAdd( oPC, FEAT_A_THOUSAND_FACES, FALSE, TRUE, FALSE );
		}
		if ( GetLevelByClass( CLASS_TYPE_DRUID, oPC ) >= 15 ) {
			FeatAdd( oPC, FEAT_TIMELESS_BODY, FALSE, TRUE, FALSE );
		}
		
        // Replace Power Attack with the ACR version.
        _SwapFeat( oPC, FEAT_POWER_ATTACK, FEAT_ACR_POWER_ATTACK );
        _SwapFeat( oPC, FEAT_IMPROVED_POWER_ATTACK, FEAT_ACR_IMPROVED_POWER_ATTACK );
        bChanged = TRUE;
	}
	
	if((sCurrentVersion == "" || fCurrentVersion < 1.92005) && fTargetVersion >= 1.92005) { // X -> 1.9201
    FeatAdd( oPC, FEAT_RIDE, FALSE, TRUE, TRUE);
    if( GetLevelByClass( CLASS_TYPE_PALADIN, oPC) >= 5 ) {
      FeatAdd( oPC, FEAT_PALADIN_WARHORSE, FALSE, TRUE, TRUE );
    }
	}
    return bChanged;
}

void _SwapFeat( object oPC, int OldFeat, int NewFeat ) {
    if ( GetHasFeat( OldFeat, oPC ) ) {
        FeatAdd( oPC, NewFeat, FALSE, FALSE );
        FeatRemove( oPC, OldFeat );
    }
}

#endif
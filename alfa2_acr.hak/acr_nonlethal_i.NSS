////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_nonlethal_i.nss
//    $Revision:: 655      $ current version of the file
//        $Date:: 2009-05-30#$ date the file was created or modified
//       Author : Creslyn & AcadiusLost
//
//   Var Prefix : ACR_NLD
//  Dependencies:
//
//  Description
//  This script controls the nonlethal/subdual scripts for use on other PCs and NPCs.
//
//  Revision History
//  2008/07/22  Creslyn  Subdual v11: Inception.
//  2008/08/27  AcadiusLost  reformatting/integration to ACR.
//  2008/08/30  AcadiusLost  adjusted constants to Live versions, converted DB to SQL
//                expanded ACR_NLD_OnPCLoaded() event to initialize local caches.
//  2008/09/01  AcadiusLost  Switched to orange for reporting, added death switch
//  2008/09/06  Creslyn  Improved feat handling, removed persistency requirements,
//				  dealt with several DR cases.
//  2008/09/19  AcadiusLost  Attempted improvement on subdued animations.
//  2008/09/20  AcadiusLost  Altered subdual health display
//  2008/09/21  AcadiusLost  Fixed subdual health reports, added DEX=0 to the Helpless state.
//					SetCommandable window reduced to 0.1 seconds, Dex penalty removal fixed,
//					OnExit event added to clear logout with subdual on.
//	2008/09/27	AcadiusLost  Added Subdual logging. Also cleaned reporting of {CR} text to players.
//  2008/11/10  AcadiusLost  Migrated/fixed reporting of {CR} text to acr_tools_i
//  2009/03/20  Creslyn  Addition of public function to apply subdual damage
//	2009/05/10  Creslyn  Improvements to Weapon Switch, DR check, and ApplyFist functions.
//  2009/05/30  AcadiusLost  Subdual healing to 1 per 8 rnds
//	2012/05/13	Zelknolf  Fix some of the white space in NLD; always remove -5 damage item
//					properties when removing NLD effects.
//	2012/05/13	Zelknolf  More whitespace fixes in NLD; turn NLD mode off on death; double shot of
//					damage cap no longer produces double corpse.
//	2012/05/26	Foam  Cleaned code, added further commenting.
//	2012/05/26	Foam  Added a function for determining if a target is immune to nonlethal damage.
//	2012/05/26	Foam  Added support for precise strike and insightful strike.
//	2012/05/26	Foam  Improved enhancement bonus support.
//	2012/05/28	Foam  Added favored enemy/improved favored enemy bonus support.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_NONLETHAL_I
#define ACR_NONLETHAL_I

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const string ACR_NLD_FIST = "acr_nld_fist";
const string ACR_SUBDUAL_TOGGLE = "acr_subdual";
const string ACR_NLD_DB = "ACR_NLD_DB";

//!! Number of rounds it takes to heal 1 point of non lethal damage
//!!  10 may be canon, 5 is less tedious for a PW environment.
const int ACR_NLD_HEALRATE = 8;

//!! Determine whether or not sneak attacks are allowed to deal non lethal damage
//!! - FALSE: not allowed; TRUE: allowed
const int NLD_SA_ALLOWED = FALSE;

const string ACR_NLD_MODE = "ACR_NLD_MODE";
const string ACR_NLD_STATE = "ACR_NLD_STATE";
const string ACR_NLD_HEALING = "ACR_NLD_HEALING";

const int ACR_NLD_STATE_NORMAL = 0;
const int ACR_NLD_STATE_STAGGERED = 1;
const int ACR_NLD_STATE_HELPLESS = 2;

const string ACR_NLD_DAMAGE = "ACR_NLD_DAMAGE";
const string ACR_NLD_DAMAGE_TOTAL = "ACR_NLD_DAMAGE_TOTAL";

const string ACR_NLD_DICE_DAMAGE = "ACR_NLD_DICE_DAMAGE";
const string ACR_NLD_DICE_NUMBER = "ACR_NLD_DICE_NUMBER";
const string ACR_NLD_DAMAGE_PENALTY = "ACR_NLD_DAMAGE_PENALTY";

const string ACR_NLD_WOFFHAND = "ACR_NLD_WOFFHAND";
const string ACR_NLD_W2HANDED = "ACR_NLD_W2HANDED";

const string ACR_NLD_SNEAKATTACK = "ACR_NLD_SNEAKATTACK";
const string ACR_NLD_SA_DICE = "ACR_NLD_SA_DICE";

const string ACR_NLD_MAT_ADAMANTINE = "_ada_";
const string ACR_NLD_MAT_ALCSILVER = "_slv_";
const string ACR_NLD_MAT_COLDIRON = "_cld_";
//const string ACR_NLD_MAT_MITHRIL = "_mth_";
//const string ACR_NLD_MAT_DARKSTEEL = "_drk_";

const string ACR_NLD_ATTACKER = "ACR_NLD_ATTACKER";
const string ACR_NLD_TARGET = "ACR_NLD_TARGET";

// Missing feat globals.
const int FEAT_FAVORED_SOUL_DR_COLD_IRON = 2087;
const int FEAT_FAVORED_SOUL_DR_SILVER = 2088;
const int FEAT_INSIGHTFUL_STRIKE = 2141;

// Missing spell globals.
const int SPELL_GR_SHADOW_CON_GHOSTLY_VISAGE = 351;

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//!! Toggles NLD mode on/off for oUser, also reports total NLD oUser currently suffers
void ACR_ToggleNLDMode( object oUser = OBJECT_SELF );

//!! Start healing cycle, toggle NLD mode off (if it was on), restore feats, etc.
void ACR_NLD_OnPCLoaded( object oPC );

//!! Adds/removes NLD properties to equipped/unequipped weapons
//!! - oUser
//!! - oWeapon
//!! - bEquipped: specify whether oWeapon was just equipped (TRUE) or unequipped (FALSE)
void ACR_NLD_OnWeaponSwitch( object oUser, object oWeapon, int bEquipped = TRUE );

//!! Apply and/or remove the effects associate with each NLD state
//!! - oTarget
//!! - nSubdualTotal: total amount of non lethal damage oTarget has taken
void ACR_ApplyNLDEffects( object oTarget, int nSubdualTotal );

//!! NLD check on weapon hit, applied from x2_s3_onhitcast
//!! returns TRUE if NLD mode is on, then applies NLD. FALSE if off
int ACR_NLD_OnWeaponHit( object oWeapon, object oTarget, object oAttacker );

//!! Heals nHealAmount of non lethal damage on oTarget
//!! - if this takes oTarget out of/into the staggered
//!!   or helpless states, remove/apply effects from those states
//!! - bReport: tells the player how much nonlethal damage they have remaining
//!! - oCaster: if oCaster is a valid object, report amount of NLD healed/remaining to oCaster too
void ACR_NLD_HealNLD( object oTarget, int nHealAmount, int bReport = TRUE, object oCaster = OBJECT_INVALID );

//!! Regenerates X amount of nonlethal damage on oTarget per round
//!! * X depends on which spell is used
//!! - oTarget:
//!! - nAmount: amount to regenerate
//!! - nSpell: use GetSpellID()
//!! - fDelay: how long before the next iteration of regenerate
void ACR_NLD_Regen( object oTarget, int nAmount, int nSpell, float fDelay );

//!! Reports the total amount of non lethal damage oTarget is still suffering
//!! - oTarget:
//!! - oReportTo: who recieves the message
//!! - nAmount: used in other functions where this amount is already known,
//!!		saves extra db calls
void ACR_NLD_ReportTotal( object oTarget, object oReportTo, int nAmount = 0 );

//!! Heals all non lethal damage on oTarget
//!! - for use in a successful rest, or login after x period of time
void ACR_NLD_HealAll( object oTarget );

//!! If oTarget is taken into negatives/killed, determine if
//!! oAttacker was using non lethal damage, and if so how much
//!! non lethal damage was done ( = amount real damage to heal)
//!! - oTarget: dead/dying pc
//!! - oAttacker: damage dealer, use GetLastDamager()
int ACR_NLD_DeathOrDyingHitDamage( object oTarget, object oAttacker );

//!! Deactivates subdual mode for dead PCs (avoids inadvertant feat upgrade from deactivation after
//!!  a rez which would cause loss of a sneak attack feat.
void ACR_NLD_OnDeath( object oDead );

//!! Cleans up after a logout while in Subdual Mode
void ACR_NonLethalOnClientExit( object oDeparting );

// Apply an amount of nonlethal damage (nSubdualDamage) to oTarget directly.
// * This will simply apply a flat amount of nonlethal damage, ignoring resistances,
//    saves or anything and everything else.
void ACR_ApplyNonlethalDamageToCreature( object oTarget, int nSubdualDamage );

//! *** PRIVATE FUNCTIONS ***
//! Not for external use.

// Applies non lethal damage from subdual weapons.
// - oTarget
// - oAttacker
// - oItem: the equipped weapon
// - bSneak: attack was a Sneak Attack - TRUE/FALSE
void _NLDWeaponDamage( object oTarget, object oAttacker, object oItem, int bSneak = FALSE );

// Determine if oAttacker has the specialisation feat for his weapon
int _NLDGetWeaponSpecialisation( object oAttacker, object oItem );

// Determine if oAttacker has the greater specialisation feat for his weapon
int _NLDGetGreaterWeaponSpecialisation( object oAttacker, object oItem );

// Determine enhancement bonus of the weapon
int _NLDGetEnhancementBonus( object oTarget, object oItem );

// Retrieve the feat for a specific favored enemy.
int _NDLGetFavoredEnemyFeat( object oTarget );

// Retrieve the feat for a specific improved favored enemy.
int _NDLGetImprovedFavoredEnemyFeat( object oTarget );

// Determine the favored enemy bonus of the attacker against the target.
int _NLDGetFavoredEnemyBonus( object oAttacker, object oTarget );

// Get the amount of non lethal damage that bypasses
// oTarget's damage reduction, apply physical damage
// up to the amount of DR (for stoneskins)
// - oWeapon : the weapon hitting oTarget
// - nNLDamage : the amount of non lethal damage done
//   before DR is accounted for
// - nHeal : the amount of real damage taken in the hit
// * Due to how X/Magic works, need to return value as a string
//	 for healing handling
string _NLDamageReductionCheck( object oTarget, object oWeapon, int nNLDamage, int nHeal );

// Give oUser a creature weapon for unarmed NLD
void _GiveNLDFist( object oUser );

// Apply NLD weapon effects to the NLD fist held by oUser
void _ApplyNLDFist( object oUser );

// oTarget will heal non lethal damage at a set amount/time
// - for testing purposes, it will be 1hp/round
void _NLDNaturalHealing( object oTarget, int nCnt = 0 );

// Remove the NLD staggered state effects from oTarget
// - needs work
void _RemoveNLDStaggeredEffect( object oTarget );

// Remove the NLD helpless state effects from oTarget
// - needs work
void _RemoveNLDHelplessEffect( object oTarget );

// Get how many d6 sneak attack oAttacker has
int _GetNLDSneakAttackDice( object oAttacker );

// Determines how much Sneak Attack damage oAttacker should
// do, and removes the feats
void _HandleNLDSneakAttacks( object oAttacker );

// Restores removed Sneak Attack feats
void _RestoreNLDSneakAttackFeats( object oAttacker );

// Retrieve list of sneak attack feats removed from oAttacker
int _GetNLDSAFeatList( object oAttacker );

// Store list of sneak attack feats removed from oAttacker
void _SetNLDSAFeatList( object oAttacker, int nFeatList );

// Determine NLD mode. Returns:
// - TRUE: ON
// - FALSE: OFF
int _GetNLDMode( object oUser );

// Set NLD mode
// - TRUE: on
// - FASE: off
void _SetNLDMode( object oUser, int bMode );

// Get NLD state of target. Returns:
// - 0: normal
// - 1: staggered
// - 2: helpless
int _GetNLDState( object oTarget );

// Set what NLD state the target is in
// - 0: normal
// - 1: staggered
// - 2: helpless
void _SetNLDState( object oTarget, int nState );

// Get the total non lethal damage that oTarget has taken
int _GetNLDTotal( object oTarget );

// Set the total non lethal damage that oTarget has taken
void _SetNLDTotal( object oTarget, int nAmount );

// Get the amount of damage the last NLD hit caused
int _GetLastNLDamage( object oTarget );

// Set the amount of damage the last NLD hit caused
void _SetLastNLDamage( object oTarget, int nDamage );

// Determine if oTarget is healing NLD naturally
int _GetIsNLDHealing( object oTarget );

// Set oTarget to heal/cease healing NLD naturally
void _SetIsNLDHealing( object oTarget, int bHeal );

// void wrapper for looping animation enforcement on subdued PCs.
void _DoSubduedAnimation( object oTarget );

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_pps_i"
#include "acr_1984_i"
#include "acr_tools_i"
#include "x2_inc_itemprop"

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PUBLIC FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////


void ACR_ToggleNLDMode( object oUser = OBJECT_SELF ) {
    object oWeapR = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oUser );
    object oWeapL = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oUser );
    object oCweap = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oUser );
    if ( _GetNLDMode( oUser ) ) {
        if ( GetIsObjectValid( oWeapR ) && GetWeaponType( oWeapR ) != WEAPON_TYPE_NONE
                && GetWeaponRanged( oWeapR ) != TRUE )
            ACR_NLD_OnWeaponSwitch( oUser, oWeapR, FALSE );
        if ( GetIsObjectValid( oWeapL ) && GetWeaponType( oWeapL ) != WEAPON_TYPE_NONE )
            ACR_NLD_OnWeaponSwitch( oUser, oWeapL, FALSE );
        if ( GetIsObjectValid( oCweap ) && GetTag( oCweap ) == ACR_NLD_FIST ) {
            DestroyObject( oCweap, 0.2, FALSE );
        }
        _RestoreNLDSneakAttackFeats( oUser );
        FeatRemove( oUser, FEAT_WEAPON_PROFICIENCY_CREATURE );
        if ( GetHasFeat( FEAT_WEAPON_FOCUS_CREATURE, oUser ) )
            FeatRemove( oUser, FEAT_WEAPON_FOCUS_CREATURE );
        DelayCommand( 0.1,_SetNLDMode( oUser, FALSE ) );
    } else {
        _SetNLDMode( oUser, TRUE );
        if ( GetIsObjectValid( oWeapR ) && GetWeaponType( oWeapR ) != WEAPON_TYPE_NONE
                && GetWeaponRanged( oWeapR ) != TRUE )
            DelayCommand( 0.1,ACR_NLD_OnWeaponSwitch( oUser, oWeapR, TRUE ) );
        if ( GetIsObjectValid( oWeapL ) && GetWeaponType( oWeapL ) != WEAPON_TYPE_NONE )
            DelayCommand( 0.1,ACR_NLD_OnWeaponSwitch( oUser, oWeapL, TRUE ) );
        _HandleNLDSneakAttacks( oUser );
        DelayCommand( 0.1, _GiveNLDFist( oUser ) );
    }
}


void ACR_NLD_OnPCLoaded( object oPC ) {
    ACR_NLD_HealNLD( oPC, 1 );
    if ( _GetNLDMode( oPC ) )
        ACR_ToggleNLDMode( oPC );
}

void ACR_NLD_OnWeaponSwitch( object oUser, object oWeapon, int bEquipped = TRUE ) {
    if ( !_GetNLDMode( oUser ) )
        return;
    object oWeapR = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oUser );
    object oWeapL = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oUser );
    object oCweap = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oUser );

    // handle offhand/2handed str modifiers for currently equipped weapons
    if ( GetIsObjectValid( oWeapR ) && GetWeaponRanged( oWeapR ) != TRUE
            && GetWeaponType( oWeapR ) != WEAPON_TYPE_NONE ) {
        SetLocalInt( oWeapR,ACR_NLD_WOFFHAND,FALSE );
        // item in the offhand?
        if ( GetIsObjectValid( oWeapL ) && oWeapL != oWeapR ) {
            SetLocalInt( oWeapR,ACR_NLD_W2HANDED,FALSE );
            if ( GetWeaponType( oWeapL ) != WEAPON_TYPE_NONE )
                SetLocalInt( oWeapL,ACR_NLD_WOFFHAND,TRUE );
        } else {
            //check weapon size vs creature size to determine if it's wielded 2 handed
            int nSize = StringToInt( Get2DAString( "baseitems","WeaponSize",GetBaseItemType( oWeapR ) ) );
            // Debug
            //   SendMessageToPC(oUser, "Weapon size is: "+IntToString(nSize));
            if ( ( GetCreatureSize( oUser ) == CREATURE_SIZE_HUGE && nSize >= 4 )
                    || ( GetCreatureSize( oUser ) == CREATURE_SIZE_LARGE && nSize >= 4 )
                    || ( GetCreatureSize( oUser ) == CREATURE_SIZE_MEDIUM && nSize >= 3 )
                    || ( GetCreatureSize( oUser ) == CREATURE_SIZE_SMALL && nSize >= 2 )
                    || ( GetCreatureSize( oUser ) == CREATURE_SIZE_TINY && nSize >= 1 ) )
                SetLocalInt( oWeapR,ACR_NLD_W2HANDED,TRUE );
            else
                SetLocalInt( oWeapR,ACR_NLD_W2HANDED,FALSE );
        }
    } else if ( !GetIsObjectValid( oWeapR ) ) {
        // need to work on barehanded subdual.
        if ( !GetIsObjectValid( oCweap ) ) {
            _GiveNLDFist( oUser );
        }
    }
// now look at the weapon that was just equipped
    if ( GetTag( oWeapon ) == ACR_NLD_FIST )
        return;

    if ( GetIsObjectValid( oWeapon ) && GetWeaponRanged( oWeapon ) != TRUE
            && GetWeaponType( oWeapon ) != WEAPON_TYPE_NONE ) {
        itemproperty iProp;
        itemproperty iHit = ItemPropertyOnHitCastSpell( IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1 );
        itemproperty iNoDam = ItemPropertyNoDamage();
        itemproperty iNoStr = ItemPropertyDamagePenalty( 5 );
        int nDiceDam, nDiceNum, nBaseItem, nSADice, nDamPenalty;

        // weapon was just unequipped: remove NLD properties, zero damage/sneak vars
        if ( bEquipped == FALSE ) {
            iProp = GetFirstItemProperty( oWeapon );
            while ( GetIsItemPropertyValid( iProp ) ) {
                if ( GetItemPropertyType( iProp ) == ITEM_PROPERTY_ONHITCASTSPELL
                        || GetItemPropertyType( iProp ) == ITEM_PROPERTY_NO_DAMAGE )
                    DelayCommand( 0.5,AssignCommand( oUser,RemoveItemProperty( oWeapon,iProp ) ) );
                if (GetItemPropertyType( iProp ) == ITEM_PROPERTY_DECREASED_DAMAGE &&
                    GetItemPropertyCostTableValue( iProp ) == 5 &&
                    GetItemPropertyDurationType( iProp ) == DURATION_TYPE_TEMPORARY)
                    DelayCommand( 0.5,AssignCommand( oUser,RemoveItemProperty( oWeapon,iProp ) ) );
                iProp = GetNextItemProperty( oWeapon );
            }
            SetLocalInt( oWeapon,ACR_NLD_WOFFHAND,FALSE );
            SetLocalInt( oWeapon,ACR_NLD_W2HANDED,FALSE );
            SetLocalInt( oWeapon,ACR_NLD_SA_DICE,0 );
            nDamPenalty = GetLocalInt( oWeapon, ACR_NLD_DAMAGE_PENALTY );
        }

        // weapon was just equipped: add NLD properties, set damage/sneak vars
        else {
            iProp = GetFirstItemProperty( oWeapon );
            while ( GetIsItemPropertyValid( iProp ) ) {
                if ( GetItemPropertyType( iProp ) == ITEM_PROPERTY_DECREASED_DAMAGE ) {
                    nDamPenalty = GetItemPropertyCostTableValue( iProp );
                    SetLocalInt( oWeapon, ACR_NLD_DAMAGE_PENALTY, nDamPenalty );
                }
                iProp = GetNextItemProperty( oWeapon );
            }
            if ( nDamPenalty < 1 )
                SetLocalInt( oWeapon, ACR_NLD_DAMAGE_PENALTY, 255 );
            nBaseItem = GetBaseItemType( oWeapon );
            nDiceDam = StringToInt( Get2DAString( "baseitems","DieToRoll",nBaseItem ) );
            nDiceNum = StringToInt( Get2DAString( "baseitems","NumDice",nBaseItem ) );
            nSADice = _GetNLDSneakAttackDice( oUser );
            SetLocalInt( oWeapon,ACR_NLD_DICE_DAMAGE,nDiceDam );
            SetLocalInt( oWeapon,ACR_NLD_DICE_NUMBER,nDiceNum );
            SetLocalInt( oWeapon,ACR_NLD_SA_DICE,nSADice );
            AssignCommand(oUser, AddItemProperty(DURATION_TYPE_TEMPORARY, iHit, oWeapon, 24.0f * 60.0f * 60.0f)); // lasts 24 hours.
            AssignCommand(oUser, AddItemProperty(DURATION_TYPE_TEMPORARY, iNoDam, oWeapon, 24.0f * 60.0f * 60.0f));
            AssignCommand(oUser, AddItemProperty(DURATION_TYPE_TEMPORARY, iNoStr, oWeapon, 24.0f * 60.0f * 60.0f));
        }
    }
}


void ACR_ApplyNLDEffects( object oTarget, int nSubdualTotal ) {

    effect eStaggered = ExtraordinaryEffect( EffectDazed() );
    int nCurrentHP = GetCurrentHitPoints( oTarget );
    int nState = _GetNLDState( oTarget );
    if ( nSubdualTotal == nCurrentHP ) {			// Staggered : just dazed for now
        if ( nState != ACR_NLD_STATE_STAGGERED ) {
            if ( nState == ACR_NLD_STATE_HELPLESS ) {
                _RemoveNLDHelplessEffect( oTarget );
            }
            _SetNLDState( oTarget, ACR_NLD_STATE_STAGGERED );
            DelayCommand( 0.1,AssignCommand( oTarget,SpeakString( "<c=orange>Staggered</c>" ) ) );
            AssignCommand( oTarget,ApplyEffectToObject( DURATION_TYPE_TEMPORARY,eStaggered,oTarget,12.0 ) );
        }
    } else if ( nSubdualTotal > nCurrentHP ) {		// Helpless : setcommandable for now
        if ( nState == ACR_NLD_STATE_STAGGERED ) {
            _RemoveNLDStaggeredEffect( oTarget );
        }
        if ( nState != ACR_NLD_STATE_HELPLESS ) {
            effect eHelplessDex = ExtraordinaryEffect( EffectAbilityDecrease( ABILITY_DEXTERITY, GetAbilityScore( oTarget, ABILITY_DEXTERITY ) ) );
			effect eHelplessStun = ExtraordinaryEffect( EffectStunned() );
            AssignCommand( GetModule(), ApplyEffectToObject( DURATION_TYPE_PERMANENT, eHelplessDex, oTarget ) );
            AssignCommand( GetModule(), ApplyEffectToObject( DURATION_TYPE_PERMANENT, eHelplessStun, oTarget ) );
            AssignCommand( oTarget,SpeakString( "<c=orange>Subdued</c>" ) );
            // log the event
            object oSubduer = GetLocalObject( oTarget, ACR_NLD_ATTACKER );
            ACR_LogEvent( oTarget, ACR_LOG_SUBDUAL, "Was subdued by "+GetName( oSubduer ) );
            ACR_LogEvent( oSubduer, ACR_LOG_SUBDUAL, "Subdued "+GetName( oTarget ) );
            DeleteLocalObject( oTarget, ACR_NLD_ATTACKER );
            DeleteLocalObject( oSubduer, ACR_NLD_TARGET );
            _SetNLDState( oTarget, ACR_NLD_STATE_HELPLESS );
            AssignCommand( oTarget, ClearAllActions( TRUE ) );
            //DelayCommand(0.1, AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK))); 	// need some other animation for non-humanoids
            PlayCustomAnimation( oTarget, "proneb", 1 );
            // start re-polling with animation ever 2 seconds till recovered
            DelayCommand( 2.0, _DoSubduedAnimation( oTarget ) );
            DelayCommand( 0.1, SetCommandable( FALSE, oTarget ) );
        }
    } else {										// Normal
        if ( nState == ACR_NLD_STATE_HELPLESS ) {
            _RemoveNLDHelplessEffect( oTarget );
        } else if ( nState == ACR_NLD_STATE_STAGGERED ) {
            _RemoveNLDStaggeredEffect( oTarget );
        }
        if ( nState != ACR_NLD_STATE_NORMAL ) {
            _SetNLDState( oTarget, ACR_NLD_STATE_NORMAL );
            DelayCommand( 0.1,AssignCommand( oTarget,SpeakString( "<c=orange>Recovered</c>" ) ) );
            // log the event
            ACR_LogEvent( oTarget, ACR_LOG_SUBDUAL, "Recovered" );
        }
    }
    if ( !_GetIsNLDHealing( oTarget ) && nSubdualTotal > 0 ) {
        _SetIsNLDHealing( oTarget,TRUE );
        DelayCommand( RoundsToSeconds( 1 ),_NLDNaturalHealing( oTarget ) );
    }
}

int ACR_NLD_OnWeaponHit( object oWeapon, object oTarget, object oAttacker ) {
    if ( GetWeaponType( oWeapon ) != WEAPON_TYPE_NONE ) {
        if ( _GetNLDMode( oAttacker )  && GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ) {
            int bSneak = FALSE;
            if ( NLD_SA_ALLOWED ) {
                if ( ( GetAttackTarget( oTarget ) != oAttacker || GetHasFeatEffect( FEAT_FEINT, oTarget ) )
                        && !GetIsImmune( oTarget, IMMUNITY_TYPE_SNEAK_ATTACK ) )
                    bSneak = TRUE;
            }
            _NLDWeaponDamage( oTarget,oAttacker,oWeapon, bSneak );
            return TRUE;
        }
    }
    return FALSE;
}

void ACR_NLD_HealNLD( object oTarget, int nHealAmount, int bReport = TRUE, object oCaster = OBJECT_INVALID ) {
    int nDam = _GetNLDTotal( oTarget );
    if ( nDam == 0 )
        return;
    int nNLDamage = nDam - nHealAmount;
    if ( nNLDamage < 0 ) {
        nHealAmount = nDam;
        nNLDamage = 0;
        _SetIsNLDHealing( oTarget, FALSE );
        bReport = FALSE;
    }
    _SetNLDTotal( oTarget,nNLDamage );
    ACR_ApplyNLDEffects( oTarget, nNLDamage );
    SendMessageToPC( oTarget,"<c=orange>Nonlethal damage healed: </c>"+IntToString( nHealAmount ) );
    if ( bReport )
        ACR_NLD_ReportTotal( oTarget, oTarget, nNLDamage );
    if ( GetIsObjectValid( oCaster ) && oCaster != oTarget ) {
        SendMessageToPC( oCaster,"<c=orange>Nonlethal damage healed: </c>"+IntToString( nHealAmount ) );
        ACR_NLD_ReportTotal( oTarget, oCaster, nNLDamage );
    }
}

void ACR_NLD_Regen( object oTarget, int nAmount, int nSpell, float fDelay ) {
    if ( GetHasSpellEffect( nSpell ) ) {
        ACR_NLD_HealNLD( oTarget, nAmount, FALSE );
        DelayCommand( fDelay, ACR_NLD_Regen( oTarget, nAmount, nSpell, fDelay ) );
    }
}

void ACR_NLD_ReportTotal( object oTarget, object oReportTo, int nAmount = 0 ) {
    if ( !GetIsObjectValid( oTarget ) || !GetIsObjectValid( oReportTo ) )
        return;
    if ( nAmount == 0 )
        nAmount = _GetNLDTotal( oTarget );
    SendMessageToPC( oReportTo, "<c=orange>Subdual Health: </c>"+IntToString( GetCurrentHitPoints( oTarget )-nAmount ) +"/"+IntToString( GetCurrentHitPoints( oTarget ) ) );
    // SendMessageToPC(oReportTo, "<c=orange>Total non lethal damage remaining: </c>"+IntToString(nAmount));
}

void ACR_NLD_HealAll( object oTarget ) {
    int nHeal = _GetNLDTotal( oTarget );
    ACR_NLD_HealNLD( oTarget, nHeal );
}

int ACR_NLD_DeathOrDyingHitDamage( object oTarget, object oAttacker ) {
    if ( GetIsObjectValid( oAttacker ) && GetObjectType( oAttacker ) == OBJECT_TYPE_CREATURE ) {
        if ( _GetNLDMode( oAttacker ) )
            return _GetLastNLDamage( oTarget );
    }
    return FALSE;
}

void ACR_NLD_OnDeath( object oDead ) {

    if ( _GetNLDMode( oDead ) ) {
        ACR_ToggleNLDMode( oDead );
    }

}

void ACR_NonLethalOnClientExit( object oDeparting ) {

    if ( _GetNLDMode( oDeparting ) ) {
        ACR_ToggleNLDMode( oDeparting );
    }
}


void ACR_ApplyNonlethalDamageToCreature( object oTarget, int nSubdualDamage ) {
    int nNLDTotal = _GetNLDTotal( oTarget );
    int nHPMax = GetMaxHitPoints( oTarget );
    int nCap = nHPMax + 10;
    SendMessageToPC( oTarget,"<c=orange>You take </c> "+IntToString( nSubdualDamage ) +" <c=orange> points of non-lethal damage.</c>" );
    nNLDTotal = ( ( nNLDTotal + nSubdualDamage ) > nCap ) ? nCap :
                nNLDTotal + nSubdualDamage;
    _SetNLDTotal( oTarget, nNLDTotal );
    ACR_ApplyNLDEffects( oTarget, nNLDTotal );
}


////////////////////////////////////////////////////////////////////////////////
// *** BEGIN PRIVATE FUNCTIONS ***
////////////////////////////////////////////////////////////////////////////////

int GetIsNonlethalImmune( object oTarget ) {
    // Check race.
    int iRace = GetRacialType( oTarget );
    switch ( iRace ) {
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
    case RACIAL_TYPE_ELEMENTAL:
    case RACIAL_TYPE_INCORPOREAL:
    case RACIAL_TYPE_OOZE:
        return TRUE;
    }

    // Check for spell effects that grant nonlethal damage immunity.
    if ( GetHasSpellEffect( SPELL_IRON_BODY, oTarget ) ) return TRUE;
    if ( GetHasSpellEffect( SPELL_STONE_BODY, oTarget ) ) return TRUE;

    // Feats that grant nonlethal immunity.
    if ( GetHasFeatEffect( FEAT_OAKEN_RESILIENCE, oTarget ) ) return TRUE;

    // Classes that grant nonlethal immunity.
    if ( GetLevelByClass( CLASS_TYPE_PALEMASTER, oTarget ) >= 10 ) return TRUE;

    // No other condition met? Then this target can take subdual damage.
    return FALSE;
}

void _NLDWeaponDamage( object oTarget, object oAttacker, object oItem, int bSneak = FALSE ) {
    // Check if the target is immune to subdual damage.
    if ( GetIsNonlethalImmune( oTarget ) ) {
        SendMessageToPC( oAttacker, "<c=orange>Target is immune to nonlethal damage</c>" );
        return;
    }

    // Valid weapon to deal subdual with?
    if ( !GetIsObjectValid( oItem ) ) {
        oItem = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oAttacker );
        if ( !GetIsObjectValid( oItem ) ) {
            SendMessageToPC( oAttacker, "<c=orange>No valid subdual weapon in hand</c>" );
            return;
        }
    }

    // Get weapon data.
    effect eHeal;
    int nHeal = 0;
    int nDiceDam = GetLocalInt( oItem,ACR_NLD_DICE_DAMAGE );
    int nDiceNum = GetLocalInt( oItem,ACR_NLD_DICE_NUMBER );
    int nDamMod;
    int n2Hand = GetLocalInt( oItem, ACR_NLD_W2HANDED );

    // Add strength damage.
    int nStrMod = GetAbilityModifier( ABILITY_STRENGTH, oAttacker );
    if ( nStrMod > 0 ) {
        nDamMod = ( n2Hand ) ? FloatToInt( IntToFloat( nStrMod ) * 1.5 ) : ( GetLocalInt( oItem, ACR_NLD_WOFFHAND ) == TRUE ) ? FloatToInt( IntToFloat( nStrMod ) * 0.5 ) : nStrMod;
    } else {
        nDamMod = nStrMod;
    }

    // Check for weapon specialization.
    if ( _NLDGetWeaponSpecialisation( oAttacker, oItem ) ) {
        nDamMod += 2;
        if ( _NLDGetGreaterWeaponSpecialisation( oAttacker, oItem ) ) nDamMod += 2;
    }

    // Add enchantment damage.
    int nEnhance = _NLDGetEnhancementBonus( oTarget, oItem );
    nDamMod += nEnhance;
	
	// Favored enemies.
    int nFavoredBonus = _NLDGetFavoredEnemyBonus( oAttacker, oTarget );
    nDamMod += nFavoredBonus;

    // Check for power attack modes
    if ( GetActionMode( oAttacker, ACTION_MODE_POWER_ATTACK ) == TRUE ) {
        if ( n2Hand ) nDamMod += 6;
        else nDamMod += 3;
    } else if ( GetActionMode( oAttacker, ACTION_MODE_IMPROVED_POWER_ATTACK ) == TRUE ) {
        if ( n2Hand ) nDamMod += 12;
        else nDamMod += 6;
    }

    // Add Insightful Strike damage.
    if ( GetHasFeat( FEAT_INSIGHTFUL_STRIKE, oAttacker )
            && GetEncumbranceState( oAttacker ) == ENCUMBRANCE_STATE_NORMAL
            && !GetIsImmune( oTarget, IMMUNITY_TYPE_SNEAK_ATTACK ) ) {
        nDamMod += GetAbilityModifier( ABILITY_INTELLIGENCE, oAttacker );
    }

    // Add precise strike damage.
    if ( GetHasFeat( FEAT_PRECISE_STRIKE, oAttacker ) && !GetIsObjectValid( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oAttacker ) ) ) {
        nDamMod += d6( 1 );
        if ( GetLevelByClass( CLASS_TYPE_DUELIST, oAttacker ) >= 10 ) nDamMod += d6( 1 );
    }

    // If we have more than +5 damage from bonuses, add some healing.
    if ( nDamMod > 5 ) {
        nHeal += nDamMod - 5;
    }
    if ( nHeal < 1 ) nHeal = 1;

    // Calculate damage.
    int nDamage = ( ( Random( nDiceDam ) + 1 ) * nDiceNum ) + nDamMod;

    // Sneak attack?
    if ( bSneak ) {
        int nSneakAttack = GetLocalInt( oItem, ACR_NLD_SA_DICE );
        if ( nSneakAttack > 0 ) nDamMod += d6( nSneakAttack );
    }

    // Calculate damage resistance.
    string sDRCheck = _NLDamageReductionCheck( oTarget, oItem, nDamage, nHeal );
    if ( GetStringLeft( sDRCheck, 2 ) == "ND" ) {
        nHeal = 0;
    } else {
        nHeal = StringToInt( GetStringLeft( sDRCheck, 2 ) );
    }
    nDamage = StringToInt( GetStringRight( sDRCheck, 2 ) );
    _SetLastNLDamage( oTarget, nDamage );

    // Heal damage.
    int nReportHealth = GetCurrentHitPoints( oTarget );
    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ) {
        if ( nHeal > 0 ) {
            if ( GetCurrentHitPoints( oTarget ) < GetMaxHitPoints( oTarget ) ) {
                eHeal = EffectHeal( nHeal );
                AssignCommand( oTarget, ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget ) );
                nReportHealth = nReportHealth + nHeal;
            }
        }
    }

    // Cap and set damage.
    int nTotalDam = nDamage + _GetNLDTotal( oTarget );
    if ( nTotalDam > GetMaxHitPoints( oTarget ) + 10 ) nTotalDam = GetMaxHitPoints( oTarget ) + 10;
    _SetNLDTotal( oTarget, nTotalDam );

    // Report.
    string sMsgAtk = ACR_CleanCreatureNameTextForPlayers( GetName( oAttacker ) )+"<c=orange> deals: </c>"+IntToString( nDamage )+"<c=orange> to </c>"+ACR_CleanCreatureNameTextForPlayers( GetName( oTarget ) );
    int nSubdualHealth = nReportHealth - nTotalDam;
    string sMsgTgt = sMsgAtk + "<c=orange>; Total subdual health is </c>" + IntToString( nSubdualHealth ) + "/" + IntToString( nReportHealth );
    SendMessageToPC( oAttacker, sMsgTgt );
    SendMessageToPC( oTarget, sMsgTgt );

    // Cache targets.
    SetLocalObject( oTarget, ACR_NLD_ATTACKER, oAttacker );
    SetLocalObject( oAttacker, ACR_NLD_TARGET, oTarget );

    // Apply NLD effects.
    ACR_ApplyNLDEffects( oTarget,nTotalDam );
}

int _NLDGetWeaponSpecialisation( object oAttacker, object oItem ) {
    // Save time if we aren't looking at at least a level 4 fighter.
    if ( GetLevelByClass( CLASS_TYPE_FIGHTER, oAttacker ) < 4 ) return FALSE;

    // Check for the greater weapon specialization feat.
    int nReturn = FALSE;
    int nType = GetBaseItemType( oItem );
    switch ( nType ) {
    case BASE_ITEM_BASTARDSWORD:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_BATTLEAXE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_CLUB:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_CLUB, oAttacker, TRUE );
        break;
    case BASE_ITEM_DAGGER:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_DAGGER, oAttacker, TRUE );
        break;
    case BASE_ITEM_DWARVENWARAXE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_DWAXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_GREATAXE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_GREAT_AXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_GREATSWORD:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_HALBERD:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_HALBERD, oAttacker, TRUE );
        break;
    case BASE_ITEM_HANDAXE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_HAND_AXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_HEAVYFLAIL:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL, oAttacker, TRUE );
        break;
    case BASE_ITEM_KAMA:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_KAMA, oAttacker, TRUE );
        break;
    case BASE_ITEM_KATANA:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_KATANA, oAttacker, TRUE );
        break;
    case BASE_ITEM_KUKRI:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_KUKRI, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTFLAIL:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTHAMMER:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTMACE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE, oAttacker, TRUE );
        break;
    case BASE_ITEM_LONGSWORD:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_LONG_SWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_MORNINGSTAR:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_MORNING_STAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_RAPIER:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_RAPIER, oAttacker, TRUE );
        break;
    case BASE_ITEM_SCIMITAR:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SCIMITAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_SCYTHE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SCYTHE, oAttacker, TRUE );
        break;
    case BASE_ITEM_SHORTSWORD:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_SICKLE:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SICKLE, oAttacker, TRUE );
        break;
    case BASE_ITEM_SPEAR:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SPEAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_QUARTERSTAFF:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_SPEAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_WARHAMMER:
        nReturn = GetHasFeat( FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER, oAttacker, TRUE );
        break;
    case BASE_ITEM_FALCHION:
        nReturn = GetHasFeat( 1591, oAttacker, TRUE );
        break;
    case BASE_ITEM_WARMACE:
        nReturn = GetHasFeat( 1602, oAttacker, TRUE );
        break;
    }
    return nReturn;
}

int _NLDGetGreaterWeaponSpecialisation( object oAttacker, object oItem ) {
    // Save time if we aren't looking at at least a level 12 fighter.
    if ( GetLevelByClass( CLASS_TYPE_FIGHTER, oAttacker ) < 12 ) return FALSE;

    // Check for the greater weapon specialization feat.
    int nReturn = FALSE;
    int nType = GetBaseItemType( oItem );
    switch ( nType ) {
    case BASE_ITEM_BASTARDSWORD:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_BASTARDSWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_BATTLEAXE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_BATTLEAXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_CLUB:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_CLUB, oAttacker, TRUE );
        break;
    case BASE_ITEM_DAGGER:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_DAGGER, oAttacker, TRUE );
        break;
    case BASE_ITEM_DWARVENWARAXE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_DWAXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_GREATAXE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_GREATAXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_GREATSWORD:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_GREATSWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_HALBERD:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_HALBERD, oAttacker, TRUE );
        break;
    case BASE_ITEM_HANDAXE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_HANDAXE, oAttacker, TRUE );
        break;
    case BASE_ITEM_HEAVYFLAIL:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_HEAVYFLAIL, oAttacker, TRUE );
        break;
    case BASE_ITEM_KAMA:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_KAMA, oAttacker, TRUE );
        break;
    case BASE_ITEM_KATANA:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_KATANA, oAttacker, TRUE );
        break;
    case BASE_ITEM_KUKRI:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_KUKRI, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTFLAIL:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTFLAIL, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTHAMMER:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTHAMMER, oAttacker, TRUE );
        break;
    case BASE_ITEM_LIGHTMACE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_LIGHTMACE, oAttacker, TRUE );
        break;
    case BASE_ITEM_LONGSWORD:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_LONGSWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_MORNINGSTAR:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_MORNINGSTAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_RAPIER:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_RAPIER, oAttacker, TRUE );
        break;
    case BASE_ITEM_SCIMITAR:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_SCIMITAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_SCYTHE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_SCYTHE, oAttacker, TRUE );
        break;
    case BASE_ITEM_SHORTSWORD:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTSWORD, oAttacker, TRUE );
        break;
    case BASE_ITEM_SICKLE:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_SICKLE, oAttacker, TRUE );
        break;
    case BASE_ITEM_SPEAR:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTSPEAR, oAttacker, TRUE );
        break;
    case BASE_ITEM_QUARTERSTAFF:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_QUARTERSTAFF, oAttacker, TRUE );
        break;
    case BASE_ITEM_WARHAMMER:
        nReturn = GetHasFeat( FEAT_GREATER_WEAPON_SPECIALIZATION_WARHAMMER, oAttacker, TRUE );
        break;
    case BASE_ITEM_FALCHION:
        nReturn = GetHasFeat( 1598, oAttacker, TRUE );
        break;
    case BASE_ITEM_WARMACE:
        nReturn = GetHasFeat( 1609, oAttacker, TRUE );
        break;
    }
    return nReturn;
}

int _NLDGetEnhancementBonus( object oTarget, object oItem ) {
    int nReturn = 0;

    // Loop through item properties.
    itemproperty iProp = GetFirstItemProperty( oItem );
    while ( GetIsItemPropertyValid( iProp ) ) {
        // Get property data.
        int iType = GetItemPropertyType( iProp );
        int iSubType = GetItemPropertySubType( iProp );
        int iValue = GetItemPropertyCostTableValue( iProp );
        int iParam1 = GetItemPropertyParam1Value( iProp );

        // If the enhancement bonus would be greater...
        if ( iValue > nReturn ) {
            switch ( iType ) {
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                nReturn = iValue;
                break;
            case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
                if ( iSubType == IP_CONST_ALIGNMENTGROUP_ALL ) {
                    nReturn = iValue;
                } else if ( iSubType == IP_CONST_ALIGNMENTGROUP_GOOD && GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_GOOD ) {
                    nReturn = iValue;
                } else if ( iSubType == IP_CONST_ALIGNMENTGROUP_EVIL && GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_EVIL ) {
                    nReturn = iValue;
                } else if ( iSubType == IP_CONST_ALIGNMENTGROUP_NEUTRAL && GetAlignmentGoodEvil( oTarget ) == ALIGNMENT_NEUTRAL ) {
                    nReturn = iValue;
                } else if ( iSubType == IP_CONST_ALIGNMENTGROUP_LAWFUL && GetAlignmentLawChaos( oTarget ) == ALIGNMENT_LAWFUL ) {
                    nReturn = iValue;
                } else if ( iSubType == IP_CONST_ALIGNMENTGROUP_CHAOTIC && GetAlignmentLawChaos( oTarget ) == ALIGNMENT_CHAOTIC ) {
                    nReturn = iValue;
                }
                break;
            case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
                if ( GetRacialType( oTarget ) == iSubType ) nReturn = iValue;
                break;
            }
        }

        // Next property.
        iProp = GetNextItemProperty( oItem );
    }

    return nReturn;
}

int _NDLGetFavoredEnemyFeat( object oTarget ) {
	int nFeatID = -1;
	switch ( GetRacialType( oTarget ) ) {
		case RACIAL_TYPE_ABERRATION:
			nFeatID = FEAT_FAVORED_ENEMY_ABERRATION;
			break;
		case RACIAL_TYPE_ANIMAL:
			nFeatID = FEAT_FAVORED_ENEMY_ANIMAL;
			break;
		case RACIAL_TYPE_BEAST:
			nFeatID = FEAT_FAVORED_ENEMY_BEAST;
			break;
		case RACIAL_TYPE_CONSTRUCT:
			nFeatID = FEAT_FAVORED_ENEMY_CONSTRUCT;
			break;
		case RACIAL_TYPE_DRAGON:
			nFeatID = FEAT_FAVORED_ENEMY_DRAGON;
			break;
		case RACIAL_TYPE_DWARF:
			nFeatID = FEAT_FAVORED_ENEMY_DWARF;
			break;
		case RACIAL_TYPE_ELEMENTAL:
			nFeatID = FEAT_FAVORED_ENEMY_ELEMENTAL;
			break;
		case RACIAL_TYPE_ELF:
			nFeatID = FEAT_FAVORED_ENEMY_ELF;
			break;
		case RACIAL_TYPE_FEY:
			nFeatID = FEAT_FAVORED_ENEMY_FEY;
			break;
		case RACIAL_TYPE_GIANT:
			nFeatID = FEAT_FAVORED_ENEMY_GIANT;
			break;
		case RACIAL_TYPE_GNOME:
			nFeatID = FEAT_FAVORED_ENEMY_GNOME;
			break;
		case RACIAL_TYPE_GRAYORC:
			nFeatID = FEAT_FAVORED_ENEMY_ORC;
			break;
		case RACIAL_TYPE_HALFELF:
			nFeatID = FEAT_FAVORED_ENEMY_HALFELF;
			break;
		case RACIAL_TYPE_HALFLING:
			nFeatID = FEAT_FAVORED_ENEMY_HALFLING;
			break;
		case RACIAL_TYPE_HALFORC:
			nFeatID = FEAT_FAVORED_ENEMY_HALFORC;
			break;
		case RACIAL_TYPE_HUMAN:
			nFeatID = FEAT_FAVORED_ENEMY_HUMAN;
			break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:
			nFeatID = FEAT_FAVORED_ENEMY_GOBLINOID;
			break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:
			nFeatID = FEAT_FAVORED_ENEMY_MONSTROUS;
			break;
		case RACIAL_TYPE_HUMANOID_ORC:
			nFeatID = FEAT_FAVORED_ENEMY_ORC;
			break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:
			nFeatID = FEAT_FAVORED_ENEMY_REPTILIAN;
			break;
		case RACIAL_TYPE_MAGICAL_BEAST:
			nFeatID = FEAT_FAVORED_ENEMY_MAGICAL_BEAST;
			break;
		case RACIAL_TYPE_OUTSIDER:
			nFeatID = FEAT_FAVORED_ENEMY_OUTSIDER;
			break;
		case RACIAL_TYPE_SHAPECHANGER:
			nFeatID = FEAT_FAVORED_ENEMY_SHAPECHANGER;
			break;
		case RACIAL_TYPE_UNDEAD:
			nFeatID = FEAT_FAVORED_ENEMY_UNDEAD;
			break;
		case RACIAL_TYPE_VERMIN:
			nFeatID = FEAT_FAVORED_ENEMY_VERMIN;
			break;
		case RACIAL_TYPE_YUANTI:
			nFeatID = FEAT_FAVORED_ENEMY_REPTILIAN;
			break;
	}
	return nFeatID;
}

int _NDLGetImprovedFavoredEnemyFeat( object oTarget ) {
	int nFeatID = -1;
	switch ( GetRacialType( oTarget ) ) {
		case RACIAL_TYPE_ABERRATION:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ABERRATION;
			break;
		case RACIAL_TYPE_ANIMAL:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ANIMAL;
			break;
		case RACIAL_TYPE_BEAST:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_BEAST;
			break;
		case RACIAL_TYPE_CONSTRUCT:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_CONSTRUCT;
			break;
		case RACIAL_TYPE_DRAGON:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_DRAGON;
			break;
		case RACIAL_TYPE_DWARF:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_DWARF;
			break;
		case RACIAL_TYPE_ELEMENTAL:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ELEMENTAL;
			break;
		case RACIAL_TYPE_ELF:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ELF;
			break;
		case RACIAL_TYPE_FEY:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_FEY;
			break;
		case RACIAL_TYPE_GIANT:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_GIANT;
			break;
		case RACIAL_TYPE_GNOME:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_GNOME;
			break;
		case RACIAL_TYPE_GRAYORC:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ORC;
			break;
		case RACIAL_TYPE_HALFELF:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_HALFELF;
			break;
		case RACIAL_TYPE_HALFLING:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_HALFLING;
			break;
		case RACIAL_TYPE_HALFORC:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_HALFORC;
			break;
		case RACIAL_TYPE_HUMAN:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_HUMAN;
			break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_GOBLINOID;
			break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_MONSTROUS;
			break;
		case RACIAL_TYPE_HUMANOID_ORC:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_ORC;
			break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_REPTILIAN;
			break;
		case RACIAL_TYPE_MAGICAL_BEAST:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_MAGICAL_BEAST;
			break;
		case RACIAL_TYPE_OUTSIDER:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_OUTSIDER;
			break;
		case RACIAL_TYPE_SHAPECHANGER:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_SHAPECHANGER;
			break;
		case RACIAL_TYPE_UNDEAD:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_UNDEAD;
			break;
		case RACIAL_TYPE_VERMIN:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_VERMIN;
			break;
		case RACIAL_TYPE_YUANTI:
			nFeatID = FEAT_IMPROVED_FAVORED_ENEMY_REPTILIAN;
			break;
	}
	return nFeatID;
}

int _NLDGetFavoredEnemyBonus( object oAttacker, object oTarget ) {
	int nTotalBonus = 0;
	
	// Get feats.
	int nFEFeat = _NDLGetFavoredEnemyFeat( oTarget );
	int nIFEFeat = _NDLGetImprovedFavoredEnemyFeat( oTarget );
	
	// Favored enemy?
	int nFEBonus = ( GetLevelByClass( CLASS_TYPE_RANGER, oAttacker ) / 5 ) + 1;
	if ( nFEFeat != -1 && GetHasFeat( nFEFeat, oAttacker, TRUE ) ) {
		nTotalBonus += nFEBonus;
	}
	
	// Improved favored enemy?
	if ( nIFEFeat != -1 && GetHasFeat( nIFEFeat, oAttacker, TRUE ) ) {
		nTotalBonus += 5;
	}
	
	return nTotalBonus;
}

string _NLDamageReductionCheck( object oTarget, object oWeapon, int nNLDamage, int nHeal ) {
    string sReturn = "";
    int nDam = 0;
    int nHigh;
    string sHeal;
    string sWeapon = GetTag( oWeapon );
    object oSkin = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oTarget );
    int nSDancer = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oTarget );
// Determine if oTarget has DR bypassable by adamantine weapons (spells only)
    int nAdm = ( GetHasSpellEffect( SPELL_PREMONITION, oTarget ) == TRUE
                 || GetHasSpellEffect( SPELL_SHADES_TARGET_CASTER, oTarget ) == TRUE ) ? 30 :
               ( GetHasSpellEffect( SPELL_GREATER_STONESKIN, oTarget ) == TRUE
                 || GetHasSpellEffect( SPELL_ETHEREAL_VISAGE, oTarget ) == TRUE ) ? 20 :
               ( GetHasSpellEffect( SPELL_STONESKIN, oTarget ) == TRUE
                 || GetHasSpellEffect( SPELL_SHADES_STONESKIN, oTarget ) == TRUE
                 || GetHasSpellEffect( SPELL_SHADOW_SHIELD, oTarget ) == TRUE
                 || ( GetHasSpellEffect( SPELL_SHADOW_EVADE, oTarget ) && nSDancer >= 10 ) ) ? 10 :
               ( GetHasSpellEffect( SPELLABILITY_MERGE_WITH_STONE, oTarget ) == TRUE ) ? 5 : FALSE;
    if ( nAdm != FALSE ) {
// Check the attackers weapon - is it adamantine?
        if ( TestStringAgainstPattern( "**"+ACR_NLD_MAT_ADAMANTINE+"**", sWeapon ) )
            nAdm = FALSE;
    }

// Determine if oTarget has DR bypassable by magic weapons
    int nMgc = ( GetLevelByClass( CLASS_TYPE_MONK, oTarget ) >= 20 ) ? 10 :
               ( GetHasSpellEffect( SPELL_GHOSTLY_VISAGE, oTarget ) == TRUE
                 || GetHasSpellEffect( SPELLABILITY_AS_GHOSTLY_VISAGE, oTarget ) == TRUE
                 || ( GetHasSpellEffect( 351, oTarget ) == TRUE ) || ( nSDancer <= 5
                         && GetHasSpellEffect( SPELL_SHADOW_EVADE, oTarget ) ) ) ? 5 : FALSE;
    if ( nMgc != FALSE ) {
// Check the attackers weapon - is it magical?
        if ( GetItemHasItemProperty( oWeapon, ITEM_PROPERTY_ENHANCEMENT_BONUS ) )
            nMgc = FALSE;
    }

// Determine if oTarget has DR bypassable by cold iron weapons
    int nWlk = GetLevelByClass( CLASS_TYPE_WARLOCK, oTarget );
    int nCld= ( nWlk >= 3 && nWlk < 7 ) ? 1 : ( nWlk >= 7 && nWlk < 11 ) ? 2 :
              ( nWlk >= 11 && nWlk < 15 ) ? 3 : ( nWlk >= 15 && nWlk < 19 ) ? 4 :
              ( nWlk >= 19 || GetLevelByClass( CLASS_TYPE_SPIRIT_SHAMAN, oTarget ) >= 20 ) ? 5 :
              ( GetHasFeat( 2087, oTarget ) ) ? 10 : FALSE;
    int nFey = GetHasFeat( 2184, oTarget, TRUE );
    int nCnt;
    if ( nFey ) {
        for ( nCnt=2181; nCnt<=2184; nCnt++ ) {
            if ( GetHasFeat( nFey, oTarget, TRUE ) )
                nFey += 1;
        }
        nCld += nFey;
    }
    if ( nCld != FALSE ) {
// Check the attackers weapon - is it cold iron?
        if ( TestStringAgainstPattern( "**"+ACR_NLD_MAT_COLDIRON+"**", sWeapon ) )
            nCld = FALSE;
    }

// Determine if oTarget has DR bypassable by silver weapons
    int nSlv = ( GetHasSpellEffect( SPELL_I_DARK_FORESIGHT, oTarget ) == TRUE || GetHasFeat( 2088, oTarget )
                 || ( GetHasSpellEffect( SPELL_SHADOW_EVADE, oTarget ) && ( nSDancer == 8 || nSDancer == 9 ) )
                 || GetRacialType( oTarget ) == RACIAL_TYPE_SHAPECHANGER ) ? 10 :
               ( GetHasSpellEffect( SPELL_SHADOW_EVADE, oTarget ) && ( nSDancer == 6 || nSDancer == 7 ) ) ? 5 : FALSE;
    if ( nSlv != FALSE ) {
// Check the attackers weapon - is it alchemical silver?
        if ( TestStringAgainstPattern( "**"+ACR_NLD_MAT_ALCSILVER+"**", sWeapon ) )
            nSlv = FALSE;
    }

    if ( nAdm != FALSE || nMgc != FALSE || nSlv != FALSE || nCld != FALSE ) {
        nHigh = ( nAdm >= nMgc && nAdm >= nSlv && nAdm >= nCld ) ? nAdm :
                ( nSlv >= nMgc && nSlv >= nCld ) ? nSlv :
                ( nCld >= nMgc ) ? nCld : nMgc;
    } else
        nHigh = FALSE;

    if ( nHigh != FALSE ) {
        effect eDam;
        if ( nHigh >= nNLDamage ) {
            nDam = ( nNLDamage > nHeal ) ? nNLDamage - nHeal : 0;
            sReturn = "ND_00";
        } else {
            sReturn = IntToString( nNLDamage - nHigh );
            if ( GetStringLength( sReturn ) == 1 )
                sReturn = "0"+sReturn;
            if ( nHigh >= nHeal ) {
                nDam = nHigh - nHeal;
                sReturn = "ND_"+sReturn;
            } else {
                nDam = 0;
                sHeal = IntToString( nHeal - nHigh ) + "_";
                if ( GetStringLength( sHeal ) == 2 )
                    sHeal = "0"+sHeal;
                sReturn = sHeal+sReturn;
            }
        }
        if ( nDam > 0 ) {
            eDam = EffectDamage( nDam, DAMAGE_TYPE_BLUDGEONING );
            AssignCommand( GetItemPossessor( oWeapon ),
                           ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget ) );
        }
    } else {
// Determine if oTarget has DR not bypassable by anything
// (barb DR or adamantine armor/shield only)
        int nBarb = GetLevelByClass( CLASS_TYPE_BARBARIAN, oTarget );
        int nDDef = GetLevelByClass( CLASS_TYPE_DWARVENDEFENDER, oTarget );
        int nNoPass = ( nBarb >= 7   && nBarb < 10 ) ? 1 : ( nBarb >= 10 && nBarb < 13 ) ? 2 :
                      ( ( nBarb >= 13 && nBarb < 16 ) || ( nDDef >= 6 && nDDef < 10 ) ) ? 3 :
                      ( nBarb >= 16 && nBarb < 19 ) ? 4 : ( nBarb >= 19 ) ? 5 : ( nDDef >= 10 ) ? 6 : FALSE;
        if ( nNoPass != FALSE ) {
// Check for the Greater Resiliency feat (barb only)
            nNoPass = ( GetHasFeat( FEAT_GREATER_RESILIENCY, oTarget ) == TRUE ) ?
                      nNoPass+1 : nNoPass;
        }
        int nArm = 0;
        int nRank;
        object oArm = GetItemInSlot( INVENTORY_SLOT_CHEST, oTarget );
        if ( GetIsObjectValid( oArm ) ) {
            string sArm = GetTag( oArm );
            if ( TestStringAgainstPattern( "**"+ACR_NLD_MAT_ADAMANTINE+"**", sArm ) ) {
                nRank = GetArmorRank( oArm );
                nArm = ( nRank == ARMOR_RANK_HEAVY ) ? 3 : ( nRank == ARMOR_RANK_MEDIUM ) ? 2 :
                       ( nRank == ARMOR_RANK_LIGHT ) ? 1 : 0;
            }
        }
        object oShd = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oTarget );
        if ( GetIsObjectValid( oShd ) ) {
            string sShd = GetTag( oShd );
            if ( TestStringAgainstPattern( "**"+ACR_NLD_MAT_ADAMANTINE+"**", sShd ) ) {
                int nType = GetBaseItemType( oShd );
                nArm = ( nType == BASE_ITEM_TOWERSHIELD && nArm < 3 ) ? 3 :
                       ( nType == BASE_ITEM_LARGESHIELD && nArm < 2 ) ? 2 :
                       ( nType == BASE_ITEM_SMALLSHIELD && nArm < 1 ) ? 1 : nArm;
            }
        }
        nNoPass = ( nNoPass >= nArm ) ? nNoPass : nArm;
        if ( nNoPass >= 1 ) {
            if ( nNoPass < nNLDamage ) {
                sReturn = IntToString( nNLDamage - nNoPass );
                if ( GetStringLength( sReturn ) == 1 )
                    sReturn == "0"+sReturn;
                if ( nNoPass >= nHeal )
                    sReturn = "ND_"+sReturn;
                else {
                    sHeal = IntToString( nHeal - nNoPass ) + "_";
                    if ( GetStringLength( sHeal ) == 2 )
                        sHeal = "0"+sHeal;
                    sReturn = sHeal + sReturn;
                }
            } else
                sReturn = "ND_00";
        } else {
            sReturn = IntToString( nNLDamage );
            if ( GetStringLength( sReturn ) == 1 )
                sReturn = "0"+sReturn;
            sHeal = IntToString( nHeal ) + "_";
            if ( GetStringLength( sHeal ) == 2 )
                sHeal = "0"+sHeal;
            sReturn = sHeal + sReturn;
        }
    }
    return sReturn;
}

void _GiveNLDFist( object oUser ) {
    if ( !GetIsObjectValid( oUser ) )
        return;
    object oFist = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oUser );
	if(GetIsPC(oUser) && ACR_GetIsPlayerDead(oUser))
	{
		// Let's not flood corpses with NLD fists; proper thing to do is
		// just turn NLD mode off.
		ACR_ToggleNLDMode(oUser);
		return;
	}
    if ( !GetIsObjectValid( oFist ) ) {
        oFist = CreateItemOnObject( ACR_NLD_FIST, oUser, 1, ACR_NLD_FIST, FALSE );
        FeatAdd( oUser, FEAT_WEAPON_PROFICIENCY_CREATURE, FALSE );
        DelayCommand( 0.1,AssignCommand( oUser,ActionEquipItem( oFist, INVENTORY_SLOT_CWEAPON_R ) ) );
        DelayCommand( 2.0, _ApplyNLDFist( oUser ) );
    } else
        SendMessageToPC( oUser, "<c=orange>Already have a creature weapon. Cannot use subdual mode with this creature weapon</c>" );
}

void _ApplyNLDFist( object oUser ) {
    object oFist = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oUser );
    if ( !GetIsObjectValid( oFist ) ) {
        return;
    }
    int nDiceDam, nDiceNum, nSADice, nSlot, nSize, nMonk;
    nSize = GetCreatureSize( oUser );
    nDiceNum = 1;
    nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 2 : 3;
    nMonk = GetLevelByClass( CLASS_TYPE_MONK, oUser )
            + GetLevelByClass( CLASS_TYPE_SACREDFIST, oUser );
    if ( nMonk >= 1 ) {
        if ( nMonk <= 3 )
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 4 : 6;
        else if ( nMonk <= 7 )
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 6 : 8;
        else if ( nMonk <= 11 )
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 8 : 10;
        else if ( nMonk <= 15 ) {
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 10 : 6;
            nDiceNum = ( nSize == CREATURE_SIZE_SMALL ) ? 1 : 2;
        } else if ( nMonk <= 19 ) {
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 6 : 8;
            nDiceNum = 2;
        } else {
            nDiceDam = ( nSize == CREATURE_SIZE_SMALL ) ? 8 : 10;
            nDiceNum = 2;
        }
    }
    nSADice = _GetNLDSneakAttackDice( oUser );
    SetLocalInt( oFist, ACR_NLD_DICE_DAMAGE, nDiceDam );
    SetLocalInt( oFist, ACR_NLD_DICE_NUMBER, nDiceNum );
    SetLocalInt( oFist, ACR_NLD_SA_DICE, nSADice );
    SetLocalInt( oFist, ACR_NLD_WOFFHAND, FALSE );
    SetLocalInt( oFist, ACR_NLD_W2HANDED, FALSE );
    if ( GetHasFeat( FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oUser ) )
        FeatAdd( oUser, FEAT_WEAPON_FOCUS_CREATURE, FALSE );
}


void _NLDNaturalHealing( object oTarget, int nCnt = 0 ) {
    if ( !GetIsObjectValid( oTarget ) )
        return;
    nCnt += 1;
    int nNLD = _GetNLDTotal( oTarget );
    if ( nNLD < 1 ) {
        _SetIsNLDHealing( oTarget, FALSE );
        return;
    }
    if ( nCnt >= ACR_NLD_HEALRATE ) {	// healrate determined by this constant
        nNLD -= 1;
        _SetNLDTotal( oTarget, nNLD );
        int nCurrentHealth = GetCurrentHitPoints( oTarget );
        int nSubdualHealth = nCurrentHealth - nNLD;
        SendMessageToPC( oTarget, "<c=orange>Healed 1 point of non lethal damage. Subdual Health now: </c>"+IntToString( nSubdualHealth ) +"/"+IntToString( nCurrentHealth ) );
        nCnt = 0;
    }
    DelayCommand( RoundsToSeconds( 1 ), _NLDNaturalHealing( oTarget, nCnt ) );
    ACR_ApplyNLDEffects( oTarget, nNLD );
}

void _RemoveNLDStaggeredEffect( object oTarget ) {
    effect eSubD = GetFirstEffect( oTarget );
    object oMod = GetModule();
    while ( GetIsEffectValid( eSubD ) ) {
        if ( GetEffectType( eSubD ) == EFFECT_TYPE_DAZED ) {
            DelayCommand( 0.1, RemoveEffect( oTarget, eSubD ) );
        } else if ( GetEffectType( eSubD ) == EFFECT_TYPE_ABILITY_DECREASE ) {
            DelayCommand( 0.2, RemoveEffect( oTarget, eSubD ) );
        }
        eSubD = GetNextEffect( oTarget );
    }
}

void _RemoveNLDHelplessEffect( object oTarget ) {
    SetCommandable( TRUE, oTarget );
    object oMod = GetModule();
    effect eTest = GetFirstEffect( oTarget );
    // loop through to clear DEX penalty.
    while ( GetIsEffectValid( eTest ) ) {
        if ( GetEffectType( eTest ) == EFFECT_TYPE_ABILITY_DECREASE || GetEffectType( eTest ) == EFFECT_TYPE_STUNNED ) {
            DelayCommand( 0.2, RemoveEffect( oTarget, eTest ) );
        }
        eTest = GetNextEffect( oTarget );
    }
    DelayCommand( 0.1,AssignCommand( oTarget,ClearAllActions() ) );
}

int _GetNLDSneakAttackDice( object oAttacker ) {
    return _GetNLDSAFeatList( oAttacker );
}

void _HandleNLDSneakAttacks( object oAttacker ) {
    string sFeatList, sFeat;
    int nFeat, nDice = 0;
    if ( GetLevelByClass( CLASS_TYPE_ROGUE, oAttacker ) >= 1 ) {
        FeatRemove( oAttacker, 221 );
        nDice += 1;
        for ( nFeat=345; nFeat<=353; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_TYPE_ASSASSIN, oAttacker ) >= 1 ) {
        for ( nFeat=455; nFeat<=459; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_TYPE_BLACKGUARD, oAttacker ) >= 1 ) {
        for ( nFeat=460; nFeat<=462; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_TYPE_ARCANETRICKSTER, oAttacker ) >= 1 ) {
        for ( nFeat=1502; nFeat<=1506; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_TYPE_SHADOWTHIEFOFAMN, oAttacker ) >= 1 ) {
        for ( nFeat=1562; nFeat<=1564; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_NWNINE_WARDER, oAttacker ) >= 1 ) {
        for ( nFeat=1497; nFeat<=1499; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( GetLevelByClass( CLASS_TYPE_INVISIBLE_BLADE, oAttacker ) >= 1 ) {
        for ( nFeat=2052; nFeat<=2054; nFeat++ ) {
            if ( GetHasFeat( nFeat, oAttacker ) ) {
                FeatRemove( oAttacker, nFeat );
                nDice += 1;
            }
        }
    }
    if ( nDice > 0 )
        _SetNLDSAFeatList( oAttacker, nDice );
}

void _RestoreNLDSneakAttackFeats( object oPC ) {
    int i, nFeat, nLevel;

// Restore any missing rogue feats
    nLevel = GetLevelByClass( CLASS_TYPE_ROGUE, oPC );
    if ( nLevel >= 1 ) {
        FeatAdd( oPC, 221, TRUE );
        i = 3;
        nFeat = 345;
        while ( i <= 19 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 2;
            nFeat += 1;
        }
    }

// Restore any missing assassin feats
    nLevel = GetLevelByClass( CLASS_TYPE_ASSASSIN, oPC );
    if ( nLevel >= 1 ) {
        i = 1;
        nFeat = 455;
        while ( i <= 9 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 2;
            nFeat += 1;
        }
    }

// Restore any missing blackguard feats
    nLevel = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );
    if ( nLevel >= 4 ) {
        i = 4;
        nFeat = 460;
        while ( i <= 10 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 3;
            nFeat += 1;
        }
    }

// Restore any missing arcane trickster feats
    nLevel = GetLevelByClass( CLASS_TYPE_ARCANETRICKSTER, oPC );
    if ( nLevel >= 2 ) {
        i = 2;
        nFeat = 1502;
        while ( i <= 10 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 2;
            nFeat += 1;
        }
    }

// Restore any missing shadow thief of amn feats
    nLevel = GetLevelByClass( CLASS_TYPE_SHADOWTHIEFOFAMN, oPC );
    if ( nLevel >= 1 ) {
        i = 1;
        nFeat = 1562;
        while ( i <= 5 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 2;
            nFeat += 1;
        }
    }

// Skip NWN9. They're knight protectors for us, and thus don't get sneak attack.

// Restore any missing invisible blade feats
    nLevel = GetLevelByClass( CLASS_TYPE_INVISIBLE_BLADE, oPC );
    if ( nLevel >= 1 ) {
        i = 1;
        nFeat = 2052;
        while ( i <= 5 && i <= nLevel ) {
            FeatAdd( oPC, nFeat, TRUE );
            i += 2;
            nFeat += 1;
        }
    }
}

int _GetNLDSAFeatList( object oAttacker ) {
    return GetLocalInt( oAttacker, ACR_NLD_SNEAKATTACK );
}

void _SetNLDSAFeatList( object oAttacker, int nFeatList ) {
    SetLocalInt( oAttacker, ACR_NLD_SNEAKATTACK, nFeatList );
}

int _GetNLDMode( object oUser ) {
    return ( GetLocalInt( oUser, ACR_NLD_MODE ) ) ? TRUE : FALSE;
}

void _SetNLDMode( object oUser, int bMode ) {
    SetLocalInt( oUser, ACR_NLD_MODE, bMode );
    string sMessage;
    if ( bMode ) {
        sMessage = "<c=orange>Subdual Mode Activated</c>";
        FloatingTextStringOnCreature( "<c=orange>Subdual Mode Activated</c>", oUser, FALSE, 3.0 );
    } else {
        sMessage = "<c=blue>Subdual Mode Deactivated</c>";
        FloatingTextStringOnCreature( "<c=orange>Subdual Mode Deactivated</c>", oUser, FALSE, 3.0 );
        DeleteLocalObject( oUser, ACR_NLD_TARGET );
    }
//  SendMessageToPC(oUser, sMessage);
    ACR_NLD_ReportTotal( oUser, oUser, _GetNLDTotal( oUser ) );
}

int _GetNLDState( object oTarget ) {
    return GetLocalInt( oTarget, ACR_NLD_STATE );
}

void _SetNLDState( object oTarget, int nState ) {
    SetLocalInt( oTarget, ACR_NLD_STATE, nState );
}

int _GetNLDTotal( object oTarget ) {
    return GetLocalInt( oTarget, ACR_NLD_DAMAGE_TOTAL );
}

void _SetNLDTotal( object oTarget, int nAmount ) {
    SetLocalInt( oTarget, ACR_NLD_DAMAGE_TOTAL, nAmount );
}

int _GetLastNLDamage( object oTarget ) {
    return GetLocalInt( oTarget,ACR_NLD_DAMAGE );
}

void _SetLastNLDamage( object oTarget, int nDamage ) {
    SetLocalInt( oTarget,ACR_NLD_DAMAGE,nDamage );
}

int _GetIsNLDHealing( object oTarget ) {
    return GetLocalInt( oTarget, ACR_NLD_HEALING );
}

void _SetIsNLDHealing( object oTarget, int bHeal ) {
    SetLocalInt( oTarget, ACR_NLD_HEALING, bHeal );
}

void _DoSubduedAnimation( object oTarget ) {
    int nState = _GetNLDState( oTarget );
    // if the target is still helpless, play the animation again.
    if ( nState == ACR_NLD_STATE_HELPLESS ) {
        PlayCustomAnimation( oTarget, "proneb", 1 );
        DelayCommand( 2.0, _DoSubduedAnimation( oTarget ) );
    }
    // otherwise, do nothing (ends the looping animations)
}

#endif
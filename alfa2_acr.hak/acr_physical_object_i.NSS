////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_physical_object_i
//      Version : 0.1
//         Date : 5/13/06
//       Author : Ronan
//
//  Local Variable Prefix = ACR_POB
//
//  Dependencies external of nwscript:
//
//  Description
//  This script contains tools used to replicate 3.5 rules with regard to
//  inanimate, physical objects. Mechanics shared by both placeable objects and
//  doors can be found here.
//
//  Known issues:
//  SetHardness() does not reset the hardness against energy damage.
//
//  Revision History
//  2006/11/15  ç i p h é r  Fixed ACR function references
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_PHYSICAL_OBJ_I
#define ACR_PHYSICAL_OBJ_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_debug_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

const int CREATURE_SIZE_FINE = -5;
const int CREATURE_SIZE_DIMINUTIVE = -4;
const int CREATURE_SIZE_GARGANTUAN = -3;
const int CREATURE_SIZE_COLOSSAL = -2;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Global Variables ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Initializes the system of rules governing physical objects.
//void InitializePhysicalObjects();

// Initializes oObject, creating the appropriate effects to duplicate the DMG's
// rules.
void ACR_InitializePhysicalObject(object oObject);

// Applies 3.5's damage rules to a physical object based on its OnDamaged event.
void ACR_PhysicalObjectOnDamaged();

//! Retursn the modifier to the roll to break open an object based on a
//! creature's size.
int ACR_GetBreakSizeModifier(int nCreatureSize);

////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// D20 SRD:
//
// Energy Attacks
// Acid and sonic attacks deal damage to most objects just as they do to
// creatures; roll damage and apply it normally after a successful hit.
// Electricity and fire attacks deal half damage to most objects; divide the
// damage dealt by 2 before applying the hardness. Cold attacks deal one-quarter
// damage to most objects; divide the damage dealt by 4 before applying the
// hardness.
//
// Ranged Weapon Damage
// Objects take half damage from ranged weapons (unless the weapon is a siege
// engine or something similar). Divide the damage dealt by 2 before applying
// the objects hardness.
/*void ApplyPhysicalObjectEffects(object oObject) {
    // FIX ME!!
    // Halve ranged weapon damage if possible.

    int nHardness = GetHardness(oObject);
    effect eEffects = EffectDamageResistance(DAMAGE_TYPE_ACID, nHardness);
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_ACID, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_COLD, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_DIVINE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_FIRE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_MAGICAL, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_SONIC, nHardness) );

    int nAcidImmunity = GetLocalInt(oObject, _ACR_POB_ACID_IMMUNITY);
    int nBludgeImmunity = GetLocalInt(oObject, _ACR_POB_BLUDGEONING_IMMUNITY);
    int nColdImmunity = GetLocalInt(oObject, _ACR_POB_COLD_IMMUNITY);
    int nDivineImmunity = GetLocalInt(oObject, _ACR_POB_DIVINE_IMMUNITY);
    int nFireImmunity = GetLocalInt(oObject, _ACR_POB_ELECTRICAL_IMMUNITY);
    int nElectricalImmunity = GetLocalInt(oObject, _ACR_POB_FIRE_IMMUNITY);
    int nMagicalImmunity = GetLocalInt(oObject, _ACR_POB_MAGICAL_IMMUNITY);
    int nNegativeImmunity = GetLocalInt(oObject, _ACR_POB_NEGATIVE_IMMUNITY);
    int nPierceImmunity = GetLocalInt(oObject, _ACR_POB_PIERCING_IMMUNITY);
    int nPositiveImmunity = GetLocalInt(oObject, _ACR_POB_POSITIVE_IMMUNITY);
    int nSlashImmunity = GetLocalInt(oObject, _ACR_POB_SLASHING_IMMUNITY);

    // FIX ME!
    int nRangedImmunity = GetLocalInt(oObject, _ACR_POB_RANGED_IMMUNITY);

    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, nAcidImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, nBludgeImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, nColdImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, nDivineImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, nFireImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, nElectricalImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, nMagicalImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, nNegativeImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, nPierceImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, nPositiveImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, nSlashImmunity) );
    eEffects = EffectLinkEffects(eEffects, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT) );

    AssignCommand(_oPhysicalObjectStorageObject, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eEffects), oObject) );

    // We delete the ints to free up memory.
    DeleteLocalInt(oObject, _ACR_POB_ACID_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_BLUDGEONING_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_COLD_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_DIVINE_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_ELECTRICAL_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_FIRE_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_MAGICAL_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_NEGATIVE_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_PIERCING_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_POSITIVE_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_SLASHING_IMMUNITY);
    DeleteLocalInt(oObject, _ACR_POB_RANGED_IMMUNITY);
}*/

void ACR_PhysicalObjectOnDamaged() {

}

int ACR_GetBreakSizeModifier(int nCreatureSize) {
    switch(nCreatureSize) {
        case CREATURE_SIZE_FINE:
            return -16;
        case CREATURE_SIZE_DIMINUTIVE:
            return -12;
        case CREATURE_SIZE_TINY:
            return -8;
        case CREATURE_SIZE_SMALL:
            return -4;
        case CREATURE_SIZE_MEDIUM:
            return 0;
        case CREATURE_SIZE_LARGE:
            return 4;
        case CREATURE_SIZE_HUGE:
            return 8;
        case CREATURE_SIZE_GARGANTUAN:
            return 12;
        case CREATURE_SIZE_COLOSSAL:
            return 16;
    }
    return 0;
}

void ACR_InitializePhysicalObject(object oObject) {
	effect eEffects;
    //int nHardness = GetHardness(oObject);
    //eEffects = EffectDamageResistance(DAMAGE_TYPE_ACID, nHardness);
    /*eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_ACID, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_COLD, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_DIVINE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_FIRE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_MAGICAL, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, nHardness) );
    eEffects = EffectLinkEffects(eEffects, EffectDamageResistance(DAMAGE_TYPE_SONIC, nHardness) );*/

    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 75) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 50) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 0) );
    //eEffects = EffectLinkEffects(eEffects, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 50) );
    eEffects = EffectLinkEffects(eEffects, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT) );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eEffects), oObject);
}

#endif
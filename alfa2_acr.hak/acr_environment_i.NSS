////////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_environment_i
//    $Revision:: 1          $ current version of the file
//        $Date:: 2012-07-18#$ date the file was created or modified
//       Author : FoamBats4All
//
//  Local Variable Prefix = ACR_ENVI
//
//  Description:
//    Provides functions related to environmental conditoins, such as weather
//    and temperature.
//
//    Note that these functions are related to areas and objects to manipulate
//    the environment. For environmental hazards, see acr_hazards_i.
//
//	Use:
//	  TEMPERATURE
//		To enable temperature on an area, trigger, or object, you must declare
//		a new local integer variable on that object, with ACR_TEMP_TYPE set
//		to 1.
//
//		With that variable set, you can also set the ACR_TEMP_CURRENT variable
//		to specify the temperature in that trigger or area. Specifying it on 
//		a creature or placeable will force their temperature, despite any
//		environmental conditions.
////////////////////////////////////////////////////////////////////////////////

#ifndef ACR_ENVIRONMENT_I
#define ACR_ENVIRONMENT_I

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_spells_i"

////////////////////////////////////////////////////////////////////////////////
// Constants ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Temperature types.
const string ACR_TEMP_TYPE = "ACR_TEMP_TYPE";
const int ACR_TEMP_TYPE_DISABLED = 0;
const int ACR_TEMP_TYPE_ENABLED = 1;

// Temperatures.
const string ACR_TEMP_CURRENT = "ACR_TEMP_CURRENT";
const float ACR_TEMP_INVALID = 999.9f;
const float ACR_TEMP_HOT_EXTREME = 140.0f;
const float ACR_TEMP_HOT_SEVERE = 110.0f;
const float ACR_TEMP_HOT = 90.0f;
const float ACR_TEMP_COLD = 40.0f;
const float ACR_TEMP_COLD_SEVERE = 0.0f;
const float ACR_TEMP_COLD_EXTREME = -20.0f;

////////////////////////////////////////////////////////////////////////////////
// Structures //////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Function Prototypes /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//! Return's an object temperature type. Currently, FALSE if there is no
//! temperature data, TRUE if there is.
int ACR_GetHasTemperature( object oObject );

//! Returns an object's temperature, or ACR_TEMPERATURE_INVALID if the object,
//! the triggers it rests in, and the area do not have temperatures specified.
//!  - oObject : Object to get the temperature for.
float ACR_GetCurrentTemperature( object oObject );

//! Returns TRUE if the creature can exist comfortably at a given temperature.
//! For now, we assume all creatures have the same biology.
//!  - oPC : Creature to check the temperature conditions of.
//!  - fTemperature : Temperature to check against.
int ACR_IsComfortableTemperature( object oPC, float fTemperature = ACR_TEMP_INVALID );

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PUBLIC ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

int ACR_GetHasTemperature( object oObject ) {
	return GetLocalInt( oObject, ACR_TEMP_TYPE );
}


float ACR_GetCurrentTemperature( object oObject ) {
	float fTemperature = ACR_TEMP_INVALID;
	
	// If the object has the temperature on it already, use that.
	if ( ACR_GetHasTemperature( oObject ) ) {
		fTemperature = GetLocalFloat( oObject, ACR_TEMP_CURRENT );
	} else {
		// Get the area the object is in.
		object oArea = GetArea( oObject );
		if ( !GetIsObjectValid( oArea ) ) return ACR_TEMP_INVALID;
		
		// Loop through triggers in the area.
		object oTrigger = GetFirstObjectInArea( oArea );
		while ( GetIsObjectValid( oTrigger ) ) {
			if ( GetObjectType( oTrigger ) == OBJECT_TYPE_TRIGGER && GetIsInSubArea( oObject, oTrigger ) ) {
				if ( ACR_GetHasTemperature( oTrigger ) ) fTemperature = GetLocalFloat( oTrigger, ACR_TEMP_CURRENT );
			}
			oTrigger = GetNextObjectInArea( oArea );
		}
		
		// If we still don't have a temperature, check the area itself.
		if ( fTemperature == ACR_TEMP_INVALID && ACR_GetHasTemperature( oArea ) ) {
			fTemperature = GetLocalFloat( oArea, ACR_TEMP_CURRENT );
		}
	}
	
	return fTemperature;
}


int ACR_IsComfortableTemperature( object oPC, float fTemperature = ACR_TEMP_INVALID ) {
	int bComfortable = TRUE;
	float fMinComfortableTemp = ACR_TEMP_COLD;
	float fMaxComfortableTemp = ACR_TEMP_HOT;
	
	// If we have endure elements active, we are comfortable in more conditions.
	if ( GetHasSpellEffect( SPELL_ENDURE_ELEMENTS, oPC ) ) {
		fMinComfortableTemp = -50.0f;
		fMinComfortableTemp = 140.0f;
	}
	
	// If the temperature was not provided, get their current temperature.
	if ( fTemperature == ACR_TEMP_INVALID ) fTemperature = ACR_GetCurrentTemperature( oPC );
	
	// If we couldn't get the temperature, we'll assume they're comfortable.
	if ( fTemperature == ACR_TEMP_INVALID ) return TRUE;
	
	// Finally, check.
	if ( fTemperature < fMinComfortableTemp ) bComfortable = FALSE;
	if ( fTemperature > fMaxComfortableTemp ) bComfortable = FALSE;
	return bComfortable;
}

////////////////////////////////////////////////////////////////////////////////
// Function Definitions : PRIVATE //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#endif
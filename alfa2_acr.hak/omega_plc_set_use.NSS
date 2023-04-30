/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : ga_plc_set_use.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Toggle the useable flag on a placeable
//  
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#include "acr_placeable_i"

void main() {
 
	object oUse = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_PLACEABLE);
	while(oUse != OBJECT_INVALID) {
		int nUseableFlag = GetUseableFlag(oUse);
		if(nUseableFlag == 0) {SetUseableFlag(oUse, 1);}
		else if(nUseableFlag == 1) {SetUseableFlag(oUse, 0);}
		oUse = GetNextObjectInShape(SHAPE_SPHERE, 5.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_PLACEABLE);
	}
}
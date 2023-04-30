/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_arcanemark.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-02-24 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Arcane Mark as per SRD.  Additionally, Arcane Mark cast on a Scrying Object
//  by a Sorceror or Wizard will call forth a scrying focus as part of the
//	ALFA Scrying System, but that is handled in the Scrying Object's on castat script.

//	When Arcane Mark is cast, it creates an invisible iPoint with a VFX. That iPoint
//	is found in the DetectMagic group of the Placeables pallet. It will persist 
//	past server reset. It will vanish with reset, but when Detect Magic
//	or Arcane Sight or Read Magic is cast upon its location, those spells will
//	recreate it in place and report its maker to the caster of those divinatory spells.
//  
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main()
{		
	if (!ACR_PrecastEvent())
    {
        return;
    }

	SignalEvent( GetSpellTargetObject(), EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
	object oCaster = OBJECT_SELF;
	//Did we click on an object to mark?
	object oMarked = GetSpellTargetObject();
	string sName = GetName(oMarked);
	location lMarked = GetLocation(oMarked);
	int nExpire = 0;
	//Or did we click on the floor to mark a location?
	if(oMarked == OBJECT_INVALID) {
		lMarked = GetSpellTargetLocation();
		//If we did click on the floor, then we're going to need a proxy oMarked to store our variables, so let's find one within arm's reach.
		oMarked = GetFirstObjectInShape(SHAPE_SPHERE, 2.5, lMarked, TRUE, OBJECT_TYPE_ALL); 
		sName = "This location";
		while(oMarked != OBJECT_INVALID) {
			//We only want objects that will always be there
			if((GetObjectType(oMarked) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oMarked) == OBJECT_TYPE_DOOR) ||  (GetObjectType(oMarked) == OBJECT_TYPE_TRIGGER) || (GetObjectType(oMarked) == OBJECT_TYPE_WAYPOINT)) {break;} 
			oMarked = GetNextObjectInShape(SHAPE_SPHERE, 2.5, lMarked, TRUE, OBJECT_TYPE_ALL); 
			}
		}
	//If we couldn't find a proxy near enough, we'll settle for using the area.
	if(oMarked == OBJECT_INVALID) {
		oMarked = GetArea(oCaster);
		}
	//If you *did* click on an object, and that object is a creature, then the mark will wear off in 30 days. Otherwise, it's permanent until Erased.
	if(GetObjectType(oMarked) == OBJECT_TYPE_CREATURE) {nExpire = 30;}
	//We'll allow up to four marks on any given objects, whether directly or as a proxy for a location.
	int nAM = 1;
	while (nAM < 5) {
		//You already marked this one, silly.
		if((ACR_GetPersistentString(oMarked, "ACR_ARCANEMARK" + IntToString(nAM)) == GetName(oCaster)) && (ACR_GetPersistentLocation(oMarked, "ACR_ARCANEMARKLoc" + IntToString(nAM)) == lMarked)) {
			SendMessageToPC(oCaster, sName + " already bears your arcane mark."); 
			return;
			}
		//But this one's good, so write the following info on it in permanent ink: 
		//1. Your name.
		//2. The object's location or -- if this is a proxy object -- the desired location.
		//Finally, create the visual representation. This will vanish with reset, but show up again under Detect Magic or Read Magic. 
		if(ACR_GetPersistentString(oMarked, "ACR_ARCANEMARK" + IntToString(nAM)) == "") {
			SendMessageToPC(oCaster, sName + " now bears your arcane mark."); 
			ACR_SetPersistentString(oMarked, "ACR_ARCANEMARK" + IntToString(nAM), GetName(oCaster), nExpire);
			ACR_SetPersistentLocation(oMarked, "ACR_ARCANEMARKLoc" + IntToString(nAM), lMarked, nExpire);
			object oMark = CreateObject(OBJECT_TYPE_PLACEABLE, "ipoint_arcane_mark", lMarked, TRUE);
			return;
			}
		nAM ++;
		}
			
	SendMessageToPC(oCaster, "This " + sName + " cannot hold any more arcane marks.");

	// Post-cast event.
	ACR_PostcastEvent();
	}				
/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_erase.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-02-24 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Erase as per SRD. Looks for Arcane Marks and Glyphs of Warding, checks to 
//	see if oTarget is a magic scroll, and removes its item properties if so.
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
	//Set Default oMarked, look for a possible unclickable Glyph of Warding plc and a possible Glyph of Warding AOE
	object oErase = GetSpellTargetObject();
	location lErase = GetLocation(oErase);
	object oGlyphPLC = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_PLACEABLE);
	while (oGlyphPLC != OBJECT_INVALID) {
		if(FindSubString(GetTag(oGlyphPLC), "glyph_ward") != -1) {break;}
		oGlyphPLC = GetNextObjectInShape(SHAPE_SPHERE, 5.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_PLACEABLE);
		}
	location lGlyphPLC = GetLocation(oGlyphPLC);
	float fGlyphPLC = GetDistanceBetweenLocations(GetSpellTargetLocation(), lGlyphPLC);
	object oGlyphAOE = GetFirstObjectInShape(SHAPE_SPHERE, 7.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	while (oGlyphAOE != OBJECT_INVALID) {
		if(GetAreaOfEffectSpellId(oGlyphAOE) == 549) {break;}
		oGlyphAOE = GetNextObjectInShape(SHAPE_SPHERE, 7.0, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
		}
	location lGlyphAOE = GetLocation(oGlyphAOE);
	float fGlyphAOE = GetDistanceBetweenLocations(GetSpellTargetLocation(), lGlyphAOE);
	if((oErase == OBJECT_INVALID) && (FindSubString(GetTag(oGlyphPLC), "glyph_ward") != -1) && (fGlyphPLC < 5.0)) {oErase = oGlyphPLC; lErase = lGlyphPLC;}
	else if((oErase == OBJECT_INVALID) && (GetAreaOfEffectSpellId(oGlyphAOE) == 549) && (fGlyphAOE < 7.0)) {oErase = oGlyphAOE; lErase = lGlyphAOE;}
		
	//Run a CL check to see if oErase is erased later in script. DC is always 15.
	int nCasterLevel = GetCasterLevel(oCaster); 
	int nCLRoll = d20(1);
	SendMessageToPC(oCaster, "Caster level check: " + IntToString(nCLRoll) + " + " + IntToString(nCasterLevel) + " = " + IntToString(nCLRoll + nCasterLevel) + " vs DC15");
	//oCaster failed their check.
	if(nCLRoll <= 2) {SendMessageToPC(oCaster, "A natural 1 or 2 is always a failure on erasing magical writing.");}
	if((nCasterLevel + nCLRoll < 15) || (nCLRoll <= 2)) {
		SendMessageToPC(oCaster, "Your Erase spell fails.");
		//oCaster failed on a Glyph of Warding. Oops. Boom.
		if((FindSubString(GetTag(oErase), "glyph_ward") != -1) || (GetAreaOfEffectSpellId(oGlyphAOE) == 549))  {
			SendMessageToPC(oCaster, "You activate a Glyph of Warding!");
			string sResRef = "";
			if(GetObjectType(oErase) == OBJECT_TYPE_AREA_OF_EFFECT) {sResRef = GetResRef(GetAreaOfEffectCreator(oErase));}
			else {sResRef = GetLocalString(oErase, "ACR_CASTER_RESREF");}
			effect eFreeze = EffectCutsceneImmobilize();
			effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY, FALSE);
			object oAOEProxy = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lErase);
			SetFirstName(oAOEProxy, "Glyph of");
			SetLastName(oAOEProxy, "Warding");
			ChangeToStandardFaction(oAOEProxy, STANDARD_FACTION_MERCHANT);
			SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oCaster);
			SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 50, oCaster);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oAOEProxy, HoursToSeconds(100));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oAOEProxy, HoursToSeconds(100));
			DelayCommand(1.0, AssignCommand(oAOEProxy, ActionCastSpellAtLocation(549, GetLocation(oCaster), METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));
			DestroyObject(oErase, 2.0);
			DestroyObject(oAOEProxy, 3.0);
			}
		return;
		}
	//oCaster passed their check. Hooray.	
	else {
		effect eErase = EffectVisualEffect(VFX_IMP_EVIL_HELP);
		
		//Magic scrolls that have been Erased are demagic-ified
		if((GetBaseItemType(oErase) == 54) || (GetBaseItemType(oErase) == 75) || (GetBaseItemType(oErase) == 105)) {
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eErase, lErase, 3.0);
			SendMessageToPC(oCaster, "Both magic and the writing that had encoded it fade from " + GetName(oErase) + ".");
			SetFirstName(oErase, "Erased Scroll");
			SetDescription(oErase, "This scroll has been erased.");
			itemproperty ipRemove = GetFirstItemProperty(oErase);
			while (GetIsItemPropertyValid(ipRemove)) {
				RemoveItemProperty(oErase, ipRemove);
					ipRemove = GetNextItemProperty(oErase);
				} 
			return;
			}
		
		//Is this a Glyph of Warding?
		if(((GetObjectType(oErase) == OBJECT_TYPE_PLACEABLE)  && (FindSubString(GetTag(oErase), "glyph_ward") != -1)) || ((GetObjectType(oErase) == OBJECT_TYPE_AREA_OF_EFFECT)  && (GetAreaOfEffectSpellId(oErase) == 549))) {
			SendMessageToPC(oCaster, "You successfully erase a Glyph of Warding.");
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eErase, lErase, 3.0);
			DestroyObject(oErase);
			return;
			}	
		
		//Looking for Arcane Marks now. Do any exist on objects within radius 5.0 of target location?
		if(oErase == OBJECT_INVALID) {
			lErase = GetSpellTargetLocation();
			oErase = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lErase, TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_WAYPOINT); 
			int nMarked = 0;
			while (oErase != OBJECT_INVALID) {
				 int nAM = 1;
				 while (nAM < 5) {
					if(ACR_GetPersistentString(oErase, "ACR_ARCANEMARK" + IntToString(nAM)) != "") {nMarked = 1; break;}
					nAM++;
					}
				if(nMarked == 1) {break;}
				oErase = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lErase, TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_WAYPOINT); 
				}
			}
		
		//If none of the objects within radius are Marked, then we check the area, as a proxy for Marks that were placed without an object within 5.0 of the location they were placed.	
		//This is a technical end-around for mechanical limitations.
		if(oErase == OBJECT_INVALID) {oErase = GetArea(oCaster);}
		
		if(oErase != OBJECT_INVALID)  {
			object oMark = GetNearestObjectByTag("ipoint_arcane_mark", oErase, 1);
			if(oErase == GetArea(oCaster)) {oMark = GetNearestObjectByTag("ipoint_arcane_mark", oCaster, 1);}
			int nAM = 1;
			int nErased = 0;
			//Do the actual erasing. Sometimes the (non-persistant) mark itself is actually a little bit away from the (persistant) proxy object storing its information.
			while (nAM < 5) {
				if(ACR_GetPersistentString(oErase, "ACR_ARCANEMARK" + IntToString(nAM)) != "") {
					lErase = ACR_GetPersistentLocation(oErase, "ACR_ARCANEMARKLoc" + IntToString(nAM));
					string sName = GetName(oErase);
					string sMarked = ACR_LocationToString(lErase);
					string sMarkedProxy = ACR_LocationToString(GetLocation(oErase));
					int nXStart = FindSubString(sMarked, "#X#", 0);
					string sXYMarked = GetSubString(sMarked, nXStart, 30);
					string sXYMarkedProxy = GetSubString(sMarkedProxy, nXStart, 30);
					
					if(sXYMarked != sXYMarkedProxy) {sName = "a location";}
					if((sXYMarked == sXYMarkedProxy) || ((sXYMarked != sXYMarkedProxy) && (GetSpellTargetObject() == OBJECT_INVALID))) { 
						ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eErase, lErase, 3.0);
						if(GetDistanceBetween(oMark, oErase) <= 2.5) {DestroyObject(oMark, 1.0);}
						else if((oErase == GetArea(oCaster)) && (GetDistanceBetween(oMark, oCaster) <= 2.5)){DestroyObject(oMark, 1.0);}
						SendMessageToPC(oCaster, "You have erased an Arcane Mark drawn on " + sName + ".");
						ACR_SetPersistentString(oErase, "ACR_ARCANEMARK" + IntToString(nAM), "", 0);
						ACR_SetPersistentLocation(oErase, "ACR_ARCANEMARKLoc" + IntToString(nAM), ACR_StringToLocation(""), 0);
						nErased++;
						}
					}
				nAM++;
				}
					
			//oCaster passed their check, but no Marks existed to be erased.
			if(nErased == 0) {SendMessageToPC(oCaster, "You found nothing to erase.");}
		}
	}
	// Post-cast event.
	ACR_PostcastEvent();
	}				
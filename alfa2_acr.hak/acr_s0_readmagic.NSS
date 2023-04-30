/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_readmagic.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Read Magic as per SRD. Reads and reveals Arcane Marks and Glyphs of Warding.
//
//
//////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void main() {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell.
	if ( !ACR_PrecastEvent() ) {
		return;
	}

	// Casting information.
	object oCaster = OBJECT_SELF;
	float fDuration = ACR_GetSpellDuration( oCaster, ACR_DURATION_TYPE_PER_CL, ACR_DURATION_10M );
	ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_SPELL_READ_MAGIC ), oCaster, fDuration);
	
	object oTarget = GetSpellTargetObject();
	object oReadMagic = GetFirstObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oTarget), TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_ITEM |OBJECT_TYPE_DOOR | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_WAYPOINT | OBJECT_TYPE_AREA_OF_EFFECT);
	int nMarked = 0;
	int nGlyph = 0;
	string sName;
	while(oReadMagic != OBJECT_INVALID) {
		sName = GetName(oReadMagic);
		//Read Magic: Glyph of Warding
		if(((GetObjectType(oReadMagic) == OBJECT_TYPE_PLACEABLE)  && (FindSubString(GetTag(oReadMagic), "glyph_ward") != -1)) || ((GetObjectType(oReadMagic) == OBJECT_TYPE_AREA_OF_EFFECT)  && (GetAreaOfEffectSpellId(oReadMagic) == 549))) {
			if(ACR_SkillCheck(SKILL_SPELLCRAFT, oCaster, 13, TRUE)) {
				object oGlyphCaster;
				if(GetObjectType(oReadMagic) == OBJECT_TYPE_AREA_OF_EFFECT) {oGlyphCaster = GetAreaOfEffectCreator(oReadMagic);}
				else {string sResRef = GetLocalString(oReadMagic, "ACR_CASTER_RESREF"); 
					oGlyphCaster = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oReadMagic));
					effect eFreeze = EffectCutsceneParalyze();
					effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY, FALSE);
					ChangeToStandardFaction(oGlyphCaster, STANDARD_FACTION_MERCHANT);
					SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oGlyphCaster);
					SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 50, oGlyphCaster);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oGlyphCaster, HoursToSeconds(100));
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oGlyphCaster, HoursToSeconds(100));
					DestroyObject(oGlyphCaster, 2.0);
					}	
				int nGlyphCasterLvl = GetLevelByClass(CLASS_TYPE_CLERIC, oGlyphCaster);
				if(nGlyphCasterLvl >= 10){nGlyphCasterLvl = 10;}
				int nDam = 8 * (nGlyphCasterLvl /2 );
				int nAlign = GetAlignmentGoodEvil(oGlyphCaster);
				string sAlignDmg = "Divine";
				if (nAlign == ALIGNMENT_GOOD) {sAlignDmg = "Divine";}
				else if (nAlign == ALIGNMENT_EVIL) {sAlignDmg = "Negative";}
				else {sAlignDmg = "Sonic";}
				if(GetObjectType(oReadMagic) == OBJECT_TYPE_AREA_OF_EFFECT) { sName = "A nearby location";}
				SendMessageToPC(oCaster, sName + " bears a Blasting Glyph of Warding that will do up to " + IntToString(nDam) + " points of " + sAlignDmg + " damage to anybody who disturbs it.");
				}
			else {SendMessageToPC(oCaster, sName + " has a glyph on it.");}
		}
		//Read Magic: Arcane Mark directly on an object or on the object as a proxy for a location
		int nRM = 0;
		while (nRM < 5) {
			nRM++;
			if(ACR_GetPersistentString(oReadMagic, "ACR_ARCANEMARK" + IntToString(nRM)) != "") {
				location lMarked = ACR_GetPersistentLocation(oReadMagic, "ACR_ARCANEMARKLoc" + IntToString(nRM));
				if(GetDistanceBetweenLocations(lMarked, GetLocation(oCaster)) < 5.0) {
					object oMark = GetFirstObjectInShape(SHAPE_SPHERE, 1.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
					while (oMark != OBJECT_INVALID) {
						if(GetTag(oMark) == "abr_plc_ipoint_arcane_mark") {nMarked = 1;}
						oMark = GetNextObjectInShape(SHAPE_SPHERE, 1.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
						}
					if(nMarked != 1) {CreateObject(OBJECT_TYPE_PLACEABLE, "abr_plc_ipoint_arcane_mark", lMarked, TRUE);}
					string sMarked = ACR_LocationToString(lMarked);
					string sMarkedProxy = ACR_LocationToString(GetLocation(oReadMagic));
					int nXStart = FindSubString(sMarked, "#X#", 0);
					string sXYMarked = GetSubString(sMarked, nXStart, 30);
					string sXYMarkedProxy = GetSubString(sMarkedProxy, nXStart, 30);
					if(sXYMarked != sXYMarkedProxy) {sName = "A nearby location";}
					SendMessageToPC(oCaster, sName + " bears an Arcane Mark which reads " + ACR_GetPersistentString(oReadMagic, "ACR_ARCANEMARK" + IntToString(nRM)));
					}
				}
			}
		if(oReadMagic != GetNextObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oTarget), TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_ITEM |OBJECT_TYPE_DOOR | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_WAYPOINT | OBJECT_TYPE_AREA_OF_EFFECT))
			{oReadMagic = GetNextObjectInShape(SHAPE_SPHERE, 6.0, GetLocation(oTarget), TRUE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_ITEM |OBJECT_TYPE_DOOR | OBJECT_TYPE_TRIGGER | OBJECT_TYPE_WAYPOINT | OBJECT_TYPE_AREA_OF_EFFECT);}
		else {break;}
		}
	
	//Read Magic: Arcane Mark on the area as a proxy for a location	
	 nMarked = 0;	
	 oReadMagic = GetArea(oCaster);
	 	
	 int nRM = 0;
	 while (nRM < 5) {
		nRM++;
		if(ACR_GetPersistentString(oReadMagic, "ACR_ARCANEMARK" + IntToString(nRM)) != "") {
			location lMarked = ACR_GetPersistentLocation(oReadMagic, "ACR_ARCANEMARKLoc" + IntToString(nRM));
			if(GetDistanceBetweenLocations(lMarked, GetLocation(oCaster)) < 5.0) {
				float fDistance = GetDistanceBetweenLocations(lMarked, GetLocation(oCaster));
				sName = "A nearby location";
				object oMark = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
				while (oMark != OBJECT_INVALID) {
					if(GetTag(oMark) == "abr_plc_ipoint_arcane_mark") {nMarked = 1;}
					oMark = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
					}
					
				if(nMarked != 1) {CreateObject(OBJECT_TYPE_PLACEABLE, "abr_plc_ipoint_arcane_mark", lMarked, TRUE);}
				SendMessageToPC(oCaster, sName + " bears an arcane mark that reads: " + ACR_GetPersistentString(oReadMagic, "ACR_ARCANEMARK" + IntToString(nRM)));
				}
			}
		}
	
	// Post-cast event.
	ACR_PostcastEvent();
}
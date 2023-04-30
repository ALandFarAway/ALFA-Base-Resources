/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_detectmagic.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-01-30 date the file was created or modified
//       Author : Wynna 

/*	Detect Magic
	
	A caster can detect the magical auras of objects within a spellcone. 
	The information learned is based on a Concentration Check for the Caster and individual Spellcraft Checks against every magical item in range.
	
	Concentration Check = Concentration Roll
	1 = Failure
	2-6 = 1 Round: There is magic within range.
	7-13 = 2 Rounds: The number of auras and the power of the strongest aura.
	14+ = 3 Rounds: The location of each aura and a Spellcraft Check against the magic item's power to determine the school of magic.
	
	Placeables, items, creatures, doors, waypoints and triggers may 
	have the following matched variable sets placed on them to report to Detect Magic:
	If you place a SpellSchool variable, you must also place its matching SpellPower
	variable. The SubSchool variable is optional. See below.
	
	Sample placeables may be found in the pallet in the _ALFA_Detect_Magic group.
	These placeables hold sample variables. Any placeable, item, creature, door,
	waypoint or trigger with any model, name, tag, ResRef, VFX may be used, 
	as long as it has the variables.
	  
	
	ACR_SPELLSCHOOL = 
	ACR_SPELLPOWER = 
	ACR_SUBSCHOOL = 
	
	ACR_SPELLSCHOOL2 =
	ACR_SPELLPOWER2 = 
	ACR_SUBSCHOOL2 = 
	
	ACR_SPELLSCHOOL3 =
	ACR_SPELLPOWER3 = 
	ACR_SUBSCHOOL3 = 
	
	School of Magic = Integer
	Abjuration = 1
	Conjuration = 2
	Divination = 3
	Enchantment = 4
	Evocation = 5
	Illusion = 6
	Necromancy = 7
	Transmutation = 8
	Universal = 9
	
	Power of Magic = Integer
	Faint = 1-3
	Moderate = 4-6
	Strong = 7-9
	Overwhelming = 10+
	
	SubSchool (optional) = string 
	This allows the builder to place any tag desired here. For instance, 
	if ACR_SPELLSCHOOL is Evocation, the builder may make ACR_SUBSCHOOL = Sonic or
	= Cold to give the caster a better hint. Or leave it blank, to provide no hints.
				
	*/
	
////////////////////////////////////////////////////////////////////////////////
// Includes ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#include "acr_skills_i"
#include "x2_inc_itemprop"
#include "x0_i0_position"
#include "acr_spells_i"


////////////////////////////////////////////////////////////////////////////////
// Function Definitions ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

string GetCompassDirectionOfBearing(float fDegrees)
{
    /* Takes a bearing from degrees (0.0 -> 360.0)
     * where 0.0 is North and 90.0 is West and
     * returns its corresponding compass direction
     */

    // Handle cases when the caller is lazy
    while (fDegrees < 0.0) {
        fDegrees += 360.0;
    }
    while (fDegrees > 360.0) {
        fDegrees -= 360.0;
    }
	int nDegrees = FloatToInt(fDegrees);
	string sDegrees = IntToString(nDegrees);
	 // Do the mapping
    if ((fDegrees > 22.5) && (fDegrees < 67.5)) {
        return "southwest";
    }
    else if ((fDegrees > 67.5) && (fDegrees < 112.5)) {
        return "west";
    }
   else if ((fDegrees > 112.5) && (fDegrees < 157.5)) {
        return "northwest";
    }
    else if ((fDegrees > 157.5) && (fDegrees < 202.5)) {
        return "north";
    }
    else if ((fDegrees > 202.5) && (fDegrees < 247.5)) {
        return "northeast";
    }
    else if ((fDegrees > 247.5) && (fDegrees < 292.5)) {
        return "east";
    }
    else if ((fDegrees > 292.5) && (fDegrees < 337.5)) {
        return "southeast";
    }
   
    else return "south";
}

string GetCompassDirectionOfAngle(float fAngle)
{
    /* Takes an angle from degrees (0.0 -> 360.0)
     * where 0.0 is the positive X-axis and 90.0
     * is the positive Y-axis and returns its
     * corresponding compass direction
     */
    return GetCompassDirectionOfBearing(-fAngle + 90.0);
}

void ActionCreatePlaceable(string sPlaceable, location lLocPlaceable)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sPlaceable, lLocPlaceable);
}

void main()
{		
		object oCaster = OBJECT_SELF;
		int nMetaMagic = GetMetaMagicFeat();
		float fDur = TurnsToSeconds( GetCasterLevel(oCaster ));
		if ( nMetaMagic == METAMAGIC_EXTEND ) {
			fDur = fDur * 2;
			} 
		else if ( nMetaMagic == METAMAGIC_PERSISTENT ) {
			fDur = HoursToSeconds( 24 );
			}
		//nConcentration determines how many rounds of information a PC Caster gets. 
		int nConcentration = ACR_SkillCheck(SKILL_CONCENTRATION, oCaster, 0, TRUE, FALSE, 0);
		string sRounds = " 1 round.";
		if(nConcentration > 6) {sRounds = " 2 rounds.";} 
		if(nConcentration > 13) {sRounds = " 3 rounds.";} 
		if(nConcentration - GetSkillRank(SKILL_CONCENTRATION, oCaster, FALSE)<= 1) {
			nConcentration = 1;
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(3.0, SendMessageToAllDMs(GetName(oCaster) + " cannot concentrate at all and learns nothing."));
				}
			DelayCommand(3.0, SendMessageToPC(oCaster, "You cannot concentrate at all and learn nothing."));
			return;		
			}
		if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
			SendMessageToAllDMs(GetName(oCaster) + "'s Concentration = " + IntToString(nConcentration) + " earns" + sRounds);
			}
		//Declare loop variables	
		int nAuraCount;
		int nCreatureCount;
		int nItemCounted;
		int nArcaneMark;
		//Begin looping through all objects in the spellcone
		object oDetected = GetFirstObjectInShape( SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_ALL );
		while (GetIsObjectValid(oDetected)) {
		SignalEvent( oDetected, EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );
		
		//Zero out variables common to all objects, for each valid oDetected loop iteration.
		string sAuraPower = "";
		int nAuraPower = 0;
		int nAuraPowerHigh = 0;
		string sAuraPowerHigh = "";
		string sAuraStrength = "";
		string sAuraStrength2 = "";
		string sAuraStrength3 = "";
		string sSchool = "";
		string sSchool2 = "";
		string sSchool3 = "";
		//Let's look at Creatures, Doors, Items, Placeables, Placed Effects, Waypoints, Area of Effect Objects 
			if((oDetected != oCaster) && ((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) || (GetObjectType(oDetected) == OBJECT_TYPE_DOOR)  || (GetObjectType(oDetected) == OBJECT_TYPE_ITEM) || (GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE)|| (GetObjectType(oDetected) == OBJECT_TYPE_PLACED_EFFECT) || (GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER) || (GetObjectType(oDetected) == OBJECT_TYPE_AREA_OF_EFFECT)  || (GetObjectType(oDetected) == OBJECT_TYPE_WAYPOINT))){
			
			//Distance and direction per detected object
			string sName = GetName(oDetected);
			float fDistance = GetDistanceBetween(oDetected, oCaster);
			int nDistance = FloatToInt(fDistance);
			string sDistance = IntToString(nDistance);
			float fAngle = GetAngleBetweenObjects(oDetected, oCaster);
			string sAngle = GetCompassDirectionOfAngle(fAngle);
			
			//Let's get Placed Effects out of the way. They can't have variables and have so few properties
			//to hook onto that we have to call out school and power by individual tag.
			if(GetObjectType(oDetected) == OBJECT_TYPE_PLACED_EFFECT) {
				if((FindSubString(GetTag(oDetected), "_containment") != -1) || (FindSubString(GetTag(oDetected), "_encase") != -1)  || (FindSubString(GetTag(oDetected), "_barrier") != -1) || (FindSubString(GetTag(oDetected), "_trap") != -1) || (FindSubString(GetTag(oDetected), "_imprison") != -1)){
						 nAuraCount++;
						 nAuraPower = 3;
						 sAuraStrength = "faint";
						 sName = "A containment field";
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=lightblue>Abjuration</color>";}
					}
				if(FindSubString(GetTag(oDetected), "force") != -1){
						 nAuraCount++;
						 nAuraPower = 5;
						 sAuraStrength = "moderate";
						 sName = "A wall of force";
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=red>Evocation</color>";}
					}	 
				if(FindSubString(GetTag(oDetected), "_ioun_") != -1){
						 nAuraCount++;
						 nAuraPower = 5;
						 sAuraStrength = "strong";
						 object oOwner = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, oDetected, 1);
						 string sOwner = GetName(oOwner) + "'s head";
						 if(GetDistanceBetween(oDetected, oOwner) > 2.0) {sOwner = "something";}
						 sName = "A gem spinning around " + sOwner;
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=orange>Transmutation</color>";}
					}	 
				if(FindSubString(GetTag(oDetected), "_elemental") != -1){
						 nAuraCount++;
						 nAuraPower = 5;
						 sAuraStrength = "moderate";
						 sName = "An elemental manifestation";
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=tan>Conjuration</color>";}
					}	 
				if(FindSubString(GetTag(oDetected), "_proj") != -1){
						 nAuraCount++;
						 nAuraPower = 3;
						 sAuraStrength = "faint";
						 sName = "An arcane symbol";
						 if(FindSubString(GetTag(oDetected), "_abj") != -1) {sSchool = " of <color=lightblue>Abjuration</color>";}
						 if(FindSubString(GetTag(oDetected), "_con") != -1) {sSchool = " of <color=tan>Conjuration</color>";}
						 if(FindSubString(GetTag(oDetected), "_div") != -1) {sSchool = " of <color=green>Divination</color>";}
						 if(FindSubString(GetTag(oDetected), "_enc") != -1) {sSchool = " of <color=magenta>Enchantment</color>";}
						 if(FindSubString(GetTag(oDetected), "_evo") != -1) {sSchool = " of <color=red>Evocation</color>";}
						 if(FindSubString(GetTag(oDetected), "_ill") != -1) {sSchool = " of <color=purple>Illusion</color>";}
						 if(FindSubString(GetTag(oDetected), "_nec") != -1) {sSchool = " of <color=white>Necromancy</color>";}
						 if(FindSubString(GetTag(oDetected), "_tra") != -1) {sSchool = " of <color=orange>Transmutation</color>";}
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE) == FALSE) {sSchool = "";}
						 }	 
				if((FindSubString(GetTag(oDetected), "_arcane_lamp_") != -1) ||(FindSubString(GetTag(oDetected), "gem_energy") != -1) ||(FindSubString(GetTag(oDetected), "_psychic_") != -1)|| (FindSubString(GetTag(oDetected), "_sparkle") != -1)){
						 nAuraCount++;
						 nAuraPower = 1;
						 sAuraStrength = "faint";
						 sName = "A light";
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=red>Evocation</color>";}
						}	 
				if(GetTag(oDetected) == "abr_afx_gem_energy_blue"){
						 nAuraCount++;
						 nAuraPower = 7;
						 sAuraStrength = "strong";
						 sName = "A teleport field";
						 if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=tan>Conjuration</color>";}
						}	 
				
				//Flag Round 1 Message 	
				SetLocalInt(oCaster, "nMessage1", 1);
					
				//Queue up report to caster if Round 3 achieved
				if((nConcentration > 13) && (nAuraPower > 0)) {
					if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
						DelayCommand(21.0, SendMessageToAllDMs( sName + " --" + GetTag(oDetected) +  "-- " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
						}
					DelayCommand(21.0, SendMessageToPC(oCaster, sName + " " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " aura" + sSchool));
					}
			}
				
			//Doors, Placeables, Triggers and Waypoints can carry variables that identify them as magical. 
			if((GetObjectType(oDetected) == OBJECT_TYPE_DOOR) || (GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER)|| (GetObjectType(oDetected) == OBJECT_TYPE_WAYPOINT)) {
				//Place up to two pairs of ACR_SPELLSCHOOL and ACR_SPELLPOWER integers onto any placeable to have it report school and power to caster. 
				//A third pair of variables reports with a different message structure, but can be used to represent "stored power" inside the other two schools, if you desire.
				//There are also subschools defined here. They are optional, to allow (for instance) Evocation (Sonic) to be discriminated from Evocation (Cold).
				if(GetLocalInt(oDetected, "ACR_SPELLSCHOOL") > 0) {
					nAuraCount++;
					int nACRSpellSchool = GetLocalInt(oDetected, "ACR_SPELLSCHOOL");
					string sACRSubSchool = GetLocalString(oDetected, "ACR_SUBSCHOOL");
					int nAuraPower = GetLocalInt(oDetected, "ACR_SPELLPOWER");
					int nACRSpellSchool2 = GetLocalInt(oDetected, "ACR_SPELLSCHOOL2");
					string sACRSubSchool2 = GetLocalString(oDetected, "ACR_SUBSCHOOL2");
					int nAuraPower2 = GetLocalInt(oDetected, "ACR_SPELLPOWER2");
					int nACRSpellSchool3 = GetLocalInt(oDetected, "ACR_SPELLSCHOOL3");
					string sACRSubSchool3 = GetLocalString(oDetected, "ACR_SUBSCHOOL3");
					int nAuraPower3 = GetLocalInt(oDetected, "ACR_SPELLPOWER3");
					
					if(nAuraPower > 0) {sAuraStrength = "a faint";}
					if(nAuraPower > 3) {sAuraStrength = "a moderate";}
					if(nAuraPower > 6) {sAuraStrength = "a strong";}
					if(nAuraPower > 9) {sAuraStrength = "an overwhelming";}
					if(nAuraPower2 > 0) {sAuraStrength2 = "a faint";}
					if(nAuraPower2 > 3) {sAuraStrength2 = "a moderate";}
					if(nAuraPower2 > 6) {sAuraStrength2 = "a strong";}
					if(nAuraPower2 > 9) {sAuraStrength2 = "an overwhelming";}
					if(nAuraPower3 > 0) {sAuraStrength3 = "a faint";}
					if(nAuraPower3 > 3) {sAuraStrength3 = "a moderate";}
					if(nAuraPower3 > 6) {sAuraStrength3 = "a strong";}
					if(nAuraPower3 > 9) {sAuraStrength3 = "an overwhelming";}
					if(nACRSpellSchool == 1) {sSchool = " of <color=lightblue>Abjuration </color>";}
					if(nACRSpellSchool == 2) {sSchool = " of <color=tan>Conjuration </color>";}
					if(nACRSpellSchool == 3) {sSchool = " of <color=green>Divination </color>";}
					if(nACRSpellSchool == 4) {sSchool = " of <color=magenta>Enchantment </color>";}
					if(nACRSpellSchool == 5) {sSchool = " of <color=red>Evocation </color>";}
					if(nACRSpellSchool == 6) {sSchool = " of <color=purple>Illusion </color>";}
					if(nACRSpellSchool == 7) {sSchool = " of <color=white>Necromancy </color>";}
					if(nACRSpellSchool == 8) {sSchool = " of <color=orange>Transmutation </color>";}
					if(nACRSpellSchool == 9) {sSchool = " of <color=#FFFF00>Universal arcanity</color>";}
					if(nACRSpellSchool2 == 1) {sSchool2 = " of <color=lightblue>Abjuration </color>";}
					if(nACRSpellSchool2 == 2) {sSchool2 = " of <color=tan>Conjuration </color>";}
					if(nACRSpellSchool2 == 3) {sSchool2 = " of <color=green>Divination </color>";}
					if(nACRSpellSchool2 == 4) {sSchool2 = " of <color=magenta>Enchantment </color>";}
					if(nACRSpellSchool2 == 5) {sSchool2 = " of <color=red>Evocation </color>";}
					if(nACRSpellSchool2 == 6) {sSchool2 = " of <color=purple>Illusion </color>";}
					if(nACRSpellSchool2 == 7) {sSchool2 = " of <color=white>Necromancy </color>";}
					if(nACRSpellSchool2 == 8) {sSchool2 = " of <color=orange>Transmutation </color>";}
					if(nACRSpellSchool2 == 9) {sSchool = " of <color=#FFFF00>Universal arcanity</color>";}
					if(nACRSpellSchool3 == 1) {sSchool3 = " of <color=lightblue>Abjuration </color>";}
					if(nACRSpellSchool3 == 2) {sSchool3 = " of <color=tan>Conjuration </color>";}
					if(nACRSpellSchool3 == 3) {sSchool3 = " of <color=green>Divination </color>";}
					if(nACRSpellSchool3 == 4) {sSchool3 = " of <color=magenta>Enchantment </color>";}
					if(nACRSpellSchool3 == 5) {sSchool3 = " of <color=red>Evocation </color>";}
					if(nACRSpellSchool3 == 6) {sSchool3 = " of <color=purple>Illusion </color>";}
					if(nACRSpellSchool3 == 7) {sSchool3 = " of <color=white>Necromancy </color>";}
					if(nACRSpellSchool3 == 8) {sSchool3 = " of <color=orange>Transmutation </color>";}
					if(nACRSpellSchool3 == 9) {sSchool3 = " of <color=#FFFF00>Universal arcanity</color>";}
					if(sACRSubSchool != "") {sSchool = sSchool + "(" + sACRSubSchool + ")";}
					if(sSchool2 != "") {sSchool2 = " and " + sAuraStrength2 + " aura " + sSchool2;}
					if(sACRSubSchool2 != "") {sSchool2 = sSchool2 + "(" + sACRSubSchool2 + ")";}
					if(sSchool3 != "") {sSchool3 = " inside that outer layer. Both surround " +sAuraStrength3 + " amount " + sSchool3;}
					if(sACRSubSchool3 != "") {sSchool3 = sSchool3 + "(" + sACRSubSchool3 + ")";}
					
					//Does the caster learn the school?
					if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE) == FALSE) {sSchool = "";}
					
					//Are any of the three pairs of variables the highest power aura encountered thus far? If so, store it.	
					nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
					if(nAuraPower > nAuraPowerHigh) {
						SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
						SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength);
						}
					nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
					if(nAuraPower2 > nAuraPowerHigh) {
						SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower2);
						SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength2);
						}
					nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
					if(nAuraPower3 > nAuraPowerHigh) {
						SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower3);
						SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength3);
						}
					
					//Flag Round 1 Message 	
					SetLocalInt(oCaster, "nMessage1", 1);
				
					//Queue up report to caster if Round 3 achieved
					if(nConcentration > 13) {
						if((GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER) || (GetObjectType(oDetected) == OBJECT_TYPE_WAYPOINT)) {sName = "Something";}
						if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
							DelayCommand(21.0, SendMessageToAllDMs(GetName(oDetected) + " --" +sName + "-- " + sDistance + "m to the " + sAngle + " has " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool + sSchool2 + sSchool3));
							}
						DelayCommand(21.0, SendMessageToPC(oCaster, sName + " " + sDistance + "m to the " + sAngle + " has " + sAuraStrength + " aura" + sSchool + sSchool2 + sSchool3));
						}
						
					//SpellSchools done. Zero out all variables because these variables can also be needed by any of the specific use cases below
					sSchool = "";
					sSchool2 = "";
					sSchool3 = ""; 
					sACRSubSchool = "";
					sACRSubSchool2 = "";
					sACRSubSchool3 = "";
					nAuraPower = 0;
					nAuraPower2 = 0;
					}
				}
		
			//Multi-type objects with standardized tags or variables
			if((GetObjectType(oDetected) == OBJECT_TYPE_DOOR) || (GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oDetected) == OBJECT_TYPE_ITEM) || (GetObjectType(oDetected) == OBJECT_TYPE_CREATURE)|| (GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER) || (GetObjectType(oDetected) == OBJECT_TYPE_WAYPOINT)) {
				//Arcane Mark
				int nMarked = 0;
				int nAM = 0;
				if(nArcaneMark != 1) {
					nArcaneMark = 1;
					object oMarked = GetArea(oCaster);
					while (nAM < 5) {
						nAM++;
						if(ACR_GetPersistentString(oMarked, "ACR_ARCANEMARK" + IntToString(nAM)) != "") {
							location lMarked = ACR_GetPersistentLocation(oMarked, "ACR_ARCANEMARKLoc" + IntToString(nAM));
							location lFacing = GetAheadLocation(oCaster, GetDistanceBetweenLocations(lMarked, GetLocation(oCaster)));
							float fDistanceFace = GetDistanceBetweenLocations(lMarked, lFacing);
							
							if(fDistanceFace < 5.0) {
								sName = "A nearby location";
								object oMark = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
								while (oMark != OBJECT_INVALID) {
									if(GetTag(oMark) == "abr_plc_ipoint_arcane_mark") {nMarked = 1;}
									if(oMark != GetNextObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE)) {
										oMark = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
										}
									else {break;}
									}
								if(nMarked != 1) {DelayCommand(6.0, ActionCreatePlaceable("abr_plc_ipoint_arcane_mark", lMarked));}
			
								nAuraCount++;
								nAuraPower = 1;
								sAuraStrength = "faint";
								if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=#FFFF00>Universal arcanity</color>";}
									
								//Flag Round 1 Message 	
								SetLocalInt(oCaster, "nMessage1", 1);
								
								//Queue up report to caster if Round 3 achieved
								if(nConcentration > 13) {
									if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
										DelayCommand(21.0, SendMessageToAllDMs(sName + " --" +sName + " has an arcane mark that glows with a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
										}
									DelayCommand(21.0, SendMessageToPC(oCaster, sName + " has an arcane mark that glows with a " + sAuraStrength + " aura" + sSchool));
									}
								}
							}
						}
					}
					
				nMarked = 0;
				nAM = 0;
				while (nAM < 5) {
					nAM++;
					if(ACR_GetPersistentString(oDetected, "ACR_ARCANEMARK" + IntToString(nAM)) != "") {
						location lMarked = ACR_GetPersistentLocation(oDetected, "ACR_ARCANEMARKLoc" + IntToString(nAM));
						string sMarked = ACR_LocationToString(lMarked);
						string sMarkedProxy = ACR_LocationToString(GetLocation(oDetected));
						int nXStart = FindSubString(sMarked, "#X#", 0);
						string sXYMarked = GetSubString(sMarked, nXStart, 30);
						string sXYMarkedProxy = GetSubString(sMarkedProxy, nXStart, 30);
						sName = GetName(oDetected);
						if(sXYMarked != sXYMarkedProxy) {sName = "A nearby location";}
						object oMark = GetFirstObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
						while (oMark != OBJECT_INVALID) {
						SendMessageToAllDMs("DM" + IntToString(nAM) + " oDetected = " + GetTag(oDetected) + "; oMark = " + GetTag(oMark));
				    		if(GetTag(oMark) == "abr_plc_ipoint_arcane_mark") {nMarked = 1;}
							if(oMark != GetNextObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE)) {
								oMark = GetNextObjectInShape(SHAPE_SPHERE, 3.0, lMarked, TRUE, OBJECT_TYPE_PLACEABLE);
								}
							else {break;}
							}
							
						if(nMarked != 1) {DelayCommand(6.0, ActionCreatePlaceable("abr_plc_ipoint_arcane_mark", lMarked));}
			
						nAuraCount++;
						nAuraPower = 1;
						sAuraStrength = "faint";
						if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=#FFFF00>Universal arcanity</color>";}
							
						//Flag Round 1 Message 	
						SetLocalInt(oCaster, "nMessage1", 1);
						
						//Queue up report to caster if Round 3 achieved
						if(nConcentration > 13) {
							if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
								DelayCommand(21.0, SendMessageToAllDMs(sName + " has an arcane mark that glows with a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
								}
							DelayCommand(21.0, SendMessageToPC(oCaster, sName + " has an arcane mark that glows with a " + sAuraStrength + " aura" + sSchool));
							}
						}
					}
				}
			
		//Detect Magic: Glyph of Warding AOE
		if(GetObjectType(oDetected) == OBJECT_TYPE_AREA_OF_EFFECT) {
			if(GetAreaOfEffectSpellId(oDetected) == 549) {
				nAuraCount++;
				nAuraPower = 3;
				sAuraStrength = "faint";
				if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=lightblue>Abjuration</color>";}
										
				//Flag Round 1 Message 	
				SetLocalInt(oCaster, "nMessage1", 1);
									
				//Queue up report to caster if Round 3 achieved
				if(nConcentration > 13) {
					if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
						DelayCommand(21.0, SendMessageToAllDMs("A nearby location has a glyph that glows with a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
						}
					DelayCommand(21.0, SendMessageToPC(oCaster, "A nearby location has a glyph that glows with a " + sAuraStrength + " aura" + sSchool));
					}
				}
			}
			
		//Detect Magic: Glyph of Warding Placeable
		if(GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) {
			if(FindSubString(GetTag(oDetected), "glyph_ward") != -1) {
				nAuraCount++;
				nAuraPower = 3;
				sAuraStrength = "faint";
				if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=lightblue>Abjuration</color>";}
										
				//Flag Round 1 Message 	
				SetLocalInt(oCaster, "nMessage1", 1);
									
				//Queue up report to caster if Round 3 achieved
				if(nConcentration > 13) {
					if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
						DelayCommand(21.0, SendMessageToAllDMs("A nearby glyph glows with a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
						}
					DelayCommand(21.0, SendMessageToPC(oCaster, "A nearby glyph glows with a " + sAuraStrength + " aura" + sSchool));
					}
				}
			}
				
			//Portals
			if((GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER)) {
				//If they are tagged as per the line below, DM is automatic for them and they will register as Strong Conjuration.
				 if(FindSubString(GetTag(oDetected), "_portal")!= -1) {
				    nAuraCount++;
					nAuraPower = 7;
					sAuraStrength = "strong";
					if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=tan>Conjuration</color>";}
					
					//Flag Round 1 Message 	
					SetLocalInt(oCaster, "nMessage1", 1);
				
					//Queue up report to caster if Round 3 achieved
					if(nConcentration > 13) {
						if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
							DelayCommand(21.0, SendMessageToAllDMs(GetName(oDetected) + " --" +sName + "-- " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
							}
						DelayCommand(21.0, SendMessageToPC(oCaster, sName + " " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " aura" + sSchool));
						}
					}
				
				//Symbol traps after they've fired, and the triggers that fire them.
				//If they are tagged correctly as below, DM is automatic for them. They will report as follows:
				/*
				Symbol of Pain = Moderate Necromancy
				Symbol of Sleep = Moderate Enchantment
				Symbol of Fear = Moderate Necromancy
				Symbol of Persuasion = Moderate Enchantment
				Symbol of Weakness = Strong Necromancy
				Symbol of Stunning = Strong Enchantment
				Symbol of Death = Strong Necromancy
				Symbol of Insanity = Strong Enchantment
				*/
				
				 if(((FindSubString(GetTag(oDetected), "_symbol_") != -1)) && (FindSubString(GetTag(oDetected), "_det") == -1) && (GetLocalInt(oDetected, "Fired") != 1)) {
					nAuraCount++;
					if((FindSubString(GetTag(oDetected), "_symbol_fear") != -1) || (FindSubString(GetTag(oDetected), "_symbol_pers") != -1) || (FindSubString(GetTag(oDetected), "_symbol_sleep") != -1) || (FindSubString(GetTag(oDetected), "_symbol_stun") != -1)) {sSchool = " of <color=magenta>Enchantment</color>";}
					if((FindSubString(GetTag(oDetected), "_symbol_weakness") != -1) || (FindSubString(GetTag(oDetected), "_symbol_pain") != -1) || (FindSubString(GetTag(oDetected), "_symbol_death") != -1)) {sSchool = " of <color=white>Necromancy</color>";}
					if((FindSubString(GetTag(oDetected), "_symbol_pain") != -1) || (FindSubString(GetTag(oDetected), "_symbol_sleep") != -1)) {nAuraPower = 5;}
					if((FindSubString(GetTag(oDetected), "_symbol_pers") != -1) || (FindSubString(GetTag(oDetected), "_symbol_fear") != -1)) {nAuraPower = 6;}
					if((FindSubString(GetTag(oDetected), "_symbol_stun") != -1) || (FindSubString(GetTag(oDetected), "_symbol_weakness") != -1)) {nAuraPower = 7;}
					if((FindSubString(GetTag(oDetected), "_symbol_insanity") != -1) || (FindSubString(GetTag(oDetected), "_symbol_death") != -1)) {nAuraPower = 8;}
					if(nAuraPower > 0) {sAuraStrength = "faint";}
					if(nAuraPower > 3) {sAuraStrength = "moderate";}
					if(nAuraPower > 6) {sAuraStrength = "strong";}
					if(nAuraPower > 9) {sAuraStrength = "overwhelming";}
					
					//Does the caster learn the school?
					if(!GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)){sSchool = "";}
					
					//Flag Round 1 Message 	
					SetLocalInt(oCaster, "nMessage1", 1);
				
					//Queue up report to caster if Round 3 achieved
					string sSymbolName = GetName(oDetected);	
					if(GetObjectType(oDetected) == OBJECT_TYPE_TRIGGER) {sSymbolName = "Something";}		
					if(nConcentration > 13) {
						if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
							DelayCommand(21.0, SendMessageToAllDMs(sSymbolName + " --" + GetName(oDetected) + "-- centered on a spot " + sDistance + "m " + sAngle + " of " + GetName(oCaster) + " gives off a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura " + sSchool));
						}
						DelayCommand(21.0, SendMessageToPC(oCaster, sSymbolName + " centered on a spot " + sDistance + "m " + sAngle + " of " + GetName(oCaster) + " gives off a " + sAuraStrength + " aura " + sSchool));
						}
					}
				}	
						
			//Walls of Force tagged or named with "Forcefield" will register automatically as Moderate Evocation
			if((FindSubString(GetName(oDetected), "Forcefield") != -1) || (FindSubString(GetTag(oDetected), "forcefield") != -1)){
				nAuraCount++;
				nAuraPower = 5;
				sAuraStrength = "moderate";
					
				//Does the caster learn the school?
				if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of <color=red>Evocation</color>";}
					
				//Flag Round 1 Message 	
				SetLocalInt(oCaster, "nMessage1", 1);
				
				//Queue up report to caster if Round 3 achieved
				if(nConcentration > 13) {
					if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
						DelayCommand(21.0, SendMessageToAllDMs(GetName(oDetected) + " --" +sName + "-- " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
						}
					DelayCommand(21.0, SendMessageToPC(oCaster, sName + " " + sDistance + "m to the " + sAngle + " has a " + sAuraStrength + " aura" + sSchool));
					}
				}
					
			//Specific Waypoint use cases include traps 		
			if(GetObjectType(oDetected) == OBJECT_TYPE_WAYPOINT)  {
				//Traps, if placed, already have the ACR_TRAP_SPELL_ID on them. If spawned, they do not.
				//To have a spawning trap report to the caster, put the ACR_TRAP_SPELL_ID spell integer onto the spawnpoint itself.
				if(GetLocalInt(oDetected, "ACR_TRAP_SPELL_ID") > 0) {
					nAuraCount++;
					int nSpellID = GetLocalInt(oDetected, "ACR_TRAP_SPELL_ID");
					//Pull the spell school from the spells 2DA for the ACR_TRAP_SPELL_ID spell integer.
					sSchool = Get2DAString("spells", "School", nSpellID);
					if(sSchool == "A") {sSchool = " of <color=lightblue>Abjuration</color>";}
					if(sSchool == "C") {sSchool = " of <color=tan>Conjuration</color>";}
					if(sSchool == "D") {sSchool = " of <color=green>Divination</color>";}
					if(sSchool == "E") {sSchool = " of <color=magenta>Enchantment</color>";}
					if(sSchool == "H") {sSchool = " of <color=white>Holy</color>";}
					if(sSchool == "I") {sSchool = " of <color=purple>Illusion</color>";}
					if(sSchool == "N") {sSchool = " of <color=white>Necromancy</color>";}
					if(sSchool == "T") {sSchool = " of <color=orange>Transmutation</color>";}
					if(sSchool == "V") {sSchool = " of <color=red>Evocation</color>";}
					if(sSchool == "G") {sSchool = " of <color=#FFFF00>Universal arcanity</color>";}
					//Pull the spell level from the spells 2DA.
					sAuraPower = Get2DAString("spells", "Innate", nSpellID);
					nAuraPower = StringToInt(sAuraPower);
					sAuraStrength = "an indeterminately powerful";
					if(nAuraPower > 0) {sAuraStrength = "a faint";}
					if(nAuraPower > 3) {sAuraStrength = "a moderate";}
					if(nAuraPower > 6) {sAuraStrength = "a strong";}
					if(nAuraPower > 9) {sAuraStrength = "an overwhelming";}
					
					//Does the caster learn the school?		
					if(!GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)){sSchool = "";}
					
					//Flag Round 1 Message 	
					SetLocalInt(oCaster, "nMessage1", 1);
													
					//Check for trap origin and distance and direction from Origin to trap
					object oOrigin = GetNearestObjectByTag("TRAP_ORIGIN", oDetected, 1);
					float fDistance = GetDistanceBetween(oCaster, oOrigin);
					int nDistance = FloatToInt(fDistance);
					float fAngle = GetAngleBetweenObjects(oCaster, oOrigin);
					string sAngle = GetCompassDirectionOfAngle(fAngle);
					string sDistance = ", " + IntToString(nDistance) + "m " + sAngle + ",";
					float fSeparate = GetDistanceBetween(oDetected, oOrigin);
					int nSeparate = FloatToInt(fSeparate);
					string sSeparate = IntToString(nSeparate);
					float fAngleSeparate = GetAngleBetweenObjects(oDetected, oOrigin);
					string sAngleSeparate = GetCompassDirectionOfAngle(fAngleSeparate);
					string sSeparated = " and a circle centered on a spot " + sSeparate + "m " + sAngleSeparate + " of " + GetName(oOrigin);
					if(nDistance = 0) {sSeparated = "";}
					
					//If there is a valid Origin placeable and the caster earned a Round 3, queue up the report.
					if((nConcentration > 13) && (oOrigin != OBJECT_INVALID)) {
						if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
							DelayCommand(21.0, SendMessageToAllDMs("Trap origin --" + GetName(oOrigin) + sSeparated + " gives off " + sAuraStrength + " --" + IntToString(nAuraPower) + "--  aura" + sSchool));
							}
						DelayCommand(21.0, SendMessageToPC(oCaster, GetName(oOrigin) + sDistance + sSeparated + " gives off " + sAuraStrength + " aura" + sSchool));
						}
					}
				}
					
				//Creatures are the most complicated use case. Creatures can have innate magic, and effects, and inventory.
				if((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) && (GetIsDM(oDetected) == FALSE)) {
					int nRace = GetRacialType(oDetected);
					//Certain races have a lingering magic about them because of their nature, or how they were created/summoned
					string sRace = "";
					if(nRace == 10) {sRace = "Construct"; sSchool = "<color=orange> Transmutation</color>";}
					if(nRace == 16) {sRace = "Elemental"; sSchool = "<color=tan> Conjuration</color>";}
					if(nRace == 17) {sRace = "Fey";  sSchool = "<color=magenta> Enchantment</color>";}
					if(nRace == 19) {sRace = "Magical Beast"; sSchool = "<color=#D3D3D3> Innate Magic</color>";}
					if(nRace == 20) {sRace = "Outsider"; sSchool = "<color=tan> Conjuration</color>";}
					if(nRace == 23) {sRace = "Shapechanger"; sSchool = "<color=orange> Transmutation</color>";}
					if(nRace == 24) {sRace = "Undead"; sSchool = "<color=white> Necromancy</color>";}
					//Scrying sensors are creatures. They spawn invisible, but when detected, become visible.
					if(FindSubString(GetTag(oDetected), "abr_cr_scry_sen") != -1) {sName = "A scrying sensor"; sRace = "Scrying Sensor"; sSchool = "<color=green>Divination</color>";
						effect eEffect = GetFirstEffect(oDetected);
						int nRep = 0;
						int nInvis = 0;
						while ((GetIsEffectValid(eEffect)) && (nRep < 10)) { 
							 if(GetEffectType(eEffect) == 56) {sName = "Something"; SetLocalInt(oDetected, "nInvis", 1);}
							 nInvis = GetLocalInt(oDetected, "nInvis");
							 eEffect = GetNextEffect(oDetected);
							 nRep ++;
							}
						} 
						
					//Does the caster learn the school?	
					if(GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)) {sSchool = " of " + sSchool;}
					
					//Sometimes creatures are invisible, in which case we don't want their name being bandied about willy-nilly.
					if((GetHasSpellEffect(SPELL_INVISIBILITY, oDetected)) || (GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oDetected)) || (GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oDetected))  || (GetHasSpellEffect(SPELL_MASS_INVISIBILITY, oDetected))) {sName = "Something"; SetLocalInt(oDetected, "nInvis", 1);int nInvis = GetLocalInt(oDetected, "nInvis");}  
					
					//If the critter is innately magical, let's define its power as one half its CR, to fit within the base 10 scale.
					if(sRace != ""){
						nAuraCount++;
						float fAuraPower = GetChallengeRating(oDetected);
						nAuraPower = FloatToInt(fAuraPower)/2;
						if(nAuraPower > 0) {sAuraStrength = "a faint";}
						if(nAuraPower > 3) {sAuraStrength = "a moderate";}
						if(nAuraPower > 6) {sAuraStrength = "a strong";}
						if(nAuraPower > 9) {sAuraStrength = "an overwhelming";}
						
						//Flag Round 1 Message 	
						SetLocalInt(oCaster, "nMessage1", 1);
				
						//Queue up report to caster if Round 3 achieved
						if(nConcentration > 13) {
							if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
								DelayCommand(21.0, SendMessageToAllDMs(sName + " has a " + sAuraStrength + " lingering aura of " + sSchool));
								}
							DelayCommand(21.1, SendMessageToPC(oCaster, sName + " has a " + sAuraStrength + " lingering aura" + sSchool));
							}
						}
					
					//Start looping through effects and cross-referencing their spell, school, and power from the 2da by the Effect Spell ID
					effect eEffect = GetFirstEffect(oDetected);
					int nEffect = 0; 
					string sEffect = "";
					string sEffectSchool = "";
					string sEffectStrength = "";
					int nEffectSchool = 0;
					int nEffectCount = 0;
					int nEffectSpell = 0;
					int nEffectSchoolHigh = 0;
					while (GetIsEffectValid(eEffect)) {
						//Invisibility is sometimes not a spell effect but should always be one, so force it.
						if(GetEffectType(eEffect) == 56) {
							nEffectCount++; 
							nAuraCount++; 
							SetLocalString(oDetected, "sEffectStrength_I", "a moderate"); 
							SetLocalInt(oDetected, "nEffectSchoolHigh_I", 4); 
							SetLocalString(oDetected, "sEffectSpell_I" , GetLocalString(oDetected, "sEffectSpell_I") + ", Invisibility" );
							SetLocalInt(oDetected, "nInvis", 1);
							}
						nEffect = GetEffectSpellId(eEffect); 
						//If this is a valid spell aura, increment auras and effects in total as well as auras by school on this creature
						if(nEffect != -1) {
							sEffect = Get2DAString("spells", "Label", nEffect);
							//Weed out spell duplicates because effects report multiple times without this
							if(GetLocalString(oDetected, "sEffect_" + sEffect) != sEffect) {
								SetLocalString(oDetected, "sEffect_" + sEffect, sEffect);
								nAuraCount++;
								nEffectCount++;
								sEffectSchool = Get2DAString("spells", "School", nEffect);
								sAuraPower = Get2DAString("spells", "Innate", nEffect);
								nAuraPower = StringToInt(sAuraPower);
								if(nAuraPower > 0) {sEffectStrength = "a faint";}
								if(nAuraPower > 3) {sEffectStrength = "a moderate";}
								if(nAuraPower > 6) {sEffectStrength = "a strong";}
								if(nAuraPower > 9) {sEffectStrength = "an overwhelming";}
									
								//Store highest aura, total and by school
								nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
								if(nAuraPower > nAuraPowerHigh) {
									SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
									SetLocalString(oCaster, "sAuraPowerHigh", sEffectStrength);
									}
								nEffectSchoolHigh = GetLocalInt(oDetected, "nEffectSchoolHigh_" + sEffectSchool);
								if(nAuraPower > nEffectSchoolHigh) {
									SetLocalInt(oDetected, "nEffectSchoolHigh_" + sEffectSchool, nAuraPower);
									SetLocalString(oDetected, "sEffectStrength_" + sEffectSchool, sEffectStrength);
									}
									
								//Keep track of all active spells by school for DM information, just because we can	
								SetLocalString(oDetected, "sEffectSpell_" + sEffectSchool, GetLocalString(oDetected, "sEffectSpell_" + sEffectSchool) + ", " + sEffect);
										
								//Flag Round 1 Message 	
								SetLocalInt(oCaster, "nMessage1", 1);
								
								//Queue up headers for report to caster if first effect and Round 3 achieved.
								if((nConcentration > 13) && (nEffectCount == 1) && (GetLocalInt(oDetected, "nInvis")== 0)) {
									if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
										DelayCommand(23.5, SendMessageToAllDMs("**********"));
										DelayCommand(23.6, SendMessageToAllDMs("FUNCTIONING SPELLS: " + GetName(oDetected) + " --" + sName ));
										}
									DelayCommand(23.5, SendMessageToPC(oCaster, "**********"));
									DelayCommand(23.6, SendMessageToPC(oCaster, "FUNCTIONING SPELLS: " + sName));
									}
								}
							}
						eEffect = GetNextEffect(oDetected);
						}	
								
						int nInvis = GetLocalInt(oDetected, "nInvis");
						string sColor = "<color=#666666>";
						if(nInvis == 1) {sColor = "<color=#FFFF00>";sName = "Something "  + IntToString(FloatToInt(GetDistanceBetween(oCaster, oDetected))) + "m to the " + sAngle;}
						
						//Queue up report to caster if Round 3 achieved
						if(nConcentration > 13) {
							float fSummaryDelay = 24.5;
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_A") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_A") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=lightblue>Abjuration </color> --" + GetLocalString(oDetected, "sEffectSpell_A")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_C") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_C") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=tan>Conjuration </color> --" + GetLocalString(oDetected, "sEffectSpell_C")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_D") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_D") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=green>Divination </color> --" + GetLocalString(oDetected, "sEffectSpell_D")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_E") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_E") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=magenta>Enchantment </color> --" + GetLocalString(oDetected, "sEffectSpell_E")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_V") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_V") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=red>Evocation </color> --" + GetLocalString(oDetected, "sEffectSpell_V")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_I") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_I") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=purple>Illusion </color> --" + GetLocalString(oDetected, "sEffectSpell_I")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_N") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_N") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=white>Necromancy </color> --" + GetLocalString(oDetected, "sEffectSpell_N")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_T") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_T") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=orange>Transmutation </color> --" + GetLocalString(oDetected, "sEffectSpell_T")));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_G") > 0) {DelayCommand(fSummaryDelay, SendMessageToAllDMs(GetName(oDetected) + sColor + " --" + sName + "-- has " + GetLocalString(oDetected, "sEffectStrength_G") + " --" + IntToString(nAuraPower) + "</color>-- aura of <color=yellow>Universal arcanity </color> --" + GetLocalString(oDetected, "sEffectSpell_G")));}
								
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_A") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_A")  + "</color> aura of <color=lightblue>Abjuration </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_C") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_C")  + "</color> aura of <color=tan>Conjuration </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_D") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_D")  + "</color> aura of <color=green>Divination </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_E") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_E")  + "</color> aura of <color=magenta>Enchantment </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_V") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_V")  + "</color> aura of <color=red>Evocation </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_I") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_I")  + "</color> aura of <color=purple>Illusion </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_N") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_N")  + "</color> aura of <color=white>Necromancy </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_T") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_T")  + "</color> aura of <color=orange>Transmutation </color>"));}
							if(GetLocalInt(oDetected, "nEffectSchoolHigh_G") > 0) {DelayCommand(fSummaryDelay, SendMessageToPC(oCaster, sColor + sName + " has " + GetLocalString(oDetected, "sEffectStrength_G")  + "</color> aura of <color=yellow>Universal arcanity </color>"));}
							}	
					}
				
				//Zero out effect specific variables.
				SetLocalInt(oDetected, "nEffectSchoolHigh_A", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_C", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_D", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_E", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_V", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_I", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_N", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_T", 0);
				SetLocalInt(oDetected, "nEffectSchoolHigh_G", 0);
					
				nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
				if(nAuraPower > nAuraPowerHigh) {
					SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
					SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength);
					}
				
				//Creature race and effects done.
				//Zero out variables needed for this creature's items, which are about to be determined.
				sSchool = "";
				nAuraPower = 0;
				
				//Begin items, in creature or placeable inventory, or loose.	
				//Declare item variables
				object oItem;
				int nSlot;
				string sSlot;
				
				//Placeables and creatures can have items, and items can also be found outside of inventories. We have to deal with all of that.
				if(((GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) && (GetHasInventory(oDetected))) || ((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) && (GetIsDM(oDetected) == FALSE)) || (GetObjectType(oDetected) == OBJECT_TYPE_ITEM)){
					//We're going to check every slot in a creature, and every inventory slot in a creature or placeable.
					//If oDetected is a loose item, on the other hand, we don't need slots or inventory, so set the upcoming loop to its last iteration.
					if(GetObjectType(oDetected) == OBJECT_TYPE_ITEM) {oItem = oDetected; nSlot = 14; sSlot = IntToString(FloatToInt(GetDistanceBetween(oCaster, oDetected))) + "m to the " + sAngle;}
						else {oItem = GetFirstItemInInventory(oDetected);}
						//Zero out the schools of magic counts before item loops.
						int nFirst = 0;
						int nGen = 0;
						int nAbj = 0;
						int nCon = 0;
						int nDiv = 0;
						int nEnc = 0;
						int nEvo = 0;
						int nIll = 0;
						int nNec = 0;
						int nTra = 0;
						int nSomething = 0;
						//Loop through inventory slots, starting with equipped items. If a placeable, just loop through inventory.
						while (nSlot < 15) {
							if(GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) {nSlot = 14;}		
							if((nFirst == 0) && (GetObjectType(oDetected) == OBJECT_TYPE_CREATURE)) {nCreatureCount++;nFirst = 1; sSlot = "in the inventory of " + GetName(oDetected);}
							else if (nSlot < 14) {
								oItem = GetItemInSlot(nSlot, oDetected); 
								if(nSlot == 0) {sSlot = "on the head of";}
								if(nSlot == 1) {sSlot = "worn by";}
								if(nSlot == 2) {sSlot = "on the feet of";}
								if(nSlot == 3) {sSlot = "on the arms of";}
								if(nSlot == 4) {sSlot = "in the right hand of";}
								if(nSlot == 5) {sSlot = "in the left hand of";}
								if(nSlot == 6) {sSlot = "on the back of";}
								if(nSlot == 7) {sSlot = "on a finger on the left hand of";}
								if(nSlot == 8) {sSlot = "on a finger on the right hand of";}
								if(nSlot == 9) {sSlot = "around the neck of";}
								if(nSlot == 10) {sSlot = "around the waist of";}
								if(nSlot == 11) {sSlot = "in the quiver of";}
								if(nSlot == 12) {sSlot = "carried by";}
								if(nSlot == 13) {sSlot = "in the quiver of";}
								sSlot = sSlot + " " + GetName(oDetected);
								nSlot++;
								}
							else if(GetObjectType(oDetected) != OBJECT_TYPE_ITEM) {
								oItem = GetNextItemInInventory(oDetected); 
								if(oItem == OBJECT_INVALID) {nSlot++;}
								else {sSlot = "in the inventory of " + GetName(oDetected);}
								}
							
							//First, check the item for SpellSchool variables. 	
							//If found, assign a temporary item property that gives it a ticket into the item property loop below. 
							if((GetLocalInt(oItem, "ACR_SPELLSCHOOL") > 0)|| (GetLocalInt(oItem, "ACR_SPELLSCHOOL2") > 0) || (GetLocalInt(oItem, "ACR_SPELLSCHOOL3") > 0)) { 
								int nSpell = IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY;
								int nNumberUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
								itemproperty ipSpellSchool = ItemPropertyCastSpell(nSpell, nNumberUses);
								IPSafeAddItemProperty(oItem, ipSpellSchool, 5.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
								SetLocalInt(oItem, "ACR_SPELLADDED", 1);
								}
																						
							itemproperty ipItem = GetFirstItemProperty(oItem);
							//Exclude creature items
							if(((GetBaseItemType(oItem) < 69) || (GetBaseItemType(oItem) > 73))
							//Exclude items with OOC or non-magical item properties
							&& ((GetIsItemPropertyValid(ipItem))
								&& (GetTag(oItem) != "omega_wand")
								&& (GetTag(oItem) != "slv_wand")
								&& (GetTag(oItem) != "tsm_builder_wand")
								&& (GetTag(oItem) != "abr_it_mi_body")
								&& (GetTag(oItem) != "dmfi_exe_tool")
								&& (GetTag(oItem) != "03_it_food")
								&& (GetTag(oItem) != "it_elderberry")
								&& (GetTag(oItem) != "kemoportablechair")
								&& (GetTag(oItem) != "abr_it_firstaid")
								&& (FindSubString(GetTag(oItem), "_ooc_") == -1)
								&& (FindSubString(GetTag(oItem), "abr_it_dm") == -1)
								&& (FindSubString(GetTag(oItem), "acr_dm") == -1)
								&& (FindSubString(GetTag(oItem), "acr_dc") == -1)
								&& (FindSubString(GetTag(oItem), "abr_dm") == -1)
								&& (FindSubString(GetTag(oItem), "abr_spawn") == -1)
								&& (FindSubString(GetTag(oItem), "_loot_token") == -1)
								&& (FindSubString(GetTag(oItem), "dye_") == -1)
								&& (FindSubString(GetTag(oItem), "it_cassi") == -1)
								&& (FindSubString(GetTag(oItem), "it_nararoo") == -1)
								)) {
									//Establish base item, a base item string, and a spot modifier based on size to go with it			
									int nBaseItem = GetBaseItemType(oItem);
									string sBaseItem = IntToString(nBaseItem);
									string sItemName = GetName(oItem);
									
									//If it's unidentified, say so
									string sIdentified = " ";
									string sIdentifiedN = " ";
									string sIdentifiedCap = " ";
									if(GetIdentified(oItem) == FALSE) {sIdentified = "unidentified ";sIdentifiedCap = "Unidentified ";sIdentifiedN = "n unidentified ";} 
											
									if(nBaseItem == 19) {sBaseItem = "An" + sIdentified + "amulet";}
									if(nBaseItem == 16) {sBaseItem = sIdentifiedCap + "Armor";}
									if((nBaseItem == 16) && (FindSubString(GetName(oItem), "Robe") != -1)) {sBaseItem = "A" + sIdentifiedN + "robe";}
									if(nBaseItem == 20) {sBaseItem = sIdentifiedCap + "Arrows";}
									if(nBaseItem == 3) {sBaseItem = "A" + sIdentifiedN + "bastard sword";}
									if(nBaseItem == 2) {sBaseItem = "A" + sIdentifiedN + "battle axe";}
									if(nBaseItem == 21) {sBaseItem = "A" + sIdentifiedN + "belt";}
									if(nBaseItem == 101) {sBaseItem = "A" + sIdentifiedN + "bottle";}
									if(nBaseItem == 25) {sBaseItem = sIdentifiedCap + "Bolts";}
									if(nBaseItem == 74) {sBaseItem = "A" + sIdentifiedN + "book";}
									if(nBaseItem == 26) {sBaseItem = "A" + sIdentifiedN + "pair of boots";}
									if(nBaseItem == 78) {sBaseItem = "A" + sIdentifiedN + "pair of bracers";}
									if(nBaseItem == 27) {sBaseItem = "A" + sIdentifiedN + "pouch of bullets";}
									if(nBaseItem == 80) {sBaseItem = "A" + sIdentifiedN + "cloak";}
									if(nBaseItem == 28) {sBaseItem = "A" + sIdentifiedN + "club";}
									if(nBaseItem == 22) {sBaseItem = "A" + sIdentifiedN + "dagger";}
									if(nBaseItem == 31) {sBaseItem = "A" + sIdentifiedN + "set of darts";}
									if(nBaseItem == 33) {sBaseItem = "A" + sIdentifiedN + "double axe"; }
									if(nBaseItem == 128) {sBaseItem = "A" + sIdentifiedN + "drum";}
									if(nBaseItem == 108) {sBaseItem = "A" + sIdentifiedN + "dwarven war axe";}
									if(nBaseItem == 114) {sBaseItem = "A" + sIdentifiedN + "falchion";}
									if(nBaseItem == 116) {sBaseItem = "A" + sIdentifiedN + "flail";}
									if(nBaseItem == 129) {sBaseItem = "A" + sIdentifiedN + "flute";}
									if(nBaseItem == 77) {sBaseItem = "A" + sIdentifiedN + "gem";}
									if(nBaseItem == 36) {sBaseItem = "A" + sIdentifiedN + "pair of gloves";}
									if(nBaseItem == 18) {sBaseItem = "A" + sIdentifiedN + "great axe";}
									if(nBaseItem == 120) {sBaseItem = "A" + sIdentifiedN + "great club";}
									if(nBaseItem == 13) {sBaseItem = "A" + sIdentifiedN + "great sword";}
									if(nBaseItem == 81) {sBaseItem = "A" + sIdentifiedN + "grenade";}
									if(nBaseItem == 10) {sBaseItem = "A" + sIdentifiedN + "halberd";}
									if(nBaseItem == 38) {sBaseItem = "A" + sIdentifiedN + "hand axe";}
									if(nBaseItem == 6) {sBaseItem = "A" + sIdentifiedN + "heavy crossbow";}
									if(nBaseItem == 35) {sBaseItem = "A" + sIdentifiedN + "heavy flail";}
									if(nBaseItem == 17) {sBaseItem = "A" + sIdentifiedN + "helmet or other headgear";}
									if((nBaseItem == 17) && (FindSubString(GetName(oItem), "Mask") != -1)) {sBaseItem = "A" + sIdentifiedN + "mask";}
									if((nBaseItem == 17) && (FindSubString(GetName(oItem), "Headband") != -1)) {sBaseItem = "A" + sIdentifiedN + "headband";}
									if(nBaseItem == 40) {sBaseItem = "A" + sIdentifiedN + "kama";}
									if(nBaseItem == 41) {sBaseItem = "A" + sIdentifiedN + "katana";}
									if(nBaseItem == 65) {sBaseItem = "A" + sIdentifiedN + "key";}
									if(nBaseItem == 42) {sBaseItem = "A" + sIdentifiedN + "kukri";}
									if(nBaseItem == 66) {sBaseItem = "A" + sIdentifiedN + "large box";}
									if(nBaseItem == 56) {sBaseItem = "A" + sIdentifiedN + "large shield";}
									if(nBaseItem == 7) {sBaseItem = "A" + sIdentifiedN + "light crossbow";}
									if(nBaseItem == 4) {sBaseItem = "A" + sIdentifiedN + "light flail";}
									if(nBaseItem == 37) {sBaseItem = "A" + sIdentifiedN + "light hammer";}
									if(nBaseItem == 9) {sBaseItem = "A" + sIdentifiedN + "light mace";}
									if(nBaseItem == 1) {sBaseItem = "A" + sIdentifiedN + "longsword";}
									if(nBaseItem == 8) {sBaseItem = "A" + sIdentifiedN + "longbow";}
									if(nBaseItem == 132) {sBaseItem = "A" + sIdentifiedN + "lute";}
									if(nBaseItem == 113) {sBaseItem = "A" + sIdentifiedN + "mace";}
									if(nBaseItem == 44) {sBaseItem = "A" + sIdentifiedN + "rod";}
									if(nBaseItem == 45) {sBaseItem = "A" + sIdentifiedN + "staff";}
									if(nBaseItem == 46) {sBaseItem = "A" + sIdentifiedN + "wand";}
									if(nBaseItem == 34) {sBaseItem = "A" + sIdentifiedN + "large item";}
									if(nBaseItem == 29) {sBaseItem = "A" + sIdentifiedN + "medium item";}
									if(nBaseItem == 24) {sBaseItem = "A" + sIdentifiedN + "small item";}
									if(nBaseItem == 103) {sBaseItem = "A" + sIdentifiedN + "small item";}
									if(nBaseItem == 43) {sBaseItem = "A" + sIdentifiedN + "tall item";}
									if(nBaseItem == 79) {sBaseItem = "A" + sIdentifiedN + "thin item";}
									if(nBaseItem == 68) {sBaseItem = "A" + sIdentifiedN + "wide item";}
									if(nBaseItem == 47) {sBaseItem = "A" + sIdentifiedN + "morningstar";}
									if(nBaseItem == 49) {sBaseItem = "A" + sIdentifiedN + "potion";}
									if(nBaseItem == 96) {sBaseItem = "A" + sIdentifiedN + "potion";}
									if(nBaseItem == 50) {sBaseItem = "A" + sIdentifiedN + "quarterstaff";}
									if(nBaseItem == 51) {sBaseItem = "A" + sIdentifiedN + "rapier";}
									if(nBaseItem == 52) {sBaseItem = "A" + sIdentifiedN + "ring";}
									if(nBaseItem == 53) {sBaseItem = "A" + sIdentifiedN + "scimitar";}
									if(nBaseItem == 75) {sBaseItem = "A" + sIdentifiedN + "scroll";}
									if(nBaseItem == 55) {sBaseItem = "A" + sIdentifiedN + "scythe";}
									if(nBaseItem == 11) {sBaseItem = "A" + sIdentifiedN + "short bow";}
									if(nBaseItem == 58) {sBaseItem = "A" + sIdentifiedN + "short spear";}
									if(nBaseItem == 0) {sBaseItem = "A" + sIdentifiedN + "shortsword";}
									if(nBaseItem == 59) {sBaseItem = "A" + sIdentifiedN + "set of shuriken";}
									if(nBaseItem == 60) {sBaseItem = "A" + sIdentifiedN + "sickle";}
									if(nBaseItem == 61) {sBaseItem = "A" + sIdentifiedN + "sling";}
									if(nBaseItem == 14) {sBaseItem = "A" + sIdentifiedN + "small shield";}
									if(nBaseItem == 119) {sBaseItem = "A" + sIdentifiedN + "spear";}
									if(nBaseItem == 63) {sBaseItem = "A" + sIdentifiedN + "set of throwing axes";}
									if(nBaseItem == 62) {sBaseItem = "A" + sIdentifiedN + "set of thieves tools";}
									if(nBaseItem == 200) {sBaseItem = "A" + sIdentifiedN + "small item";}
									if(nBaseItem == 72) {sBaseItem = "A" + sIdentifiedN + "small item";}
									if(nBaseItem == 57) {sBaseItem = "A" + sIdentifiedN + "tower shield";}
									if(nBaseItem == 5) {sBaseItem = "A" + sIdentifiedN + "war hammer";}
									if(nBaseItem == 126) {sBaseItem = "A" + sIdentifiedN + "war mace";}
									if(nBaseItem == 111) {sBaseItem = "A" + sIdentifiedN + "whip";}
									
									//Start looping through item properties on each item
									while (GetIsItemPropertyValid(ipItem)) {
										int nItemProperty = GetItemPropertyType(ipItem);
										int nItemSubType = GetItemPropertySubType(ipItem);
										string sItemSubType = IntToString(nItemSubType);
										int nItemCost = GetItemPropertyCostTableValue(ipItem);
										string sItemProperty = "";
										string sSpellIndex = "";
										
										/*  SRD under Magic Items and Detect Magic
										    Armor and protection items = Abjuration
											Weapons or offensive items = Evocation
											Bonus to ability score, on skill check, etc. = Transmutation
											*/
										if(nItemProperty == 0) {sItemProperty = "Ability Bonus"; sSchool = "T"; nAuraPower = nItemCost;}
										if((nItemProperty >= 1) && (nItemProperty <=5)) {sItemProperty = "AC Bonus"; sSchool = "A"; nAuraPower = nItemCost;}
										if((nItemProperty >= 56) && (nItemProperty <=59)) {sItemProperty = "Attack Bonus"; sSchool = "V"; nAuraPower = nItemCost;}
										if(nItemProperty == 12) {sItemProperty = "Bonus Feat"; sSchool = "T"; nAuraPower = 2;}
										if(nItemProperty == 66) {sItemProperty = "Bonus HP"; sSchool = "T"; nAuraPower = 2;}
										if(nItemProperty == 13) {sItemProperty = "Bonus Spell Slot"; sSchool = "T"; nAuraPower = nItemCost;}
										//We don't want to override values already set on items currently checking Cast Spell: Unique added by SpellSchool variables
										if(nItemProperty == 15){
											sItemProperty = "Cast Spell";
											if(GetLocalInt(oItem, "ACR_SPELLADDED") == 0) {
												sSpellIndex = Get2DAString("iprp_spells", "SpellIndex", nItemSubType); 
												sSchool = Get2DAString("spells", "School", StringToInt(sSpellIndex));
												sAuraPower = Get2DAString("spells", "Innate", StringToInt(sSpellIndex));
												nAuraPower = StringToInt(sAuraPower);
												}
											}
										if((nItemProperty >= 16) && (nItemProperty <=19)) {sItemProperty = "Damage Bonus"; sSchool = "V"; nAuraPower = nItemCost;}
										if(nItemProperty == 90) {sItemProperty = "Damage Reduction"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 23) {sItemProperty = "Damage Resistance"; sSchool = "A"; nAuraPower = nItemCost;}
										if(nItemProperty == 24) {sItemProperty = "Damage Vulnerability"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 26) {sItemProperty = "Darkvision"; sSchool = "T"; nAuraPower = 2;}
										if(nItemProperty == 27) {sItemProperty = "Decreased Ability"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 28) {sItemProperty = "Decreased AC"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 29) {sItemProperty = "Decreased Skill"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 10) {sItemProperty = "Decreased Enhancement Modifier"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 60) {sItemProperty = "Decreased Attack Modifier"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 21) {sItemProperty = "Decreased Damage"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 49) {sItemProperty = "Decreased Saving Throw"; sSchool = "T"; nAuraPower = nItemCost;}
										if((nItemProperty >= 6) && (nItemProperty <=9)) {sItemProperty = "Enhancement Bonus"; sSchool = "V"; nAuraPower = nItemCost;}
										if((nItemProperty >= 33) && (nItemProperty <=34)) {sItemProperty = "Extra Damage"; sSchool = "V"; nAuraPower = nItemCost;}
										if(nItemProperty == 75) {sItemProperty = "Freedom of Movement"; sSchool = "T"; nAuraPower = 4;}
										if(nItemProperty == 35) {sItemProperty = "Haste"; sSchool = "T"; nAuraPower = 3;}
										if(nItemProperty == 20) {sItemProperty = "Immunity Damage Type"; sSchool = "A"; nAuraPower = 7;}
										if(nItemProperty == 37) {sItemProperty = "Immunity Misc"; sSchool = "A"; nAuraPower = 7;}
										if((nItemProperty >= 53) && (nItemProperty <=54)) {sItemProperty = "Immunity Spell/s"; sSchool = "A"; nAuraPower = 7;}
										if(nItemProperty == 78) {sItemProperty = "Immunity Spell Level"; sSchool = "A"; nAuraPower = 7;}
										if(nItemProperty == 38) {sItemProperty = "Improved Evasion"; sSchool = "T"; nAuraPower = 7;}
										if(nItemProperty == 44) {sItemProperty = "Light"; sSchool = "V"; nAuraPower = 1;}
										if(nItemProperty == 82) {
											sItemProperty = "On Hit Cast Spell";
											sSpellIndex = Get2DAString("iprp_spells", "SpellIndex", nItemSubType); 
											sSchool = Get2DAString("spells", "School", StringToInt(sSpellIndex));
											sAuraPower = Get2DAString("spells", "Innate", StringToInt(sSpellIndex));
											nAuraPower = StringToInt(sAuraPower);
											}
										if(nItemProperty == 51) {sItemProperty = "Regeneration"; sSchool = "T"; nAuraPower = 7;}
										if((nItemProperty >= 40) && (nItemProperty <=41)) {sItemProperty = "Saving Throw Bonus"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 52) {sItemProperty = "Skill Bonus"; sSchool = "T"; nAuraPower = nItemCost;}
										if(nItemProperty == 39) {sItemProperty = "Spell Resistance"; sSchool = "A"; nAuraPower = 5;}
										if(nItemProperty == 71) {sItemProperty = "True Seeing"; sSchool = "T"; nAuraPower = 5;}
										
										if(sItemProperty != "") {
											if(GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) {SetLocalInt(oCaster, "nItemCount", 1);}
											//If no SpellSchool variables on Cast Unique subtypes
											if((GetLocalInt(oItem, "ACR_SPELLADDED") == 0) && ((sItemSubType == "125") || (sItemSubType == "329") || (sItemSubType == "335"))) 
												{sSchool = " of complex arcanity "; nAuraPower = 0; sAuraStrength = "magic";
												if(GetTag(oItem) == "abr_it_holysymbol") {sSchool = "A"; nAuraPower = 1;}
												if(GetTag(oItem) == "abr_it_scry_kit") {sSchool = "G"; nAuraPower = 1;}
												}
											//SpellSchool variables for the Cast Unique property that was added before the loop	
											if(GetLocalInt(oItem, "ACR_SPELLADDED") == 1) {
												int nACRSpellSchool = GetLocalInt(oItem, "ACR_SPELLSCHOOL");
												int nAuraPower = GetLocalInt(oItem, "ACR_SPELLPOWER");
												string sACRSubSchool = GetLocalString(oItem, "ACR_SUBSCHOOL");
												if(sACRSubSchool != "") {sACRSubSchool = "(" + sACRSubSchool + ")";}
												if(nACRSpellSchool == 1) {sSchool = " of <color=lightblue>Abjuration " + sACRSubSchool + "</color>"; nAbj++;}
												if(nACRSpellSchool == 2) {sSchool = " of <color=tan>Conjuration " + sACRSubSchool + "</color>"; nCon++;}
												if(nACRSpellSchool == 3) {sSchool = " of <color=green>Divination " + sACRSubSchool + "</color>"; nDiv++;}
												if(nACRSpellSchool == 4) {sSchool = " of <color=magenta>Enchantment " + sACRSubSchool + "</color>"; nEnc++;}
												if(nACRSpellSchool == 5) {sSchool = " of <color=red>Evocation " + sACRSubSchool + "</color>"; nEvo++;}
												if(nACRSpellSchool == 6) {sSchool = " of <color=purple>Illusion " + sACRSubSchool + "</color>"; nIll++;}
												if(nACRSpellSchool == 7) {sSchool = " of <color=white>Necromancy " + sACRSubSchool + "</color>"; nNec++;}
												if(nACRSpellSchool == 8) {sSchool = " of <color=orange>Transmutation " + sACRSubSchool + "</color>"; nTra++;}
												if(nACRSpellSchool == 9) {sSchool = " of <color=#FFFF00>Universal arcanity" + sACRSubSchool + "</color>"; nGen++;}
												
												int nACRSpellSchool2 = GetLocalInt(oItem, "ACR_SPELLSCHOOL2");
												int nAuraPower2 = GetLocalInt(oItem, "ACR_SPELLPOWER2");
												string sACRSubSchool2 = GetLocalString(oItem, "ACR_SUBSCHOOL2");
												if(sACRSubSchool2 != "") {sACRSubSchool2 = "(" + sACRSubSchool2 + ")";}
												if(nACRSpellSchool2 == 1) {sSchool2 = " of <color=lightblue>Abjuration " + sACRSubSchool2 + "</color>"; nAbj++;}
												if(nACRSpellSchool2 == 2) {sSchool2 = " of <color=tan>Conjuration " + sACRSubSchool2 + "</color>"; nCon++;}
												if(nACRSpellSchool2 == 3) {sSchool2 = " of <color=green>Divination " + sACRSubSchool2 + "</color>"; nDiv++;}
												if(nACRSpellSchool2 == 4) {sSchool2 = " of <color=magenta>Enchantment " + sACRSubSchool2 + "</color>"; nEnc++;}
												if(nACRSpellSchool2 == 5) {sSchool2 = " of <color=red>Evocation " + sACRSubSchool2 + "</color>"; nEvo++;}
												if(nACRSpellSchool2 == 6) {sSchool2 = " of <color=purple>Illusion " + sACRSubSchool2 + "</color>"; nIll++;}
												if(nACRSpellSchool2 == 7) {sSchool2 = " of <color=white>Necromancy " + sACRSubSchool2 + "</color>"; nNec++;}
												if(nACRSpellSchool2 == 8) {sSchool2 = " of <color=orange>Transmutation " + sACRSubSchool2 + "</color>"; nTra++;}
												if(nACRSpellSchool2 == 9) {sSchool2 = " of <color=#FFFF00>Universal arcanity" + sACRSubSchool2 + "</color>"; nGen++;}
												int nACRSpellSchool3 = GetLocalInt(oItem, "ACR_SPELLSCHOOL3");
												int nAuraPower3 = GetLocalInt(oItem, "ACR_SPELLPOWER3");
												string sACRSubSchool3 = GetLocalString(oItem, "ACR_SUBSCHOOL3");
												if(sACRSubSchool3 != "") {sACRSubSchool3 = "(" + sACRSubSchool3 + ")";}
												if(nACRSpellSchool3 == 1) {sSchool3 = " of <color=lightblue>Abjuration " + sACRSubSchool3 + "</color>"; nAbj++;}
												if(nACRSpellSchool3 == 2) {sSchool3 = " of <color=tan>Conjuration " + sACRSubSchool3 + "</color>"; nCon++;}
												if(nACRSpellSchool3 == 3) {sSchool3 = " of <color=green>Divination " + sACRSubSchool3 + "</color>"; nDiv++;}
												if(nACRSpellSchool3 == 4) {sSchool3 = " of <color=magenta>Enchantment " + sACRSubSchool3 + "</color>"; nEnc++;}
												if(nACRSpellSchool3 == 5) {sSchool3 = " of <color=red>Evocation " + sACRSubSchool3 + "</color>"; nEvo++;}
												if(nACRSpellSchool3 == 6) {sSchool3 = " of <color=purple>Illusion " + sACRSubSchool3 + "</color>"; nIll++;}
												if(nACRSpellSchool3 == 7) {sSchool3 = " of <color=white>Necromancy " + sACRSubSchool3 + "</color>"; nNec++;}
												if(nACRSpellSchool3 == 8) {sSchool3 = " of <color=orange>Transmutation " + sACRSubSchool3 + "</color>"; nTra++;}
												if(nACRSpellSchool3 == 9) {sSchool3 = " of <color=#FFFF00>Universal arcanity" + sACRSubSchool3 + "</color>"; nGen++;}
												
												if(nAuraPower > 0) {sAuraStrength = "faint";}
												if(nAuraPower > 3) {sAuraStrength = "moderate";}
												if(nAuraPower > 6) {sAuraStrength = "strong";}
												if(nAuraPower > 9) {sAuraStrength = "overwhelming";}
												if(nAuraPower2 > 0) {sAuraStrength2 = "faint";}
												if(nAuraPower2 > 3) {sAuraStrength2 = "moderate";}
												if(nAuraPower2 > 6) {sAuraStrength2 = "strong";}
												if(nAuraPower2 > 9) {sAuraStrength2 = "overwhelming";}
												if(nAuraPower3 > 0) {sAuraStrength3 = "faint";}
												if(nAuraPower3 > 3) {sAuraStrength3 = "moderate";}
												if(nAuraPower3 > 6) {sAuraStrength3 = "strong";}
												if(nAuraPower3 > 9) {sAuraStrength3 = "overwhelming";}
												
												nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
												if(nAuraPower > nAuraPowerHigh) {
													SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
													SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength);
								    				}
												nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
												if(nAuraPower2 > nAuraPowerHigh) {
													SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower2);
													SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength2);
								    				}
												nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
												if(nAuraPower3 > nAuraPowerHigh) {
													SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower3);
													SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength3);
								    				}	
												
												//Extra reports for items with SpellSchool variables.
												float fDelay = 22.1;
												//If this is part of a Creature message stack, that takes longer, with more messages spread over a minute.
										 		//Due to the magic of fDelay, this message stack arrives in the chat window after Round 2 and its own Round 3 Headers
												if(GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) {fDelay = 42.1 + IntToFloat(nSlot/10) +IntToFloat(nCreatureCount * 2);}
												//Only report equipped items for Creatures.
												if(((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) && (nSlot > 0) && (nSlot <= 13)) || (GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oDetected) == OBJECT_TYPE_ITEM)){
													//Queue up SpellSchool reports to caster if Round 3 achieved and creature is not invisible
													if((nConcentration > 13) && (GetLocalInt(oDetected, "nInvis") == 0)) {
														if(nACRSpellSchool > 0) {
															nAuraCount++;
															if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
																DelayCommand(fDelay, SendMessageToAllDMs(GetName(oItem) + ", " + sBaseItem  +  " " + sSlot + ", gives off a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
																}
															DelayCommand(fDelay, SendMessageToPC(oCaster, sBaseItem  +  " " + sSlot + " gives off a " + sAuraStrength + " aura" + sSchool));
															}
														if(nACRSpellSchool2 > 0) {
															nAuraCount++;
															if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
																DelayCommand(fDelay, SendMessageToAllDMs(GetName(oItem) + ", " + sBaseItem  +  " " + sSlot + ", gives off a " + sAuraStrength2 + " --" + IntToString(nAuraPower2) + "-- aura" + sSchool2));
																}
															DelayCommand(fDelay, SendMessageToPC(oCaster, sBaseItem  +  " " + sSlot + " gives off a " + sAuraStrength2 + " aura" + sSchool2));
															}
														if(nACRSpellSchool3 > 0) {
															nAuraCount++;
															if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
																DelayCommand(fDelay, SendMessageToAllDMs(GetName(oItem) + ", " + sBaseItem  +  " " + sSlot + ", gives off a " + sAuraStrength3 + " --" + IntToString(nAuraPower3) + "-- aura" + sSchool3));
																}
															DelayCommand(fDelay, SendMessageToPC(oCaster, sBaseItem  +  " " + sSlot + " gives off a " + sAuraStrength3 + " aura" + sSchool3));
															}
														}
													}
													
												} 
											
											//If it's in a closed container, no soup for you.
											if((GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE)&& (GetIsOpen(oDetected) == FALSE)) {sBaseItem = "Something"; nSomething++;}
												
											if(sSchool == "A") {sSchool = " of <color=lightblue>Abjuration </color>"; nAbj++;}
											if(sSchool == "C") {sSchool = " of <color=tan>Conjuration </color>"; nCon++;}
											if(sSchool == "D") {sSchool = " of <color=green>Divination </color>"; nDiv++;}
											if(sSchool == "E") {sSchool = " of <color=magenta>Enchantment </color>"; nEnc++;}
											if(sSchool == "I") {sSchool = " of <color=purple>Illusion </color>"; nIll++;}
											if(sSchool == "N") {sSchool = " of <color=white>Necromancy </color>"; nNec++;}
											if(sSchool == "T") {sSchool = " of <color=orange>Transmutation </color>"; nTra++;}
											if(sSchool == "V") {sSchool = " of <color=red>Evocation </color>"; nEvo++;}
											if(sSchool == "G") {sSchool = " of <color=#FFFF00>Universal arcanity</color>"; nGen++;}
											
											//If caster fails Spellcraft, no school for you, either.
											if(!GetIsSkillSuccessful(oCaster, SKILL_SPELLCRAFT, 15 + nAuraPower, FALSE)){sSchool = "";sSchool2 = "";sSchool3 = "";}
											
											if(nAuraPower > 0) {sAuraStrength = "faint";}
											if(nAuraPower > 3) {sAuraStrength = "moderate";}
											if(nAuraPower > 6) {sAuraStrength = "strong";}
											if(nAuraPower > 9) {sAuraStrength = "overwhelming";}
											
											//Is this the highest power aura encountered thus far? If so, store it.	
											nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
											if(nAuraPower > nAuraPowerHigh) {
												SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
												SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength);
							    				}
												
											//If the caster gets a Round 3, most objects report at 22 seconds into the report.
											float fDelay = 22.0;
											//If this is part of a Creature message stack, that takes longer, with more messages spread over a minute.
									 		//Due to the magic of fDelay, this message stack arrives in the chat window after Round 2 and its own Round 3 Headers
											if(GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) {fDelay = 42.0 + IntToFloat(nSlot/10) +IntToFloat(nCreatureCount * 2);}
											//Only report equipped items for Creatures.
											if(((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) && (nSlot > 0) && (nSlot <= 13)) || (GetObjectType(oDetected) == OBJECT_TYPE_PLACEABLE) || (GetObjectType(oDetected) == OBJECT_TYPE_ITEM)){
												//Queue up Detail Equipped report to caster if Round 3 achieved and creature is not invisible and it wasn't sent as a SpellSchool message before this
												if((nConcentration > 13) && (GetLocalInt(oDetected, "nInvis") == 0) && (GetLocalInt(oDetected, "ACR_SPELLADDED") == 0)) {
													if((GetLocalInt(oItem, "ACR_SPELLSCHOOL") == 0) && (GetLocalInt(oItem, "ACR_SPELLSCHOOL2") == 0) && (GetLocalInt(oItem, "ACR_SPELLSCHOOL3") == 0)) {
														nAuraCount++;
														if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
															DelayCommand(fDelay, SendMessageToAllDMs(GetName(oItem) + ", " + sBaseItem  +  " " + sSlot + ", gives off a " + sAuraStrength + " --" + IntToString(nAuraPower) + "-- aura" + sSchool));
															}
														DelayCommand(fDelay, SendMessageToPC(oCaster, sBaseItem  +  " " + sSlot + " gives off a " + sAuraStrength + " aura" + sSchool));
														}
													}
												SetLocalInt(oItem, "ACR_SPELLADDED", 0); 
												
												}
											
										//Flag Round 1 Message 	
										SetLocalInt(oCaster, "nMessage1", 1);
										}
										string sSchool = "";
										ipItem = GetNextItemProperty(oItem);
									}
								}
							
							if(GetObjectType(oDetected) == OBJECT_TYPE_ITEM) {nSlot++;}
							 }
						
						//If the caster gets a Round 3, generalize the quantities of auras by school, for a summary report.	
						if(nConcentration > 13) {
							string sAbj;
							string sCon;
							string sDiv;
							string sEnc;
							string sEvo;
							string sIll;
							string sNec;
							string sTra;
							string sGen;
							string sHoly;
							string sSomething;	
									
							if(nAbj < 5) {sAbj = IntToString(nAbj);} else if(nAbj < 8) {sAbj = "around half a dozen";} else if(nAbj < 13) {sAbj = "close to ten";}  else if(nAbj > 12) {sAbj = "more than a dozen";}
							if(nCon < 5) {sCon = IntToString(nCon);} else if(nCon < 8) {sCon = "around half a dozen";} else if(nCon < 13) {sCon = "close to ten";}  else if(nCon > 12) {sCon = "more than a dozen";}
							if(nDiv < 5) {sDiv = IntToString(nDiv);} else if(nDiv < 8) {sDiv = "around half a dozen";} else if(nDiv < 13) {sDiv = "close to ten";}  else if(nDiv > 12) {sDiv = "more than a dozen";}
							if(nEnc < 5) {sEnc = IntToString(nEnc);} else if(nEnc < 8) {sEnc = "around half a dozen";} else if(nEnc < 13) {sEnc = "close to ten";}  else if(nEnc > 12) {sEnc = "more than a dozen";}
							if(nEvo < 5) {sEvo = IntToString(nEvo);} else if(nEvo < 8) {sEvo = "around half a dozen";} else if(nEvo < 13) {sEvo = "close to ten";}  else if(nEvo > 12) {sEvo = "more than a dozen";}
							if(nIll < 5) {sIll = IntToString(nIll);} else if(nIll < 8) {sIll = "around half a dozen";} else if(nIll < 13) {sIll = "close to ten";}  else if(nIll > 12) {sIll = "more than a dozen";}
							if(nNec < 5) {sNec = IntToString(nNec);} else if(nNec < 8) {sNec = "around half a dozen";} else if(nNec < 13) {sNec = "close to ten";}  else if(nNec > 12) {sNec = "more than a dozen";}
							if(nTra < 5) {sTra = IntToString(nTra);} else if(nTra < 8) {sTra = "around half a dozen";} else if(nTra < 13) {sTra = "close to ten";}  else if(nTra > 12) {sTra = "more than a dozen";}
							if(nGen < 5) {sGen = IntToString(nGen);} else if(nGen < 8) {sGen = "around half a dozen";} else if(nGen < 13) {sGen = "close to ten";}  else if(nGen > 12) {sGen = "more than a dozen";}
							if(nSomething < 5) {sSomething = IntToString(nSomething);} else if(nSomething < 8) {sSomething = "around half a dozen";} else if(nSomething < 13) {sSomething = "close to ten";}  else if(nSomething > 12) {sSomething = "more than a dozen";}
							//If it's a Creature, send the Equipped and Carried Summary and the Equipped Detail Header
							if((GetObjectType(oDetected) == OBJECT_TYPE_CREATURE) && (GetLocalInt(oCaster, "nItemCount") > 0)) {
								if(GetLocalInt(oDetected, "nInvis")== 1) {sName = "Something " + IntToString(FloatToInt(GetDistanceBetween(oCaster, oDetected))) + "m to the " + sAngle;}
								float fSumDelay = 26.0;
								if((GetLocalInt(oCaster, "nSummary") == 0) && (GetLocalInt(oDetected, "nInvis")== 0)){
									if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
										DelayCommand(fSumDelay, SendMessageToAllDMs(" "));
										DelayCommand(fSumDelay + 0.1, SendMessageToAllDMs("EQUIPPED AND CARRIED SUMMARY: "));
										}
									}
								if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
									if(nAbj>0) {DelayCommand(fSumDelay + 0.2 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=lightblue>: " + sAbj + " Abjuration</color> auras"));}
									if(nCon>0) {DelayCommand(fSumDelay + 0.3 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=tan>: " + sCon + " Conjuration</color> auras"));}
									if(nDiv>0) {DelayCommand(fSumDelay + 0.4 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=green>: " + sDiv + " Divination</color> auras"));}
									if(nEnc>0) {DelayCommand(fSumDelay + 0.5 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=magenta>: " + sEnc + " Enchantment</color> auras"));}
									if(nEvo>0) {DelayCommand(fSumDelay + 0.6 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=red>: " + sEvo + " Evocation</color> auras"));}
									if(nIll>0) {DelayCommand(fSumDelay + 0.7 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=purple>: " + sIll + " Illusion</color> auras"));}
									if(nNec>0) {DelayCommand(fSumDelay + 0.8 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=white>: " + sNec + " Necromancy</color> auras"));}
									if(nTra>0) {DelayCommand(fSumDelay + 0.9 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=orange>: " + sTra + " Transmutation</color> auras"));}
									if(nGen>0) {DelayCommand(fSumDelay + 1.0 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- <color=#FFFF00>: " + sGen + " Universal</color> auras"));}
									if(nSomething>0) {DelayCommand(fSumDelay + 1.2 + IntToFloat(nCreatureCount), SendMessageToAllDMs(sName + " -- " + GetName(oDetected) + "-- : " + sSomething + " auras you can't classify"));}
									}
								if((GetLocalInt(oCaster, "nSummary") == 0) && (GetLocalInt(oDetected, "nInvis")== 0)){
									if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
										DelayCommand(fSumDelay + 2.1 + IntToFloat(nCreatureCount), SendMessageToAllDMs(" "));
										DelayCommand(fSumDelay + 2.2 + IntToFloat(nCreatureCount), SendMessageToAllDMs("**********"));
										DelayCommand(fSumDelay + 2.3 + IntToFloat(nCreatureCount), SendMessageToAllDMs("EQUIPPED DETAIL: "));
										DelayCommand(50.0 + IntToFloat(nCreatureCount * 2), SendMessageToAllDMs(" "));
										}
									}
									
								if(GetLocalInt(oDetected, "nInvis")== 0) {
									if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
										DelayCommand(50.1 + IntToFloat(nCreatureCount *2 ), SendMessageToAllDMs("The rest of the auras on " + sName + " are in inventory."));
								 		}
									}
									if((GetLocalInt(oCaster, "nSummary") == 0) && (GetLocalInt(oDetected, "nInvis")== 0)) {
										DelayCommand(fSumDelay, SendMessageToPC(oCaster, " "));
										DelayCommand(fSumDelay + 0.1, SendMessageToPC(oCaster, "EQUIPPED AND CARRIED SUMMARY: "));
										}
									if(nAbj>0) {DelayCommand(fSumDelay + 0.2 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=lightblue>: " + sAbj + " Abjuration</color> auras"));}
									if(nCon>0) {DelayCommand(fSumDelay + 0.3 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=tan>: " + sCon + " Conjuration</color> auras"));}
									if(nDiv>0) {DelayCommand(fSumDelay + 0.4 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=green>: " + sDiv + " Divination</color> auras"));}
									if(nEnc>0) {DelayCommand(fSumDelay + 0.5 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=magenta>: " + sEnc + " Enchantment</color> auras"));}
									if(nEvo>0) {DelayCommand(fSumDelay + 0.6 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=red>: " + sEvo + " Evocation</color> auras"));}
									if(nIll>0) {DelayCommand(fSumDelay + 0.7 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=purple>: " + sIll + " Illusion</color> auras"));}
									if(nNec>0) {DelayCommand(fSumDelay + 0.8 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=white>: " + sNec + " Necromancy</color> auras"));}
									if(nTra>0) {DelayCommand(fSumDelay + 0.9 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=orange>: " + sTra + " Transmutation</color> auras"));}
									if(nGen>0) {DelayCommand(fSumDelay + 1.0 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + "<color=#FFFF00>: " + sGen + " Universal</color> auras"));}
									if(nSomething>0) {DelayCommand(fSumDelay + 1.2 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, sName + ": " + sSomething + " auras you can't classify"));}
								 	if((GetLocalInt(oCaster, "nSummary") == 0) && (GetLocalInt(oDetected, "nInvis")== 0)) {
										SetLocalInt(oCaster, "nSummary",1);
										DelayCommand(fSumDelay + 2.1 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, " "));
										DelayCommand(fSumDelay + 2.2 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, "**********"));
										DelayCommand(fSumDelay + 2.3 + IntToFloat(nCreatureCount), SendMessageToPC(oCaster, "EQUIPPED DETAIL: "));
										DelayCommand(50.0 + IntToFloat(nCreatureCount * 2), SendMessageToPC(oCaster, " "));
										}
									if(GetLocalInt(oDetected, "nInvis")== 0) {DelayCommand(50.1 + IntToFloat(nCreatureCount * 2), SendMessageToPC(oCaster, "The rest of the auras on " + sName + " are in inventory."));}
								}
							}
						
						//Zero out the variables needed by the next item in inventory of this object, or the next object detected in the spellcone
						sSchool = "";
						nAuraPower = 0;
					}
				}
					
				if(nAuraPower > 0) {sAuraStrength = "a faint";}
				if(nAuraPower > 3) {sAuraStrength = "a moderate";}
				if(nAuraPower > 6) {sAuraStrength = "a strong";}
				if(nAuraPower > 9) {sAuraStrength = "an overwhelming";}
					
				nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
				if(nAuraPower > nAuraPowerHigh) {
					SetLocalInt(oCaster, "nAuraPowerHigh", nAuraPower);
					SetLocalString(oCaster, "sAuraPowerHigh", sAuraStrength);
					}
				
				oDetected = GetNextObjectInShape( SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_ALL );
			}
			
		//Any one of the valid aura situations above could have flagged the release of the first round message
		if(GetLocalInt(oCaster, "nMessage1") == 1) {
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(6.0, SendMessageToAllDMs(GetTag(oDetected) + " " + GetName(oCaster) + " concentrates for one round and learns that there is magic within range."));
				}
			DelayCommand(6.0, SendMessageToPC(oCaster, "You concentrate for one round and learn that there is magic within range."));
			SetLocalInt(oCaster, "nMessage1", 2);
			}
		
															
		//We've had Round 1 reported by whichever of the objects had the first magic aura detected.
		//Now see what we've got stored as the strongest aura for Round 2
		int nAuraPowerHigh = GetLocalInt(oCaster, "nAuraPowerHigh");
		string sAuraPowerHigh = GetLocalString(oCaster, "sAuraPowerHigh");
				
		if(nAuraPowerHigh >= 0) {sAuraPowerHigh = "faint";}
		if(nAuraPowerHigh > 3) {sAuraPowerHigh = "moderate";}
		if(nAuraPowerHigh > 6) {sAuraPowerHigh = "strong";}
		if(nAuraPowerHigh > 9) {sAuraPowerHigh = "overwhelming";}
		
		//Also for Round 2, in general how many auras has the caster detected?					
		string sAuraCount = "";
		string sS = "";
		if(nAuraCount > 0) {sS = "s";}
		if(nAuraCount < 5) {sAuraCount = IntToString(nAuraCount);} else if(nAuraCount < 8) {sAuraCount = "around half a dozen";} else if(nAuraCount < 13) {sAuraCount = "close to ten";}  else if(nAuraCount < 15) {sAuraCount = "more than a dozen";} else if(nAuraCount < 24) {sAuraCount = "twenty or so";}else if(nAuraCount < 37) {sAuraCount = "dozens of";}else if(nAuraCount >= 37) {sAuraCount = "scores of";}
		
		//Report Round 2			
		if((nAuraCount > 0) && (nConcentration > 6)) {
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(11.0, SendMessageToAllDMs("**********"));
				DelayCommand(12.0, SendMessageToAllDMs(GetName(oCaster) + " concentrates for two rounds."));
				DelayCommand(13.0, SendMessageToAllDMs(GetName(oCaster) + " senses " + sAuraCount + " --" + IntToString(nAuraCount) + "-- aura"+ sS ));
				DelayCommand(14.0, SendMessageToAllDMs("The most powerful aura " + GetName(oCaster) + " detects is " + sAuraPowerHigh));
				}
				DelayCommand(11.0, SendMessageToPC(oCaster, "**********"));
				DelayCommand(12.0, SendMessageToPC(oCaster, "You concentrate for two rounds."));
				DelayCommand(13.0, SendMessageToPC(oCaster, "You sense " + sAuraCount + " aura" +sS));
				DelayCommand(14.0, SendMessageToPC(oCaster, "The most powerful aura you detect is " + sAuraPowerHigh));
			}
		
		//Introduce Round 3. Headers generated above come after this. Details on equipped items generated even further above come after that.
		if((nAuraCount > 0) && (nConcentration > 13)) {
			float fDelay = 26.0;
			nItemCounted = GetLocalInt(oCaster, "nItemCount");
			int nInvis = GetLocalInt(oDetected, "nInvis");
			if((nItemCounted == 1)&& (nInvis== 0)) {fDelay = 60.0;}
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(19.0, SendMessageToAllDMs("**********"));
				DelayCommand(19.1, SendMessageToAllDMs(GetName(oCaster) + " concentrates for three rounds and learns:"));
				DelayCommand(fDelay + IntToFloat(nCreatureCount * 2), SendMessageToAllDMs("**********"));
				DelayCommand(fDelay + IntToFloat(nCreatureCount * 2)+ 0.1, SendMessageToAllDMs("That is all you learn."));
				}	
			DelayCommand(19.0, SendMessageToPC(oCaster, "**********"));
			DelayCommand(19.1, SendMessageToPC(oCaster, "You concentrate for three rounds and learn:"));
			
			/*
			This is where info learned in Round 3 because of Concentration > 13 will show in chat box
			Function Spells Header: starts Line 639
			FS Detail: starts Line 655
			E&C Summary: starts Line 1049
			E Detail: starts Line 1006
			*/
			
			//The last thing sent, after Round 3 equipped details finish. 
			DelayCommand(fDelay + IntToFloat(nCreatureCount * 2), SendMessageToPC(oCaster, "**********"));
			DelayCommand(fDelay + IntToFloat(nCreatureCount * 2) + 0.1, SendMessageToPC(oCaster, "That is all you learn."));
			SetLocalInt(oCaster, "nItemCount", 0);
			}
		
		//If the caster didn't roll over a 13 Concentration, they don't get any of that lovely Round 3 info above at all.
		else if (nAuraCount > 0){
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(19.0, SendMessageToAllDMs("**********"));
				DelayCommand(19.1, SendMessageToAllDMs(GetName(oCaster) + "'s concentration breaks."));
				}
			DelayCommand(19.0, SendMessageToPC(oCaster, "**********"));
			DelayCommand(19.1, SendMessageToPC(oCaster, "Your concentration breaks."));
			}
		
		//If there's nothing magic in the spell cone.
		if(nAuraCount == 0) {
			if(GetLocalInt(GetModule(), "DM_Spam") == 0) {
				DelayCommand(6.0, SendMessageToAllDMs(GetName(oCaster) + " detects 0 auras."));
				}
			DelayCommand(6.0, SendMessageToPC(oCaster, "You detect 0 auras."));
			}	
		
		//Unset local variables	
		SetLocalInt(oCaster, "nAuraPowerHigh", 0);
		SetLocalString(oCaster, "sAuraPowerHigh", "");
		SetLocalInt(oCaster, "nSummary", 0);
		
}				
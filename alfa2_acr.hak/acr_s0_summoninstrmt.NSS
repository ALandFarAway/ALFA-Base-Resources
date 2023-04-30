/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_summoninstrmt.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Summon Instrument.   
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
	effect eBardSong = EffectVisualEffect(VFX_DUR_BARD_SONG, 0);
	//Try to determine what instrument the PC favors by what they've put the most skill points into
	int nPerformStr = GetSkillRank(48, oCaster, FALSE);
	int nPerformWind = GetSkillRank(62, oCaster, FALSE);
	int nPerformDrum = GetSkillRank(60, oCaster, FALSE);
	string sPerform = "abr_it_msc_lute";
	string sPerformScry = "lute";
	if((nPerformWind >= nPerformStr) && (nPerformStr >= nPerformDrum)) {sPerform = "abr_it_msc_flute"; sPerformScry = "flute";}
	if((nPerformDrum >= nPerformStr) && (nPerformStr >= nPerformWind)) {sPerform = "abr_it_msc_drum"; sPerformScry = "drum";}
		
	//Scrying hook. If they're close enough to a scrying mirror, they get a scrying shard.	
	if((GetDistanceBetween(GetNearestObjectByTag("ACR_SCRY_OBJECT", oCaster, 1), oCaster) <= 5.0) && (FindSubString(GetName(GetNearestObjectByTag("ACR_SCRY_OBJECT", oCaster, 1)), "Mirror") != -1)) {
		object oScryer = oCaster;
		location lTarget = GetLocation(oScryer);
		object oScry = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_PLACEABLE);
		while(oScry != OBJECT_INVALID) {
				string sPlaceableTag = GetTag(oScry);
				string sPlaceableName = GetName(oScry);
				if((FindSubString(sPlaceableTag, "_SCRY_") != -1) && (FindSubString(sPlaceableName, "Mirror") != -1)) {
					object oFocus = CreateItemOnObject("abr_it_scry_focus", oScryer, 1);
					SetFirstName(oFocus, "Scrying Shard");
					SendMessageToPC(oScryer, "A shard shaped like a " + sPerformScry + " shimmers into your hand, out of the " + GetName(oScry) + ", leaving the glass unblemished.");
				 }
				oScry = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_PLACEABLE);
				}
	}
	
	//Otherwise, they just want to play, so give them a temporary instrument.
	else {		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBardSong, oCaster, 3.0);
		ActionPlayAnimation(ANIMATION_FIREFORGET_BARDSONG, 1.0, 3.0);
		object oPerform = CreateItemOnObject(sPerform, oCaster, 1);
		SetPlotFlag(oPerform, TRUE);
		DelayCommand(1.0, ActionEquipItem(oPerform, INVENTORY_SLOT_RIGHTHAND)); 
		int nBardLevel = GetCasterLevel(oCaster);
		float nDuration = nBardLevel * 60.0;
		DestroyObject(oPerform, nDuration);
		}
		
	// Post-cast event.
	ACR_PostcastEvent();
	}				
/////////////////////////////////////////////////////////////////////////////
//
//  System Name : ALFA Core Rules
//     Filename : acr_s0_createwater.nss
//    $Revision:: 1        $ current version of the file
//        $Date:: 2023-03-15 date the file was created or modified
//       Author : Wynna 
//
//
//  Description
//  Create Water. Mostly a hook into Scrying, but also the cantrip as per FRCS.
//  This script handles the Druid interaction with trigger based scrying pools.
//  Object-based scrying pools and fonts are handled in the placeable oncastat.
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
	ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 3.0);
	object oScryer = OBJECT_SELF;
	effect eCreateWater = EffectVisualEffect(VFX_DUR_SPELL_SHROUDING_FOG, 0);
	effect eCreateWater2 = EffectVisualEffect(VFX_HIT_DROWN, 0);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCreateWater, oScryer, 3.0);
	DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCreateWater2, oScryer));
	
	//Because Druids use triggers as well as objects for scrying we have to do some scripting gymnastics.
	//If a Druid casts this within 5.0 radius of a trigger-based scrying pool, they get a scrying droplet.
	int nCasterType = GetLastSpellCastClass();
	SetLocalInt(oScryer, "nSpellCasterType", nCasterType);
	object oScry = GetSpellTargetObject();
	location lTarget = GetLocation(oScryer);
	if(nCasterType == CLASS_TYPE_DRUID) {
		lTarget = GetSpellTargetLocation();
		oScry = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_TRIGGER);
		while(oScry != OBJECT_INVALID) {
			string sTriggerTag = GetTag(oScry);
			if(FindSubString(sTriggerTag, "_SCRY_") != -1) {
				object oFocus = CreateItemOnObject("abr_it_scry_focus", oScryer, 1);
				SetFirstName(oFocus, "Scrying Droplet");
				SendMessageToPC(oScryer, "You call forth a droplet of water vapor, catching it in a vial as it rises from the " + GetName(oScry) + ".");
			    SetItemIcon(oFocus, 1896);
				return;
				}
			oScry = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_TRIGGER);
			}
		}
	
	//If anybody, Druid or not, cast this on anything but a trigger-based scrying pool, give 'em a drink already.		
	if(GetTag(oScry) != "ACR_SCRY_OBJECT") 
		{CreateItemOnObject("abr_it_food_water", oScryer, 1);
		 SendMessageToPC(oScryer, "Water vapor forms in the air around you, and condenses into a small bottle you have ready for it.");
		}
		
	// Post-cast event.
	ACR_PostcastEvent();
	}				
//::///////////////////////////////////////////////
//:: Blades of Fire
//:: nx2_s0_blades_of_fire.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   	Blades of Fire
	Conjuration (Creation) [Fire]
	Level: Ranger 1, sorceror/wizard 1
	Components: V
	Range: Touch
	Targets: Up to two melee weapons you are weilding
	Duration: 2 rounds
	Saving throw: None
	Spell Resistance: None
	 
	Your melee weapons each deal an extra 1d8 points of fire damage.  
	This damage stacks with any energy damage your weapons already deal.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	SpawnScriptDebugger();
	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	object oRightHand		= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object oLeftHand		= GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	// Spell Duration
	float fDuration			= RoundsToSeconds(2);
	// Effects
	itemproperty ipFire 	= ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// check to see if ally
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
			// check to make sure right hand weapon is meleee and valid
			if(GetIsObjectValid(oRightHand) && IPGetIsMeleeWeapon(oRightHand))
			{
				// fire it up, since it stacks with any energy damge no need for a safe add
				IPSafeAddItemProperty(oRightHand, ipFire, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			// check to make sure left hand weapon is meleee and valid
			if(GetIsObjectValid(oLeftHand) && IPGetIsMeleeWeapon(oLeftHand))
			{
				// fire it up, since it stacks with any energy damge no need for a safe add
				IPSafeAddItemProperty(oLeftHand, ipFire, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
	}
	
}
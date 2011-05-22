//::///////////////////////////////////////////////
//:: Bladeweave
//:: nx2_s0_bladeweave.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Bladeweave
	Illusion [Pattern]
	Level: Bard 2, Wizard/Sorcerer 2
	Components: V
	Range: Personal
	Target: You
	Duration: 1 round/level
	Saving Thow: See Text
	Spell Resistance: See text
	 
	For the duration of the spell, your weapon gains the ability to daze opponents who fail their will save for one round.  
	The save is calculated based on the caster's abilities.

	*NOTE* Currently the save is set at 16, need further support to make save based on caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic

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
	//SpawnScriptDebugger();
	// Get necessary objects
	object oCaster			= OBJECT_SELF;
	object oWeapon			= IPGetTargetedOrEquippedMeleeWeapon();
	object oTarget 			= GetItemPossessor(oWeapon);
	// Spell Duration
	float fDuration			= RoundsToSeconds(GetCasterLevel(oCaster));
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	// Effects
	itemproperty ipDaze 	= ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_16, IP_CONST_ONHIT_DURATION_100_PERCENT_1_ROUND);
	effect eVisual 			= EffectVisualEffect(VFX_HIT_SPELL_BLADEWEAVE);
	string sFeedback		= GetStringByStrRef(228878); // Weapon is Invalid: Bladeweave will have no effect!
	// Make sure spell target is valid
	if (!GetIsObjectValid(oWeapon))
	{
		SendMessageToPC(oCaster, sFeedback);
		return;
	}
	else
	{
		//SpeakString("Object is Valid, Apparently");
		IPSafeAddItemProperty(oWeapon, ipDaze, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
		//Fire cast spell at event for the specified target
   		SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	}


	
}
//::///////////////////////////////////////////////
//:: Epic Gate
//:: nx_s2_epic_gate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Classes: Bard, Cleric, Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 27
	Caster Level: Epic
	Innate Level: Epic
	School: Conjuration
	Descriptor(s): 
	Components: Verbal, Somatic
	Range: Medium
	Area of Effect / Target: Point
	Duration: 40 rounds
	Save: None
	Spell Resistance: No

	This spell opens a portal to the Lower Planes and calls forth a balor
	to assail your foes. If the demon is slain, a second one is
	immediately summoned in its place.  The strength of this conjuration
	is such that the devils are bound to your will, and you need not have
	cast Protection from Evil, or any similar spell, to prevent them from
	attacking you.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/11/2007
//:://////////////////////////////////////////////
// EPF 7/13/07 - changed to balor
// AFW-OEI 07/17/2007: NX1 VFX.

#include "x2_inc_spellhook"


void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    float fDuration = RoundsToSeconds(40);	// Fixed 40 round duration
	location lSpellTargetLocation = GetSpellTargetLocation();
    effect eDur = EffectVisualEffect(VFX_DUR_SPELL_EPIC_GATE);
	effect eVis = EffectVisualEffect(VFX_INVOCATION_BRIMSTONE_DOOM);
    effect eSummon = EffectSwarm(FALSE, "c_summ_balor", "c_summ_balor");

	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDur, lSpellTargetLocation, 5.0);
	DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lSpellTargetLocation));
    DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration));
}
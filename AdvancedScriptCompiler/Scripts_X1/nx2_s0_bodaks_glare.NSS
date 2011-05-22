//::///////////////////////////////////////////////
//:: Bodak's Glare
//:: nx2_s0_bodaks_glare.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Bodak's Glare
	Necromancy [Death, Evil]
	Level: Cleric 8
	Components: V, S
	Range: Close
	Target: One living creature
	Duration: TBD
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	 
	Upon completion of the spell, you target a creature within range.  
	That creature dies instantly unless it succeeds on a Fortitude save.
	 
	If you slay a humanoid creature with this attack, it will return as a bodak under your control.
	
	*NOTE* Currently using zombie as bodak place holder, also duration set at caster level is temporary as well
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/29/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x0_i0_match"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	// Get necessary objects
	object oTarget		= GetSpellTargetObject();
	object oCaster		= OBJECT_SELF;
	location lTarget	= GetLocation(oTarget);
	// Caster Level
	int nCasterLevel	= GetCasterLevel(oCaster);
	float fDuration		= RoundsToSeconds(nCasterLevel);
	// Effects
	effect eDeath		= EffectDeath();
	effect eHit			= EffectVisualEffect(VFX_HIT_SPELL_BODAKS_GLARE);
	effect eSummon		= EffectSummonCreature("c_zombie", VFX_SUMMON_SPELL_BODAKS_GLARE, 0.8f);
	effect eLink		= EffectLinkEffects(eHit, eDeath);
	// Succesful save?
	int nSaved;
	
	// Make sure spell target valid
	if (GetIsObjectValid(oTarget))
	{
		// check to see if hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) 
		{
			nSaved = FortitudeSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster);
			if(nSaved == 2)
			{
				// do nothing, immune
			}
			else if(nSaved == 1)
			{
				// do nothing, succesful save
			}
			else if(nSaved == 0)
			{
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				if(MatchHumanoidRacialType(GetRacialType(oTarget)))
				{
					ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
				}
			}
			//Fire cast spell at event for the specified target
	    	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
}
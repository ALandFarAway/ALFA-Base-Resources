//::///////////////////////////////////////////////
//:: Drown, Mass
//:: NX_s0_massdrown.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Drown, Mass
	Conjuration (Creation) [Water]
	Level: Druid 9
	Components: V, S
	Range: Close
	Target: Any creature within 30 ft of the targeted area or creature.
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	You create water in the lungs of the subject, 
	reducing it to 90% of its current hit points.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills based on x0_s0_drown (06.26.02 Brent)
//:: Created On: 12.01.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

#include "nw_i0_spells"
#include "x2_inc_spellhook"  

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Declare major variables
	location lTarget = GetSpellTargetLocation();
	object oCaster = OBJECT_SELF;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDam;
	effect eVis = EffectVisualEffect( VFX_HIT_DROWN );
    effect eDam;
	
//target discrimination
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1019));
			
			//Make SR Check
        	if(!MyResistSpell(OBJECT_SELF, oTarget))
        	{
            	// * certain racial types are immune
            	if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
                	&&(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                	&&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
            	{
                	//Make a fortitude save 
                	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
                	{
                    	nDam = FloatToInt(GetCurrentHitPoints(oTarget) * 0.9);
                    	eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
                    	//Apply the VFX impact and damage effect
                    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}
		
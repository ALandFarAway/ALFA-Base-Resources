//::///////////////////////////////////////////////
//:: Call Lightning Storm
//:: NX_s0_callstorm.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
	Duration: 1 round/level
	Components: V
	Saving Throw: Will negates
	Spell Resistance: No
	 
	Implement as targetable AoE with radius of 30 
	ft and range of Close (if we use range for AoE 
	spells). Any affected target is affected with 
	Sleep status effect for the spell's duration.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: ChazM 6/13/07 - Signal Event
//:: AFW-OEI 07/11/2007: NX1 VFX

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"

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
    location 	lTarget 	= 	GetSpellTargetLocation();
	object 		oCaster 	=	OBJECT_SELF;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    effect 		eDur 		= 	EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
			{
            	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
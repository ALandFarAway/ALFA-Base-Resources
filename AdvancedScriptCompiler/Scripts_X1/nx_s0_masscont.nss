//::///////////////////////////////////////////////
//:: Contagion, Mass
//:: NX_s0_mascont.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Contagion, Mass
	Necromancy [Evil]
	Level: Cleric 5, druid 5, sorceror/wizard 6
	Components: V, S
	Range: Medium
	Area: 20-ft.-radius
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	 
	As contagion except that it effects all targets within the prescribed area.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills, based on nw_s0_contagion (06.06.01 Preston Watamaniuk)
//:: Created On: 11.30.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/16/2007: Do not link duration VFX to disease,
//::	as resting will remove the VFX, which will also remove
//::	the linked disease.

#include "nw_i0_spells" 
#include "x0_I0_SPELLS"    
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
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	object oCaster = OBJECT_SELF;
    int nRand = Random(7)+1;
    int nDisease;
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
        case 1:
            nDisease = DISEASE_BLINDING_SICKNESS;
        break;
        case 2:
            nDisease = DISEASE_CACKLE_FEVER;
        break;
        case 3:
            nDisease = DISEASE_FILTH_FEVER;
        break;
        case 4:
            nDisease = DISEASE_MINDFIRE;
        break;
        case 5:
            nDisease = DISEASE_RED_ACHE;
        break;
        case 6:
            nDisease = DISEASE_SHAKES;
        break;
        case 7:
            nDisease = DISEASE_SLIMY_DOOM;
        break;
    }
	effect eDisease = EffectDisease(nDisease);
	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1017));
			
			if (!MyResistSpell(oCaster, oTarget))
			{
				//disease resistance and saves are handled by the EffectDisease function automatically
				effect eHit = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY );
				//eDisease = EffectLinkEffects( eDisease, eHit );
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);

			}
		}
		//find my next victim
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}
//::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target must save or be struck down with
    Blidning Sickness, Cackle Fever, Filth Fever
    Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 6, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 07/16/2007: Do not link duration VFX to disease,
//::	as resting will remove the VFX, which will also remove
//::	the linked disease.

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
    object oTarget = GetSpellTargetObject();
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
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
        effect eDisease = EffectDisease(nDisease);
        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //The effect is permament because the disease subsystem has its own internal resolution
            //system in place.
			//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_POISON);	// NWN1 VFX
			effect eHit = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY );	// NWN2 VFX
			//eDisease = EffectLinkEffects( eDisease, eHit );
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget );	// NWN2 VFX
        }
    }
}
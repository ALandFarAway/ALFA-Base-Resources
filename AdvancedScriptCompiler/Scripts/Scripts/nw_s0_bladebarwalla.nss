//::///////////////////////////////////////////////
//:: Blade Barrier, Wall : On Enter
//:: NW_S0_BladeBarWallA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
    effect eDam;
    //effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    int nMetaMagic = GetMetaMagicFeat();
    int nLevel = GetCasterLevel(GetAreaOfEffectCreator());
	
    //Make level check
    if (nLevel > 15)
    {
        nLevel = 15;
    }
    if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
    {
        //Fire spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLADE_BARRIER));
        //Roll Damage
        int nDamage = d6(nLevel);
        //Enter Metamagic conditions
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {
            nDamage = nLevel * 6;//Damage is at max
        }
        else if (nMetaMagic == METAMAGIC_EMPOWER)
        {
            nDamage = nDamage + (nDamage/2);
        }
        //Make SR Check
        if (!MyResistSpell(oCaster, oTarget) )
        {
            //if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC()))
            //{
            //    nDamage = nDamage/2;
            //}

            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster);

        if (nDamage > 0)
        {
            //Set damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
			
			//Link Effects
			//effect eLink = EffectLinkEffects( eDam, eVis );
			
            //Apply damage and VFX
			//ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget);
			SpawnBloodHit(oTarget, TRUE, OBJECT_INVALID);
			ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget);
			
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        }
    }
}
//::///////////////////////////////////////////////
//:: Flame Strike
//:: NW_S0_FlmStrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A flame strike is a vertical column of divine fire
// roaring downward. The spell deals 1d6 points of
// damage per level, to a maximum of 15d6. Half the
// damage is fire damage, but the rest of the damage
// results directly from divine power and is therefore
// not subject to protection from elements (fire),
// fire shield (chill shield), etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 19, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
// ChazM 7/18/07 - Fire and Holy effect order swapped. (GetDamageDealtByType() will not return Fire damage)

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
  object oTarget;
  int nCasterLvl = GetCasterLevel(OBJECT_SELF);
  int nDamage, nDamage2;
  int nMetaMagic = GetMetaMagicFeat();
  effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);	// NWN2 VFX
  //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FLAMESTRIKE);	// NWN2 VFX
  effect eColumn = EffectVisualEffect( VFX_HIT_SPELL_FLAMESTRIKE );	// NWN2 VFX
  effect eHoly;
  effect eFire;
  effect eLink;
  //Limit caster level for the purposes of determining damage.
  if (nCasterLvl > 15)
  {
    nCasterLvl = 15;
  }
  
  location lTarget = GetSpellTargetLocation();
  ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eColumn, lTarget );
  
  //Declare the spell shape, size and the location.  Capture the first target object in the shape.
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);

  //Cycle through the targets within the spell shape until an invalid object is captured.
  while ( GetIsObjectValid(oTarget) )
  {
       if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	   {
            //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_STRIKE));
           //Make SR check, and appropriate saving throw(s).
           if (!MyResistSpell(OBJECT_SELF, oTarget, 0.6))
    	   {
    	        nDamage =  d6(nCasterLvl);
    		    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                     nDamage = 6 * nCasterLvl;
                }
    		    if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                      nDamage = nDamage + (nDamage/2);
                }
                //Adjust the damage based on Reflex Save, Evasion and Improved Evasion
                nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DIVINE);
                nDamage = GetReflexAdjustedDamage(nDamage/2, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                
				//Make a faction check so that only enemies receieve the full brunt of the damage.
				// 8/29/06 - BDF-OEI: uh, why?  Let's get rid of this.
                //if(!GetIsFriend(oTarget))
                //{
                    eHoly = EffectDamage( nDamage2, DAMAGE_TYPE_DIVINE );
                //}
                // Apply effects to the currently selected target.
                eFire =  EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
                if(nDamage > 0 || nDamage2 > 0)
                {
					//eLink = EffectLinkEffects( eFire, eHoly );
					eLink = EffectLinkEffects( eHoly, eFire );
					eLink = EffectLinkEffects( eLink, eVis );
                    //DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    //DelayCommand( 0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oTarget) );
                    //DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(0.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR );
    }
}
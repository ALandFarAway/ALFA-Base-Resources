//::///////////////////////////////////////////////
//:: Weird
//:: NW_S0_Weird
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All enemies in LOS of the spell must make 2 saves or die.
    Even IF the fortitude save is succesful, they will still take
    3d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: DEc 14 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 27, 2001

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
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	
    effect eWeird = EffectVisualEffect(VFX_FNF_WEIRD);
    effect eAbyss = EffectVisualEffect(VFX_HIT_AOE_EVIL);//PMills OEI 07.07.06 This is never called in this script, but if someone wants to put it in I've updated the vfx for it
    effect eDeath = EffectDeath();
	effect eLink2 = EffectLinkEffects(eVis2, eDeath);
	int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWeird, GetSpellTargetLocation());
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
    while (GetIsObjectValid(oTarget))
    {
        //Make a faction check
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
               fDelay = GetRandomDelay(3.0, 4.0);
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEIRD));
               //Make an SR Check
               if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
               {
                    if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) &&
                         !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) &&
						 !GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTarget) )	// AFW-OEI 04/20/2006: If I'm Immune to Phantasms, I'm immune to this spell
                    {
                        if(GetHitDice(oTarget) >= 4)
                        {
                            //Make a Will save against mind-affecting
                            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF))
                            {
                                //Make a fortitude save against death
                                if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF))
                                {
                                    // * I made my saving throw but I still have to take the 3d6 damage

                                    //Roll damage
                                    nDamage = d6(3);
                                    //Make metamagic check
                                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                                    {
                                        nDamage = 18;
                                    }
                                    if (nMetaMagic == METAMAGIC_EMPOWER)
                                    {
                                        nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                                    }
                                    //Set damage effect
                                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                                    //Apply VFX Impact and damage effect
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                                }
                                else
                                {
                                    // * I failed BOTH saving throws. Now I die.


                                    //Apply VFX impact and death effect
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                                }
                            } // Will save
                        }
                        else
                        {
                            // * I have less than 4HD, I die.

                            //Apply VFX impact and death effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));
                            //effect eDeath = EffectDeath();
                            //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
               }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
    }
}
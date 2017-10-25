//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: RPGplayer1 02/10/2009: Do SR check only after melee touch attack success

#include "NW_I0_SPELLS"
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
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
		if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{
			FloatingTextStrRefOnCreature(40105, OBJECT_SELF, FALSE);
			return;
		}
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));
        //Make melee touch attack
        if(TouchAttackMelee(oTarget))
        {
            //Make SR check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Fort save
                if  (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH))
                {
                    //Apply the death effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                }
                else
                {
                    //Roll damage
                    nDamage = d6(3)+ nCasterLevel;
                    //Make metamagic checks
                    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDamage = 18 + nCasterLevel;
                    }
                    if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDamage = nDamage + (nDamage/2);
                    }
                    //Apply damage effect and VFX impact
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
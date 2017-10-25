//::///////////////////////////////////////////////
//:: [Shocking Grasp]
//:: [NW_S0_ShkngGrsp.nss]
//:://////////////////////////////////////////////
//:: 
//:: 
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 06, 2005
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Maximized cirticals obey dice caps
//::  No double damage on creatures immune to critical hits
//:://////////////////////////////////////////////

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


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
    object oTarget = GetSpellTargetObject();
    int nDamage, nHeal;
    int nTouch = TouchAttackMelee(oTarget);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);	//VFX_IMP_HARM
	effect eRay = EffectBeam(VFX_BEAM_SHOCKING_GRASP, OBJECT_SELF, BODY_NODE_HAND);
    effect eDam;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    if (nTouch != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
    	  if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	  {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                int nMaxLvl = nCasterLvl;
                if ( nMaxLvl > 5 )
                {
                    nMaxLvl = 5;
                }
                nDamage = d6(nMaxLvl);
				//PKM-OEI: 05.28.07: Do critical hit damage
				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
				{
					nDamage = d6(nMaxLvl * 2);
					//Check for metamagic
                	nDamage = ApplyMetamagicVariableMods(nDamage, (nMaxLvl*2) * 6);
				}
				else if (nTouch >= 1)
				{
                	//Check for metamagic
                	nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl*6);
				}
				
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_ELECTRICAL);

                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
}
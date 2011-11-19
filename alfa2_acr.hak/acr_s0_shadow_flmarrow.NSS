//::///////////////////////////////////////////////
//:: Shadow Flame Arrow
//:: acr_S0_Shadow_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a stream of fiery arrows at the selected
    target that do 4d6 damage per arrow.  1 Arrow
    per 4 levels is created.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 20, 2001
//:: Updated By: Georg Zoeller, Aug 18 2003: Uncapped
//:://////////////////////////////////////////////
// Modified by NESchampion 3 November 2011

#include "x0_I0_SPELLS"
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
	
    object oTarget = GetSpellTargetObject();
	location lSourceLoc = GetLocation(OBJECT_SELF);
	location lTargetLoc = GetLocation(oTarget);
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nCnt;
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE);

    int nMissiles = (nCasterLvl)/4;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    //float fDelay = fDist/(3.0 * log(fDist) + 2.0);
	float fTime;
	float fTime2;
    //Limit missiles to five
    if(nMissiles == 0)
    {
        nMissiles = 1;
    }
    /* Uncapped because PHB does list any cap and we now got epic levels
    else if (nMissiles > 5)
    {
        nMissiles = 5;
    }*/

    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT; 
    //int nPathType = PROJECTILE_PATH_TYPE_HOMING_SPIRAL; //NWN1 stuff that I don't want, was overriding 2da settings.

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        float fDelay = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_ARROW));

	effect eMantle = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eMantle) &&
		(GetEffectSpellId(eMantle) != SPELL_LEAST_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_LESSER_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_SPELL_MANTLE) &&
		(GetEffectSpellId(eMantle) != SPELL_GREATER_SPELL_MANTLE))
	{
		eMantle = GetNextEffect(oTarget);
	}
	if (GetIsEffectValid(eMantle)) 
	{
		MyResistSpell(OBJECT_SELF, oTarget, fDelay);
		for (nCnt = 1; nCnt <= nMissiles; ++nCnt)
		{
			fTime2 = ((nCnt - 1) * 0.25);
			DelayCommand(fTime2, SpawnSpellProjectile(OBJECT_SELF,oTarget,lSourceLoc,lTargetLoc,SPELL_FLAME_ARROW,nPathType));
		}
	}
	else
	{
        //Apply a single damage hit for each missile instead of as a single mass
        //Make SR Check
        for (nCnt = 1; nCnt <= nMissiles; ++nCnt)
        {
			fTime = fDelay + ((nCnt - 1) * 0.25);
			fTime2 = ((nCnt - 1) * 0.25);
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
				if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE))
				{
                	//Roll damage
                	nDamage = d6(4) + 1;
                	//Enter Metamagic conditions
                	if (nMetaMagic == METAMAGIC_MAXIMIZE)
                	{
                	      nDamage = 24;//Damage is at max
                	}
                	if (nMetaMagic == METAMAGIC_EMPOWER)
                	{
                	      nDamage += nDamage/2; //Damage/Healing is +50%
                	}
                	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                	//Set damage effect
                	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                	//Apply the damage effect
                	DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
				}
				else
				{
				    //Roll damage
                	nDamage = d6(4) + 1;
                	//Enter Metamagic conditions
                	if (nMetaMagic == METAMAGIC_MAXIMIZE)
                	{
                	      nDamage = 24;//Damage is at max
                	}
                	if (nMetaMagic == METAMAGIC_EMPOWER)
                	{
                	      nDamage += nDamage/2; //Damage/Healing is +50%
                	}
                	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
					//Disbelief damage reduction
					nDamage = nDamage/5;
                	//Set damage effect
                	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                	//Apply the damage effect
                	DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
				}
            }
            // * May 2003: Make it so the arrow always appears, even if resisted
			DelayCommand(fTime2, SpawnSpellProjectile(OBJECT_SELF,oTarget,lSourceLoc,lTargetLoc,SPELL_FLAME_ARROW,nPathType));
        }
	}
    }
}
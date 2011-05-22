//::///////////////////////////////////////////////
//:: Dragon Breath Fire
//:: NW_S1_DragFire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:: Modified By: Constant Gaw - 8/9/06
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Make damage roll for each target

#include "NW_I0_SPELLS"
#include "x0_i0_spells"

void BreathFire(int nDamage, int nDC);

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
    int nDamage, nDC, nDamStrike;
    float fDelay;
    object oTarget;
    effect eVis, eBreath;
    //Use the HD of the creature to determine damage and save DC
    if (nAge <= 6) //Wyrmling
    {
        nDamage = 2;
        nDC = 15;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = 4;
        nDC = 18;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = 6;
        nDC = 19;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = 8;
        nDC = 22;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = 10;
        nDC = 24;
    }
    else if (nAge >= 19 && nAge <= 22) //Adult
    {
        nDamage = 12;
        nDC = 25;
    }
    else if (nAge >= 23 && nAge <= 24) //Mature Adult
    {
        nDamage = 14;
        nDC = 28;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = 16;
        nDC = 30;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = 18;
        nDC = 33;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = 20;
        nDC = 35;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = 22;
        nDC = 38;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = 24;
        nDC = 40;
    }

	effect eFireBreath = EffectNWN2SpecialEffectFile("fx_red_dragon_breath.sef");
	
    PlayDragonBattleCry();
	PlayCustomAnimation(OBJECT_SELF, "Una_breathattack01", 0, 0.7f);
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFireBreath, OBJECT_SELF, 3.0f));
    //Get first target in spell area
	
	DelayCommand(0.7f, BreathFire(nDamage, nDC));
}
	
void BreathFire(int nDamage, int nDC)
{
	float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_ASTRONOMIC, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Reset the damage to full
            int nDamStrike = d10(nDamage);		

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
            {
                nDamStrike = nDamStrike/2;
                if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamStrike = 0;
                }
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamStrike = nDamStrike/2;
            }			
			effect eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_FIRE);
            if (nDamStrike > 0)
            {
                //Determine effect delay
                //fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
                DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_ASTRONOMIC, GetSpellTargetLocation(), TRUE);
    }
}
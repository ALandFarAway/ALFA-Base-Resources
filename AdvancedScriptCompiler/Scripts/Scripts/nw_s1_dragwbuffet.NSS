//::///////////////////////////////////////////////
//:: Dragon Wing Buffet
//:: NW_S1_DragWBuffet
//:://////////////////////////////////////////////
/*
    Applies Dragon Wing Buffet effects to creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Constant Gaw - 8/9/06
//:: Modified By: Brian Fox - 8/21/06
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "ginc_math"

void main()
{
    //Declare major variables
    int nAge = GetHitDice(OBJECT_SELF);
	int nDC;
    float fDelay;
	float fRandomDuration;
    object oTarget;
    effect eVis, eBreath;
    //Use the HD of the creature to determine save DC
    if (nAge <= 6) //Wyrmling
    {
        nDC = 15;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDC = 18;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDC = 19;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDC = 22;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDC = 24;
    }
    else if (nAge >= 19 && nAge <= 22) //Adult
    {
        nDC = 25;
    }
    else if (nAge >= 23 && nAge <= 24) //Mature Adult
    {
        nDC = 28;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDC = 30;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDC = 33;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDC = 35;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDC = 38;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDC = 40;
    }
	
	location lSelf = GetLocation(OBJECT_SELF);

	effect eWingBuffet = EffectNWN2SpecialEffectFile("fx_reddr_wbuffet.sef");
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	
    PlayDragonBattleCry();
	PlayCustomAnimation(OBJECT_SELF, "*specialattack01", 0, 1.0f);
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWingBuffet, OBJECT_SELF, 3.0f));
	DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lSelf));
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetSpellTargetLocation(), TRUE);
	//oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, lSelf, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
 //           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.

            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                //Set Damage and VFX
				effect eKnockdown = EffectKnockdown();

                //eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
				eVis = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				fRandomDuration = RandomFloatBetween(3.0, 10.0);
                //Apply the VFX impact and effects
							
               	DelayCommand(0.5 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));			
				DelayCommand(0.5 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0f));
				//DelayCommand(0.5 + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(1.5 + fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0f));
				//DelayCommand(1.5 + fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetSpellTargetLocation(), TRUE);
		//oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, lSelf, TRUE);
    }
}

// Old variant:

//::///////////////////////////////////////////////
//:: Dragon Wing Buffet
//:: NW_S1_WingBlast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The dragon will launch into the air, knockdown
    all opponents who fail a Reflex Save and then
    land on one of those opponents doing damage
    up to a maximum of the Dragons HD + 10.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2002
//:://////////////////////////////////////////////
/*
void main()
{
    //Declare major variables
    effect eAppear;
    effect eKnockDown = EffectKnockdown();
    int nHP;
    int nCurrent = 0;
    object oVict;
    int nDamage = GetHitDice(OBJECT_SELF);
    int nDC = nDamage;
    nDamage = Random(nDamage) + 11;
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
                if(GetCreatureSize(oTarget) != CREATURE_SIZE_HUGE)
                {
                    if(!ReflexSave(oTarget, nDC))
                    {
                        DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oTarget, 6.0);
                    }
                }
            //Get next target in spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
        }
    }
    location lLocal;
    lLocal = GetLocation(OBJECT_SELF);
    //Apply the VFX impact and effects
    eAppear = EffectDisappearAppear(lLocal);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAppear, OBJECT_SELF, 6.0);

}
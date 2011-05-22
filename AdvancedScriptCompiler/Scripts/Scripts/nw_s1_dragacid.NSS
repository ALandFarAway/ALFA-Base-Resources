//::///////////////////////////////////////////////
//:: Acid Breath
//:: nw_s1_dragacid
//::
//:: RPGplayer1 03/19/2008:
//::  Breath shape changed to line (to match VFX)
//::  Make damage roll for each target

#include "X0_I0_SPELLS"
#include "ginc_debug"
#include "x0_i0_position"

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
        nDC = 13;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = 4;
        nDC = 14;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = 6;
        nDC = 17;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = 8;
        nDC = 18;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = 10;
        nDC = 22;
    }
    else if (nAge >= 19 && nAge <= 21) //Adult
    {
        nDamage = 12;
        nDC = 23;
    }
    else if (nAge >= 22 && nAge <= 24) //Mature Adult
    {
        nDamage = 12;
        nDC = 26;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = 16;
        nDC = 27;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = 18;
        nDC = 30;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = 20;
        nDC = 31;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = 24;
        nDC = 34;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = 24;
        nDC = 36;
    }
	
	oTarget = GetSpellTargetObject();	
	effect eAcidBeam = EffectVisualEffect(VFX_BEAM_GREEN_DRAGON_ACID);
    PlayDragonBattleCry();  //What does this do?  Mysteries abound in the land of Faerun.
	PlayCustomAnimation(OBJECT_SELF, "Una_breathattack01", 0, 0.7f);
    //Get first target in spell area
	location lLocation = GetLocation(oTarget);
	
	location lNewLocation = GetAheadLocation(OBJECT_SELF, 60.0f);
	object oEndTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lNewLocation);
	
	DelayCommand(1.0f, DestroyObject(oEndTarget));
	
	DelayCommand(0.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAcidBeam, oEndTarget, 4.0f));
	
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lLocation, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Reset the damage to full
            nDamStrike = d4(nDamage);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_ACID));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0f;
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ACID))
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
            if (nDamStrike > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_ACID);
                eVis = EffectVisualEffect(VFX_IMP_ACID_L);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0 ));
                DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0 ));
                DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0 ));
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 60.0, lLocation, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    }
}
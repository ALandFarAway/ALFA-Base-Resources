//::///////////////////////////////////////////////
//:: Dragon Tail Slap
//:: NW_S1_DragTSlap
//:://////////////////////////////////////////////
/*
    Applies Dragon Tail Slap effects to creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Constant Gaw - 8/9/06
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x0_i0_position"
#include "ginc_math"

void TailSwipe(int nDamage, int nDC);
void DisarmCreature(object oTarget);

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
        nDamage = d4(2);
        nDC = 15;
    }
    else if (nAge >= 7 && nAge <= 9) //Very Young
    {
        nDamage = d4(4);
        nDC = 18;
    }
    else if (nAge >= 10 && nAge <= 12) //Young
    {
        nDamage = d4(6);
        nDC = 19;
    }
    else if (nAge >= 13 && nAge <= 15) //Juvenile
    {
        nDamage = d4(8);
        nDC = 22;
    }
    else if (nAge >= 16 && nAge <= 18) //Young Adult
    {
        nDamage = d4(10);
        nDC = 24;
    }
    else if (nAge >= 19 && nAge <= 22) //Adult
    {
        nDamage = d4(12);
        nDC = 25;
    }
    else if (nAge >= 23 && nAge <= 24) //Mature Adult
    {
        nDamage = d4(14);
        nDC = 28;
    }
    else if (nAge >= 25 && nAge <= 27) //Old
    {
        nDamage = d4(16);
        nDC = 30;
    }
    else if (nAge >= 28 && nAge <= 30) //Very Old
    {
        nDamage = d4(18);
        nDC = 33;
    }
    else if (nAge >= 31 && nAge <= 33) //Ancient
    {
        nDamage = d4(20);
        nDC = 35;
    }
    else if (nAge >= 34 && nAge <= 37) //Wyrm
    {
        nDamage = d4(22);
        nDC = 38;
    }
    else if (nAge > 37) //Great Wyrm
    {
        nDamage = d4(24);
        nDC = 40;
    }
	
    PlayDragonBattleCry();
	PlayCustomAnimation(OBJECT_SELF, "Una_tailslap", 0, 0.5f);
    //Get first target in spell area
	
	DelayCommand(1.0f, TailSwipe(nDamage, nDC));
}
	
void TailSwipe(int nDamage, int nDC)
{
	float fDelay;
    effect eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
	effect eKnockdown = EffectKnockdown();
	float fFacing = GetFacing(OBJECT_SELF);
	float fRandomDuration;
	location lLocation = GetBehindLocation(OBJECT_SELF, 15.0f);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLocation, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Reset the damage to full
            int nDamStrike = nDamage;		
   		    effect eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_FIRE);
            //Fire cast spell at event for the specified target
//            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC - 5, SAVING_THROW_TYPE_NONE))
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
                //Determine effect delay
                //fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Apply the VFX impact and effects
				//ActionUseFeat(FEAT_IMPROVED_DISARM, oTarget);
				if (GetIsCreatureDisarmable(oTarget) == TRUE && !MySavingThrow(SAVING_THROW_REFLEX, 
					oTarget, nDC, SAVING_THROW_TYPE_NONE))
				{
					DelayCommand(0.7, AssignCommand(oTarget, DisarmCreature(oTarget)));
				}
				
				fRandomDuration = RandomFloatBetween(6.0, 12.0);
				
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLocation, FALSE, OBJECT_TYPE_CREATURE);
    }
	
}

void DisarmCreature(object oTarget)
{
	object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_mc_bag03", GetLocation(oTarget));
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	AssignCommand(oBag, ActionTakeItem(oItem, oTarget));	
}
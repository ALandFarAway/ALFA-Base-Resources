//::///////////////////////////////////////////////
//:: Heal Animal Companion
//:: nx_s0_healanimal.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Heal Animal Companion
	Conjuration (Healing)
	Level: Druid 5, ranger 3
	Components: V, S
	Range: Touch
	Target: Your animal companion touched
	
	Heals an animal companion of 10 points per caster
	level and removes the wounded effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.06.2006
//:://////////////////////////////////////////////
// ChazM 5/31/07 - updated to use HealHarmTarget() in nwn2_inc_spells

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
//#include "nwn2_inc_hlhrm"
#include "nwn2_inc_spells"


void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

//Major variables
	object 	oTarget 	= 	GetSpellTargetObject();
	object 	oCaster 	= 	OBJECT_SELF;
	int 	nCasterLevel 	= GetCasterLevel( oCaster );

	

//Validate target and apply effects
	if (GetIsObjectValid(oTarget))
	{
		if (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
		{
		int bIsHealingSpell = TRUE;
		int nSpellID = SPELL_HEAL;
		
		HealHarmTarget(oTarget, nCasterLevel, nSpellID, bIsHealingSpell );
		}
		else
		{
			FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
			return;
		}
	
/*	
		if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    	{
    		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) //if the target is undead and hostile, or hardcore rules are on
    		{
				HarmTarget( oTarget, oCaster, SPELL_HEAL );
        	}
			else //undead, even friendly ones, will never be healed by this spell
			{
				return;
			}
		}
		else if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
		{
			if ((GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL
				|| GetRacialType(oTarget) == RACIAL_TYPE_BEAST
				|| GetRacialType(oTarget) == RACIAL_TYPE_VERMIN)
				&& !GetHasEffect(EFFECT_TYPE_WILDSHAPE, oTarget))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1030, FALSE));
				HealTarget( oTarget, oCaster, SPELL_HEAL );
				
			}
			else
			{
				FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
				return;
			}
		}
*/		
	}
}
				
		
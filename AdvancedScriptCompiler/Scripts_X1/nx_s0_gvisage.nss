//::///////////////////////////////////////////////
//:: Visage of the Deity
//:: nx_s0_visage.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*	
	Components: V, S
	Range: Personal
	Duration: 1 round/level
	 
	Caster gains the following:*
	- +1 Natural Armor (stacks with all)
	- DR 10/magic (does not stack with similar effects; best DR is used)
	- SR 25 (does not stack with similar effects; best SR is used)
	 
	* In D&D, caster also gets wings. We won't be giving wings.
	 
	If cleric is Good:
	- Resistance 10 to acid, cold, electricity

	- Immunity to disease
	- +4 to saving throws vs. poison
	- Ability bonuses (stack with all): +2 DEX, INT; +4 STR, CON, WIS, CHA.
	- Blue aura around character
	 
	If cleric is Neutral (w/ respect to good and evil):**
	- Resistance 15 to acid and electricity

	- Ability bonuses (stack with all): +4 STR, DEX, CON, INT, WIS, CHA
	- Green aura around character
	 
	** In D&D, there isn't a neutral version.
	 
	If cleric is Evil:
	- Resistance 10 to acid, cold, electricity, fire

	- Immunity to poison
	- Ability bonuses (stack with all): +2 CON, CHA, WIS; +4 STR, DEX, INT***
	- Red aura around character
	 
	*** In D&D, evil casters also get claw and bite attacks. Instead 
	we're giving +2 WIS (in D&D, evil casters gain no WIS bonus).
	
	NOTE: Vision modifiers removed because the only way to do this
	is to grant temporary feats, which can break characters and 
	save games.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 06/28/2007: Use new Greater Visage VFX.
//:: RPGplayer1 02/25/2009: Changed SpellCastAt event to harmless, so it doesn't drop invisibility

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"


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

//Declare major variables

	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetSpellTargetObject();
	effect		eCha;
	effect		eDex;
	effect		eInt;
	effect		eStr;
	effect		eCon;
	effect		eWis;
	effect		eAcid;
	effect		eCold;
	effect		eElec;
	effect		eFire;
	effect		eGood;
	effect		eEvil;
	effect		eNeut;
	effect		eGoodVis	=	EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect		eEvilVis	=	EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect		eNeutVis	=	EffectVisualEffect(VFX_HIT_AOE_TRANSMUTATION);
	effect		eGoodAura	=	EffectVisualEffect(VFX_DUR_SPELL_VISAGE_GOOD);
	effect		eEvilAura	=	EffectVisualEffect(VFX_DUR_SPELL_VISAGE_EVIL);
	effect		eNeutAura	=	EffectVisualEffect(VFX_DUR_SPELL_VISAGE_NEUTRAL);
	effect		eDisease	=	EffectImmunity(IMMUNITY_TYPE_DISEASE);
	effect		ePoison		=	EffectImmunity(IMMUNITY_TYPE_POISON);
	effect		eSR			=	EffectSpellResistanceIncrease(25);
	effect		eDR			=	EffectDamageReduction(10, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS);
	effect		eAC			=	EffectACIncrease(1,AC_NATURAL_BONUS);
	effect		eSaves		=	EffectSavingThrowIncrease(SAVING_THROW_FORT, 4, SAVING_THROW_TYPE_POISON);
	
	float		fDuration	=	RoundsToSeconds(GetCasterLevel(oCaster));
	
	
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
	if (GetIsObjectValid(oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1041, FALSE));
		if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
		{
			eAcid	=	EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
			eCold	=	EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eElec	=	EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
			
			eDex	=	EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
			eInt	=	EffectAbilityIncrease(ABILITY_INTELLIGENCE, 2);
			
			eStr	=	EffectAbilityIncrease(ABILITY_STRENGTH, 4);
			eCon	=	EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
			eWis	=	EffectAbilityIncrease(ABILITY_WISDOM, 4);
			eCha	=	EffectAbilityIncrease(ABILITY_CHARISMA, 4);
			
			eGood	=	EffectLinkEffects(eAcid, eCold);
			eGood	=	EffectLinkEffects(eGood, eElec);
			eGood	=	EffectLinkEffects(eGood, eDex);
			eGood	=	EffectLinkEffects(eGood, eInt);
			eGood	=	EffectLinkEffects(eGood, eStr);
			eGood	=	EffectLinkEffects(eGood, eCon);
			eGood	=	EffectLinkEffects(eGood, eWis);
			eGood	=	EffectLinkEffects(eGood, eCha);
			eGood	=	EffectLinkEffects(eGood, eGoodAura);
			eGood	=	EffectLinkEffects(eGood, eDisease);
			eGood	=	EffectLinkEffects(eGood, eSaves);
			eGood	=	EffectLinkEffects(eGood, eSR);
			eGood	=	EffectLinkEffects(eGood, eDR);
			eGood	=	EffectLinkEffects(eGood, eAC);
			
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGood, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eGoodVis, oCaster);
		}
		else if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL)
		{
		 	eCold	=	EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
			eFire	=	EffectDamageResistance(DAMAGE_TYPE_FIRE, 10);
			eAcid	=	EffectDamageResistance(DAMAGE_TYPE_ACID, 10);
			eElec	=	EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10);
			
			eCon	=	EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
			eCha	=	EffectAbilityIncrease(ABILITY_CHARISMA, 2);
			eWis	=	EffectAbilityIncrease(ABILITY_WISDOM, 2);
			
			eStr	=	EffectAbilityIncrease(ABILITY_STRENGTH, 4);
			eDex	=	EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
			eInt	=	EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);		
			
			eEvil	=	EffectLinkEffects(eCold, eFire);
			eEvil	=	EffectLinkEffects(eEvil, eAcid);
			eEvil	=	EffectLinkEffects(eEvil, eElec);
			eEvil	=	EffectLinkEffects(eEvil, eCon);
			eEvil	=	EffectLinkEffects(eEvil, eCha);
			eEvil	=	EffectLinkEffects(eEvil, eWis);
			eEvil	=	EffectLinkEffects(eEvil, eStr);
			eEvil	=	EffectLinkEffects(eEvil, eDex);
			eEvil	=	EffectLinkEffects(eEvil, eInt);
			eEvil	=	EffectLinkEffects(eEvil, ePoison);
			eEvil	=	EffectLinkEffects(eEvil, eSR);
			eEvil	=	EffectLinkEffects(eEvil, eDR);
			eEvil	=	EffectLinkEffects(eEvil, eAC);
			eEvil	=	EffectLinkEffects(eEvil, eEvilAura);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEvil, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEvilVis, oCaster);
		}
		else
		{
			eAcid	=	EffectDamageResistance(DAMAGE_TYPE_ACID, 15);
			eElec	=	EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 15);
			
			eStr	=	EffectAbilityIncrease(ABILITY_STRENGTH, 4);
			eDex	=	EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
			eCon	=	EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
			eInt	=	EffectAbilityIncrease(ABILITY_INTELLIGENCE, 4);
			eWis	=	EffectAbilityIncrease(ABILITY_WISDOM, 4);
			eCha	=	EffectAbilityIncrease(ABILITY_CHARISMA, 4);
			
			
			eNeut	=	EffectLinkEffects(eAcid, eElec);
			eNeut	=	EffectLinkEffects(eNeut, eStr);
			eNeut	=	EffectLinkEffects(eNeut, eDex);
			eNeut	=	EffectLinkEffects(eNeut, eCon);
			eNeut	=	EffectLinkEffects(eNeut, eInt);
			eNeut	=	EffectLinkEffects(eNeut, eWis);
			eNeut	=	EffectLinkEffects(eNeut, eCha);
			eNeut	=	EffectLinkEffects(eNeut, eNeutAura);
			eNeut	=	EffectLinkEffects(eNeut, eSR);
			eNeut	=	EffectLinkEffects(eNeut, eDR);
			eNeut	=	EffectLinkEffects(eNeut, eAC);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNeut, oCaster, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeutVis, oCaster);
		}
	}
}
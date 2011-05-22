//::///////////////////////////////////////////////
//:: Level 9 Arcane Spell: Shades
//:: shades.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/19/05
//:://////////////////////////////////////////////
/*
	Greater Shadow Conjuration
	
    If the opponent is clicked on Delayed Blast Fireball is cast.
    If the caster clicks on himself he will cast Premonition, Protection from Spells, and Shield.  
    If they click on the ground they will call Summon Creature VIII

*/
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Update creature blueprints.
//::	Change summon durations from hours to 3 + CL rounds.
//:: BDF-OEI 06/21/2006:
//::	Modified to make use of new NWN2 data

#include "nw_i0_spells"
#include "x2_inc_spellhook" 

	
const int CONTEXT_SELF 		= 1;
const int CONTEXT_TARGET 	= 2;
const int CONTEXT_GROUND	= 3;

void HandleCastOnSelf( object oSelf, int nDuration );
void HandleCastOnTarget( object oTarget, int nDuration );
void HandleCastOnGround( location lTarget, int nDuration );




void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel; // Duration is 1 hr per level of the caster
	int nSummonDuration = nCasterLevel + 3;	// Summon duration 3 + caster level rounds

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
    {
		nDuration = nDuration *2;	//Duration is +100%
		nSummonDuration = nSummonDuration * 2;
    }

	object oTarget = GetSpellTargetObject();
    int nCast = CONTEXT_GROUND;
    if (GetIsObjectValid(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            nCast = CONTEXT_SELF;
        }
        else
        {
            nCast = CONTEXT_TARGET;
        }
    }
    else
    {
        nCast = CONTEXT_GROUND;
    }
    
    switch (nCast)
    {
        case CONTEXT_SELF:			HandleCastOnSelf( oTarget, nDuration );								break;
		case CONTEXT_TARGET:		HandleCastOnTarget( oTarget, nDuration );							break;
		case CONTEXT_GROUND:		HandleCastOnGround( GetSpellTargetLocation(), nSummonDuration );	break;
    }
}

///////////////////////////////////////////////////////////////////////////////
// HandleCastOnSelf
// 	Get Premonition, Protection from Spells, and Mage Armor effects
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnSelf( object oSelf, int nDuration )
{
    //Fire cast spell at event for the specified target
    SignalEvent(oSelf, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	// Get rid of old effects
	RemoveEffectsFromSpell(oSelf, SPELL_PROTECTION_FROM_SPELLS);
    RemoveEffectsFromSpell(oSelf, SPELL_PREMONITION);
    RemoveEffectsFromSpell(oSelf, SPELL_MAGE_ARMOR);

    effect eLink;

	// Premonition	
	int nLimit = GetCasterLevel(oSelf) * 10;
    //effect eStone 	= EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);	// 3.0 DR rules
    effect eStone 	= EffectDamageReduction( 30, GMATERIAL_METAL_ADAMANTINE, nLimit, DR_TYPE_GMATERIAL );		// 3.5 DR rule approximation
    //effect eVis 	= EffectVisualEffect(VFX_DUR_PROT_PREMONITION);	// no longer using the NWN1 VFX
    effect eVis 	= EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );	// makes use of the NWN2 VFX
	eLink = EffectLinkEffects(eStone, eVis); // Link it up!

	// Protection from Spells
    //effect ePfS_Vis 	= EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);	// no longer using the NWN1 VFX
    effect ePfS_Vis 	= EffectVisualEffect( VFX_DUR_SPELL_PROTECTION_FROM_SPELLS );	// makes use of the NWN2 VFX
    effect ePfS_Save 	= EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL);
    effect ePfS_Dur1 	= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// no longer using the NWN1 VFX
    //effect ePfS_Dur2 	= EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);	// no longer using the NWN1 VFX
	eLink = EffectLinkEffects(ePfS_Vis, eLink);
	eLink = EffectLinkEffects(ePfS_Save, eLink);
	eLink = EffectLinkEffects(ePfS_Dur1, eLink);	// no longer using the NWN1 VFX
	//eLink = EffectLinkEffects(ePfS_Dur2, eLink);	// no longer using the NWN1 VFX

    //Mage Armor
	//effect eMA_Vis 	= EffectVisualEffect(VFX_IMP_AC_BONUS);	// no longer using the NWN1 VFX
	effect eMA_Vis 	= EffectVisualEffect( VFX_DUR_SPELL_MAGE_ARMOR );	// makes use of the NWN2 VFX
    effect eMA_AC 	= EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eMA_Dur 	= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// no longer using the NWN1 VFX
	eLink = EffectLinkEffects(eMA_AC, eLink);
	eLink = EffectLinkEffects(eMA_Dur, eLink);	// no longer using the NWN1 VFX

    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oSelf, HoursToSeconds(nDuration));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, ePfS_Vis, oSelf);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMA_Vis, oSelf);
}

///////////////////////////////////////////////////////////////////////////////
// HandleCastOnTarget
// 	Casts a "Delayed Blast Fireball" at the target's location
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnTarget( object oTarget, int nDuration )
{
    effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL);
    location lTarget = GetLocation( oTarget );

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

///////////////////////////////////////////////////////////////////////////////
// HandleCastOnGround
// 	Runs identical to the "Creature Summoning VIII" Spell
//	This was copied from the nw_s0_summon8.nss script
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnGround( location lTarget, int nDuration )
{
   	//Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eSummon;
    int nRoll = d4();
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        switch (nRoll)
        {
            case 1:	eSummon = EffectSummonCreature("c_elmairelder");            break;
            case 2:	eSummon = EffectSummonCreature("c_elmearthelder");          break;
            case 3:	eSummon = EffectSummonCreature("c_elmfireelder");         	break;
            case 4:	eSummon = EffectSummonCreature("c_elmwaterelder");          break;
        }
    }
    else
    {
        switch (nRoll)
        {
            case 1:	eSummon = EffectSummonCreature("c_elmairgreater");              break;
            case 2:	eSummon = EffectSummonCreature("c_elmearthgreater");            break;
            case 3:	eSummon = EffectSummonCreature("c_elmfiregreater");             break;
            case 4:	eSummon = EffectSummonCreature("c_elmwatergreater");            break;
        }
    }

    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);	// no longer using the NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SUMMON_CREATURE );	// makes use of the NWN2 VFX
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(),RoundsToSeconds(nDuration));
}
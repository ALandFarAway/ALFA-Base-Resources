//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses
// 10/2/06-BDF: modified STR and DEX bonuses from d2(4) to d4(2), as per description
// 10/18/16-BDF(OEI): restored most of original implementation now that polymorphing
//	to the Tenser's appearance type is supported for this spell again.
#include "x2_inc_spellhook"
#include "nw_i0_spells"

void main()
{


  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tensors by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    int nLevel = GetCasterLevel(OBJECT_SELF);
    int nHP, /*nCnt,*/ nDuration;
    nDuration = GetCasterLevel(OBJECT_SELF);
	
	/* This loop is ridiculous
    //Determine bonus HP
    for(nCnt; nCnt <= nLevel; nCnt++)
    {
        nHP += d6();
    }
	*/
	
	nHP = d6( nLevel );

    int nMeta = GetMetaMagicFeat();
    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nHP = nLevel * 6;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }
    //Declare effects
    effect eAttack = EffectAttackIncrease(nLevel/2); 
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_TENSERS_TRANSFORM );
    effect ePoly = EffectPolymorph(28);
    effect eSwing = EffectModifyAttacks(2);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	
	//These substitute for the non-functional polymorph effects
	// 10/18/06-BDF: now that the Tenser's appearance is re-enabled, these effects are no longer necessary
//	effect eStr		= EffectAbilityIncrease(ABILITY_STRENGTH, d4(2));	// 10/2/06-BDF: modified from d2(4)
//	effect eDex		= EffectAbilityIncrease(ABILITY_DEXTERITY, d4(2));	// 10/2/06-BDF: modified from d2(4)
//	effect eCon		= EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
	//effect eAC	= EffectACIncrease(4, AC_NATURAL_BONUS);	// 10/18/06 - BDF: This is set in polymorph.2da



    //Link effects

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, ePoly);
    eLink = EffectLinkEffects(eLink, eSwing);
//	eLink = EffectLinkEffects( eLink, eHP );	// 8/1/06 - BDF: linked to temp HP to allow for easy removal when poly is cancelled
	
	//These are additional links substituting for the polymorph
	// 10/18/06-BDF: now that the Tenser's appearance is re-enabled, these effects are no longer necessary
//	eLink = EffectLinkEffects( eLink, eStr );
//	eLink = EffectLinkEffects( eLink, eDex );
//	eLink = EffectLinkEffects( eLink, eCon );
	//eLink = EffectLinkEffects( eLink, eAC );	// 10/18/06 - BDF: This is set in polymorph.2da

    effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION));
    eLink = EffectLinkEffects(eLink, eOnDispell);
    eHP = EffectLinkEffects(eHP, eOnDispell);

    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration));	// this effect is now included in the link
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration)-0.01);
}
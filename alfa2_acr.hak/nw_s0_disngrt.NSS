//:://///////////////////////////////////////////////
//:: Level 6 Arcane Spell: Disintegrate
//:: nw_s0_disngrt.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/16/05
//::////////////////////////////////////////////////
/*
        5.1.6.3.2	Disintegrate (B)
        PHB, pg. 222
        School:		Transmutation
        Components: 	Verbal, Somatic
        Range:		Medium
        Target:		Ray
        Duration:		Instantaneous
        Saving Throw:	Fortitude partial
        Spell Resist:	Yes

        This requires a ranged touch attack to hit. Any creature hit takes 2d6 
        hit points of damage per caster level (to a maximum of 40d6). Any creature 
        reduced to 0 hit points or less is entirely disintegrated. If the target 
        makes their fortitude saves, they only take 5d6 damage.
        [Art] For this spell to work we need a disintegration effect or some sort 
        of procedural effect that would mimic it. It would have to work for any hostile target.

        [Rules Note] In 3.5 you can also disintegrate objects, but that's not really possible in NWN2.

*/
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage
//:: AFW-OEI 06/08/2007: Switch hostile target check & signal event with Touch Attack check.
//::	This way, a missed disintegrate still alerts the target.
// ChazM 8/9/07 Trolls can now be disentegrated.
//:: AFW-OEI 08/23/2007: Strip trolls of their inability to be slain except by acid/fire if
//:: 	it does more damage than the troll has HP.

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ginc_event_handlers"

void main()
{

    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }



    //Declare major variables
    object oCaster  = OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();
    //effect eVis     = EffectVisualEffect(VFX_IMP_HARM);	//VFX_IMP_HARM	// NWN1 VFX
    effect eBeam    = EffectBeam( VFX_BEAM_TRANSMUTATION, oCaster, BODY_NODE_HAND );	// NWN2 VFX
    int nCasterLvl  = GetCasterLevel(OBJECT_SELF);
	int nDamage;
	int nSave		= 0;
	int nDice;
	int nMeta		= GetMetaMagicFeat();
	

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
		 
		int nTouch      = TouchAttackRanged(oTarget, TRUE);
	    if (nTouch != TOUCH_ATTACK_RESULT_MISS) 
	    {

            if ( !MyResistSpell( oCaster, oTarget ))
            {
                // - oCreature
                // - nDC: Difficulty check
                // - nSaveType: SAVING_THROW_TYPE_*
                // - oSaveVersus
                // Returns: 0 if the saving throw roll failed
                // Returns: 1 if the saving throw roll succeeded
                // Returns: 2 if the target was immune to the save type specified

                nSave = FortitudeSave( oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster ); // SAVING_THROW_TYPE_DEATH?

                if ( nSave == 0 ) // Saving Throw failed
                {
                    nDice = nCasterLvl * 2; // BCH 03/10/06 - changed to caster level * 2, to reflect
												//	script comment that damage is 2d6 per caster level
				
                    if ( nDice > 40 ) nDice = 40;	// AFW-OEI 06/06/2007: Cap before doubling for crits.
					
                }
                else if ( nSave == 1 ) // Saving Throw succeeded
                {
					nDice = 5;
                 }
                else if ( nSave == 2 )  // Target is immune
                {
                	return; 
				 // Nothing? pop up some text, maybe?
                }
					//PKM-OEI: 05.28.07: Do critical hit damage
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{
						nDice = nDice*2;
					}
				
				//if maximized 6 * ndice
				if (nMeta == METAMAGIC_MAXIMIZE)
				{
					nDamage = 6 * nDice;
				}
				else if (nMeta == METAMAGIC_EMPOWER)
				{
					nDamage = d6( nDice );
					nDamage = nDamage + nDamage / 2;
				}
				else
				{
					nDamage = d6( nDice );
				}
				
				// If we should damage the target, apply it now
                if ( nDamage > 0 )
                {
					// AFW-OEI 08/23/2007: If we're potentially doing enough damage to drop the creature, remove any troll immunities.
					string sEventHandler = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED);
					if ( (nDamage >= GetCurrentHitPoints(oTarget)) && sEventHandler == "gb_troll_dmg")
					{
					    SetEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED, SCRIPT_DEFAULT_DAMAGE);
 						SetImmortal(oTarget, FALSE);
					}
					
					effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL), oTarget);	
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
					int nHP = GetCurrentHitPoints( oTarget );
					
					if (nHP <= 0  )
					{
					    // If they are at or below 0 hit points, disintegrate them!
						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisintegrate( oTarget ), oTarget);
					}
					else if (sEventHandler == "gb_troll_dmg")
					{	// AFW-OEI 08/23/2007: Still alive and had the troll on-damage script, so put that stuff back on.
					    SetEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED, "gb_troll_dmg");
 						SetImmortal(oTarget, TRUE);
					}
                }
				
				//ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
            }
        }
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
    } //else ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7 );
}
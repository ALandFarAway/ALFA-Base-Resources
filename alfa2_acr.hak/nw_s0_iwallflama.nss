//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Wall of Perilous Flame     ON ENTER
//:: nw_s0_iwallflama.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Wall of Perilous Flame
        Complete Arcane, pg. 136
        Spell Level:	5
        Class: 		    Misc

        The warlock can conjure a wall of fire (4th level wizard spell). 
        It behaves identically to the wizard spell, except half of the damage 
        is considered magical energy and fire resistance won't affect it.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

    //Declare major variables
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
    int nCasterLvl = GetCasterLevel(oCreator);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    
    //Declare and assign personal impact visual effect.
    effect eVisFire = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eVisMagic = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);

    // Fire damage effects will be applied this long after the magic damage
    float fFireDelay = 1.0f;

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
    //Make SR check, and appropriate saving throw(s).
    if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
    {
        //Roll damage.
        nDamage = d6(2);

        if ( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
        {
            nDamage *= 2;
        }
        int nFireDamage = nDamage / 2;
        int nMagicDamage = nDamage - nFireDamage;

        // Magic damage is just applied regardless of resistance
        eDam = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);
        effect eDam2 = EffectDamage(nMagicDamage, DAMAGE_TYPE_MAGICAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisMagic, oTarget, 1.0);

        // Fire damage gets a saving throw
        if(nFireDamage > 0)
        {
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);
            DelayCommand( fFireDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
            DelayCommand( fFireDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisFire, oTarget, 1.0) );
        }

    }
}
//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Curse of Despair
//:: nw_s0_icharm.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.4	Curse of Despair
        Complete Arcane, pg. 132
        Spell Level:	4
        Class: 		Misc

        This is the equivalent to the Bestow Curse spell (4th level wizard). 
        But even if the target makes their save, 
        they still suffer a -1 penalty to hit for 10 rounds.

*/
// RPGplayer1 02/04/2009: Made SpellCastAt event pass proper caster, so that caster drops invisibility as he should


#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{
    if (!ACR_PrecastEvent())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }



	int 	nMod 	= 3; // Default mod is 3, a successful save reduces it to 1 
    object	oTarget = GetSpellTargetObject();
	effect	eCurse;

    float fDuration = 0.0f;
    int nDurType = DURATION_TYPE_PERMANENT;

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BESTOW_CURSE));
         
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will Save
            if ( MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()) )
            {
                nMod = 1;
				eCurse	=	EffectAttackDecrease(nMod);
                fDuration = RoundsToSeconds(10);
                nDurType = DURATION_TYPE_TEMPORARY;
            }
			
			else
			{
            	eCurse   = EffectCurse(nMod, nMod, nMod, nMod, nMod, nMod);
			}
		    
			effect eVis     = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
			//Make sure that curse is of type supernatural not magical
		    eCurse = SupernaturalEffect(eCurse);

            //Apply Effect and VFX
            ApplyEffectToObject(nDurType, eCurse, oTarget, fDuration);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}
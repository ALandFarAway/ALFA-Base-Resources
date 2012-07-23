//::///////////////////////////////////////////////
//:: Shadow Darkness: On Enter
//:: acr_S0_Shadow_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications -  evenflw edited to stop AI lockups

#include "x0_i0_spells"

#include "x2_inc_spellhook"
#include "acr_spells_i"

void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);//EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    //effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    // effect eLink = EffectLinkEffects(eDark, eDur);
	SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(GetAreaOfEffectCreator()), 1);
    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    object oTarget = GetEnteringObject();

    // * July 2003: If has darkness then do not put it on it again
    /*if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }*/

    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
        // Creatures immune to the darkness spell are not affected.
        if ( ResistSpell(OBJECT_SELF,oTarget) != 2)
        {
			if(!GetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget)))
			{
				if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
				{
            		//Fire cast spell at event for the specified target
            		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				}
				else
				{
					SetLocalInt(OBJECT_SELF, "ACR_SHADOW_BELIEVE_" + ObjectToString(oTarget), 1);
				}
			}
        }
    }
    /*else if (oTarget == GetAreaOfEffectCreator())
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetEffectSpellId(eLink), FALSE));
        // Creatures immune to the darkness spell are not affected.
        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
        {
            //Fire cast spell at event for the specified target
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        }
    }*/
}
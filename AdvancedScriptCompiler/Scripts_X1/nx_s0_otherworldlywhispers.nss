//::///////////////////////////////////////////////
//:: Otherworldly Whispers
//:: [nx_s0_otherworldlywhispers]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Invocation Level: Least
//:: Spell Level Equivalent: 2
//::
//:: You hear whispers in your ears, revealing secrets
//:: of the multiverse.  You gain a +6 bonus on all lore
//:: and spellcraft checks for 24 hours.
//:://////////////////////////////////////////////
//:: Created By: ??
//:: Created On: ??
//:://////////////////////////////////////////////



#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	
    //Declare major variables
	object oCaster = OBJECT_SELF;
	
    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
 	float fDuration = 60.0*60.0*24.0;  // 24 hours
						
	//Enter Metamagic conditions
 	int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
	{
		fDuration = fDuration + (fDuration / 2.0);
	}
	
    effect eLore = EffectSkillIncrease(SKILL_LORE, 6);
	effect eSpellCraft = EffectSkillIncrease(SKILL_SPELLCRAFT, 6);
    effect eLink = EffectLinkEffects(eLore, eSpellCraft);

	//effect eVis = EffectVisualEffect(VFX_DUR_CONE_SONIC);	// replace with whisper effect
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, 1.5f);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}
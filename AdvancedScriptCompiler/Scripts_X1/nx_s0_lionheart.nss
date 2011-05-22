//::///////////////////////////////////////////////
//:: lionheart
//:: NX_s0_lionheart.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Lionheart
	Abjuration [Mind-Affecting]
	Level: Paladin 1
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration: 1 round/level
	 
	The subject gains immunity to fear effects.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.22.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

#include "nw_i0_spells" 
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
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
    object oTarget = GetSpellTargetObject();
    effect eFear	=	EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_LIONHEART );
	effect eLink;

    int nBonus = 3; //Saving throw bonus to be applied
    float fDuration = RoundsToSeconds(GetCasterLevel(OBJECT_SELF)); 

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE)); //replace with proper cast at event when the 2da is updated

    //Check for metamagic extend
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //link vis and immunity
	eLink = EffectLinkEffects( eFear, eVis );

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);

}
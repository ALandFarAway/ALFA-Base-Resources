//::///////////////////////////////////////////////
//:: Potion of Lore
//:: NW_S0_PLore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Gives the user a +4 bonus to lore for 5 minutes.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 26, 2006
//:://////////////////////////////////////////////


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
    int nBonus = 4;
    effect eLore = EffectSkillIncrease( SKILL_LORE, nBonus );
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_IDENTIFY );
    effect eLink = EffectLinkEffects( eLore, eDur );



    if(!GetHasSpellEffect( 983, oTarget ) || !GetHasSpellEffect( SPELL_LEGEND_LORE, oTarget ))
    {
         SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, 983 , FALSE));
         ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( 50 ));
    }
}
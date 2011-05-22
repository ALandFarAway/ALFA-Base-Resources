//::///////////////////////////////////////////////
//:: Rage
//:: NW_S0_Rage
//:://////////////////////////////////////////////
/*
    Gives Barbarian Rage effect to targets, but
    without the associated negative effects.
    Note that this is the Wizard spell Rage.
    The Str and Con of the target increases +2,
    Will Saves are +2, AC -2.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////


#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "X0_I0_SPELLS"
#include "ginc_henchman"


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
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
	
    effect eStr = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
    effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 1);
    effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
    effect eLink = EffectLinkEffects(eCon, eStr);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    //Make effect extraordinary
    eLink = ExtraordinaryEffect(eLink);

    {
		location lTarget = GetLocation( oTarget );
        object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
	
        // First, affect Caster...
        while ( GetIsObjectValid(oAlly) )
        {
			if (spellsIsTarget ( oAlly, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
			{ 
		   		RemoveEffectsFromSpell(oAlly, SPELL_RAGE);
	        	PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oAlly);

            	//Fire cast spell at event for the specified target
            	SignalEvent(oAlly, EventSpellCastAt(OBJECT_SELF, SPELL_RAGE, FALSE));

            	// Apply effects to the currently selected target.
            	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAlly, RoundsToSeconds (nDuration));
			}
			
			oAlly = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget );
        }
    }
}
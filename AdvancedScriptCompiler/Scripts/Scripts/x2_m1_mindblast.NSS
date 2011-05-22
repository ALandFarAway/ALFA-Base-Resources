//::///////////////////////////////////////////////
//:: Cone: Mindflayer Mind Blast
//:: x2_m1_mindblast
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Anyone caught in the cone must make a
    Will save (DC 17) or be stunned for 3d4 rounds.
	
	Update: Now does 3d6 magic damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:: Modified By: Jeff Husges
//:://////////////////////////////////////////////

#include "x2_i0_spells"

void main()
{
	int nSaveDC			= 14 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	object oTarget		= GetSpellTargetObject();
	effect eConeBlast	= EffectNWN2SpecialEffectFile("fx_mindflayer_cone");
	
	int nStunDuration;	
	int nDamageAmount;
	float fDelay;
	
	location lTargetLocation = GetSpellTargetLocation();
	effect eStun		= EffectStunned();
	effect eHit			= EffectNWN2SpecialEffectFile("sp_sonic_hit");
	effect eDamageHit	= EffectNWN2SpecialEffectFile("sp_magic_hit");
	effect eVis			= EffectNWN2SpecialEffectFile("fx_stun");
	effect eMindblast	= EffectLinkEffects(eStun, eVis);
	effect eDamage;

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConeBlast, OBJECT_SELF, 2.0f);
	
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0f, lTargetLocation, TRUE);

    while(GetIsObjectValid(oTarget))
    {
        int nApp = GetAppearanceType(oTarget);
        int bImmune = FALSE;
        //----------------------------------------------------------------------
        // Hack to make mind flayers immune to their psionic attacks...
        //----------------------------------------------------------------------
        if (nApp == 413 ||nApp== 414 || nApp == 415)
        {
            bImmune = TRUE;
        }

        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF && !bImmune )
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			
			nStunDuration	= d4(3);
			nDamageAmount	= d6(3);
			eDamage			= EffectDamage(nDamageAmount);
			eDamage			= EffectLinkEffects(eDamage, eDamageHit);
			
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
			
            // already stunned
            if (!GetHasSpellEffect(GetSpellId(), oTarget) && WillSave(oTarget, nSaveDC)==SAVING_THROW_CHECK_FAILED)
            {
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMindblast, oTarget, RoundsToSeconds(nStunDuration)));
			}
		}
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0f, lTargetLocation, TRUE);
    }
}

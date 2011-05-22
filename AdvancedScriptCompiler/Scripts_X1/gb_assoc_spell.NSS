//::///////////////////////////////////////////////
//:: Henchmen: On Spell Cast At
//:: gb_assoc_spell
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This determines if the spell just cast at the
    target is harmful or not.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 6, 2001
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "hench_i0_ai"

void main()
{
    object oCaster = GetLastSpellCaster();
	int nSpellID = GetLastSpell();
	// if dying (but not dead), any healing will help me recover
	if ( GetIsHenchmanDying() 
		&& GetIsHealingRelatedSpell(nSpellID))
	{
		SetLocalInt( OBJECT_SELF, "X0_L_WAS_HEALED", 10 );
		WrapCommandable( TRUE, OBJECT_SELF );
		DoRespawn( oCaster, OBJECT_SELF );
	}
    if(GetLastSpellHarmful())
    {
        SetCommandable(TRUE);
        // * GZ Oct 3, 2003
        // * Really, the engine should handle this, but hey, this world is not perfect...
        // * If I was hurt by my master or the creature hurting me has
        // * the same master
        // * Then clear any hostile feelings I have against them
        // * After all, we're all just trying to do our job here
        // * if we singe some eyebrow hair, oh well.
        if (GetFactionEqual(oCaster))
        {
            ClearPersonalReputation(oCaster, OBJECT_SELF);
        }
        else
        {
    		CheckRemoveStealth();
            if (!GetAssociateState(NW_ASC_MODE_PUPPET) &&
             !GetIsObjectValid(GetAttackTarget()) &&
             !GetIsObjectValid(GetAttemptedSpellTarget()) &&
             !GetIsObjectValid(GetAttemptedAttackTarget()) &&
             !GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN)) &&
             !GetIsFriend(oCaster))
            {
                SetCommandable(TRUE);
                HenchDetermineCombatRound(oCaster);
            }
        }
    }
    // Send the user-defined event as appropriate
    if(GetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_SPELL_CAST_AT));
    }
}
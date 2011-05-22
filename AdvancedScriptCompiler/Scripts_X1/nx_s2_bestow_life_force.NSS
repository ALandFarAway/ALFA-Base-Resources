// nx_s2_bestow_life_force
/*
    Spirit Eater Bestow Life Force Feat
    
Bestow Life Force
Limitations: Friendly targets only, cannot be in last stage of affliction.
Alignment: Good; Bestow Life Force shifts alignment 2 points towards Good.
The player can choose to heal his companions using the spirit energy he’s stored up. This power will 
fully heal all companions. Its cost in spirit energy is calculated by taking the sum total of the 
companions’ current hit points and dividing that by their summed max hit points. That resulting number 
is in turn subtracted from 100. That percentage becomes the amount towards the next stage of affliction 
the player will advance toward as a result of casting. The governing idea of the formula is this: if 
the party is not very hurt, Bestow Life Force shouldn’t cost much, but if the whole party is critically 
wounded, the player’s affliction should advance a full stage. That advancement is not capped once the next 
stage is reached, so if he is 50% of the way to stage 1, and he casts this for a full heal, he will end up 
50% of the way towards stage 2.
Bestow Life Force also reduces corruption, because it is more or less the inverse of spirit-eating. The 
amount reduced is equal to the percentage calculated above divided by 5. So potentially the player can 
reduce corruption by a maximum of 20% with one use of this ability, depending on how much spirit energy 
he invests.
    
*/
// ChazM 2/23/07
// ChazM 4/6/07 - updated impact on corruption and spirit energy
// ChazM 4/12/07 VFX/string update

#include "kinc_spirit_eater"
#include "x2_inc_spellhook"


void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    object oCaster 	= OBJECT_SELF;

    // can't be used in last stage
 	if (GetSpiritEaterStage() >= SPIRIT_EATER_STAGE_5 )
	{
        PostFeedbackStrRef(OBJECT_SELF, STR_REF_TOO_WEAK);
		//PrettyDebug("You are to weak to use this power.");
   		return;
    }
	
	// Visual effect on caster
    effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_BESTOW_LIFE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
	
    // alignment shift: good, 2 point
    AdjustAlignment(OBJECT_SELF, ALIGNMENT_GOOD, 2);

    DoBestowLifeForce();
 }
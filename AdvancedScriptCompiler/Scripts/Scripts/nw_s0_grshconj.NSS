//::///////////////////////////////////////////////
//:: Level 7 Arcane Spell: Greater Shadow Conjuration
//:: nw_s0_grshconj.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/19/05
//:://////////////////////////////////////////////
/*
	Greater Shadow Conjuration
	
	
    If the opponent is clicked on Shadow Bolt is cast.
    If the caster clicks on himself he will cast Stoneskin and Mirror Image.  
    If they click on the ground they will summon a Shadow Lord.

*/
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//::	Update creature blueprints.
//::	Change summon duration from hours to 3 + CL rounds.
//:://////////////////////////////////////////////
//:: BDF-OEI 9/11/2006:
//::	THIS SCRIPT IS DEPRECATED AND IS NO LONGER IN USE!

// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "nw_i0_spells"
#include "x2_inc_spellhook" 


const int CONTEXT_SELF 		= 1;
const int CONTEXT_TARGET 	= 2;
const int CONTEXT_GROUND	= 3;

void HandleCastOnSelf( object oSelf, int nDurType, float nDuration );
void HandleCastOnTarget( object oTarget, int nDurType, float fDuration );
void HandleCastOnGround( location lTarget, int nDurType, float fDuration );

void main()
{
    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLevel); // Duration is 1 hr per level of the caster
    fDuration = ApplyMetamagicDurationMods(fDuration);

	float fSummonDuration = RoundsToSeconds(nCasterLevel + 3); // Summon duration is 3 + caster level rounds.
	fSummonDuration = ApplyMetamagicDurationMods(fSummonDuration);

    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	object oTarget = GetSpellTargetObject();
    int nCast = CONTEXT_GROUND;
    if (GetIsObjectValid(oTarget))
    {
        if (oTarget == OBJECT_SELF)
        {
            nCast = CONTEXT_SELF;
        }
        else
        {
            nCast = CONTEXT_TARGET;
        }
    }
    else
    {
        nCast = CONTEXT_GROUND;
    }
    
    switch (nCast)
    {
        case CONTEXT_SELF:			HandleCastOnSelf( oTarget, nDurType, fDuration );							break;
		case CONTEXT_TARGET:		HandleCastOnTarget( oTarget, nDurType, fDuration );							break;
		case CONTEXT_GROUND:		HandleCastOnGround( GetSpellTargetLocation(), nDurType, fSummonDuration );	break;
    }

}


///////////////////////////////////////////////////////////////////////////////
// HandleCastOnSelf
// 	Get Stoneskin and Mirror Image effects
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnSelf( object oSelf, int nDurType, float fDuration )
{
    //Fire cast spell at event for the specified target
    SignalEvent(oSelf, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	int nACBonus = (2 + ( nCasterLvl / 3 )) / 5;
    int nImages = (d4( 1 + ( nCasterLvl / 3 ))) / 5;
	//This determines how long to wait between spawning the images. 
	float fSpin = ( 1.5 / nImages );
	float fDelay = ( 0.0 );
	string sImg = ("sp_mirror_image_1.sef");
	effect eVis 	= EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
	//effect eStone 	= EffectDamageReduction( 1, DAMAGE_POWER_PLUS_FIVE, FloatToInt( fDuration ) * 10);	// 3.0 DR rules
	effect eStone 	= EffectDamageReduction( 2, GMATERIAL_METAL_ADAMANTINE, FloatToInt( fDuration ) * 10, DR_TYPE_GMATERIAL );		// 3.5 DR approximation
	effect eLink 	= EffectLinkEffects(eStone, eVis);
	
    nImages = ApplyMetamagicVariableMods(nImages, 4);
    nImages += nCasterLvl;
    
	//Max out Images at 8
	if( nImages > 8 )  
	{ 
		nImages = 8; 
	}
	
	nImages /= 5;
	
	ApplyEffectToObject(nDurType, eLink, OBJECT_SELF, fDuration);
	
	int i;
    for ( i = 0; i < nImages; i++ )
    {
        effect eAbsorb = EffectAbsorbDamage(nACBonus);
        effect eDur = EffectVisualEffect(876);
		effect eImg = EffectNWN2SpecialEffectFile( sImg, OBJECT_SELF );
        effect eLink2 = EffectLinkEffects(eAbsorb, eDur);
		eLink2 = EffectLinkEffects(eLink2, eImg);

        //Apply the VFX impact and effects
        DelayCommand( fDelay, ApplyEffectToObject(nDurType, eLink2, oSelf, fDuration) );
		fDelay += fSpin;		
    }
}


///////////////////////////////////////////////////////////////////////////////
// HandleCastOnTarget
// 	Fire a "shadow bolt" at the target
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnTarget( object oTarget, int nDurType, float fDuration )
{
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	effect eBeam = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);

	float fDelay = 0.0f; // Used to put pauses between damage events

	if ( !ResistSpell(OBJECT_SELF, oTarget) )
	{
	    int nDamage;
	    int nBolts = GetCasterLevel(OBJECT_SELF)/5;
	    int nCnt;
	    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	    
	    for (nCnt = 0; nCnt < nBolts; nCnt++)
	    {
	        int nDam = d6(4);
			nDam = ApplyMetamagicVariableMods( nDam, 4*6 ); //Enter Metamagic conditions
	        
			fDelay = (nCnt * 0.5f) + 0.5f; // half second delay between each damage event

	        if (ReflexSave(oTarget, GetSpellSaveDC()))
	        {
	            nDamage = nDamage/2;
	        }
	        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
	        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	    }
	}
	fDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, fDelay);
}


///////////////////////////////////////////////////////////////////////////////
// HandleCastOnTarget
// 	Summon up a nasty dire bear
///////////////////////////////////////////////////////////////////////////////
void HandleCastOnGround( location lTarget, int nDurType, float fDuration )
{
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
	int nCasterLevel = GetCasterLevel(OBJECT_SELF);
	effect eSummon = EffectSummonCreature("c_shadow9", VFX_HIT_SPELL_SUMMON_CREATURE);
	ApplyEffectAtLocation(nDurType, eSummon, GetSpellTargetLocation(), fDuration);
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}
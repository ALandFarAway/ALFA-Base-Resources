//::///////////////////////////////////////////////
//:: Mirror Image
//:: NW_S0_MirrorImg.nss
//:://////////////////////////////////////////////
/*
    Caster gains 1d4 + 1/Level Images (max 8) that
    block damage from you on a chance AC 10 + Dex mod.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 26, 2005
//:://////////////////////////////////////////////
//:: PKM-OEI 08.14.06:VFX and functionality revision 



// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "ginc_debug"
#include "nw_i0_spells"


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

	// Prevent stacking
	int nID = GetSpellId();
	if ( GetHasSpellEffect(nID) )
	{
		effect eEffect = GetFirstEffect( OBJECT_SELF );
		while ( GetIsEffectValid(eEffect) )
		{
			if ( GetEffectSpellId(eEffect) == nID )
			{
				RemoveEffect( OBJECT_SELF, eEffect );
			}
			
			eEffect = GetNextEffect( OBJECT_SELF );
		}
	}

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
	float fDuration = TurnsToSeconds(nCasterLvl);	

	//Cap out caster level at 15 for purposes of AC bonus
	if (nCasterLvl > 15)
	{
		nCasterLvl = 15;
	}
	//Define AC bonus
	int nACBonus = (2 + ( nCasterLvl / 3 ));
	
	//Determine how many images will be created
    int nImages = d4( 1 ) + ( nCasterLvl / 3 );
	
    //int nACTest = 10 + GetAbilityModifier(ABILITY_DEXTERITY);

	
    //Enter Metamagic conditions
    nImages = ApplyMetamagicVariableMods(nImages, 4 + (nCasterLvl / 3));
    //nImages += nCasterLvl;
    
	//Max out Images at 8
	if( nImages > 8 )  
	{ 
		nImages = 8; 
	}
	//Metamagic duration & duration type
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	//This determines how long to wait between spawning the images. 
	float fSpin = ( 1.5 / nImages );
	float fDelay = ( 0.0 );
	string sImg = ("sp_mirror_image_1.sef");

    int i;
    for ( i = 0; i < nImages; i++ )
    {
        effect eAbsorb = EffectAbsorbDamage(nACBonus);
        effect eDur = EffectVisualEffect(876);
//        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID); //Don't need this.
		effect eImg = EffectNWN2SpecialEffectFile( sImg, OBJECT_SELF );
        effect eLink = EffectLinkEffects(eAbsorb, eDur);
		eLink = EffectLinkEffects(eLink, eImg);
        effect eOnDispell = EffectOnDispel(0.0f, RemoveEffectsFromSpell(oTarget, SPELL_MIRROR_IMAGE));
        eLink = EffectLinkEffects(eLink, eOnDispell);

        //Apply the VFX impact and effects
//        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand( fDelay, ApplyEffectToObject(nDurType, eLink, oTarget, fDuration) );
		fDelay += fSpin;		
    }
	
	
}
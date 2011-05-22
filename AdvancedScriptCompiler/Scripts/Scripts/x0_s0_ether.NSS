//::///////////////////////////////////////////////
//:: Etherealness
//:: x0_s0_ether.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Like sanctuary except almost always guaranteed
    to work.
    Lasts one turn per level.

	AFW-OEI 05/30/2006:
	Actually etherealness works exactly like
	sanctuary, but never fails.

	Also, it affects yourself and one ally / 3
	caster levels within 10'.  D&D rules say
	"touch" but that's a bit restrictive for NWN2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// NWN1 VFX
    int    nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int    nMaxTargets = 1 + nCasterLevel/3;
	float  fDuration = TurnsToSeconds(nCasterLevel);
 
	   //Enter Metamagic conditions
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
    	fDuration = fDuration *2; //Duration is +100%
    }
	
 	int nTargets = 0;
	object oTarget = GetFirstFactionMember( OBJECT_SELF, FALSE );
    while (GetIsObjectValid(oTarget) &&
		   nTargets < nMaxTargets)
	{
		float fDist = GetDistanceBetween( OBJECT_SELF, oTarget ); // returns 0.0 if they're in different areas

		if ( ( fDist > 0.0 && fDist < 3.3f ) ||		// Is the party member close enough to feel the effects?
			 ( OBJECT_SELF == oTarget ) )				// Or it's the caster himself
		{
			float fDelay = 0.25 * fDist;
			
			DelayCommand( fDelay, SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREALNESS, FALSE) ) );
			//DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );	// NWN1 VFX

		    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
		    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );	// NWN2 VFX
		    effect eSanc = EffectEthereal();
		    effect eLink = EffectLinkEffects(eDur, eSanc);

			DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration ) );

			nTargets++;
		}

		oTarget = GetNextFactionMember( OBJECT_SELF, FALSE );
	}
}

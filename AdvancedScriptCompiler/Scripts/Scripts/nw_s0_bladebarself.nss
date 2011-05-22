//::///////////////////////////////////////////////
//:: Blade Barrier, Self
//:: NW_S0_BladeBarSelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a curtain of blades 10m in diameter around the caster
	that hack and slice anything moving into it.  Anything 
	caught in the blades takes 2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality
//:: PKM-OEI 08.31.06 - Stacking rules
//:: RPGplayer1 03.19.08 - Linked AOE with Cutscene Immobilize

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

	//We need to make sure that this AOE isn't stackable, because it is super powerful
	//First we need to generate the string that serves as the object ID for this AOE object
	object oCaster = OBJECT_SELF;
	string sSelf = ObjectToString(oCaster) + IntToString(GetSpellId());
	//Now we need to see if anything with this tag already exists
	object oSelf = GetNearestObjectByTag(sSelf);
	//If it exists, kill it.
	if (GetIsObjectValid(oSelf))
	{
		DestroyObject(oSelf);
	}

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect( 57, "", "", "", sSelf );
	effect eHold = EffectCutsceneImmobilize();
    //location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF)/2;
    int nMetaMagic = GetMetaMagicFeat();

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }

    eAOE = EffectLinkEffects(eAOE, eHold);

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, OBJECT_SELF, RoundsToSeconds(nDuration));
}
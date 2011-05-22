//::///////////////////////////////////////////////
//:: Blade Barrier, Wall
//:: NW_S0_BladeBarWall.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality
//:: PKM-OEI 08.31.06 - Stacking rules

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
	string sWall = ObjectToString(oCaster) + IntToString(GetSpellId());
	//Now we need to see if anything with this tag already exists
	object oWall = GetNearestObjectByTag(sWall);
	//If it exists, kill it.
	if (GetIsObjectValid(oWall))
	{
		DestroyObject(oWall);
	}


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLBLADE, "", "", "", sWall );
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
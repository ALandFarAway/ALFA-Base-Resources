//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a conduit from the caster
    to the elemental planes.  The first elemental
    summoned is a 24 HD Air elemental.  Whenever an
    elemental dies it is replaced by the next
    elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001
//:: AFW-OEI 05/31/2006:
//::	Update to new creature blueprints.
//::	Change duration from 24 hours to CL minutes.

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
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    float fDuration = GetCasterLevel(OBJECT_SELF) * 60.0f;	// 1 minute/caster level
    //nDuration = 24;
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
    //Check for metamagic duration
    if (nMetaMagic == METAMAGIC_EXTEND)
 	{
		fDuration = fDuration * 2;	//Duration is +100%
	}
    //Set the summoning effect
    eSummon = EffectSwarm(FALSE, "c_elmairgreater", "c_elmearthgreater","c_elmwatergreater","c_elmfiregreater");
    //Apply the summon effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, fDuration);
}
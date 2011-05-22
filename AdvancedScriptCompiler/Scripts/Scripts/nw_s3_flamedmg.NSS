//::///////////////////////////////////////////////
//:: OnHit Firedamage 2
//:: nw_s3_flamedmg
//:://////////////////////////////////////////////
/*

   OnHit Castspell Fire Damage property for the
   flaming weapon spell (x2_s0_flmeweap).

   We need to use this property because we can not
   add random elemental damage to a weapon in any
   other way and implementation should be as close
   as possible to the book.

   3.5 -- This one ignores caster level

*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 26, 2005
//:://////////////////////////////////////////////




void main()
{
	//SpawnScriptDebugger();
	// Get Caster Level
	int nLevel = GetCasterLevel(OBJECT_SELF);
	// Assume minimum caster level if variable is not found
	if (nLevel== 0)
	{
	   nLevel =1;
	}
	
	int nDmg = d6();	// JLR - OEI 07/26/05
	
	effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_FIRE);
	effect eVis;
	if (nDmg<10) // if we are doing below 10 point of damage, use small flame
	{
		eVis =EffectVisualEffect(VFX_IMP_FLAME_S);
	}
	else
	{
	     eVis =EffectVisualEffect(VFX_IMP_FLAME_M);
	}
	eDmg = EffectLinkEffects (eVis, eDmg);
	object oTarget = GetSpellTargetObject();
	
	if (GetIsObjectValid(oTarget))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
	}
}
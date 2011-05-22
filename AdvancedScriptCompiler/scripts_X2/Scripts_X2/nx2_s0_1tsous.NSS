//	nx2_s0_1tsous
/*
	Initial effect of ts'ous poison: 4d4 points of damage.
*/
//	JSH-OEI 03/27/08

void main()
{
	object oTarget	= OBJECT_SELF;
	int nDamage		= d4(4);
	effect eDamage	= EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	effect eVisual	= EffectNWN2SpecialEffectFile("sp_noxious_hit");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
}
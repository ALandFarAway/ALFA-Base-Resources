//	nx2_s0_2tsous
/*
	Secondary effect of ts'ous poison: 2d4 points of damage.
*/
//	JSH-OEI 03/27/08

void main()
{
	object oTarget	= OBJECT_SELF;
	int nDamage		= d4(2);
	effect eDamage	= EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	effect eVisual	= EffectNWN2SpecialEffectFile("sp_noxious_hit");
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, OBJECT_SELF);
}
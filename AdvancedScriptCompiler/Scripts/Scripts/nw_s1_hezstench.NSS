//::///////////////////////////////////////////////
//:: Hezrou Stench
//:: NW_S1_HezStench.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    A hezrous skin produces a foul-smelling, 
	toxic liquid whenever it fights. Any living creature 
	(except other demons) within 10 feet must succeed on a DC 24 Fortitude 
	save or be nauseated for as long as it remains within the affected area 
	and for 1d4 rounds afterward. Creatures that successfully save are 
	sickened for as long as they remain in the area. A creature that 
	successfully saves cannot be affected again by the same hezrous 
	stench for 24 hours. A delay poison or neutralize poison spell removes 
	either condition from one creature. Creatures that have immunity to poison 
	are unaffected, and creatures resistant to poison receive their 
	normal bonus on their saving throws. The save DC is Constitution-based.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////

void main()
{
    //Declare and apply the AOE
    effect eAOE = EffectAreaOfEffect( AOE_MOB_HEZROU_STENCH );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF );
}
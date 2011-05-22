//::///////////////////////////////////////////////
//:: Ghast Stench
//:: NW_S1_ghaststench.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
    The stink of death and corruption surrounding 
    these creatures is overwhelming. Living creatures 
    within 10 feet must succeed on a DC 15 Fortitude 
    save or be sickened for 1d6+4 minutes. A creature 
    that successfully saves cannot be affected again 
    by the same ghasts stench for 24 hours. A delay 
    poison or neutralize poison spell removes the effect 
    from a sickened creature. Creatures with immunity 
    to poison are unaffected, and creatures resistant 
    to poison receive their normal bonus on their 
    saving throws. The save DC is Charisma-based.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 24, 2006
//:://////////////////////////////////////////////

void main()
{
    //Declare and apply the AOE
    effect eAOE = EffectAreaOfEffect( AOE_MOB_GHAST_STENCH );
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF );
}
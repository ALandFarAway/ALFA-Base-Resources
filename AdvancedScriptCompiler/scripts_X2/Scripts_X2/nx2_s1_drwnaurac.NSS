//::///////////////////////////////////////////////
//:: Drowned Aura Heartbeat
//:: NX2_S1_drwnaurab.nss
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Nathaniel Chapman
//:: Created On: March 17, 2008
//:://////////////////////////////////////////////
//:: RPGplayer1 01/10/2009: Characters with Iron Body should be immune to this

#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
	object oTarget = GetFirstInPersistentObject();
	int nDamage;
	effect eDam;
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect( VFX_HIT_DROWN );
	
    while(GetIsObjectValid(oTarget))
	{
		if((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
          &&(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
          &&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL)
          &&!GetHasSpellEffect(SPELL_IRON_BODY, oTarget))
        {
			//Make a saving throw check
			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 14, SAVING_THROW_TYPE_NONE))
            {
				if(GetGameDifficulty() == GAME_DIFFICULTY_DIFFICULT)
                	nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.9);
				
				else if (GetGameDifficulty() == GAME_DIFFICULTY_CORE_RULES)
					nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.3);
                
				else
					nDamage = FloatToInt(GetCurrentHitPoints(oTarget) * 0.1);
				
				eDam = EffectDamage(nDamage);
				
				//Apply the VFX impact and effects for Nausea
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
            }
		}
		
		oTarget = GetNextInPersistentObject();
    }
}
void main()

{

object oDM = OBJECT_SELF;
object oNPC = GetLocalObject(oDM, "Object_Target");
int nSpell = GetLocalInt(oDM, "omega_cast_spell");
int nCache = GetLocalInt(oDM, "omega_cast_cache");
int nOmega_Target = GetLocalInt(oDM, "omega_cast_target");
int iTarget2 = GetLocalInt(oDM, "omega_secondary_target");
object oTarget2 = GetLocalObject(oDM, "oTarget2");
object oTarget;
location lTarget;


if(nCache == 0)
	{if(iTarget2 == 1)
		{SetLocalObject(oDM, "oTarget2", oNPC);
		 oTarget2 = GetLocalObject(oDM, "oTarget2");
		 SendMessageToPC(oDM, "Spell target cached = " + GetName(oTarget2));
	     return;
		 }
	}
	
		if(nOmega_Target == 8)
			{oTarget = oNPC;
			 }
		else if(nOmega_Target == 1)
			{oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNPC, 1);
			}
		else if(nOmega_Target == 2)
			{lTarget = GetLocation(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oNPC, 1));
			}
		else if(nOmega_Target == 3)
			{oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oNPC, 1);
			}
		else if(nOmega_Target == 4)
			{lTarget = GetLocation(GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oNPC, 1));
			}
		else if(nOmega_Target == 5)
			{lTarget = GetLocation(oNPC);
			}
		else if(nOmega_Target == 6)
			{oTarget = oTarget2;
			}
			
		else if(nOmega_Target == 7)
			{lTarget = GetLocation(oTarget);
			 }
		else if(nOmega_Target == 0)
			{SendMessageToPC(oDM, "You must pick a target.");
			}
			
if(nCache == 2)
   {int nCache_Count = 0;
	float fDelay;
	while(nOmega_Target != 0)
	   {if(nOmega_Target == 8)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtObject(nSpell, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		   }
		else if(nOmega_Target == 1)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtObject(nSpell, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		    }
		else if(nOmega_Target == 2)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtLocation(nSpell, lTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
			}
		else if(nOmega_Target == 3)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtObject(nSpell, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		   }
		else if(nOmega_Target == 4)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtLocation(nSpell, lTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
			}
		else if(nOmega_Target == 5)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtLocation(nSpell, lTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		   }
		else if(nOmega_Target == 6)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtObject(nSpell, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		   }
			
		else if(nOmega_Target == 7)
			{DelayCommand(fDelay, AssignCommand(oNPC, ActionCastSpellAtLocation(nSpell, lTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
			}
		
		
		nOmega_Target = GetLocalInt(oNPC, "Omega_Cache_Target_" + IntToString(nCache_Count));
	    nSpell = GetLocalInt(oNPC, "Omega_Cache_Spell_" + IntToString(nCache_Count));
 	    SetLocalInt(oNPC, "Omega_Cache_Target_" + IntToString(nCache_Count), 0);
		SetLocalInt(oNPC, "Omega_Cache_Spell_" + IntToString(nCache_Count), 999999999);
		fDelay = fDelay + 6.0;
		nCache_Count++;
		
		}
	SetLocalInt(oTarget, "nCache_Count", 0);
	SetLocalInt(oDM, "omega_cast_cache", 0);
    SetLocalInt(oDM, "omega_cast_target", 0);
    SetLocalInt(oDM, "omega_cast_spell", 999999999);
     	
	}
	
if(nCache == 1)
		{
		
		 int nCache_Count = GetLocalInt(oNPC, "nCache_Count");
		 SetLocalInt(oNPC, "Omega_Cache_Target_" + IntToString(nCache_Count), nOmega_Target);
		 SetLocalInt(oNPC, "Omega_Cache_Spell_" + IntToString(nCache_Count), nSpell);
		 nCache_Count++;
		 SetLocalInt(oNPC, "nCache_Count", nCache_Count);
		 
		}
	
effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE, FALSE);
effect eQuake = EffectVisualEffect(VFX_SPELL_HIT_EARTHQUAKE, FALSE);
effect eDebris = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM, FALSE);
		  		 
if(nCache == 3)
	{if(nSpell == 9999)
		{SetImmortal(oTarget, TRUE);
		 SetMovementRateFactor(oNPC, 0.0);
		 ChangeToStandardFaction(oNPC, STANDARD_FACTION_HOSTILE);
		 DelayCommand(1.0, AssignCommand(oTarget, ActionCastSpellAtObject(979, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, ClearAllActions(TRUE));
		 AssignCommand(oNPC, ActionCastSpellAtObject(122, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1));
		 AssignCommand(oNPC, DelayCommand(1.0, ClearAllActions(TRUE)));
		 DelayCommand(3.0, AssignCommand(oNPC, ActionCastSpellAtObject(61, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(4.0, ClearAllActions(TRUE)));
		 DelayCommand(4.0, AssignCommand(oTarget, ActionCastSpellAtObject(466, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oTarget, DelayCommand(5.0, ClearAllActions(TRUE)));
		 DelayCommand(5.0, AssignCommand(oNPC, ActionCastSpellAtObject(183, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(5.5, ClearAllActions(TRUE)));
		 DelayCommand(6.0, AssignCommand(oNPC, ActionCastSpellAtObject(89, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(6.5, ClearAllActions(TRUE)));
		 DelayCommand(7.0, AssignCommand(oTarget, ActionCastSpellAtObject(76, oNPC, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oTarget, DelayCommand(8.0, ClearAllActions(TRUE)));
		 DelayCommand(10.0, AssignCommand(oNPC, ActionCastSpellAtObject(485, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 DelayCommand(11.0, ChangeToStandardFaction(oNPC, STANDARD_FACTION_COMMONER));
		 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0);
		 effect eStone = EffectVisualEffect(VFX_DUR_SPELL_STONESKIN);
		 effect eStatue = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
	     DelayCommand(10.0, SetImmortal(oTarget, FALSE));
	 	 DelayCommand(10.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStatue, oTarget));
    	 DelayCommand(10.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStone, oTarget));
    	 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(9.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(9.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(13.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(13.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(16.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(16.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(19.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(19.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(23.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(23.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(26.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(26.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 DelayCommand(29.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
		 DelayCommand(29.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuake, oTarget, 5.0));
		 }	 
		 
	if(nSpell == 10001)
		{AssignCommand(oNPC, ClearAllActions(TRUE));
		 AssignCommand(oNPC, ActionCastSpellAtObject(114, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1));
		 AssignCommand(oNPC, DelayCommand(1.0, ClearAllActions(TRUE)));
		 DelayCommand(5.0, AssignCommand(oNPC, ActionCastSpellAtObject(104, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(6.0, ClearAllActions(TRUE)));
		 DelayCommand(10.0, AssignCommand(oNPC, ActionCastSpellAtObject(6, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(11.0, ClearAllActions(TRUE)));
		 DelayCommand(15.0, AssignCommand(oNPC, ActionCastSpellAtObject(133, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(11.0, ClearAllActions(TRUE)));
		 }
	
	if(nSpell == 10002)
		{AssignCommand(oNPC, ClearAllActions(TRUE));
		 AssignCommand(oNPC, ActionCastSpellAtObject(852, oNPC, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1));
		 AssignCommand(oNPC, DelayCommand(1.0, ClearAllActions(TRUE)));
		 DelayCommand(5.0, AssignCommand(oNPC, ActionCastSpellAtObject(41, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(6.0, ClearAllActions(TRUE)));
		 DelayCommand(9.0, ChangeToStandardFaction(oNPC, STANDARD_FACTION_HOSTILE));
		 DelayCommand(10.0, AssignCommand(oNPC, ActionCastSpellAtObject(107, oTarget, -1, 1, 0, PROJECTILE_PATH_TYPE_DEFAULT, 1)));
		 AssignCommand(oNPC, DelayCommand(11.0, ClearAllActions(TRUE)));
		 }
		 
	 
	//if(nSpell == 10003)
	//	{DelayCommand(8.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(10.0, SendMessageToAllDMs("Epic Hellball"));
	//	 DelayCommand(10.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(636, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(11.0, SendMessageToAllDMs("Grenade Holy"));
	//	 DelayCommand(11.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(466, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(11.0, SendMessageToAllDMs("Storm of Vengeance"));
	//	 DelayCommand(11.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(173, oNPC,  PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(11.0, SendMessageToAllDMs("Ice Storm"));
	//	 DelayCommand(11.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(368, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebris, oTarget, 5.0));
	//	 DelayCommand(12.0, SendMessageToAllDMs("Greater Fireburst"));
	//	 DelayCommand(12.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(869, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(12.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(13.0, SendMessageToAllDMs("Greater Fireburst"));
	//	 DelayCommand(13.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(869, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(14.0, SendMessageToAllDMs("Greater Fireburst"));
	//	 DelayCommand(14.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(869, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(14.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(15.0, SendMessageToAllDMs("Horrid Wilting"));
	//	 DelayCommand(15.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(367, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(20.0, SendMessageToAllDMs("Greater Fireburst"));
	//	 DelayCommand(20.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(869, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(21.0, SendMessageToAllDMs("Horrid Wilting"));
	//	 DelayCommand(21.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(367, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(25.0, SendMessageToAllDMs("Greater Fireburst"));
	//	 DelayCommand(25.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(869, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(25.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(26.0, SendMessageToAllDMs("Horrid Wilting"));
	//	 DelayCommand(26.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(367, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(27.0, SendMessageToAllDMs("Wail of Banshee"));
	//	 DelayCommand(27.0, AssignCommand(oNPC, ActionCastFakeSpellAtObject(190, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(27.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(28.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebris, oTarget, 5.0));
	//	 DelayCommand(30.0, SendMessageToAllDMs("Wail of Banshee"));
	//	 DelayCommand(30.0, AssignCommand(oNPC, ActionCastSpellAtObject(190, oNPC, PROJECTILE_PATH_TYPE_DEFAULT)));
	//	 DelayCommand(30.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oTarget, 5.0));
	//	 DelayCommand(30.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebris, oTarget, 5.0));
	//	 DelayCommand(32.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebris, oTarget, 5.0));
	//	 }
		   
		 	 	 
	SetLocalInt(oTarget, "nCache_Count", 0);
	SetLocalInt(oDM, "omega_cast_cache", 0);
    SetLocalInt(oDM, "omega_cast_target", 0);
    SetLocalInt(oDM, "omega_cast_spell", 999999999);
     
	}
	
	
	      	
	 






}		
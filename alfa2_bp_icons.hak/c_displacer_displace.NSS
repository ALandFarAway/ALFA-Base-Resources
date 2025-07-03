//::///////////////////////////////////////////////
//:: Displacer Beast : displace ( combat end event )
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

void main()
{
  if(GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL))
  {
    DetermineSpecialBehavior();
  }
  else if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
  {
    DetermineCombatRound();
  }
 
  if(GetIsInCombat())
  {
    if (d100()<30)
	{
  		object oPC=GetLastAttacker();
		object oTarget=GetFactionWeakestMember(oPC);
		location lLoca = GetLocation( oTarget);
		
		//**--------------------------------
		int angle = Random(180);
		int rand = Random(1);
		if (rand == 1 ) {angle=angle*-1;}
		float dist= 2.0f;
		location new_loc=GenerateNewLocationFromLocation(lLoca,dist,IntToFloat(angle),1.0f);
		location loc_respawn=CalcSafeLocation(OBJECT_SELF,new_loc,5.0f,FALSE,FALSE);
		vector vFace=GetPosition(oPC);

		//**--------------------------------
		//** ajouter effet
		//**--------------------------------
		effect oeffect=EffectNWN2SpecialEffectFile("displacer_displace.sef");
		ApplyEffectToObject(DURATION_TYPE_INSTANT,oeffect,OBJECT_SELF);
		ClearAllActions(TRUE);
		AssignCommand( OBJECT_SELF ,DelayCommand(0.5,ActionJumpToLocation(loc_respawn) ) );
		DelayCommand(0.6,SetFacingPoint(vFace) );
		AssignCommand( OBJECT_SELF ,DelayCommand(0.7,ActionAttack(oPC) ) );
	}
	
	}
}
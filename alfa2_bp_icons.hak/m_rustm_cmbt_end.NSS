//::///////////////////////////////////////////////
//:: Rust Monster Antennae Attack
//:://////////////////////////////////////////////
/*
    Handles antennae attack and rusting functions
    if attack hits.  Also calls the end of combat
    script every round.
*/
//:://////////////////////////////////////////////
//:: Based on End of Round Combat Script by Preston Watamaniuk
//:: Modified by LordEmil (July-30-2002) to include rust monster abilities
//:: Modified by El Magnifico Uno (Sept-11-2002) to enhance an already great script
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

// this will check to see if the object is metal
// or is partly metal - Returns 0 if no metal,
// 1 if part metal, 2 if mostly metal
// type 16 is armor and needs an extra check
int IsItemMetal(object oItem)
{
  int nReturnVal=0;
  int type=GetBaseItemType(oItem);
  if((type<6)||type==9||type==10||type==12||type==13||type==17||type==18
     ||type==22||type==27||type==32||type==33||type==35||type==37||type==28
     ||type==40||type==41||type==42||type==47||type==51||type==52||type==53
     ||type==57||type==59||type==60||type==63||type==65||type==76)
  {
    nReturnVal=2;// Mostly metal
  }
  if(type==7||type==7||type==19||type==20||type==21||type==28||type==31
     ||type==44||type==45||type==46||type==56||type==62||type==78
     ||type==25||type==55||type==58)
  {
    nReturnVal=1;// Part metal
  }
  if(type==BASE_ITEM_ARMOR)// see what kind of armor
  {
    int ac=GetItemACValue (oItem);
    int limit=3;
    if(GetItemHasItemProperty(oItem,ITEM_PROPERTY_AC_BONUS))limit=5;
    if(ac>limit)
    {
      nReturnVal=2;// mostly metal
    }
  }
  return nReturnVal;
}

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
  // do rust attack against attakee
  if(GetIsInCombat())
  {
    string sItem;
    object oItem;
    int nItemSlot;
    int isMetal;
    object oPC=GetAttackTarget();
    if(oPC==OBJECT_INVALID)oPC=GetAttemptedAttackTarget();

    if (GetDistanceToObject(oPC) < 2.5)
    {
      for(nItemSlot=0;nItemSlot<13;nItemSlot++)
      {
        oItem=GetItemInSlot(nItemSlot,oPC);
        isMetal=IsItemMetal(oItem);
        if(isMetal!=0)break;// found a target
      }
      // El Magnifico Uno - Added TouchAttack
      if(nItemSlot<13 && (TouchAttackMelee(oPC)>0))// we got one
      {
        sItem=GetName(oItem);
        SendMessageToPC(oPC,"The Rust Monster's antennae brush against your "+sItem );
        // El Magnifico Uno - Changed save mechanism
        // to a straight Reflex Save per 3e rules.
        // Normally only get a save for magical items.
        // But was lazy and didn't want to list 60+
        // instances of GetItemHasProperty.
        if(ReflexSave(oPC,20))// saved
        {
          SendMessageToPC(oPC,"But the "+sItem+" resists the rust effects!");
        }else //didn't save
        {
          SendMessageToPC(oPC,"And destroys your "+sItem+"!");
          DestroyObject(oItem);
          //El Magnifico Uno - Changed Effect
          // ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_ACID_L),oPC);
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID),GetLocation(oPC));
        }
      }
    }
  }
  if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
  {
    SignalEvent(OBJECT_SELF, EventUserDefined(1003));
  }
}


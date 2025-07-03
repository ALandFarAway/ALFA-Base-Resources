//::///////////////////////////////////////////////
//:: Rust Monster Search & Eat script
//:: (OnUserDefined)
//:://////////////////////////////////////////////
/*
    Rust Monster will wander around and eat dropped
    metal objects.
*/
//:://////////////////////////////////////////////
//:: Created By: El Magnifico Uno
//:: Created On: September 11, 2002
//:://////////////////////////////////////////////

int HasMetalItem(object oItem)
{
  switch (GetBaseItemType(oItem))
  {
    case BASE_ITEM_ARMOR: return TRUE; break;
    case BASE_ITEM_HELMET: return TRUE; break;
    case BASE_ITEM_LARGESHIELD: return TRUE; break;
    case BASE_ITEM_SMALLSHIELD: return TRUE; break;
    case BASE_ITEM_TOWERSHIELD: return TRUE; break;

    case BASE_ITEM_BASTARDSWORD: return TRUE; break;
    case BASE_ITEM_BATTLEAXE: return TRUE; break;
    case BASE_ITEM_DIREMACE: return TRUE; break;
    case BASE_ITEM_DOUBLEAXE: return TRUE; break;
    case BASE_ITEM_GREATAXE: return TRUE; break;
    case BASE_ITEM_GREATSWORD: return TRUE; break;
    case BASE_ITEM_HALBERD: return TRUE; break;
    case BASE_ITEM_HEAVYCROSSBOW: return TRUE; break;
    case BASE_ITEM_HEAVYFLAIL: return TRUE; break;
    case BASE_ITEM_KAMA: return TRUE; break;
    case BASE_ITEM_KATANA: return TRUE; break;
    case BASE_ITEM_KUKRI: return TRUE; break;
    case BASE_ITEM_LIGHTFLAIL: return TRUE; break;
    case BASE_ITEM_LIGHTHAMMER: return TRUE; break;
    case BASE_ITEM_LIGHTMACE: return TRUE; break;
    case BASE_ITEM_LONGSWORD: return TRUE; break;
    case BASE_ITEM_MORNINGSTAR: return TRUE; break;
    case BASE_ITEM_RAPIER: return TRUE; break;
    case BASE_ITEM_SCIMITAR: return TRUE; break;
    case BASE_ITEM_SCYTHE: return TRUE; break;
    case BASE_ITEM_SHORTSWORD: return TRUE; break;
    case BASE_ITEM_SHURIKEN: return TRUE; break;
    case BASE_ITEM_SICKLE: return TRUE; break;
    case BASE_ITEM_TWOBLADEDSWORD: return TRUE; break;
    case BASE_ITEM_WARHAMMER: return TRUE; break;
  }
  return FALSE;
}


//:://///////////////////////////////////////////////

int CarriesMetal(object oTarget)
{
  object oItem = GetFirstItemInInventory(oTarget);
  while (oItem != OBJECT_INVALID)
  {
    if (HasMetalItem(oItem))
    {
      return TRUE;
      break;
    }
    oItem = GetNextItemInInventory(oTarget);
  }
  return FALSE;
}

//::////////////////////////////////////////////////

int EquipMetal(object oTarget)
{
  int nSlot = 0;
  object oItem = GetItemInSlot(nSlot);
  while (nSlot <= 5)
  {
    if (HasMetalItem(oItem))
    {
      return TRUE;
      break;
    }
    nSlot++;
    oItem = GetItemInSlot(nSlot);
  }
  return FALSE;
}

//:://////////////////////////////////////////////

void AttackTarget(object oTarget)
{
  ClearAllActions();
  SetIsTemporaryEnemy(oTarget, OBJECT_SELF, TRUE, 60.0);
  ActionDoCommand(ActionAttack(oTarget));
}

//:://///////////////////////////////////////////

object NextTarget(int nNth)
{
  return GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, nNth);
}

//:://///////////////////////////////////////////

void main()
{

  ActionRandomWalk(); // Default is wander around a bit

  float fDetectRange = 25.0;
  object oItem = GetNearestObject(OBJECT_TYPE_ITEM);
  if (GetIsObjectValid(oItem))
  {
    float fDist = GetDistanceToObject(oItem);
    if (fDist < fDetectRange) // Can we detect garbage?
    {
      ClearAllActions();
      ActionMoveToObject(oItem,FALSE,1.0); // Move to item.
      if (HasMetalItem(oItem) && (GetDistanceToObject(oItem) < 1.5))
      {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID),GetLocation(oItem));
        DestroyObject(oItem);
      }
    }
  }

  object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1);
  if (oTarget != OBJECT_INVALID && !GetIsObjectValid(oItem)) // Search for walking food if there's nothing lying around
  { if (EquipMetal(oTarget) || CarriesMetal(oTarget)) {AttackTarget(oTarget);}

    else if (NextTarget(2) != OBJECT_INVALID)
    { oTarget = NextTarget(2);
      if (EquipMetal(oTarget) || CarriesMetal(oTarget)) {AttackTarget(oTarget);}

      else if (NextTarget(3) != OBJECT_INVALID)
      { oTarget = NextTarget(3);
        if (EquipMetal(oTarget) || CarriesMetal(oTarget)) {AttackTarget(oTarget);}

        else if (NextTarget(4) != OBJECT_INVALID)
        { oTarget = NextTarget(4);
          if (EquipMetal(oTarget) || CarriesMetal(oTarget)) {AttackTarget(oTarget);}

          else if (NextTarget(5) != OBJECT_INVALID)
          { oTarget = NextTarget(5);
            if (EquipMetal(oTarget) || CarriesMetal(oTarget)) {AttackTarget(oTarget);}
          }
        }
      }
    }
  }
}


